local _C = UIManager.Controller(UIManager.ControllerName.ClimbingTowerMoopingUpReady, UIManager.ViewName.ClimbingTowerMoopingUpReady)
local _CTroop = require(UIManager.ControllerName.TroopsSelect)
table.insert(_C.SubCtrl, _CTroop)

_C.IsPopupBox = true

local view = nil
-- 千重楼实例化信息
local towerInsInfo = DataTrunk.PlayerInfo.TowerData
-- 楼层共层数
local towerTotalFloor = MiscCommonConfig.Config.TowerTotalFloor
-- 君主实例化数据
local monarchInsInfo = DataTrunk.PlayerInfo.MonarchsData.LevelConfig
-- 武将库
local captainInsInfo = DataTrunk.PlayerInfo.MilitaryAffairsData.Captains
-- 参与扫荡武将
local moopingupCaptainList = nil
-- 布阵信息
local embattleInfo = { FightAmountShowType = 0, BattleTargetRace = nil }

-- 返回
local function btnBack()
    _C:close()
end
-- 布阵
local function btnToTroopsEmbattle()
    UIManager.openController(UIManager.ControllerName.TroopsEmbattle)
end
-- 开始扫荡
local function btnStart()
    -- 判断阵上是否更改
    _CTroop:c2sTroopsSync( function()
        -- 获取阵上武将
        local count, captainList = _CTroop:getCurTroopCaptains_2()

        -- 上阵武将个数限制判断
        if nil ~= monarchInsInfo then
            -- 上阵武将太多
            if count > monarchInsInfo.TowerCaptainLimit then
                UIManager.showTip( { content = string.format(Localization.TowerTroopCaptainNum_1, monarchInsInfo.TowerCaptainLimit), result = false })
                return
            end
            -- 上阵武将太少
            if count < monarchInsInfo.TowerCaptainLimit and DataTrunk.PlayerInfo.MilitaryAffairsData:getIdleCaptainCount() > count then
                UIManager.showTip( { content = string.format(Localization.TowerTroopCaptainNum_2, monarchInsInfo.TowerCaptainLimit), result = false })
                return
            end
        end
        -- 扫荡前武将信息保存
        moopingupCaptainList = { }
        for k, v in pairs(captainList) do
            if v ~= 0 then
                table.insert(moopingupCaptainList, { insId = v, captain = captainInsInfo[v], befLevel = captainInsInfo[v].Level })
            end
        end
        print("进行扫荡！！")
        NetworkManager.C2SAutoChallengeProto(captainList)
    end )
end
-- 扫荡成功
local function moopingupSucceedAck()
    if not _C.IsOpen then
        return
    end

    btnBack()
    UIManager.openController(UIManager.ControllerName.ClimbingTowerMoopingUpStart, moopingupCaptainList)
end

-- 更新扫荡描述
local function updateMoopingupInfo()
    -- 可扫荡楼层描述
    if towerInsInfo.AutoMaxFloor == towerTotalFloor then
        view.MoopingUpDesc.text = string.format(Localization.TowerMoopingupDesc_1, towerInsInfo.AutoMaxFloor)

    else
        view.MoopingUpDesc.text = string.format(Localization.TowerMoopingupDesc_2, towerInsInfo.AutoMaxFloor + 1, towerInsInfo.AutoMaxFloor)
    end

    -- 扫荡次数（加数据）
    view.MoopingUpCount.text = 10
    -- 重置时间
    view.ResetTime.text = string.format(Localization.TimeReset, MiscCommonConfig.Config.DailyResetTime)
    -- 历史最高层
    view.MoopingUpFloorMax.text = towerInsInfo.HistoryMaxFloor
end

function _C:onCreat()
    view = _C.View

    view.BtnBack.onClick:Add(btnBack)
    view.BtnStart.onClick:Add(btnStart)
    view.BtnTroopEmbattle.onClick:Add(btnToTroopsEmbattle)

    Event.addListener(Event.TOWER_AUTO_CHALLENGE_SUCCEED, moopingupSucceedAck)
end
function _C:onOpen(data)
    updateMoopingupInfo()
end
function _C:onShow()
    -- 0进入布阵
    _CTroop:clear()
    _CTroop.fightAmountShowType = 1
    _CTroop:setParent(view.TroopSlot)
end
function _C:onDestroy()
    view.BtnBack.onClick:Clear()
    view.BtnStart.onClick:Clear()
    view.BtnTroopEmbattle.onClick:Clear()

    Event.removeListener(Event.TOWER_AUTO_CHALLENGE_SUCCEED, moopingupSucceedAck)
end
