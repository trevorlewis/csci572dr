#!/usr/bin/env bash

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
    array=()
    lc=$(wc -l < $infile)
    while [ ${#array[@]} -lt $num ]; do
        rnd=$RANDOM
        let "rnd %= $lc"
        if [[ " ${array[*]} " == *" $rnd "* ]]; then
			continue
		fi
		array+=($rnd)
    done
	sorted=$(echo ${array[@]} | tr ' ' '\n' | sort -nu | tr '\n' ' ')
    array=()
    for i in "${sorted[@]}"; do
		array+=($i)
	done
	i=0
	p=0
	while IFS=$'\t' read -r -a myArray; do
		if [ $i -eq ${array[$p]} ]; then
			printf "%s\t" "${myArray[@]}" >> $file
			printf "\n" >> $file
			((p++))
			[ $p -eq ${#array[@]} ] && break
		fi
		((i++))
	done < $infile

done < list.txt
