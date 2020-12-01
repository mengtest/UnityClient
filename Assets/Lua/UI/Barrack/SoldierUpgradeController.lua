local _C = UIManager.Controller(UIManager.ControllerName.SoldierUpgrade, UIManager.ViewName.SoldierUpgrade)
local _CchatBrief = require(UIManager.ControllerName.ChatBrief)
table.insert(_C.SubCtrl, _CchatBrief)

local view = nil
-- 军政实例化信息
local militarydata = nil
-- 货币信息
local currencyData = nil
-- 玩家信息
local playerdata = nil
-- 升阶特效预制件
local shengjieParticlePath = "Prefabs/Particle/Eff_sce_city_shibing_shengjie"

local Resources = CS.UnityEngine.Resources
local GameObject = CS.UnityEngine.GameObject
local Vector3 = CS.UnityEngine.Vector3
local GoWrapper = CS.FairyGUI.GoWrapper

-- 士兵升级
local function UpgradeBtnOnClick()
    NetworkManager.C2SUpdateSoldierLevelProto()
end

-- 刷新数据
local function RefreshUI()
    if not _C.IsOpen then
        return
    end

    view.ConditionList:RemoveChildrenToPool()
    -- 当前士兵等级
    local soldierLev = militarydata.SoldierLevel
    -- 当前等级数据
    local currLevData = SoldierConfig.Config[soldierLev]
    -- 当前等级
    view.CurLev.title = string.format(Localization.LevelDesc, soldierLev)
    -- 当前等级描述
    view.CurrDesc.text = currLevData.Desc
    -- 升级消耗
    local upgradeCost = nil
    -- 下一等级数据
    local nextLevData = SoldierConfig.Config[soldierLev + 1]

    -- 判断是否满级
    if nextLevData == nil then
        view.Level_C.selectedIndex = 1
        return
    else
        view.Level_C.selectedIndex = 0
        upgradeCost = nextLevData.UpgradeCost
    end

    -- 下一级
    view.NextLev.title = string.format(Localization.LevelDesc, nextLevData.Level)
    -- 下一级描述
    view.NextDesc.text = nextLevData.Desc
    -- 建造或者升级所需花费
    if upgradeCost ~= nil then
        for k, v in pairs(upgradeCost) do
            while true do
                if type(v) ~= "number" or v == 0 then
                    break
                end

                item = view.ConditionList:AddItemFromPool(UIConfig.ConditionType.Resourse)
                item_C = item:GetController("State_C")
                -- 图标
                item:GetChild("Loader_Res").url = UIConfig.CurrencyType[k]
                -- 当前值
                local currValue = 0

                -- 如果是元宝,可能是我多虑了,先写着以防万一,如果不是4种货币/元宝会出错
                if k == "YuanBao" then
                    currValue = playerdata.Money
                else
                    currValue = currencyData[CurrencyType[k]]
                end
                
                -- 当前货币值
                item:GetChild("Text_Total").text = currValue
                -- 消耗值
                item:GetChild("Text_Need").text = v

                if currValue < v then
                    item_C.selectedIndex = 1
                    item:GetChild("Button_Add").onClick:Set( function() print("怕是要干一些增加货币的事情了") end)
                    -- 按钮置灰,关闭交互
                    view.UpgradeBtn.grayed = true
                    view.UpgradeBtn.touchable = false
                else
                    item_C.selectedIndex = 0
                    view.UpgradeBtn.grayed = false
                    view.UpgradeBtn.touchable = true
                end

                break
            end
        end
    end
end

-- 特效列表
local particleList = { }

-- 载入模型
local function LoadModel(ui, id)
    local prefab = Resources.Load(ActorConfig[id].prefab)
    local particle = Resources.Load(shengjieParticlePath)
    local go = GameObject.Instantiate(prefab)
    local particleObj = GameObject.Instantiate(particle, go.transform)
    particleObj.name = "particle"

    table.insert(particleList, particleObj)

    -- go.transform.localPosition = Vector3(95, -275, 1000)
    -- go.transform.localEulerAngles = Vector3(0, 160, 0)
    -- go.transform.localScale = Vector3(150, 150, 150)
    ui:GetChild("Graph_Model"):SetNativeObject(GoWrapper(go))

    return go
end

-- 升阶成功
local function UpgradeSuccess()
    if not _C.IsOpen then
        return
    end

    for k, v in pairs(particleList) do
        v:GetComponent("ParticleSystem"):Play()
    end

    RefreshUI()
end

function _C:onCreat()
    particleList = { }
    view = _C.View

    view.BuBingInfo.icon = UIConfig.Race[1]
    local buModel = LoadModel(view.BuBing, 1)
    buModel.transform.localPosition = Vector3(135, -275, 1000)
    buModel.transform.localEulerAngles = Vector3(0, 160, 0)
    buModel.transform.localScale = Vector3(150, 150, 150)

    view.GongBingInfo.icon = UIConfig.Race[3]
    local gongModel = LoadModel(view.GongBing, 3)
    gongModel.transform.localPosition = Vector3(135, -275, 1000)
    gongModel.transform.localEulerAngles = Vector3(0, 160, 0)
    gongModel.transform.localScale = Vector3(150, 150, 150)

    view.QiBingInfo.icon = UIConfig.Race[2]
    local qiModel = LoadModel(view.QiBing, 2)
    qiModel.transform.localPosition = Vector3(129.43, -268.1, 1000)
    qiModel.transform.localEulerAngles = Vector3(18, 162.5, -5.4)
    qiModel.transform.localScale = Vector3(110, 110, 110)

    view.CheBingInfo.icon = UIConfig.Race[4]
    local cheModel = LoadModel(view.CheBing, 4)
    cheModel.transform.localPosition = Vector3(150, -260, 1000)
    cheModel.transform.localEulerAngles = Vector3(18.7, 155, -7.5)
    cheModel.transform.localScale = Vector3(110, 110, 110)

    view.XieBingInfo.icon = UIConfig.Race[5]
    local xieModel = LoadModel(view.XieBing, 5)
    xieModel.transform.localPosition = Vector3(120, -250, 1000)
    xieModel.transform.localEulerAngles = Vector3(20, 150, -12)
    xieModel.transform.localScale = Vector3(95, 95, 95)

    view.BackBtn.onClick:Set( function() _C:close() end)
    view.UpgradeBtn.onClick:Set(UpgradeBtnOnClick)
    view.RelationBtn.onClick:Set( function()
        UIManager.openController(UIManager.ControllerName.MutualRestraint)
    end )
    
    Event.addListener(Event.BARRACK_UPGRADE_SOLDIER_SUCCESS, UpgradeSuccess)
    Event.addListener(Event.CURRENCY_CURRENT_UPDATE, RefreshUI)
end

function _C:onOpen(data)
    militarydata = DataTrunk.PlayerInfo.MilitaryAffairsData
    currencyData = DataTrunk.PlayerInfo.InternalAffairsData.CurrencyCurrInfo
    playerdata = DataTrunk.PlayerInfo.MonarchsData
    RefreshUI()
end

function _C:onInteractive(isOk)
    if isOk then
        _CchatBrief:setParent(view.UI)      
    end
end

function _C:onDestroy()
    Event.removeListener(Event.BARRACK_UPGRADE_SOLDIER_SUCCESS, UpgradeSuccess)
    Event.removeListener(Event.CURRENCY_CURRENT_UPDATE, RefreshUI)
end