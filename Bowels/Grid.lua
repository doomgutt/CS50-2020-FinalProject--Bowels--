Grid = Class{}

require 'Sight'
require 'Smell'

require 'Agent'
require 'Util'

require 'Maps'

function Grid:init ()

    self.senses = {}

    -- 1D list printed to the screen
    self.grid = {}
    self.wallList = {}

    -- -- fill grid with floors
    -- self:makeFloor()
    -- -- fill the walls list
    -- self:wallsInit()
    -- -- put walls on grid
    -- self:makeWalls()

    self:makeMap(MAP_1)


    -- init agents
    self.agents = {
        ['Toe_1'] = Agent('Toe', self.grid),
        ['Nostril'] = Agent('Nostril', self.grid)
    }

    -- init senses
    self.senses['Toe_1'] = Sight(self.grid, self.agents['Toe_1'])
    self.senses['Nostril'] = Smell(self.grid, self.agents['Nostril'])

    -- self:getTile(0, 0)
end


-- update grid
function Grid:update(dt)

    -- -- removes previous agent placements
    -- self:makeFloor()
    -- self:makeWalls()
    self:makeMap(MAP_1)

    if self.agents['Toe_1'].status['out'] == true then
        self:init()
    end

    -- udpate agents
    for _, agent in pairs(self.agents) do
        if agent.status['alive'] then
            agent:update(dt)
        end
    end

    -- place agents
    for _, agent in pairs(self.agents) do
        if agent.status['alive'] then
            self:gridPlaceTile(agent.x, agent.y, agent.tile)
        end
    end

    -- udpate senses
    for name, sense in pairs(self.senses) do
        if self.agents[name].status['alive'] then
            sense:update(self.grid, self.agents[name])
        end
    end

    if self.agents['Nostril'].x == self.agents['Toe_1'].x and
        self.agents['Nostril'].y == self.agents['Toe_1'].y then
        self.agents['Toe_1'].status['alive'] = false
    end

    -- -- agent updates
    -- self.agents['Toe_1']:update(dt)
    -- self.agents['Nostril']:update(dt)
    -- -- agent placements
    -- self:gridPlaceTile(self.agents['Nostril'].x,
    --     self.agents['Nostril'].y,
    --     self.agents['Nostril'].tile)
    -- self:gridPlaceTile(self.agents['Toe_1'].x,
    --     self.agents['Toe_1'].y,
    --     self.agents['Toe_1'].tile)
    --
    -- -- update the senses
    -- self.senses['Toe_1']:update(self.grid, self.agents['Toe_1'])
    -- self.senses['Nostril']:update(self.grid, self.agents['Nostril'])
end


-- draw grid
function Grid:render()

    -- render movement map
    for y = 1, GRID_HEIGHT do
        for x = 1, GRID_WIDTH do
            local col
            if self.grid[(y - 1) * GRID_WIDTH + x]['id'] == EXCLUDE_AGENT_ID_1 or
                self.grid[(y - 1) * GRID_WIDTH + x]['id'] == EXCLUDE_AGENT_ID_2 then
                col = FLOOR_TILE['RGB']
            else
                col = self.grid[(y - 1) * GRID_WIDTH + x]['RGB']
            end

            love.graphics.setColor(
                col['r'],
                col['g'],
                col['b'])
            self:customTile(x, y)
        end
    end

    -- render sense UI
    self:senseUI(3, 23, self.senses['Toe_1'], self.agents['Toe_1'])
    self:senseUI(33, 23, self.senses['Nostril'], self.agents['Nostril'])

    -- render sight rays
    self.senses['Toe_1']:render(SIGHT_RAYS)
    -- love.graphics.line((1)*TILE_SIZE, (1+3)*TILE_SIZE, 20*TILE_SIZE, (20+3)*TILE_SIZE)

    -- self:renderSight()
end


--%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
--- %% MAKE MAP %% -------------------------------------------------------------
function Grid:makeMap(mapModel)
    local map = mapModel

    for y = 1, GRID_HEIGHT do
        for x = 1, GRID_WIDTH do
            self.grid[(y - 1) * GRID_WIDTH + x] = TILE_LIST[map[(y - 1) * GRID_WIDTH + x]]
        end
    end
end


--- %% RENDER FUNCTIONS %% -----------------------------------------------------


-- place agent on the grid
function Grid:gridPlaceTile(x, y, tile)
    self.grid[(y - 1) * GRID_WIDTH + x] = tile
end


