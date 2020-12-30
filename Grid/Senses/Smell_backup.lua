Smell = Class{}

function Smell:init(grid, agent)
    self.smellMap = {}
    self.smellUImap = {}

    self.UIoutput = self.smellUImap

    self:makeSmellMap(grid)
    self.senseOfSmell = 1


    -- self.test_array = {
    --     ['bob'] = 4,
    --     [1] = 1,
    --     [2] = 2,
    --     [3] = 3
    -- }

    -- for name, value in ipairs(self.test_array) do
    --     print(name .. ' ' .. value)
    -- end
end


function Smell:update(dt, grid, agent)

    self:updateSmellMap(dt, grid)
    self:pickUpSmell(agent)

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

-- remove self-smell
-- add smell aura


-- make grid smells without agents
function Smell:makeSmellMap(grid)
    local smell
    for y = 1, GRID_HEIGHT do
        for x = 1, GRID_WIDTH do

            local gridTile = TILE(grid[(y - 1) * GRID_WIDTH + x])

            -- if AGENT, replace with floor tile
            if gridTile['id'] == EAR_ID or
                    gridTile['id'] == TOE_ID or
                    gridTile['id'] == NOSTRIL_ID then

                -- ['SMELL'] list for multiple smells
                -- ['SMELL'][1] is always the tile's base smell
                smell = {
                    ['tile'] = TILE(FLOOR_TILE),
                    ['SMELL'] = {
                        [1] = {
                            ['id'] = gridTile['id'],
                            ['sml'] = gridTile['smell'],
                            ['strength'] = 1
                        }
                    }
                }
            else
                -- otherwise just smack the tile on there
                smell = {
                    ['tile'] = gridTile,
                    ['SMELL'] = {
                        [1] = {
                            ['id'] = gridTile['id'],
                            ['sml'] = gridTile['smell'],
                            ['strength'] = 1
                        }
                    }
                }
            end

            -- add tile to the SmellMap
            self.smellMap[(y - 1) * GRID_WIDTH + x] = smell
        end
    end
end


-- place agent smells and update smell strengths
function Smell:updateSmellMap(dt, grid)
    -- speed of smell fade
    local smellFadeConstant = 0.1

    for y = 1, GRID_HEIGHT do
        for x = 1, GRID_WIDTH do

            local gridTile = TILE(grid[(y - 1) * GRID_WIDTH + x])

            if gridTile['id'] == EAR_ID or
                    gridTile['id'] == TOE_ID or
                    gridTile['id'] == NOSTRIL_ID then

                -- variables for convenience
                local smellTile = self.smellMap[(y - 1) * GRID_WIDTH + x]
                local gridSmell = {
                    ['tile'] = gridTile,
                    ['SMELL'] = {
                        [1] = {
                            ['id'] = gridTile['id'],
                            ['sml'] = gridTile['smell'],
                            ['strength'] = 1
                        }
                    }
                }

                -- print('bop' .. smellTile['SMELL'][1]['id'])

                -- add the smell to the smellTile
                self:addSmell(gridSmell, smellTile)
            end
        end
    end



    -- update smell fade
    for y = 1, GRID_HEIGHT do
        for x = 1, GRID_WIDTH do

            -- local var for convenience
            local smellTile = self.smellMap[(y - 1) * GRID_WIDTH + x]

            for i, smellEntry in ipairs(smellTile['SMELL']) do
                -- print(x .. ',' .. y .. ' str: ' .. smellEntry['strength'])
                if i ~= 1 then

                    smellEntry['strength'] = smellEntry['strength'] - dt * smellFadeConstant
                    -- print(smellEntry['strength'])

                    -- check for 0 strength
                    if smellEntry['strength'] <= 0 then
                        --recursively null all entries
                        smellTile['SMELL'][i] = nil
                        -- smellEntry = recCleanTable(smellEntry)
                        -- remove element
                        -- table.remove(smellTile['SMELL'], smellEntry)

                    elseif smellEntry['strength'] >= 1  then
                        smellEntry['strength'] = 1
                    end
                end
            end

            self:smellAura(x, y, smellTile)
        end
    end
