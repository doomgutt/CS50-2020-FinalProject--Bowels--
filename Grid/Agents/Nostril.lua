Nostril = Class{}

-- require 'Utility/Util'

function Nostril:init(params)

    self.x = 2
    self.y = 2

    self.moveSpeed = 0.11 -- 0.08
    self.id = NOSTRIL_ID

    self.senseOfSmell = 1

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
