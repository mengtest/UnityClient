local _C = UIManager.SubController(UIManager.ControllerName.CaptainEquipList, nil)
_C.view = nil
_C.parent = nil

local itemInsData = DataTrunk.PlayerInfo.ItemsData
-- 缺省个数
local defaultAllNum = 20
local defaultPartNum = 8

local handleCaptainIns = nil
local handleEquipInsId = nil
local handleSlotType = nil

-- 索引0 - 5 约定，
-- 0:全部
-- 1:武器
-- 2:铠甲
-- 3:护腿
-- 4:饰品
-- 5:头盔
local equipListInfo = { [0] = { }, [1] = { }, [2] = { }, [3] = { }, [4] = { }, [5] = { } }

-- 获取并刷新装备列表
local function getEquipList()
    -- 获取
    local ids = { }
    for i = 0, 5 do
        ids[i] = 0
        equipListInfo[i] = { }
    end

    local index = 0
    for k, v in pairs(DataTrunk.PlayerInfo.ItemsData.Equips) do
        ids[0] = ids[0] + 1
        equipListInfo[0][ids[0]] = v

        index = itemInsData:getPartEquipPanelId(v.Config.Type)
        ids[index] = ids[index] + 1
        equipListInfo[index][ids[index]] = v
    end

    -- 排序
    sort = function(a, b)
        local result
        if a.RefinedLevel == b.RefinedLevel then
            if a.Config.Quality.Level == b.Config.Quality.Level then
                result = a.Config.Id > b.Config.Id
            else
                result = a.Config.Quality.Level > b.Config.Quality.Level
            end
        else
            result = a.RefinedLevel > b.RefinedLevel
        end
        return result
    end

    -- 排序
    for k, v in pairs(equipListInfo) do
        table.sort(v, sort)
    end
    -- 约定
    for i = 0, 5 do
        if i == 0 then
            if ids[i] < defaultAllNum then
                ids[i] = defaultAllNum
            end
        else
            if ids[i] < defaultPartNum then
                ids[i] = defaultPartNum
            end
        end

        -- 列表个数
        _C.view.ListEquip[i].numItems = ids[i]
        _C.view.ListEquip[i]:RefreshVirtualList()
    end
end
-- 更新装备描述
local function updateEquipDesc(textName, textDesc, equipInfo)
    -- 更新描述
    local desc = ""
    if equipInfo.TotalStat.Attack ~= 0 then
        desc = desc .. Localization.Attack .. " +" .. tostring(equipInfo.TotalStat.Attack) .. "\n"
    end
    if equipInfo.TotalStat.Defense ~= 0 then
        desc = desc .. Localization.Defense .. " +" .. tostring(equipInfo.TotalStat.Defense) .. "\n"
    end
    if equipInfo.TotalStat.Strength ~= 0 then
        desc = desc .. Localization.Strength .. " +" .. tostring(equipInfo.TotalStat.Strength) .. "\n"
    end
    if equipInfo.TotalStat.Dexterity ~= 0 then
        desc = desc .. Localization.Dexterity .. " +" .. tostring(equipInfo.TotalStat.Dexterity) .. "\n"
    end
    textDesc.text = desc
    textName.text = equipInfo.Config.Name
    textName.color = UIConfig.QualityColor[equipInfo.Config.Quality.Type]
end
-- 更新替换槽位信息
local function updateReplaceSlotInfo()
    -- 更换武将部位信息
    _C.view.SelectedEquipDesc.text = ""
    _C.view.SelectedEquipName.text = ""
    _C.view.ReplaceEquipDesc.text = ""
    _C.view.ReplaceEquipName.text = ""
    -- 全部面板不更新
    if handleSlotType ~= nil and handleSlotType ~= 0 then
        -- 部位装备
        if nil ~= handleCaptainIns and nil ~= handleCaptainIns.Equips[handleSlotType] then
            -- 更新描述
            updateEquipDesc(_C.view.SelectedEquipName, _C.view.SelectedEquipDesc, handleCaptainIns.Equips[handleSlotType])

            _C.view.BtnReplace.grayed = false
            _C.view.BtnReplace.touchable = true
        else
            -- 按钮置灰
            _C.view.BtnReplace.grayed = true
            _C.view.BtnReplace.touchable = false
        end
        -- 未选中任何装备
        _C.view.BtnReplace.title = Localization.Unwield
        handleEquipInsId = nil
    end
