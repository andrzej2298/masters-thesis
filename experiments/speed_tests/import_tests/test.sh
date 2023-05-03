#!/usr/bin/env bash

lang="$1"
for i in 1 $(seq 5 5 100)
do
    sed "s/LIBNUM/$i/g" template.jsonnet > file.jsonnet
    sed -i "" "s/WASMLANG/$lang/g" file.jsonnet
    ./jsonnet file.jsonnet > /tmp/results.txt
    echo "$(grep runtime /tmp/results.txt | grep -o '[0-9]\+') $(grep meta /tmp/results.txt | grep -o '[0-9]\+' | awk '{s+=$1} END {print s}')"
done
