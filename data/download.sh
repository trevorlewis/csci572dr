#!/bin/sh

# download and extract plain text from Wikipedia database XML dump using WikiExtractor

while read line; do
	wget "http://download.wikimedia.org/"$line"wiki/latest/"$line"wiki-latest-pages-articles.xml.bz2"
	bzcat $line"wiki-latest-pages-articles.xml.bz2" | ./WikiExtractor.py -cb 10M -o extracted - --no-templates
	rm -f $line"wiki-latest-pages-articles.xml.bz2"
	find extracted -name '*bz2' -exec bunzip2 -c {} \; > $line"-text.xml"
	rm -rf extracted
	bzip2 $line"-text.xml"
done < list.txt
