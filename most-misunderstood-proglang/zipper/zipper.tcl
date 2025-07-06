#!/usr/bin/env tclsh

# packages lookup paths (vendor/ directory)
set WORKDIR [file normalize [file dirname [info script]]]
lappend auto_path [file join $WORKDIR vendor]
tcl::tm::path add [file join $WORKDIR vendor www]

# tcllib
package require logger
package require des
package require defer
package require json
# other packages
package require wapp 1.0 ;# minimal version constraint: require wapp version 1.0 or higher
package require vfs::zip
package require TclCurl

set LOG [logger::init zipper]
set SECRET_STRING OMdNnGgz ;# 8 bytes long for DES
set COMPRESSION_RATIO_THRESHOLD 8.9

set VIRUSTOTAL_UPLOAD_URL https://www.virustotal.com/api/v3/files
set VIRUSTOTAL_API_KEY $env(VIRUSTOTAL_API_KEY)

if {[info exists env(ZIPPER_LOGLEVEL)]} {
  logger::setlevel $env(ZIPPER_LOGLEVEL)
} else {
  logger::setlevel info
}

proc html-upload-form {} {
  wapp-trim {
    <form action="/upload" method="post" enctype="multipart/form-data">
      <label for="fileupload">Choose a file:</label>
      <input type="file" id="fileupload" name="fileupload">
      <input type="submit" value="Upload File">
    </form>
  }
}

proc html-header {} {
  wapp-content-security-policy off ;# this is needed to allow loading css from CDN

  wapp-trim {
    <html>
    <head>
      <title>Zipper</title>
      <link rel="stylesheet" href="https://unpkg.com/mvp.css">
    </head>
    <body>
      <header>
        <nav style="margin-bottom: 1rem;">
          <a href="/">Home</a>
        </nav>
        <h1>Upload your zip archive for great good</h1>
      </header>
      <main style="padding-top: 1rem; padding-bottom: 1rem;">
  }
}

proc html-footer {} {
  wapp-trim {
      </main>
      <footer><hr><p>&copy; The Art Of The Terminal</p></footer>
    </body>
    </html>
  }
}

proc html-warning {msg} {
  return "
    <section>
      <article>
        <aside>
          <mark><b>Warning:</b> $msg</mark>
        </aside>
      </article>
    </section> "
}

proc html-info {msg} {
  return "
    <section>
      <article>
        <aside>
          $msg
        </aside>
      </article>
    </section> "
}

proc list-as-table {l} {
  set result <table>
  foreach i $l {
    lappend result <tr>
    foreach j $i {
      lappend result <td>$j</td>
    }
    lappend result </tr>
  }
  lappend result </table>
  return [join $result ""]
}

proc encrypt {path} {
  upvar #0 SECRET_STRING secret

  # pad to 8 bytes (DES requirement)
  set pad_size [expr {8 - ([string length $path] % 8)}]
  set padded_path $path[string repeat $pad_size $pad_size]

  set base64_encoded [base64 -encode [DES::des -mode ecb -dir encrypt -key $secret $padded_path]]
  string map { "+" "-" "/" "_" "=" "." } $base64_encoded ;# making it url-safe
}

proc decrypt {path} {
  upvar #0 SECRET_STRING secret

  set base64_encoded [string map { "-" "+" "_" "/" "." "=" } $path]
  # set decrypted [DES::des -mode ecb -dir decrypt -key $secret [base64 -decode $base64_encoded]]]
  # ^^^ interesting bug: this will add ] to the end of the string with no warning on unmatched brackets
  set decrypted [DES::des -mode ecb -dir decrypt -key $secret [base64 -decode $base64_encoded]]
  set pad_char [string index $decrypted end]
  set pad_size $pad_char
  string range $decrypted 0 [expr {[string length $decrypted] - $pad_size - 1}]
}

proc base64 {direction input} {
  switch -- $direction {
    "-encode" {
      binary encode base64 $input
    }
    "-decode" {
      binary decode base64 $input
    }
  }
}

