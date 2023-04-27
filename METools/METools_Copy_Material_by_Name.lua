-- Author: modelleicher
-- Name: METools | Copy Material by Name
-- Description: Copys materials from the first set of selections to the second set of selections according to the names of the items.
-- Icon:
-- Hide: no


-- HOW TO USE
-- This Script copies the Material from the first object in the selection to the second(or multiple) 
-- objects in the selection with the same name
-- 1. select all the objects, make sure you select the ones you want to copy from first
-- 2. run the script



-- get Selection first
local get = getSelection(0);

-- number of selected objects
local num = getNumSelected()

-- list of secondary selection (e.g. the ones where the material is added to)
local secondary = {}

-- find pairs, run through selection
for i = 1, num - 1 do
    local get = getSelection(i)
    local name = getName(get)

    -- run second time to find other existing items with same name
    for x = 1, getNumSelected() - 1 do
        local set = getSelection(x)
        local nameFound = getName(set)
        -- check for matching names
        -- check if set and get are different
        -- check if get is in the secondary list
        if nameFound == name and get ~= set and secondary[tostring(get)] == nil then
           setMaterial(set, getMaterial(get, 0), 0)
           secondary[tostring(set)] = true
           print("Material set from "..tostring(get).." to "..tostring(set).." name: "..tostring(name))
        end
    end

end

print("Copy Material by Name End")