end
-- 取消选中
local function cancelListSelected(equipType)
    local index = itemInsData:getPartEquipPanelId(equipType)
    if index == 0 then
        -- 取消所有选中
        for k, v in pairs(_C.view.ListEquip) do
            v:SelectNone()
        end
    else
        _C.view.ListEquip[index]:SelectNone()
    end
end

-- 装备替换成功
local function onEquipReplaceSucceedAck(equipType)
    if not _C.IsOpen then
        return
    end
    -- 重新获取并刷新装备列表
    getEquipList()
    -- 更新部件信息
    updateReplaceSlotInfo()
    -- 取消选中
    cancelListSelected(handleSlotType)
end

-- 装备强化成功
local function onEquipStrengthSucceedAck(equip)
    if not _C.IsOpen then
        return
    end
    if handleSlotType ~= equip.Config.Type then
        return
    end

    -- 更新部件信息
    updateReplaceSlotInfo()
end

-- 替换装备,数据同步
local function btnToEquipReplace()
    if handleEquipInsId ~= nil then
        -- 换装备
        -- print("替换装备！", handleCaptainIns.Id, handleEquipInsId)
        NetworkManager.C2SWearEquipmentProto(handleCaptainIns.Id, handleEquipInsId, false)
    elseif handleCaptainIns.Equips[handleSlotType] ~= nil then
        -- 脱装备
        -- print("脱下装备！", handleCaptainIns.Id, handleCaptainIns.Equips[handleSlotType].InsId)
        NetworkManager.C2SWearEquipmentProto(handleCaptainIns.Id, handleCaptainIns.Equips[handleSlotType].InsId, true)
    else
        UIManager.showTip( { content = Localization.CaptainPartEmpty_2, result = false })
    end
end
-- 当滚动结束
local function onEquipListScrollEnd()
    -- 当前选中面板
    local panelId = _C.view.EquipList.scrollPane.currentPageX
    _C.view.EquipPartStat.selectedIndex = panelId
    -- 当前操作槽位
    handleSlotType = itemInsData:getPartEquipType(panelId)

    -- 取消所有选中
    cancelListSelected(-1)
    -- 更新部位信息
    updateReplaceSlotInfo()
    -- 部件槽位点击
    _C.parent:onPartClick(handleSlotType)
end
-- 当滚动进行
local function onEquipListScroll()
    _C.view.EquipSlideBar.scrollPerc = _C.view.EquipList.scrollPane.percX
end
-- 按钮切换面板
local function btnToEquipList(index)
    _C.view.EquipList:ScrollToView(index)
    onEquipListScrollEnd()
end
-- item渲染
local function onItemRender(index, obj, listInfo)
    obj.name = tostring(index)
    -- 更新
    _C.view:updateListEquipInfo(obj, listInfo[index + 1])
end
-- item点击
local function onItemClick(item, listInfo)
    local index = tonumber(item.name)
    local itemInsInfo = listInfo[index + 1]
    if nil == itemInsInfo then
        return
    end
    -- 更新选中道具
    handleEquipInsId = itemInsInfo.InsId
    if nil ~= handleCaptainIns.Equips[handleSlotType] then
        _C.view.BtnReplace.title = Localization.ReplaceEquip
    else
        _C.view.BtnReplace.title = Localization.PutOnEquip
    end

    -- 更新描述
    updateEquipDesc(_C.view.ReplaceEquipName, _C.view.ReplaceEquipDesc, itemInsInfo)

    -- 按钮激活
    _C.view.BtnReplace.grayed = false
    _C.view.BtnReplace.touchable = true
