Smell = Class{}

function Smell:init(grid)
    self.smellMap = {}
    self.smellUIMap = {}

    self.UIoutput = {}



    self:makeSmellMap(grid)
end

-- add AURA smells

function Smell:update(dt, grid, agent)
    self.agent = agent
    self.senseOfSmell = agent.senseOfSmell

    -- add smells to grid
    self:addSmells(dt, grid)
    -- update smell decay
    self:updateSmells(dt)
    -- make smell UI (and render)
    self:pickUpSmell()

end


function Smell:render()
    for y = 1, GRID_HEIGHT do
        for x = 1, GRID_WIDTH do

            local col = self:smellOutput(self.smellMap[(y - 1) * GRID_WIDTH + x])

            love.graphics.setColor(
                col['r'],
                col['g'],
                col['b'])
            self:customTile(x, y)
        end
    end
end

--%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
-- %% ORDER %%
-- INIT
--  - make map without agents
-- UPDATE
--  - check grid(x, y) for agent positions
--  - - check smellMap(x, y) for agent smells
--  - - - if agent smell -> UPDATE smellMap(x, y) with agent smell
--  - - - else ADD agent smell to smellMap(x, y)
--
--  - check smellMap(x, y) for agent smells
--  - - reduce agent smell strength by CONSTANT
--  - - - if strength <= 0 -> remove entry
--  - - - if strength > 1 -> stength = 1
--
--  - make UI map



-- initial making of the map - no agents
function Smell:makeSmellMap(grid)
    for y = 1, GRID_HEIGHT do
        for x = 1, GRID_WIDTH do

            -- local vars for convenience
            local gridTile = TILE(grid[(y - 1) * GRID_WIDTH + x])
            local gridSmell

            -- if AGENT, replace with floor tile
            if gridTile['id'] == EAR_ID or
                    gridTile['id'] == TOE_ID or
                    gridTile['id'] == NOSTRIL_ID then

                gridSmell = {
                    ['base'] = {
                        ['id'] = TILE(FLOOR_TILE)['id'],
                        ['smell'] = TILE(FLOOR_TILE)['smell'],
                        ['strength'] = 1
                    }
                }
            else
                -- otherwise just smack the tile on there
                gridSmell = {
                    ['base'] = {
                        ['id'] = gridTile['id'],
                        ['smell'] = gridTile['smell'],
                        ['strength'] = 1
                    }
                }
            end

            -- set smell map value
            self.smellMap[(y - 1) * GRID_WIDTH + x] = gridSmell
        end
    end
end


-- get agent positions from grid, place them onto the map and update smell decay
function Smell:addSmells(dt, grid)
    for y = 1, GRID_HEIGHT do
        for x = 1, GRID_WIDTH do

            -- get tile from grid
            local gridTile = TILE(grid[(y - 1) * GRID_WIDTH + x])

            -- if agent, add to smellmap
            if gridTile['id'] == EAR_ID or
                    gridTile['id'] == TOE_ID or
                    gridTile['id'] == NOSTRIL_ID then

                -- new smell var
                local newSmell = {
                    ['id'] = gridTile['id'],
                    ['smell'] = gridTile['smell'],
                    ['strength'] = 1
                }

                -- check if same smell exists
                local no_similarities = true
                local smellTile = self.smellMap[(y - 1) * GRID_WIDTH + x]
                for i, smellEntry in pairs(smellTile) do

                    -- if tile exists, reset its strength to 1
                    if smellEntry['id'] == newSmell['id'] then
                        smellEntry['strength'] = 1
                        no_similarities = false
                        break
                    end
                end

                -- if it doesn't, append it
                if no_similarities then
                    smellTile[newSmell['id']] = newSmell
                end
            end
        end
    end
end


-- update smell fade
function Smell:updateSmells(dt)
    local smellFadeConstant = 0.1

    for y = 1, GRID_HEIGHT do
        for x = 1, GRID_WIDTH do

            local smellTile = self.smellMap[(y - 1) * GRID_WIDTH + x]

            for i, smellEntry in pairs(smellTile) do
                if i ~= 'base' then
                    -- tables pass by reference
                    -- local str = smellEntry['strength']
                    smellEntry['strength'] = smellEntry['strength'] - dt * smellFadeConstant

                    if smellEntry['strength'] <= 0 then
                        -- experimental, might need to remove index?? not sure...
                        smellTile[i] = nil
                        -- smellEntry = nil
                        -- table.remove(smellTile, smellEntry)
                    elseif smellEntry['strength'] > 1 then
                        str = 1
                    end
                end
            end
        end
    end
