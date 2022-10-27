!!! info
	Assuming we have already [implimented RedBlackDbTree](implimentation.md) as `RedBlackDbTree`

In this example, we use `Part` objects.

### Utilizing mutable objects:
```lua
local START_POSITION = Vector3.new(-1, 0.5, 18) -- The start position for our parts
local PART_OFFSET = Vector3.new(4, 0, 0)

local removePart, movePart
local tree

function createNewPart(name, position)
	local part = Instance.new("Part")
	part.Anchored = true
	part.Position = position
	part.Name = name
	part.Parent = workspace
	
	return part
end

function partXComparator(part1, part2)
	if part1 == part2 or part1.Position.X == part2.Position.X then
		return 0  -- part1 equal to part2 or they have equal X positions
	elseif part1.Position.X < part2.Position.X then
		return -1 -- part1 is more left than other
	else
		return 1  -- part1 is more right than other
	end
end

tree = RedBlackDbTree.new(partXComparator) -- Instantiate the tree with the comparator

removePart = createNewPart("REMOVEME", START_POSITION)
movePart = createNewPart("MOVEME", START_POSITION + PART_OFFSET * 2)

tree:AddAll(createNewPart("P1", START_POSITION), createNewPart("P2", START_POSITION + PART_OFFSET), movePart, removePart) -- Add objects into the tree
tree:Remove(removePart) -- Remove `removePart`

tree:UpdateObject(movePart, {Position = START_POSITION - PART_OFFSET}) -- Move `movePart` left of P1

tree:InOrderPrint()
```

When you run your game, the following should be printed to the console:
```
MOVEME Color B
P1 Color B
P2 Color B
```

Since we updated `movePart` to be left of P1, it is now considered the "smallest".