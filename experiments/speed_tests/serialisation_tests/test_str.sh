#!/usr/bin/env bash

for i in 1 $(seq 5 5 100)
do
    sed "s/LIBNUM/$i/g" template_str.jsonnet > file.jsonnet
    LIBARGS=\"aaaaaaaaaaa\"
    if (( i > 1 ))
    then
        for j in $(seq 2 ${i})
        do
            LIBARGS="${LIBARGS}, \"aaaaaaaaaaa\""
        done
    fi
    sed -i "" "s/LIBARGS/${LIBARGS}/g" file.jsonnet
    ./jsonnet file.jsonnet > /tmp/results.txt
    echo "$(grep argevaltime /tmp/results.txt | grep -o '[0-9]\+') $(grep argmarshaltime /tmp/results.txt | grep -o '[0-9]\+')"
done
