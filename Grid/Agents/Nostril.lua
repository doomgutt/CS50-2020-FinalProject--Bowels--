Nostril = Class{}

-- require 'Utility/Util'

function Nostril:init(params)

    self.x = 2
    self.y = 2

    self.moveSpeed = 0.2 -- 0.08
    self.id = NOSTRIL_ID

    -- sight
    self.sightDistance = 0

    -- sound
    self.senseOfHearing = 0.1
    self.stepLoudness = 0.8
    self.bumpLoudness = 0.7

    -- smell
    self.senseOfSmell = 1
    self.smelliness = 0

    -- controls
    self.controls = {
        ['up'] = 'i',
        ['down'] = 'k',
        ['left'] = 'j',
        ['right'] = 'l'
        -- ['senseDown'] = '[',
        -- ['senseUp'] = ']'
    }


    self.standingRGB = {
        ['r'] = 42/255,
        ['g'] = 141/255,
        ['b'] = 75/255
    }

    self.movingRGB = {
        ['r'] = 140/255,
        ['g'] = 201/255,
        ['b'] = 0/255
    }

    self.smell = {
        ['r'] = 140/255,
        ['g'] = 201/255,
        ['b'] = 0/255
    }

end
