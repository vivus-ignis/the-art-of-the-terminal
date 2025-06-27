## Tk example

- install Tk

```bash
sudo apt install tk
```

- start Tk REPL

```bash
wish
```

- create the test window

```tcl
button .my_button -text "Click Me" -command {puts "Button clicked"}
pack .my_button -pady 20
```

- try to click the button and check the output in the terminal where you started `wish`
