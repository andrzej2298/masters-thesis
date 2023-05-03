{
    local lib = importwasm "wasmlibs/rust_wasm_lib_LIBNUM.wasm",
    a: std.objectFields(lib),
    result: lib.add_LIBNUM(LIBARGS)
}
