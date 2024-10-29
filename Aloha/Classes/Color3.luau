-- thegalaxydev

--[=[
	@class Color3

	The Color3 data type describes a color using red, green, and blue components in the range of 0 to 1.
]=]
local Color3 = {}
Color3.__index = Color3

export type Color3 = typeof(Color3) & {
	R: number,
	G: number,
	B: number,
}

--[=[
	Creates a new Color3.
	@param r number
	@param g number
	@param b number
	@return Color3
]=]
function Color3.new(r: number, g: number, b: number): Color3
	local self = setmetatable({}, Color3)

	self.R = math.clamp(r, 0, 1)
	self.G = math.clamp(g, 0, 1)
	self.B = math.clamp(b, 0, 1)

	return self
end

--[=[
	Creates a new Color3 from RGB values.
	@param r number
	@param g number
	@param b number
	@return Color3
]=]
function Color3.fromRGB(r: number, g: number, b: number): Color3
	return Color3.new(r / 255, g / 255, b / 255)
end

--[=[
	Creates a new Color3 from a hex string.
	@param hex string
	@return Color3
]=]
function Color3.fromHex(hex: string): Color3
	local r, g, b = hex:match("#(%x%x)(%x%x)(%x%x)")

	r = tonumber(r, 16) or 0
	g = tonumber(g, 16) or 0
	b = tonumber(b, 16) or 0

	return Color3.new(r / 255, g / 255, b / 255)
end

--[=[
	Creates a new Color3 from HSV values.
	@param h number
	@param s number
	@param v number
	@return Color3
]=]
function Color3.fromHSV(h: number, s: number, v: number): Color3
	h = h / 255
	s = s / 255
	v = v / 255

	local r, g, b

	local i = math.floor(h * 6)
	local f = h * 6 - i
	local p = v * (1 - s)
	local q = v * (1 - f * s)
	local t = v * (1 - (1 - f) * s)

	i = i % 6

	if i == 0 then
		r, g, b = v, t, p
	elseif i == 1 then
		r, g, b = q, v, p
	elseif i == 2 then
		r, g, b = p, v, t
	elseif i == 3 then
		r, g, b = p, q, v
	elseif i == 4 then
		r, g, b = t, p, v
	elseif i == 5 then
		r, g, b = v, p, q
	end

	return Color3.new(r, g, b)
end

--[=[
	Converts the Color3 to a hex string.
	@return string
]=]
function Color3:ToHex(): string
	return ("#%02X%02X%02X"):format(self.R * 255, self.G * 255, self.B * 255)
end

--[=[
	Converts the Color3 to HSV values.
	@return number, number, number
]=]
function Color3:ToHSV(): (number, number, number)
	local r, g, b = self.R, self.G, self.B

	local min_val = math.min(r, g, b)
	local max_val = math.max(r, g, b)
	local delta = max_val - min_val

	local h, s, v = 0, 0, max_val

	if max_val ~= 0 then
		s = delta / max_val
	else
		s = 0
		h = -1
		return h, s, v
	end

	if delta == 0 then
		h = 0 -- 
	elseif max_val == r then
		h = (g - b) / delta % 6
	elseif max_val == g then
		h = (b - r) / delta + 2
	elseif max_val == b then
		h = (r - g) / delta + 4
	end

	h = h / 6

	if h < 0 then
		h = h + 1
	end

	return h, s, v
end

--[=[
	Lerps between two colors.
	@param other Color3
	@param alpha number
	@return Color3
]=]
function Color3:Lerp(other: Color3, alpha: number): Color3
	return Color3.new(
		self.R + (other.R - self.R) * alpha,
		self.G + (other.G - self.G) * alpha,
		self.B + (other.B - self.B) * alpha
	)
end

--[=[
	Converts the Color3 to an integer.
	@return number
]=]
function Color3:ToInt(): number
	return (self.R * 255 * 256 * 256) + (self.G * 255 * 256) + self.B * 255
end

return Color3
