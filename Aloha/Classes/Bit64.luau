--!optimize 2
-- Created by Dekkonot https://gist.github.com/Dekkonot/49143d03962be70dfaeb71b3258dd305

-- stylua: ignore
local HEX_TO_BINARY = {
    ["0"] = "0000", ["1"] = "0001", ["2"] = "0010", ["3"] = "0011",
    ["4"] = "0100", ["5"] = "0101", ["6"] = "0110", ["7"] = "0111",
    ["8"] = "1000", ["9"] = "1001", ["a"] = "1010", ["b"] = "1011",
    ["c"] = "1100", ["d"] = "1101", ["e"] = "1110", ["f"] = "1111",
}
local Vector3 = require("./Vector3")
type Vector3 = Vector3.Vector3

local function u64_from_pair(most: number, least: number): Vector3
	-- 32 - 22 = 10
	-- x = upper 24 of most
	-- y = lower 10 of most and lower 10 of least
	-- z = upper 24 of least
	return Vector3.new(
		bit32.rshift(most, 10),
		bit32.replace(bit32.band(least, 0x3FF), bit32.band(most, 0x3FF), 10, 10),
		bit32.rshift(least, 10)
	)
end

local function u64_from_u32(u32: number): Vector3
	return Vector3.new(0, bit32.band(u32, 0x3FF), bit32.rshift(u32, 10))
end

