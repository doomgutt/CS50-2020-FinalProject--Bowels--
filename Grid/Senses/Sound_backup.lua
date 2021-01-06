Sound = Class{}

function Sound:init(grid, agent)
    self.soundMap = {}
    self.UIoutput = {}

    -- debugging
    self.soundPlot = {}
    self.soundDistance = (GRID_WIDTH + GRID_HEIGHT)*TILE_SIZE

    -- debug
    self.drawLines = {}
    self.debugBeamInfo = false
    self.debugStepLines = false
    self.debugLines = false
    self.debugPartciles = true

end


function Sound:update(dt, grid, agent, gridSounds)
    self.drawLines = {}
    self.soundMap = gridSounds

    self:radialHearing(grid, agent)

    self:makeSound(agent, grid)
    self:updateSoundMap(dt, grid)
    self:makeUImap(agent, grid)

    return self.soundMap
end


function Sound:render()

    -- -- debug lines
    if self.debugLines then
        love.graphics.setColor(0.6, 0.6, 0.6)
        for n, line in pairs(self.drawLines) do
            love.graphics.line(line['x1'], line['y1'], line['x2'], line['y2'])
        end
    end

    if self.debugPartciles then
        for _, sound in pairs(self.soundMap) do
            local col = sound['strength']
            love.graphics.setColor(col, col, col)
            love.graphics.rectangle('fill', sound['x']-1.5, sound['y']-1.5, 3, 3)
        end
    end


    -- sound ray debugging
    if self.debugStepLines then
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



-- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


-- moves sounds and updates their strengths
-- NOTE, THERE IS A BUG THAT MIGHT EVENTUALLY SLOW THE GAME DOWN
-- SOMETIMES SOUND PARTICLES GET STUCK AND DONT GET DELETED????
function Sound:updateSoundMap(dt, grid)
    local step = 20
    local soundDecay = 0.4
    for n, sound in pairs(self.soundMap) do

        local tile = getTile(grid, sound['x'], sound['y'])
        -- if strength <= 0 the sound dies
        if sound['strength'] <= 0 or
                sound['x'] > GRID_WIDTH*TILE_SIZE or
                sound['x'] < 0 or
                sound['y'] > GRID_HEIGHT*TILE_SIZE or
                sound['y'] < 0 or
                tile == nil then
            self.soundMap[n] = nil
        end

        -- check for collision

        if tile ~= nil then

            -- if tile['id'] == WALL_TILE['id'] then
            --     sound['strength'] = sound['strength'] - soundDecay
            --     sound['x'], sound['y'], sound['dx'], sound['dy'] = self:reflectionXY(sound['x'], sound['y'], sound['dx'], sound['dy'])
            --     -- sound['x'] = sound['x'] + sound['dx']*TILE_SIZE*0.2
            --     -- sound['y'] = sound['y'] + sound['dy']*TILE_SIZE*0.2
            -- end

            -- update sound
            sound['x'] = sound['x'] + sound['dx'] * step * dt
            sound['y'] = sound['y'] + sound['dy'] * step * dt
            sound['strength'] = sound['strength'] - soundDecay * dt
        end
    end
end


