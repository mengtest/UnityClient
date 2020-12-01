local _C = UIManager.Controller(UIManager.ControllerName.TaskPrize, UIManager.ViewName.TaskPrize)
local view = nil

local function CloseSelf()
    _C:close()
end

-- 更新任务奖励
local function UpdatePrize(taskConfig)

    if taskConfig == nil then
        return
    end

    -- 显示奖励
    view.PrizeList:RemoveChildrenToPool()
    local prizeItem = nil

    if taskConfig ~= nil then
        -- 通货
        for k, v in pairs(taskConfig.Prize.Currencys) do
            prizeItem = view.PrizeList:AddItemFromPool()
            prizeItem.icon = v.Config.Icon
            prizeItem.title = v.Amount
            prizeItem:GetController("Count_C").selectedIndex = 1
            prizeItem:GetController("State_C").selectedIndex = 1 
        end

        -- 物品
        for k, v in pairs(taskConfig.Prize.Goods) do
            prizeItem = view.PrizeList:AddItemFromPool()
            prizeItem.icon = v.Config.Icon
            if v.Amount > 1 then
                prizeItem:GetController("Count_C").selectedIndex = 1
                prizeItem.title = v.Amount
            else
                prizeItem:GetController("Count_C").selectedIndex = 0
            end
            prizeItem:GetController("State_C").selectedIndex = 1
        end
        
        -- 装备
        for k, v in pairs(taskConfig.Prize.Equips) do
            prizeItem = view.PrizeList:AddItemFromPool()
            prizeItem.icon = v.Config.Icon

            if v.Amount > 1 then
                prizeItem:GetController("Count_C").selectedIndex = 1
                prizeItem.title = v.Amount
            else
                prizeItem:GetController("Count_C").selectedIndex = 0
            end
            prizeItem:GetController("State_C").selectedIndex = 1
        end
    end

    view.Effect:Play(CloseSelf)
end

function _C:onOpen(data)
    UpdatePrize(data)
end

function _C:onCreat()
    view = _C.View
end