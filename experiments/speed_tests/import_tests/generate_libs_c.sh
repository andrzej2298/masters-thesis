#!/usr/bin/env bash

for i in $(seq 5 5 100)
do
    {
        echo "#include \"jsonnetffi.h\""
        echo "#include \"jsonnetffi/jsonnetffi.h\""
        echo "#include <stdlib.h>"
        echo "#include <string.h>"
        echo "#include <stdint.h>"
        echo ""

        for j in $(seq 1 $i)
        do
            echo "void *__jsonnet_export_add_${j}(uint8_t *arguments_ptr) JSONNET_ATTRIBUTES(add_${j}) {"
            echo "    jsonnet_args *arguments = get_jsonnet_args(arguments_ptr);"
            echo "    int32_t x = jsonnet_get_int32_arg(arguments, \"x\");"
            echo "    int32_t y = jsonnet_get_int32_arg(arguments, \"y\");"
            echo "    return jsonnet_return_int32(x + y, arguments_ptr, arguments);"
            echo "}"
            echo ""
            echo "JSONNET_REGISTER_ARGS(add_${j}, \"x\", \"y\");"
            echo ""
        done
    } > exported_functions.c
    cd build && emmake make && cd ..
    cp build/exported-functions.wasm "wasmlibs/c_wasm_lib_$i.wasm"
done
