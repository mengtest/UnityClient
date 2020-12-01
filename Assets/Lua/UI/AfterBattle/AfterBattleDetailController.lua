local _C = UIManager.Controller(UIManager.ControllerName.AfterBattleDetail, UIManager.ViewName.AfterBattleDetail)
-- view
local view = nil
-- 回放信息
local battleInfo = nil

-- 返回--
local function btnToBack()
    _C:close()
end
-- 更新武将列表
local function updateGeneralList()
    if nil == battleInfo.replayInfo then
        return
    end
    -- 生成武将
    spawner = function(list, info)
        -- 道具item
        list:RemoveChildrenToPool()
        for k, v in pairs(info) do
            local item = list:AddItemFromPool()

            -- 刷新	
            item:GetChild("Loader_Icon").url = v.Captain.Head
            item:GetChild("TextField_Name").text = v.Captain.Name
            item:GetChild("TextField_Level").text = v.Captain.Level
            -- 兵种
            item:GetChild("Component_SoldierType").icon = UIConfig.Race[v.Captain.RaceType]
            -- 总兵，活兵
            local totalSolider = v.Captain.Soldier
            local aliveSolider = 0
            if battleInfo.replayInfo.Result.AliveSolider[v.InsId] ~= nil then
                aliveSolider = battleInfo.replayInfo.Result.AliveSolider[v.InsId]
            end

            -- 统兵
            item:GetChild("TextField_SoliderTotal").text = totalSolider
            -- 死亡
            item:GetChild("TextField_SoliderDie").text = totalSolider - aliveSolider
            -- 受伤
            item:GetChild("TextField_SoliderHurt").text = "缺数据！！"

            list:AddChild(item)
        end
    end
    spawner(view.AttackerGeneralList, battleInfo.replayInfo.AttackerPlayer.TroopsList)
    spawner(view.DefenderGeneralList, battleInfo.replayInfo.DefenserPlayer.TroopsList)
end

function _C:onCreat()
    view = _C.View
    view.BtnBack.onClick:Add(btnToBack)
end

function _C:onOpen(data)
    battleInfo = data
    updateGeneralList()
end
function _C:onDestroy()
    view.BtnBack.onClick:Clear()

    itemsCache = { }
end