#!/usr/bin/env bash

for i in 1 $(seq 5 5 100)
do
    {
        echo "use helper_macros::jsonnet_export;"
        echo "#[jsonnet_export]"
        printf "pub fn add_$i(x1: f32"
        if (( i > 1 ))
        then
            for j in $(seq 2 $i)
            do
                printf ", x${j}: f32"
            done
        fi
        printf ") -> f32 {\n"
        echo "    x1"
        echo "}"
    } > src/exported_functions.rs
    cargo build
    cp target/wasm32-wasi/debug/wasm_lib.wasm "wasmlibs/rust_wasm_lib_$i.wasm"
done
