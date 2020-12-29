Smell = Class{}

function Smell:init(grid, agent)
    self.smellMap = {}
    self.smellUImap = {}

    self.UIoutput = self.smellUImap

    self:makeSmellMap(grid)
end


function Smell:update(dt, grid, agent)

    self:updateSmellMap(dt, grid)
    self:pickUpSmell(agent)

end


function Smell:render()
    for y = 1, GRID_HEIGHT do
        for x = 1, GRID_WIDTH do

            local col = self:smellFade(self.smellMap[(y - 1) * GRID_WIDTH + x])

            love.graphics.setColor(
                col['r'],
                col['g'],
                col['b'])
            self:customTile(x, y)
        end
    end
end

-- check grid
-- place agents on UI map



function Smell:makeSmellMap(grid)
    local smell
    for y = 1, GRID_HEIGHT do
        for x = 1, GRID_WIDTH do

            if grid[(y - 1) * GRID_WIDTH + x]['id'] == EAR_ID or
                    grid[(y - 1) * GRID_WIDTH + x]['id'] == TOE_ID or
                    grid[(y - 1) * GRID_WIDTH + x]['id'] == NOSTRIL_ID then

                smell = {
                    ['tile'] = TILE(FLOOR_TILE),
                    ['SMELL'] = TILE(VOID_TILE)['smell'],
                    ['strength'] = 1}
            else
                smell = {
                    ['tile'] = TILE(grid[(y - 1) * GRID_WIDTH + x]),
                    ['SMELL'] = TILE(VOID_TILE)['smell'],
                    ['strength'] = 1}
            end

            self.smellMap[(y - 1) * GRID_WIDTH + x] = smell
        end
    end
end


function Smell:updateSmellMap(dt, grid)
    local smellFadeConstant = 0.1

    -- place smells
    for y = 1, GRID_HEIGHT do
        for x = 1, GRID_WIDTH do

            -- make smell
            local gridSmell = {
                ['tile'] = TILE(grid[(y - 1) * GRID_WIDTH + x]),
                ['SMELL'] = TILE(grid[(y - 1) * GRID_WIDTH + x])['smell'],
                ['strength'] = 1}

            -- place creature smell on map
            -- (adjust for smelliness in the actual smell)
            if gridSmell['tile']['id'] == EAR_ID or
                    gridSmell['tile']['id'] == TOE_ID or
                    gridSmell['tile']['id'] == NOSTRIL_ID then

                self.smellMap[(y - 1) * GRID_WIDTH + x] = gridSmell
            end
        end
    end


    -- update smell fade
    for y = 1, GRID_HEIGHT do
        for x = 1, GRID_WIDTH do

            local mapSmell = self.smellMap[(y - 1) * GRID_WIDTH + x]

            if mapSmell['strength'] <= 0 then
                mapSmell['SMELL'] = TILE(VOID_TILE)['smell']
                mapSmell['strength'] = 1
            elseif mapSmell['strength'] >= 1  then
                mapSmell['strength'] = 1
            end

            if mapSmell['tile']['id'] == EAR_ID or
                    mapSmell['tile']['id'] == TOE_ID or
                    mapSmell['tile']['id'] == NOSTRIL_ID then

                mapSmell['strength'] = mapSmell['strength'] - dt * smellFadeConstant
            end

            self.smellMap[(y - 1) * GRID_WIDTH + x] = mapSmell
            self:smellAura(x, y, mapSmell)
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


-- adjust RGB by strength of smell
function Smell:smellFade(smellTile)
    local RGB = {}
    local smellAdjust

    -- check for map edge
    if smellTile ~= nil then
        if smellTile['tile']['id'] == WALL_TILE['id'] then
            smellAdjust = 0.7
        else
            smellAdjust = 1.5
        end

        local str = smellTile['strength']
        local smellOnTile = smellTile['SMELL']
        local tileSmell = smellTile['tile']['smell']

        RGB['r'] = (smellOnTile['r'] * str + tileSmell['r'] * smellAdjust)/2
        RGB['g'] = (smellOnTile['g'] * str + tileSmell['g'] * smellAdjust)/2
        RGB['b'] = (smellOnTile['b'] * str + tileSmell['b'] * smellAdjust)/2

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
        [1] = self:smellFade(self.smellMap[((agent.y-1) - 1) * GRID_WIDTH + (agent.x-1)]),
        -- 2 - u
        [2] = self:smellFade(self.smellMap[((agent.y-1) - 1) * GRID_WIDTH + (agent.x)]),
        -- 3 - ur
        [3] = self:smellFade(self.smellMap[((agent.y-1) - 1) * GRID_WIDTH + (agent.x+1)]),
        -- 4 - r
        [4] = self:smellFade(self.smellMap[((agent.y) - 1) * GRID_WIDTH + (agent.x+1)]),
        -- 5 - dr
        [5] = self:smellFade(self.smellMap[((agent.y+1) - 1) * GRID_WIDTH + (agent.x+1)]),
        -- 6 - d
        [6] = self:smellFade(self.smellMap[((agent.y+1) - 1) * GRID_WIDTH + (agent.x)]),
        -- 7 - dl
        [7] = self:smellFade(self.smellMap[((agent.y+1) - 1) * GRID_WIDTH + (agent.x-1)]),
        -- 8 - l
        [8] = self:smellFade(self.smellMap[((agent.y) - 1) * GRID_WIDTH + (agent.x-1)])
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
