function variables_are_global_by_default() {
  k++
}

BEGIN {
  variables_are_global_by_default()
  print "k: " k
}
