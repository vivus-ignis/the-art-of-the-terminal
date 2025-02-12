@load "time"

@include "./lib/log"
@include "./lib/cache"
@include "./lib/telegram"
@include "./lib/openai"
@include "./lib/helpers"

# Known issues:
# -------------
# * warning on time extension deprecation
#   in later gawk releases time extension should be un-deprecated, see https://github.com/xonixx/makesure/issues/118
# * no error handling (should try using 'curl -v' to get access to HTTP status code etc)

BEGIN {
  offset = 1

  while (1) {
    l::dlog("Updates offset: " offset)
    telegram::get_updates(offset)

    for (idx in telegram::result_arr) {
      if (telegram::result_arr[idx]["message"] !~ /^https?:\/\//) {
          l::dlog("Skipping non-URL message")
          offset = telegram::result_arr[idx]["update_id"] + 1
          continue
      }

      cached = cache::get(telegram::result_arr[idx]["message"])
      if (cached) {
        l::dlog("Using cached description")
        description = cached
      } else {
        page_dump = helpers::get_page_dump(telegram::result_arr[idx]["message"])
        description = openai::describe(page_dump)
        cache::set(telegram::result_arr[idx]["message"], description)
      }
      l::dlog("Description of " telegram::result_arr[idx]["message"] ": " description)

      success = telegram::reply(telegram::result_arr[idx]["chat_id"], description)
      if (success) {
        l::dlog("Reply sent, acknowledging message was processed...")
        offset = telegram::result_arr[idx]["update_id"] + 1
      }
    } # for telegram::result_arr

    sleep(5)
  } # while 1
}
