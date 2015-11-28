#!/usr/bin/env bash

javac -cp ".:tika-app-1.11.jar:json-simple-1.1.1.jar" Benchmark.java
java -cp ".:tika-app-1.11.jar:json-simple-1.1.1.jar" Benchmark ../data/test.tsv > result.tsv

./benchmark_text_cl.sh ../data/test.tsv > result2.tsv
