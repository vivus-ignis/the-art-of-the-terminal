@namespace "telegram"
@load "json"

BEGIN {
  token = ENVIRON["TG_TOKEN"]
  base_url = "https://api.telegram.org/bot"
  http_client = "curl"
}

function get_updates(offset, \
                     cmd, line, raw_result, parsed_result_arr, idx) {
  l::dlog("Getting telegram messages with offset " offset)
  cmd = http_client " " base_url token "/getUpdates?offset=" offset
  while ((cmd | getline line) > 0) {
    raw_result = raw_result line
  }
  close(cmd)
  l::dlog("TG API raw result: " raw_result)

  if (! json::from_json(raw_result, parsed_result_arr)) {
    l::error("Cannot parse Telegram API response: " ERRNO)
    return
  }

  for (idx in result_arr) {
    delete result_arr[idx]
  }

  if (awk::isarray(parsed_result_arr["result"])) {
    for (idx in parsed_result_arr["result"]) {
      result_arr[idx]["message"] = parsed_result_arr["result"][idx]["message"]["text"]
      result_arr[idx]["chat_id"] = parsed_result_arr["result"][idx]["message"]["chat"]["id"]
      result_arr[idx]["update_id"] = parsed_result_arr["result"][idx]["update_id"]
    }
  }
}

function reply(chat_id, message, \
               request, tempfile, cmd, line, raw_result, parsed_result_arr) {
  request["chat_id"] = chat_id
  request["text"] = message

  tempfile = helpers::to_json_and_tempfile(request)

  cmd = http_client " " base_url token "/sendMessage" \
      " -H 'Content-Type: application/json'" \
      " -d @" tempfile
  l::dlog("Reply command: " cmd)

  while ((cmd | getline line) > 0) {
    raw_result = raw_result line
  }
  close(cmd)
  system("rm -f " tempfile)

  l::dlog("Telegram reply sent: " raw_result)

  if (! json::from_json(raw_result, parsed_result_arr)) {
    l::error("Cannot parse Telegram API response: " ERRNO)
    return 0
  }

  if (! parsed_result_arr["ok"]) {
    return 0
  }

  return 1
}
