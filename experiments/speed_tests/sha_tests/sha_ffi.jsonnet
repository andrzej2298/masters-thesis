local lib = importwasm "sha_ffi.wasm";
{
    input:: "helloworld",
    result:  lib.sha(self.input, std.parseInt(std.extVar("loopCount"))),
}
