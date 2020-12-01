local _C = UIManager.Controller(UIManager.ControllerName.EquipmentForge, UIManager.ViewName.EquipmentForge)

_C.selectEquipIndex = nil
_C.smithyForgeInfo = nil
_C.startRecoveryTime = nil
_C.selectedEquipCount = 0
_C.forgeRemainCount = 0
_C.equipInfo = { }

function _C:onCreat()
	_C.InitUIEvent()
end

function _C.InitUIEvent()
    _C.View.BtnReturn.onClick:Set( function() _C:close() end)
    _C.View.BtnEquipment.onClick:Set(_C.OpenEquipUI)
    _C.View.BtnMelt.onClick:Set( function() UIManager.openController(UIManager.ControllerName.Smithy) end)
    _C.View.BtnForge.onClick:Set(_C.SendForgeRequest)
    _C.View.BtnForgeOneKey.onClick:Set(_C.SendForgeOneKeyRequest)

    if _C.View.EquipItems ~= nil then
        for i, v in pairs(_C.View.EquipItems) do
            if v ~= nil then
                v.onClick:Set( function() _C.OnEquipItemClick(i) end)
            end
        end
    end
	
	Event.addListener(Event.SMITHY_FORGE_SUCCESS, _C.OnForgeSuccess)
end

function _C.InitData()
	_C.View.EquipInfo_C.selectedIndex = 1
	local SmithyInfo = DataTrunk.PlayerInfo.InternalAffairsData.BuildingsInfo[BuildingType.Smithy]
	if SmithyInfo ~= nil then
		_C.smithyForgeInfo = SmithyForgeConfig:getConfigByLevel(SmithyInfo.Level)
	end
	
	for i, v in ipairs(_C.smithyForgeInfo.EquipForge) do
        local data = { }
		data.Equip = EquipsConfig:getConfigById(v)
		data.isLock = false
		data.unLockLevel = 0
		data.sort = _C.smithyForgeInfo.EquipForgePos[i] + 1
		table.insert(_C.equipInfo, data)
	end
	
	for i, v in ipairs(_C.smithyForgeInfo.EquipLocked) do
        local data = { }
		data.Equip = EquipsConfig:getConfigById(v)
		data.isLock = true
		data.unLockLevel = _C.smithyForgeInfo.LockLevel[i]
		data.sort = _C.smithyForgeInfo.EquipLockedPos[i] + 1
		table.insert(_C.equipInfo, data)
	end
	
	table.sort(_C.equipInfo, function(data1, data2)
		return data1.sort < data2.sort
    end )
end

function _C.OpenEquipUI()
	-- 武将个数判断
	if #DataTrunk.PlayerInfo.MilitaryAffairsData.Captains > 0 then
		UIManager.openController(UIManager.ControllerName.CaptainEquipMain)
	else
        UIManager.showTip( { content = Localization.CaptainNumZero, result = false })
	end
end

function _C.SendForgeRequest()
	if _C:Check() == false then
		return
	end
	
	NetworkManager.C2SForgingEquip(_C.selectEquipIndex, 1)
end

function _C.SendForgeOneKeyRequest()
	if _C:Check() == false then
		return
	end
	
	NetworkManager.C2SForgingEquip(_C.selectEquipIndex, _C.forgeRemainCount)
end

function _C:Check()
	if _C.selectEquipIndex == nil then
        UIManager.showTip( { content = Localization.SelectEquipFist, result = false })
		return false
	end
	if _C.equipInfo[_C.selectEquipIndex + 1].isLock then
        UIManager.showTip( { content = string.format(Localization.ForgeUnlockCondition, _C.equipInfo[_C.selectEquipIndex + 1].unLockLevel), result = false })
		return false
	end
	if _C.forgeRemainCount <= 0 then
        UIManager.showTip( { content = Localization.ForgeCountNotEnough, result = false })
		return false
	end
	return true
end

function _C:onOpen()
	self.InitData()
	self.SetOneKeyVisible()
	self.SetForgeEquipState()
end

function _C.SetForgeEquipState()
	for i, v in ipairs(_C.equipInfo) do
		if v ~= nil then
			_C.View.EquipItems[i].selected = false
			_C.View.EquipItems[i]:GetChild("Loader_EquipmentIcon").icon = v.Equip.Icon
			if v.isLock then
				_C.View.EquipItems[i]:GetController("Quality_C").selectedIndex = 0
			else
				_C.View.EquipItems[i]:GetController("Quality_C").selectedIndex = v.Equip.Quality.Level
			end
		end
	end
end

