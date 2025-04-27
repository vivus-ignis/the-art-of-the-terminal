include(/usr/share/doc/m4/examples/foreach.m4)dnl
<html>
  <head>
    <title>M4 List Example</title>
  </head>
  <body>
    <h2>List Of Unix Gurus</h2>
define(`GURUS', `(Dennis Ritchie, Brian Kernighan, Eric Allman)')dnl
    <ul>
foreach(`guru', GURUS,
`      <li>guru</li>
')dnl
    </ul>
  </body>
</html>
