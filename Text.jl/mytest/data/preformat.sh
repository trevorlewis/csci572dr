#!/bin/sh

while read line; do
	tr '\n' ' ' < $line"-text.xml" > $line"-text.tmp"
	sed 's/<\/doc> /<\/doc>\n/g' $line"-text.tmp" > $line"-text-format.xml"
	rm $line"-text.tmp"
done < list.txt
