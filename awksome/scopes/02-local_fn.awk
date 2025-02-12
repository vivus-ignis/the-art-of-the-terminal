function local_variables_are_declared_as_fn_params(l) {
  l++
}

BEGIN {
  local_variables_are_declared_as_fn_params()
  print "l: " l
}
