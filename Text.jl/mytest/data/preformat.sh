#!/bin/sh

while read line; do
	perl -pe 's/\n/ / if $_ == /<\/doc>/' $line"-text.xml" > $line"-text-format.xml"
done < list.txt