proc generate-encrypted-path {archive {directory ""}} {
  if {$directory == ""} {
    encrypt $archive
  } else {
    string cat [encrypt $archive] / [encrypt $directory]
  }
}

proc save-to-disk {name contents} {
  upvar #0 WORKDIR workdir

  set upload_dir [file join $workdir upload]
  file mkdir $upload_dir
  set name_on_disk [file join $upload_dir $name]
  set fd [open $name_on_disk wb] ;# b for binary mode
  defer::defer close $fd

  puts -nonewline $fd $contents

  return $name_on_disk
}

proc scan-virustotal {archive} {
  upvar #0 LOG log
  upvar #0 VIRUSTOTAL_UPLOAD_URL upload_url
  upvar #0 VIRUSTOTAL_API_KEY api_key

  set file_basename [file tail $archive]

  set curl [curl::init]
  defer::defer $curl cleanup

  $curl configure \
    -url $upload_url \
    -httpheader [list "x-apikey: $api_key" "accept: application/json"] \
    -post 1 \
    -httppost [list name "file" file $file_basename filename $file_basename filecontent $archive contenttype application/octet-stream] \
    -bodyvar response

  ${log}::debug "About to post archive $archive to virustotal"
  if {[catch {$curl perform} error]} {
    ${log}::error "Error during upload: [curl::easystrerror $error]"

    return "Archive upload to virustotal failed: [curl::easystrerror $error]"
  }

  set http_code [$curl getinfo responsecode]
  if {$http_code != 200} {
    ${log}::error "Virustotal request failed with HTTP code $http_code"
    ${log}::error "Response body was: $response"

    return "Virustotal request failed: $response"
  }

  ${log}::debug "Virustotal upload finished"
  ${log}::debug "Virustotal response HTTP code: [$curl getinfo responsecode]"
  ${log}::debug "Virustotal response: $response"
  set parsed_response [::json::json2dict $response]

  if {[catch {set analysis_url [dict get $parsed_response data links self]} error ]} {
    ${log}::error "No analysis url in virustotal response"

    return "No analysis url in virustotal response"
  }

  ${log}::debug "Analysis URL: $analysis_url"

  get-virustotal-analysis $analysis_url
}

proc get-virustotal-analysis {url} {
  upvar #0 LOG log
  upvar #0 VIRUSTOTAL_UPLOAD_URL upload_url
  upvar #0 VIRUSTOTAL_API_KEY api_key

  set curl [curl::init]
  defer::defer $curl cleanup

  $curl configure -url $url \
    -httpheader [list "x-apikey: $api_key" "accept: application/json"] \
    -bodyvar response

  ${log}::debug "About to request virustotal analysis"
  if {[catch {$curl perform} error]} {
    ${log}::error "Error getting virustotal analysis: [curl::easystrerror $error]"

    return "Error getting virustotal analysis: [curl::easystrerror $error]"
  }
  ${log}::debug "Virustotal analysis response: $response"
  set parsed_response [::json::json2dict $response]
  set status [dict get $parsed_response data attributes status]

  if {$status != "completed"} {
    after 10000
    return [get-virustotal-analysis $url]
  }

  set found_issues []
  dict for {k v} [dict get $parsed_response data attributes results] {
    if {[dict get $v result] != "null"} {
      lappend found_issues [list [dict get $v engine_name] [dict get $v result]]
    }
  }
  ${log}::debug "found_issues: $found_issues"
  if {[llength $found_issues] == 0} {
    return [html-info "No issues found"]
  }

  return "[html-warning "Malware detected"] [list-as-table $found_issues]"
}

proc list-archive-directory {archive {directory ""}} {
  upvar #0 LOG log

  if {[catch {vfs::zip::Mount $archive /archive} mount_handle options]} {
    set error_code [dict get $options -errorcode]
    set error_message [dict get $options -errorinfo]
    ${log}::error "Failed to list archive, error code: $error_code, error message: $error_message"
    return [html-warning "Failed to list archive. Too many files?"]
  }
  defer::defer vfs::zip::Unmount $mount_handle /archive

  set root_path [file join /archive $directory]
  set result <article><ul>
  foreach f [glob -directory $root_path *] {
    if {[file isdirectory $f]} {
      lappend result "<li><a href=/list/[generate-encrypted-path $archive $f]>[file tail $f]</a></li>"
    } else {
      lappend result "<li>[file tail $f]</li>"
    }
  }
  lappend result </ul></article>
  return [join $result ""]
}

