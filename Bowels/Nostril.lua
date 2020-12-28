Nostril = Class{}


function Nostril:init(params)

    self.x = 2
    self.y = 2

    self.moveSpeed = 0.05 -- 0.08
    self.id = 20

    self.controls = {
        ['up'] = 'w',
        ['down'] = 's',
        ['left'] = 'a',
        ['right'] = 'd'
    }


    -- self.standingRGB = {
    --     ['r'] = 0/255,
    --     ['g'] = 200/255,
    --     ['b'] = 0/255
    -- }
    --
    -- self.movingRGB = {
    --     ['r'] = 0/255,
    --     ['g'] = 255/255,
    --     ['b'] = 0/255
    -- }

    self.standingRGB = {
        ['r'] = 100/255,
        ['g'] = 20/255,
        ['b'] = 5/255
    }

    self.movingRGB = {
        ['r'] = 255/255,
        ['g'] = 60/255,
        ['b'] = 10/255
    }
end
