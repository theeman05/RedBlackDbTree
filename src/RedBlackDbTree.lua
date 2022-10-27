--[[	
	My version of the RedBlackTree, RedBlackNode.
	
	Converted most of the code from https://algs4.cs.princeton.edu/33balanced/RedBlackBST.java.html
	
	Since it was my version of the RedBlackTree, I added DB into the name after dbhs.
	
	Asset ID on roblox: 11328824364
	
	@author: dbhs (on Roblox) / theeman05 (on github)
	
	Note: If using mutable objects, changed objects must be updated using RedBlackDbTree:Update() to keep structure.
	
	Version: 2.05
--]]


local RedBlackNode = {}
local RedBlackDbTree = {}

local NULL_OBJECT_ERROR = "An object must be given"
local TREE_UNDERFLOW_ERROR = "No nodes in the tree"
local TREE_UPDATE_ERROR = "No properties were given to update"
local MUTATION_ERROR = "The given object isn't mutable and therefore cannot be updated."

local RED = true
local BLACK = false

--------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------ RedBlackNode ------------------------------------------------------------
do 
	RedBlackNode.__index = RedBlackNode
	
	-- Constructor for creating a RedBlackNode. object is expected. The others are optional
	function RedBlackNode.new(object : any, left : RedBlackNode, right : RedBlackNode, color : boolean) : RedBlackNode
		return setmetatable({
			Object = object;	-- The object of this node
			Left = left;		-- The node's left child	
			Right = right;		-- The node's right child
			Color = color;		-- The color of this node
		}, RedBlackNode)
	end
end

