# Shell, fork and zombies: The Unix Code

## Sources & extra materials

- Bell Labs
    - Bell Labs memorial site https://memorial.bellsystem.com/belllabs.html
    - List of people who worked at Bell Labs Computer Science Research Center (Department 1127) https://www.spinroot.com/gerard/1127_alumni.html
    - By the way, if you watched Severance series, this Lumon Industries office is one of the former Bell Labs buildings: https://bell.works/severance-filming-locations/. But not the one where Ken Thompson worked.
- Multics
    - History of Multics https://multicians.org/history.html
    - Multics had a high level vision, but got bogged down in bureaucracy  https://multicians.org/devproc.html
    - Why multics failed https://www.usenix.org/system/files/login/articles/1070-multics.pdf
    - Backup feature of multics filesystem looks very much like an inspiration for AWS Glacier https://multicians.org/fjcc4.html
- Early Unix history
    - History Of Unix https://www.tuhs.org/Mirror/Hauben/unix.html
    - Unix: an oral history https://dspinellis.github.io/oral-history-of-unix/frs122/unixhist/finalhis.htm
    - Thompson: an oral history https://www.computerhistory.org/collections/catalog/102808980/
    - Unix Version 0, for PDP-7 https://github.com/DoctorWkt/pdp7-unix
    - Porting of "Space Travel"
        - https://en.wikipedia.org/wiki/Space_Travel_(video_game)
        - https://livinginternet.com/i/iw_unix_dev.htm
        - https://9p.io/who/dmr/spacetravel.html
        - https://wiki.tuhs.org/doku.php?id=systems%3Apdp7_unix
    - The Unix Room https://corecursive.com/brian-kernighan-unix-bell-labs1/#the-unix-room---2431---
    - Kernighan: Unix was designed for developers https://www.youtube.com/watch?v=v0ON23Y4W68
    - The evolution of the unix time-sharing system https://www.nokia.com/bell-labs/about/dennis-m-ritchie/hist.html
- Reconstructed early Unix version for emulators
    - Ancient versions of Unix https://github.com/felipenlunkes/run-ancient-unix
    - Unix V1 I worked on https://github.com/jserv/unix-v1.git

``bash
# debian trixie is required
sudo apt install -y libpcre3
make clean
make run
``

- /etc/passwd
    - Which passwords Ken Thompson used on early Unix systems? https://leahneukirchen.org/blog/archive/2019/10/ken-thompson-s-unix-password.html <-- mention this article in github announcement
    - /etc/passwd GECOS field https://www.redhat.com/en/blog/linux-gecos-demystified
- C
    - The development of C language https://www.nokia.com/bell-labs/about/dennis-m-ritchie/chist.html
    - The best description I've found on the version of C I'm using in the video https://9p.io/cm/cs/who/dmr/primevalC.html
- Formatting text in nroff https://www.youtube.com/watch?v=WCF5oSuMm9g
- Shell
    - How shell programming looked like in the 1970's PDF: "Using a Command Language as a High-Level Programming Language"
- TRIZ, the soviet inventors framework https://en.wikipedia.org/wiki/TRIZ
- Age verification tracker https://agelesslinux.org/distros.html

## Manuals for the earliest Unix versions

- [C Reference Manual, 1974](pdfs/c-reference-manual-1974.pdf)
- [Line editor ed, the tutorial by B.Kernighan](pdfs/ed-tutorial.pdf)
- [Unix Time Sharing System, documentation for Unix edition "zero"](pdfs/unix-time-sharing-system-unix-ed-zero.pdf)
- [Unix Programmers Manual, 1971](pdfs/unix-programmers-manual-november-1971.pdf)
- [Preliminary Unix Implementation, 1972](pdfs/preliminary-unix-implementation-june-1972.pdf)
- [Unix Time Sharing System](pdfs/unix-time-sharing-system-1974.pdf)
