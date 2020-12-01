local _C = UIManager.Controller(UIManager.ControllerName.GeneralSoulIllustration, UIManager.ViewName.GeneralSoulIllustration)
local view = nil

-- 玩家将魂信息
local playerSoulData = DataTrunk.PlayerInfo.CaptainSoulData
-- 将魂Id
local soulIdData = { }

-- 判断是否已经解锁
local function isUnlockSoul( soulId )
	for _,v in pairs(playerSoulData.UnlockCaptainSouls) do
		if v == soulId then
			return true
		end
	end
	return false
end

-- 将魂排序
local function sompareSoul( soulID1, soulID2 )
	local isSoul1Unlocked = isUnlockSoul(soulID1)
	local isSoul2Unlocked = isUnlockSoul(soulID2)
	if not isSoul1Unlocked and isSoul2Unlocked then 
		return false
	else if isSoul1Unlocked == isSoul2Unlocked then
	 	return soulID1 > soulID2
	else
		return true
	end
end
end

-- 更新将魂id列表
local function UpdateSoulIDList()
    -- 没有武将关闭界面
    if Utils:GetTableLength(CaptainSoulConfig.Config) == 0 then
        _C:close()
        return
    end
    soulIdData = { }
    for k, v in pairs(CaptainSoulConfig.Config) do
        if v == nil then
            break
        end
        table.insert(soulIdData, k)
    end
end

-- 填充列表
local function onSoulIllustratedItemRender( index, obj )
	obj.gameObjectName = tostring(index)
    local soulId = soulIdData[index + 1]
    local itemInfo = CaptainSoulConfig:getConfigById(soulId)
    if itemInfo == nil then
    	return
	else
		obj:GetChild("txt_jianghunmingzi").text = itemInfo.Name
		obj:GetChild("icon").url = itemInfo.Icon
		-- 目前将魂颜色全为白色
		obj:GetChild("list_quality"):GetController("Quality_C").selectedIndex = 0
		local qulityName = "CaptainSoulQualityName" .. itemInfo.Quality
		obj:GetChild("lab_shengjiang").title = Localization.qulityName
		obj:GetChild("txt_dengji").text = Localization.qulityName
	end
	if not isUnlockSoul(soulId) then
		obj.grayed = true
	else
		obj.grayed = false
	end
	obj.onClick:Set( function()
		UIManager.openController(UIManager.ControllerName.GeneralSoulDetail, itemInfo)
	end)
end

function _C:onCreat()
    view = _C.View
    -- 按钮绑定
    view.BackBtn.onClick:Set( function() _C:close() end)
    view.FettersBtn.onClick:Set( function()
    	UIManager.openController(UIManager.ControllerName.GeneralSoulFetters)
    end)
    -- 事件监听
    --Event.addListener(Event.GENERAL_RENAME_CUCCESS, GeneralRenameSucc)
end

function _C:onOpen(index)
	-- 更新将魂ID
	UpdateSoulIDList()
	-- 排序
	table.sort( soulIdData, sompareSoul )
	-- 列表
	view.SoulList.itemRenderer = onSoulIllustratedItemRender
	view.SoulList.numItems = #soulIdData
end

function _C:onInteractive(isOk)
end

function _C:onDestroy()
    --Event.removeListener(Event.GENERAL_RENAME_CUCCESS, GeneralRenameSucc)
end