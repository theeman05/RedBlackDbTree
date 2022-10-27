!!! info
	Assuming we have already [implimented RedBlackDbTree](implimentation.md) as `RedBlackDbTree`

### Retrieving the sorted array:
```lua
local result

local tree = RedBlackDbTree.new() -- Instantiate the tree
tree:AddAll(5,6,8,9,2,1,4,109) -- Add objects into the tree
tree:AddAll({3,7}) -- We can alternatively add objects like this
tree:Remove(109) -- Remove an object

result = tree:InOrderArray() -- Store the in-order array in `result`
print(result) -- print the result
```

When you run your game, the following should be printed to the console (you may need to expand the table):
```
{
	[1] = 1,
	[2] = 2,
	[3] = 3,
	[4] = 4,
	[5] = 5,
	[6] = 6,
	[7] = 7,
	[8] = 8,
	[9] = 9
}
```