Nostril = Class{}

-- require 'Utility/Util'

function Nostril:init(params)

    self.x = 20
    self.y = 10

    self.moveSpeed = 0.15 -- 0.08
    self.id = NOSTRIL_ID


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
