local _C = UIManager.Controller(UIManager.ControllerName.MoveCityConfirm, UIManager.ViewName.MoveCityConfirm)
_C.IsPopupBox = true
local view = nil
local newX = -1
local newY = -1

local moveCityData = nil
local moveBuidingType = nil

-- 关闭自己
local function closeSelf()
    LevelManager.CurrLevelLogic:leaveAdvancedMoveBase()
    _C:close()
end

-- 请求迁移城池
local function onMoveCity()
    -- 非法坐标
    if newX < 0 or newY < 0 then
        return
    end

    if moveBuidingType == BuildingType.Campsite then
        UIManager.openController(UIManager.ControllerName.Popup, 
            { 
                UIManager.PopupStyle.ContentYesNo, 
                btnFunc = function()
                    local mapId = LevelManager.CurrLevelLogic.getCurrentMapId()
                    if DataTrunk.PlayerInfo.MonarchsData.CampMap == 0 then
                        NetworkManager.C2SNewTentProto(mapId, newX, newY)
                    else
                        NetworkManager.C2SFastMoveBaseProto(mapId, newX, newY, true)
                    end
                end,
                content = string.format(Localization.CampsiteMoveCostTips, Utils.secondConversion(math.floor(RegionCommonConfig.Config.CampsiteBuildingTime)))
            }
        )
    else
        local mapId = LevelManager.CurrLevelLogic.getCurrentMapId()
        NetworkManager.C2SFastMoveBaseProto(mapId, newX, newY, false)
    end
    closeSelf()
end

-- 更新迁移城池数据和状态
local function onUpdateMoveCityStatus()
    moveCityData = LevelManager.CurrLevelLogic:getMoveCityData()
    if moveCityData == nil then
        return
    end

    -- 更新此界面显示位置
    view.UI.position = CS.LPCFramework.InputController.WorldToScreenPoint(moveCityData.Position) + CS.UnityEngine.Vector3(0, 100, 0)

    -- 设置迁城按钮是否可操作
    if moveCityData.CanPut == true then
        view.MoveBtn.grayed = false
        view.MoveBtn.touchable = true

        newX = moveCityData.OddQX
        newY = moveCityData.OddQY
    else
        view.MoveBtn.grayed = true
        view.MoveBtn.touchable = false

        newX = -1
        newY = -1
    end
end

function _C:onOpen(data)
    newX = -1
    newY = -1
    moveBuidingType = data
    view.MoveBtn.grayed = true
    view.MoveBtn.touchable = false

    -- 更新此界面显示位置
    moveCityData = LevelManager.CurrLevelLogic:getMoveCityData()
    if moveCityData ~= nil and moveCityData.Position ~= nil then
        view.UI.position = CS.LPCFramework.InputController.WorldToScreenPoint(moveCityData.Position) + CS.UnityEngine.Vector3(0, 100, 0)
    end

end

function _C:onCreat()
    view = _C.View

    view.CancelBtn.onClick:Set(closeSelf)
    view.MoveBtn.onClick:Set(onMoveCity)

    Event.addListener(Event.ON_MOVE_CITY_STATUS_UPDATED, onUpdateMoveCityStatus)
end

function _C:onDestroy()
    Event.removeListener(Event.ON_MOVE_CITY_STATUS_UPDATED, onUpdateMoveCityStatus)
end
