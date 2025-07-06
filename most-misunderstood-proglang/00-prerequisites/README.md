## Packages installation

```bash
sudo apt install tcl rlwrap
```

## Starting Tcl REPL

```bash
rlwrap -r -c tclsh
```

## Reading documentation

### Getting a list of all available Tcl commands

```bash
apropos -s 3tcl file | grep -v Tcl_
```

### Getting help for a particular command

```bash
man 3tcl fileevent
```

## Code linter for vim

```bash
wget https://master.dl.sourceforge.net/project/nagelfar/Rel_133/nagelfar133.linux.gz
gunzip nagelfar133.linux.gz
```
- put nagelfar binary somewhere to your $PATH
- vim config parameters if using ALE:

```vimscript
let g:ale_tcl_nagelfar_executable = 'nagelfar'
let g:ale_tcl_nagelfar_options = '-severity E'
```
