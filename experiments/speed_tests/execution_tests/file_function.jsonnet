{
    local lib = importwasm "wasm_lib.wasm",
    sum: lib.measure_time(),
}