function _C:onUpdate()
	startRecoveryTime = DataTrunk.PlayerInfo.InternalAffairsData.SmithyForgeRecoveryTime
	local count = math.floor((TimerManager.currentTime - startRecoveryTime) / _C.smithyForgeInfo.ForgeRecoveryDur)
	_C.forgeRemainCount = math.min(count, _C.smithyForgeInfo.MaxForgeTimes)
	_C.View.ForgeRemain.text = string.format(Localization.ForgeRemainCount, _C.forgeRemainCount)
	if count <= 0 then
		_C.View.BtnForgeItem_C.selectedIndex = 0
		_C.View.BtnForgeGray_C.selectedIndex = 1
		_C.View.ForgeCdVisible_C.selectedIndex = 1
		_C.View.ForgeCD.text = tostring(Utils.secondConversion(math.floor(startRecoveryTime + _C.smithyForgeInfo.ForgeRecoveryDur - TimerManager.currentTime)))
	elseif count < _C.smithyForgeInfo.MaxForgeTimes then
		_C.View.BtnForgeItem_C.selectedIndex = 0
		_C.View.BtnForgeGray_C.selectedIndex = 0
		_C.View.ForgeCdVisible_C.selectedIndex = 0
	else
		_C.View.BtnForgeItem_C.selectedIndex = 1
		_C.View.BtnForgeGray_C.selectedIndex = 0
		_C.View.ForgeCdVisible_C.selectedIndex = 0
	end
end

function _C:onClose()
	_C.selectEquipIndex = nil
	_C.smithyForgeInfo = nil
	_C.startRecoveryTime = nil
	_C.selectedEquipCount = 0
	_C.forgeRemainCount = 0
	_C.equipInfo = { }
	_C.lockInfo = { }
end

function _C:onDestroy()
    _C.View.BtnReturn.onClick:Clear()
    _C.View.BtnEquipment.onClick:Clear()
    _C.View.BtnMelt.onClick:Clear()
    _C.View.BtnForge.onClick:Clear()
    _C.View.BtnForgeOneKey.onClick:Clear()

    if _C.View.EquipItems ~= nil then
        for i, v in pairs(_C.View.EquipItems) do
            if v ~= nil then
                v.onClick:Clear()
            end
        end
    end
	

	Event.removeListener(Event.SMITHY_FORGE_SUCCESS, _C.OnForgeSuccess)
end

function _C.OnForgeSuccess()
	_C.SetEquipAttri(_C.selectEquipIndex + 1)
end

function _C.OnEquipItemClick(index)
	if _C.View.EquipItems[index]:GetController("Quality_C").selectedIndex == 0 then
		UIManager.showTip({content = string.format(Localization.ForgeUnlockCondition, _C.equipInfo[index].unLockLevel), result = false})
		_C.View.EquipInfo_C.selectedIndex = 1
	else
		_C.selectEquipIndex = index - 1
		_C.View.EquipInfo_C.selectedIndex = 0
		_C.SetEquipAttri(index)
	end
end

function _C.SetEquipAttri(index)
	if _C.equipInfo[index] == nil then
		return
	end
	_C.View.EquipName.text = _C.equipInfo[index].Equip.Name
	local desc = ""
	if _C.equipInfo[index].Equip.BaseStat.Attack ~= 0 then
        desc = string.format(Localization.ItemAttribute, desc, Localization.Attack, _C.equipInfo[index].Equip.BaseStat.Attack)
    end
    if _C.equipInfo[index].Equip.BaseStat.Defense ~= 0 then
		desc = string.format(Localization.ItemAttribute, desc, Localization.Defense, _C.equipInfo[index].Equip.BaseStat.Defense)
    end
    if _C.equipInfo[index].Equip.BaseStat.Strength ~= 0 then
        desc = string.format(Localization.ItemAttribute, desc, Localization.Strength, _C.equipInfo[index].Equip.BaseStat.Strength)
    end
    if _C.equipInfo[index].Equip.BaseStat.Dexterity ~= 0 then
		desc = string.format(Localization.ItemAttribute, desc, Localization.Dexterity, _C.equipInfo[index].Equip.BaseStat.Dexterity)
    end
	_C.View.EquipAttribute.text = desc

	local equipData = DataTrunk.PlayerInfo.ItemsData.Equips
	_C.selectedEquipCount = 0
	if equipData ~= nil then
		for k, v in pairs(equipData) do
			if v ~= nil and v.Config.Id == _C.equipInfo[index].Equip.Id then
				_C.selectedEquipCount = _C.selectedEquipCount + 1
			end
		end
		
		_C.View.EquipHave.text = string.format(Localization.EquipHave, _C.selectedEquipCount)
	end
end

function _C.SetOneKeyVisible()
	_C.View.BtnForgeOneKey.visible = _C.smithyForgeInfo.OneKeyFunctionOpened
end