-- Senses UI
function Grid:senseUI(posX, posY, agentSenses, agent)
    -- check for dead agent
    local UIout
    local UIself
    if agent.status['alive'] then
        UIself = agent.tile['RGB']
        UIout = agentSenses.UIoutput
    else
        UIself = VOID_TILE['RGB']
        UIout = DEAD_UI_OUTPUT
    end

    -- sense bg
    for y = posY-1, posY + 6 do
        for x = posX-1, posX + 6 do
            love.graphics.setColor(0.2, 0.2, 0.2)
            self:customTile(x, y)
        end
    end

    -- agent tile
    self:senseUItile(posX + 1*2, posY + 1*2, UIself)

    -- manually drawing senses
    self:senseUItile(posX + 0*2, posY + 0*2, UIout[1])
    self:senseUItile(posX + 1*2, posY + 0*2, UIout[2])
    self:senseUItile(posX + 2*2, posY + 0*2, UIout[3])
    self:senseUItile(posX + 0*2, posY + 1*2, UIout[8])
    self:senseUItile(posX + 2*2, posY + 1*2, UIout[4])
    self:senseUItile(posX + 0*2, posY + 2*2, UIout[7])
    self:senseUItile(posX + 1*2, posY + 2*2, UIout[6])
    self:senseUItile(posX + 2*2, posY + 2*2, UIout[5])

    -- 1 2 3
    -- 8   4
    -- 7 6 5


    -- for y = 0, 2 do
    --     for x = 0, 2 do
    --         if y == 0 then
    --             self:senseUItile(posX + x*2, posY + y*2, agentSenses.sightUImap[x+1])
    --         elseif y == 1 and x == 1 then
    --             self:senseUItile(posX + y*2, posY + y*2, agent.tile['RGB'])
    --         end
    --
    --     end
    -- end
end


function Grid:senseUItile(posX, posY, rgb)
    -- check for no tile input
    local RGB = rgb or VOID_TILE['RGB']

    love.graphics.setColor(
        RGB['r'],
        RGB['g'],
        RGB['b'])
    -- love.graphics.setColor(1,1,1, 0.5)
    self:customTile(posX, posY)
    self:customTile(posX + 1, posY)
    self:customTile(posX, posY + 1)
    self:customTile(posX + 1, posY + 1)
end


-- draw a rectangle at x,y
function Grid:customTile(x, y)
    love.graphics.rectangle('fill',
        (x) * TILE_SIZE,         -- x
        (y) * TILE_SIZE,         -- y
        TILE_SIZE,             -- width
        TILE_SIZE,             -- height
        TILE_SIZE * 0.3,       -- rounding x
        TILE_SIZE * 0.3)       -- rounding y
end




-- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
-- init map


-- -- adds a wall
-- function Grid:addWall(wallX, wallY)
--     self.wallList[(wallY - 1) * GRID_WIDTH + wallX] = true
-- end




-- -- writes floors to GRID
-- function Grid:makeFloor()
--     -- grid is 40 by 20
--     for y = 1, GRID_HEIGHT do
--         for x = 1, GRID_WIDTH do
--             -- set bg colour
--             self.grid[(y - 1) * GRID_WIDTH + x] = FLOOR_TILE
--         end
--     end
-- end
--
--
-- -- write WALLS to GRID
-- function Grid:makeWalls()
--     -- grid is 40 by 20
--     for y = 1, GRID_HEIGHT do
--         for x = 1, GRID_WIDTH do
--             -- set bg colour
--             if self.wallList[(y - 1) * GRID_WIDTH + x] == true then
--                 self.grid[(y - 1) * GRID_WIDTH + x] = WALL_TILE
--             end
--         end
--     end
-- end

-- wall placements
-- function Grid:wallsInit()
--
--     for x = 1, 40 do
--         self:addWall(x, 1)
--     end
--     for x = 1, 20 do
--         self:addWall(x, 20)
--     end
--     for y = 1, 20 do
--         self:addWall(1, y)
--     end
--     for y = 1, 20 do
--         self:addWall(40, y)
--     end
--
--     -- middle wall
--     self:addWall(20, 7)
--     self:addWall(20, 8)
--     self:addWall(20, 9)
--     self:addWall(20, 10)
--     self:addWall(20, 11)
--     self:addWall(20, 12)
--     self:addWall(20, 13)
--     self:addWall(20, 14)
--
--
--     -- left corner
--     self:addWall(7, 19)
--     self:addWall(7, 18)
--     self:addWall(7, 17)
--     self:addWall(7, 16)
--     self:addWall(6, 16)
--     self:addWall(5, 16)
--     self:addWall(4, 16)
--
--     -- left tube
--
--     self:addWall(3, 3)
--     self:addWall(3, 4)
--     self:addWall(3, 6)
--     self:addWall(3, 7)
--     self:addWall(3, 8)
--     self:addWall(3, 9)
--     self:addWall(4, 3)
--     self:addWall(5, 3)
--     self:addWall(6, 3)
--     self:addWall(7, 3)
--     self:addWall(8, 3)
--
--
--
--
--     -- self:addWall(8, 16)
-- end
