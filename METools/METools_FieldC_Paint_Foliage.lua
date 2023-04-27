-- Author:Admin
-- Name:METools | Field C | Create Foliage
-- Description:
-- Icon:
-- Hide: no

local foliageName = "grass"
local foliageBit = 3

local terrain = getChild(getChildAt(getRootNode(), 0), "terrain")
local terrainSize = getTerrainSize(terrain)

local foliageId = getTerrainDataPlaneByName(terrain, foliageName)

local modifier = DensityMapModifier.new(foliageId, 0, 5)

-- cycle through fieldDimensions of the current field
local field = getSelection(0)

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
    modifier:executeSet(foliageBit)

end