end


function Smell:smellAura(self_x, self_y, smell)
    -- for y = -1, 1 do
    --     for x = -1, 1 do
    --         if self:checkBounds(self_x + x, self_y + y) then
    --             if
    --         end
    --     end
    -- end
end


function Smell:addSmell(smellToAdd, smellTile)

    local counter = 1
    local len = #smellTile['SMELL']

    for i, smellEntry in ipairs(smellTile['SMELL']) do

        -- if smell exists, reset it's strength to 1
        if smellEntry['id'] == smellToAdd['SMELL'][1]['id'] then
            smellEntry['strength'] = 1
            -- print('str reset to 1')
            break
        end

        -- if no similar smell found, add new one
        if counter == len then
            smellTile['SMELL'][len+1] = smellToAdd['SMELL'][1]
            -- print('added new smell')
            break
        end
        counter = counter + 1
    end
end


-- adjust RGB by strength of smell
function Smell:smellOutput(smellTile)

    local RGB = {}

    -- check for map edge
    if smellTile ~= nil then
        local smellAdjust
        if smellTile['tile']['id'] == WALL_TILE['id'] then
            smellAdjust = 1
        elseif smellTile['tile']['id'] == FLOOR_TILE['id'] then
            smellAdjust = 1
        else
            smellAdjust = 1
        end

        -- iterating over the smells
        for i, smellEntry in ipairs(smellTile['SMELL']) do
            if i == 1 then
                RGB = {
                    ['r'] = smellEntry['sml']['r'] * smellAdjust,
                    ['g'] = smellEntry['sml']['g'] * smellAdjust,
                    ['b'] = smellEntry['sml']['b'] * smellAdjust
                }
            else
                local str = smellEntry['strength']

                RGB['r'] = RGB['r'] + smellEntry['sml']['r'] * str
                RGB['g'] = RGB['g'] + smellEntry['sml']['g'] * str
                RGB['b'] = RGB['b'] + smellEntry['sml']['b'] * str
            end
        end

        -- average
        local totes = #smellTile['SMELL']
        RGB['r'] = RGB['r'] --/ totes
        RGB['g'] = RGB['g'] --/ totes
        RGB['b'] = RGB['b'] --/ totes
    else
        RGB['r'] = 0
        RGB['g'] = 0
        RGB['b'] = 0
    end

    return RGB
end


-- making UI
function Smell:pickUpSmell(agent)
    self.UIoutput = {
        -- 1 - ul
        [1] = self:smellOutput(self.smellMap[((agent.y-1) - 1) * GRID_WIDTH + (agent.x-1)]),
        -- 2 - u
        [2] = self:smellOutput(self.smellMap[((agent.y-1) - 1) * GRID_WIDTH + (agent.x)]),
        -- 3 - ur
        [3] = self:smellOutput(self.smellMap[((agent.y-1) - 1) * GRID_WIDTH + (agent.x+1)]),
        -- 4 - r
        [4] = self:smellOutput(self.smellMap[((agent.y) - 1) * GRID_WIDTH + (agent.x+1)]),
        -- 5 - dr
        [5] = self:smellOutput(self.smellMap[((agent.y+1) - 1) * GRID_WIDTH + (agent.x+1)]),
        -- 6 - d
        [6] = self:smellOutput(self.smellMap[((agent.y+1) - 1) * GRID_WIDTH + (agent.x)]),
        -- 7 - dl
        [7] = self:smellOutput(self.smellMap[((agent.y+1) - 1) * GRID_WIDTH + (agent.x-1)]),
        -- 8 - l
        [8] = self:smellOutput(self.smellMap[((agent.y) - 1) * GRID_WIDTH + (agent.x-1)])
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
