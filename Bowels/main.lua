push = require 'push'
Class = require 'class'
require 'Grid'
require 'Util'

function love.load()

    love.graphics.setDefaultFilter('nearest', 'nearest')
    love.window.setTitle('Final Project [title??]')

    math.randomseed(os.time())

    smallFont = love.graphics.newFont('font.ttf', 8)
    largeFont = love.graphics.newFont('font.ttf', 16)
    scoreFont = love.graphics.newFont('font.ttf', 32)
    love.graphics.setFont(smallFont)

    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        fullscreen = false,
        resizable = true,
        vsync = true
    })

    grid = Grid()
end


function love.keypressed(key)
    if key == 'escape' then
        love.event.quit()
    end
    if key == 'r' then
        grid:init()
    end
end


function love.resize(w, h)
    push:resize(w, h)
end


function love.update(dt)
    -- print('testing console')
    -- for _, v in ipairs(grid.grid) do
    --     io.write(v)
    -- end
    -- print()
    grid:update(dt)
    -- love.timer.sleep(1)
end


function love.draw()
    push:apply('start')

    -- BG colour
    love.graphics.clear(0.4, 0.4, 0.4)
    -- love.graphics.clear(0/255, 45/255, 52/255, 255/255)
    -- love.graphics.setColor(0/255, 45/255, 52/255, 255/255)

    -- Render the grid
    -- Currently at 40 by 20 resolution
    grid:render()
    debugging()


    push:apply('end')
end

function debugging()
    love.graphics.setFont(smallFont)
    love.graphics.setColor(0, 255, 0, 255)
    love.graphics.print('FPS: ' .. tostring(love.timer.getFPS()), 0, 0)
end
