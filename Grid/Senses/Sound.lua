Sound = Class{}

function Sound:init(grid, agent)
    self.soundMap = {}
    self.soundUImap = {}

    self.UIoutput = self.soundUImap


    self.soundDistance = (GRID_WIDTH + GRID_HEIGHT)*TILE_SIZE

    -- self x, y
    self.agentX = agent.x
    self.agentY = agent.y
end


function Sound:update()
    -- body...
end


function Sound:render(soundRays)
    -- local soundRays = soundRays or 'n'
    -- -- sound ray debugging
    -- if soundRays == 'y' then
    --     for i, XY in pairs(self.soundPlot) do
    --         local col = XY['tile']['RGB']
    --         love.graphics.setColor(
    --             col['r']+50/255,
    --             col['g']+50/255,
    --             col['b']+50/255)
    --         love.graphics.rectangle('fill', XY['x']-1.5, XY['y']-1.5, 3, 3)
    --     end
    -- end
end
