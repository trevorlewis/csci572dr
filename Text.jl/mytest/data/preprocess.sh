#!/bin/sh

# preprocess the plain text files generated using WikiExtractor
# by combining random 'n' lines of all the files into a single TSV file
# such that the first column contains the language of the text in the second column

n=1000

rm -f "text.tsv"

while read line; do
	perl -pe 's/<[^>]*>//g' $line"-text.xml" | sed '/^\s*$/d' | sed 's/^/'$line'\t/' > $line"-text.tmp"
	shuf -n $n $line"-text.tmp" >> "text.tsv"
	rm -f $line"-text.tmp"
done < list.txt
