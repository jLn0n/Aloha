local Vector3 = {}
Vector3.__index = Vector3

export type Vector3 = {
	X: number,
	Y: number,
	Z: number,
	Zero: () -> Vector3,
	One: () -> Vector3,
}

function Vector3.new(x: number, y: number, z: number) : Vector3
	local self = setmetatable({}, {
		__index = Vector3,
		__tostring = function(self)
			return string.format("(%d, %d, %d)", self.X, self.Y, self.Z)
		end,
		__eq = function(self, other)
			return self.X == other.X and self.Y == other.Y and self.Z == other.Z
		end,
		__add = function(self, other)
			return Vector3.new(self.X + other.X, self.Y + other.Y, self.Z + other.Z)
		end,
		__sub = function(self, other)
			return Vector3.new(self.X - other.X, self.Y - other.Y, self.Z - other.Z)
		end,
		__mul = function(self, other)
			return Vector3.new(self.X * other.X, self.Y * other.Y, self.Z * other.Z)
		end,
		__div = function(self, other)
			return Vector3.new(self.X / other.X, self.Y / other.Y, self.Z / other.Z)
		end,
		__unm = function(self)
			return Vector3.new(-self.X, -self.Y, -self.Z)
		end,
	})

	self.X = x
	self.Y = y
	self.Z = z

	return self
end

function Vector3.Zero() : Vector3
	return Vector3.new(0, 0, 0)
end

function Vector3.One() : Vector3
	return Vector3.new(1, 1, 1)
end

return Vector3
