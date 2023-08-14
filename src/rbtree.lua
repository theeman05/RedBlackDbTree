--RedBlackDbTree.lua
--Optimized by iiau, Sun Aug 13 2023

--[[	
	My version of the RedBlackTree, RedBlackNode.
	
	Converted most of the code from https://algs4.cs.princeton.edu/33balanced/RedBlackBST.java.html
	
	Since it was my version of the RedBlackTree, I added DB into the name after dbhs.
	
	Asset ID on roblox: 11328824364
	
	@author: dbhs (on Roblox) / theeman05 (on github)
	
	Note: If using mutable objects, changed objects must be updated using RedBlackDbTree:Update() to keep structure.
	
	Version: 2.06

	Reference:
	https://theeman05.github.io/RedBlackDbTree/api-reference/
--]]

--[[
	new(comparer(a, b) -> tuple<1, 2, 3>)

	_debug_inOrder()
    _debug_postOrder()
    _debug_preOrder()
    add(value)
    addAll(...)
    clear()
    erase(value)
    eraseBack()
    eraseFront()
    max()
    min()
    inOrderArray()
    postOrderArray()
    preOrderArray()
    remove(value)
    update(value)

	exists(value) -> boolean
	empty() -> boolean
    size() -> int
]]

local RedBlackNode = {}
local RedBlackDbTree = {}

local NULL_OBJECT_ERROR = "An object must be given"
local TREE_UNDERFLOW_ERROR = "No nodes in the tree"
local TREE_UPDATE_ERROR = "No properties were given to update"
local MUTATION_ERROR = "The given object isn't mutable and therefore cannot be updated."

local RED = true
local BLACK = false

--
-- RedBlackNode --
do 
	RedBlackNode.__index = RedBlackNode
	
	-- Constructor for creating a RedBlackNode. object is expected. The others are optional
	RedBlackNode.new = function(object : any, left : RedBlackNode, right : RedBlackNode, color : boolean) : RedBlackNode
		return setmetatable({
			data = object;	-- The object of this node
			l = left;		-- The node's left child	
			r = right;		-- The node's right child
			c = color;		-- The color of this node
		}, RedBlackNode)
	end
end
type RedBlackNode = typeof(RedBlackNode.new())
local isRed, getNode, add, removeKeyFromTree, removeMin, removeMax, remove, rotateLeft, flipColors, moveRedLeft, moveRedRight, balance, height, min, max, preOrderArray, inOrderArray, postOrderArray, printNameOrObject, preOrderPrint, inOrderPrint, postOrderPrint, rotateRight

