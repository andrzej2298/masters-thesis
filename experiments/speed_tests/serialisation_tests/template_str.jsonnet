{
    local lib = importwasm "wasmlibs/rust_wasm_str_lib_LIBNUM.wasm",
    result: lib.str_LIBNUM(LIBARGS)
}
