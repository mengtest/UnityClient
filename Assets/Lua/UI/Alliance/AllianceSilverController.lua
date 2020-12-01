local _C = UIManager.SubController(UIManager.ControllerName.AllianceSilverController, nil)

local view = nil

-- 联盟收入列表
local function IncomeDetailsListRenderer(index, obj)
    -- 地名
    obj:GetChild("Text_Name").text = "XX税收"
    -- 银两
    obj:GetChild("Text_Silver").text = "服务器暂无数据"
end

-- 支出记录列表
local function PayListRenderer(index, obj)
    -- 内容
    obj:GetChild("Text_Content").text = "服务器暂无数据"
end

-- 收入记录列表
local function IncomeListRenderer(index, obj)
    -- 内容
    obj:GetChild("Text_Content").text = "服务器暂无数据"
end

-- 更新数据(联盟金库页)
local function UpdateData()
    -- 联盟收入
    view.IncomeDetailsList.itemRenderer = IncomeDetailsListRenderer
    view.IncomeDetailsList.numItems = 1

    -- 支出记录
    view.PayList.itemRenderer = PayListRenderer
    view.PayList.numItems = 1

    -- 收入记录
    view.IncomeList.itemRenderer = IncomeListRenderer
    view.IncomeList.numItems = 1

    -- 联盟总银两
    view.TotalMoney.text = "服务器暂无数据"
    -- 联盟总工资
    view.TotalSalary.text = "服务器暂无数据"
end

-- 点击发工资按钮
local function SalaryBtnOnClick()
    UIManager.showTip( { content = "假装发工资", result = true })
end

-- 赠予联盟
local function GiveToAllianceBtnOnClick()
    UIManager.openController(UIManager.ControllerName.GiveToAllianceWindow)
end

-- 赠予个人
local function GiveToPlayerBtnOnClick()
    UIManager.openController(UIManager.ControllerName.GiveToPlayerWindow)
end

function _C.RefreshUI()
    UpdateData()
end

function _C:onCreat()
    view = _C.view.SilverPage

    view.SalaryBtn.onClick:Set(SalaryBtnOnClick)
    view.GiveToAllianceBtn.onClick:Set(GiveToAllianceBtnOnClick)
    view.GiveToPlayerBtn.onClick:Set(GiveToPlayerBtnOnClick)
end

function _C:onDestroy()
    view.IncomeDetailsList.itemRenderer = nil
    view.PayList.itemRenderer = nil
    view.IncomeList.itemRenderer = nil
end

return _C