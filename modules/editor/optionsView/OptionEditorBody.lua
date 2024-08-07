-- Template: file://./OptionEditorBody.xml

---@class MapPinEnhanced
local MapPinEnhanced = select(2, ...)

local Options = MapPinEnhanced:GetModule("Options")

---@class OptionScrollFrame : ScrollFrame
---@field Child Frame

---@class OptionEditorBodyHeader : Frame
---@field bg Texture
---@field selectedCategoryName FontString


---@class MapPinEnhancedOptionEditorViewBodyMixin : Frame
---@field optionElements FramePool
---@field buttons FramePool
---@field checkboxes FramePool
---@field colorpickers FramePool
---@field inputs FramePool
---@field selects FramePool
---@field sliders FramePool
---@field init boolean
---@field sidebar MapPinEnhancedOptionEditorViewSidebarMixin
---@field scrollFrame OptionScrollFrame
---@field header OptionEditorBodyHeader
---@field optionElementFrames table<string, MapPinEnhancedOptionEditorElementMixin>
---@field activeCategory OPTIONCATEGORY
MapPinEnhancedOptionEditorViewBodyMixin = {}

function MapPinEnhancedOptionEditorViewBodyMixin:OnLoad()
    if self.init then return end
    self.optionElements = CreateFramePool("Frame", nil, "MapPinEnhancedOptionEditorElementTemplate")
    self.buttons = CreateFramePool("Button", nil, "MapPinEnhancedButtonTemplate")
    self.checkboxes = CreateFramePool("CheckButton", nil, "MapPinEnhancedCheckboxTemplate")
    self.colorpickers = CreateFramePool("ColorSelect", nil, "MapPinEnhancedColorpickerTemplate")
    self.inputs = CreateFramePool("EditBox", nil, "MapPinEnhancedInputTemplate")
    self.selects = CreateFramePool("Frame", nil, "MapPinEnhancedSelectTemplate")
    self.sliders = CreateFramePool("Slider", nil, "MapPinEnhancedSliderTemplate")
    self.init = true
    self.header:SetScript("OnMouseDown", function(self)
        MapPinEnhanced.editorWindow:StartMoving()
        SetCursor("Interface/CURSOR/UI-Cursor-Move.crosshair")
    end)

    self.header:SetScript("OnMouseUp", function(self)
        MapPinEnhanced.editorWindow:StopMovingOrSizing()
        SetCursor(nil)
    end)

    Options.OptionBody = self
end

---@alias FormType "button" | "checkbox" | "colorpicker" | "input" | "select" | "slider"
---@alias FormElement MapPinEnhancedButtonMixin | MapPinEnhancedCheckboxMixin | MapPinEnhancedColorpickerMixin | MapPinEnhancedInputMixin | MapPinEnhancedSelectMixin | MapPinEnhancedSliderMixin

---@class FormData
---@field type FormType


---@param formType FormType
---@return MapPinEnhancedOptionEditorElementMixin
function MapPinEnhancedOptionEditorViewBodyMixin:GetFormElement(formType)
    if not self.init then
        self:OnLoad()
    end
    assert(type(formType) == "string", "formType must be a string")
    local optionElement = self.optionElements:Acquire() --[[@as MapPinEnhancedOptionEditorElementMixin]]
    if formType == "button" then
        local buttons = self.buttons:Acquire() --[[@as MapPinEnhancedButtonMixin]]
        optionElement:SetFormElement(buttons)
        return optionElement
    elseif formType == "checkbox" then
        local checkboxes = self.checkboxes:Acquire() --[[@as MapPinEnhancedCheckboxMixin]]
        optionElement:SetFormElement(checkboxes)
        return optionElement
    elseif formType == "colorpicker" then
        local colorpickers = self.colorpickers:Acquire() --[[@as MapPinEnhancedColorpickerMixin]]
        optionElement:SetFormElement(colorpickers)
        return optionElement
    elseif formType == "input" then
        local inputs = self.inputs:Acquire() --[[@as MapPinEnhancedInputMixin]]
        optionElement:SetFormElement(inputs)
        return optionElement
    elseif formType == "select" then
        local selects = self.selects:Acquire() --[[@as MapPinEnhancedSelectMixin]]
        optionElement:SetFormElement(selects)
        return optionElement
    elseif formType == "slider" then
        local sliders = self.sliders:Acquire() --[[@as MapPinEnhancedSliderMixin]]
        optionElement:SetFormElement(sliders)
        return optionElement
    end
    optionElement.type = formType
    error("Invalid form formType: " .. formType)
    return optionElement
end

function MapPinEnhancedOptionEditorViewBodyMixin:OnShow()
    self:SetActiveCategory("General")
end

function MapPinEnhancedOptionEditorViewBodyMixin:ClearAllOptions()
    if not self.init then
        self:OnLoad()
    end
    self.optionElements:ReleaseAll()
    self.buttons:ReleaseAll()
    self.checkboxes:ReleaseAll()
    self.colorpickers:ReleaseAll()
    self.inputs:ReleaseAll()
    self.selects:ReleaseAll()
    self.sliders:ReleaseAll()
end

---@param category OPTIONCATEGORY
function MapPinEnhancedOptionEditorViewBodyMixin:SetActiveCategory(category)
    if not category then return end
    local options = Options:GetOptionsForCategory(category)
    self:ClearAllOptions()
    self.optionElementFrames = {}
    self.header.selectedCategoryName:SetText(category)
    self.activeCategory = category
    if not options then return end
    local lastOptionElement = nil
    for _, option in ipairs(options) do
        local optionElement = self:GetFormElement(option.type)
        optionElement:ClearAllPoints()
        optionElement:Setup(option)
        if lastOptionElement then
            optionElement:SetPoint("TOPLEFT", lastOptionElement, "BOTTOMLEFT", 0, -10)
            optionElement:SetPoint("TOPRIGHT", lastOptionElement, "BOTTOMRIGHT", 0, -10)
        else
            optionElement:SetPoint("TOP", self.scrollFrame.Child, 0, -10)
            optionElement:SetPoint("LEFT", self.scrollFrame.Child, 0, -10)
            optionElement:SetPoint("RIGHT", self.scrollFrame.Child, 0, -10)
        end
        optionElement:SetParent(self.scrollFrame.Child)
        optionElement:Show()
        lastOptionElement = optionElement
        self.optionElementFrames[option.label] = optionElement
    end
end

function MapPinEnhancedOptionEditorViewBodyMixin:GetActiveCategory()
    return self.activeCategory
end

function MapPinEnhancedOptionEditorViewBodyMixin:GetOptionElementFrame(category, label)
    if not category or category ~= self:GetActiveCategory() then
        return nil
    end
    if not label then
        return nil
    end
    return self.optionElementFrames[label]
end

---@param category? OPTIONCATEGORY
---@param label? string
function MapPinEnhancedOptionEditorViewBodyMixin:Update(category, label)
    if not category and not label then -- update the current category
        self:SetActiveCategory(self.header.selectedCategoryName:GetText())
        return
    end
    if category and category == self.header.selectedCategoryName:GetText() then -- update the current category if the category is the same
        self:SetActiveCategory(category)
        return
    end
    if category and label then -- update a specific option
        local optionElement = self:GetOptionElementFrame(category, label)
        if optionElement then
            optionElement:Update()
        end
        return
    end
end
