--[=[
@class LinkedList
A linked list implementation.
]=]
local LinkedList = {}
LinkedList.__Index = LinkedList
LinkedList.__len = function(self)
	return self.Length
end

--[=[
@within LinkedList
@type LinkedListNode<T> {Next: LinkedListNode<T>?, Prev: LinkedListNode<T>?, Index: number, Value: T}
A node in the linked list.
]=]
type LinkedListNode<T> = {
	Next: LinkedListNode<T>?,
	Prev: LinkedListNode<T>?,
	Index: number,
	Value: T
}

--[=[
@within LinkedList
@type LinkedList<T> {Head: LinkedListNode<T>?, Tail: LinkedListNode<T>?, Length: number}
A linked list.
]=]
export type LinkedList<T> = {
	Head: LinkedListNode<T>?,
	Tail: LinkedListNode<T>?,
	Length: number
}

--[=[
@within LinkedList
@param ... T
@return LinkedList<T>
Creates a new linked list.
]=]
function LinkedList.new<T>(...: T): LinkedList<T>
	local self = setmetatable({}, LinkedList)
	local elements = {...} 

	self.Length = #elements
	self.Head = elements[1]
	self.Tail = elements[self.Length]

	if self.Length < 2 then
		return self
	end

	for i = 1, self.Length do
		local current = elements[i]
		current.Next = elements[i + 1]  
		current.Prev = elements[i - 1]  
	end

	return self
end

--[=[
@within LinkedList
@param Value T
Pushes a value to the right of the linked list.
]=]
function LinkedList:PushRight<T>(Value: T)
	local node = {
		Next = nil,
		Prev = self.Tail,
		Value = Value,
		Index = self.Length + 1
	}

	if self.Tail then
		self.Tail.Next = node
	else
		self.Head = node
	end

	self.Tail = node
	self.Length += 1
end

--[=[
@within LinkedList
@param Value T
Pushes a value to the left of the linked list.
]=]
function LinkedList:PushLeft<T>(Value: T)
	local node = {
		Next = self.Head,
		Prev = nil,
		Value = Value,
		Index = 1
	}

	if self.Head then
		local current = self.Head
		while current do
			current.Index += 1
			current = current.Next
		end
		self.Head.Prev = node
	else
		self.Tail = node
	end

	self.Head = node
	self.Length += 1
end

--[=[
@within LinkedList
@return T?
Pops a value from the right of the linked list.
]=]
function LinkedList:PopRight<T>(): T?
	if not self.Tail then
		return nil
	end

	local Value = self.Tail.Value
	self.Tail = self.Tail.Prev

	if self.Tail then
		self.Tail.Next = nil
	else
		self.Head = nil
	end

	self.Length -= 1
	return Value
end

--[=[
@within LinkedList
@return T?
Pops a value from the left of the linked list.
]=]
function LinkedList:PopLeft<T>(): T?
	if not self.Head then
		return nil
	end

	local Value = self.Head.Value
	self.Head = self.Head.Next

	if self.Head then
		local current = self.Head
		while current do
			current.Index -= 1
			current = current.Next
		end
		self.Head.Prev = nil
	else
		self.Tail = nil
	end

	self.Length -= 1
	return Value
end

return LinkedList
