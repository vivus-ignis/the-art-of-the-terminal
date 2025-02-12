@namespace "helpers"
@load "json"

BEGIN {
  terminal_browser = "lynx -dump -nonumbers"
}

function get_page_dump(url, \
                       cmd, line, page_dump) {
  cmd = terminal_browser " " url
  while ((cmd | getline line) > 0) {
    page_dump = page_dump line
  }
  close(cmd)

  gsub(/\n/, " ", page_dump)
  return page_dump
}

function to_json_and_tempfile(arr, \
                              tempfile) {
  tempfile = "/tmp/_bot_awk.request." PROCINFO["pid"] ".json"
  print json::to_json(arr, 1) > tempfile
  fflush(tempfile)
  close(tempfile)

  return tempfile
}
