local _C = UIManager.Controller(UIManager.ControllerName.AfterBattleFail, UIManager.ViewName.AfterBattleFail)
-- view
local view = nil
-- 回放信息
local battleInfo = nil

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
local function updatePVPLose()
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
local function updatePVELose()
end
-- 胜利效果
local function playWinEffect()
    view.EffectFail:Play()

    -- 战斗类型判断
    if battleInfo.replayInfo.Style == BattleStyleType.PVP then
        view.PanelPVE.visible = false
        view.PanelPVP.visible = true

        updatePVPLose()
        view.EffectPVP:Play()
    else
        view.PanelPVP.visible = false
        view.PanelPVE.visible = true

        updatePVELose()
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
    AudioManager.PlaySound('UI_Battle_Fail', 1)
    playWinEffect()
end

function _C:onDestroy()
    view.BtnDetial.onClick:Clear()
    view.BtnReplay.onClick:Clear()
    view.BtnProgress.onClick:Clear()
    view.BtnBack.onClick:Clear()
end