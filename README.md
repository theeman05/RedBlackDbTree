<h1 align="center">RedBlackDbTree</h1>

<div align="center">
	A declarative Red Black Tree Module for Roblox Lua.
</div>

<div>&nbsp;</div>

## Installation

### Method 1: Roblox's built in `require` method

- Inside your script, you can `require` the module directly.

### Method 2: Model File (Roblox Studio)

- Download the rbxm model file from the [RedBlackDbTree GitHub](https://github.com/theeman05/School-Projects/tree/main/Personal/RedBlackDbTree)

- Insert the model into Roblox Studio in a place like `ReplicatedStorage`

## [Documentation](https://theeman05.github.io/RedBlackDbTree)
For a more detailed guide and examples, visit [the official RedBlackDbTree documentation](https://theeman05.github.io/RedBlackDbTree).

```lua
local RedBlackDbTree = require(11328824364) -- Impliment the module

local tree = RedBlackDbTree.new() -- Instantiate the tree
tree:AddAll(5,6,8,9,2,1,4,109) -- Add objects into the tree
tree:AddAll({3,7}) -- We can alternatively add objects like this
tree:Remove(109) -- Remove an object

tree:InOrderPrint()
```
