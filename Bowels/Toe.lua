Toe = Class{}

function Toe:init()

    self.x = 39
    self.y = 19

    self.moveSpeed = 0.07
    self.id = 10

    self.controls = {
        ['up'] = 'up',
        ['down'] = 'down',
        ['left'] = 'left',
        ['right'] = 'right',
        ['senseDown'] = '[',
        ['senseUp'] = ']'
    }

    self.standingRGB = {
        ['r'] = 115/255,
        ['g'] = 101/255,
        ['b'] = 8/255
    }

    self.movingRGB = {
        ['r'] = 188/255,
        ['g'] = 143/255,
        ['b'] = 21/255
    }



--     self.standingRGB = {
--         ['r'] = 100/255,
--         ['g'] = 100/255,
--         ['b'] = 100/255
--     }
--
--     self.movingRGB = {
--         ['r'] = 200/255,
--         ['g'] = 200/255,
--         ['b'] = 200/255
--     }
end