-- RedBlackDbTree --
do
	RedBlackDbTree.__index = RedBlackDbTree
	
	-- Method for comparing objects with default arguments
	local function defaultComparator(object1, object2)
		return object1 < object2 and -1 or object1 > object2 and 1 or 0
	end
	
	-- Constructor for creating a new RedBlackDbTree. A comparator can be given and determines the order children are stored
	RedBlackDbTree.new = function(comparator : (object1 : any, object2 : any) -> number)
		return setmetatable({ -- The RedBlackDbTree Variables
			Objects = {}; 	-- Object dictionary {[object] = RedBlackNode}
			Root 	= nil;  -- Root Node
			Size 	= 0;	-- The number of non-null nodes in the tree
			Compare = comparator or defaultComparator;
		}, RedBlackDbTree)
	end
	
	-- Helper Methods --

	-- Return true if a node is red, false if it is black
	function isRed(node : RedBlackNode)
		return node ~= nil and node.c == RED or false
	end
	
	-- Finds the node of the given object (null if not present)
	function getNode(self, object : any) : RedBlackNode
		return self.Objects[object]
	end

	-- Add the object into the given node and return the new node. If it is new, add it to the Objects dictionary
	function add(self, node : RedBlackNode, newObject) : RedBlackNode
		if not node then
			node = RedBlackNode.new(newObject, nil, nil, RED)
			self.Objects[newObject] = node
			return node
		end
		
		local cmp = self.Compare(newObject, node.data)
		if cmp < 0 then
			node.l = add(self, node.l, newObject)
		elseif cmp > 0 then
			node.r = add(self, node.r, newObject)
		end
		
		-- Fix any right-leaning links
		if isRed(node.r) and not isRed(node.l) then
			node = rotateLeft(node)
		end
		if isRed(node.l) and isRed(node.l.l) then
			node = rotateRight(node)
		end
		if isRed(node.l) and isRed(node.r) then
			flipColors(node)
		end
		
		return node
	end

	-- Remove the given key from the tree and reduce the size. Key is expected to be in the tree.
	function removeKeyFromTree(self, key)
		self.Size -= 1
		self.Objects[key] = nil
	end

	function removeMin(self, node : RedBlackNode) : RedBlackNode
		if node.l == nil then
			return nil
		end
		
		if not (isRed(node.l) or isRed(node.l.l)) then
			node = moveRedLeft(node)
		end
		
		local prevLeft = node.l
		node.l = removeMin(self, node.l)
		
		if node.l == nil then
			removeKeyFromTree(self, prevLeft.data)
		end
		
		return balance(node)
	end

	function removeMax(self, node : RedBlackNode) : RedBlackNode
		if isRed(node.l) then
			node = rotateRight(node)
		end
		
		if node.r == nil then
			return nil
		end
		
		if not (isRed(node.r) or isRed(node.r.l)) then
			node = moveRedRight(node)
		end
		
		local prevRight = node.r
		node.r = removeMax(self.Objects, node.r)
		
		if node.r == nil then
			removeKeyFromTree(self, prevRight.data)
		end
		
		return balance(node)
	end

	
	-- Delete the node with the given object rooted at node
	function remove(self, node : RedBlackNode, object) : RedBlackNode
		if not node then return nil end
		if self.Compare(object, node.data) < 0 then -- if object is smaller than the current
			if node.l and not (isRed(node.l) or isRed(node.l.l)) then
				node = moveRedLeft(node)
			end
			node.l = remove(self, node.l, object)
		else
			if isRed(node.l) then
				node = rotateRight(node)
			end
			if self.Compare(object, node.data) == 0 and node.r == nil then
				return nil
			end
			if node.r and not (isRed(node.r) or isRed(node.r.l)) then
				node = moveRedRight(node)
			end
			if self.Compare(object, node.data) == 0 then
				node.data = min(node.r).data
				node.r = removeMin(self, node.r)
				self.Objects[node.data] = node
			else
				node.r = remove(self, node.r, object)
			end
		end

		return balance(node)
	end
	
	-- Make a right-leaning tree lean left
	function rotateLeft(prevRoot : RedBlackNode) : RedBlackNode
		assert(prevRoot ~= nil and isRed(prevRoot.r), "Can't rotate left on a nil node or a node with a non-red right child")
		
		local rightChild = prevRoot.r
		prevRoot.r = rightChild.l
		rightChild.l = prevRoot
		rightChild.c = prevRoot.c
		prevRoot.c = RED
		
		return rightChild
	end

	-- make a left-leaning link lean right
	function rotateRight(prevRoot : RedBlackNode) : RedBlackNode
		assert(prevRoot ~= nil and isRed(prevRoot.l), "Can't rotate right on a nil node or a node with a non-red left child")
		
		local leftChild = prevRoot.l
		prevRoot.l = leftChild.r
		leftChild.r = prevRoot
		leftChild.c = prevRoot.c
		prevRoot.c = RED
		
		return leftChild
	end
	
	-- flip the colors of a node and its two children
	function flipColors(node : RedBlackNode)
		node.c = not node.c
		if node.l then
			node.l.c = not node.l.c
		end
		if node.r then
			node.r.c = not node.r.c
		end
	end
	
	-- Assuming node is red and both its left and left's left are black, make its left or one of its children red
	function moveRedLeft(node : RedBlackNode) : RedBlackNode
		flipColors(node)
		
		if node.r and isRed(node.r.l) then
			node.r = rotateRight(node.r)
			node = rotateLeft(node)
			flipColors(node)
		end
		return node
	end 
	
	-- Assuming node is red and both its right and right's left are black, make its right or one of its children red
	function moveRedRight(node : RedBlackNode) : RedBlackNode
		flipColors(node)

		if node.l and isRed(node.l.l) then
			node = rotateRight(node)
			flipColors(node)
		end
		return node
	end 
	
	-- Restore red-black tree invariant
	function balance(node : RedBlackNode) : RedBlackNode
		if not node then return end
		if isRed(node.r) and not isRed(node.l) then
			node = rotateLeft(node)
		end
		if isRed(node.l) and isRed(node.l.l) then
			node = rotateRight(node)
		end
		if isRed(node.l) and isRed(node.r) then
			flipColors(node)
		end
			
		return node
	end
	
	
	function height(node : RedBlackNode) : number
		return node ~= nil and 1 + math.max(height(node.l), height(node.r)) or -1
	end
	
