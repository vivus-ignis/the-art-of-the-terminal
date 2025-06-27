#!/usr/bin/env tclsh

proc every {ms body} {
    eval $body
    after $ms [info level 0]
}

set filename "$env(HOME)/to_backup"
set remote_user "ignis"
set remote_host "molfar"
set remote_dir "__backups"

every 5000 {
    if {[file exists $::filename]} {
        set file_id [open $::filename r]
        while {[gets $file_id line] >= 0} {
            set filepath [string trim $line]

            if {$filepath ne ""} {
                puts "About to copy $filepath to $::remote_host"
                catch {exec /usr/bin/scp "$filepath" "${::remote_user}@${::remote_host}:${::remote_dir}/"}
            }
        }

        close $file_id

        puts "Truncating $::filename"
        set truncate_file_id [open $::filename w]
        close $truncate_file_id
    }
    puts "Waiting..."
}
vwait forever
