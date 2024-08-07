-- Template: file://./OptionEditorElement.xml
---@class MapPinEnhancedOptionEditorElementMixin : Frame
---@field label FontString
---@field highlight Texture
---@field option OptionObjectVariantsTyped
---@field formElement FormElement
---@field optionHolder Frame
---@field type FormType
---@field info Frame -- defining it as a frame for now
MapPinEnhancedOptionEditorElementMixin = {}


function MapPinEnhancedOptionEditorElementMixin:ShowDescription()
    if self.option then
        local description = self.option.description
        local descriptionImage = self.option.descriptionImage
        GameTooltip:SetOwner(self.info, "ANCHOR_BOTTOMRIGHT")

        if descriptionImage then
            -- add a dummy line to make sure the texture is shown
            GameTooltip:AddLine(" ")
            ---@diagnostic disable-next-line: redundant-parameter (this is not full documented in the WoW API extension)
            GameTooltip:AddTexture(descriptionImage, {
                width = 200,
                height = 200,
                anchor = Enum.TooltipTextureAnchor.LeftTop,
                region = Enum.TooltipTextureRelativeRegion.LeftLine,
                verticalOffset = 0,
                margin = { left = 5, right = 5, top = 0, bottom = 0 },
            })
            GameTooltip:SetMinimumWidth(210)
        end
        GameTooltip:AddLine(description, 1, 1, 1, true)
        GameTooltip:Show()
    end
end

function MapPinEnhancedOptionEditorElementMixin:OnLoad()
    self.info:SetScript("OnEnter", function()
        self:ShowDescription()
    end)
    self.info:SetScript("OnLeave", function()
        GameTooltip:Hide()
    end)
end

---@param formElement FormElement
function MapPinEnhancedOptionEditorElementMixin:SetFormElement(formElement)
    assert(formElement, "formElement must be a valid frame")
    self.formElement = formElement
    formElement:SetParent(self.optionHolder)
    formElement:ClearAllPoints()
    formElement:SetPoint("RIGHT", 0, 0)
    formElement:Show()
    formElement:SetPropagateMouseMotion(true)
end

---@param optionData OptionObjectVariantsTyped
function MapPinEnhancedOptionEditorElementMixin:Setup(optionData)
    self.option = optionData
    self.label:SetText(optionData.label)
    self.formElement:Setup(optionData)
end

function MapPinEnhancedOptionEditorElementMixin:Update()
    if not self.option then
        return
    end
    self:Setup(self.option)
end
