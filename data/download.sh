#!/usr/bin/env bash

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
