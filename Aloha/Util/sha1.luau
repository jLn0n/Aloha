--[=[
    @class sha1
    SHA-1 hashing implementation. Credit to Dekkonot - https://github.com/Dekkonot/lua-hashing
]=]

--!strict
--!native
--!optimize 2

-- An allocation that is reused for blocks during hashing
local BLOCK = table.create(80)

--[=[
    @function processBlocks
    @within sha1
    @param digest {number} -- The digest array to update
    @param message string -- The message to process
    @param start number -- Starting byte position
    @param finish number -- Ending byte position
    Processes message from byte start to byte finish using digest. Assumes (finish - start) % 64 == 0
    @private
]=]
local function processBlocks(digest: { number }, message: string, start: number, finish: number)
	local block = BLOCK
	local d1, d2, d3, d4, d5 = digest[1], digest[2], digest[3], digest[4], digest[5]

	for i = start, finish, 64 do
		-- Fill `block`
		for t = 1, 16 do
			local a, b, c, d = string.byte(message, i, i + 3)
			block[t] = bit32.bor(bit32.lshift(a, 24), bit32.lshift(b, 16), bit32.lshift(c, 8), d)
			i += 4
		end
		-- This loop was previously unrolled but with improvements to Luau,
		-- the performance boost is now minimal.
		for t = 17, 80 do
			block[t] = bit32.lrotate(bit32.bxor(block[t - 3], block[t - 8], block[t - 14], block[t - 16]), 1)
		end

		-- Standard SHA1 rounds
		local a, b, c, d, e = d1, d2, d3, d4, d5
		local temp
		for t = 1, 20 do
			-- F(B,C,D) = CH(X,Y,Z) = ternary for bits
			-- e.g. if x_bit == 1 then bit = y_bit else bit = z_bit
			-- reference implemention, this is: (X AND Y) XOR ((NOT X) AND Z)
			-- However, the XOR is equivalent to addition if you don't carry
			-- Since we're using bit32 (which truncates), we don't carry.
			-- So we're left with:
			-- (X AND Y) + ((NOT X) AND Z)
			-- Also, NOT X is equivalent to -1 - X
			-- So we can drop another bitwise op:

			-- f = bit32.band(b, c) + bit32.band(-1 - b, d)
			temp = bit32.lrotate(a, 5) + bit32.band(b, c) + bit32.band(bit32.bnot(b), d) + e + 0x5A827999 + block[t]
			e, d, c, b, a = d, c, bit32.lrotate(b, 30), a, temp
		end
		for t = 21, 40 do
			-- f = bit32.bxor(b, c, d)
			temp = bit32.lrotate(a, 5) + bit32.bxor(b, c, d) + e + 0x6ED9EBA1 + block[t]
			e, d, c, b, a = d, c, bit32.lrotate(b, 30), a, temp
		end
		for t = 41, 60 do
			-- f = bit32.band(d, c) + bit32.band(b, bit32.bxor(d, c))
			temp = bit32.lrotate(a, 5) + bit32.band(d, c) + bit32.band(b, bit32.bxor(d, c)) + e + 0x8F1BBCDC + block[t]
			e, d, c, b, a = d, c, bit32.lrotate(b, 30), a, temp
		end
		for t = 61, 80 do
			-- f = bit32.bxor(b, c, d)
			temp = bit32.lrotate(a, 5) + bit32.bxor(b, c, d) + e + 0xCA62C1D6 + block[t]
			e, d, c, b, a = d, c, bit32.lrotate(b, 30), a, temp
		end

		d1 = bit32.bor(a + d1, 0)
		d2 = bit32.bor(b + d2, 0)
		d3 = bit32.bor(c + d3, 0)
		d4 = bit32.bor(d + d4, 0)
		d5 = bit32.bor(e + d5, 0)
	end

	-- Only update the digest once for the vine
	digest[1] = d1
	digest[2] = d2
	digest[3] = d3
	digest[4] = d4
	digest[5] = d5
end

--[=[
    @function sha1
    @within sha1
    @param message string -- The payload to compute the SHA-1 hash of
    @return buffer -- The computed SHA-1 hash as a buffer
    Computes the SHA-1 hash for the given message and returns it as a buffer
]=]
local function sha1(message: string): buffer
	local digest = {
		0x67452301,
		0xEFCDAB89,
		0x98BADCFE,
		0x10325476,
		0xC3D2E1F0,
	}

	local messageLen = #message
	local leftover = messageLen % 64
	if messageLen >= 64 then
		processBlocks(digest, message, 1, messageLen - leftover)
	end

	-- Calculate padding
	local nextMultipleOf64 = bit32.band(leftover + 32, 0xffffffc0)
	local finalMessage = {
		if leftover ~= 0 then string.sub(message, -leftover) else "",
		"\x80",
		string.rep("\0", (nextMultipleOf64 - leftover - 9) % 64),
		string.pack(">L", messageLen * 8),
	}
	local finalBlock = table.concat(finalMessage)
	processBlocks(digest, finalBlock, 1, #finalBlock)

	local newBuffer = buffer.create(20)

	buffer.writeu32(newBuffer, 0, digest[1])
	buffer.writeu32(newBuffer, 4, digest[2])
	buffer.writeu32(newBuffer, 8, digest[3])
	buffer.writeu32(newBuffer, 12, digest[4])
	buffer.writeu32(newBuffer, 16, digest[5])

	return newBuffer
end

return sha1