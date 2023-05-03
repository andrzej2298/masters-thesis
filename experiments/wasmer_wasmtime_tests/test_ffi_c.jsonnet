{
    local lib = importwasm "library_c.wasm",
    result: lib.add(1, 2)
}
