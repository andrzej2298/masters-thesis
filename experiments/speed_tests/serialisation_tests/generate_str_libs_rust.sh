#!/usr/bin/env bash

for i in 1 $(seq 5 5 100)
do
    {
        echo "use helper_macros::jsonnet_export;"
        echo "#[jsonnet_export]"
        printf "pub fn str_$i(x1: String"
        if (( i > 1 ))
        then
            for j in $(seq 2 $i)
            do
                printf ", x${j}: String"
            done
        fi
        printf ") -> String {\n"
        echo "    x1"
        echo "}"
    } > src/exported_functions.rs
    cargo build
    cp target/wasm32-wasi/debug/wasm_lib.wasm "wasmlibs/rust_wasm_str_lib_$i.wasm"
done
