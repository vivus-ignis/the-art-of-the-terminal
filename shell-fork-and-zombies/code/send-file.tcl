#!/usr/bin/expect

set source_file ""
set dest_dir ""

set REMOTE_LOGIN "root"
set REMOTE_PASSWORD "taoftt"
set PROMPT "#"  ;# one of: @, #

while {[llength $argv] > 0} {
    set opt [lindex $argv 0]
    switch -- $opt {
        -s {
            set source_file [lindex $argv 1]
            set argv [lrange $argv 2 end]
        }
        -d {
            set dest_dir [lindex $argv 1]
            set argv [lrange $argv 2 end]
        }
        default {
            puts stderr "Unknown option: $opt"
            exit 1
        }
    }
}

if {$source_file eq "" || $dest_dir eq ""} {
    puts stderr "Usage: send-file.tcl -s SOURCE_FILE -d DEST_DIR"
    exit 1
}

if {[string length [file tail $source_file]] > 8} {
    puts stderr "Filenames longer than 8 chars are not supported"
    exit 1
}

set fp [open $source_file r]
set file_contents [read $fp]
close $fp

set remote_file [file join $dest_dir [file tail $source_file]]

set timeout 10

spawn telnet localhost 5555

expect "login:"
send "$REMOTE_LOGIN\r"

# expect "Password:"
# send "$REMOTE_PASSWORD\r"

expect "$PROMPT "

send "ed $remote_file\r"
send "1,\$d\r"

# write every N lines to disk
# because otherwise file gets corrupted
set refresh 10

send "a\r"
foreach line [split $file_contents \n] {
    send "$line\r"
    incr refresh -1
    if { $refresh eq 0 } {
      send ".\r"
      send "w\r"
      expect -re {\d+\r}
      send "a\r"

      set refresh 20
    }
}

send ".\r"
send "w\r"
expect -re {\d+\r}

send "q\r"

# send Ctrl+] (telnet escape) and then "q" to disconnect
expect "$PROMPT "
send "\x1D"
expect "telnet> "
send "quit\r"

expect eof
