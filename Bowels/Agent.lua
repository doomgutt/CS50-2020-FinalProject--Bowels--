Agent = Class{}

require "Toe"
require 'Nostril'
require 'Ear'


-- agent init
function Agent:init(type, grid)

    self.x = AGENT_TYPES[type].x
    self.y = AGENT_TYPES[type].y
        self.moveQUp = 0
        self.moveQDown = 0
        self.moveQLeft = 0
        self.moveQRight = 0
            self.yMoving = 0
            self.xMoving = 0
        self.senseControlKey = nil

    self.moveSpeed = AGENT_TYPES[type].moveSpeed
    self.controls = AGENT_TYPES[type].controls

    -- self.tile['RGB'] = AGENT_TYPES[type].RGB
    self.tile = {
        ['id'] = AGENT_TYPES[type].id,
        ['RGB'] = AGENT_TYPES[type].standingRGB
    }
    -- self.id = AGENT_TYPES[type].id
    -- self.tile['RGB'] = self:agentRGB()
        self.standingRGB = AGENT_TYPES[type].standingRGB
        self.movingRGB = AGENT_TYPES[type].movingRGB

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
    if self.yMoving == 1 or self.xMoving == 1 then
        self.tile['RGB'] = self.movingRGB
    elseif self.yMoving == 0 and self.xMoving == 0 then
        self.tile['RGB'] = self.standingRGB
    end
    return self.tile['RGB']
end


-- Movement
function Agent:movement(dt)

    -- y movement
    if love.keyboard.isDown(self.controls['up']) then
        self.moveQUp = self.moveQUp + dt
        while self.moveQUp > self.moveSpeed do
            self.moveQUp = self.moveQUp - self.moveSpeed
            if self:Collision(self.x, self.y - 1) then
                self.y = self.y - 1
                self.yMoving = 1
            else
                self.yMoving = 0
            end
        end
    elseif love.keyboard.isDown(self.controls['down']) then
        -- self.y = self.y + 1
        self.moveQDown = self.moveQDown + dt
        while self.moveQDown > self.moveSpeed do
            self.moveQDown = self.moveQDown - self.moveSpeed
            if self:Collision(self.x, self.y + 1) then
                self.y = self.y + 1
                self.yMoving = 1
            else
                self.yMoving = 0
            end
        end
    else
        self.moveQUp = 0
        self.moveQDown = 0
        self.yMoving = 0
    end

    -- x movement
    if love.keyboard.isDown(self.controls['left']) then
        -- self.x = self.x - 1
        self.moveQLeft = self.moveQLeft + dt
        while self.moveQLeft > self.moveSpeed do
            self.moveQLeft = self.moveQLeft - self.moveSpeed
            if self:Collision(self.x - 1, self.y) then
                self.x = self.x - 1
                self.xMoving = 1
            else
                self.xMoving = 0
            end
        end
    elseif love.keyboard.isDown(self.controls['right']) then
        -- self.x = self.x + 1
        self.moveQRight = self.moveQRight + dt
        while self.moveQRight > self.moveSpeed do
            self.moveQRight = self.moveQRight - self.moveSpeed
            if self:Collision(self.x + 1, self.y) then
                self.x = self.x + 1
                self.xMoving = 1
            else
                self.xMoving = 0
            end
        end
    else
        self.moveQLeft = 0
        self.moveQRight = 0
        self.xMoving = 0
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
