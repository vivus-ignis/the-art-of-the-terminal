#!/usr/bin/env tclsh

package require Thread

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

        set worker_thread_id [thread::create -joinable {
            proc run_task {cmd master_thread_id} {
                if {[catch {exec sh -c "$cmd 2>&1"} result]} {
                    thread::send -async $master_thread_id [list puts "\nError executing '$cmd': $result"]
                } else {
                    thread::send -async $master_thread_id [list puts "\nOutput from '$cmd':\n$result"]
                }
                thread::release
            }

            thread::wait ;# wait for commands from the main thread
        }]
        thread::send -async $worker_thread_id [list run_task $line [thread::id]]
        thread::wait ;# wait for commands from worker threads
     }

    fileevent $fifo_chan readable [list process_fifo_line $fifo_chan]
}

update_spinner $spinner_chars 0

fileevent $fifo_chan readable [list process_fifo_line $fifo_chan]

vwait forever
