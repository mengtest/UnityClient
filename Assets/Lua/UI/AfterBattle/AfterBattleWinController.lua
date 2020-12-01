local _C = UIManager.Controller(UIManager.ControllerName.AfterBattleWin, UIManager.ViewName.AfterBattleWin)
-- view
local view = nil
-- 回放信息
local battleInfo = nil
-- 武将库
local captainInsInfo = DataTrunk.PlayerInfo.MilitaryAffairsData.Captains

-- 返回--
local function btnToBack()
    _C:close()
    if LevelManager.PreLevelType == LevelType.MainCity then
        LevelManager.loadScene(LevelType.MainCity)
    elseif LevelManager.PreLevelType == LevelType.WorldMap then
        -- 加载场景
        LevelManager.loadScene(LevelType.WorldMap)
    end
end
-- 战斗进展信息
local function btnToProgress()
    UIManager.openController(UIManager.ControllerName.BattleProgress, battleInfo.progress)
end
-- 重播--
local function btnToReplay()
    _C:close()
    UIManager.openController(UIManager.ControllerName.Battle)
end
-- 详情--
local function btnToDetail()
    UIManager.openController(UIManager.ControllerName.AfterBattleDetail, battleInfo)
end
-- 分享
local function btnToShare()
    print("Share button on click")
end
-- pvp结果
local function updatePVPAward()
    if battleInfo.replayInfo.Result.PVPAward == nil then
        return
    end

    view.PVPFood.title = battleInfo.replayInfo.Result.PVPAward.Currency[CurrencyType.Food]
    view.PVPWood.title = battleInfo.replayInfo.Result.PVPAward.Currency[CurrencyType.Wood]
    view.PVPStone.title = battleInfo.replayInfo.Result.PVPAward.Currency[CurrencyType.Stone]
    view.PVPGold.title = battleInfo.replayInfo.Result.PVPAward.Currency[CurrencyType.Gold]
    view.PVPResource.title = Localization.RaidingCapacity .. tostring(battleInfo.replayInfo.Result.PVPAward.CurLoadResource) .. "/" .. tostring(battleInfo.replayInfo.AttackerPlayer.TotalLoadResource)
end
-- pve结果
local function updatePVEAward()
    if battleInfo.replayInfo.Result.PVEAward == nil then
        -- 看别人回放时不显示信息
        view.PVEStat.selectedIndex = 1
        return
    end
    view.PVEStat.selectedIndex = 0

    -- 武将item
    view.PVECaptainList:RemoveChildrenToPool()
    for k, v in pairs(battleInfo.replayInfo.AttackerPlayer.TroopsList) do
        local item = view.PVECaptainList:AddItemFromPool()

        -- 武将实例化信息,依据槽位获取，槽位 + 1
        local captainInsId = battleInfo.replayInfo.Result.PVEAward.Captains[v.IdY + 1]
        local captainInsInfo = captainInsInfo[captainInsId]

        -- 是否升级
        if captainInsInfo.Level > v.Captain.Level then
            item:GetTransition("wujiang_shengji"):Play()
        else
            item:GetTransition("wujiang_shengji"):Stop()
        end

        -- 经验增加
        item:GetChild("txt_jinyan").text = string.format(Localization.Exp_1, battleInfo.replayInfo.Result.PVEAward.GeneralExp)

        -- 经验条
        local expBar = item:GetChild("progressBar_1")
        expBar.max = CaptainLevelConfig:getConfigByLevel(captainInsInfo.Level)
        expBar.value = captainInsInfo.Exp

        -- 武将
        local heroCaptain = item:GetChild("img_di")
        heroCaptain:GetController("Quality_C").selectedIndex = captainInsInfo.Quality - 1
        heroCaptain:GetChild("Text_Level").text = captainInsInfo.Level
        heroCaptain:GetChild("Loader_Icon").url = captainInsInfo.Head
        heroCaptain:GetChild("Label_GeneralType").icon = UIConfig.Race[captainInsInfo.Race]
        item:GetChild("txt_zi").text = captainInsInfo.Name

        view.PVECaptainList:AddChild(item)
    end

    -- 道具item
    view.PVEItemList:RemoveChildrenToPool()
    for k, v in pairs(battleInfo.replayInfo.Result.PVEAward.Items) do
        local item = view.PVEItemList:AddItemFromPool()

        -- 添加监听
        item.onClick:Set( function() UIManager.openController(UIManager.ControllerName.ItemTips, v) end)

        -- 刷新数据
        item:GetController("State_C").selectedIndex = 1
        item:GetController("Count_C").selectedIndex = 1
        item:GetController("CornerMark_C").selectedIndex = 0
        item:GetChild("title").text = v.Amount
        item:GetChild("icon").url = v.Config.Icon

        -- 品质
        if v.ClassifyType == ItemClassifyType.Equip then
            item:GetChild("quality").url = UIConfig.Item.EquipQuality[v.Config.Quality.Level]
        else
            item:GetChild("quality").url = UIConfig.Item.DefaultQuality[v.Config.Quality]
        end
        view.PVEItemList:AddChild(item)
    end
end
-- 胜利效果
local function playWinEffect()
    view.EffectWin:Play()

    -- 胜利类型判断
    if battleInfo.replayInfo.Result.BattleResultType == BattleResultType.CompleteWin then
        view.WinType.url = UIConfig.AfterBattle.CompleteWin
    elseif battleInfo.replayInfo.Result.BattleResultType == BattleResultType.Victory then
        view.WinType.url = UIConfig.AfterBattle.Victory
    elseif battleInfo.replayInfo.Result.BattleResultType == BattleResultType.Win then
        view.WinType.url = UIConfig.AfterBattle.Win
    elseif battleInfo.replayInfo.Result.BattleResultType == BattleResultType.Squeak then
        view.WinType.url = UIConfig.AfterBattle.Squeak
    end

    -- 战斗类型判断
    if battleInfo.replayInfo.Style == BattleStyleType.PVP then
        view.PanelPVE.visible = false
        view.PanelPVP.visible = true

        updatePVPAward()
        view.EffectPVP:Play()
    else
        view.PanelPVP.visible = false
        view.PanelPVE.visible = true

        updatePVEAward()
        view.EffectPVE:Play()
    end
end
function _C:onCreat()
    view = _C.View

    view.BtnDetial.onClick:Add(btnToDetail)
    view.BtnReplay.onClick:Add(btnToReplay)
    view.BtnProgress.onClick:Add(btnToProgress)
    view.BtnBack.onClick:Add(btnToBack)
end

function _C:onOpen(data)
    battleInfo = data
    AudioManager.PlaySound('UI_Battle_Win', 1)
    playWinEffect()
end
function _C:onDestroy()
    view.BtnDetial.onClick:Clear()
    view.BtnReplay.onClick:Clear()
    view.BtnProgress.onClick:Clear()
    view.BtnBack.onClick:Clear()

    itemsCache = { }
end