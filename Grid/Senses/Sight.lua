Sight = Class{}

function Sight:init(grid, agent, sightDist)

    -- self.drawTable = {
    --     ['x'] = 400,
    --     ['y'] = 400
    -- }

    -- circular vision
    self.visionPlot = {}
    self.visionGrid = {}
    self.sightUImap = {}
    self.sightDistance = sightDist or (GRID_WIDTH + GRID_HEIGHT)*TILE_SIZE

    -- self x, y
    self.agentX = agent.x
    self.agentY = agent.y

    -- grid-size
    -- self.sightMap = {}
    -- self.sightMap2 = {}
    -- possible directions for sight
    -- self.directionMap = {}
    -- self:makeDirections()
    -- self.sightID = FLOOR_TILE

end


function Sight:update(grid, agent)

    self.agentX = agent.x
    self.agentY = agent.y
    self:radialVision(grid, agent)
    self:makeUImap(agent)

    -- self:makeSightMap(grid)
    -- self:tileDistance(grid)
    -- self:nullSightMap()
    -- self:makeSight(grid)


    -- self.drawTable = {}
    -- for _, squareXY in pairs(makeSquareList(5, self.agentX, self.agentY, 'odd')) do
    --     self:sightCollision(grid,
    --         self.agentX, self.agentY,
    --         squareXY['x'], squareXY['y'])
    -- end

    -- self:sightCollision(grid, self.agentX, self.agentY, 4, 4)
    self.UIoutput = self.sightUImap
end

function Sight:render(visionRays)
    local visionRays = visionRays or 'n'
    -- vision ray debugging
    if visionRays == 'y' then
        for i, XY in pairs(self.visionPlot) do
            local col = XY['tile']['RGB']
            love.graphics.setColor(
                col['r']+50/255,
                col['g']+50/255,
                col['b']+50/255)
            love.graphics.rectangle('fill', XY['x']-1.5, XY['y']-1.5, 3, 3)
        end
    end

    -- self:drawSightmap()

    -- print('agent')
    -- print(self.agentX)
    -- print(self.agentY)

    -- self:drawLines(self.agentX, self.agentY, 4, 4)

    -- local k = TILE_SIZE
    -- local c = 0.5
    -- love.graphics.line(
    --     (self.agentX + c)*k, (self.agentY + c)*k,
    --     (2 + c)*k, (2 + c)*k)

    -- love.graphics.setColor(1, 1, 1)
    -- for i, XY in pairs(self.drawTable) do
    --     love.graphics.rectangle('fill', XY['x'], XY['y'], 3, 3)
    -- end
end


--%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


function Sight:radialVision(grid, agent, step, partitions)
    -- clear vision
    self.visionPlot = {}
    self.visionGrid = {
        [1] = {}, -- 1 - down
        [2] = {}, -- 2 - dr
        [3] = {}, -- 3 - r
        [4] = {}, -- 4 - ur
        [5] = {}, -- 5 - u
        [6] = {}, -- 6 - ul
        [7] = {}, -- 7 - l
        [8] = {}}  -- 8 - dl

    -- init vars
    local partitions = partitions or 180
    local step = step or 5

    -- self position
    local self_x = (agent.x + 0.5) * TILE_SIZE
    local self_y = (agent.y + 0.5) * TILE_SIZE

    -- circle math
    local degs = 0
    local fullCircle = math.pi*2
    local radialIncrement = fullCircle/partitions

    for n = 1, 8 do
        local circleMapStep = -(n * fullCircle)/8

        -- circle direction calculation -- 0.019
        local k = fullCircle/(8^3) - 2*(fullCircle/8) -- adjusting circle a little
        for rad = -(fullCircle)/16 + k + circleMapStep,
                   (fullCircle)/16 + k + circleMapStep,
                   radialIncrement do

            -- calculate x,y step
            local dy = math.cos(rad)*step
            local dx = math.sin(rad)*step
            local dxx = (TILE_SIZE*0.2)*dx
            local dyy = (TILE_SIZE*0.2)*dy

            -- line loop
            local dist = (dxx^2 + dyy^2)^0.5
            while dist < self.sightDistance do
                -- get tile
                local tile = getTile(grid, self_x + dxx, self_y + dyy)

                -- debugging: add transient vision
                self.visionPlot[#self.visionPlot + 1] = {
                    ['x'] = self_x + dxx,
                    ['y'] = self_y + dyy,
                    ['tile'] = tile or VOID_TILE}
                self.visionGrid[n][#self.visionGrid[n] + 1] = {
                    ['tile'] = tile or VOID_TILE,
                    ['dist'] = dist}

                -- check for edge pf screen
                if tile == nil then
                    self.visionPlot[#self.visionPlot + 1] = {
                        ['x'] = self_x + dxx,
                        ['y'] = self_y + dyy,
                        ['tile'] = VOID_TILE}
                    self.visionGrid[n][#self.visionGrid[n] + 1] = {
                        ['tile'] = VOID_TILE,
                        ['dist'] = dist}
                    break
                -- check for non-floor tiles
                elseif tile['id'] ~= FLOOR_TILE['id'] then
                    self.visionPlot[#self.visionPlot + 1] = {
                        ['x'] = self_x + dxx,
                        ['y'] = self_y + dyy,
                        ['tile'] = tile}
                    self.visionGrid[n][#self.visionGrid[n] + 1] = {
                        ['tile'] = tile,
                        ['dist'] = dist}
                    break
                end

                -- update dx/dy
                dxx = dxx + dx
                dyy = dyy + dy
                dist = (dxx^2 + dyy^2)^0.5
            end
        end
    end
