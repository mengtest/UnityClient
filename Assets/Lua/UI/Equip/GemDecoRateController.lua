local _C = UIManager.Controller(UIManager.ControllerName.GemDecoRate, UIManager.ViewName.GemDecoRate)
_C.IsPopupBox = true
local view = nil
-- 玩家拥有的宝石
local playerGems = DataTrunk.PlayerInfo.ItemsData.Gems
-- 部位号
local PartType = 0
-- 槽位序号
local SlotIndex = 0
-- 武将
local handleCaptainIns = nil
-- 应该显示的宝石数据
local ShowGemsData = { }
-- 显示的宝石索引
local selectedGemIndex = 0 
-- 合成使用的列表 
local addGemsList = { }
-- 保存选中的item（自动选择使用）
local addGemsIndexList = { }
-- 现在可以达到的等级
local canGetLevel = 0
-- 增加的经验值
local AddExpTotal = 0
-- 被强化的宝石
local curGem = nil
-- 是否是在宝石镶嵌页面
local isDecoRateGemPage = true

local function isDifferenType(gem, typeList)
    -- 判断宝石是否是不同类型
    if Utils.GetTableLength(typeList) == 0 then
        return true
    end

    for i = 1, Utils.GetTableLength(typeList) do
        if gem.Data.GemType == typeList[i] then
            return false
        end
    end

    return true
end

-- 计算不同种类的宝石
local function UpdateDifferentGems(partType)
    -- 已装备的类型
    local decoratedType = { }
    for i = 1, 3 do
        local slotInfo = GemSlotDataConfig.SlotList[partType][i]
        if handleCaptainIns.Gems[slotInfo.SlotIndex] ~= nil then
            table.insert(decoratedType, handleCaptainIns.Gems[slotInfo.SlotIndex].GemType)
        end
    end

    ShowGemsData = { }
    for k, v in ipairs(playerGems) do
        if isDifferenType(v, decoratedType) then
            table.insert(ShowGemsData, v)
        end
    end
end

local function UpdateSameTypeGems(gem)
    ShowGemsData = { }
    for k, v in ipairs(playerGems) do
        if gem.GemType == v.Data.GemType then
            table.insert(ShowGemsData, v)
        end
    end
end

local function UpdateGemCom(obj, gem)
    if gem ~= nil then
        obj:GetChild("Loader_GemIcon").url = gem.Data.Icon
        obj:GetChild("Txt_Level").text = gem.Amount
    end
end

local function onGemBagItemRender(index, obj)
    obj.gameObjectName = tostring(index)
    local gemInfo = ShowGemsData[index + 1]
    obj:GetController("selectControll").selectedIndex = 0
    UpdateGemCom(obj, gemInfo)
end

local function onGemItemClick(item)
    local index = tonumber(item.data.gameObjectName)
    selectedGemIndex = index
    -- 刷新详情面板
    local selectedGem = ShowGemsData[selectedGemIndex + 1]
    UpdateGemCom(view.GemBigObj, selectedGem)
    view.GemNameLab.text = selectedGem.Data.Name
    view.GemLevelLab.text = string.format(Localization.Level_1, selectedGem.Data.Level)
    local gemData = selectedGem.Data
    if gemData.TotalStat.Attack ~= nil and gemData.TotalStat.Attack ~= 0 then
        view.GemPorpertyLab.text = Localization.Attack .. ":"
        view.GemPorpertyNum.text = "+" .. gemData.TotalStat.Attack
    elseif gemData.TotalStat.Defense ~= nil and gemData.TotalStat.Defense ~= 0 then
        view.GemPorpertyLab.text = Localization.Defense .. ":"
        view.GemPorpertyNum.text = "+" .. gemData.TotalStat.Defense
    elseif gemData.TotalStat.Strength ~= nil and gemData.TotalStat.Strength ~= 0 then
        view.GemPorpertyLab.text = Localization.Strength .. ":"
        view.GemPorpertyNum.text = "+" .. gemData.TotalStat.Strength
    elseif gemData.TotalStat.Dexterity ~= nil and gemData.TotalStat.Dexterity ~= 0 then
        view.GemPorpertyLab.text = Localization.Dexterity .. ":"
        view.GemPorpertyNum.text = "+" .. gemData.TotalStat.Dexterity
    elseif gemData.TotalStat.SoldierCapcity ~= nil and gemData.TotalStat.SoldierCapcity ~= 0 then
        view.GemPorpertyLab.text = Localization.SoldierCapcity .. ":"
        view.GemPorpertyNum.text = "+" .. gemData.TotalStat.SoldierCapcity
    end
