local _C = UIManager.Controller(UIManager.ControllerName.Lords, UIManager.ViewName.Lords)
local _CchatBrief = require(UIManager.ControllerName.ChatBrief)
local _CWhiteFlag = require(UIManager.ControllerName.WhiteFlag)
table.insert(_C.SubCtrl, _CchatBrief)
table.insert(_C.SubCtrl, _CWhiteFlag)
local view = nil

-- 改名列表
local oldNameContent = ""
-- 某玩家的信息
local playerInfo = nil

local function AllianceBtnOnClick()
    -- 未加入联盟，打开选择联盟界面；否则打开我的联盟界面
    if DataTrunk.PlayerInfo.MonarchsData.GuildId == 0 then
        UIManager.openController(UIManager.ControllerName.CreateOrJoinAlliance)
    else
        UIManager.openController(UIManager.ControllerName.Alliance)
    end
end

local function RenameBtnOnClick()
    UIManager.openController(UIManager.ControllerName.ChangeName, oldNameContent)
end

local function SettingsBtnOnClick()
    UIManager.openController(UIManager.ControllerName.Settings)
end

local function ChatBtnOnClick()
    print("ChatBtn On Click")
end

local function FriendBtnOnClick()
    print("FriendBtn On Click")
end

-- 曾用名按钮
local function FormerNameBtnOnClick()
    view.Tips.title = oldNameContent
    view.Tips.visible = true
    view.FormerNameBtn.touchable = false
    view.Tips_T:Play( function() view.FormerNameBtn.touchable = true end)
end

-- 插白旗
local function UpdateWhiteFlag(data)
    local whiteFlagInfo = data.FlagGuildFlagName
    local expireTime = false
    if data.FlagExpire ~= nil and TimerManager.currentTime > data.FlagExpire then
        expireTime = true
    end

    if whiteFlagInfo == nil or whiteFlagInfo == "" or expireTime then
        view.Flag_C.selectedIndex = 1
    else
        view.Flag_C.selectedIndex = 0
        view.WhiteFlag:GetChild("Text_FlagName").text = whiteFlagInfo
        view.WhiteFlag.onClick:Set( function()
            _CWhiteFlag.GetFlagDetail(data.Id)
        end )
    end
end

-- 刷新界面
local function Refresh(data)
    if not _C.IsOpen then
        return
    end
    -- 城池等级
    local cityLevel = data.BaseLevel

    if cityLevel > 0 then
        view.State_C.selectedIndex = 0
        -- 主城等级
        view.CityLevel.text = cityLevel
        view.CityExpBar.max = MainCityLevelConfig.Config[cityLevel].RequireProsperity
        -- 坐标
        view.Coords.title = string.format(Localization.LordsCoord, data.BaseX, data.BaseY)
        view.Coords.onClick:Set( function()
            DataTrunk.PlayerInfo.RegionData:setSelectRegion(data.MapId)
            DataTrunk.PlayerInfo.RegionData:setSelectPos(data.BaseX, data.BaseY)
            Event.dispatch(Event.ENTER_OUTSIDE)
            _C:close()
        end )
    else
        view.State_C.selectedIndex = 1
    end

    if data.IsMainPlayer then
        -- 0:联盟 1:没有联盟
        if data.GuildId == 0 then
            view.Alliance_C.selectedIndex = 1
        else
            view.Alliance_C.selectedIndex = 0
        end

        view.IsMainPlayer_C.selectedIndex = 0
        local internalData = DataTrunk.PlayerInfo.InternalAffairsData

        if cityLevel > 0 then
            -- 城池经验条(繁荣度)
            view.CityExpBar.value = internalData.Prosperity
        end

        -- 战斗力
        view.Power.text = DataTrunk.PlayerInfo.MonarchsData.FightAmount
        -- 经验条
        view.LordExpBar.value = data.Exp
        view.LordExpBar.max = MonarchsConfig.LevelConfig[data.Level].UpgradeExp
    else
        view.IsMainPlayer_C.selectedIndex = 1

        if cityLevel > 0 then
            -- 城池经验条(繁荣度)
            view.CityExpBar.value = data.BaseProsperity
        end

        -- 战斗力
        view.Power.text = data.FightAmount
    end

    -- 没有联盟显示“无”,+按钮显隐
    if data.Guild == "" then
        view.Alliance.text = Localization.None
    else
        view.Alliance.text = data.Guild
    end

    -- 名字
    view.Name.text = data.Name

    -- 曾用名按钮
    view.FormerNameBtn.visible = data.HasOldName
    -- 大头像
    view.Picture.url = data.Head.BigIcon
    -- 小头像
    view.Icon.url = data.Head.SmallIcon
    -- 等级
    view.LordLevel.text = data.Level

    UpdateWhiteFlag(data)
end

-- data 君主信息
function _C:onOpen(data)
    Refresh(data)
    playerInfo = data

    if data.HasOldName and playerInfo ~= nil and playerInfo.Id ~= nil then
        -- 获取曾用名列表
        NetworkManager.C2SListOldNameProto(playerInfo.Id)
    end
end

-- 改名回调,更新曾用名列表
local function OldNameReqCallBack(nameList)
    if not _C.IsOpen then
        return
    end

    oldNameContent = ""

    for k, v in ipairs(nameList) do
        oldNameContent = oldNameContent .. v .. "\n"
    end
end

function _C:onCreat()
    view = _C.View
    _CWhiteFlag.view = view
    -- top left
    view.BackBtn.onClick:Set( function() _C:close() end)

    view.IllustrationBtn.onClick:Set( function()
        UIManager.openController(UIManager.ControllerName.GeneralSoulIllustration)
    end )

    -- center
    view.FormerNameBtn.onClick:Set(FormerNameBtnOnClick)
    view.AllianceBtn.onClick:Set(AllianceBtnOnClick)
    view.RenameBtn.onClick:Set(RenameBtnOnClick)
    view.SettingsBtn.onClick:Set(SettingsBtnOnClick)

    Event.addListener(Event.OLD_NAME_LIST_UPDATE, OldNameReqCallBack)
    Event.addListener(Event.PLAYER_INFO_UPDATE, function() Refresh(playerInfo) end)
    Event.addListener(Event.ALLIANCE_ON_UPDATE_NAME_OR_FLAG_SUCCESS, function() Refresh(playerInfo) end)
end

function _C:onInteractive(isOk)
    if isOk then
        _CchatBrief:setParent(view.UI)
    end
end

function _C:onDestroy()
    view.IllustrationBtn.onClick:Clear()
    view.FormerNameBtn.onClick:Clear()
    view.AllianceBtn.onClick:Clear()
    view.RenameBtn.onClick:Clear()
    view.SettingsBtn.onClick:Clear()
    Event.removeListener(Event.OLD_NAME_LIST_UPDATE, OldNameReqCallBack)
    Event.removeListener(Event.PLAYER_INFO_UPDATE, function() Refresh(playerInfo) end)
    Event.removeListener(Event.ALLIANCE_ON_UPDATE_NAME_OR_FLAG_SUCCESS, function() Refresh(playerInfo) end)
    view.WhiteFlag.onClick:Clear()
end