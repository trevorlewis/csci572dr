#!/usr/bin/env bash

# Licensed to the Apache Software Foundation (ASF) under one
# or more contributor license agreements.  See the NOTICE file
# distributed with this work for additional information
# regarding copyright ownership.  The ASF licenses this file
# to you under the Apache License, Version 2.0 (the
# "License"); you may not use this file except in compliance
# with the License.  You may obtain a copy of the License at
#
#   http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing,
# software distributed under the License is distributed on an
# "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
# KIND, either express or implied.  See the License for the
# specific language governing permissions and limitations
# under the License.

# download and extract plain text from Wikipedia database XML dump using WikiExtractor

# Usage:
#     download.sh [options]
# Options:
#     -l, --lang : languages file name
# Example:
#     download.sh -l=languages.txt

languages="./languages.txt"

for i in "$@"
do
case $i in
    -l=*|--lang=*)
    languages="${i#*=}"
    ;;
    *)
    # unknown option
    ;;
esac
done

while read lang; do
    if [ ! -f $lang".xml.bz2" ]; then
        wget "http://download.wikimedia.org/"$lang"wiki/latest/"$lang"wiki-latest-pages-articles.xml.bz2" -O $lang".xml.bz2"
    fi
    if [ ! -f $lang"-text.xml" ]; then
        bzcat $lang".xml.bz2" | ./WikiExtractor.py -cb 10M -o extracted - --no-templates
        find extracted -name '*bz2' -exec bunzip2 -c {} \; > $lang"-text.xml"
        rm -rf extracted
    fi
done < $languages
