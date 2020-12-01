local _C = UIManager.Controller(UIManager.ControllerName.Academy, UIManager.ViewName.Academy)
local _CchatBrief = require(UIManager.ControllerName.ChatBrief)
table.insert(_C.SubCtrl, _CchatBrief)

local view = nil
local upgradeTimer = nil
-- 科技点数据
local techData = nil

local function BackBtnOnClick()
    _C:close()
end

-- 更新按钮菜单数据
local function UpdateButtonMenuData()
    if not _C.IsOpen then
        return
    end

    view.MainList:RemoveChildrenToPool()

    -- techType:科技类型 v:{科技序号,{科技等级,科技数据}}
    for techType, v in pairs(TechnologyConfig.ConfigByTypeAndSequenceAndLevel) do
        local item = view.MainList:AddItemFromPool(view.MainList.defaultItem)
        -- 标题
        item:GetChild("Label_Technology").text = Localization["Academy" .. techType]
        -- 按钮列表
        local list = item:GetChild("List_Technology")
        list:RemoveChildrenToPool()

        -- techSequence:序号 j:{科技等级,科技数据}
        for techSequence, j in pairs(v) do
            local btn = list:AddItemFromPool(list.defaultItem)
            -- 玩家拥有科技
            local data = nil

            if techData[techType] == nil then
                data = nil
            else
                -- TechnologyDataClass()
                data = techData[techType][techSequence]
            end

            -- 0:可升级 1:满级 2:0级
            local level_C = btn:GetController("Level_C")

            if data == nil then
                -- 0级
                level_C.selectedIndex = 2
                -- 取一级的数据
                data = TechnologyConfig.ConfigByTypeAndSequenceAndLevel[techType][techSequence][1]
            else
                -- 等级
                btn.title = data.Level

                if TechnologyConfig:getNextLvConfigById(data.Id) == nil then
                    level_C.selectedIndex = 1
                else
                    level_C.selectedIndex = 0
                end
            end

            -- 名字
            btn:GetChild("Label_Technology").title = data.Name
            -- 图标
            btn.icon = UIConfig.Academy[data.Icon]
            -- 进入升级界面
            btn.onClick:Set( function()
                UIManager.openController(UIManager.ControllerName.UpgradeTechnology, data)
            end )
        end
    end
end

function _C:onCreat()
    view = _C.View
    -- 根据配置生成界面
    UpdateButtonMenuData()
    view.BackBtn.onClick:Set(BackBtnOnClick)
    Event.addListener(Event.TECHNOLOGY_UPGRADE, UpdateButtonMenuData)
end

function _C:onOpen()
    techData = DataTrunk.PlayerInfo.InternalAffairsData.TechnologiesInfo
    UpdateButtonMenuData()
end

function _C:onInteractive(isOk)
    if isOk then
        _CchatBrief:setParent(view.UI)
    end
end

function _C:onDestroy()
    TimerManager.disposeTimer(upgradeTimer)
    upgradeTimer = nil
    Event.removeListener(Event.TECHNOLOGY_UPGRADE, UpdateButtonMenuData)
end
