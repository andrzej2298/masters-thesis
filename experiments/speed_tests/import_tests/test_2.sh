#!/usr/bin/env bash

for i in 1 $(seq 5 5 100)
do
    sed "s/LIBNUM/$i/g" template.jsonnet > file.jsonnet
    ./jsonnet file.jsonnet > /tmp/results.txt
    echo "$(grep runtime /tmp/results.txt | grep -o '[0-9]\+') $(grep tsresult /tmp/results.txt | grep -o '[0-9]\+' | awk '{s+=$1} END {print s}')"
done
