local _C = UIManager.Controller(UIManager.ControllerName.AllianceChangeSalaryWindow, UIManager.ViewName.AllianceChangeSalaryWindow)
_C.IsPopupBox = true

local view = nil
-- 当前玩家的数据
local currData = nil
-- 当前工资
local currSalary = 0
-- 测试
local memberSalay = 10

-- 点击减按钮
local function SubBtnOnClick()
    if currSalary <= 0 then
        view.SalaryInput.text = "0"
        return
    end

    currSalary = currSalary - 1
    view.SalaryInput.text = currSalary
end

-- 点击加按钮
local function AddBtnOnClick()
    currSalary = currSalary + 1
    view.SalaryInput.text = currSalary
end

-- 输入框失焦回调
local function SalaryInputonFocusOut()
    if view.SalaryInput.text == "" then
        view.SalaryInput.text = 0
    end

    currSalary = tonumber(view.SalaryInput.text)
end

-- 点击取消按钮
local function CancelBtnOnClick()
    _C:destroy(true)
end

-- 点击确认按钮
local function ConfirmBtnOnClick()
    UIManager.showTip( { content = string.format("假装你修改了工资为%d银两,等待服务器开发完毕", view.SalaryInput.text), result = true })
    CancelBtnOnClick()
end

function _C:onCreat()
    view = _C.View

    view.BG.onClick:Set(CancelBtnOnClick)
    view.SubBtn.onTouchBegin:Set(SubBtnOnClick)
    view.AddBtn.onTouchBegin:Set(AddBtnOnClick)
    view.SalaryInput.onFocusOut:Set(SalaryInputonFocusOut)
    view.ConfirmBtn.onClick:Set(ConfirmBtnOnClick)
    view.CancelBtn.onClick:Set(CancelBtnOnClick)

    local subGesture = LongPressGesture(view.SubBtn)
    subGesture.interval = UIConfig.LongPressInterval
    subGesture.trigger = UIConfig.LongPressTrigger
    subGesture.onAction:Set(SubBtnOnClick)

    local addGesture = LongPressGesture(view.AddBtn)
    addGesture.interval = UIConfig.LongPressInterval
    addGesture.trigger = UIConfig.LongPressTrigger
    addGesture.onAction:Set(AddBtnOnClick)
end

-- data:GuildMemberClass()
function _C:onOpen(data)
    currData = data

    -- 假装服务器有数据
    currSalary = memberSalay
    view.SalaryInput.text = currSalary
    view.Name.text = currData.Hero.Name
end

function _C:onDestroy()
end