end

local function onGemComposeBagRender(index, obj)
    obj.gameObjectName = tostring(index)
    local gemInfo = ShowGemsData[index + 1]
    if addGemsIndexList[index] ~= nil then
        obj:GetController("selectControll").selectedIndex = 1
    else
        obj:GetController("selectControll").selectedIndex = 0
    end
    UpdateGemCom(obj, gemInfo)
end

local function UpdateAddPorperty(gem, level, levelLab, porpertyLab, porpertyNum)
    levelLab.text = string.format(Localization.Level_1, level)
    local gemData = gem
    if gemData.TotalStat.Attack ~= nil and gemData.TotalStat.Attack ~= 0 then
        porpertyLab.text = Localization.Attack .. ":"
        porpertyNum.text = "+" .. gemData.TotalStat.Attack
    elseif gemData.TotalStat.Defense ~= nil and gemData.TotalStat.Defense ~= 0 then
        porpertyLab.text = Localization.Defense .. ":"
        porpertyNum.text = "+" .. gemData.TotalStat.Defense
    elseif gemData.TotalStat.Strength ~= nil and gemData.TotalStat.Strength ~= 0 then
        porpertyLab.text = Localization.Strength .. ":"
        porpertyNum.text = "+" .. gemData.TotalStat.Strength
    elseif gemData.TotalStat.Dexterity ~= nil and gemData.TotalStat.Dexterity ~= 0 then
        porpertyLab.text = Localization.Dexterity .. ":"
        porpertyNum.text = "+" .. gemData.TotalStat.Dexterity
    elseif gemData.TotalStat.SoldierCapcity ~= nil and gemData.TotalStat.SoldierCapcity ~= 0 then
        porpertyLab.text = Localization.SoldierCapcity .. ":"
        porpertyNum.text = "+" .. gemData.TotalStat.SoldierCapcity
    end
end

local function getCurMaxLevelId()
    local maxLevel = curGem.Level
    local maxLevelId = curGem.Id
    for k, v in ipairs(ShowGemsData) do
        if v.Data.Level > maxLevel then
            maxLevel = v.Data.Level
            maxLevelId = v.InsId
        end
    end
    return maxLevelId
end

-- 背包中同类型宝石提供的经验值
local function bagGemsProvideNum(Geminfo)
    if Geminfo.NextLevel == 0 then
        return
    end
    -- 背包中同类宝石转换成1级宝石数量
    local totalNum = 0
    for k, v in ipairs(DataTrunk.PlayerInfo.ItemsData.Gems) do
        if v.Data.Level == 1 then
            totalNum = totalNum + v.Amount
        elseif GemDataConfig:getConfigById(v.Data.PreLevel) ~= 0 and GemDataConfig:getConfigById(v.Data.PreLevel) ~= nil then
            local gem = GemDataConfig:getConfigById(v.Data.PreLevel)
            local gemChangeLevelnum = 1
            for i = 1,(gem.Level - 1) do
                if gem.PreLevel ~= 0 then
                    gemChangeLevelnum = gemChangeLevelnum * gem.UpgradeNeedCount
                    gem = GemDataConfig:getConfigById(gem.PreLevel)
                end
            end
            if v.InsId == Geminfo.Id then
                totalNum = totalNum + gemChangeLevelnum *(v.Amount + 1)
            elseif v.Amount > 0 then
                totalNum = totalNum + gemChangeLevelnum * v.Amount
            end
        end
    end
    -- 升级需要多少一级宝石
    local needLevel1Gems = 1
    for i = 1, Geminfo.Level do
        needLevel1Gems = needLevel1Gems * Geminfo.UpgradeNeedCount
        if Geminfo.PreLevel ~= 0 then
            Geminfo = GemDataConfig:getConfigById(Geminfo.PreLevel)
        end
    end
    return needLevel1Gems, totalNum
end

