## Constructors

### RedBlackDbTree.new
```qvt
RedBlackDbTree.new() -> RedBlackDBTree
```
Creates a new, empty RedBlackDbTree using the natural ordering of its objects. 

!!! caution
	The only objects who may be sorted by the default comparator are Strings, numbers or Metatables with comparison methods.

---

```qvt
RedBlackDbTree.new(comparator : (object1, object2) -> number) -> RedBlackDbTree
```
Creates a new, empty RedBlackDbTree, ordered according to the given `comparator`.

The comparator should take two arguments representing the objects passed into it. The main 3 cases are listed below:

- If `object1` is "smaller" than `object2`, a negative number should be returned

- If `object1` is "greater" than `object2`, a positive number should be returned

- If the two objects are considered equal, 0 should be returned

---

## Methods

!!! info
	`self` is an active RedBlackDbTree Instance.

### Add
```qvt
self:Add(object : any)
```
Adds `object` to the tree, given it is not in the array already.

!!! caution
	If `object` is mutable, it must be updated using `UpdateObject`.
	Alternatively, the object can be removed, updated then added back in.

---

### AddAll
```qvt
self:AddAll(...)
```
Adds all the given objects in the tuple `...`

If one object is given, it is assumed to be a table in which all values will be added.

---

### Remove
```qvt
self:Remove(object : any)
```
Removes `object` from the tree.

---

### RemoveAll
```qvt
self:RemoveAll(...)
```
Removes all the given objects in the tuple `...`

If one object is given, it is assumed to be a table in which all values will be removed.

---

### ContainsObject
```qvt
self:ContainsObject(object) -> boolean
```
Returns true if the tree contains `object`, false otherwise.

---

### UpdateObject
```qvt
self:UpdateObject(object, dict : {[property] = update})
```
- Removes the `object` from the tree

- Applies the `update` to the `property` of the `object` for all properties in `dict`

- Adds the updated `object` back into the tree at its correct location

!!! caution
	Only mutable objects may be updated this way. An error will be thrown otherwise.

---

### Clear
```qvt
self:Clear()
```
Remove all objects from the tree, making it empty.

---

### IsEmpty
```qvt
self:IsEmpty() -> boolean
```
Returns true if the tree is empty, false otherwise.

---

### Height
```qvt
self:Height()
```
Returns the height of the tree. A one-node tree has height 0.

---

### __len
```qvt
#self -> number
```
Returns the number of non-nil nodes in the tree. `self` should be a RedBlackDbTree instance.

---

### Min
```qvt
self:Min() -> object
```
Returns the smallest object in the tree.

!!! caution
	An error will be produced if there are no objects in the tree.

---

### Max
```qvt
self:Max() -> object
```
Returns the largest object in the tree.

!!! caution
	An error will be produced if there are no objects in the tree.

---

### RemoveMin
```qvt
self:RemoveMin()
```
Removes the "smallest" object from the tree.

!!! caution
	An error will be produced if there are no objects in the tree.

---

### RemoveMax
```qvt
self:RemoveMax()
```
Removes the "largest" object from the tree

!!! caution
	An error will be produced if there are no objects in the tree.

---

### PreOrderArray
```qvt
self:PreOrderArray() -> {object}
```
Returns a new array of the tree's objects in pre-order format.

---

### InOrderArray
```qvt
self:InOrderArray() -> {object}
```
Returns a new array of the tree's objects in the in-order format.

---

### PostOrderArray
```qvt
self:PostOrderArray() -> {object}
```
Returns a new array of the tree's objects in post-order format.

---

### PreOrderPrint
```qvt
self:PreOrderPrint()
```
Prints the tree's objects in pre-order format.

---

### InOrderPrint
```qvt
self:InOrderPrint()
```
Prints the tree's objects in the in-order format.

---

### PostOrderPrint
```qvt
self:PostOrderPrint()
```
Prints the tree's objects in post-order format.