end
-- item点击
local function onAllItemClick(item)
    local index = tonumber(item.data.name)
    local itemInsInfo = equipListInfo[0][index + 1]
    if nil == itemInsInfo then
        return
    end

    -- 滚动至制定列表
    btnToEquipList(itemInsData:getPartEquipPanelId(itemInsInfo.Config.Type))

    -- 滚动至列表指定位置
    local scrollToIndex
    scrollToIndex = function(renderId, curId, list)
        -- 滚动
        list:ScrollToView(curId)
        -- 选中
        local item = list:GetChild(tostring(renderId))
        if nil ~= item then
            list.scrollPane:ScrollToView(item)
            item.onClick:Call()
        else
            scrollToIndex(renderId, curId + 2, list)
        end
    end
    -- 开始滚动
    local scrollTo
    scrollTo = function(list, listInfo, insId)
        local renderId = 0
        for k, v in pairs(listInfo) do
            -- 搜索指定装备
            if v.InsId == insId then
                scrollToIndex(renderId, 0, list)
                return
            end

            renderId = renderId + 1
        end
    end

    -- 道具类型
    local index = itemInsData:getPartEquipPanelId(itemInsInfo.Config.Type)
    if index ~= 0 then
        scrollTo(_C.view.ListEquip[index], equipListInfo[index], itemInsInfo.InsId)
    end
end
-- 武将点击
function _C:onGeneralClick(captainInsInfo, partType)
    print("更新道具列表！！")
    handleCaptainIns = captainInsInfo
    btnToEquipList(itemInsData:getPartEquipPanelId(partType))
end
function _C:onCreat()
    -- 列表
    for i = 0, 5 do
        _C.view.ListEquip[i].scrollItemToViewOnClick = false
        _C.view.BtnEquipList[i].onClick:Add( function() btnToEquipList(i) end)

        if i == 0 then
            _C.view.ListEquip[i].itemRenderer = function(index, obj) onItemRender(index, obj, equipListInfo[i]) end
            _C.view.ListEquip[i].onClickItem:Add(onAllItemClick)

        else
            _C.view.CaptainPart[i].Root.onClick:Add( function() btnToEquipList(i) end)
            _C.view.ListEquip[i].itemRenderer = function(index, obj) onItemRender(index, obj, equipListInfo[i]) end
            _C.view.ListEquip[i].onClickItem:Add( function(item) onItemClick(item.data, equipListInfo[i]) end)
        end
    end
    _C.view.EquipList.scrollItemToViewOnClick = false
    _C.view.BtnReplace.onClick:Add(btnToEquipReplace)
    _C.view.EquipList.scrollPane.onScroll:Add(onEquipListScroll)
    _C.view.EquipList.scrollPane.onScrollEnd:Add(onEquipListScrollEnd)

    Event.addListener(Event.EQUIP_REPLACE_SUCCEED, onEquipReplaceSucceedAck)
    Event.addListener(Event.EQUIP_INFO_UPDATE_COMPLETE, onEquipStrengthSucceedAck)
end

function _C:onOpen()
    getEquipList()
end

function _C:onDestroy()
    for k, v in pairs(_C.view.CaptainPart) do
        v.Root.onClick:Clear()
    end
    for k, v in pairs(_C.view.BtnEquipList) do
        v.onClick:Clear()
    end
    for k, v in pairs(_C.view.ListEquip) do
        v.itemRenderer = nil
        v.onClickItem:Clear()
    end

    _C.view.BtnReplace.onClick:Clear()
    _C.view.EquipList.scrollPane.onScroll:Clear()
    _C.view.EquipList.scrollPane.onScrollEnd:Clear()

    Event.removeListener(Event.EQUIP_REPLACE_SUCCEED, onEquipReplaceSucceedAck)
    Event.removeListener(Event.EQUIP_INFO_UPDATE_COMPLETE, onEquipStrengthSucceedAck)
end

return _C