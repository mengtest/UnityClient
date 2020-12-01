local UIController = UIManager.Controller(UIManager.ControllerName.TransportSoldiers, UIManager.ViewName.TransportSoldiers)
local OnSwitchButtonClick = nil
local OnTranportButtonClick = nil
local OnCancelButtonClick = nil
local OnSpeedUpButtonClick = nil 
local OnDecreaseButtonClick= nil 
local OnIncreaseButtonClick = nil
local OnDecreaseTouchBegin = nil
local OnDecreaseTouchEnd = nil
local OnIncreaseTouchBegin = nil
local OnIncreaseTouchEnd = nil

local OnBgClick = nil
local SetProgressBarInfo = nil
local SetInfo = nil
local SetTransportCount = nil
local SetTransprotingInfo = nil
local SetPress = nil
-- 军营最大容量
local MilitaryCampMaxCapacity = 0
-- 军营当前兵量
local MilitaryCampCurCount = 0
-- 行营最大容量
local CampsiteMaxCapacity = 0
-- 行营当前兵量
local CampsiteCurCount = 0
-- 运送的最大量min(CampsiteMaxCapacity - CampsiteCurCount, MilitaryCampCurCount) 
local TransportMax = 0 

local Timer = nil

local IsIncrease = false
local IsTouching = false
local TouchStartTime = 0

local SelectTransprotNum = 0

local TransportingToMilitaryCamp = false

local TransprotingToCampsite = false


function UIController:onCreat ( )
    self.View.SwitchButton.onClick:Set(OnSwitchButtonClick)
    self.View.TranportButton.onClick:Set(OnTranportButtonClick)
    self.View.CancelButton.onClick:Set(OnCancelButtonClick)

    self.View.DecreaseButton.onClick:Set(OnDecreaseButtonClick)
    SetPress(self.View.DecreaseButton, OnDecreaseButtonClick)

    self.View.IncreaseButton.onClick:Set(OnIncreaseButtonClick)
    SetPress(self.View.IncreaseButton, OnIncreaseButtonClick)
    
    self.View.Bg.onClick:Set(OnBgClick)
end

function OnSwitchButtonClick()
    if UIController.View.TopItemCtr.selectedIndex == 0 then
        UIController.View.TopItemCtr.selectedIndex = 1
    else
        UIController.View.TopItemCtr.selectedIndex = 0
    end

    SetTransportCount()
    SetProgressBarInfo()
end

function OnTranportButtonClick()
    if UIController.View.BottomBtnCtr.selectedIndex == 0 then
        UIController.View.BottomBtnCtr.selectedIndex = 1
    else
        UIController.View.BottomBtnCtr.selectedIndex = 0 
    end 
end

function OnDecreaseButtonClick()
    SelectTransprotNum = SelectTransprotNum - 1
    if SelectTransprotNum < 0 then
        SelectTransprotNum = 0
    end
    SetProgressBarInfo()
end

function OnIncreaseButtonClick()
    SelectTransprotNum = SelectTransprotNum + 1
    if SelectTransprotNum > TransportMax then
        SelectTransprotNum = TransportMax
    end
    SetProgressBarInfo()
end

function SetPress(obj, callback)
    local gestureDecrease = LongPressGesture(obj)
    gestureDecrease.trigger = 0.15
    gestureDecrease.interval = 0.1
    gestureDecrease.onAction:Set(callback)
end

function SetProgressBarInfo()
    UIController.View.ProgressBar.max = TransportMax
    UIController.View.ProgressBar.value = SelectTransprotNum
    UIController.View.ProgressBar:GetChild("title").text = SelectTransprotNum .. "/".. TransportMax
end

function OnCancelButtonClick()
    -- TODO : 取消运送
    UIController.View.BottomBtnCtr.selectedIndex = 0 
end

function OnSpeedUpButtonClick()
    -- TODO : 加速运送
end

function SetTransportCount()
    SelectTransprotNum = 0
    if UIController.View.TopItemCtr.selectedIndex == 0 then
        TransportMax = math.min(MilitaryCampCurCount, CampsiteMaxCapacity - CampsiteCurCount)
    else
        TransportMax = math.min(CampsiteCurCount, MilitaryCampMaxCapacity - MilitaryCampCurCount)
    end
end

function UIController:onOpen ( )
    SetInfo()
end

function SetInfo()
    MilitaryCampMaxCapacity = 100
    MilitaryCampCurCount = 10
    CampsiteMaxCapacity = 50
    CampsiteCurCount = 5
    
    SetTransportCount()
    SetProgressBarInfo()
    
    UIController.View.SoldiersNumberLeft.max = MilitaryCampMaxCapacity
    UIController.View.SoldiersNumberLeft.value = MilitaryCampCurCount
    UIController.View.SoldiersNumberLeft:GetChild("title").text = MilitaryCampCurCount .. "/".. MilitaryCampMaxCapacity

    UIController.View.SoldiersNumberRight.max = CampsiteMaxCapacity
    UIController.View.SoldiersNumberRight.value = CampsiteCurCount
    UIController.View.SoldiersNumberRight:GetChild("title").text = CampsiteCurCount .. "/".. CampsiteMaxCapacity

    UIController.View.SoldiersIcon:GetChild("icon_pingzi").url = "" -- load soldier icon

    SetTransprotingInfo()
end

function SetTransprotingInfo()
    if UIController.View.TopItemCtr.selectedIndex == 0 then
        if TransprotingToCampsite then
            -- TODO : show timer
            UIController.View.TranportTimer.visible = true
        else
            UIController.View.TranportTimer.visible = false
        end
    else
        if TransportingToMilitaryCamp then
            -- TODO : show timer 
            UIController.View.TranportTimer.visible = true
        else
            UIController.View.TranportTimer.visible = false
        end
    end
end

function UIController:onClose( )
    -- body
end

function OnBgClick()
    UIController:close()
end

function UIController:onDestroy( )
    self.View.SwitchButton.onClick:Clear() 
    self.View.TranportButton.onClick:Clear() 
    self.View.CancelButton.onClick:Clear() 
    self.View.DecreaseButton.onClick:Clear() 
    self.View.IncreaseButton.onClick:Clear()
    self.View.Bg.onClick:Clear()
end