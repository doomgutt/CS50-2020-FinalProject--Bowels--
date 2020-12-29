math.randomseed(os.time())

-- %% SCREEN SETTINGS %%
--------------------------------------------------------------------------------
WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 920

-- keep these to 40 = VIRTUAL_XXXXX / TILE_SIZE
-- for smoothest performance
VIRTUAL_WIDTH = 400
VIRTUAL_HEIGHT = 400
TILE_SIZE = 8

-- %% GRID SETTINGS %%
--------------------------------------------------------------------------------
GRID_WIDTH = 40--math.floor((VIRTUAL_WIDTH-20) / TILE_SIZE)
GRID_HEIGHT = 20--math.floor((VIRTUAL_HEIGHT / TILE_SIZE) / 2)

-- %% TILE SETTINGS %%
-------------------------------------------------------------------------------
TOE_ID = 10
EAR_ID = 20
NOSTRIL_ID = 30


VOID_TILE = {
    ['id'] = 0,
    ['RGB'] = {
        ['r'] = 0/255,
        ['g'] = 0/255,
        ['b'] = 0/255
    },
    ['smell'] = {
        ['r'] = 0/255,
        ['g'] = 0/255,
        ['b'] = 0/255
    }
}

FLOOR_TILE = {
    ['id'] = 1,
    ['RGB'] = {
        ['r'] = 58/255,
        ['g'] = 16/255,
        ['b'] = 6/255
    },
    ['smell'] = {
        ['r'] = 58/255,
        ['g'] = 16/255,
        ['b'] = 6/255
    }
}

WALL_TILE = {
    ['id'] = 2,
    ['RGB'] = {
        ['r'] = 180/255,
        ['g'] = 160/255,
        ['b'] = 160/255
    },
    ['smell'] = {
        ['r'] = 180/255,
        ['g'] = 160/255,
        ['b'] = 160/255
    }
}


-- SIGHT_TILE = {
--     ['id'] = 0,
--     ['RGB'] = {
--         ['r'] = 0/255,
--         ['g'] = 255/255,
--         ['b'] = 0/255
--     }}

TILE_LIST = {}
TILE_LIST[0] = VOID_TILE
TILE_LIST[1] = FLOOR_TILE
TILE_LIST[2] = WALL_TILE
-------------------------------------------------------------

DEAD_UI_OUTPUT = {}
for i = 1,8 do
    DEAD_UI_OUTPUT[i] = VOID_TILE['RGB']
end


--------------------------------------------------------

function TILE(TILE)
    local RGB = {
        ['r'] = TILE['RGB']['r'],
        ['g'] = TILE['RGB']['g'],
        ['b'] = TILE['RGB']['b']
    }
    local smell = {
        ['r'] = TILE['smell']['r'],
        ['g'] = TILE['smell']['g'],
        ['b'] = TILE['smell']['b']
    }
    local id = TILE['id']
    local tile = {
        ['RGB'] = RGB,
        ['id'] = id,
        ['smell'] = smell
    }
    return tile
end


function getTile(grid, screenX, screenY)

    x = math.floor(screenX/TILE_SIZE)
    y = math.floor(screenY/TILE_SIZE)
    -- print()
    -- print('getting tile... ' .. x .. ','.. y)
    return grid[(y - 1) * GRID_WIDTH + x]
end


function makeSquareList(searchSize, posX, posY, oddness)
    local squareList = {}
    if oddness == 'odd' then
        for y = posY - searchSize, posY + searchSize do
            for x = posX - searchSize, posX + searchSize do
                if x == posX - searchSize or
                    x == posX + searchSize or
                    y == posY - searchSize or
                    y == posY + searchSize then

                    squareList[#squareList + 1] = {
                        ['x'] = x,
                        ['y'] = y
                    }
                end
            end
        end
    elseif oddness == 'even' then
        for y = posY - searchSize, posY + searchSize + 1 do
            for x = posX - searchSize, posX + searchSize + 1 do
                if x == posX - searchSize or
                    x == posX + searchSize + 1 or
                    y == posY - searchSize or
                    y == posY + searchSize + 1 then

                    squareList[#squareList + 1] = {
                        ['x'] = x,
                        ['y'] = y
                    }
                end
            end
        end
    end
    return squareList
end



















-- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
-- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

-- Debugging Controls
SIGHT_RAYS = 'n'
SOUND_RAYS = 'y'
EXCLUDE_AGENT_ID_1 = nil
EXCLUDE_AGENT_ID_2 = nil
EXCLUDE_AGENT_ID_3 = nil
EXCLUDE_AGENT_ID_4 = nil
