!!! info
	Assuming we have already [implimented RedBlackDbTree](implimentation.md) as `RedBlackDbTree`

In this example, we create a custom comparator which sorts in decending order.

### Create a custom comparator:
```lua
local tree

function decOrderComparator(object1, object2)
	if object1 > object2 then
		return -1 -- object1 is larger than object2
	elseif object1 < object2 then
		return 1  -- object1 is smaller than object2
	else
		return 0  -- object1 is equal to object2
	end
end

tree = RedBlackDbTree.new(decOrderComparator) -- Instantiate the tree with the comparator

tree:AddAll(5,6,8,9,2,1,4,109) -- Add objects into the tree
tree:AddAll({3,7}) -- We can alternatively add objects like this
tree:Remove(109) -- Remove an object

tree:InOrderPrint()
```

When you run your game, the following should be printed to the console:
```
9 Color: B
8 Color: R
7 Color: B
6 Color: B
5 Color: B
4 Color: B
3 Color: B
2 Color: B
1 Color: B
```