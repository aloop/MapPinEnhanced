---@class MapPinEnhanced
local MapPinEnhanced = select(2, ...)

---@class PinFactory
local PinFactory = MapPinEnhanced:GetModule("PinFactory")
local PinManager = MapPinEnhanced:GetModule("PinManager")

---@type {distance: number, time: number}[]
local distanceCache = {}
local throttle_interval = 1
local lastDistance = 0
local lastUpdate = nil


---@param pinID string
---@param pinData table
function PinFactory:UpdateDistance(pinID, pinData)
    local currentTime = GetTime()
    -- Check if we need to update based on throttle interval
    if not lastUpdate or currentTime - lastUpdate > throttle_interval then
        local isSuperTrackingUserWaypoint = C_SuperTrack.IsSuperTrackingUserWaypoint()
        if not isSuperTrackingUserWaypoint then return end

        local distance = C_Navigation.GetDistance()
        if distance == 0 then return end            -- No distance to get to the waypoint
        if lastDistance == distance then return end -- No need to update if the distance is the same
        lastDistance = distance

        -- Maintain a cache of recent distances
        if #distanceCache > 5 then
            table.remove(distanceCache, 1)
        end
        table.insert(distanceCache, { distance = distance, time = currentTime })

        -- Calculate total distance and time from the cache
        local totalDistance = 0
        local totalTime = 0
        for i = 2, #distanceCache do
            local prev = distanceCache[i - 1]
            local current = distanceCache[i]
            totalDistance = totalDistance + (prev.distance - current.distance)
            totalTime = totalTime + (current.time - prev.time)
        end

        if totalTime == 0 then return end
        if totalDistance == 0 then return end

        -- Calculate speed (yards per second)
        ---@type number
        local speed = totalDistance / totalTime
        if speed <= 0 then
            self.distanceCache = {}
            if MapPinEnhanced.SuperTrackedPin then
                MapPinEnhanced.SuperTrackedPin:UpdateTimeText()
            end
        end

        -- Calculate time to target
        local timeToTarget = distance / speed
        if timeToTarget <= 0 then
            if MapPinEnhanced.SuperTrackedPin then
                MapPinEnhanced.SuperTrackedPin:UpdateTimeText()
            end
        end

        -- Update throttle interval based on distance
        throttle_interval = 0.1 + 2e-04 * distance - 5e-09 * distance * distance

        -- Update the UI with the new time to target
        if MapPinEnhanced.SuperTrackedPin then
            MapPinEnhanced.SuperTrackedPin:UpdateTimeText(timeToTarget)
        end

        if distance < 20 then
            if not pinData.persistent then
                PinManager:RemovePinByID(pinID)
            end
        end
        lastUpdate = currentTime
    end
end