-- The smallest node in subtree rooted at node; null if no node present
	function min(node : RedBlackNode) : RedBlackNode
		return node.l and min(node.l) or node
	end
	
	-- The largest node in the tree
	function max(node : RedBlackNode) : RedBlackNode
		return node.r and max(node.r) or node
	end

	function preOrderArray(node : RedBlackNode, array)
		if node ~= nil then
			table.insert(array, node.data)
			preOrderArray(node.l, array)
			preOrderArray(node.r, array)
		end
	end

	function inOrderArray(node : RedBlackNode, array)
		if node ~= nil then
			inOrderArray(node.l, array)
			table.insert(array, node.data)
			inOrderArray(node.r, array)
		end
	end

	function postOrderArray(node : RedBlackNode, array)
		if node ~= nil then
			postOrderArray(node.l, array)
			postOrderArray(node.r, array)
			table.insert(array, node.data)
		end
	end

	-- If the node object is an instance, print it's name. else print the object
	function printNameOrObject(node : RedBlackNode)
		if type(node.data) == "userdata" then
			print(node.data.Name.. " Color: ".. (node.c and "R" or "B"))
		else
			print(node.data.. " Color: ".. (node.c and "R" or "B"))
		end
	end

	function preOrderPrint(node : RedBlackNode)
		if node ~= nil then
			printNameOrObject(node)
			preOrderPrint(node.l)
			preOrderPrint(node.r)
		end
	end

	function inOrderPrint(node : RedBlackNode)
		if node ~= nil then
			inOrderPrint(node.l)
			printNameOrObject(node)
			inOrderPrint(node.r)
		end
	end
	
	function postOrderPrint(node : RedBlackNode)
		if node ~= nil then
			postOrderPrint(node.l)
			postOrderPrint(node.r)
			printNameOrObject(node)
		end
	end
end

-- Get number of nodes in the tree
function RedBlackDbTree:__len() : number
	return self.Size
end

-- Make the tree empty
function RedBlackDbTree:Clear()
	self.Root = nil
	self.Size = 0
	table.clear(self.Objects)
end
RedBlackDbTree.clear = RedBlackDbTree.Clear

-- Check if the tree is empty
function RedBlackDbTree:IsEmpty() : boolean
	return self.Root == nil
end
RedBlackDbTree.empty = RedBlackDbTree.IsEmpty
--
--  Search Methods --
-- Determine if the tree has the given object
function RedBlackDbTree:ContainsObject(object : any) : boolean
	return getNode(self, object) ~= nil
end
RedBlackDbTree.exists = RedBlackDbTree.ContainsObject

-- Update the tree by removing and re-adding the object. The items in the dictionary will be applied to the object
function RedBlackDbTree:UpdateObject(object : any, callback : (any) -> ())
	assert(type(object) == "table" or type(object) == "userdata", MUTATION_ERROR)
	assert(callback, TREE_UPDATE_ERROR)
	
	self:Remove(object)
	callback(object)
	self:Add(object)
end
RedBlackDbTree.update = RedBlackDbTree.UpdateObject
--
-- RedBlackDbTree Insertion --

-- Method for adding a new node into the tree
function RedBlackDbTree:Add(newObject : any)
	assert(newObject, NULL_OBJECT_ERROR)
	if self:ContainsObject(newObject) then return end
	
	self.Root = add(self, self.Root, newObject)
	self.Root.c = BLACK
	self.Size += 1
end
RedBlackDbTree.add = RedBlackDbTree.Add

-- Add multiple objects passed as a tuple or a table. If one element which is a table gets passed, it is assumed the objects within the table should be added.
function RedBlackDbTree:AddAll(...)
	assert(..., NULL_OBJECT_ERROR)
	local o1, o2 = ...
	for _, object in pairs(o2 and {...} or o1) do
		self:Add(object)
	end
end
RedBlackDbTree.addAll = RedBlackDbTree.AddAll

