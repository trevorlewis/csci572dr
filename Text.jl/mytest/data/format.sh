#!/usr/bin/env bash

# preprocess the plain text files generated using WikiExtractor
# by combining random 'n' lines of all the files into a single TSV file
# such that the first column contains the language of the text in the second column

file="test.tsv"
num=1000
for i in "$@"
do
case $i in
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
    lc=$(wc -l < $infile)
    for n in `seq 1 $num`; do
        # get a random number between 1 and $lc
        rnd=$RANDOM
        let "rnd %= $lc"
        ((rnd++))
        # traverse file and find line number $rnd
        i=0
        while read -r line; do
         ((i++))
         [ $i -eq $rnd ] && break
        done < $infile
        # output random line
        echo $line >> $file
    done
done < list.txt
