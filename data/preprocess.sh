#!/bin/sh

# preprocess the plain text files generated using WikiExtractor
# by combining random 'n' lines of all the files into a single TSV file
# such that the first column contains the language of the text in the second column

file="text.tsv"
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

while read line; do
	perl -pe 's/<[^>]*>//g' $line"-text.xml" | sed '/^\s*$/d' | sed 's/^/'$line'\t/' > $line"-text.tmp"
	shuf -n $num $line"-text.tmp" >> $file
	rm -f $line"-text.tmp"
done < list.txt
