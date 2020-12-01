local _C = UIManager.Controller(UIManager.ControllerName.GeneralSoulMain, UIManager.ViewName.GeneralSoulMain)

local view = nil
-- 玩家将魂信息
local captainSoulData = DataTrunk.PlayerInfo.CaptainSoulData
-- CaptainSoulConfig
-- 将魂附身数据
local captainSoulAttached = DataTrunk.PlayerInfo.MilitaryAffairsData.CaptainSoulAttachedInfo
-- 当前武将
local curCaptain = nil

local function requestAttachSoul( captainId, isUp, soulId )
	-- 请求武将附身
	NetworkManager.C2SAttachSoulProto( captainId, isUp, soulId)
end

local function onCaptainSoulItemRender(index, obj)
    obj.gameObjectName = tostring(index)
    local soulId = captainSoulData.UnlockCaptainSouls[index + 1]
    local itemInfo = CaptainSoulConfig:getConfigById(soulId)
    if itemInfo == nil then
    	return
	else
        -- 名字
		obj:GetChild("TextField_SoulName").text = itemInfo.Name
        -- 图片
		obj:GetChild("Loader_GeneralIcon").url = itemInfo.Icon
		-- 品质框
        local qualityNum = itemInfo.Quality - 1
		obj:GetChild("Component_Square"):GetController("Quality_C").selectedIndex = qualityNum
        -- 品质控制器（称号、评级）
        obj:GetController("State_C").selectedIndex = qualityNum
        -- 增加的士气
		obj:GetChild("TextField_Development").text = itemInfo.AddMorale
	end

	if captainSoulAttached[itemInfo.Id] ~= nil then
		-- 将魂已附身
		obj:GetChild("TextField_GeneralName").text = DataTrunk.PlayerInfo.MilitaryAffairsData.Captains[captainSoulAttached[itemInfo.Id]].Name
	else
		-- 无将魂附身
		obj:GetChild("TextField_GeneralName").text = ""
		obj:GetChild("Button_Acquire").onClick:Set(
			function ()
				requestAttachSoul(curCaptain.Id, true, itemInfo.Id)	
			end
		)
	end
end

local function AttachSoulSucc( data )
	_C:close()
end

function _C:onCreat()
    view = _C.View
    -- 按钮绑定
    view.BackBtn.onClick:Set( function() _C:close() end)
    -- 事件监听
    Event.addListener(Event.CAPTAIN_ATTACH_SOUL_SUCCESS, AttachSoulSucc)
end

function _C:onOpen(data)
	curCaptain = data
	view.CaptainSoulList.itemRenderer = onCaptainSoulItemRender 
	view.CaptainSoulList.numItems = #captainSoulData.UnlockCaptainSouls
end

function _C:onInteractive(isOk)
	-- if isOk then
 --        view.CaptainSoulList:RefreshVirtualList()
 --    end
end

function _C:onDestroy()
    Event.removeListener(Event.CAPTAIN_ATTACH_SOUL_SUCCESS, AttachSoulSucc)
end