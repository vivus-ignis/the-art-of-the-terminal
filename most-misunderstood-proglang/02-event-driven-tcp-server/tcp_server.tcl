#!/usr/bin/env tclsh

proc accept_connection {sock addr port} {
    puts "Accepted connection from $addr:$port"
    chan configure $sock -blocking 0 -buffering line
    chan event $sock readable [list handle_data $sock]
}

proc handle_data {sock} {
    if {[gets $sock line] >= 0} {
        set current_time [clock format [clock seconds] -format "%Y-%m-%d %H:%M:%S"]
        puts $sock "$current_time $line"
    } elseif {[eof $sock]} {
        close $sock
    }
}
socket -server accept_connection 12345
vwait forever
