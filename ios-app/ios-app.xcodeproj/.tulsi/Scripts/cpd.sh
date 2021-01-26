#!/bin/bash
# Copyright 2016 The Tulsi Authors. All rights reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
#
# Bridge between Xcode and Bazel for the "clean" action.
#
# Usage: bazel_clean.sh <bazel_binary_path> <bazel_binary_output_path> <bazel startup options>
# Note that the ACTION environment variable is expected to be set to "clean".

set -eu

(
  set +x
  if [ -f tools/cpd.sh ]; then
    make cpd_dir SCAN_DIR=${3:-.} &> /dev/null
    cd out_cpd
    echo "
<?php
\$total = 0;
foreach (simplexml_load_file('result.xml')->duplication as \$duplication) {
    \$files = \$duplication->xpath('file');
    \$lines = \$duplication['lines'];
    \$total += intval(\$lines);
    foreach (\$files as \$file) {
        \$start_line = intval(\$file['line']) + 1;
        \$end_line = \$start_line + intval(\$duplication['lines']) - 1;
        \$output = \$file['path'].':'.\$start_line.':1: warning: [START] '.\$duplication['lines'].' copy-pasted lines from: '
            .implode(', ', array_map(function (\$otherFile) { return \$otherFile['path'].':'.\$otherFile['line']; },
            array_filter(\$files, function (\$f) use (&\$file) { return \$f != \$file; }))).PHP_EOL;
        \$output = \$output.\$file['path'].':'.\$end_line.':1: warning: [END] '.\$duplication['lines'].' copy-pasted lines from: '.implode(', ', array_map(function (\$otherFile) { return \$otherFile['path'].':'.\$otherFile['line']; },
            array_filter(\$files, function (\$f) use (&\$file) { return \$f != \$file; }))).PHP_EOL;
        echo \$output;
    }
}
echo 'warning: Total number of duplication: '.intval(\$total / 2).' lines'.PHP_EOL;
?>
" > parse_cpd_outout.php
    php parse_cpd_outout.php
  fi
)

