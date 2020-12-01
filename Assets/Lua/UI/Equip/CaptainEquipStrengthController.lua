local _C = UIManager.SubController(UIManager.ControllerName.CaptainEquipRefine, nil)
_C.view = nil
_C.parent = nil

local handleEquipType = nil
local handleCaptainIns = nil
local upgradeIcon = GoodsCommonConfig.Config.EquipUpgradeReqGood.Icon
local refineIcon = GoodsCommonConfig.Config.EquipRefinedReqGood.Icon
local itemsInsData = DataTrunk.PlayerInfo.ItemsData
local upgradeItem = nil
local refineItem = nil

-- 升级道具
local function getUpgradeCostItem()
    upgradeItem = itemsInsData.Default[GoodsCommonConfig.Config.EquipUpgradeReqGood.Id]
end
-- 强化道具
local function getRefineCostItem()
    refineItem = itemsInsData.Default[GoodsCommonConfig.Config.EquipRefinedReqGood.Id]
end

-- 获取槽位信息
local function getEquipInSlot()
    local equip = handleCaptainIns.Equips[handleEquipType]
    if nil ~= equip then
        return equip
    else
        return nil
    end
end
-- 检测是否可升级
local function checkUpgradeConsume(equipInfo)
    if nil == equipInfo then
        return false
    end
    getUpgradeCostItem()
    if nil == upgradeItem then
        return false
    else
        return equipInfo.NextLvItemCostCount <= upgradeItem.Amount
    end
end
-- 检测是否可强化
local function checkRefineConsume(equipInfo)
    if nil == equipInfo then
        return false
    end

    getRefineCostItem()
    if nil == refineItem then
        return false
    else
        return equipInfo.NextRefineLvItemCostCount <= refineItem.Amount
    end
end
-- 检测是否可全部升级
local function checkUpgradeAll()
    -- 检测如果有一个可升级，则进行升级操作
    for k, v in pairs(handleCaptainIns.Equips) do
        if checkUpgradeConsume(v) then
            _C.view.BtnEquipAllUpgardeOnce.grayed = false
            _C.view.BtnEquipAllUpgardeOnce.touchable = true
            return
        end
    end
    _C.view.BtnEquipAllUpgardeOnce.grayed = true
    _C.view.BtnEquipAllUpgardeOnce.touchable = false
end

-- 更新升级信息
local function updateUpdateInfo(equipInfo, property)
    --  升级消耗
    local curCount = 0
    local needCount = equipInfo.NextLvItemCostCount

    getUpgradeCostItem()
    if nil == upgradeItem then
        curCount = 0
    else
        curCount = upgradeItem.Amount
    end
    _C.view.EquipStengthCostIcon.url = upgradeIcon
    if needCount > curCount then
        _C.view.EquipStengthCostCount.text = string.format("%d/%s", needCount, string.format(Localization.ColorRed, tostring(curCount)))
    else
        _C.view.EquipStengthCostCount.text = string.format("%d/%d", needCount, curCount)
    end
    -- 升级提升
    for k, v in pairs(property) do
        local desc = _C.view.StrengthDescList:AddItemFromPool()
        desc:GetChild("Text_Title").text = v
        _C.view.StrengthDescList:AddChild(desc)
    end

    -- 装备等级
    _C.view.EquipStengthLv.text = equipInfo.Level
end
-- 更新强化信息
local function updateRefineInfo(equipInfo, property)
    -- 强化消耗
    local curCount = 0
    local needCount = equipInfo.NextRefineLvItemCostCount

    getRefineCostItem()
    if nil == refineItem then
        curCount = 0
    else
        curCount = refineItem.Amount
    end
    _C.view.EquipStengthCostIcon.url = refineIcon
    if needCount > curCount then
        _C.view.EquipStengthCostCount.text = string.format("%d/%s", needCount, string.format(Localization.ColorRed, tostring(curCount)))
    else
        _C.view.EquipStengthCostCount.text = string.format("%d/%d", needCount, curCount)
    end

    -- 强化提升
    for k, v in pairs(property) do
        local desc = _C.view.StrengthDescList:AddItemFromPool()
        desc:GetChild("Text_Title").text = v
        _C.view.StrengthDescList:AddChild(desc)
    end
    _C.view.EquipStengthPropertyPercentAdd.text = equipInfo.RefineStatAddPercent

    -- 强化等级
    _C.view:updateStarLv(_C.view.EquipStengthRefineLvList, equipInfo.Config.Quality.RefinedLevelLimit, equipInfo.RefinedLevel, UIConfig.Item.StarMiddleSize)

    -- 套装等级
    if nil == handleCaptainIns.EquipTaoZ then
        _C.view:updateStarLv(_C.view.EquipStengthTaoZLvList, 10, 0, UIConfig.Item.StarSmallSize)
        _C.view.GeneralMorale.text = 0

    else
        _C.view:updateStarLv(_C.view.EquipStengthTaoZLvList, 10, handleCaptainIns.EquipTaoZ.Level, UIConfig.Item.StarSmallSize)
        _C.view.GeneralMorale.text = handleCaptainIns.EquipTaoZ.Morale
    end
