-- Author:Admin
-- Name:METools | Spline Exporter
-- Description:
-- Icon:
-- Hide: no

-- HOW TO USE
-- change the "splineResolution" below to the resolution you want (or leave at 1)
-- select the Spine to export
-- run the script, select the File in the File-Dialog which opens, have fun with the exportet spline :)


local splineResolution = 1.0 


-- create and load obj file
local objFilePath = openFileDialog("Select File", "*.obj")

local objFileId = createFile(objFilePath, FileAccess.WRITE)

-- create comment header line (not needed) 
fileWrite(objFileId, "# Spline Export Giants Editor \n")


-- get spline and values
local splineId = getSelection(0)

local splineLength = getSplineLength(splineId) 
local splinePiecePoint = splineResolution / splineLength  -- relative size [0..1]

-- store vertexPoints to connect lines with vertices later
local vertexPoints = 0

-- go along spline on given distances and write vertice-points to file
local splinePos = 0.0
    while splinePos <= 1.0 do

    local posX, posY, posZ = getSplinePosition(splineId, splinePos)

    fileWrite(objFileId, "v "..tostring(posX).." "..tostring(posY).." "..tostring(posZ).."\n")    
    
    vertexPoints = vertexPoints + 1
    -- goto next point
    splinePos = splinePos + splinePiecePoint
end

-- write the line connections
for i = 1, vertexPoints-1 do
    fileWrite(objFileId, "l "..tostring(i).." "..tostring(i+1).."\n")
end

delete(objFileId)

print("File "..tostring(objFilePath).." Exported!")

