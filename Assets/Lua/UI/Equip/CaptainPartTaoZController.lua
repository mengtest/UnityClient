local _C = UIManager.Controller(UIManager.ControllerName.CaptainPartTaoZ, UIManager.ViewName.CaptainPartTaoZ)
_C.IsPopupBox = true

local view = nil
-- 武将实例化数据
local captainInsInfo = nil

-- 返回
local function btnBack()
    _C:close()
end
-- 更新套装信息
local function updateTaoZInfo()
    local curConfig = nil
    local nextConfig = nil
    if nil ~= captainInsInfo.EquipTaoZ then
        curConfig = captainInsInfo.EquipTaoZ
        -- 如果为空
        if nil == curConfig then
            curConfig = EquipTaozConfig:getConfigById(curConfig.EquipTaoZLv)
        else
            nextConfig = EquipTaozConfig:getConfigById(curConfig.Level + 1)
        end

        -- 当前等级刷新
        view.TaoZCurLv.text = string.format(Localization.Level_1, curConfig.Level)
        view.TaoZCurEquip.text = string.format(Localization.CaptainTaoZEquip, curConfig.EquipCount, curConfig.RefinedLevel)
        view.TaoZCurMorale.text = string.format(Localization.CaptainTaoZMorale, curConfig.Morale)
    else
        nextConfig = EquipTaozConfig:getConfigById(1)

        -- 下一等级刷新
        view.TaoZCurLv.text = string.format(Localization.Level_1, 0)
        view.TaoZCurEquip.text = string.format(Localization.CaptainTaoZEquip, 0, 0)
        view.TaoZCurMorale.text = string.format(Localization.CaptainTaoZMorale, 0)
    end

    -- 已满级
    if nil == nextConfig then
        view.TaoZStat.selectedIndex = 1
    else
        view.TaoZNextLv.text = string.format(Localization.Level_1, nextConfig.Level)
        view.TaoZNextEquip.text = string.format(Localization.CaptainTaoZEquip, nextConfig.EquipCount, nextConfig.RefinedLevel)
        view.TaoZNextMorale.text = string.format(Localization.CaptainTaoZMorale, nextConfig.Morale)

        view.TaoZStat.selectedIndex = 0
    end
end

function _C:onCreat()
    view = _C.View
    view.BtnBack.onClick:Add(btnBack)
end

function _C:onOpen(data)
    if nil == data then
        _C:close()
        return
    end

    captainInsInfo = data

    -- 添加监听
    Event.addListener(Event.STAGE_ON_TOUCH_END, btnBack)
end

function _C:onShow()
    updateTaoZInfo()
end

function _C:onClose()
    -- 移除监听
    Event.removeListener(Event.STAGE_ON_TOUCH_END, btnBack)
end
function _C:onDestroy()
    view.BtnBack.onClick:Clear()
end