end
-- 更新装备信息
local function updateEquipDetailInfo()
    -- 槽位类型
    handleEquipType = itemsInsData:getPartEquipType(_C.view.EquipStrengthSelectStat.selectedIndex + 1)
    local equipInfo = getEquipInSlot()

    -- 按钮状态
    btnUpgradeState = function(bool)
        _C.view.BtnEquipUpgardeOnce.grayed = not bool
        _C.view.BtnEquipUpgardeTen.grayed = not bool
        _C.view.BtnEquipUpgardeOnce.touchable = bool
        _C.view.BtnEquipUpgardeTen.touchable = bool
    end
    -- 按钮状态
    btnRefineState = function(bool)
        _C.view.BtnEquipRefine.grayed = not bool
        _C.view.BtnEquipRefine.touchable = bool
    end

    btnUpgradeState(false)
    btnRefineState(false)

    if nil == equipInfo then
        _C.view.EquipEmptyStat.selectedIndex = 1
        _C.view:updateStarLv(_C.view.EquipStengthTaoZLvList, 10, 0, UIConfig.Item.StarSmallSize)
    else
        _C.view.EquipEmptyStat.selectedIndex = 0
        -- 可升级
        if checkUpgradeConsume(equipInfo) then
            btnUpgradeState(true)
        end
        -- 可强化
        if checkRefineConsume(equipInfo) then
            btnRefineState(true)
        end

        _C.view.EquipStengthName.text = equipInfo.Config.Name

        -- 属性提升
        local id = 0
        local upgradeAdd, refineAdd = { }, { }
        if equipInfo.TotalStat.Attack ~= 0 then
            id = id + 1

            upgradeAdd[id] = string.format(Localization.EquipProperty, Localization.Attack, equipInfo.TotalStat.Attack, equipInfo.NextLvStatAdd.Attack)
            refineAdd[id] = string.format(Localization.EquipProperty, Localization.Attack, equipInfo.TotalStat.Attack, equipInfo.NextRefineLvStatAdd.Attack)
        end
        if equipInfo.TotalStat.Defense ~= 0 then
            id = id + 1

            upgradeAdd[id] = string.format(Localization.EquipProperty, Localization.Defense, equipInfo.TotalStat.Defense, equipInfo.NextLvStatAdd.Defense)
            refineAdd[id] = string.format(Localization.EquipProperty, Localization.Defense, equipInfo.TotalStat.Defense, equipInfo.NextRefineLvStatAdd.Defense)
        end
        if equipInfo.TotalStat.Strength ~= 0 then
            id = id + 1

            upgradeAdd[id] = string.format(Localization.EquipProperty, Localization.Strength, equipInfo.TotalStat.Strength, equipInfo.NextLvStatAdd.Strength)
            refineAdd[id] = string.format(Localization.EquipProperty, Localization.Strength, equipInfo.TotalStat.Strength, equipInfo.NextRefineLvStatAdd.Strength)
        end
        if equipInfo.TotalStat.Dexterity ~= 0 then
            id = id + 1

            upgradeAdd[id] = string.format(Localization.EquipProperty, Localization.Dexterity, equipInfo.TotalStat.Dexterity, equipInfo.NextLvStatAdd.Dexterity)
            refineAdd[id] = string.format(Localization.EquipProperty, Localization.Dexterity, equipInfo.TotalStat.Dexterity, equipInfo.NextRefineLvStatAdd.Dexterity)
        end

        -- 刷新list
        _C.view.StrengthDescList:RemoveChildrenToPool()
        if _C.view.EquipStrengthStat.selectedIndex == 0 then
            updateUpdateInfo(equipInfo, upgradeAdd)
        else
            updateRefineInfo(equipInfo, refineAdd)
        end
    end
end
-- 更新所有装备信息
local function updateEquipAllInfo()
    for k, v in pairs(EquipType) do
        if v ~= EquipType.None then
            _C.view:updatePartEquipInfo(_C.view.EquipStength[itemsInsData:getPartEquipPanelId(v)], handleCaptainIns.Equips[v], Localization["EquipType" .. v])
        end
    end

    checkUpgradeAll()
    updateEquipDetailInfo()
