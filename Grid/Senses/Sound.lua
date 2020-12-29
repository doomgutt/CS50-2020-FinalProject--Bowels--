Sound = Class{}

function Sound:init(grid, agent)
    self.soundMap = {}
    self.soundUImap = {}

    self.soundPlot = {}
    self.soundGrid = {}
    self.UIoutput = self.soundUImap


    self.soundDistance = (GRID_WIDTH + GRID_HEIGHT)*TILE_SIZE

    -- self x, y
    self.agentX = agent.x
    self.agentY = agent.y
end


function Sound:update(dt, grid, agent)
    self.agentX = agent.x
    self.agentY = agent.y
    self:radialHearing(grid, agent)
    -- self:makeUImap(agent)
end


function Sound:render(soundRays)
    local soundRays = soundRays or 'n'
    -- sound ray debugging
    if soundRays == 'y' then
        for i, XY in pairs(self.soundPlot) do
            local col = XY['tile']['RGB']
            love.graphics.setColor(
                col['r']+50/255,
                col['g']+50/255,
                col['b']+50/255)
            love.graphics.rectangle('fill', XY['x']-1.5, XY['y']-1.5, 3, 3)
        end
    end
end



-- beam info:
-- -- dxx, dyy
-- -- strength



function Sound:radialHearing(grid, agent, step, partitions)
    -- clear sound
    self.soundPlot = {}
    self.soundGrid = {
        [1] = {}, -- 1 - ul
        [2] = {}, -- 2 - u
        [3] = {}, -- 3 - ur
        [4] = {}, -- 4 - r
        [5] = {}, -- 5 - dr
        [6] = {}, -- 6 - d
        [7] = {}, -- 7 - dl
        [8] = {}}  -- 8 - l

    -- init vars
    local partitions = partitions or 1
    local step = step or 5

    -- self position
    local self_x = (agent.x + 0.5) * TILE_SIZE
    local self_y = (agent.y + 0.5) * TILE_SIZE

    -- circle math
    local fullCircle = math.pi*2
    local radialIncrement = fullCircle/partitions

    for n = 1, 1 do
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
            while dist < self.soundDistance do
                -- get tile
                local tile = getTile(grid, self_x + dxx, self_y + dyy)
                local tile_x = math.floor((self_x + dxx) / TILE_SIZE)
                local tile_y = math.floor((self_y + dyy) / TILE_SIZE)

                -- debugging: add transient sound
                self.soundPlot[#self.soundPlot + 1] = {
                    ['x'] = self_x + dxx,
                    ['y'] = self_y + dyy,
                    ['tile'] = tile or VOID_TILE}
                self.soundGrid[n][#self.soundGrid[n] + 1] = {
                    ['tile'] = tile or VOID_TILE,
                    ['dist'] = dist}

                -- check for edge pf screen
                if tile == nil then
                    self.soundPlot[#self.soundPlot + 1] = {
                        ['x'] = self_x + dxx,
                        ['y'] = self_y + dyy,
                        ['tile'] = VOID_TILE}
                    self.soundGrid[n][#self.soundGrid[n] + 1] = {
                        ['tile'] = VOID_TILE,
                        ['dist'] = dist}
                    break
                -- check for non-floor tiles
                elseif tile['id'] ~= FLOOR_TILE['id'] then
                    self.soundPlot[#self.soundPlot + 1] = {
                        ['x'] = self_x + dxx,
                        ['y'] = self_y + dyy,
                        ['tile'] = tile}
                    self.soundGrid[n][#self.soundGrid[n] + 1] = {
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











function Sight:determineViewCorners(posX, posY, targX, targY)
    local corners = {}
    local targetPosition = ''

    -- if target on top of you
    if posX == targX and posY == targY then
        corners[1] = {['x'] = posX, ['y'] = posY}
        corners[2] = {['x'] = posX+1, ['y'] = posY+1}
    end

    -- above, below
    if posX == targX then
        -- above
        if posY > targY then
            corners[1] = {['x'] = posX, ['y'] = posY}
            corners[2] = {['x'] = posX + 1, ['y'] = posY}

        -- below
    elseif posY < targY then
            corners[1] = {['x'] = posX, ['y'] = posY + 1}
            corners[2] = {['x'] = posX + 1, ['y'] = posY + 1}
        end
    end

    -- right-left
    if posY == targY then
        -- right
        if posX < targX then
            corners[1] = {['x'] = posX + 1, ['y'] = posY}
            corners[2] = {['x'] = posX + 1, ['y'] = posY + 1}

        -- left
    elseif posX > targX then
            corners[1] = {['x'] = posX, ['y'] = posY}
            corners[2] = {['x'] = posX, ['y'] = posY + 1}
        end
    end

    -- top right
    if (posY > targY and posX < targX) or
        (posY < targY and posX > targX) then
        corners[1] = {['x'] = posX, ['y'] = posY}
        corners[2] = {['x'] = posX + 1, ['y'] = posY + 1}
    end

    -- bottom right
    if (posY < targY and posX < targX) or
        (posY > targY and posX > targX) then
        corners[1] = {['x'] = posX + 1, ['y'] = posY}
        corners[2] = {['x'] = posX, ['y'] = posY + 1}
    end

    --debugging
    print('-------------------\n1:')
    io.write(corners[1]['x'])
    io.write(' ')
    io.write(corners[1]['y'])
    print('\n2:')
    io.write(corners[2]['x'])
    io.write(' ')
    io.write(corners[2]['y'])
end
