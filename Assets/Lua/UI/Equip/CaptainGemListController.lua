local _C = UIManager.Controller(UIManager.ControllerName.CaptainGemList, nil)
_C.view = nil
_C.parent = nil

-- 槽位个数
local slotCount = 3
-- 选择武将
local handleCaptainIns = nil
-- 选择的部位
local selectedPartType = nil

-- 背包中是否有不同类型的宝石
local function haveDifferentTypeGems(partType)
    for k, v in pairs(DataTrunk.PlayerInfo.ItemsData.Gems) do
        -- 为空判断
        if v ~= nil and v.InsId ~= nil then
            local isDiff = true
            for i = 1, slotCount do
                -- 武将槽位宝石
                local GemInfo = handleCaptainIns.Gems[GemSlotDataConfig.SlotList[partType][i].SlotIndex]
                if GemInfo ~= nil then
                    local gemType = GemInfo.GemType
                    if gemType == v.Data.GemType then
                        isDiff = false
                    end
                end
            end
            if isDiff then
                return true
            end
        end
    end
    return false
end

-- 背包中同类型宝石提供的经验值
local function bagGemsProvideNum(gemInfo)
    -- 无需升级
    if gemInfo.NextLevel == 0 or gemInfo.NextLevel == nil then
        return false
    end
    -- 背包中同类宝石转换成1级宝石数量
    local totalNum = 0
    for k, v in pairs(DataTrunk.PlayerInfo.ItemsData.Gems) do
        -- 为空判断
        if v ~= nil and v.InsId ~= nil and v.Data.GemType == gemInfo.GemType then
            if v.Data.Level == 1 then
                totalNum = totalNum + v.Amount
            elseif GemDataConfig:getConfigById(v.Data.PreLevel) ~= 0 and GemDataConfig:getConfigById(v.Data.PreLevel) ~= nil then
                -- 转换为1级宝石
                local gemConfig = GemDataConfig:getConfigById(v.Data.PreLevel)
                local gemChangeLevelnum = 1
                for i = 1,(gemConfig.Level - 1) do
                    if gemConfig.PreLevel ~= 0 then
                        gemChangeLevelnum = gemChangeLevelnum * gemConfig.UpgradeNeedCount
                        gemConfig = GemDataConfig:getConfigById(gemConfig.PreLevel)
                    end
                end
                if v.InsId == gemInfo.Id then
                    totalNum = totalNum + gemChangeLevelnum *(v.Amount + 1)
                else
                    totalNum = totalNum + gemChangeLevelnum * v.Amount
                end
            end
        end
    end
    -- 升级需要多少一级宝石
    local needLevel1Gems = 1
    for i = 1, gemInfo.Level do
        needLevel1Gems = needLevel1Gems * gemInfo.UpgradeNeedCount
        if gemInfo.PreLevel ~= 0 then
            gemInfo = GemDataConfig:getConfigById(gemInfo.PreLevel)
        end
    end
    if totalNum >= needLevel1Gems then
        return true
    else
        return false
    end
end

-- 更新部件宝石信息
local function updateGemPanelInfo()
    -- 增加属性
    local AddAttack, AddDefense, AddStrength, AddDexterity, AddSodierCapcity = 0, 0, 0, 0
    for k, v in pairs(EquipType) do
        if v ~= EquipType.None then
            -- 是否有装备
            if nil == handleCaptainIns.Equip[v] then
                view.CaptainPartGems[v].Item.Stat.selectedIndex = 3
                view.CaptainPartGems[v].Stat.selectedIndex = 0
            else
                view.CaptainPartGems[v].Stat.selectedIndex = 3
            end

            -- 宝石处理
            for m = 1, slotCount do
                -- 槽位信息
                local slotInfo = GemSlotDataConfig.SlotList[v][m]
                local slotIndex = slotInfo.SlotIndex
                -- 宝石槽位未开启
                if handleCaptainIns.Ability < slotInfo.NeedAbility then
                    view.CaptainPartGems[v].Gem[m].Stat.selectedIndex = 0
                else
                    local gemData = handleCaptainIns.Gems[slotIndex]
                    -- 槽位宝石为空
                    if handleCaptainIns.Gems[slotIndex] == nil then
                        view.CaptainPartGems[v].Gem[m].Stat.selectedIndex = 1
                    else
                        -- 累计属性加成
                        AddAttack = AddAttack + gemData.TotalStat.Attack
                        AddDefense = AddDefense + gemData.TotalStat.Defense
                        AddStrength = AddStrength + gemData.TotalStat.Strength
                        AddDexterity = AddDexterity + gemData.TotalStat.Dexterity
                        AddSodierCapcity = AddSodierCapcity + gemData.TotalStat.SoldierCapcity

                        view.CaptainPartGems[v].Gem[m].Stat.selectedIndex = 2
                        view.CaptainPartGems[v].Gem[m].Icon = gemData.Icon
                    end
                end
            end
        end
    end
    -- 显示属性
    view.PropertyGemLab.text = string.format(Localization.GemAddPorpertyDesc, AddAttack, AddDefense, AddStrength, AddDexterity, AddSodierCapcity)
