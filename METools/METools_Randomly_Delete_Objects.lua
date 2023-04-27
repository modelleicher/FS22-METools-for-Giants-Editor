-- Author:Admin
-- Name:METools | Randomly Delete Objects
-- Description: Randomly deletes items within the transformgroup according to given percentage
-- Icon:
-- Hide: no


-- HOW TO USE:
-- 1. set the "percentageToDelete" below to the percent amount of items that should be removed
-- 2. select a transformGroup containing the Items which a percentage should be deleted
-- 3. run the script

-- OPTIONAL:
-- create a TransformGroup called "METools | Randomly Delete Objects | Settings" as child of root
-- add a integer UserAttribute "Percentage To Delete"
-- you can now set the percentage there instead of in the script if you don't want to have the script editor open.

-- change this vlaue to set the percentage of how much of the selected items should 
-- be deleted randomly
local percentageToDelete = 20


-- NO CHANGES BELOW HERE

-- obligatory getNoNil func
function getNoNil(value, backup)
    if value == nil then
        return backup
    end
    return value
end

-- get optional settings TG
local settingsNode = getChild(getChildAt(getRootNode(), 0), "METools | Randomly Delete Objects | Settings")

-- get values from userAttributes on fieldTG instead of script header (optional)
if settingsNode ~= nil and settingsNode ~= 0 then
    percentageToDelete = getNoNil(getUserAttribute(settingsNode, "Percentage To Delete"), percentageToDelete) 
end

local selection = getSelection(0)

local initialItemsCount = getNumOfChildren(selection)

local loopCount = math.floor(initialItemsCount * (percentageToDelete / 100))

for i = 1, loopCount do
    local numOfChildren = getNumOfChildren(selection)
    local deleteIndex = math.random(0, numOfChildren -1)
    
    delete(getChildAt(selection, deleteIndex))

end

print(tostring(loopCount).." Items were deleted.")





