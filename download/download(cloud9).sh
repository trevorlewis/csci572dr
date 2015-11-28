#!/bin/sh

# download and extract plain text from Wikipedia database XML dump using Cloud9 (a Hadoop toolkit)

export JAVA_HOME=/home/trevor/Applications/jdk1.8.0_60
export PATH=${PATH}:${JAVA_HOME}/bin
export PATH_TO_HADOOP=/home/trevor/Applications/hadoop-2.5.0-cdh5.3.0
export PATH=${PATH}:${PATH_TO_HADOOP}/bin

while read line; do
	wget "http://download.wikimedia.org/"$line"wiki/latest/"$line"wiki-latest-pages-articles.xml.bz2"
	hadoop jar ~/Applications/Cloud9-master/target/cloud9-2.0.2-SNAPSHOT-fatjar.jar edu.umd.cloud9.collection.wikipedia.DumpWikipediaToPlainText -input $line"wiki-latest-pages-articles.xml.bz2" -wiki_language $line -output $line
done < list.txt
