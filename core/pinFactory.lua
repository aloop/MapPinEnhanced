---@class Wayfinder
local Wayfinder = select(2, ...)
---@class PinFactory : Module
local PinFactory = Wayfinder:CreateModule("PinFactory")
-- NOTE: Here the big pin "object" is created, deleted and managed (i.e. icon change) containing the pin data, the world pin, the minimap pin and the worldmap pin. (a singular pin object)

local HBDP = LibStub("HereBeDragons-Pins-2.0")

local WorldmapPool = CreateFramePool("Button", nil, "WayfinderWorldmapPinTemplate")
local MinimapPool = CreateFramePool("Frame", nil, "WayfinderMinimapPinTemplate")
-- local WorldPool = CreateFramePool("Frame", nil, "WayfinderWorldPinTemplate")



local SetSuperTrackedUserWaypoint = C_SuperTrack.SetSuperTrackedUserWaypoint


---@param pinData pinData
---@param pinID string
---@return PinObject
function PinFactory:CreatePin(pinData, pinID)
    local worldmapPin = WorldmapPool:Acquire()
    ---@cast worldmapPin WayfinderWorldMapPinMixin
    local minimapPin = MinimapPool:Acquire()
    ---@cast minimapPin WayfinderMinimapPinMixin
    -- local worldPin = WorldPool:Acquire()
    local x, y, mapID = pinData.x, pinData.y, pinData.mapID

    worldmapPin:Setup(pinData)
    minimapPin:Setup(pinData)
    -- worldPin:Setup(pinData)

    HBDP:AddWorldMapIconMap(Wayfinder, worldmapPin, mapID, x, y, 3, "PIN_FRAME_LEVEL_ENCOUNTER")
    HBDP:AddMinimapIconMap(Wayfinder, minimapPin, mapID, x, y, false, false)


    local isTracked = false
    local function Track()
        worldmapPin:Track()
        minimapPin:Track()
        -- worldPin:Track()
        SetSuperTrackedUserWaypoint(true)
        isTracked = true
    end

    local function Untrack()
        worldmapPin:Untrack()
        minimapPin:Untrack()
        -- worldPin:Untrack()
        isTracked = false
    end

    worldmapPin:SetClickCallback(function()
        if isTracked then
            Untrack()
        else
            Track()
        end
    end)



    if pinData.setTracked then
        Track()
    end


    return {
        pinID = pinID,
        -- worldPin = worldPin,
        minimapPin = minimapPin,
        pinData = pinData,
        Track = Track,
        Untrack = Untrack,
        IsTracked = function() return isTracked end,
    }
end
