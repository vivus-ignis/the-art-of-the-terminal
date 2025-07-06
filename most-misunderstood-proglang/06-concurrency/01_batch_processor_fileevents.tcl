#!/usr/bin/env tclsh

if {[llength $argv] < 1} {
    puts "Usage: $argv0 <fifo-name>"
    exit 1
}

set spinner_chars {- \\ | /}

set fifo_path [lindex $argv 0]

if { ![file exists $fifo_path] || [file type $fifo_path] ne "fifo" || ![file readable $fifo_path] } {
    puts "Error: Named pipe '$fifo_path' does not exist, is not a file or is not readable."
    exit 1
}

set fifo_chan [open $fifo_path {RDONLY NONBLOCK}]

proc update_spinner {spinner_chars spinner_index} {
    set next_char [lindex $spinner_chars $spinner_index]

    incr spinner_index
    if { $spinner_index >= [llength $spinner_chars] } {
        set spinner_index 0
    }

    puts -nonewline "\r\b$next_char"
    flush stdout

    after 100 [list update_spinner $spinner_chars $spinner_index]
}

proc process_fifo_line {fifo_chan} {
    if {[gets $fifo_chan line] != -1} {
        puts "\nReceived new command: $line"
        if {[catch {exec sh -c "$line 2>&1"} result]} {
            puts "\nError executing '$line': $result"
        } else {
            puts "\nOutput from '$line':\n$result"
        }
    }

    fileevent $fifo_chan readable [list process_fifo_line $fifo_chan]
}

update_spinner $spinner_chars 0

fileevent $fifo_chan readable [list process_fifo_line $fifo_chan]

vwait forever
