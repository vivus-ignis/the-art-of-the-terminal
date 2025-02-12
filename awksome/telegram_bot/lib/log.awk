@namespace "l"

BEGIN {
  DEBUG = ENVIRON["DEBUG_LOG"]
}

function dlog(message) {
  if (DEBUG) print message
}

function error(message) {
  print "!!! " message > "/dev/stderr"
}
