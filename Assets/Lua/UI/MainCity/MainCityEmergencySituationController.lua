local _C = UIManager.SubController(UIManager.ControllerName.MainCityEmergencySituation, nil)
_C.view = nil

local view = nil
-- 紧急军情数据
local emergencyDataList = { }
-- 显示列表
local showList = { }
-- 组队邀请数量
local inviteTeamNum = 0
-- 敌军数量
local enemyNum = 0
-- 被掠夺数量
local plunderNum = 0
-- 被援助数量
local assitanceNum = 0
-- 紧急军情枚举
local EmergencyType = {
    None = 0,
    IVITE_TEAM = 1,
    ENEMY = 2,
    PLUNDER = 3,
    ASSITANCE = 4,
}

-- 军情图标
local function onEmergencyItemRender(index, obj)
    obj.gameObjectName = tostring(index)
    local dataNum = emergencyDataList[showList[index]]
    if dataNum > 99 then
        dataNum = 99
    end
    if dataNum > 0 then
        obj.icon = UIConfig.EmergencyIconUrl[showList[index]]
        obj:GetChild("Text_Number").text = dataNum
        if showList[index] == EmergencyType.IVITE_TEAM then
            obj:GetChild("Text_Team").text = Localization.EmergencyTitle1
            obj.onClick:Set( function()
                UIManager.openController(UIManager.ControllerName.TowerBackroomMain)
            end )
        elseif showList[index] == EmergencyType.ENEMY then
            obj:GetChild("Text_Team").text = Localization.EmergencyTitle2
            obj.onClick:Set( function()
                UIManager.openController(UIManager.ControllerName.WarSituation)
            end )
        elseif showList[index] == EmergencyType.PLUNDER then
            obj:GetChild("Text_Team").text = Localization.EmergencyTitle3
            obj.onClick:Set( function()
                UIManager.openController(UIManager.ControllerName.WarSituation)
            end )
        elseif showList[index] == EmergencyType.ASSITANCE then
            obj:GetChild("Text_Team").text = Localization.EmergencyTitle4
            obj.onClick:Set( function()
                UIManager.openController(UIManager.ControllerName.WarSituation)
            end )
        end
    end
end

-- 更新军情图标显示
local function UpdateEmerGencyIconList()
    if inviteTeamNum + enemyNum + plunderNum + assitanceNum == 0 then
        view.EmergencyList.visible = false
        return
    else
        view.EmergencyList.visible = true
    end
    emergencyDataList = { }
    showList = { }
    local index = 0
    if inviteTeamNum > 0 then
        emergencyDataList[EmergencyType.IVITE_TEAM] = inviteTeamNum
        showList[index] = EmergencyType.IVITE_TEAM
        index = index + 1
    else
        emergencyDataList[EmergencyType.IVITE_TEAM] = nil
    end
    if enemyNum > 0 then
        emergencyDataList[EmergencyType.ENEMY] = enemyNum
        showList[index] = EmergencyType.ENEMY
        index = index + 1
    else
        emergencyDataList[EmergencyType.ENEMY] = nil
    end
    if plunderNum > 0 then
        emergencyDataList[EmergencyType.PLUNDER] = plunderNum
        showList[index] = EmergencyType.PLUNDER
        index = index + 1
    else
        emergencyDataList[EmergencyType.PLUNDER] = nil
    end
    if assitanceNum > 0 then
        emergencyDataList[EmergencyType.ASSITANCE] = assitanceNum
        showList[index] = EmergencyType.ASSITANCE
    else
        emergencyDataList[EmergencyType.ASSITANCE] = nil
    end

    view.EmergencyList.itemRenderer = onEmergencyItemRender
    view.EmergencyList.numItems = Utils.GetTableLength(showList)
end

local function onInviteTeamNumChange()
    inviteTeamNum = DataTrunk.PlayerInfo.TowerBackroom.InviteTroopsInfo.TroopsCount
    UpdateEmerGencyIconList()
end

local function onEnemyNumChange()
    UpdateEmerGencyIconList()
end

local function onPlunderNumChange()
    UpdateEmerGencyIconList()
end

local function onAssitanceNumChange()
    UpdateEmerGencyIconList()
end

local function onEmergencyChange(enemy, plunder, assitance)
    enemyNum = enemy
    plunderNum = plunder
    assitanceNum = assitance
    onEnemyNumChange()
    onPlunderNumChange()
    onAssitanceNumChange()
end

function _C:onCreat()
    view = _C.view

    Event.addListener(Event.TOWER_BACKROOM_INVITE_COUNT, onInviteTeamNumChange)
    Event.addListener(Event.MAINUI_MILITARY_UPDATE, onEmergencyChange)
end

function _C:onShow()
    onInviteTeamNumChange()
    onEnemyNumChange()
    onPlunderNumChange()
    onAssitanceNumChange()
end

function _C:onDestroy()
    view.EmergencyList.itemRenderer = nil
    Event.removeListener(Event.TOWER_BACKROOM_INVITE_COUNT, onInviteTeamNumChange)
    Event.removeListener(Event.MAINUI_MILITARY_UPDATE, onEmergencyChange)
end

return _C