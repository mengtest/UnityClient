local _C = UIManager.Controller(UIManager.ControllerName.GemRemove, UIManager.ViewName.GemRemove)
_C.IsPopupBox = true
local view = nil
-- 当前英雄
local curCaptain = nil
-- 当前魂槽
local curSlotIndex = -1
-- 当前宝石
local curGem = nil

local function UpdateGemInfo()
	view.ComGem:GetChild("Loader_GemIcon").url = curGem.Icon
	view.ComGem:GetChild("Txt_Level").text = curGem.Level
	view.curLevelLab.text = string.format(Localization.GemLevel, curGem.Level)
	view.GemNameLab.text = curGem.Name
	-- 属性值
	if curGem.TotalStat.Attack ~= nil and curGem.TotalStat.Attack ~= 0 then
		view.curGemPorpertyLab.text = Localization.Attack .. ":"
		view.curGemPorpertyNum.text = "+" .. curGem.TotalStat.Attack
	elseif curGem.TotalStat.Defense ~= nil and curGem.TotalStat.Defense ~= 0 then
		view.curGemPorpertyLab.text = Localization.Defense .. ":"
		view.curGemPorpertyNum.text = "+" .. curGem.TotalStat.Defense
	elseif curGem.TotalStat.Strength ~= nil and curGem.TotalStat.Strength ~= 0 then
		view.curGemPorpertyLab.text = Localization.Strength .. ":"
		view.curGemPorpertyNum.text = "+" .. curGem.TotalStat.Strength
	elseif curGem.TotalStat.Dexterity ~= nil and curGem.TotalStat.Dexterity ~= 0 then
		view.curGemPorpertyLab.text = Localization.Dexterity .. ":"
		view.curGemPorpertyNum.text = "+" .. curGem.TotalStat.Dexterity
	elseif curGem.TotalStat.SoldierCapcity ~= nil and curGem.TotalStat.SoldierCapcity ~= 0 then
		view.curGemPorpertyLab.text = Localization.SoldierCapcity .. ":"
		view.curGemPorpertyNum.text = "+" .. curGem.TotalStat.SoldierCapcity
	end
	if 0 == curGem.NextLevel then
		view.Level_C.selectedIndex = 1
		view.ComposeBtn.onClick:Set(function()
			UIManager.showTip({ content = Localization.GemLevelMax, result = false })
		end)
	else
		view.Level_C.selectedIndex = 0
		view.nexLevelLab.text = string.format(Localization.GemLevel, curGem.Level + 1)
		local nexcurGem = GemDataConfig:getConfigById(curGem.NextLevel)
		if nexcurGem.TotalStat.Attack ~= nil and nexcurGem.TotalStat.Attack ~= 0 then
			view.nexGemPorpertyLab.text = Localization.Attack .. ":"
			view.nexGemPorpertyNum.text = "+" .. nexcurGem.TotalStat.Attack
		elseif nexcurGem.TotalStat.Defense ~= nil and nexcurGem.TotalStat.Defense ~= 0 then
			view.nexGemPorpertyLab.text = Localization.Defense .. ":"
			view.nexGemPorpertyNum.text = "+" .. nexcurGem.TotalStat.Defense
		elseif nexcurGem.TotalStat.Strength ~= nil and nexcurGem.TotalStat.Strength ~= 0 then
			view.nexGemPorpertyLab.text = Localization.Strength .. ":"
			view.nexGemPorpertyNum.text = "+" .. nexcurGem.TotalStat.Strength
		elseif nexcurGem.TotalStat.Dexterity ~= nil and nexcurGem.TotalStat.Dexterity ~= 0 then
			view.nexGemPorpertyLab.text = Localization.Dexterity .. ":"
			view.nexGemPorpertyNum.text = "+" .. nexcurGem.TotalStat.Dexterity
		elseif nexcurGem.TotalStat.SoldierCapcity ~= nil and nexcurGem.TotalStat.SoldierCapcity ~= 0 then
			view.nexGemPorpertyLab.text = Localization.SoldierCapcity .. ":"
			view.nexGemPorpertyNum.text = "+" .. nexcurGem.TotalStat.SoldierCapcity
		end
		view.ComposeBtn.onClick:Set(function()
			local data = {
						--PartType = partType,
						SlotType = curSlotIndex,
						curCaptain = curCaptain,
						controllerIndex = 1,
					}
		UIManager.openController(UIManager.ControllerName.GemDecoRate, data)
		end)
	end

end

local function removeSuccess()
	_C:close()
end

local function ComBineGemSucc( data )
	curGem = curCaptain.Gems[curSlotIndex]
end

function _C:onCreat()
    view = _C.View
    -- 按钮绑定
    view.BackBtn.onClick:Set( function() _C:close() end)
    view.RemoveBtn.onClick:Set( function()
    	NetworkManager.C2SUseGemProto( curCaptain.Id, curGem.Id, true, curSlotIndex )
    end)
    -- 事件监听
    Event.addListener(Event.DECORATE_OR_RELEASE_GEM_SUCCESS, removeSuccess)
    Event.addListener(Event.COMBINE_GEM_SUCCESS, ComBineGemSucc)
end

function _C:onOpen(data)
	if data ~= nil then
		curCaptain = data.OpenCaptain
		curSlotIndex = data.OpenSlotIndex
		curGem = data.OpenGem
	end
	if curGem ~= nil then
		UpdateGemInfo()
	end
end

function _C:onInteractive(isOk)
	if isOk and curGem ~= nil then
		UpdateGemInfo()
	end
end

function _C:onDestroy()
    Event.removeListener(Event.DECORATE_OR_RELEASE_GEM_SUCCESS, removeSuccess)
    Event.removeListener(Event.COMBINE_GEM_SUCCESS, ComBineGemSucc)
end