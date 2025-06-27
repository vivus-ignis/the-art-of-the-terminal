# ln --symbolic foo bar
file link -symbolic bar foo

# ln --symbolic 'VirtualBox VMs' vms
file link -symbolic vms {VirtualBox VMs}

# date +%s
# date -d @`date +%s`

clock seconds
clock format [clock seconds]

# echo $HOME
puts $env(HOME)

# echo "Tcl is the \"Tool Command Language\""
puts "Tcl is the \[Tool Command Language\]"