end


function Sight:makeUImap(agent)

    -- average distance for all directions
    local avgTotalDist = 0
    local avgTotCount = 0
    for i = 1, 8 do
        for n, sightTile in pairs(self.visionGrid[i]) do
            avgTotalDist = avgTotalDist + sightTile['dist']
            avgTotCount = avgTotCount + 1
        end
    end
    avgTotalDist = avgTotalDist / avgTotCount

    -- for every direction
    for i = 1, 8 do

        -- reset RGB
        local r = 0
        local g = 0
        local b = 0

        -- counting tiles to account for too many floor tiles
        local tileCounter = 0
        local distCount = 0
        local dMod
        local focusMod = 0

        -- focus mod
        for n, sightTile in pairs(self.visionGrid[i]) do
            focusMod = focusMod + sightTile['dist']
        end

        -- focusMod > 1 when dir dist avg > total dist avg
        -- focusMod < 1 when dir dist avg < total dist avg
        focusMod = (focusMod / #self.visionGrid[i]) / avgTotalDist

        -- sum RGB over seen nodes and adjust distance
        for n, sightTile in pairs(self.visionGrid[i]) do

            -- tile importance adjusts
            if sightTile['tile']['id'] == FLOOR_TILE['id'] then
                -- closer to 1 makes floor more vivid
                -- smaller than 1 makes walls more vivid
                dMod = 0.1
            elseif sightTile['tile']['id'] == 20 then
                -- makes the enemy more visible
                dMod = 40*((focusMod^1.2)*4)
            elseif sightTile['tile']['id'] == WALL_TILE['id'] then
                dMod = 1
            else
                dMod = 1
            end

            -- constant to adjust the distance function
            -- for k closer to -1 is more sharp (close range vision)
            -- for case closer to 0 ln is more like 1/x (far range vision)
            -- 0.02 seems to work well??
            -- might need to fanagle the constants a bit
            local k = -0.05 / ((focusMod^1.2)*2)
            -- local formatted = string.format("%.2f %%", focusMod)
            -- distance function with e^(-x)
            local dist = dMod * math.exp(k * (sightTile['dist'] - 1))

            -- DIST_PRINT[#DIST_PRINT + 1}] = dist
            -- weirdly divided weighted averages...
            -- not sure why slamming 1/x in there makes it better...?
            distCount = distCount + dist --+ (1 / sightTile['dist'])


            -- print(dist)
            -- sum RGB
            r = r + sightTile['tile']['RGB']['r'] * dist
            g = g + sightTile['tile']['RGB']['g'] * dist
            b = b + sightTile['tile']['RGB']['b'] * dist

        end

        -- V1 average of colours
        r = r / distCount
        g = g / distCount
        b = b / distCount

        -- add colours to the ui sight map
        self.sightUImap[i] = {
            ['r'] = r,
            ['g'] = g,
            ['b'] = b}
    end
end



-- SETUP
-- VERSION 1:
-- - infinite range
-- - try to find the right 'vision' function
--
-- VERSION 2:
-- - FINITE range
-- ????


-- SOLUTIONS
-- V1. STOP BEING SO SHORTSIGHTED
-- V2. add A LOT of distance to 'empty?' tiles



-- -- makes direction coords
-- function Sight:makeDirections()
--     for y = -1, 1 do
--         for x = -1, 1 do
--             -- if not (x == 0 and y == 0) then
--             self.directionMap[#self.directionMap + 1] = {
--                 ['x'] = x,
--                 ['y'] = y}
--             -- print(x)
--             -- print(y)
--             -- print()
--         end
--     end
--     self.directionMap[5] = nil
--     -- COORD MAP:
--     -- 1 2 3
--     -- 4   6
--     -- 7 8 9
--     -- end
-- end
--
--
-- -- distance to TILE in direction DIR
-- function Sight:tileDistance(grid)
--     -- debugging
--     -- print('===============================')
--     -- print(grid[1]['id'])
--
--     -- for every direction
--     for dirID, dir in pairs(self.directionMap) do
--
--         -- testing tile ID check
--         self.sightID = FLOOR_TILE
--
--         -- initialize agent's X and Y
--         x = self.agentX
--         y = self.agentY
--
--         -- initialize distance map
--         -- (starting at -1 because of how the WHILE loop is made later on)
--         self.sightUImap[dirID] = {
--             ['dir'] = self.directionMap[dirID],
--             ['dist'] = -1,
--             ['tile'] = FLOOR_TILE}
--
--         -- debugging
--         -- print('-------------')
--         -- print('grid id: ' .. grid[(y - 1) * GRID_WIDTH + x]['id'])
--
--         -- implement 'while' check at the end of the loop so that we can retrieve
--         -- the tile ID without looking ahead
--         local check = true
--         -- calculating distance to a non-floor tile and it's ID
--         while check do
--
--             -- increment x,y
--             x = x + dir['x']
--             y = y + dir['y']
--             -- io.write('[')
--             -- io.write(x)
--             -- io.write(',')
--             -- io.write(y)
--             -- io.write('] ')
--
--             -- calculate distance via PYTHAGORAS
--             self.sightUImap[dirID]['dist'] =
--                 self.sightUImap[dirID]['dist'] +
--                     (self.sightUImap[dirID]['dir']['x'] ^ 2 +
--                         self.sightUImap[dirID]['dir']['y'] ^ 2) ^ 0.5
--
--
--             -- NOTE: CHECK BOUNDS BEFORE TILE!!!
--
--             -- check bounds
--             if x < 1 or x > GRID_WIDTH or y < 1 or y > GRID_HEIGHT then
--                 -- -- debugging
--                 -- print('\n' .. 'last tile before void: ' ..
--                 --     grid[(y - 1) * GRID_WIDTH + x]['id'])
--
--                 -- set last tile ID
--                 self.sightUImap[dirID]['tile'] = VOID_TILE
--                 -- round off distances
--                 self.sightUImap[dirID]['dist'] = math.floor(self.sightUImap[dirID]['dist'])
--                 break
--             end
--
--             -- check tile
--             if grid[(y - 1) * GRID_WIDTH + x]['id'] == FLOOR_TILE['id'] then
--                 check = true
--             else
--                 -- -- debugging
--                 -- print('\n' .. 'last tile before quit?: ' ..
--                 --     grid[(y - 1) * GRID_WIDTH + x]['id'])
--
--                 -- set last tile ID
--                 self.sightUImap[dirID]['tile'] = grid[(y - 1) * GRID_WIDTH + x]
--                 -- round off distances
--                 self.sightUImap[dirID]['dist'] = math.floor(self.sightUImap[dirID]['dist'])
--                 check = false
--             end
--         end
--
--         -- debugging
--         -- print(
--         --     -- '\n' ..
--         --     'DIST ' ..
--         --         self.sightUImap[dirID]['dist'] ..
--         --     ' to TILE ' ..
--         --         self.sightUImap[dirID]['tile']['id'] ..
--         --     ' in DIR ' ..
--         --         self.sightUImap[dirID]['dir']['x'] ..
--         --         ',' ..
--         --         self.sightUImap[dirID]['dir']['y'])
--     end
-- end




-- -- null sightMap
-- function Sight:nullSightMap()
--     for y = 1, GRID_HEIGHT do
--         for x = 1, GRID_WIDTH do
--             self.sightMap[(y - 1) * GRID_WIDTH + x] = FLOOR_TILE
--         end
--     end
-- end


--
-- function Sight:makeSight(grid)
--     for dirID, dir in pairs(self.directionMap) do
--
--         -- initialize agent XY
--         x = self.agentX
--         y = self.agentY
--
--         local check = true
--         while check do
--
--             --increment x,y
--             x = x + dir['x']
--             y = y + dir['y']
--
--             -- check bounds
--             if x < 1 or x > GRID_WIDTH or y < 1 or y > GRID_HEIGHT then
--                 break
--             end
--
--             -- check tile
--             if grid[(y - 1) * GRID_WIDTH + x]['id'] == FLOOR_TILE['id'] then
--                 self.sightMap[(y-1)*GRID_WIDTH+x] =
--                     self.sightUImap[dirID]['tile']
--                 -- io.write(self.sightMap[(y-1)*GRID_WIDTH+x]['id'])
--                 check = true
--             else
--                 check = false
--             end
--         end
--         -- print()
--     end
-- end


-- -- draws the sight map to the screen
-- function Sight:drawSightmap()
--
--         -- render movement map
--     for dirID, dir in pairs(self.directionMap) do
--
--         -- initialize agent XY
--         x = self.agentX
--         y = self.agentY
--
--         local check = true
--         while check do
--
--             --increment x,y
--             x = x + dir['x']
--             y = y + dir['y']
--
--             -- check bounds
--             if x < 1 or x > GRID_WIDTH or y < 1 or y > GRID_HEIGHT then
--                 break
--             end
--
--             -- check tile
--             if self.sightMap[(y-1)*GRID_WIDTH+x]['id'] ~= FLOOR_TILE['id'] then
--                 local col = self.sightUImap[dirID]['tile']['RGB']
--                 -- print(self.senses['Toe_1'].sightID['id'])
--                 love.graphics.setColor(
--                     col['r'],
--                     col['g'],
--                     col['b'],
--                     0.8)
--                 love.graphics.rectangle('fill',
--                     (x - 1) * TILE_SIZE,   -- x
--                     (y-1+3) * TILE_SIZE, -- y
--                     TILE_SIZE,             -- width
--                     TILE_SIZE,             -- height
--                     TILE_SIZE * 0.3,       -- rounding x
--                     TILE_SIZE * 0.3)       -- rounding y
--                 check = true
--             else
--                 check = false
--             end
--         end
--     end
-- end


--  -- input grid coords as normal
-- function Sight:sightCollision(grid, posX, posY, targX, targY, step)
--     -- LOTS OF CONSTANTS ADDED FOR SMOOTHNESS
--
--     -- check stepdetail
--     local step = step or 0.9
--
--     -- shift by 0.5
--     local k = 0.5
--     local posX = (posX + k) * TILE_SIZE - 1
--     local posY = (posY + k) * TILE_SIZE - 1
--     local targX = (targX + k) * TILE_SIZE
--     local targY = (targY + k) * TILE_SIZE
--
--     -- print('posX = ' .. posX .. ', posY = ' .. posY)
--     -- print('targX = ' .. targX .. ', targY = ' .. targY)
--     -- print()
--
--     -- make dx/dy
--     local dx = targX - posX
--     local dy = targY - posY
--     local lenScalar = ((dy^2 + dx^2)^0.5)
--     local dxx = (dx/lenScalar)*10*step
--     local dyy = (dy/lenScalar)*10*step
--
--
--
--     -- print('lenScalar = ' .. lenScalar)
--     -- print('dx = ' .. dx .. ', dy = ' .. dy)
--     -- print('dxx = ' .. dxx .. ', dyy = ' .. dyy)
--     -- print()
--
--     local x = dxx/step
--     local y = dyy/step
--     local counter = 0
--     local switch = true
--     while (math.abs(y) <= math.abs(dy) and math.abs(x) <= math.abs(dx)) do
--
--         -- check tile id
--         local tile = getTile(grid, posX + x, posY + y)
--
--         -- add to draw table
--         self.drawTable[#self.drawTable + 1] = {
--             ['x'] = posX + x,
--             ['y'] = posY + y,
--             ['tile'] = WALL_TILE
--         }
--
--         -- check for non-floor tile
--         if tile['id'] ~= FLOOR_TILE['id'] then
--
--             self.drawTable[#self.drawTable + 1] = {
--                 ['x'] = posX + x,
--                 ['y'] = posY + y,
--                 ['tile'] = tile
--             }
--             self.sightMap2[(targY-1)*GRID_WIDTH + targX] = tile
--
--             -- self.sightMap2[#self.sightMap2 + 1] = {
--             --     ['x'] =
--             -- }
--
--             -- debugging
--             -- print('counter = ' .. counter .. ', id = ' .. id)
--             -- print()
--             -- print()
--             break
--         end
--
--         y = y + dyy
--         x = x + dxx
--     end
-- end





















-- sight
-- function Sight:sightsightsight(agent, grid)
--
--     local agentSightMap[agent.x, agent.y] = agent.RGB
--     -- sight: increasing squares
--     local searchSize = 1
--
--     -- while agentSightMap
--     while(some unexplored)
--
--         -- make square
--         local square = makeSquareList(searchSize, agent.x, agent.y, 'odd')
--         for n in pairs(square) do
--             -- set x,y from square
--             x = square[n]['x']
--             y = square[n]['y']
--             -- check for x,y leaving the boundaries
--             if x < 0 then
--                 x = 0
--             elseif x > GRID_WIDTH then
--                 x = GRID_WIDTH
--             elseif y < 0
--                 y = 0
--             elseif y > GRID_HEIGHT
--                 y = GRID_HEIGHT
--             end
--             -- check for non-floor tiles
--             if grid[(y-1)*GRID_WIDTH + x]['id'] ~= FLOOR_TILE['id'] then
--                 agentSightMap[(y-1)*GRID_WIDTH+x] = grid[(y-1)*GRID_WIDTH + x]
--                 -- SET THE ONES BEHIND IT TO NIL
--             end
--         end
--
--
--
--         searchSize = searchSize + 1
--     end
-- end

-- input grid coordinates
-- function Sight:drawLines(x1, y1, x2, y2)
--     local corners1 = Sight:determineViewCorners(x1, y1, x2, y2)
--     local corners2 = Sight:determineViewCorners(x2, y2, x1, y1)
--     local k = TILE_SIZE
--     love.graphics.setColor(1, 1, 1)
--     love.graphics.line(
--         (corners1[1]['x']-1)*k,
--         (corners1[1]['y']+2)*k,
--         (corners2[1]['x']-1)*k,
--         (corners2[1]['y']+2)*k)
--     love.graphics.line(
--         (corners1[2]['x']-1)*k,
--         (corners1[2]['y']+2)*k,
--         (corners2[2]['x']-1)*k,
--         (corners2[2]['y']+2)*k)
-- end
--
--
-- function Sight:determineViewCorners(posX, posY, targX, targY)
--     local corners = {}
--
--     -- if target on top of you
--     if posX == targX and posY == targY then
--         corners[1] = {['x'] = posX, ['y'] = posY}
--         corners[2] = {['x'] = posX+1, ['y'] = posY+1}
--     end
--
--     -- above, below
--     if posX == targX then
--         -- above
--         if posY > targY then
--             corners[1] = {['x'] = posX, ['y'] = posY}
--             corners[2] = {['x'] = posX + 1, ['y'] = posY}
--
--         -- below
--     elseif posY < targY then
--             corners[1] = {['x'] = posX, ['y'] = posY + 1}
--             corners[2] = {['x'] = posX + 1, ['y'] = posY + 1}
--         end
--     end
--
--     -- right-left
--     if posY == targY then
--         -- right
--         if posX < targX then
--             corners[1] = {['x'] = posX + 1, ['y'] = posY}
--             corners[2] = {['x'] = posX + 1, ['y'] = posY + 1}
--
--         -- left
--     elseif posX > targX then
--             corners[1] = {['x'] = posX, ['y'] = posY}
--             corners[2] = {['x'] = posX, ['y'] = posY + 1}
--         end
--     end
--
--     -- top right
--     if (posY > targY and posX < targX) or
--         (posY < targY and posX > targX) then
--         corners[1] = {['x'] = posX, ['y'] = posY}
--         corners[2] = {['x'] = posX + 1, ['y'] = posY + 1}
--     end
--
--     -- bottom right
--     if (posY < targY and posX < targX) or
--         (posY > targY and posX > targX) then
--         corners[1] = {['x'] = posX + 1, ['y'] = posY}
--         corners[2] = {['x'] = posX, ['y'] = posY + 1}
--     end
--
--     --debugging
--     print('-------------------\n1:')
--     io.write(corners[1]['x'])
--     io.write(' ')
--     io.write(corners[1]['y'])
--     print('\n2:')
--     io.write(corners[2]['x'])
--     io.write(' ')
--     io.write(corners[2]['y'])
-- end
