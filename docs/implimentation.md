Add a new `Script` object to `ServerScriptService` in Roblox Studio.

### Using Method 1:
```lua
local RedBlackDbTree = require(11328824364) -- Impliment the module
```

### Using Method 2:
```lua
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RedBlackDbTree = require(ReplicatedStorage.RedBlackDbTree) -- Impliment the module
```

!!! info
	Method 2 assumes you've successfuly [installed RedBlackDbTree](installation.md) into `ReplicatedStorage`

### After using a provided method:
```lua
local tree = RedBlackDbTree.new() -- Instantiate the tree
tree:AddAll(5,6,8,9,2,1,4,109) -- Add objects into the tree
tree:AddAll({3,7}) -- We can alternatively add objects like this
tree:Remove(109) -- Remove an object

tree:InOrderPrint()
```

When you run your game, the following should be printed to the console:
```
1 Color: B
2 Color: B
3 Color: B
4 Color: B
5 Color: B
6 Color: R
7 Color: B
8 Color: B
9 Color: B
```

Congrats!