-- calculates sound reflections
function Sound:reflectionXY(collisionX, collisionY, dx, dy)

    local tileRadius = 0.5 * TILE_SIZE

    local midpointX = math.floor(collisionX/TILE_SIZE)*TILE_SIZE + tileRadius
    local midpointY = math.floor(collisionY/TILE_SIZE)*TILE_SIZE + tileRadius

    local c = collisionY - (dy/dx)*collisionX


    local x
    local y
    local fx = 0
    if self.debugBeamInfo then
        print('--------------------------------')
        print('x diff = ' .. collisionX - midpointX)
        print('y diff = ' .. collisionY - midpointY)
        print('--------------------------------')
        print('in: dx = ' .. dx .. ' | dy = ' .. dy)
    end
    --  coming from the right
    if dx < 0 then
        x = midpointX + tileRadius
        fx = c + (dy/dx) * x
        -- y lower than bounds
        if fx >= (midpointY + tileRadius) then
            y = midpointY + tileRadius
            x = (y - c)*(dx/dy)
            dy = -dy
        -- y higher than bounds
    elseif fx <= (midpointY - tileRadius) then
            y = midpointY - tileRadius
            x = (y - c)*(dx/dy)
            dy = -dy
        -- within bounds, so set y
        else
            y = fx
            dx = -dx
        end

    -- coming from the left
    elseif dx > 0 then
        x = midpointX - tileRadius
        fx = c + (dy/dx) * x
        -- y lower than bounds
        if self.debugBeamInfo then
            print('fx = ' .. fx .. ' | dy/dx = ' .. dy/dx .. ' | c = ' .. c)
            print(' midpointY - tileRadius: ' .. (midpointY - tileRadius))
            print(' midpointY: ' .. midpointY)
            print(' midpointY + tileRadius: ' .. (midpointY + tileRadius))
            print('coll x, y: [' .. collisionX .. ', ' .. collisionY .. ']')
            print('grid x, y: [' .. math.floor(collisionX/TILE_SIZE) .. ', ' .. math.floor(collisionY/TILE_SIZE) .. ']')
            print()
        end
        if fx >= (midpointY + tileRadius) then
            y = midpointY + tileRadius
            x = (y - c)*(dx/dy)
            dy = -dy
        -- y higher than bounds
    elseif fx <= (midpointY - tileRadius) then
            y = midpointY - tileRadius
            x = (y - c)*(dx/dy)
            dy = -dy
        -- within bounds, so set y
        else
            y = fx
            dx = -dx
        end
    end
    if self.debugBeamInfo then
        print('out: dx = ' .. dx .. ' | dy = ' .. dy)
        print('new x, y: [' .. x .. ', ' .. y .. ']')
        print('________________________________________')
    end

    return x, y, dx, dy
end


