interp create -safe safe0

safe0 eval {expr 2 + 2}
safe0 eval {open /etc/passwd}
safe0 eval {socket google.com 80}

safe0 eval {pwd}
safe0 alias pwd pwd
safe0 eval {pwd}

interp share {} stdout safe0  ;# sharing a file descriptor from the parent interp
safe0 eval {puts "Hello from safe0"}
set now [clock seconds]
safe0 limit time -seconds [expr $now + 20] -granularity 1
safe0 eval {puts "Hello from safe0"}
after 19  ;# sleep for 19 seconds
safe0 eval {puts "Hello from safe0"}
