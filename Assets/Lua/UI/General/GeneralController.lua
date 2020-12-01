local _C = UIManager.Controller(UIManager.ControllerName.General, UIManager.ViewName.General)
local _CchatBrief = require(UIManager.ControllerName.ChatBrief)
table.insert(_C.SubCtrl, _CchatBrief)

local view = nil
-- 军政
local militaryAffairsData = DataTrunk.PlayerInfo.MilitaryAffairsData
-- 武将数据
local captainsData = militaryAffairsData.Captains
-- 道具数据
local itemsData = DataTrunk.PlayerInfo.ItemsData
-- 拷贝武将数据
local myData = { }

-- 处理装备信息
local function UpdateEquipData(ui, data, equipType)
    local state_C = ui:GetController("State_C")

    if data == nil then
        if itemsData:checkEquipExists(equipType) then
            -- 有装备穿显示加号
            state_C.selectedIndex = 1
        else
            -- 没装备穿
            state_C.selectedIndex = 2
        end
    else
        state_C.selectedIndex = 0
        -- 品质
        ui:GetChild("Loader_Quality").url = UIConfig.Item.EquipQuality[data.Config.Quality.Level]
        -- 图标
        ui:GetChild("Loader_Icon").url = data.Config.Icon
    end
end

local function GeneralListRenderer(index, obj)
    local data = captainsData[myData[index + 1]]
    -- 0:有武将 1:显示+号
    local general_C = obj:GetController("General_C")

    if data == nil then
        -- 没武将显示加号
        general_C.selectedIndex = 1
        -- 点击加号跳转到酒馆面板
        obj.onClick:Set( function()
            UIManager.openController(UIManager.ControllerName.Tavern)
        end )

        return
    end

    -- 有武将
    general_C.selectedIndex = 0
    -- 头像
    obj.icon = data.Head
    -- 品质
    obj:GetController("Quality_C").selectedIndex = CaptainAbilityConfig.Config[data.Ability].Quality - 1
    -- 名字
    obj.title = data.Name
    -- 等级
    obj:GetChild("Text_Level").text = string.format(Localization.Level_1, data.Level)
    -- 武将类型
    obj:GetChild("Label_SoldierType").icon = UIConfig.Race[data.Race]
    -- 兵阶
    -- obj:GetChild("lab_zhiye").title = DataTrunk.PlayerInfo.MilitaryAffairsData.SoldierLevel

    ------------------- 装备 -------------------
    local equipList = obj:GetChild("List_EquipIcon")
    -- 武器
    UpdateEquipData(equipList:GetChildAt(0), data.Equips[EquipType.WU_QI], EquipType.WU_QI)
    -- 头盔
    UpdateEquipData(equipList:GetChildAt(1), data.Equips[EquipType.TOU_KUI], EquipType.TOU_KUI)
    -- 铠甲
    UpdateEquipData(equipList:GetChildAt(2), data.Equips[EquipType.KAI_JIA], EquipType.KAI_JIA)
    -- 护腿
    UpdateEquipData(equipList:GetChildAt(3), data.Equips[EquipType.HU_TUI], EquipType.HU_TUI)
    -- 护符
    UpdateEquipData(equipList:GetChildAt(4), data.Equips[EquipType.SHI_PIN], EquipType.SHI_PIN)

    -- 点击事件
    obj.onClick:Set( function()
        UIManager.openController(UIManager.ControllerName.GeneralDetails, index)
    end )
end

-- 更新武将列表
local function UpdateGeneralList()
    if not _C.IsOpen then
        return
    end

    -- 最大武将数量
    local maxGeneralCount = MonarchsConfig.LevelConfig[DataTrunk.PlayerInfo.MonarchsData.Level].CaptainCountLimit
    view.GeneralDes.text = #captainsData .. "/" .. maxGeneralCount

    myData = { }

    for k, v in pairs(captainsData) do
        table.insert(myData, k)
    end

    view.GeneralList.itemRenderer = GeneralListRenderer
    view.GeneralList.numItems = maxGeneralCount

    -- 提示
    for k, v in pairs(militaryAffairsData.CaptainsCountByMonarchLv) do
        if v.Level > DataTrunk.PlayerInfo.MonarchsData.Level then
            if v.Level >= 999 then
                view.Tips.text = Localization.GeneralCountLimit_1
            else
                view.Tips.text = string.format(Localization.GeneralCountLimit, v.Level, v.Count)
            end
            return
        end
    end
end

function _C:onCreat()
    view = _C.View
    -- top left
    view.BackBtn.onClick:Set( function() _C:close() end)

    Event.addListener(Event.GENERAL_UPDATE, UpdateGeneralList)
end

function _C:onShow()
    UpdateGeneralList()
end 

function _C:onInteractive(isOk)
    if isOk then
        _CchatBrief:setParent(view.UI)
    end
end

function _C:onDestroy()
    view.GeneralList.itemRenderer = nil

    Event.removeListener(Event.GENERAL_UPDATE, UpdateGeneralList)
end