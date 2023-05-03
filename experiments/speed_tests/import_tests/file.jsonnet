{
    local lib = importwasm "wasmlibs/wasm_lib_100.wasm",
    sum: lib.add_1(1, 2),
}