--------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------- RedBlackDbTree -----------------------------------------------------------
do
	RedBlackDbTree.__index = RedBlackDbTree
	
	-- Method for comparing objects with default arguments
	function defaultComparator(object1, object2)
		if object1 < object2 then 
			return -1 -- object1 is smaller than object2
		elseif object1 > object2 then
			return 1  -- object1 is larger than object2
		else
			return 0  -- object1 is equal to object2
		end
	end
	
	-- Constructor for creating a new RedBlackDbTree. A comparator can be given and determines the order children are stored
	function RedBlackDbTree.new(comparator : (object1 : any, object2 : any) -> number)
		return setmetatable({ -- The RedBlackDbTree Variables
			Objects = {}; 	-- Object dictionary {[object] = RedBlackNode}
			Root 	= nil;  -- Root Node
			Size 	= 0;	-- The number of non-null nodes in the tree
			Compare = comparator or defaultComparator;
		}, RedBlackDbTree)
	end
	
	----------------------------------------------------------------------
	------------------------ Node Helper Methods -------------------------
	
	-- Return true if a node is red, false if it is black
	function isRed(node : RedBlackNode)
		return node ~= nil and node.Color == RED or false
	end
	
	-- Get number of nodes in the tree
	function RedBlackDbTree.__len(self) : number
		return self.Size
	end
	
	-- Make the tree empty
	function RedBlackDbTree:Clear()
		self.Root = nil
		self.Size = 0
		table.clear(self.Objects)
	end

	-- Check if the tree is empty
	function RedBlackDbTree:IsEmpty() : boolean
		return self.Root == nil
	end
	
	----------------------------------------------------------------------
	---------------------------  Search Methods --------------------------
	
	-- Finds the node of the given object (null if not present)
	function getNode(self, object : any) : RedBlackNode
		return self.Objects[object]
	end
	
	-- Determine if the tree has the given object
	function RedBlackDbTree:ContainsObject(object : any) : boolean
		return getNode(self, object) ~= nil
	end
	
	-- Update the tree by removing and re-adding the object. The items in the dictionary will be applied to the object
	function RedBlackDbTree:UpdateObject(object : any, dictionary : {})
		assert(type(object) == "table" or type(object) == "userdata", MUTATION_ERROR)
		assert(dictionary, TREE_UPDATE_ERROR)
		
		self:Remove(object)
		
		for property, update in dictionary do
			object[property] = update
		end
		
		self:Add(object)
	end
	
	----------------------------------------------------------------------
	---------------------- RedBlackDbTree Insertion ----------------------
	
	-- Method for adding a new node into the tree
	function RedBlackDbTree:Add(newObject : any)
		assert(newObject, NULL_OBJECT_ERROR)
		if self:ContainsObject(newObject) then return end
		
		self.Root = add(self, self.Root, newObject)
		self.Root.Color = BLACK
		self.Size += 1
	end
	
	-- Add the object into the given node and return the new node. If it is new, add it to the Objects dictionary
	function add(self, node : RedBlackNode, newObject) : RedBlackNode
		if not node then
			node = RedBlackNode.new(newObject, nil, nil, RED)
			self.Objects[newObject] = node
			return node
		end
		
		local cmp = self.Compare(newObject, node.Object)
		if cmp < 0 then
			node.Left = add(self, node.Left, newObject)
		elseif cmp > 0 then
			node.Right = add(self, node.Right, newObject)
		end
		
		-- Fix any right-leaning links
		if isRed(node.Right) and not isRed(node.Left) then
			node = rotateLeft(node)
		end
		if isRed(node.Left) and isRed(node.Left.Left) then
			node = rotateRight(node)
		end
		if isRed(node.Left) and isRed(node.Right) then
			flipColors(node)
		end
		
		return node
	end
	
	-- Add multiple objects passed as a tuple or a table. If one element which is a table gets passed, it is assumed the objects within the table should be added.
	function RedBlackDbTree:AddAll(...)
		assert(..., NULL_OBJECT_ERROR)
		local o1, o2 = ...
		for _, object in pairs(o2 and {...} or o1) do
			self:Add(object)
		end
	end
	
	----------------------------------------------------------------------
	---------------------- RedBlackDbTree Deletion -----------------------
	
	-- Remove the given key from the tree and reduce the size. Key is expected to be in the tree.
	function removeKeyFromTree(self, key)
		self.Size -= 1
		self.Objects[key] = nil
	end
	
	-- Removes the smallest node from the table
	function RedBlackDbTree:RemoveMin()
		assert(not self:IsEmpty(), TREE_UNDERFLOW_ERROR)
		
		-- Check if both children of the root are black and set the root to red
		if not (isRed(self.Root.Left) or isRed(self.Root.Right))then
			self.Root.Color = RED
		end
		
		self.Root = removeMin(self, self.Root)
		
		if not self:IsEmpty() then
			self.Root.Color = BLACK
		end
	end
	
	function removeMin(self, node : RedBlackNode) : RedBlackNode
		if node.Left == nil then
			return nil
		end
		
		if not (isRed(node.Left) or isRed(node.Left.Left)) then
			node = moveRedLeft(node)
		end
		
		local prevLeft = node.Left
		node.Left = removeMin(self, node.Left)
		
		if node.Left == nil then
			removeKeyFromTree(self, prevLeft.Object)
		end
		
		return balance(node)
	end
	
	-- Removes the largest node from the table
	function RedBlackDbTree:RemoveMax()
		assert(not self:IsEmpty(), TREE_UNDERFLOW_ERROR)

		-- Check if both children of the root are black and set the root to red
		if not (isRed(self.Root.Left) or isRed(self.Root.Right)) then
			self.Root.Color = RED
		end
		
		self.Root = removeMax(self, self.Root)

		if not self:IsEmpty() then
			self.Root.Color = BLACK
		end
	end
	
	function removeMax(self, node : RedBlackNode) : RedBlackNode
		if isRed(node.Left) then
			node = rotateRight(node)
		end
		
		if node.Right == nil then
			return nil
		end
		
		if not (isRed(node.Right) or isRed(node.Right.Left)) then
			node = moveRedRight(node)
		end
		
		local prevRight = node.Right
		node.Right = removeMax(self.Objects, node.Right)
		
		if node.Right == nil then
			removeKeyFromTree(self, prevRight.Object)
		end
		
		return balance(node)
	end
	
	-- Removes the node with the given object
	function RedBlackDbTree:Remove(object : any)
		assert(object, NULL_OBJECT_ERROR)

		if not self:ContainsObject(object) then
			return
		end

		-- if both children of root are black, set root to red
		if not (isRed(self.Root.Left) or isRed(self.Root.Right)) then
			self.Root.Color = RED
		end
		
		removeKeyFromTree(self, object)
		self.Root = remove(self, self.Root, object)
		
		if not self:IsEmpty() then
			self.Root.Color = BLACK
		end
	end
	
	-- Removes the nodes with the given objects
	function RedBlackDbTree:RemoveAll(...)
		assert(..., NULL_OBJECT_ERROR)
		local o1, o2 = ...
		for _, object in pairs(o2 and {...} or o1) do
			self:Remove(object)
		end
	end
	
	-- Delete the node with the given object rooted at node
	function remove(self, node : RedBlackNode, object) : RedBlackNode
		if not node then return nil end
		if self.Compare(object, node.Object) < 0 then -- if object is smaller than the current
			if node.Left and not (isRed(node.Left) or isRed(node.Left.Left)) then
				node = moveRedLeft(node)
			end
			node.Left = remove(self, node.Left, object)
		else
			if isRed(node.Left) then
				node = rotateRight(node)
			end
			if self.Compare(object, node.Object) == 0 and node.Right == nil then
				return nil
			end
			if node.Right and not (isRed(node.Right) or isRed(node.Right.Left)) then
				node = moveRedRight(node)
			end
			if self.Compare(object, node.Object) == 0 then
				node.Object = min(node.Right).Object
				node.Right = removeMin(self, node.Right)
				self.Objects[node.Object] = node
			else
				node.Right = remove(self, node.Right, object)
			end
		end
		return balance(node)
	end
	
	----------------------------------------------------------------------
	---------------------- RedBlackDbTree Helpers ------------------------
	
	-- make a left-leaning link lean right
	function rotateRight(prevRoot : RedBlackNode) : RedBlackNode
		assert(prevRoot ~= nil and isRed(prevRoot.Left))
		
		local leftChild = prevRoot.Left
		prevRoot.Left = leftChild.Right
		leftChild.Right = prevRoot
		leftChild.Color = prevRoot.Color
		prevRoot.Color = RED
		
		return leftChild
	end
	
	-- Make a right-leaning tree lean left
	function rotateLeft(prevRoot : RedBlackNode) : RedBlackNode
		assert(prevRoot ~= nil and isRed(prevRoot.Right))
		
		local rightChild = prevRoot.Right
		prevRoot.Right = rightChild.Left
		rightChild.Left = prevRoot
		rightChild.Color = prevRoot.Color
		prevRoot.Color = RED
		
		return rightChild
	end
	
	-- flip the colors of a node and its two children
	function flipColors(node : RedBlackNode)
		node.Color = not node.Color
		if node.Left then
			node.Left.Color = not node.Left.Color
		end
		if node.Right then
			node.Right.Color = not node.Right.Color
		end
	end
	
	-- Assuming node is red and both its left and left's left are black, make its left or one of its children red
	function moveRedLeft(node : RedBlackNode) : RedBlackNode
		flipColors(node)
		
		if node.Right and isRed(node.Right.Left) then
			node.Right = rotateRight(node.Right)
			node = rotateLeft(node)
			flipColors(node)
		end
		return node
	end 
	
	-- Assuming node is red and both its right and right's left are black, make its right or one of its children red
	function moveRedRight(node : RedBlackNode) : RedBlackNode
		flipColors(node)

		if node.Left and isRed(node.Left.Left) then
			node = rotateRight(node)
			flipColors(node)
		end
		return node
	end 
	
	-- Restore red-black tree invariant
	function balance(node : RedBlackNode) : RedBlackNode
		if not node then return end
		if isRed(node.Right) and not isRed(node.Left) then
			node = rotateLeft(node)
		end
		if isRed(node.Left) and isRed(node.Left.Left) then
			node = rotateRight(node)
		end
		if isRed(node.Left) and isRed(node.Right) then
			flipColors(node)
		end
			
		return node
	end
	
	----------------------------------------------------------------------
	------------------------- Utility Function ---------------------------
	
	-- returns the height of the tree. A 1-node tree has height 0
	function RedBlackDbTree:Height() : number
		return height(self.Root)
	end
	
	function height(node : RedBlackNode) : number
		return node ~= nil and 1 + math.max(height(node.Left), height(node.Right)) or -1
	end
	
	----------------------------------------------------------------------
	---------------------------- Tree Methods ----------------------------
	
	-- Return the smallest object in the tree
	function RedBlackDbTree:Min() : any
		assert(not self:IsEmpty(), TREE_UNDERFLOW_ERROR)
		return min(self.Root).Object
	end
	
	-- The smallest node in subtree rooted at node; null if no node present
	function min(node : RedBlackNode) : RedBlackNode
		return node.Left and min(node.Left) or node
	end
	
	-- Returns the largest object in the tree
	function RedBlackDbTree:Max() : any
		assert(not self:IsEmpty(), TREE_UNDERFLOW_ERROR)
		return max(self.Root).Object
	end
	
	-- The largest node in the tree
	function max(node : RedBlackNode) : RedBlackNode
		return node.Right and max(node.Right) or node
	end
	
	----------------------------------------------------------------------
	---------------------- Traversal Data Methods ------------------------
	
	-- Returns an array of objects in the tree in the order: Parent, Left, Right
	function RedBlackDbTree:PreOrderArray() : {any}
		local t = {}
		preOrderArray(self.Root, t)
		return t
	end

	function preOrderArray(node : RedBlackNode, array)
		if node ~= nil then
			table.insert(array, node.Object)
			preOrderArray(node.Left, array)
			preOrderArray(node.Right, array)
		end
	end

	-- Returns an array of objects in the tree in the order: Left, Parent, Right
	function RedBlackDbTree:InOrderArray() : {any}
		local t = {}
		inOrderArray(self.Root, t)
		return t
	end

	function inOrderArray(node : RedBlackNode, array)
		if node ~= nil then
			inOrderArray(node.Left, array)
			table.insert(array, node.Object)
			inOrderArray(node.Right, array)
		end
	end

	-- Returns an array of objects in the tree in the order: Left, Right, Parent
	function RedBlackDbTree:PostOrderArray() : {any}
		local t = {}
		postOrderArray(self.Root, t)
		return t
	end

	function postOrderArray(node : RedBlackNode, array)
		if node ~= nil then
			postOrderArray(node.Left, array)
			postOrderArray(node.Right, array)
			table.insert(array, node.Object)
		end
	end
	
	----------------------------------------------------------------------
	---------------------- Traversal Print Methods ------------------------
	
	-- If the node object is an instance, print it's name. else print the object
	function printNameOrObject(node : RedBlackNode)
		if type(node.Object) == "userdata" then
			print(node.Object.Name.. " Color: ".. (node.Color and "R" or "B"))
		else
			print(node.Object.. " Color: ".. (node.Color and "R" or "B"))
		end
	end
	
	-- Print the tree in the order: Parent, Left, Right
	function RedBlackDbTree:PreOrderPrint()
		preOrderPrint(self.Root)
	end
	
	function preOrderPrint(node : RedBlackNode)
		if node ~= nil then
			printNameOrObject(node)
			preOrderPrint(node.Left)
			preOrderPrint(node.Right)
		end
	end
	
	-- Print the tree in the order: Left, Parent, Right
	function RedBlackDbTree:InOrderPrint()
		inOrderPrint(self.Root)
	end
	
	function inOrderPrint(node : RedBlackNode)
		if node ~= nil then
			inOrderPrint(node.Left)
			printNameOrObject(node)
			inOrderPrint(node.Right)
		end
	end
	
	-- Print the tree in the order: Left, Right, Parent
	function RedBlackDbTree:PostOrderPrint()
		postOrderPrint(self.Root)
	end

	function postOrderPrint(node : RedBlackNode)
		if node ~= nil then
			postOrderPrint(node.Left)
			postOrderPrint(node.Right)
			printNameOrObject(node)
		end
	end
end

return RedBlackDbTree