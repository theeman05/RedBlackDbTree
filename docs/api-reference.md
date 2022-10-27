## Summary

RedBlackDbTree is a utility module allowing sorting of objects based on their natural order or a given comparator. 

RedBlackDbTree has a special function called [RedBlackDbTree.new()](#redblackdbtreenew) which is used to [instantiate](../guide/implimentation) a new RedBlackDbTree Instance. This function can take a comparator as a parameter to compare and sort objects by. 

### Methods
<div class="highlight"><pre><span></span><code><span><a href="#add">Add</a>(object: any): nil</span>
</code></pre></div>
&nbsp;&nbsp;Adds the given object to the tree, if it isn't already in the tree.

<div class="highlight"><pre><span></span><code><span><a href="#addall">AddAll</a>(...): nil</span>
</code></pre></div>
&nbsp;&nbsp;Adds the given objects to the tree using [Add](#add).

<div class="highlight"><pre><span></span><code><span><a href="#remove">Remove</a>(object: any): nil</span>
</code></pre></div>
&nbsp;&nbsp;Removes the given object from the tree, if it is present in the tree.

<div class="highlight"><pre><span></span><code><span><a href="#removeall">RemoveAll</a>(...): nil</span>
</code></pre></div>
&nbsp;&nbsp;Removes the given objects to the tree using [Remove](#remove).

<div class="highlight"><pre><span></span><code><span><a href="#containsobject">ContainsObject</a>(object): nil</span>
</code></pre></div>
&nbsp;&nbsp;Returns true if the tree contains the given object, false otherwise.

<div class="highlight"><pre><span></span><code><span><a href="#updateobject">UpdateObject</a>(object, dict{[property] = update}): nil</span>
</code></pre></div>
&nbsp;&nbsp;Applies the updates given in the dictionary to the object.

<div class="highlight"><pre><span></span><code><span><a href="#clear">Clear</a>(): nil</span>
</code></pre></div>
&nbsp;&nbsp;Removes all objects from the tree, making it empty.

<div class="highlight"><pre><span></span><code><span><a href="#isempty">IsEmpty</a>(): nil</span>
</code></pre></div>
&nbsp;&nbsp;Returns true if the tree is empty, false otherwise.

<div class="highlight"><pre><span></span><code><span><a href="#height">Height</a>(): number</span>
</code></pre></div>
&nbsp;&nbsp;Returns the height of the tree. A one-node tree has height 0.

<div class="highlight"><pre><span></span><code><span><a href="#__len">__len</a>(): number</span>
</code></pre></div>
&nbsp;&nbsp;Returns the number of non-nil nodes in the tree accesed by the # size operator.

<div class="highlight"><pre><span></span><code><span><a href="#min">Min</a>(): object</span>
</code></pre></div>
&nbsp;&nbsp;Returns smallest object in the tree

<div class="highlight"><pre><span></span><code><span><a href="#max">Max</a>(): object</span>
</code></pre></div>
&nbsp;&nbsp;Returns largest object in the tree

<div class="highlight"><pre><span></span><code><span><a href="#removemin">RemoveMin</a>(): nil</span>
</code></pre></div>
&nbsp;&nbsp;Removes the smallest object from the tree.

<div class="highlight"><pre><span></span><code><span><a href="#removemax">RemoveMax</a>(): nil</span>
</code></pre></div>
&nbsp;&nbsp;Removes the largest object from the tree.

<div class="highlight"><pre><span></span><code><span><a href="#preorderarray">PreOrderArray</a>(): {object}</span>
</code></pre></div>
&nbsp;&nbsp;Returns a new array of the tree's objects in pre-order format.

<div class="highlight"><pre><span></span><code><span><a href="#inorderarray">InOrderArray</a>(): {object}</span>
</code></pre></div>
&nbsp;&nbsp;Returns a new array of the tree's objects in the in-order format.

<div class="highlight"><pre><span></span><code><span><a href="#postorderarray">PostOrderArray</a>(): {object}</span>
</code></pre></div>
&nbsp;&nbsp;Returns a new array of the tree's objects in post-order format.

<div class="highlight"><pre><span></span><code><span><a href="#preorderprint">PreOrderPrint</a>(): nil</span>
</code></pre></div>
&nbsp;&nbsp;Prints the tree's objects in pre-order format.

<div class="highlight"><pre><span></span><code><span><a href="#inorderprint">InOrderPrint</a>(): nil</span>
</code></pre></div>
&nbsp;&nbsp;Prints the tree's objects in the in-order format.

<div class="highlight"><pre><span></span><code><span><a href="#postorderprint">PostOrderPrint</a>(): nil</span>
</code></pre></div>
&nbsp;&nbsp;Prints the tree's objects in post-order format.

---

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
RedBlackDbTree.new(comparator: (object1, object2) -> number) -> RedBlackDbTree
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
self:Add(object: any)
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
self:Remove(object: any)
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
self:UpdateObject(object, dict: {[property] = update})
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
Removes the smallest object from the tree.

!!! caution
	An error will be produced if there are no objects in the tree.

---

### RemoveMax
```qvt
self:RemoveMax()
```
Removes the largest object from the tree

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