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

# format the plain text files generated using WikiExtractor
# by combining random 'n' lines of all the files into a single TSV file
# such that the first column contains the language of the article text
# the second column contains the article ID
# the third column contains the article URl
# the fourth column contains the article title
# the fifth column contains the article text

# Usage:
#     benchmark_format.sh [options]
# Options:
#     -l, --lang : languages file name
#     -f, --file : output file name
#     -n, --num : number of lines for each file
# Example:
#     benchmark_format.sh -l=languages.txt -f=benchmark_test.tsv -n=10000

languages="./languages.txt"
file="benchmark_test.tsv"
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
    infile=$lang"-text-format.xml"

    if [ ! -f $infile ]; then
        perl -pe 's/\n/ / if !($_ =~ m/<\/doc>/)' $lang"-text.xml" | sed 's/<doc id=\"//' | sed 's/\" url=\"/\t/' | sed 's/\" title=\"/\t/' | sed 's/\">\s*/\t/' | sed 's/\s*<\/doc>//' | sed 's/^/'$lang'\t/' > $infile
    fi

    array=()
    lc=$(wc -l < $infile)
    while [ ${#array[@]} -lt $num ]; do
        rnd=$RANDOM
        let "rnd %= $lc"
        if [[ " ${array[*]} " == *" $rnd "* ]]; then
            continue
        fi
        array+=($rnd)
    done
    sorted=$(echo ${array[@]} | tr ' ' '\n' | sort -nu | tr '\n' ' ')
    array=()
    for i in "${sorted[@]}"; do
        array+=($i)
    done
    i=0
    p=0
    while IFS=$'\t' read -r -a myArray; do
        if [ $i -eq ${array[$p]} ]; then
            printf "%s\t" "${myArray[@]}" >> $file
            printf "\n" >> $file
            ((p++))
            [ $p -eq ${#array[@]} ] && break
        fi
        ((i++))
    done < $infile

done < $languages
