-- Author:Admin
-- Name:METools | FieldB | Paint Farmlands and XML

-- Description: Painting Farmlands by using Field Dimensions, also adding the XML stuff to farmlands.xml
-- Icon:
-- Hide: no


-- How to Use:
-- 1. Go through the Values to be changed below and make sure the path to the farmlands.xml is correct.
-- 2. Make sure the farmlandIDToPaint is set to a farmland that doesn't exist yet or in case you want to add/overwrite to the one you want.
-- 3. make all the adjustments to the farmlands.xml entry you want
-- 4. select the field0X transform of the field you want to paint the farmland for
-- 5. execute the script.
-- NOTE: If the farmlandId already exists in the farmlands.xml it will overwrite that entry but give you an Info Print into the Log. 
--       If you did not intend to overwrite an existing farmland you need to chose another farmland ID and fix the farmlands.xml entry
--       for the overwritten farmland.


-- CHANGE VALUES HERE

-- ID of the Farmland to be painted (Make sure this ID Does not already exist of course!)
local farmlandIDToPaint = 4

-- The following values are for the farmlands.xml
-- priceScale -> the priceScale of the field
local priceScale = 0.33
-- the NPC Prefix for that particular map system (used for random NPC selection)
local npcNameWithoutNumber = "NPC_ALPINE_"
-- the max number of NPC's (used for random NPC selection)
local npcCount = 15
-- instead of random NPC's you can force a particular NPC for the current field
local npcForce = "NPC_ALPINE_2"
-- this needs to be true for the forced NPC to be used
local npcForceActive = false
-- if the farmland is shwon on ingame screen, default true
local showOnFarmlandsScreen = true
-- owned from the start, default false
local defaultFarmProperty = false
-- path the the farmlands.xml in the current map
local farmlandsXMLPath = "C:/Users/Admin/Documents/My Games/FarmingSimulator2022/mods/FS22_Lahntal/maps/mapAlpine/xml/farmlands.xml"

-- NO CHANGES BELOW HERE

function getNoNil(value, backup)
    if value == nil then
        return backup
    end
    return value
end

-- get terrain
local terrainNode = getChild(getChildAt(getRootNode(), 0), "terrain")

-- get farmland infoLayer
local farmlandsInfoLayer = getInfoLayerFromTerrain(terrainNode, "farmlands")

-- load modifier
local modifier = DensityMapModifier.new(farmlandsInfoLayer, 0, 8)

-- get terrain size
local terrainSize = getTerrainSize(terrainNode)

-- get field TG
local field = getSelection(0)

-- get optional settings TG
local settingsNode = getChild(getChildAt(getRootNode(), 0), "METools | Field B | Settings")

-- get values from userAttributes on fieldTG instead of script header (optional)
farmlandIDToPaint = getNoNil(getUserAttribute(field, "ME_farmlandId"), farmlandIDToPaint) 
priceScale = getNoNil(getUserAttribute(field, "ME_priceScale"), priceScale)

-- get values from userAttributes instead of script header (optional)
farmlandIDToPaint = getNoNil(getUserAttribute(settingsNode, "farmlandIDToPaint"), farmlandIDToPaint) 
priceScale = getNoNil(getUserAttribute(settingsNode, "priceScale"), priceScale)
npcNameWithoutNumber = getNoNil(getUserAttribute(settingsNode, "npcNameWithoutNumber"), npcNameWithoutNumber) 
npcCount = getNoNil(getUserAttribute(settingsNode, "npcCount"), npcCount) 
npcForce = getNoNil(getUserAttribute(settingsNode, "npcForce"), npcForce) 
npcForceActive = getNoNil(getUserAttribute(settingsNode, "npcForceActive"), npcForceActive) 
showOnFarmlandsScreen = getNoNil(getUserAttribute(settingsNode, "showOnFarmlandsScreen"), showOnFarmlandsScreen) 
defaultFarmProperty = getNoNil(getUserAttribute(settingsNode, "defaultFarmProperty"), defaultFarmProperty) 
farmlandsXMLPath = getNoNil(getUserAttribute(settingsNode, "farmlandsXMLPath"), farmlandsXMLPath) 


-- XML stuff
-- load XML file
if fileExists(farmlandsXMLPath) then
    local xmlFile = loadXMLFile("farmlandsXML", farmlandsXMLPath)

    
    local farmlandExists = nil
    local i = 0
    while true do
        local farmlandIdCheck = getXMLInt(xmlFile, "map.farmlands.farmland("..i..")#id")
        if farmlandIdCheck == nil then
            break
        end
        if farmlandIdCheck == farmlandIDToPaint then
            print("Farmland ID "..farmlandIDToPaint.." already exists in farmlands.xml")
            farmlandExists = i
        end
        i = i+1
    end

    local newIndex = nil
    if farmlandExists ~= nil then
        newIndex = farmlandExists
    else
        newIndex = i
    end

    setXMLInt(xmlFile, "map.farmlands.farmland("..newIndex..")#id", farmlandIDToPaint)
    setXMLFloat(xmlFile, "map.farmlands.farmland("..newIndex..")#priceScale", priceScale)

    local npcRandom = math.random(1, npcCount)
    if npcRandom < 10 then  
        npcRandom = "0"..tostring(npcRandom)
    end
    local npc = npcNameWithoutNumber..tostring(npcRandom)
    if npcForceActive then
        npc = npcForce
    end
    
    setXMLString(xmlFile, "map.farmlands.farmland("..newIndex..")#npcName", npc)
    
    setXMLBool(xmlFile, "map.farmlands.farmland("..newIndex..")#showOnFarmlandsScreen", showOnFarmlandsScreen)
    setXMLBool(xmlFile, "map.farmlands.farmland("..newIndex..")#defaultFarmProperty", defaultFarmProperty)

    
    saveXMLFile(xmlFile)

else
    print("No Farmlands XML at given Path")
end


-- cycle through fieldDimensions of the current field
local fieldDimensionsIndex = getUserAttribute(field, "fieldDimensionIndex")
local fieldDimensions = getChildAt(field, fieldDimensionsIndex)

local numberOfDimensions = getNumOfChildren(fieldDimensions)
for i = 0, numberOfDimensions-1 do
    
    -- get translation of all 3 reference points
    local corner1 = getChildAt(fieldDimensions, i)
    local sx,sy,sz = getWorldTranslation(getChildAt(corner1, 0))
    local wx,wy,wz = getWorldTranslation(getChildAt(corner1, 1))
    local hx,hy,hz = getWorldTranslation(corner1)
    
    -- execute modifier
    modifier:setParallelogramUVCoords(sx / terrainSize + 0.5, sz / terrainSize + 0.5, wx / terrainSize + 0.5, wz / terrainSize + 0.5, hx / terrainSize + 0.5, hz / terrainSize + 0.5, DensityCoordType.POINT_POINT_POINT)
    modifier:executeSet(farmlandIDToPaint)

end




