--      _     __ _            ____             _   _     
--     / \   / _| |_ ___ _ __|  _ \  ___  __ _| |_| |__  
--    / _ \ | |_| __/ _ \ '__| | | |/ _ \/ _` | __| '_ \ 
--   / ___ \|  _| ||  __/ |  | |_| |  __/ (_| | |_| | | |
--  /_/   \_\_|  \__\___|_|  |____/ \___|\__,_|\__|_| |_|
-- https://discord.gg/5D3wdy4dQH ┃ https://github.com/Afterdeathstudio ┃ https://afterdeath.gitbook.io/afterdeath-studios/

local units = Config.Units
local lastText = nil
local shown = false

local function getSpeed(vehicle)
    local speed = GetEntitySpeed(vehicle)
    return units == 'KPH' and math.floor(speed * 3.6) or math.floor(speed * 2.23694)
end

local function getGearText(vehicle)
    local speedVec = GetEntitySpeedVector(vehicle, true)
    local rpm = GetVehicleCurrentRpm(vehicle)
    local gear = GetVehicleCurrentGear(vehicle)

    if speedVec.y < -0.1 and rpm > 0.1 then
        return 'R'  -- Reversing
    elseif gear == 0 then
        return 'N'  -- Neutral (optional)
    else
        return tostring(gear)
    end
end

CreateThread(function()
    while true do
        Wait(300)

        local ped = PlayerPedId()
        local vehicle = GetVehiclePedIsIn(ped, false)

        if IsPedInAnyVehicle(ped, false) and GetPedInVehicleSeat(vehicle, -1) == ped then
            local speed = getSpeed(vehicle)
            local gear = getGearText(vehicle)
            local text = string.format("[%s]┃%d %s", gear, speed, units)

            if not shown then
                lib.showTextUI(text, {
                    position = Config.Position,
                    icon = 'car',
                    style = {
                        borderRadius = 4,
                        backgroundColor = '#000000dd',
                        color = 'white'
                    }
                })
                lastText = text
                shown = true
            elseif text ~= lastText then
                lib.hideTextUI()
                lib.showTextUI(text, {
                    position = Config.Position,
                    icon = 'car',
                    style = {
                        borderRadius = 4,
                        backgroundColor = '#000000dd',
                        color = 'white'
                    }
                })
                lastText = text
            end
        elseif shown then
            lib.hideTextUI()
            shown = false
            lastText = nil
        end
    end
end)
