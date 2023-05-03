{
    local sha = self,
    local LAST_CHUNK_MAX_SIZE = 56,
    local CHUNK_SIZE = 64,
    local H0 = 1732584193,
    local H1 = 4023233417,
    local H2 = 2562383102,
    local H3 = 271733878,
    local H4 = 3285377520,
    leftRotate(x, n)::
        if n <= 16
        then ((x << n) | (x >> (32 - n))) & (std.pow(2, 32) - 1)
        else ((((((x << 16) & (std.pow(2, 48) - 1)) << (n - 16) & (std.pow(2, 32) - 1)))) | (x >> (32 - n))) & (std.pow(2, 32) - 1),
    encodeLength(length):: [
            (length % std.pow(2, 64)) >> 56,
            (length % std.pow(2, 56)) >> 48,
            (length % std.pow(2, 48)) >> 40,
            (length % std.pow(2, 40)) >> 32,
            (length % std.pow(2, 32)) >> 24,
            (length % std.pow(2, 24)) >> 16,
            (length % std.pow(2, 16)) >> 8,
            length % std.pow(2, 8)
        ],
    arrayTo32BitNumber(array):: 
            (array[0] << 24) +
            (array[1] << 16) +
            (array[2] << 8) +
            array[3],
    hexBitsFrom32BitNumber(n)::
        [
            n >> 28,
            (n >> 24) % std.pow(2, 4),
            (n >> 20) % std.pow(2, 4),
            (n >> 16) % std.pow(2, 4),
            (n >> 12) % std.pow(2, 4),
            (n >> 8) % std.pow(2, 4),
            (n >> 4) % std.pow(2, 4),
            n % std.pow(2, 4),
        ],
    hexDigitFromHexBit(n)::
        [
            "0", "1", "2", "3", "4", "5", "6", "7", "8", "9",
            "a", "b", "c", "d", "e", "f"
        ][n],
    makeChunk(padded, chunkCount, originalMessageLength)::
        function(i)
            local ind = i * CHUNK_SIZE;
            local chunk = padded[ind:(ind + CHUNK_SIZE)];
            if i == chunkCount - 1
            // last chunk, add original message length
            then chunk + sha.encodeLength(originalMessageLength)
            else chunk,
    breakIntoChunks(x)::
        local originalMessage = std.encodeUTF8(x);
        // message is a multiple of 8 bits, so to append one '1' bit we add 2^7=128
        local oneAppended = originalMessage + [128];
        local originalMessageLength = std.length(originalMessage) * 8;
        local sizeRemainder = (std.length(oneAppended) + 8) % CHUNK_SIZE;
        local zeroCount = CHUNK_SIZE - sizeRemainder;
        local padded = oneAppended + std.makeArray(zeroCount, function(_) 0);
        local chunkCount = std.ceil(std.length(padded) / 64);
        std.makeArray(chunkCount, self.makeChunk(padded, chunkCount, originalMessageLength)),
    extend(x)::
        local smallerChunks = [std.makeArray(16, function(i) sha.arrayTo32BitNumber(chunk[(i * 4):(i * 4 + 4)])) for chunk in x];
        local smallerChunksExtended = [
            std.foldl(
                function(words, i) words + [sha.leftRotate(words[i-3] ^ words[i-8] ^ words[i-14] ^ words[i-16], 1)],
                std.range(16,79),
                chunk)
            for chunk in smallerChunks];
        smallerChunksExtended,
    calculate(acc, w)::
        local i = acc[0];
        local a = acc[1];
        local b = acc[2];
        local c = acc[3];
        local d = acc[4];
        local e = acc[5];
        local f =
            if i <= 19 then d ^ (b & (c ^ d))
            else if 40 <= i && i <= 59 then (b & c) | (b & d) | (c & d)
            else b ^ c ^ d;
        local k =
            if i <= 19 then 1518500249
            else if 20 <= i && i <= 39 then 1859775393
            else if 40 <= i && i <= 59 then 2400959708
            else 3395469782;
            [
                i + 1,
                (sha.leftRotate(a, 5) + f + e + k + w) % std.pow(2, 32),
                a,
                sha.leftRotate(b, 30) % std.pow(2, 32),
                c,
                d
            ],
            // std.trace(std.toString(acc), [
            //     i + 1,
            //     (sha.leftRotate(a, 5) + f + e + k + w) % std.pow(2, 32),
            //     a,
            //     sha.leftRotate(b, 30) % std.pow(2, 32),
            //     c,
            //     d
            // ]),
    processChunk(acc, x)::
        local processedChunk = std.foldl(sha.calculate, x, [0] + acc)[1:];
        [
            (processedChunk[0] + acc[0]) % std.pow(2, 32),
            (processedChunk[1] + acc[1]) % std.pow(2, 32),
            (processedChunk[2] + acc[2]) % std.pow(2, 32),
            (processedChunk[3] + acc[3]) % std.pow(2, 32),
            (processedChunk[4] + acc[4]) % std.pow(2, 32),
        ],
    sha(x):: 
        std.join(
            "",
            std.map(
                sha.hexDigitFromHexBit,
                std.flatMap(
                    sha.hexBitsFrom32BitNumber,
                    std.foldl(sha.processChunk,
                        sha.extend(sha.breakIntoChunks(x)),
                        [H0, H1, H2, H3, H4])
                )
            )
        ),
    input:: "helloworld",
    result: std.makeArray(std.parseInt(std.extVar("loopCount")), function(_) sha.sha(sha.input)),
}
