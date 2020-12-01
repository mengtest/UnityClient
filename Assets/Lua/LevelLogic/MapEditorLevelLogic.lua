local levelLogic = require "LevelLogic.LevelLogic"
local MapEditorLevelLogic = levelLogic:extend()
local Event = require "Event.Event"

-- 本脚本实例
local logic = nil
-- 当前地图Id
local currMapId = -1

-- **********************************************************************************************
-- 场景事件
-- **********************************************************************************************

-- 初始化场景地图--
function MapEditorLevelLogic:initLevel(levelConfig)
    logic.super.initLevel(logic, levelConfig)
end

-- 进入场景--
function MapEditorLevelLogic:onEnterScene(callBack)
    logic = self
    logic:initLevel(LevelManager.CurrLevelConfig)

    -- Todo，等Level表与服务器同学商量重新设计后，这里读取配置
    currMapId = 1

    logic:enterBigMap()

    -- 逻辑处理完成
    if callBack ~= nil then
        callBack()
    end

    UIManager.openController(UIManager.ControllerName.MapEditor)

    AudioManager.PlaySound('BGM_Field01', 1)
end

-- 退出场景--
function MapEditorLevelLogic:onExitScene()
    logic:leaveBigMap()
    currMapId = -1
    logic = nil
end

-- 更新
function MapEditorLevelLogic:update()

end

-- **********************************************************************************************

-- 进入大地图
function MapEditorLevelLogic:enterBigMap()
    -- 告诉地面现在Lua来管事了
    if not CS.LPCFramework.TerrainLuaDelegates.GoBigMap() then
        -- print("地面没在?")
    else
        -- 将所有静态物体都设置为透明，方便调试
        CS.LPCFramework.TerrainLuaDelegates.SetStaticItemAsTransparentItem()
        -- 开始地表格子显示
        CS.LPCFramework.TerrainLuaDelegates.EnableGridDisplay(true)
        -- 读取本地图的存档
        CS.LPCFramework.TerrainLuaDelegates.ReadGridPropertyFromFile(currMapId)
        -- 设置camera参数
        CS.LPCFramework.TerrainLuaDelegates.SetCameraParameters(0.02, 5.0, 15.0)
        -- 设置点触地面回调
        CS.LPCFramework.TerrainLuaDelegates.SetClickGroundCallBack("OnClickBigMapGround")
        -- 设置摄像机移动回调
        CS.LPCFramework.TerrainLuaDelegates.SetOnCameraFaceToCallback("OnCameraFaceToChanged")
    end
end

-- 离开大地图
function MapEditorLevelLogic:leaveBigMap()
    -- 告诉地面现在Lua撒手不管了
    if not CS.LPCFramework.TerrainLuaDelegates.LeaveBigMap() then
        -- print("地面没在?")
    else

    end
end

-- 获取当前的地图Id
function MapEditorLevelLogic:getCurrentMapId()
    return currMapId
end

-- 点击了大地图地面回调
-- v3Position是iOddQX,iOddQY对应的位置，注意，不是点击的位置，点击可能不在格子中心
-- v3Normal是v3Position处的法线
function MapEditorLevelLogic:OnClickBigMapGround(v2UV, iOddQX, iOddQY, v3Position, v3Normal, groundInfo)
    print("戳到了 x:" .. iOddQX .. " y:" .. iOddQY)
end

-- 玩家动了摄像机
function MapEditorLevelLogic:OnCameraFaceToChanged(iOddQX, iOddQY, fDistance)
    -- 发送事件，通知UI处理事情
    Event.dispatch(Event.CLOSE_CITY_MENU)
end

function OnClickBigMapGround(v2UV, iOddQX, iOddQY, v3Position, v3Normal, groundInfo)
    MapEditorLevelLogic:OnClickBigMapGround(v2UV, iOddQX, iOddQY, v3Position, v3Normal, groundInfo)
end

function OnCameraFaceToChanged(iOddQX, iOddQY, fDistance)
    MapEditorLevelLogic:OnCameraFaceToChanged(iOddQX, iOddQY, fDistance)
end

return MapEditorLevelLogic