end

-- 更新大槽位信息
local function updateBigSlotInfo(partType)
    for i = 1, slotCount do
        view.BigSlotList[i].onClick:Clear()
        -- 槽位信息
        local slotInfo = GemSlotDataConfig.SlotList[partType][i]
        -- 槽位Id
        local slotIndex = slotInfo.SlotIndex

        -- 槽位解锁判断
        if handleCaptainIns.Ability < slotInfo.NeedAbility then
            view.BigSlotList[i].Stat.selectedIndex = 0
            view.BigSlotList[i].OpenCondition.text = string.format(Localization.GemSlotUnlock, slotInfo.NeedAbility)
        else
            -- 获取槽位宝石
            local gemInfo = handleCaptainIns.Gems[slotIndex]
            if gemInfo ~= nil then
                view.BigSlotList[i].Icon.url = gemInfo.Icon
                -- 可升级判断
                if gemInfo.NextLevel ~= 0 and bagGemsProvideNum(gemInfo) then
                    view.BigSlotList[i].Stat.selectedIndex = 4
                else
                    view.BigSlotList[i].Stat.selectedIndex = 3
                end
                -- 点击响应
                view.BigSlotList[i].onClick:Set( function()
                    local openData =
                    {
                        OpenCaptain = handleCaptainIns,
                        OpenSlotIndex = slotIndex,
                        OpenGem = gemInfo,
                    }
                    UIManager.openController(UIManager.ControllerName.GemRemove, openData)
                end )
            else
                -- 没有可镶嵌的宝石
                if not haveDifferentTypeGems(partType) then
                    view.BigSlotList[i].Stat.selectedIndex = 2
                else
                    view.BigSlotList[i].Stat.selectedIndex = 1
                    -- 点击响应
                    view.BigSlotList[i].onClick:Set( function()
                        local data = {
                            PartType = partType,
                            SlotType = slotIndex,
                            curCaptain = handleCaptainIns,
                            controllerIndex = 0,
                        }
                        UIManager.openController(UIManager.ControllerName.GemDecoRate, data)
                    end )
                end
            end
        end
    end
end

-- 装卸宝石成功
local function updateCaptainGems(data)
    if data.captain_id ~= nil then
        handleCaptainIns = DataTrunk.PlayerInfo.MilitaryAffairsData.Captains[data.captain_id]
    end
    if handleCaptainIns ~= nil then
        updateGemPanelInfo()
        updateBigSlotInfo(selectedPartType)
    end
end

-- 槽位点击
function _C:onPartClick(partType)
    if partType ~= nil and partType > 0 and partType < 6 then
        selectedPartType = partType
    elseif nil == selectedPartType then
        selectedPartType = 1
    end

    updateBigSlotInfo(selectedPartType)
end

-- 武将点击
function _C:onGeneralClick(captainInsInfo, partType)
    print("更新宝石列表！！")
    handleCaptainIns = captainInsInfo
    -- 更新部件宝石
    updateGemPanelInfo()
end

function _C:onCreat()
    view = _C.view
    -- 槽位点击
    for k, v in pairs(EquipType) do
        if v ~= EquipType.None then
            view.CaptainPartGems[v].Item.Root.onClick:Set(
            function()
                _C:onPartClick(v)
            end )
        end
    end
    -- 一键卸下
    view.BtnRemoveGems.onClick:Set( function()
        if handleCaptainIns ~= nil then
            NetworkManager.C2SOneKeyUseGemProto(handleCaptainIns.Id, true)
        end
    end )
    -- 一键镶嵌
    view.BtnDecotate.onClick:Set( function()
        if handleCaptainIns ~= nil then
            NetworkManager.C2SOneKeyUseGemProto(handleCaptainIns.Id, false)
        end
    end )

    -- 事件监听
    Event.addListener(Event.DECORATE_OR_RELEASE_GEM_SUCCESS, updateCaptainGems)
end

function _C:onDestroy()
    Event.removeListener(Event.DECORATE_OR_RELEASE_GEM_SUCCESS, updateCaptainGems)
end

return _C