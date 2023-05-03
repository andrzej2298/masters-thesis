{
    local lib = importwasm "wasmlibs/WASMLANG_wasm_lib_LIBNUM.wasm",
    sum: lib.add_1(1, 2),
}