proc check-compression-ratio {archive} {
  upvar #0 LOG log
  upvar #0 COMPRESSION_RATIO_THRESHOLD threshold

  set zip_stats [split [exec zipinfo -t $archive] ,]  ;# calling an external command
  # 11 files, 1073741824 bytes uncompressed, 1043771 bytes compressed:  99.9%
  set uncompressed [regexp -inline {[0-9]+} [lindex $zip_stats 1]]
  set compressed [regexp -inline {[0-9]+} [lindex $zip_stats 2]]
  set ratio [expr $uncompressed / $compressed]

  ${log}::debug "Compression ratio of $archive is 1:$ratio"
  if {$ratio > $threshold} {
    return [html-warning "Compression ratio is 1:$ratio, possibly a zip bomb"]
  }
  if {$ratio == 1} {
    return [html-warning "Compression ratio is 1:$ratio, looks suspicious"]
  }
  return [html-info "Compression ratio is 1:$ratio, looks ok"]
}

proc generate-breadcrumbs {archive {directory ""}} {
  set result <p>

  for {set i 1} {$i < [llength [split $directory /]]} {incr i} {
    set path [join [lrange [split $directory /] 0 $i] "/"]
    lappend result <a href=/list/[generate-encrypted-path $archive $path]>[file tail $path]</a>
  }
  lappend result </p>

  join $result /
}

proc wapp-page-upload {} {
  upvar #0 LOG log

  html-header

  set mimetype [wapp-param fileupload.mimetype {}]
  set filename [wapp-param fileupload.filename {}]
  set content [wapp-param fileupload.content {}]
  ${log}::debug "mimetype: $mimetype"
  ${log}::debug "filename: $filename"

  if { $filename == "" } {
    wapp-trim { [html-warning "No file uploaded"] }
    return
  }

  wapp-trim {
    <section>
      <aside>
        <h1>Uploaded File Content</h1>
        <p><b>Filename:</b> %html($filename)<br>
        <b>MIME-Type:</b> %html($mimetype)<br>
      </aside>
    </section>
  }

  if { $mimetype != "application/zip" } {
    wapp-trim { [html-warning "Unsupported file type"] }
    return
  }

  set name_on_disk [save-to-disk $filename $content]
  ${log}::debug "Saved uploaded contents to $name_on_disk"

  wapp-trim {
    [check-compression-ratio $name_on_disk]
  }

  wapp-trim {
    <section>
      <aside>
        <h3>Archive contents</h3>
        [list-archive-directory $name_on_disk]
      </aside>
      <aside>
        <h3>Scan archive with virustotal</h3>
        <p><a href="/scan/[generate-encrypted-path $name_on_disk]" target="_blank"><b>Scan archive</b></a></p>
      </aside>
    </section>
  }

  html-footer
}

proc wapp-default {} {
  switch -- [wapp-param PATH_HEAD] {
    "" {
      html-header
      html-upload-form
      html-footer
    }
    "list" {
      html-header

      set archive [decrypt [lindex [split [wapp-param PATH_TAIL] /] 0]]
      set path [decrypt [lindex [split [wapp-param PATH_TAIL] /] 1]]

      wapp-trim {
        [generate-breadcrumbs $archive $path]
        [list-archive-directory $archive $path]
      }

      html-footer
    }
    "scan" {
      html-header

      set archive [decrypt [lindex [split [wapp-param PATH_TAIL] /] 0]]

      wapp-trim "<p>Scanning $archive...</p>"
      # {} have no special meaning and can be replaced with "" where appropriate
      wapp-trim {
        [scan-virustotal $archive]
      }

      html-footer
    }
  }
}

if {$tcl_interactive == 0} { ;# like if __name__ == "__main__": in python
  wapp-start $argv
}
