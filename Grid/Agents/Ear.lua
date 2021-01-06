Ear = Class{}

-- require 'Utility/Util'

function Ear:init()

    self.x = 21
    self.y = 4

    self.moveSpeed = 0.07
    self.id = EAR_ID

    -- sight
    self.sightDistance = 0

    -- sound
    self.senseOfHearing = 1.7
    self.stepLoudness = 0.1
    self.bumpLoudness = 0.3

    -- smell
    self.senseOfSmell = 0.1
    self.smelliness = 0

    -- controls
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

    self.smell = {
        ['r'] = 255/255,
        ['g'] = 60/255,
        ['b'] = 10/255
    }

end