end
-- 装备信息同步成功
local function onEquipInfoSycnAck(equipType)
    if not _C.IsOpen then
        return
    end
    -- 道具类型
    local index = itemsInsData:getPartEquipPanelId(equipType)
    if index ~= 0 then
        _C.view:updatePartEquipInfo(_C.view.EquipStength[index], handleCaptainIns.Equips[equipType], Localization["EquipType" .. equipType])
    end

    -- 装备信息
    if handleEquipType ~= nil and equipType == handleEquipType then
        updateEquipDetailInfo()
    end
    -- 是否可全部升级
    checkUpgradeAll()

    -- 特效
    -- _C.view.EffectEquipStrength:Play()
end

-- 装备信息更新
local function onEquipInfoChange(equipInfo)
    -- 更新
    local equip = handleCaptainIns:getEquipById(equipInfo.id)
    if equip == nil then
        return
    end
    equip:updateInfo(equipInfo)
    onEquipInfoSycnAck(equip.Config.Type)
    -- 信息更新完成
    Event.dispatch(Event.EQUIP_INFO_UPDATE_COMPLETE, equip)
end

-- 套装界面
local function btnTaoZ()
    UIManager.openController(UIManager.ControllerName.CaptainPartTaoZ, handleCaptainIns)
end
-- 精炼数据同步
local function btnToRefine()
    local equip = getEquipInSlot()
    NetworkManager.C2SRefinedEquipmentProto(handleCaptainIns.Id, equip.InsId)
end
-- 升级数据同步,一次
local function btnToUpgradeOnce()
    local equip = getEquipInSlot()

    NetworkManager.C2SUpgradeEquipmentProto(handleCaptainIns.Id, equip.InsId, 1)
end
-- 升级数据同步,十次
local function btnToUpgradeTen()
    local equip = getEquipInSlot()
    NetworkManager.C2SUpgradeEquipmentProto(handleCaptainIns.Id, equip.InsId, 10)
end
-- 升级数据同步,所有一次
local function btnToAllUpgradeOnce()
    NetworkManager.C2SUpgradeEquipmentAllProto(handleCaptainIns.Id)
end
-- equip选中
local function btnEquipSelected(equip)
    print("装备选中！！！")
    updateEquipDetailInfo()
end
-- 武将点击
function _C:onGeneralClick(captainInsInfo, partType)
    print("更新部件强化信息！！")
    handleCaptainIns = captainInsInfo
    if nil == captainInsInfo then
        return
    end
    -- 更新
    updateEquipAllInfo()
end
-- 槽位点击
function _C:onPartClick(partType)
    local index = itemsInsData:getPartEquipPanelId(partType)
    -- 选中
    if nil ~= partType and index ~= 0 then
        _C.view.EquipStength[index].Root.selected = true
    end
end

-- 打开面板
local function btnToEquipRefinePanel()
    _C.view.EquipStrengthStat.selectedIndex = 1
    updateEquipDetailInfo()
end
-- 打开面板
local function btnToEquipUpgradePanel()
    _C.view.EquipStrengthStat.selectedIndex = 0
    updateEquipDetailInfo()
end
function _C:onCreat()
    _C.view.BtnEquipRefine.onClick:Add(btnToRefine)
    _C.view.BtnEquipUpgardeOnce.onClick:Add(btnToUpgradeOnce)
    _C.view.BtnEquipUpgardeTen.onClick:Add(btnToUpgradeTen)
    _C.view.BtnEquipAllUpgardeOnce.onClick:Add(btnToAllUpgradeOnce)
    _C.view.BtnRefine.onClick:Add(btnToEquipRefinePanel)
    _C.view.BtnUpdate.onClick:Add(btnToEquipUpgradePanel)
    _C.view.BtnTaoZ_2.onClick:Add(btnTaoZ)
    for i = 1, 5 do
        _C.view.EquipStength[i].Root.onClick:Add( function() btnEquipSelected(_C.view.EquipStength[i]) end)
    end

    Event.addListener(Event.EQUIP_REPLACE_SUCCEED, onEquipInfoSycnAck)
    Event.addListener(Event.EQUIP_INFO_UPDATE, onEquipInfoChange)
end

function _C:onOpen()
end

function _C:onDestroy()
    _C.view.BtnEquipRefine.onClick:Clear()
    _C.view.BtnEquipUpgardeOnce.onClick:Clear()
    _C.view.BtnEquipUpgardeTen.onClick:Clear()
    _C.view.BtnEquipAllUpgardeOnce.onClick:Clear()
    _C.view.BtnRefine.onClick:Clear()
    _C.view.BtnUpdate.onClick:Clear()
    _C.view.BtnTaoZ_2.onClick:Clear()
    for i = 1, 5 do
        _C.view.EquipStength[i].Root.onClick:Clear()
    end

    Event.removeListener(Event.EQUIP_REPLACE_SUCCEED, onEquipInfoSycnAck)
    Event.removeListener(Event.EQUIP_INFO_UPDATE, onEquipInfoChange)
end

return _C