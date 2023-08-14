return function()
    local tree
    local rbtree = require(script.Parent.rbtree)
    beforeEach(function()
        tree = rbtree.new()
    end)

    local function checkEqual(arr1, arr2)
        if #arr1 ~= #arr2 then
            return false
        end

        for i = 1, #arr1 do
            if arr1[i] ~= arr2[i] then
                return false
            end
        end

        return true
    end

    local function deepEquals(arr1, arr2)
        if #arr1 ~= #arr2 then
            return false
        end
        for i = 1, #arr1 do
            if type(arr1[i]) == "table" and type(arr2[i]) == "table" then
                if not deepEquals(arr1[i], arr2[i]) then
                    return false
                end
            elseif arr1[i] ~= arr2[i] then
                return false
            end
        end
        return true
    end

    describe("rbtree", function()
        it("should work for primitives", function()
            tree:AddAll(5,6,8,9,2,1,4,109) -- Add objects into the tree
            tree:AddAll({3,7}) -- We can alternatively add objects like this
            tree:Remove(109) -- Remove an object

            local arr = tree:InOrderArray()
            print(arr)
            expect(checkEqual(arr, {1,2,3,4,5,6,7,8,9})).to.equal(true)
        end)

        it("should work for objects", function()
            tree.Compare = function(a,b)
                return a.v < b.v and -1 or a.v > b.v and 1 or 0
            end -- Instantiate the tree
            
            local t = {
                {v = 5},
                {v = 6},
                {v = 8},
                {v = 9},
                {v = 2},
                {v = 1},
                {v = 4},
                {v = 3},
                {v = 7},
            }
            tree:AddAll(t)

            for i = 1, 5 do
                tree:Remove(t[i])
            end

            local arr = tree:InOrderArray()
            expect(deepEquals(arr, {
                {v = 1},
                {v = 3},
                {v = 4},
                {v = 7},
            })).to.equal(true)
        end)
    end)
end