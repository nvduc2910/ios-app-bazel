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

readonly coverageFilterRegex="$1"; shift
readonly coverageIgnoreRegex="$1"; shift
readonly testTargetName="$1"; shift

(
  set -x  
  
  mkdir -p "$BUILT_PRODUCTS_DIR/html_coverage"
  find "$BUILT_PRODUCTS_DIR/../../ProfileData" -type f -name "Coverage.profdata" -exec cp -RLf {} "$BUILT_PRODUCTS_DIR/html_coverage/" \;
  if [ ! -f "$BUILT_PRODUCTS_DIR/html_coverage/Coverage.profdata" ]; then
      exit 0 
  fi
  COVERAGE_FILTER_REGEX="$coverageFilterRegex"
  NAME_REGEX=".*$TARGETNAME.*"
  if [[ "$COVERAGE_FILTER_REGEX" != "" ]]; then 
      NAME_REGEX="$COVERAGE_FILTER_REGEX"
  else
      echo "warning: Ignore generating HTML code coverage report because filter regex is empty."
      exit 0 
  fi
  xcrun llvm-cov show \
    -format=html \
    -instr-profile "$BUILT_PRODUCTS_DIR/html_coverage/Coverage.profdata" \
    "$BUILT_PRODUCTS_DIR/../__TulsiTestRunner_Debug-iphonesimulator/${testTargetName}.xctest/${testTargetName}" \
    -output-dir="$BUILT_PRODUCTS_DIR/html_coverage/report" \
    -ignore-filename-regex="$coverageIgnoreRegex" \
    -name-regex="$NAME_REGEX"
  
  sed -i '' "s/<h2>Coverage Report<\/h2>/<h2>Coverage Report ($TARGETNAME)<\/h2>/g" "$BUILT_PRODUCTS_DIR/html_coverage/report/index.html"
  open $BUILT_PRODUCTS_DIR/html_coverage/report/index.html
)

