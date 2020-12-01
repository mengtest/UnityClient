local _C = UIManager.Controller(UIManager.ControllerName.GeneralSoulFetters, UIManager.ViewName.GeneralSoulFetters)
_C.IsPopupBox = true
local view = nil
-- 玩家将魂信息
local playerSoulData = DataTrunk.PlayerInfo.CaptainSoulData
-- 羁绊ID数据
local fettersIDList = { }

-- 判断是否已经解锁
local function isUnlockSoul( soulId )
	for _,v in pairs(playerSoulData.UnlockCaptainSouls) do
		if v == soulId then
			return true
		end
	end
	return false
end

-- 判断是否已经领取奖励
local function isCollectPrize( fetterId )
	for _,v in pairs(playerSoulData.CollectPrizeFetters) do
		if v == fetterId then
			return true
		end
	end
	return false
end

-- 判断是否已经激活
local function isActivated( fetterId )
	for _,v in pairs(playerSoulData.ActivatedFetters) do
		if v == fetterId then
			return true
		end
	end
	return false
end

-- 更新羁绊id列表
local function UpdateFettersIDList()
    -- 没有关闭界面
    if Utils:GetTableLength(CaptainSoulFettersConfig.Config) == 0 then
        _C:close()
        return
    end
    fettersIDList = { }
    for k, v in pairs(CaptainSoulFettersConfig.Config) do
        if v == nil then
            break
        end
        table.insert(fettersIDList, k)
    end
end

local function updateSoulInfo( soulInfo, obj )
	-- 填充武将信息
	local qulityName = "CaptainSoulQualityName" .. soulInfo.Quality
	local qulityLevel = "CaptainSoulLevel" .. soulInfo.Quality
	obj:GetChild("Img_Level").title = Localization.qulityLevel
	obj:GetChild("lab_Quality").title = Localization.qulityName
	obj:GetChild("Loader_SoulIcon").url = soulInfo.Icon
end

local function openCollectPrizePopup( fetterInfo, isBtnGray )
	-- 物品显示列表
	local prizeList = { } 
	if taskConfig ~= nil then
        -- 通货
        for k, v in pairs(fetterInfo.FettersPrize.Currencys) do
        	local prizeItem = 
        	{
        		icon = v.Config.Icon,
            	count = v.Amount,
        	}
        	table.insert(prizeList,prizeItem)
        end

        -- 物品
        for k, v in pairs(fetterInfo.FettersPrize.Goods) do
            local prizeItem = 
        	{
        		icon = v.Config.Icon,
            	count = v.Amount,
        	}
        	table.insert(prizeList,prizeItem)
        end
        
        -- 装备
        for k, v in pairs(fetterInfo.FettersPrize.Equips) do
            local prizeItem = 
        	{
        		icon = v.Config.Icon,
            	count = v.Amount,
        	}
        	table.insert(prizeList,prizeItem)
        end
    end
    -- 回调方法
    local function callBackFun()
    	if isBtnGray then
    		_C:close()
		else
			NetworkManager.C2SCollectFettersPrizeProto(fetterInfo.Id)
		end
    end

    -- 打开弹窗
	data = {
		        UIManager.PopupStyle.TitleListConfirm,
		        title = Localization.FettersPrize,
		        listData = prizeList,
		        btnTitle = Localization.CollectPrize,
		        grayed = isBtnGray,
		        touchable = (not isBtnGray),
		        btnFunc = callBackFun,
		    }
	UIManager.openController(UIManager.ControllerName.Popup, data)	
end

local function fettersItemRenderer( index, obj )
	obj.gameObjectName = tostring(index)
    local fetterId = fettersIDList[index + 1]
    local fetterInfo = CaptainSoulFettersConfig:getConfigById(fetterId)
    obj:GetChild("Txt_Title").text = fetterInfo.Name
    local itemList = 
    {
    	[1] = obj:GetChild("Com_SoulIcon1"),
    	[2] = obj:GetChild("Com_SoulIcon2"),
    	[3] = obj:GetChild("Com_SoulIcon3"),
    	[4] = obj:GetChild("Com_SoulIcon4"),
	}
	-- 将魂数量
	local totalSoulNum = Utils.GetTableLength(fetterInfo.Souls)
	for k,v in pairs(itemList) do
		if k > totalSoulNum then
			v.visible = false
		end
	end
	-- 填充将魂信息
	local hasAllSouls = true
	for i = 1, totalSoulNum do
		if not isUnlockSoul(fetterInfo.Souls[i]) then
			hasAllSouls = false
			itemList[i].grayed = true
		end
		local soulInfo = CaptainSoulConfig:getConfigById(fetterInfo.Souls[i])
		updateSoulInfo(soulInfo, itemList[i])
		itemList[i].onClick:Set(function()
			UIManager.openController(UIManager.ControllerName.GeneralSoulDetail, soulInfo)
		end)
	end
	-- 判断激活信息
	local activatedBtn = obj:GetChild("Com_RewardsIcon")
	local activatedBtnController = activatedBtn:GetController("Effect")
	if not hasAllSouls then
		activatedBtn.grayed = true
		if fetterInfo.FettersPrize == nil then
			activatedBtnController.selectedIndex = 3
		else 
			activatedBtnController.selectedIndex = 0
			activatedBtn.onClick:Set(function()
				openCollectPrizePopup( fetterInfo, true )
			end)
		end
	else
		activatedBtn.grayed = false
		if fetterInfo.FettersPrize == nil then			
			if isActivated(fetterInfo.Id) then
				activatedBtnController.selectedIndex = 3
			else 
				activatedBtnController.selectedIndex = 2
				activatedBtn.onClick:Set(function()
					NetworkManager.C2SActivateFettersProto(fetterInfo.Id)
				end)
			end
		else
			if isCollectPrize(fetterInfo.Id) then
				activatedBtnController.selectedIndex = 1
			else
				activatedBtnController.selectedIndex = 0
			end
			activatedBtn.onClick:Set(function()
				openCollectPrizePopup( fetterInfo, false )
			end)
		end
	end

	-- 详情
	obj:GetChild("Btn_Details").onClick:Set(function()
		data = {
        	UIManager.PopupStyle.ContentConfirm,
        	content = fetterInfo.Story,
        	btnTitle = Localization.Confirm,
        	btnFunc = function() _C:close() end
    	}
    	UIManager.openController(UIManager.ControllerName.Popup, data)
	end)
end

local function ActivatedFettersSuccess( data )
	view.FettersList:RefreshVirtualList()
end

function _C:onCreat()
    view = _C.View
    -- 按钮绑定
    view.BackBtn.onClick:Set( function() _C:close() end)
    -- 事件监听
    Event.addListener(Event.ACTIVATE_FETTER_SUCCESS, ActivatedFettersSuccess)
    Event.addListener(Event.COLLECT_FETTERS_PRIZE_SUCCESS, ActivatedFettersSuccess)
end

function _C:onOpen(index)
	UpdateFettersIDList()
	view.FettersList.itemRenderer = fettersItemRenderer
	view.FettersList.numItems = Utils.GetTableLength(CaptainSoulFettersConfig.Config)
end

function _C:onInteractive(isOk)
end

function _C:onDestroy()
    Event.removeListener(Event.ACTIVATE_FETTER_SUCCESS, ActivatedFettersSuccess)
    Event.removeListener(Event.COLLECT_FETTERS_PRIZE_SUCCESS, ActivatedFettersSuccess)
end