end


-- adjust smell based on tile
function Smell:smellAdjust(id)
    if id == WALL_TILE['id'] then
        return 0.3 * self.senseOfSmell
    elseif id == FLOOR_TILE['id'] then
        return 1 * self.senseOfSmell
    elseif id == self.agent.tile['id'] then
        return 0.1 * self.senseOfSmell
    else
        return 1 * self.senseOfSmell
    end
end


-- smell output
function Smell:smellOutput(smellTile)
    local RGB = {}

    -- check for map edge
    if smellTile ~= nil then
        local smellAdjust = self:smellAdjust(smellTile['base']['id'])

        for i, smellEntry in pairs(smellTile) do

            if i == 'base' then
                RGB['r'] = smellTile['base']['smell']['r'] * smellAdjust
                RGB['g'] = smellTile['base']['smell']['g'] * smellAdjust
                RGB['b'] = smellTile['base']['smell']['b'] * smellAdjust
            else
                local str = smellEntry['strength']

                RGB['r'] = RGB['r'] + smellEntry['smell']['r'] * str * self:smellAdjust(smellEntry['id'])
                RGB['g'] = RGB['g'] + smellEntry['smell']['g'] * str * self:smellAdjust(smellEntry['id'])
                RGB['b'] = RGB['b'] + smellEntry['smell']['b'] * str * self:smellAdjust(smellEntry['id'])
            end
        end

        -- -- average maybe
        -- local totes = #smellTile + 1
        -- RGB['r'] = RGB['r'] / totes
        -- RGB['g'] = RGB['g'] / totes
        -- RGB['b'] = RGB['b'] / totes

    else
        RGB = {
            ['r'] = 0,
            ['g'] = 0,
            ['b'] = 0
        }
    end

    return RGB
end



-- making UI
function Smell:pickUpSmell()
    self.UIoutput = {
        -- 1 - ul
        [1] = self:smellOutput(self.smellMap[((self.agent.y-1) - 1) * GRID_WIDTH + (self.agent.x-1)]),
        -- 2 - u
        [2] = self:smellOutput(self.smellMap[((self.agent.y-1) - 1) * GRID_WIDTH + (self.agent.x)]),
        -- 3 - ur
        [3] = self:smellOutput(self.smellMap[((self.agent.y-1) - 1) * GRID_WIDTH + (self.agent.x+1)]),
        -- 4 - r
        [4] = self:smellOutput(self.smellMap[((self.agent.y) - 1) * GRID_WIDTH + (self.agent.x+1)]),
        -- 5 - dr
        [5] = self:smellOutput(self.smellMap[((self.agent.y+1) - 1) * GRID_WIDTH + (self.agent.x+1)]),
        -- 6 - d
        [6] = self:smellOutput(self.smellMap[((self.agent.y+1) - 1) * GRID_WIDTH + (self.agent.x)]),
        -- 7 - dl
        [7] = self:smellOutput(self.smellMap[((self.agent.y+1) - 1) * GRID_WIDTH + (self.agent.x-1)]),
        -- 8 - l
        [8] = self:smellOutput(self.smellMap[((self.agent.y) - 1) * GRID_WIDTH + (self.agent.x-1)])
    }
end


-- custom tile copy
function Smell:customTile(x, y)
    love.graphics.rectangle('fill',
        (x) * TILE_SIZE,       -- x
        (y) * TILE_SIZE,       -- y
        TILE_SIZE,             -- width
        TILE_SIZE,             -- height
        TILE_SIZE * 0.3,       -- rounding x
        TILE_SIZE * 0.3)       -- rounding y
end


-- checking bounds copy
function Smell:checkBounds(nextX, nextY)
    if nextX > GRID_WIDTH or nextX < 1 or nextY > GRID_HEIGHT or nextY < 1 then
        return false
    else
        return true
    end
end



function Smell:test(smellTile)
    print()
    print('id: ' .. self.smellMap[1]['base']['id'])
    print('str: ' .. self.smellMap[1]['base']['strength'])
    print('r-' .. self.smellMap[1]['base']['smell']['r'])
    print('g-' .. self.smellMap[1]['base']['smell']['g'])
    print('b-' .. self.smellMap[1]['base']['smell']['b'])
    print()
end
