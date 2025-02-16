# Hidden Gem: A 50-Year-Old Data Processing Language That CAN!

## AWK history

- interviews
	- with Aho
		- https://a-z.readthedocs.io/en/latest/awk.html
		- https://www.youtube.com/watch?v=5Zsk5L225Zs
	- with Weinberger
		- https://ieeexplore.ieee.org/document/1514393
		- https://www.tuhs.org/Archive/Documentation/OralHistory/transcripts/weinberger.htm
	- with Kernighan
		- https://www.youtube.com/watch?v=W5kr7X7EG4o
		- https://www.youtube.com/watch?v=GNyQxXw_oMQ
- Bell Labs history
	- PJW face https://web.archive.org/web/20240327060455/http://spinroot.com/pico/pjw.html

## Awk implementations

- archive code, versions from 1979 until 2012: https://github.com/danfuzz/one-true-awk
- descendant of the original codebase, still being developed, now has CSV support: https://github.com/onetrueawk/awk
- embeddable awk https://github.com/hyung-hwan/hawk
- awk features comparison across implementations https://web.archive.org/web/20241015143427/http://awk.freeshell.org/AwkFeatureComparison
- comparing awk implementations compatibility in your browser https://megamansec.github.io/awk-compare/

## Oneliners

- good selection of awk oneliners http://tuxgraphics.org/~guido/scripts/awk-one-liner.html
- even more onliners https://www.pement.org/awk/awk1line.txt

## Tutorials & Learning materials

- interactive awk excercises for a terminal https://github.com/learnbyexample/TUI-apps/tree/main/AwkExercises
- Tutorial from IBM https://developer.ibm.com/tutorials/l-awk1/
- CLI Text Processing with AWK, online book: https://learnbyexample.github.io/learn_gnuawk/cover.html
- "The Book": AWK: The programming language book (from original authors, 2nd ed from 2024)
	- https://awk.dev/
	- https://archive.org/download/pdfy-MgN0H1joIoDVoIC7/The_AWK_Programming_Language.pdf
- awk guide https://github.com/adrianlarion/simple-awk
- awk tips, tricks and pitfalls https://catonmat.net/ten-awk-tips-tricks-and-pitfalls
- awk gotchas https://learnbyexample.github.io/learn_gnuawk/gotchas-and-tips.html
- Working with fixed-sized fields https://pmitev.github.io/to-awk-or-not/Other/Fixed_size_fields/
- doing math https://pmitev.github.io/to-awk-or-not/Case_studies/List/
- profiling with gawk https://github.com/freznicek/awk-crashcourse/blob/master/examples/profiling.md
- awesome awk https://github.com/freznicek/awesome-awk
- the now gone awk.info site, archived version https://web.archive.org/web/20150909015653/http://awk.info/?var/toc

## Reference info: Documentation

- mawk functions https://invisible-island.net/mawk/manpage/mawk.html#h3-8_-Built-in-functions
- gawk functions https://www.gnu.org/software/gawk/manual/html_node/Built_002din.html
- true and false https://www.gnu.org/software/gawk/manual/html_node/Truth-Values.html
- built-in variables in gawk https://www.gnu.org/software/gawk/manual/html_node/Built_002din-Variables.html
- built-in variables in mawk https://invisible-island.net/mawk/manpage/mawk.html#h3-7_-Builtin-variables
- gawk networking https://www.gnu.org/software/gawk/manual/gawk.html#Using-gawk-for-Network-Programming

## Gawk dynamic extensions

- gawkextlib https://gawkextlib.sourceforge.net/
- array functions, basename/dirname, math functions (repository looks unmaintained!) https://github.com/su8/gawk-extensions
- TLS extension, this makes https calls from awk theoretically possible (no documentation, code commented in Spanish) https://github.com/Qaracas/gawk-tls

## Dev tools

- awk language server (supported by nvim-lspconfig) https://github.com/Beaglefoot/awk-language-server/
- intellij plugin for awk https://github.com/xonixx/intellij-awk

## Libraries of awk code

- lots of string, math, sorting, csv, time/date functions https://github.com/e36freak/awk-libs
- colorizing terminal output https://pmitev.github.io/to-awk-or-not/Case_studies/colors/
- functional programming in awk (map/reduce & friends) https://web.archive.org/web/20150909081341/http://awk.info/?Funky

## Projects written in awk

- games
	- tetris https://github.com/mikkun/AWKTC
	- awkventure, roguelike terminal game https://github.com/jpelgrims/awkventure
	- awk raycasting demo https://github.com/TheMozg/awk-raycaster
- awk terminal graphical demo  https://github.com/patsie75/awk-demo
- static website generator https://github.com/clehner/mksite
- youtube video downloader https://catonmat.net/revisiting-gnu-awk-youtube-video-downloader
- numeric functions for shell written in awk https://github.com/numcommand/num/tree/master
- git re-implementation https://github.com/djanderson/aho
- commandline text translation https://github.com/soimort/translate-shell
- interesting take on make https://makesure.dev/
- JSON parser https://github.com/xonixx/gron.awk
- file manager https://github.com/huijunchen9260/fm.awk
- awk graphics library https://github.com/patsie75/awk-glib
- CLI tools testing framework https://github.com/xonixx/fhtagn
- nothing stops you from writing a lisp interpreter http://www.cs.cmu.edu/afs/cs/Web/Groups/AI/lang/lisp/impl/awk/0.html or a compiler http://cowlark.com/mercat/

## Interesting use cases

- bioawk
	- https://github.com/lh3/bioawk
	- bioawk basics explained: https://bioinformaticsworkbook.org/Appendix/Unix/bioawk-basics.html
- awk beats hadoop with a x235 speed improvement https://adamdrake.com/command-line-tools-can-be-235x-faster-than-your-hadoop-cluster.html
- awk can be used for messages processing in data streaming service RedPanda https://docs.redpanda.com/redpanda-connect/components/processors/awk/
- "Running Awk in parallel to process 256M records" https://ketancmaheshwari.github.io/posts/2020/05/24/SMC18-Data-Challenge-4.html