-- Hearing UI
function Sound:makeUImap(agent, grid)
    local gridSounds = grid.gridSounds
    local k = 1 -- hearing constant
    local c = 0 -- circle adjust

    for n = 1, 8 do
        self.UIoutput[n] = {
            ['r'] = 0,
            ['g'] = 0,
            ['b'] = 0
        }
    end

    local pi = math.pi

    local selfX1 = agent.x * TILE_SIZE
    local selfY1 = agent.y * TILE_SIZE
    local selfX2 = (agent.x + 1) * TILE_SIZE
    local selfY2 = (agent.y + 1) * TILE_SIZE


    for _, sound in ipairs(self.soundMap) do
        if (selfX1 <= sound['x'] and sound['x'] <= selfX2) and
            (selfY1 <= sound['y'] and sound['y'] <= selfY2) then

            local deg = sound['rad'] % pi-- math.atan(sound['dy']/sound['dx']) % pi

            -- + (c*pi)/8)

            print(deg)

            -- for n = 1, 8 do
            --
            --     print('lower bound: ' .. 360*(n-1)*(pi/8)/pi)
            --     print(360 * deg / pi)
            --     print('upper bound: ' .. 360*(n)*(pi/8)/pi)
            --     print()
            --
            --     if (n-1)*(pi/8) <= deg and deg < (n)*(pi/8) then
            --         local str = sound['strength']
            --
            --         n = (n + 1) % 8 + 1
            --
            --         self.UIoutput[n]['r'] = self.UIoutput[n]['r'] + str * k
            --         self.UIoutput[n]['g'] = self.UIoutput[n]['g'] + str * k
            --         self.UIoutput[n]['b'] = self.UIoutput[n]['b'] + str * k
            --
            --         -- for n, col in pairs(self.UIoutput) do
            --         --     print(n)
            --         --     print('r' .. col['r'])
            --         --     print('g' .. col['g'])
            --         --     print('b' .. col['b'])
            --         --     print()
            --         -- end
            --     end
            -- end
            local numberCheck = {
                ['1'] = 5, -- r
                ['2'] = 6, -- dr
                ['3'] = 7, -- d
                ['4'] = 8, -- l
                ['5'] = 1, -- dl
                ['6'] = 2, -- ul
                ['7'] = 3, -- u
                ['8'] = 4 -- ur
            }

            if 0*(pi/8) <= deg and deg < 1*(pi/8) then
                local n = numberCheck['1']
                self.UIoutput[n]['r'] = self.UIoutput[n]['r'] + str * k
                self.UIoutput[n]['g'] = self.UIoutput[n]['g'] + str * k
                self.UIoutput[n]['b'] = self.UIoutput[n]['b'] + str * k
                --
            elseif 1*(pi/8) <= deg and deg < 2*(pi/8) then
                local n = numberCheck['2']
                self.UIoutput[n]['r'] = self.UIoutput[n]['r'] + str * k
                self.UIoutput[n]['g'] = self.UIoutput[n]['g'] + str * k
                self.UIoutput[n]['b'] = self.UIoutput[n]['b'] + str * k
                --
            elseif 2*(pi/8) <= deg and deg < 3*(pi/8) then
                local n = numberCheck['3']
                self.UIoutput[n]['r'] = self.UIoutput[n]['r'] + str * k
                self.UIoutput[n]['g'] = self.UIoutput[n]['g'] + str * k
                self.UIoutput[n]['b'] = self.UIoutput[n]['b'] + str * k
                --
            elseif 3*(pi/8) <= deg and deg < 4*(pi/8) then
                local n = numberCheck['4']
                self.UIoutput[n]['r'] = self.UIoutput[n]['r'] + str * k
                self.UIoutput[n]['g'] = self.UIoutput[n]['g'] + str * k
                self.UIoutput[n]['b'] = self.UIoutput[n]['b'] + str * k
                --
            elseif 4*(pi/8) <= deg and deg < 5*(pi/8) then
                local n = numberCheck['5']
                self.UIoutput[n]['r'] = self.UIoutput[n]['r'] + str * k
                self.UIoutput[n]['g'] = self.UIoutput[n]['g'] + str * k
                self.UIoutput[n]['b'] = self.UIoutput[n]['b'] + str * k
                --
            elseif 5*(pi/8) <= deg and deg < 6*(pi/8) then
                local n = numberCheck['6']
                self.UIoutput[n]['r'] = self.UIoutput[n]['r'] + str * k
                self.UIoutput[n]['g'] = self.UIoutput[n]['g'] + str * k
                self.UIoutput[n]['b'] = self.UIoutput[n]['b'] + str * k
                --
            elseif 6*(pi/8) <= deg and deg < 7*(pi/8) then
                local n = numberCheck['7']
                self.UIoutput[n]['r'] = self.UIoutput[n]['r'] + str * k
                self.UIoutput[n]['g'] = self.UIoutput[n]['g'] + str * k
                self.UIoutput[n]['b'] = self.UIoutput[n]['b'] + str * k
                --
            elseif 7*(pi/8) <= deg and deg < 8*(pi/8) then
                local n = numberCheck['8']
                self.UIoutput[n]['r'] = self.UIoutput[n]['r'] + str * k
                self.UIoutput[n]['g'] = self.UIoutput[n]['g'] + str * k
                self.UIoutput[n]['b'] = self.UIoutput[n]['b'] + str * k
                --
            end

        end
    end

    -- for _, soundRGB in pairs(self.UIoutput) do
    --     for n, col in pairs(soundRGB) do
    --         if col > 1 then
    --             col = 1
    --         elseif col < 0 then
    --             col = 0
    --         end
    --     end
    -- end

    -- self.soundMap[#self.soundMap + 1] = {
    --         ['x'] = self_x,
    --         ['y'] = self_y,
    --         ['dx'] = (TILE_SIZE*0.2)*dx,
    --         ['dy'] = (TILE_SIZE*0.2)*dy,
    --         ['strength'] = str,
    --         ['id'] = nil,
    --         ['RGB'] = nil
    -- }
end




