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

# preprocess the plain text files generated using WikiExtractor
# by combining random 'n' lines of all the files into a single TSV file
# such that the first column contains the language of the text in the second column

# Usage:
#     preprocess.sh [options]
# Options:
#     -l, --lang : languages file name
#     -f, --file : output file name
#     -n, --num : number of lines for each file
# Example:
#     preprocess.sh -l=languages.txt -f=text.tsv -n=10000

languages="./languages.txt"
file="text.tsv"
num=1000

for i in "$@"
do
case $i in
    -l=*|--lang=*)
    languages="${i#*=}"
    ;;
    -f=*|--file=*)
    file="${i#*=}"
    ;;
    -n=*|--num=*)
    num="${i#*=}"
    ;;
    *)
    # unknown option
    ;;
esac
done

rm -f $file

while read lang; do
    perl -pe 's/<[^>]*>//g' $lang"-text.xml" | sed '/^\s*$/d' | sed 's/^/'$lang'\t/' > $lang"-text.tmp"
    shuf -n $num $lang"-text.tmp" >> $file
    rm -f $lang"-text.tmp"
done < $languages
