BEGIN {
  foo::local_variable_in_namespaced_function()
  print "l: " l
  print "foo::l: " foo::l

  foo::global_variable_in_namespaced_function()
  print "k: " k
  print "foo::k: " foo::k
}

@namespace "foo"

function local_variable_in_namespaced_function(l) {
  l++
}

function global_variable_in_namespaced_function() {
  k++
}
