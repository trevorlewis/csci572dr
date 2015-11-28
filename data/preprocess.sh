#!/usr/bin/env bash

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
