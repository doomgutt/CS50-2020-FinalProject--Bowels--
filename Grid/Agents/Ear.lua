Ear = Class{}


function Ear:init()

    self.x = 2
    self.y = 2

    self.moveSpeed = 0.07
    self.id = 20

    self.controls = {
        ['up'] = 'w',
        ['down'] = 's',
        ['left'] = 'a',
        ['right'] = 'd'
    }

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
