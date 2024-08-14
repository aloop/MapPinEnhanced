---@class MapPinEnhanced
local MapPinEnhanced = select(2, ...)

local LOCALE = MapPinEnhanced.locale

if LOCALE ~= "enUS" then return end

---@class Locale : table<string, string>
local L = {
    ["Accept"] = "Accept",
    ["Add Pin"] = "Add Pin",
    ["Add to a set"] = "Add to a set",
    ["Are you sure you want to delete this set?"] = "Are you sure you want to delete this set?",
    ["Auto Track Nearest Pin"] = "Auto Track Nearest Pin",
    ["Automatic Visibility"] = "Automatic Visibility",
    ["Automatic"] = "Automatic",
    ["Back"] = "Back",
    ["Background Opacity"] = "Background Opacity",
    ["Can't show on map in combat"] = "Can't show on map in combat",
    ["Cancel"] = "Cancel",
    ["Change Color"] = "Change Color",
    ["Create a pin at your current location"] = "Create a pin at your current location",
    ["Create Set"] = "Create Set",
    ["Disabled"] = "Disabled",
    ["Editor Scale"] = "Editor Scale",
    ["Editor"] = "Editor",
    ["Enable Unlimited Distance"] = "Enable Unlimited Distance",
    ["Enter new set name"] = "Enter new set name",
    ["Entry Height"] = "Entry Height",
    ["Floating Pin"] = "Floating Pin",
    ["General"] = "General",
    ["Help"] = "Help",
    ["Hide Minimap Button"] = "Hide Minimap Button",
    ["Icon"] = "Icon",
    ["Import a set"] = "Import a set",
    ["Import"] = "Import",
    ["Imported Set"] = "Imported Set",
    ["Lock Tracker"] = "Lock Tracker",
    ["Map ID"] = "Map ID",
    ["Minimap button is now hidden"] = "Minimap button is now hidden",
    ["Minimap button is now visible"] = "Minimap button is now visible",
    ["Minimap"] = "Minimap",
    ["My way back"] = "My way back",
    ["New Pin"] = "New Pin",
    ["Open options"] = "Open options",
    ["Options"] = "Options",
    ["Override world quest tracking"] = "Override world quest tracking",
    ["Persistent"] = "Persistent",
    ["Remove Pin"] = "Remove Pin",
    ["Scale"] = "Scale",
    ["Select a set to edit or create a new one."] = "Select a set to edit or create a new one.",
    ["Sets"] = "Sets",
    ["Share Pin"] = "Share Pin",
    ["Show Centered Highlight"] = "Show Centered Highlight",
    ["Show Estimated Time"] = "Show Estimated Time",
    ["Show Numbering"] = "Show Numbering",
    ["Show on Map"] = "Show on Map",
    ["Show Sets"] = "Show Sets",
    ["Show this help message"] = "Show this help message",
    ["Show Title"] = "Show Title",
    ["Title"] = "Title",
    ["Toggle Editor"] = "Toggle Editor",
    ["Toggle minimap button"] = "Toggle minimap button",
    ["Toggle persistent"] = "Toggle persistent",
    ["Toggle tracker"] = "Toggle tracker",
    ["TomTom is loaded! The usage of /way is disabled."] = "TomTom is loaded! The usage of /way is disabled.",
    ["Tracker"] = "Tracker",
    ["X"] = "X",
    ["Y"] = "Y",
    ["You are in an instance or a zone where the map is not available"] =
    "You are in an instance or a zone where the map is not available",
    ["Pins"] = "Pins",
    ["The in-game navigation is disabled! Not all features of MapPinEnhanced will work properly. Do you want to enable it?"] =
    "The in-game navigation is disabled! Not all features of MapPinEnhanced will work properly. Do you want to enable it?"
}

MapPinEnhanced.L = L
