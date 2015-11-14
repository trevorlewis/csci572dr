#!/bin/sh

while read lang; do
	perl -pe 's/\n/ / if !($_ =~ m/<\/doc>/)' $lang"-text.xml" | sed 's/<doc id=\"//' | sed 's/\" url=\"/\t/' | sed 's/\" title=\"/\t/' | sed 's/\">\s*/\t/' | sed 's/\s*<\/doc>//' | sed 's/^/'$lang'\t/' > $lang"-text-format.xml"
done < list.txt
