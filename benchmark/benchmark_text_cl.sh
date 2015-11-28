#!/usr/bin/env bash

file=$1 # first argument input file
url="http://localhost:8000"  # Text.jl LID HTTP Server's URL
delimiter=$'\t' # delimiter tab

while IFS=$delimiter read -ra line; do
	startTime=`date +%s%N`
	json=`echo ${line[4]} | curl -s -X PUT -d @- $url`
	endTime=`date +%s%N`

	result=$(echo $json| cut -d'"' -f 4)
	let duration=$endTime-$startTime
	echo "${line[1]}$delimiter${line[0]}$delimiter$result$delimiter$duration"
done < $file