local function formatGemTypeName(gemInfo)
    local str = nil
    if gemInfo.GemType == 1 then
        str = string.format(Localization.GemNeedMoreGems, Localization.GemTypeName1)
    elseif gemInfo.GemType == 2 then
        str = string.format(Localization.GemNeedMoreGems, Localization.GemTypeName2)
    elseif gemInfo.GemType == 3 then
        str = string.format(Localization.GemNeedMoreGems, Localization.GemTypeName3)
    elseif gemInfo.GemType == 4 then
        str = string.format(Localization.GemNeedMoreGems, Localization.GemTypeName4)
    end
    return str
end

local function refreshComposeState()
    view.ReplaceGemBtn.onClick:Clear()
    if getCurMaxLevelId() ~= curGem.Id then
        view.UI:GetChild("Component_GemComponent"):GetController("c1").selectedIndex = 2
        view.ReplaceGemBtn.onClick:Set( function()
            NetworkManager.C2SUseGemProto(handleCaptainIns.Id, getCurMaxLevelId(), false, SlotIndex)
        end )
    else
        if curGem.NextLevel == 0 then
            view.UI:GetChild("Component_GemComponent"):GetController("c1").selectedIndex = 3
        else
            local needExp, totalExp = bagGemsProvideNum(curGem)
            if needExp ~= nil and totalExp ~= nil then
                if needExp > totalExp then
                    view.UI:GetChild("Component_GemComponent"):GetController("c1").selectedIndex = 1
                    view.UI:GetChild("Component_GemComponent"):GetChild("Txt_Des").text = formatGemTypeName(curGem)
                    local progressBar = view.UI:GetChild("Component_GemComponent"):GetChild("Com_Experience2")
                    progressBar.value = totalExp
                    progressBar.max = needExp
                else
                    view.UI:GetChild("Component_GemComponent"):GetController("c1").selectedIndex = 0
                    NetworkManager.C2SRequestOneKeyCombineCostProto(handleCaptainIns.Id, SlotIndex)
                end
            end
        end
    end
end

local function updateComposePanel(gem)
    view.ComposeGemIcom.url = gem.Icon
    view.ComposeGemName.text = gem.Name
    UpdateAddPorperty(gem, gem.Level, view.ComposeCurLevel, view.ComposeCurPorpertyLab, view.ComposeCurPorpertyNum)
    if gem.NextLevel ~= 0 then
        local nextLevelGem = GemDataConfig:getConfigById(gem.NextLevel)
        UpdateAddPorperty(nextLevelGem, nextLevelGem.Level, view.ComposeNexLevel, view.ComposeNexPorpertyLab, view.ComposeNexPorpertyNum)
    end
end

local function onComposeCostItemRender(index, obj)
    obj.gameObjectName = tostring(index)
    local costInfo = addGemsList[index + 1]
    local geminfo = GemDataConfig:getConfigById(costInfo.Id)
    obj:GetChild("Loader_GemIcon").url = geminfo.Icon
    obj:GetChild("Txt_Level").text = costInfo.Count
end

local function DecorateGemSucc(data)
    playerGems = DataTrunk.PlayerInfo.ItemsData.Gems
    handleCaptainIns = DataTrunk.PlayerInfo.MilitaryAffairsData.Captains[data.captain_id]
    if isDecoRateGemPage then
        _C:close()
    else
        UpdateSameTypeGems(handleCaptainIns.Gems[SlotIndex])
        view.ComposeList.itemRenderer = onGemComposeBagRender
        view.ComposeList.numItems = Utils.GetTableLength(ShowGemsData)
        -- view.ComposeList.onClickItem:Add(onComposeGemItemClick)
        curGem = handleCaptainIns.Gems[SlotIndex]
        updateComposePanel(curGem)
        refreshComposeState()
    end
end

local function RefreshCombineCost(data)
    addGemsList = { }
    if data.can_combine then
        for k, v in ipairs(data.gem_id) do
            if data.gem_count[k] > 0 then
                local useInfo =
                {
                    Id = data.gem_id[k],
                    Count = data.gem_count[k],
                }
                table.insert(addGemsList, useInfo)
            end
        end
        view.UI:GetChild("Component_GemComponent"):GetController("c1").selectedIndex = 0
        view.ComposeCostList.itemRenderer = onComposeCostItemRender
        view.ComposeCostList.numItems = Utils.GetTableLength(addGemsList)
    else
        local needExp, totalExp = bagGemsProvideNum(curGem)
        if needExp ~= nil and totalExp ~= nil then
            view.UI:GetChild("Component_GemComponent"):GetController("c1").selectedIndex = 1
            view.UI:GetChild("Component_GemComponent"):GetChild("Txt_Des").text = formatGemTypeName(curGem)
            local progressBar = view.UI:GetChild("Component_GemComponent"):GetChild("Com_Experience2")
            progressBar.value = totalExp
            progressBar.max = needExp
        end
    end
