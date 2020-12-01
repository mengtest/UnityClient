local _C = UIManager.Controller(UIManager.ControllerName.GeneralSoulDetail, UIManager.ViewName.GeneralSoulDetail)
_C.IsPopupBox = true
local view = nil

-- 玩家将魂信息
local playerSoulData = DataTrunk.PlayerInfo.CaptainSoulData
-- 当前将魂
local curSoulData = nil

-- 判断是否已经解锁
local function isUnlockSoul( soulId )
	for _,v in pairs(playerSoulData.UnlockCaptainSouls) do
		if v == soulId then
			return true
		end
	end
	return false
end

local function UpdateSoulDetailPanel()
	-- 是否已经解锁
	if isUnlockSoul(curSoulData.Id) then
		view.UI:GetController("Status").selectedIndex = 1
	else
		view.UI:GetController("Status").selectedIndex = 0
		view.GetSoulBtn.onClick:Set( function ()
			-- TODO:跳转到获取将魂界面
			UIManager.openController(UIManager.ControllerName.GeneralSoulObtain)
		end)
	end

    view.QualityController.selectedIndex = curSoulData.Quality - 1
	view.SoulICon.url = curSoulData.Icon
	view.SoulNameText.text = curSoulData.Name
	view.SoulDescText.text = curSoulData.Desc
end

function _C:onCreat()
    view = _C.View
    -- 按钮绑定
    view.BackBtn.onClick:Set( function() _C:close() end)
    view.FettersBtn.onClick:Set( function()
    	UIManager.openController(UIManager.ControllerName.GeneralSoulFetters)
    end)
end

function _C:onOpen(index)
	curSoulData = index
	UpdateSoulDetailPanel()
end