#!/usr/bin/env bash

for i in $(seq 5 5 100)
do
    {
        echo "use helper_macros::jsonnet_export;"
        for j in $(seq 1 $i)
        do
            # echo "use helper_macros::jsonnet_export;"
            echo "#[jsonnet_export]"
            echo "pub fn add_$j(x: f32, y: f32) -> f32 {"
            echo "    x + y"
            echo "}"
        done
    } > src/exported_functions.rs
    cargo build
    cp target/wasm32-wasi/debug/wasm_lib.wasm "wasmlibs/rust_wasm_lib_$i.wasm"
done