-- make sounds when walking or bumping
function Sound:makeSound(agent, partitions, step)
    local makingSound = false
    local str = 0

    if agent.xMoving or agent.yMoving then
        makingSound = true
        str = agent.stepLoudness
    elseif agent.xWallBump or agent.yWallBump then
        makingSound = true
        str = agent.bumpLoudness
    end

    if makingSound then

        local self_x = (agent.x + 0.5) * TILE_SIZE
        local self_y = (agent.y + 0.5) * TILE_SIZE

        -- circle setup
        local partitions = 180 -- partitions or 1
        local step = 5 -- step or 5

        -- circle math
        local fullCircle = math.pi*2
        local radialIncrement = fullCircle/partitions

        for n = 1, 1 do

            -- circle direction calculation -- 0.019
            local k = 0 --fullCircle/(8^3) - 2*(fullCircle/8) -- adjusting circle a little
            local circleMapStep = -(n * fullCircle)/8

            -- for every circle direction
            for rad = -(fullCircle)/16 + k + circleMapStep,
                       (fullCircle)/16 + k + circleMapStep,
                       radialIncrement do

                print(rad % math.pi)

                -- calculate x,y step
                local dy = math.cos(rad)*step
                local dx = math.sin(rad)*step
                -- print(dx)
                -- print(dy)
                -- print()

                self.soundMap[#self.soundMap + 1] = {
                        ['x'] = self_x,
                        ['y'] = self_y,
                        ['dx'] = (TILE_SIZE*0.2)*dx,
                        ['dy'] = (TILE_SIZE*0.2)*dy,
                        ['strength'] = str,
                        ['id'] = nil,
                        ['RGB'] = nil,
                        ['rad'] = rad
                }
            end
        end
        print()
    end
end



































-- mostly for debugging

function Sound:radialHearing(grid, agent, step, partitions)
    -- clear sound
    self.soundPlot = {}

    -- init vars
    local partitions = partitions or 180
    local step = step or 5

    -- circle math
    local fullCircle = math.pi*2
    local radialIncrement = fullCircle/partitions

    for n = 1, 8 do
        local circleMapStep = -(n * fullCircle)/8

        -- circle direction calculation -- 0.019
        local k = fullCircle/(8^3) - 2*(fullCircle/8) -- adjusting circle a little

        -- self position
        local self_x = (agent.x + 0.5) * TILE_SIZE
        local self_y = (agent.y + 0.5) * TILE_SIZE

        -- for every circle direction
        for rad = -(fullCircle)/16 + k + circleMapStep,
                   (fullCircle)/16 + k + circleMapStep,
                   radialIncrement do

            -- calculate x,y step
            local dy = math.cos(rad)*step
            local dx = math.sin(rad)*step


            -- local dx = 2
            -- local dy = -4

            local collisionX, collisionY
            collisionX, collisionY = self:makeBeam(self_x, self_y, dx, dy, grid)
            new_x, new_y, new_dx, new_dy = self:reflectionXY(collisionX, collisionY, dx, dy)

            collisionX, collisionY = self:makeBeam(new_x, new_y, new_dx, new_dy, grid)
            new_x, new_y, new_dx, new_dy = self:reflectionXY(collisionX, collisionY, dx, dy)

        end
    end
end



function Sound:makeBeam(self_x, self_y, dx, dy, grid)

    local dxx = (TILE_SIZE*0.2)*dx
    local dyy = (TILE_SIZE*0.2)*dy

    local collisionX = self_x + dxx
    local collisionY = self_y + dyy

    if self.debugBeamInfo then
        print('self x, y: [' .. self_x .. ', ' .. self_y .. ']')
        print('self x+dxx, y+dyy : [' .. self_x+dxx .. ', ' .. self_y+dyy .. ']')
    end

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

        -- check for edge pf screen
        if tile == nil then
            self.soundPlot[#self.soundPlot + 1] = {
                ['x'] = self_x + dxx,
                ['y'] = self_y + dyy,
                ['tile'] = VOID_TILE}

            collisionX = self_x + dxx
            collisionY = self_y + dyy

            break
        -- check for non-floor tiles
        elseif tile['id'] ~= FLOOR_TILE['id'] then
            self.soundPlot[#self.soundPlot + 1] = {
                ['x'] = self_x + dxx,
                ['y'] = self_y + dyy,
                ['tile'] = tile}

            collisionX = self_x + dxx
            collisionY = self_y + dyy

            break
        end

        -- update dy/dx
        dxx = dxx + dx
        dyy = dyy + dy
        dist = (dxx^2 + dyy^2)^0.5
    end
    -- print(collisionX)
    -- print(collisionY)


    self.drawLines[#self.drawLines + 1] = {
            ['x1'] = self_x,
            ['y1'] = self_y,
            ['x2'] = collisionX,
            ['y2'] = collisionY
    }


    return collisionX, collisionY
end
