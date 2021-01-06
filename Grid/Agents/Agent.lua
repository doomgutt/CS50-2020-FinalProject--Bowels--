Agent = Class{}

require 'Grid/Agents/Toe'
require 'Grid/Agents/Nostril'
require 'Grid/Agents/Ear'


-- agent init
function Agent:init(type, grid, x, y)

    self.agentTypes = {
        ['Toe'] = Toe(),
        ['Nostril'] = Nostril(),
        ['Ear'] = Ear()}

    -- position
    self.x = x or self.agentTypes[type].x
    self.y = y or self.agentTypes[type].y

    -- movement
    self.moveSpeed = self.agentTypes[type].moveSpeed
    self.moveQUp = 0
    self.moveQDown = 0
    self.moveQLeft = 0
    self.moveQRight = 0
    self.yMoving = false
    self.xMoving = false

    -- smell
    self.senseOfSmell = self.agentTypes[type].senseOfSmell or 1

    -- sound
    self.senseOfHearing = self.agentTypes[type].senseOfHearing or 1
    self.stepLoudness = self.agentTypes[type].stepLoudness or 0.5
    self.bumpLoudness = self.agentTypes[type].bumpLoudness or 1
    self.xWallBump = false
    self.yWallBump = false

    -- controls
    self.senseControlKey = nil
    self.controls = self.agentTypes[type].controls

    -- self.tile['RGB'] = self.agentTypes[type].RGB
    self.tile = {
        ['id'] = self.agentTypes[type].id,
        ['RGB'] = self.agentTypes[type].standingRGB,
        ['smell'] = self.agentTypes[type].smell
    }
    -- self.id = self.agentTypes[type].id
    -- self.tile['RGB'] = self:agentRGB()
        self.standingRGB = self.agentTypes[type].standingRGB
        self.movingRGB = self.agentTypes[type].movingRGB

    self.collidables = {WALL_TILE['id']}
    self.grid = grid

    self.status = {
        ['alive'] = true,
        ['out'] = false
    }
end





-- agent update
function Agent:update(dt)
    self:movement(dt)
    self:senseControl(dt)
    self.tile['RGB'] = self:agentRGB()
    -- print(self.x)
    -- print(self.y)
    -- print(self.yMoving)
end


-- agent colour
function Agent:agentRGB()
    if self.yMoving or self.xMoving then
        self.tile['RGB'] = self.movingRGB
    else
        self.tile['RGB'] = self.standingRGB
    end
    return self.tile['RGB']
end


-- Movement
function Agent:movement(dt)

    -- y movement
    if love.keyboard.isDown(self.controls['up']) then
        self.moveQUp = self.moveQUp + dt
        if self.moveQUp > self.moveSpeed then
            while self.moveQUp > self.moveSpeed do
                self.moveQUp = self.moveQUp - self.moveSpeed
                if self:Collision(self.x, self.y - 1) then
                    self.y = self.y - 1
                    self.yMoving = true
                else
                    self.yMoving = false
                    self.yWallBump = true
                end
            end
        else
            self.yMoving = false
            self.yWallBump = false
        end

    elseif love.keyboard.isDown(self.controls['down']) then
        -- self.y = self.y + 1
        self.moveQDown = self.moveQDown + dt
        if self.moveQDown > self.moveSpeed then
            while self.moveQDown > self.moveSpeed do
                self.moveQDown = self.moveQDown - self.moveSpeed
                if self:Collision(self.x, self.y + 1) then
                    self.y = self.y + 1
                    self.yMoving = true
                else
                    self.yMoving = false
                    self.yWallBump = true
                end
            end
        else
            self.yMoving = false
            self.yWallBump = false
        end
    else
        self.moveQUp = 0
        self.moveQDown = 0
        self.yMoving = false
        self.yWallBump = false
    end

    -- x movement
    if love.keyboard.isDown(self.controls['left']) then
        -- self.x = self.x - 1
        self.moveQLeft = self.moveQLeft + dt
        if self.moveQLeft > self.moveSpeed then
            while self.moveQLeft > self.moveSpeed do
                self.moveQLeft = self.moveQLeft - self.moveSpeed
                if self:Collision(self.x - 1, self.y) then
                    self.x = self.x - 1
                    self.xMoving = true
                else
                    self.xMoving = false
                    self.xWallBump = true
                end
            end
        else
            self.xMoving = false
            self.xWallBump = false
        end
    elseif love.keyboard.isDown(self.controls['right']) then
        -- self.x = self.x + 1
        self.moveQRight = self.moveQRight + dt
        if self.moveQRight > self.moveSpeed then
            while self.moveQRight > self.moveSpeed do
                self.moveQRight = self.moveQRight - self.moveSpeed
                if self:Collision(self.x + 1, self.y) then
                    self.x = self.x + 1
                    self.xMoving = true
                else
                    self.xMoving = false
                    self.xWallBump = true
                end
            end
        else
            self.xMoving = false
            self.xWallBump = false
        end
    else
        self.moveQLeft = 0
        self.moveQRight = 0
        self.xMoving = false
        self.xWallBump = false
    end
end



function Agent:senseControl(dt)
    self.senseControlKey = nil
    if self.controls['senseDown'] ~= nil then
        if love.keyboard.isDown(self.controls['senseUp']) then
            self.senseControlKey = 'up'
        elseif love.keyboard.isDown(self.controls['senseDown']) then
            self.senseControlKey = 'down'
        end
    end
end




-- check collision
function Agent:Collision(nextX, nextY)
    if self:withinBounds(nextX, nextY) then
        -- for _, v in pairs(self.collidables) do
        --     print(v)
        --

        -- print(self.grid[(nextY - 1) * GRID_WIDTH + nextX]['id'])
        for _, v in pairs(self.collidables) do
            if v == self.grid[(nextY - 1) * GRID_WIDTH + nextX]['id'] then
                return false
            else
                return true
            end
        end
    else
        return false
    end
end







function Agent:withinBounds(nextX, nextY)
    if nextX > GRID_WIDTH or nextX < 1 or nextY > GRID_HEIGHT or nextY < 1 then
        self.status['out'] = true
        print("AAAAAAAAAAA")
        return false
    else
        self.status['out'] = false
        return true
    end
end
