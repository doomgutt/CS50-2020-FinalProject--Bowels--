Toe = Class{}

-- require 'Utility/Util'

function Toe:init()

    self.x = 23
    self.y = 9

    self.moveSpeed = 0.1
    self.id = TOE_ID

    -- sight
    self.sightDistance = 100

    -- sound
    self.senseOfHearing = 0.2
    self.stepLoudness = 0.7
    self.bumpLoudness = 1

    -- smell
    self.senseOfSmell = 0.1
    self.smelliness = 0

    -- controls
    self.controls = {
        ['up'] = 'up',
        ['down'] = 'down',
        ['left'] = 'left',
        ['right'] = 'right'
        -- ['senseDown'] = '[',
        -- ['senseUp'] = ']'
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

    self.smell = {
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
