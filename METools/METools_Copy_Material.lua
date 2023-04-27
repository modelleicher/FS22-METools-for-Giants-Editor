-- Author:modelleicher
-- Name:METools | Copy Material
-- Description: copies the material from first selected to other selected
-- Icon:
-- Hide: no

-- HOW TO USE
-- 1. select the object where the Material should be copied from
-- 2. select one or several objects additionally onto which the Material should be copied to


---------------------------------

-- get first and second selection
local get = getSelection(0);
local set = getSelection(1);

-- set material for second selection
setMaterial(set, getMaterial(get, 0), 0)

-- if second selection includes more than 1 object set material for those too
for i = 1, getNumSelected() -1 do
    local set1 = getSelection(i);
    setMaterial(set1, getMaterial(get, 0), 0)
end;

