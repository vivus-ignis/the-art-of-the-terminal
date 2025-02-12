@namespace "openai"
@load "json"

BEGIN {
  chat_url = "https://api.openai.com/v1/chat/completions"
  prompt = "TLDR (no formatting, succinct): "
  token = ENVIRON["OPENAI_TOKEN"]
  http_client = "curl"
}

function describe(page_dump, \
                  request, tempfile, cmd, line, raw_result, parsed_result_arr) {
  request["model"] = "gpt-4o-mini"
  request["messages"][1]["role"] = "developer"
  request["messages"][1]["content"] = prompt
  request["messages"][2]["role"] = "user"
  request["messages"][2]["content"] = page_dump

  tempfile = helpers::to_json_and_tempfile(request)
  cmd = http_client " " chat_url \
         " -H 'Content-Type: application/json' -H 'Authorization: Bearer " token "'" \
         " -d @" tempfile
  l::dlog("Describe cmd: " cmd)

  while ((cmd | getline line) > 0) {
    raw_result = raw_result line
  }
  close(cmd)
  system("rm -f " tempfile)

  l::dlog("OpenAI API raw result: " raw_result)

  if (! json::from_json(raw_result, parsed_result_arr)) {
    l::error("Cannot parse OpenAI API response: " ERRNO)
    return
  }

  return parsed_result_arr["choices"][1]["message"]["content"]
}
