local _C = UIManager.SubController(UIManager.ControllerName.BattleGenerals, nil)
-- view
_C.view = nil
-- 武将信息
local generalInfo = { }
-- 提示框
local generalTips = nil

-- 显示武将详细信息--
local function btnToShowGeneralTips(insId)
    if generalTips == nil then
        generalTips = UIPackage.CreateObject("Library", "Label_Tips02").asCom
    end

    local property = generalInfo[insId].property
    generalInfo[insId].item:AddChild(generalTips)

    -- 位置设置
    if property.InsInfo.Camp == CampType.Attacker then
        generalTips.xy = CS.UnityEngine.Vector2(0, -140)
    else
        generalTips.xy = CS.UnityEngine.Vector2(-220, -140)
    end
    -- 武将兵力信息
    generalTips:GetChild("title").text = string.format(
    Localization.BattleCpatainTips,
    UIConfig.QualityHexColor[property.InsInfo.Captain.RaceType],
    property.InsInfo.Captain.Name,
    property.InsInfo.Captain.Level,
    property.InsInfo.Captain.SoldierLevel,
    Localization["SoliderRaceType" .. property.InsInfo.Captain.RaceType],
    tostring(property.CurSolider) .. "/" .. tostring(property.InsInfo.Captain.TotalSoldier)
    )

    generalTips.visible = true
    generalTips:GetTransition("Effect_T"):Play()
end
-- 更新武將信息
local function updateGeneralInfo(actor)
    if not _C.IsOpen then
        return
    end

    if nil == actor then
        return
    end
    local property = actor.propertyController
    -- 保存属性信息
    if generalInfo[property.InsInfo.InsId] == nil then
        generalInfo[property.InsInfo.InsId] = { }
    end
    generalInfo[property.InsInfo.InsId].property = property

    -- item武将刷新
    local item = generalInfo[property.InsInfo.InsId].item
    if item == nil then
        if property.InsInfo.Camp == CampType.Attacker then
            item = _C.view.AttackerGenerals:AddItemFromPool()
        else
            item = _C.view.DefenderGenerals:AddItemFromPool()
        end

        generalInfo[property.InsInfo.InsId].item = item
        item.asButton.onClick:Set( function() btnToShowGeneralTips(property.InsInfo.InsId) end)
    end
    item.visible = true
    item:GetController("State_C").selectedIndex = 0
    local itemGeneral = item:GetChild("Componment_general")
    itemGeneral.grayed = false
    itemGeneral:GetChild("lab_zhiye"):GetChild("icon").url = UIConfig.Race[property.Config.raceType]
    itemGeneral:GetChild("quality_bian").url = UIConfig.General.SmallQuality[property.InsInfo.Captain.Quality]
    itemGeneral:GetChild("quality_touxiang").url = property.InsInfo.Captain.Head
    print("更新武将列表！！")
end

-- 掉血--
local function updatePlayerHp(property, hurtType, damage, soliderDie)
    if not _C.IsOpen then
        return
    end

    -- 武将item
    if property.CurSolider <= 0 then
        generalInfo[property.InsInfo.InsId].item:GetChild("Componment_general").grayed = true
        generalInfo[property.InsInfo.InsId].item:GetController("State_C").selectedIndex = 1
    end
end

function _C:onCreat()
    Event.addListener(Event.BATTLE_CAPTAIN_REFRESH, updateGeneralInfo)
    Event.addListener(Event.BATTLE_DROP_OF_BLOOD, updatePlayerHp)
end
function _C:onOpen()
    _C.view.AttackerGenerals:RemoveChildrenToPool()
    _C.view.DefenderGenerals:RemoveChildrenToPool()
end
function _C:onClose()
    generalInfo = { }

    if generalTips ~= nil then
        generalTips.visible = false
    end
end

function _C:onDestroy()
    for k, v in pairs(generalInfo) do
        v.item.asButton.onClick:Clear()
    end

    Event.removeListener(Event.BATTLE_CAPTAIN_REFRESH, updateGeneralInfo)
    Event.removeListener(Event.BATTLE_DROP_OF_BLOOD, updatePlayerHp)

    generalInfo = { }
    generalTips = nil
end

return _C