end

local function ComBineGemSucc(data)
    playerGems = DataTrunk.PlayerInfo.ItemsData.Gems
    curGem = handleCaptainIns.Gems[SlotIndex]
    canGetLevel = curGem.Level
    addGemsList = { }
    addGemsIndexList = { }
    AddExpTotal = 0
    UpdateSameTypeGems(curGem)
    view.ComposeList.itemRenderer = onGemComposeBagRender
    view.ComposeList.numItems = Utils.GetTableLength(ShowGemsData)
    updateComposePanel(curGem)
    refreshComposeState()
end

function _C:onCreat()
    view = _C.View
    -- 按钮绑定
    view.BackBtn.onClick:Set( function() _C:close() end)
    view.GemComposeBackBtn.onClick:Set( function() _C:close() end)
    view.DecoRateBtn.onClick:Set( function()
        NetworkManager.C2SUseGemProto(handleCaptainIns.Id, ShowGemsData[selectedGemIndex + 1].InsId, false, SlotIndex)
    end )
    view.ComposeBtn.onClick:Set( function()
        NetworkManager.C2SCombineGemProto(handleCaptainIns.Id, SlotIndex)
    end )
    view.GemHelpBtn.onClick:Set( function()
        if curGem ~= nil then
            UIManager.openController(UIManager.ControllerName.GemHelp, curGem.GemType)
        end
    end )
    -- 事件监听
    Event.addListener(Event.DECORATE_OR_RELEASE_GEM_SUCCESS, DecorateGemSucc)
    Event.addListener(Event.COMBINE_GEM_SUCCESS, ComBineGemSucc)
    Event.addListener(Event.REQUEST_COMBINE_COST_SUCCESS, RefreshCombineCost)
end

function _C:onOpen(data)
    if data.controllerIndex == 0 then
        isDecoRateGemPage = true
        view.UI:GetController("Tab").selectedIndex = 0
        PartType = data.PartType
        SlotIndex = data.SlotType
        handleCaptainIns = data.curCaptain
        UpdateDifferentGems(PartType)
        view.GemBagList.itemRenderer = onGemBagItemRender
        view.GemBagList.numItems = Utils.GetTableLength(ShowGemsData)
        view.GemBagList.onClickItem:Add(onGemItemClick)
        if Utils.GetTableLength(ShowGemsData) > 0 then
            selectedGemIndex = 0
            view.GemBagList:GetChildAt(selectedGemIndex).onClick:Call()
        end
    else
        isDecoRateGemPage = false
        addGemsList = { }
        addGemsIndexList = { }
        AddExpTotal = 0
        view.UI:GetController("Tab").selectedIndex = 1
        SlotIndex = data.SlotType
        handleCaptainIns = data.curCaptain
        UpdateSameTypeGems(handleCaptainIns.Gems[SlotIndex])
        view.ComposeList.itemRenderer = onGemComposeBagRender
        view.ComposeList.numItems = Utils.GetTableLength(ShowGemsData)
        -- view.ComposeList.onClickItem:Add(onComposeGemItemClick)
        curGem = handleCaptainIns.Gems[SlotIndex]
        canGetLevel = curGem.Level
        updateComposePanel(curGem)
        refreshComposeState()
    end
end

function _C:onInteractive(isOk)
end

function _C:onDestroy()
    Event.removeListener(Event.DECORATE_OR_RELEASE_GEM_SUCCESS, DecorateGemSucc)
    Event.removeListener(Event.COMBINE_GEM_SUCCESS, ComBineGemSucc)
    Event.removeListener(Event.REQUEST_COMBINE_COST_SUCCESS, RefreshCombineCost)
    view.ComposeList.itemRenderer = nil
    view.ComposeCostList.itemRenderer = nil
    view.GemBagList.itemRenderer = nil
end