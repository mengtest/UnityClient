local _C = UIManager.SubController(UIManager.ControllerName.CaptainList, nil)
_C.view = nil
_C.parent = nil

local captainsList = { }
local clickRenderId = nil
local handleCaptainIns = nil
-- 装备替换成功
local function onEquipReplaceSucceedAck(equipType)
    if not _C.IsOpen then
        return
    end
    if nil == clickRenderId then
        return
    end

    -- 更新武将槽位装备
    local captain = _C.view.CaptainList:GetChild(tostring(clickRenderId))
    if nil ~= captain then _C.view:updateGeneralInfo(captain, handleCaptainIns) end
end

-- item渲染
local function onItemRender(index, obj)
    obj.name = tostring(index)
    -- 刷新
    _C.view:updateGeneralInfo(obj, captainsList[index + 1])
end
-- item点击
local function onItemClick(item)
    local index = tonumber(item.data.name)
    -- 武将点击
    print("武将点击!!", index)
    clickRenderId = index
    handleCaptainIns = captainsList[index + 1]

    -- 外部传入的槽位
    if _C.parent.incomingInfo ~= nil and _C.parent.incomingInfo.PartType ~= nil then
        _C.parent:onGeneralClick(handleCaptainIns, _C.parent.incomingInfo.PartType)
        _C.parent.incomingInfo = nil
    else
        _C.parent:onGeneralClick(handleCaptainIns, nil)
    end
end
-- 获取武将列表
local function getCaptainList()
    clickRenderId = nil
    local id = 0
    for k, v in pairs(DataTrunk.PlayerInfo.MilitaryAffairsData.Captains) do
        id = id + 1

        captainsList[id] = v
        -- 设置初始选中
        if _C.parent.incomingInfo ~= nil and _C.parent.incomingInfo.CaptainId == v.Id then
            clickRenderId = id - 1
        end
    end
    _C.view.CaptainList.numItems = id
end

function _C:onCreat()
    _C.view.CaptainList.itemRenderer = onItemRender
    _C.view.CaptainList.onClickItem:Add(onItemClick)

    Event.addListener(Event.EQUIP_REPLACE_SUCCEED, onEquipReplaceSucceedAck)
end
function _C:onOpen(data)
    getCaptainList()
end
function _C:onShow()
    if _C.view.CaptainList.numItems <= 0 then
        return
    end

    if nil == clickRenderId then
        _C.view.CaptainList:GetChildAt(0).onClick:Call()
    else
        _C.view.CaptainList:ScrollToView(clickRenderId, false)

        -- 设置选中的武将
        local captain = _C.view.CaptainList:GetChild(tostring(clickRenderId))
        if nil ~= captain then captain.onClick:Call() end
    end
end

function _C:onDestroy()
    _C.view.CaptainList.itemRenderer = nil
    _C.view.CaptainList.onClickItem:Clear()
    Event.removeListener(Event.EQUIP_REPLACE_SUCCEED, onEquipReplaceSucceedAck)
end
return _C