local function u64_from_f64(f64: number): Vector3
	return u64_from_pair(bit32.bor(f64 // 2 ^ 32), bit32.bor(f64 % 2 ^ 32))
end

local function u64_from_buffer(buf: buffer, offset: number?): Vector3
	offset = offset or 0
	local least = buffer.readu32(buf, offset :: number)
	local most = buffer.readu32(buf, offset :: number + 4)

	return u64_from_pair(most, least)
end

local function u64_from_string(str: string, offset: number?): Vector3
	offset = offset or 1
	-- This is deliberately backwards because we expect a little endian input
	local d, c, b, a, h, g, f, e = string.byte(str, offset, offset :: number + 7)
	local least = bit32.bor(bit32.lshift(bit32.replace(b, a, 8, 8), 16), bit32.replace(d, c, 8, 8))
	local most = bit32.bor(bit32.lshift(bit32.replace(f, e, 8, 8), 16), bit32.replace(h, g, 8, 8))

	return u64_from_pair(most, least)
end

local function u32_from_u64(u64: Vector3): (number, number)
	local most = bit32.bor(bit32.lshift(u64.X, 10), bit32.rshift(u64.Y, 10))
	local least = bit32.bor(bit32.lshift(u64.Z, 10), bit32.band(u64.Y, 0x3FF))

	return most, least
end

local function u16_from_u64(u64: Vector3): (number, number, number, number)
	local most, least = u32_from_u64(u64)
	return bit32.rshift(most, 16), bit32.band(most, 0xFFFF), bit32.rshift(least, 16), bit32.band(least, 0xFFFF)
end

local function f64_from_u64(u64: Vector3): number
	local most, least = u32_from_u64(u64)
	return most * 2 ^ 32 + least
end

local function to_bytes_buffer(u64: Vector3): buffer
	local most, least = u32_from_u64(u64)
	local buf = buffer.create(8)
	-- We use a little endian format because it doesn't matter and most
	-- systems we run on are little endian so it'll be nicer for them.
	buffer.writeu32(buf, 0, least)
	buffer.writeu32(buf, 4, most)
	return buf
end

local function to_bytes_string(u64: Vector3): string
	local most, least = u32_from_u64(u64)
	return string.format(
		"%c%c%c%c%c%c%c%c",
		bit32.band(least, 0xFF),
		bit32.extract(least, 8, 8),
		bit32.extract(least, 16, 8),
		bit32.rshift(least, 24),
		bit32.band(most, 0xFF),
		bit32.extract(most, 8, 8),
		bit32.extract(most, 16, 8),
		bit32.rshift(most, 24)
	)
end

local ZERO_VECTOR = Vector3.new(0, 0, 0)
-- TODO: validate that this is correct
local ONE_VECTOR = Vector3.new(0, 0x1, 0)

--[=[
	Converts the provided `u64` to a string of 16 hexadecimal digits.
	The returned string will always be 16 bytes and the number is formatted as
	if it were big-endian.
]=]
local function to_hex_string(u64: Vector3): string
	local most, least = u32_from_u64(u64)
	return string.format("%08x%08x", most, least)
end

--[=[
	Converts the provided `u64` to a string of 64 binary digits.
	The returned string will always be 64 bytes and the number is formatted as
	if it were big-endian.
]=]
local function to_bin_string(u64: Vector3): string
	-- horrible, inefficent, terrible.
	return (string.gsub(to_hex_string(u64), "(.)", HEX_TO_BINARY))
end

--[=[
	Returns whether the provided `u64` is zero or not.
	Equivalent to `u64 == from_u32(0)`.
]=]
local function is_zero(u64: Vector3): boolean
	return u64 == ZERO_VECTOR
end

--[=[
	Computes the bitwise AND of the two provide values.
	This does not accept a vararg like the `bit32` equivalent for performance
	reasons.
]=]
local function band(lhs: Vector3, rhs: Vector3): Vector3
	return Vector3.new(bit32.band(lhs.X, rhs.X), bit32.band(lhs.Y, rhs.Y), bit32.band(lhs.Z, rhs.Z))
end

--[=[
	Computes the bitwise OR of the two provide values.
	This does not accept a vararg like the `bit32` equivalent for performance
	reasons.
]=]
local function bor(lhs: Vector3, rhs: Vector3): Vector3
	return Vector3.new(bit32.bor(lhs.X, rhs.X), bit32.bor(lhs.Y, rhs.Y), bit32.bor(lhs.Z, rhs.Z))
end

--[=[
	Computes the bitwise XOR of the two provide values.
	This does not accept a vararg like the `bit32` equivalent for performance
	reasons.
]=]
local function bxor(lhs: Vector3, rhs: Vector3): Vector3
	return Vector3.new(bit32.bxor(lhs.X, rhs.X), bit32.bxor(lhs.Y, rhs.Y), bit32.bxor(lhs.Z, rhs.Z))
end

--[=[
	Computes the bitwise negation of the provided value.
]=]
local function bnot(u64: Vector3): Vector3
	return Vector3.new(bit32.bnot(u64.X), bit32.bnot(u64.Y), bit32.bnot(u64.Z))
end

--[=[
	Shifts the provided `u64` logically left by `n` bits.
	This function will error if `n` is outside the range `[0, 64]`.
]=]
local function lshift(u64: Vector3, n: number): Vector3
	if n == 0 then
		return u64
	end
	local most, least = u32_from_u64(u64)
	if n < 32 then
		local remainder = 32 - n
		local ret =
			u64_from_pair(bit32.replace(bit32.rshift(least, remainder), most, n, remainder), bit32.lshift(least, n))
		return ret
	else
		local ret = u64_from_pair(bit32.lshift(least, n - 32), 0)
		return ret
	end
end

--[=[
	Shifts the provided `u64` logically right by `n` bits.
	This function will error if `n` is outside the range `[0, 64]`.
]=]
local function rshift(u64: Vector3, n: number): Vector3
	if n == 0 then
		return u64
	end
	local most, least = u32_from_u64(u64)
	if n < 32 then
		local ret = u64_from_pair(bit32.rshift(most, n), bit32.replace(bit32.rshift(least, n), most, 32 - n, n))
		return ret
	else
		local ret = u64_from_pair(0, bit32.rshift(most, n - 32))
		return ret
	end
end

--[=[
	Shifts the provided `u64` arithmetically right by `n` bits. Since these
	numbers are unsigned, this effectively just copies the most significant
	bit into the empty space rather than filling them with zeros.
	This function will error if `n` is outside the range `[0, 64]`.
]=]
local function arshift(u64: Vector3, n: number): Vector3
	if n == 0 then
		return u64
	end
	local most, least = u32_from_u64(u64)
	if n < 32 then
		local ret = u64_from_pair(bit32.arshift(most, n), bit32.replace(bit32.rshift(least, n), most, 32 - n, n))
		return ret
	else
		local ret = u64_from_pair(
			if bit32.btest(most, 0x8000_0000) then 0xFFFF_FFFF else 0x0000_0000,
			bit32.arshift(most, n - 32)
		)
		return ret
	end
end

--[=[
	Rotates the bits of the provided `u64` left by `n` bits. 
	This function will error if `n` is outside the range `[0, 64]`.
]=]
local function lrotate(u64: Vector3, n: number): Vector3
	if n == 64 then
		return u64
	else
		local lshifted = lshift(u64, n)
		local rshifted = rshift(u64, 64 - n)
		return bor(lshifted, rshifted)
	end
end

--[=[
	Rotates the bits of the provided `u64` right by `n` bits. 
	This function will error if `n` is outside the range `[0, 64]`.
]=]
local function rrotate(u64: Vector3, n: number): Vector3
	if n == 64 then
		return u64
	else
		local lshifted = rshift(u64, n)
		local rshifted = lshift(u64, 64 - n)
		return bor(lshifted, rshifted)
	end
end

--[=[
	Returns the number of consecutive zero bits in the provided `u64` starting
	from the left-most (most significant) bit.
]=]
local function countlz(u64: Vector3): number
	local most, least = u32_from_u64(u64)
	if most == 0 then
		return bit32.countlz(least) + 32
	else
		return bit32.countlz(most)
	end
end

--[=[
	Returns the number of consecutive zero bits in the provided `u64` starting
	from the right-most (least significant) bit.
]=]
local function countrz(u64: Vector3): number
	local most, least = u32_from_u64(u64)
	if least == 0 then
		return bit32.countrz(most) + 32
	else
		return bit32.countrz(least)
	end
end

--[=[
	Returns a boolean describing whether the bitwise AND of `lhs` and
	`rhs` are different than zero.
	This does not accept a vararg like the `bit32` equivalent for performance
	reasons.
]=]
local function btest(lhs: Vector3, rhs: Vector3): boolean
	return is_zero(band(lhs, rhs))
end

--[=[
	Returns the provided `u64` with the order of bytes swapped.
]=]
local function byteswap(u64: Vector3): Vector3
	local most, least = u32_from_u64(u64)
	return u64_from_pair(bit32.byteswap(least), bit32.byteswap(most))
end

--[=[
	Returns whether `lhs` is greater than `rhs`.
]=]
local function gt(lhs: Vector3, rhs: Vector3): boolean
	local l_most, l_least = u32_from_u64(lhs)
	local r_most, r_least = u32_from_u64(rhs)

	if l_most == r_most then
		return l_least > r_least
	else
		return l_most > r_most
	end
end

--[=[
	Returns whether `lhs` is greater than or equal to `rhs`.
]=]
local function gt_equal(lhs: Vector3, rhs: Vector3): boolean
	return lhs == rhs or gt(lhs, rhs)
end

--[=[
	Returns whether `lhs` is less than `rhs`.
]=]
local function lt(lhs: Vector3, rhs: Vector3): boolean
	local l_most, l_least = u32_from_u64(lhs)
	local r_most, r_least = u32_from_u64(rhs)

	if l_most == r_most then
		return l_least < r_least
	else
		return l_most < r_most
	end
end

--[=[
	Returns whether `lhs` is less than or equal to `rhs`.
]=]
local function lt_equal(lhs: Vector3, rhs: Vector3): boolean
	return lhs == rhs or lt(lhs, rhs)
end

--[=[
	Calculates the sum of the two provided values. Equivalent to `+` for
	normal integers.
	
	If the sum is equal to or greater than 2^64, the returned value will
	overflow rather than expanding beyond 64 bits.
]=]
local function add(lhs: Vector3, rhs: Vector3): Vector3
	-- A more clever man could probably just use `lhs + rhs`
	-- and then handle carrying manually. I am not clever.
	local l_most, l_least = u32_from_u64(lhs)
	local r_most, r_least = u32_from_u64(rhs)

	local f_most = l_most + r_most
	local f_least = l_least + r_least

	-- carrying
	if f_least >= 2 ^ 32 then
		f_least -= 2 ^ 32
		f_most += 1
	end

	if f_most >= 2 ^ 32 then
		f_most -= 2 ^ 32
	end

	return u64_from_pair(f_most, f_least)
end

--[=[
	Calculates the difference of the two provided values. Equivalent to `-` for
	normal integers.
	
	If the difference is less than 0, the returned value will overflow rather
	than going negative.
]=]
local function sub(lhs: Vector3, rhs: Vector3): Vector3
	local l_most, l_least = u32_from_u64(lhs)
	local r_most, r_least = u32_from_u64(rhs)

	local f_most = l_most - r_most
	local f_least = l_least - r_least

	-- carrying
	if f_least < 0 then
		f_least += 2 ^ 32
		f_most -= 1
	end

	if f_most < 0 then
		f_most += 2 ^ 32
	end

	return u64_from_pair(f_most, f_least)
end

--[=[
	Calculates the product of the two provided values. Equivalent to `*` for
	normal integers.
	
	If the product is greater than or equal to 2^64, the returned value will
	overflow rather than expanding beyond 64-bits.
]=]
local function mult(lhs: Vector3, rhs: Vector3): Vector3
	-- We represent 64-bit numbers as two 32-bit ones.
	-- Multiplying them is:
	-- (A + B) * (C + D) = (A * C) + (A * D) + (B * C) + (B * D)
	--
	-- However, multiplying two 32-bit numbers might overflow. So, we need to
	-- use 16-bit numbers. This turns out math into this:
	-- (A + B + C + D) * (E + F + G + H) =
	-- 		(A * E) + (A * F) + (A * G) + (A * H) +
	-- 		(B * E) + (B * F) + (B * G) + (B * H) +
	-- 		(C * E) + (C * F) + (C * G) + (C * H) +
	-- 		(D * E) + (D * F) + (D * G) + (D * H)
	--
	-- We can skip (A * E), (A * F), (A * G), (B * E), (B * F), and (C * F)
	-- because they don't exist within the bounds of the final product.
	-- Since the numbers are built as A * 2 ^ 48 + B * 2 ^ 32 + C * 2 ^ 16 + D
	-- you end up with e.g. (A * 2 ^ 48 * E * 2 ^ 48) which is A * E * 2^96.
	-- Otherwise... Here we go.

	local a, b, c, d = u16_from_u64(lhs)
	local e, f, g, h = u16_from_u64(rhs)

	local product_4 = d * h
	local product_3 = bit32.rshift(product_4, 16) + c * h
	local product_2 = bit32.rshift(product_3, 16)
	product_3 = bit32.band(product_3, 0xFFFF) + d * g

	product_2 += bit32.rshift(product_3, 16) + b * h
	local product_1 = bit32.rshift(product_2, 16)

	product_2 = bit32.band(product_2, 0xFFFF) + c * g
	product_1 += bit32.rshift(product_2, 16)
	product_2 = bit32.band(product_2, 0xFFFF) + d * f
	product_1 += bit32.rshift(product_2, 16) + a * h + b * g + c * f + d * e

	-- We skip truncating any of the products the last time since they'll never
	-- overflow and bit32 will truncate them for us.

	return u64_from_pair(bit32.replace(product_2, product_1, 16, 16), bit32.replace(product_4, product_3, 16, 16))
end

--[=[
	Calculates the product of the two provided values. Equivalent to `//` for
	normal integers. 
	
	This function will error if `rhs` is 0.
]=]
local function div(lhs: Vector3, rhs: Vector3): Vector3
	if is_zero(rhs) then
		error("cannot divide integers by zero", 2)
	elseif countlz(lhs) >= 11 and countlz(rhs) >= 11 then
		local l_real = f64_from_u64(lhs)
		local r_real = f64_from_u64(rhs)
		return u64_from_f64(l_real / r_real), u64_from_f64(math.fmod(l_real, r_real))
	end

	local quotient = ZERO_VECTOR
	local divisor = rhs
	local power = 0
	while lt_equal(divisor, lhs) do
		divisor = lshift(divisor, 1)
		power += 1
	end

	while power > 0 do
		divisor = rshift(divisor, 1)
		power -= 1

		if lt_equal(divisor, lhs) then
			lhs = sub(lhs, divisor)
			quotient = bor(quotient, lshift(ONE_VECTOR, power))
		end
	end

	return quotient
end

-- TODO: replace and extract
-- TODO: to_decimal_string
-- TODO: vararg versions of band, bor, bxor
-- TODO: constants

return {
	from_pair = u64_from_pair,
	from_u32 = u64_from_u32,
	from_f64 = u64_from_f64,
	from_string = u64_from_string,
	from_buffer = u64_from_buffer,

	to_pair = u32_from_u64,
	to_quartet = u16_from_u64,

	to_string = to_bytes_string,
	to_buffer = to_bytes_buffer,
	to_hex_string = to_hex_string,
	to_bin_string = to_bin_string,

	band = band,
	bor = bor,
	bxor = bxor,
	btest = btest,

	bnot = bnot,
	byteswap = byteswap,
	countlz = countlz,
	countrz = countrz,

	rshift = rshift,
	arshift = arshift,
	rrotate = rrotate,
	lshift = lshift,
	lrotate = lrotate,

	add = add,
	sub = sub,
	mult = mult,
	div = div,

	lt = lt,
	lt_equal = lt_equal,
	gt = gt,
	gt_equal = gt_equal,
}