-- RedBlackDbTree Deletion --

-- Removes the smallest node from the table
function RedBlackDbTree:RemoveMin()
	assert(not self:IsEmpty(), TREE_UNDERFLOW_ERROR)
	
	-- Check if both children of the root are black and set the root to red
	if not (isRed(self.Root.l) or isRed(self.Root.r))then
		self.Root.c = RED
	end
	
	self.Root = removeMin(self, self.Root)
	
	if not self:IsEmpty() then
		self.Root.c = BLACK
	end
end
RedBlackDbTree.eraseFront = RedBlackDbTree.RemoveMin

-- Removes the largest node from the table
function RedBlackDbTree:RemoveMax()
	assert(not self:IsEmpty(), TREE_UNDERFLOW_ERROR)

	-- Check if both children of the root are black and set the root to red
	if not (isRed(self.Root.l) or isRed(self.Root.r)) then
		self.Root.c = RED
	end
	
	self.Root = removeMax(self, self.Root)

	if not self:IsEmpty() then
		self.Root.c = BLACK
	end
end
RedBlackDbTree.eraseBack = RedBlackDbTree.RemoveMax

-- Removes the node with the given object
function RedBlackDbTree:Remove(object : any)
	assert(object, NULL_OBJECT_ERROR)

	if not self:ContainsObject(object) then
		return
	end

	-- if both children of root are black, set root to red
	if not (isRed(self.Root.l) or isRed(self.Root.r)) then
		self.Root.c = RED
	end
	
	removeKeyFromTree(self, object)
	self.Root = remove(self, self.Root, object)
	
	if not self:IsEmpty() then
		self.Root.c = BLACK
	end
end
RedBlackDbTree.remove = RedBlackDbTree.Remove

-- Removes the nodes with the given objects
function RedBlackDbTree:RemoveAll(...)
	assert(..., NULL_OBJECT_ERROR)
	local o1, o2 = ...
	for _, object in pairs(o2 and {...} or o1) do
		self:Remove(object)
	end
end
RedBlackDbTree.erase = RedBlackDbTree.RemoveAll

--
-- Utility function --

-- returns the height of the tree. A 1-node tree has height 0
function RedBlackDbTree:Height() : number
	return height(self.Root)
end
RedBlackDbTree.size = RedBlackDbTree.Height

--
-- Tree Methods --

-- Return the smallest object in the tree
function RedBlackDbTree:Min() : any
	assert(not self:IsEmpty(), TREE_UNDERFLOW_ERROR)
	return min(self.Root).data
end
RedBlackDbTree.min = RedBlackDbTree.Min

-- Returns the largest object in the tree
function RedBlackDbTree:Max() : any
	assert(not self:IsEmpty(), TREE_UNDERFLOW_ERROR)
	return max(self.Root).data
end
RedBlackDbTree.max = RedBlackDbTree.Max

--
-- Traversal Data Methods --

-- Returns an array of objects in the tree in the order: Parent, Left, Right
function RedBlackDbTree:PreOrderArray() : {any}
	local t = {}
	preOrderArray(self.Root, t)
	return t
end
RedBlackDbTree.preOrderArray = RedBlackDbTree.PreOrderArray

-- Returns an array of objects in the tree in the order: Left, Parent, Right
function RedBlackDbTree:InOrderArray() : {any}
	local t = {}
	inOrderArray(self.Root, t)
	return t
end
RedBlackDbTree.inOrderArray = RedBlackDbTree.InOrderArray

-- Returns an array of objects in the tree in the order: Left, Right, Parent
function RedBlackDbTree:PostOrderArray() : {any}
	local t = {}
	postOrderArray(self.Root, t)
	return t
end
RedBlackDbTree.postOrderArray = RedBlackDbTree.PostOrderArray
--
-- Traversal Print Methods --

-- Print the tree in the order: Parent, Left, Right
function RedBlackDbTree:_debug_preOrder()
	preOrderPrint(self.Root)
end

-- Print the tree in the order: Left, Parent, Right
function RedBlackDbTree:_debug_inOrder()
	inOrderPrint(self.Root)
end

-- Print the tree in the order: Left, Right, Parent
function RedBlackDbTree:_debug_postOrder()
	postOrderPrint(self.Root)
end


return RedBlackDbTree