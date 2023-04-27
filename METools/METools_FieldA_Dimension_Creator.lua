-- Author:modelleicher
-- Name:METools | FieldA | Dimension Creator

-- Description: Script for simple creation of field dimensions 
-- Icon:
-- Hide: no

-- HOW TO USE
-- this only works for convex fields!
-- Step 1: create a transformGroup, place it somewhere in the center of the field (further refered to as ParentTG)
-- Step 2: create a transformGroup as a template for the field*NUMBER* transform, it should have all the userAttributes the field*NUMBER* transform needs to have (further refered to as the TemplateTG)
--          This transform will be cloned for the field*NUMBER* transform group
-- Step 3: create Transformgroups (childs of ParentTG) and place at each "corner" of the field (hint, add a sphere at scale 0.3 inside the corner-TGs to have them easily located visually)
--          This can be as many corners as you want (note, not concave only convex) but since 
--          each corner creates 3 fieldDefinion corners.. don't overdo it
-- Step 4: select ParentTG, then hold Ctrl and select "fields" Transform, then hold Ctrl and select TemplateTG  
--          Now run the script.
--          This will now create the field*NUMBER* Transformgroup for the new field
--          and create the fieldMapIndicator at the ParentTG's place
--          and create all the fieldDimensions.
--          It will also add the userAttributes to the field*NUMBER* transform already using TemplateTG

-- custom functions needed
--------------------------

-- create mid point between vector a and b 
function getMidPoint(a, b)
    local returnValue = {}
    returnValue[1], returnValue[2], returnValue[3] = (a[1] + b[1]) / 2, (a[2] + b[2]) / 2, (a[3] + b[3]) / 2 
    return returnValue
end

-- create field definition corner 
function createCorner(fieldDimensions, a, b, c, prefixIndex, prefixLetter)
    local corner1_1 = createTransformGroup("cornerToolCreation"..tostring(prefixIndex)..tostring(prefixLetter).."A_1") 
    local corner1_2 = createTransformGroup("cornerToolCreation"..tostring(prefixIndex)..tostring(prefixLetter).."A_2") 
    local corner1_3 = createTransformGroup("cornerToolCreation"..tostring(prefixIndex)..tostring(prefixLetter).."A_3")     
      
    link(fieldDimensions, corner1_1)   
    link(corner1_1, corner1_2) 
    link(corner1_1, corner1_3) 

    setTranslation(corner1_1, worldToLocal(fieldDimensions, unpack(a)))
    setTranslation(corner1_2, worldToLocal(corner1_1, unpack(b)))  
    setTranslation(corner1_3, worldToLocal(corner1_1, unpack(c)))
end

-- store selections in variables
local centerPoint = getSelection(0)
local fieldsTG = getSelection(1)

local nodes = getNumOfChildren(centerPoint)


local grassField = getName(centerPoint) -- obsolete since userAttributes don't work 


-- get the center point vector  
local centerP = {}
centerP[1], centerP[2] , centerP[3] = getWorldTranslation(centerPoint)


-- get number of fields already existing 
local numberOfFields = getNumOfChildren(fieldsTG)

-- create fieldX TG
local number = numberOfFields + 1
if number < 10 then -- add 0 prefix for smaller than 10
    number = "0"..tostring(number)
end

-- clone the third selection, TemplateTG
local field = clone(getSelection(2), false)
link(fieldsTG, field)
setName(field, "field"..tostring(number))

-- setting userAttributes does not work apparantly so this code is obsolete right now - add attributes to TemplateTG instead so they get cloned 
setUserAttribute(field, "fieldAngle", "integer", 0)
setUserAttribute(field, "fieldDimensionIndex", "integer", 1)
setUserAttribute(field, "nameIndicatorIndex", "integer", 0)
if grassField == "grass" then
    setUserAttribute(field, "fieldGrassMission", "boolean", true)
end
--

-- create fieldMapIndicator
local fieldMapIndicator = createTransformGroup("fieldMapIndicator")
link(field, fieldMapIndicator)  
setTranslation(fieldMapIndicator, worldToLocal(field, unpack(centerP)))

-- create field dimensions TG
local fieldDimensions = createTransformGroup("fieldDimensions")       
link(field, fieldDimensions)    

-- cycle through all the outside points
for i = 0, nodes-1 do   
    
    -- get the current outside node
    local node = getChildAt(centerPoint, i)
    local currentP = {}
    currentP[1], currentP[2], currentP[3] = getWorldTranslation(node)

    -- get the next outside node, if we are at the last one, its the first
    local nextIndex = i+1 
    if nextIndex == nodes then
        nextIndex = 0
    end
    local nodeNext = getChildAt(centerPoint, nextIndex)
    local nextP = {}
    nextP[1], nextP[2], nextP[3] = getWorldTranslation(nodeNext)

    -- calculate the mid point between current and center
    local curCenterMidP = getMidPoint(currentP, centerP)

    -- calculate mid point between current and next
    local curNextMidP = getMidPoint(nextP, currentP)

    -- calculate mid point between next and center
    local nextCenterMidP = getMidPoint(nextP, centerP)

    -- create first parallelogram between current, curCenterMid and curNextMid
    local par1A = curCenterMidP
    local par1B = currentP
    local par1C = curNextMidP

    -- create the second parallelogram between next, nextMid and nextCenterMid
    local par2A = curNextMidP
    local par2B = nextP
    local par2C = nextCenterMidP

    -- create the third parallelogram between nextCenterMid, center and currentCenterMid
    local par3A = nextCenterMidP
    local par3B = centerP
    local par3C = curCenterMidP

    -- create corners
    createCorner(fieldDimensions, par1A, par1B, par1C, i, "A")
    createCorner(fieldDimensions, par2A, par2B, par2C, i, "B")
    createCorner(fieldDimensions, par3A, par3B, par3C, i, "C")


end
    print("Created Field Dimensions and Field 'field"..tostring(number).."'")




