local _C = UIManager.Controller(UIManager.ControllerName.GeneralRebirthPre, UIManager.ViewName.GeneralRebirthPre)
local view = nil
-- 武将数据
local captainsData = DataTrunk.PlayerInfo.MilitaryAffairsData.Captains
-- 道具数据
local itemsData = DataTrunk.PlayerInfo.ItemsData
-- 当前武将数据
local selectedCaptainData = nil
-- 当前选中的index
local selectedCaptainIndex = 0
-- 武将id
local myData = { }
-- 道具数据
local itemsInsData = DataTrunk.PlayerInfo.ItemsData
-- 改名道具
local renameItems = { }
-- 转生前数据
local bfRebirthData = { }
-- 转生后数据
local afRebirthData = { }
-- 元宝的槽位index
local yuanBaoIndex = 5

-- 更新武将id(武将更新)
local function UpdateGeneralIDList()

    -- 没有武将关闭界面
    if Utils:GetTableLength(captainsData) == 0 then
        _C:close()
        return
    end
    myData = { }
    for k, v in pairs(captainsData) do
        if v == nil then
            break
        end
        table.insert(myData, k)
    end
end

local function initMaxLevelPanel()
    -- 填充满级面板
    view.BeforeRebirth:GetChild("title").text = selectedCaptainData.Name
    view.BeforeLevel.text = selectedCaptainData.Level
    view.BeforeHead.url = selectedCaptainData.Head
    view.BeforeQuality.selectedIndex = selectedCaptainData.Quality - 2
    -- view.BfGrowLab.text = Localization.GeneralGrowUp
    view.BfGrowNum.text = selectedCaptainData.AbilityExp
    -- view.BfGrowMaxLab.text = Localization.GeneralGrowUpMax
    view.BfGrowMaxNum.text = selectedCaptainData.Ability
    view.LevelLimitLab.visible = false
    -- view.AddPropertyLab.text = Localization.GeneralProperty
    view.AddPropertyNum.text = selectedCaptainData.TotalStat.Attack + selectedCaptainData.TotalStat.Defense + selectedCaptainData.TotalStat.Strength + selectedCaptainData.TotalStat.Dexterity
    -- view.AddCommandLab.text = Localization.GeneralCommand
    view.AddCommandNum.text = selectedCaptainData.TotalStat.SoldierCapcity
    -- view.AddGrowUpLab.text = Localization.GrowUp
    view.AddGrowUpNum.text = selectedCaptainData.AbilityExp
    -- view.UI:GetChild("txt_zuigao").text = Localization.GeneralRebirthMax
end

local function onItemClick(item)
    local index = tonumber(item.data.gameObjectName)
    selectedCaptainIndex = index
    selectedCaptainData = captainsData[myData[index + 1]]
    -- 判断是否转生满级
    if selectedCaptainData.RebirthLevel >= CaptainRebirthConfig.MaxLevel then
        view.UI:GetController("State_C").selectedIndex = 1
        initMaxLevelPanel()
    else
        view.UI:GetController("State_C").selectedIndex = 0
        NetworkManager.C2SCaptainRebirthPreviewProto(selectedCaptainData.Id)
    end
end

local function onItemRender(index, obj)
    obj.gameObjectName = tostring(index)
    local itemInfo = captainsData[myData[index + 1]]
    -- 填充数据
    local levelLab = obj:GetChild("txt_gji")
    levelLab.text = itemInfo.Level
    local qualityCtrl = obj:GetController("pinzhi")
    qualityCtrl.selectedIndex = itemInfo.Quality - 2
    local headIcon = obj:GetChild("loader_wujiang")
    headIcon.url = itemInfo.Head
    local nameLable = obj:GetChild("title")
    nameLable.text = itemInfo.Name
end

local function JumpToGetItemTip(itemId)
    -- TODO THEO: 提示获得道具
end

local function JumpToGetYuanbao()
    -- TODO THEO：跳转充值
end

local function RequestUseItem(index)
    if index >= yuanBaoIndex or index <= 0 then
        return
    else
        -- TODO THEO:条件判断，道具数量，经验是否已满
        NetworkManager.C2SUseCaptainRebirthGoods(selectedCaptainData.Id, renameItems[index].itemInfo.Id, 1)
    end
end

local function onConfirmUseYuanbao()
    NetworkManager.C2SCaptainRebirthYuanbao(selectedCaptainData.Id)
end

local function WarningUseYuanbao(num)
    local data = {
        UIManager.PopupStyle.ContentYesNo,
        content = string.format(Localization.UseYuanbaoToRebirth,num),
        btnTitle = { Localization.Cancel, Localization.Confirm },
        btnFunc = onConfirmUseYuanbao,
    }
    UIManager.openController(UIManager.ControllerName.Popup, data)
end

local function RefreshRebirthItems()
    renameItems = { }
    local itemIndex = 1
    for k, v in pairs(GoodsCommonConfig.Config.CaptainRebirthGoods) do
        renameItems[itemIndex] = { }
        renameItems[itemIndex] =
        {
            myItem = itemsInsData.Default[k],
            itemInfo = v
        }
        itemIndex = itemIndex + 1
    end

    -- 道具显示
    for k, v in ipairs(renameItems) do
        view.ExpList[k].text = string.format(Localization.Exp_1, renameItems[k].itemInfo.Effect.Exp)
        if renameItems[k].myItem == nil or renameItems[k].myItem.Amount == 0 then
            view.ItemBtnList[k]:GetController("Count_C").selectedIndex = 0
            view.ItemBtnList[k]:GetController("State_C").selectedIndex = 2
            view.ItemBtnList[k]:GetChild("buweiwenzi").text = renameItems[k].itemInfo.Name
            -- 绑定按钮事件
            view.ItemBtnList[k].onClick:Set(
            function()
                local itemId = renameItems[k].itemInfo.Id
                JumpToGetItemTip(itemId)
            end
            )
        else
            if renameItems[k].myItem.Amount == 1 then
                view.ItemBtnList[k]:GetController("Count_C").selectedIndex = 0
                view.ItemBtnList[k]:GetController("State_C").selectedIndex = 1
                view.ItemBtnList[k]:GetChild("icon").url = renameItems[k].itemInfo.Icon
                view.ItemBtnList[k].onClick:Set(
                function()
                    RequestUseItem(k)
                end
                )
            else
                view.ItemBtnList[k]:GetController("Count_C").selectedIndex = 1
                view.ItemBtnList[k]:GetController("State_C").selectedIndex = 1
                view.ItemBtnList[k]:GetChild("icon").url = renameItems[k].itemInfo.Icon
                view.ItemBtnList[k].title = renameItems[k].myItem.Amount
                view.ItemBtnList[k].onClick:Set(
                function()
                    RequestUseItem(k)
                end
                )
            end
        end
    end
    -- 元宝 (根据服务器指示计算)
    local needTotalYuanbao = CaptainRebirthConfig:getConfigByLevel(selectedCaptainData.RebirthLevel + 1).Yuanbao
    local needTotalExp = CaptainRebirthConfig:getConfigByLevel(selectedCaptainData.RebirthLevel).UpgradeExp
    local curExp = selectedCaptainData.RebirthExp
    local needYuanbao = math.ceil((math.max(0, needTotalExp - curExp) * needTotalYuanbao + needTotalExp - 1) / needTotalExp)
    view.ItemBtnList[yuanBaoIndex]:GetController("Count_C").selectedIndex = 1
    view.ItemBtnList[yuanBaoIndex]:GetController("State_C").selectedIndex = 1
    view.ExpList[yuanBaoIndex].text = Localization.GeneralAddFull
    view.ItemBtnList[yuanBaoIndex]:GetChild("icon").url = UIConfig.CurrencyType.YuanBao
    view.ItemBtnList[yuanBaoIndex].title = needYuanbao .. "/" .. DataTrunk.PlayerInfo.MonarchsData.Money
    if DataTrunk.PlayerInfo.MonarchsData.Money < needYuanbao then
        view.ItemBtnList[yuanBaoIndex].onClick:Set(
        function()
            JumpToGetYuanbao()
        end
        )
    else
        view.ItemBtnList[yuanBaoIndex].onClick:Set(
        function()
            WarningUseYuanbao(needYuanbao)
        end
        )
    end

end

local function GetPreviewDataBack(data)
    -- 转生前
    view.BeforeRebirth:GetChild("title").text = selectedCaptainData.Name
    view.BeforeLevel.text = selectedCaptainData.Level
    view.BeforeHead.url = selectedCaptainData.Head
    view.BeforeQuality.selectedIndex = selectedCaptainData.Quality - 2
    -- view.BfGrowLab.text = Localization.GeneralGrowUp
    view.BfGrowNum.text = selectedCaptainData.AbilityExp
    -- view.BfGrowMaxLab.text = Localization.GeneralGrowUpMax
    view.BfGrowMaxNum.text = selectedCaptainData.Ability
    -- 转生后
    myData[selectedCaptainIndex + 1] = data.id
    selectedCaptainData.Id = data.id
    view.AfterRebirth:GetChild("title").text = data.name
    view.AfterLevel.text = 1
    view.AfterHead.url = selectedCaptainData.Head
    view.AfterQuality.selectedIndex = data.quality - 2
    view.RebirthTimes.text = Localization["RebirthLevelName" .. data.rebirth_level]
    -- view.AfGrowLab.text = Localization.GeneralGrowUpReverse
    view.AfGrowNum.text = data.ability
    -- view.AfGrowMaxLab.text = Localization.GeneralGrowUpMaxReverse
    view.AfGrowMaxNum.text = data.ability_limit
    -- view.AddPropertyLab.text = Localization.GeneralProperty
    view.AddPropertyNum.text = "+" .. data.total_stat
    -- view.AddCommandLab.text = Localization.GeneralCommand
    view.AddCommandNum.text = "+" .. data.soldier_capcity
    -- view.AddGrowUpLab.text = Localization.GrowUp
    view.AddGrowUpNum.text = "+" ..(data.ability - selectedCaptainData.Ability)
    -- 条件
    -- view.LevelLabel.text = Localization.General.Level
    view.LevelNum.text = selectedCaptainData.Level .. "/" .. CaptainRebirthConfig:getConfigByLevel(selectedCaptainData.RebirthLevel).LevelLimit
    view.LevelProgressBar:GetChild("title").text = selectedCaptainData.RebirthExp .. "/" .. CaptainRebirthConfig:getConfigByLevel(selectedCaptainData.RebirthLevel).UpgradeExp
    view.LevelProgressBar.max = CaptainRebirthConfig:getConfigByLevel(selectedCaptainData.RebirthLevel).UpgradeExp
    view.LevelProgressBar.value = selectedCaptainData.RebirthExp
    -- 等级不够显示提示文本
    if selectedCaptainData.Level < CaptainRebirthConfig:getConfigByLevel(selectedCaptainData.RebirthLevel).LevelLimit then
        view.LevelLimitLab.visible = true
        view.LevelLimitLab.text = string.format(Localization.GeneralRebirthLevelLimit, CaptainRebirthConfig:getConfigByLevel(selectedCaptainData.RebirthLevel).LevelLimit)
    else
        view.LevelLimitLab.visible = false
    end
    -- 道具显示
    RefreshRebirthItems()
    -- 数据缓存
    bfRebirthData =
    {
        GrowUp = selectedCaptainData.Ability,
        GrowUpLimit = selectedCaptainData.AbilityExp,
        -- 显示属性之和
        Property = selectedCaptainData.TotalStat.Attack + selectedCaptainData.TotalStat.Defense + selectedCaptainData.TotalStat.Strength + selectedCaptainData.TotalStat.Dexterity,
        Command = selectedCaptainData.TotalStat.SoldierCapcity,
    }
    afRebirthData =
    {
        GrowUp = data.ability,
        GrowUpLimit = data.ability_limit,
        Property = data.total_stat + bfRebirthData.Property,
        Command = data.soldier_capcity + bfRebirthData.Command,
    }
end

local function onConfirmToRebirth()
    NetworkManager.C2SCaptainRebirthProto(selectedCaptainData.Id)
end

local function RequireRebirth()
    local data = {
        UIManager.PopupStyle.ContentYesNo,
        content = Localization.GeneralConfirmToRebirth,
        btnTitle = { Localization.Cancel, Localization.Confirm },
        btnFunc = onConfirmToRebirth,
    }
    UIManager.openController(UIManager.ControllerName.Popup, data)
end

local function CaptainRebirthSuccess(data)
    selectedCaptainData.Id = data.id
    selectedCaptainData.Name = data.name
    selectedCaptainData.Quality = data.quality
    selectedCaptainData.Ability = data.ability
    selectedCaptainData.TotalStat:updateInfo(data.total_stat)
    selectedCaptainData.RebirthLevel = data.rebirth_level
    selectedCaptainData.RebirthExp = data.rebirth_exp
    -- 刷新界面
    view.GeneralList:RefreshVirtualList()
    -- 判断是否转生满级
    if selectedCaptainData.RebirthLevel >= CaptainRebirthConfig.MaxLevel then
        view.UI:GetController("State_C").selectedIndex = 1
        initMaxLevelPanel()
    else
        view.UI:GetController("State_C").selectedIndex = 0
        NetworkManager.C2SCaptainRebirthPreviewProto(selectedCaptainData.Id)
    end
    viewData =
    {
        Captain = selectedCaptainData,
        BfRebirthData = bfRebirthData,
        AfRebirthData = afRebirthData,
    }
    UIManager.openController(UIManager.ControllerName.GeneralRebirthResult, viewData)
end

local function AddRebirthExpSuccess(data)
    selectedCaptainData.RebirthExp = data.exp
    -- 显示进度条
    view.LevelProgressBar:GetChild("title").text = selectedCaptainData.RebirthExp .. "/" .. CaptainRebirthConfig:getConfigByLevel(selectedCaptainData.RebirthLevel).UpgradeExp
    view.LevelProgressBar.max = CaptainRebirthConfig:getConfigByLevel(selectedCaptainData.RebirthLevel).UpgradeExp
    view.LevelProgressBar.value = selectedCaptainData.RebirthExp
    -- 刷新道具
    RefreshRebirthItems()
end

function _C:onCreat()
    view = _C.View
    UpdateGeneralIDList()
    view.GeneralList.onClickItem:Add(onItemClick)
    view.GeneralList.itemRenderer = onItemRender
    view.GeneralList.numItems = #myData
    --    -- 刷新道具数据
    --    RefreshRenameItems()

    -- 按钮绑定
    view.BackBtn.onClick:Set( function() _C:close() end)
    view.RebirthBtn.onClick:Set(RequireRebirth)
    --    for i = 1, yuanBaoIndex do
    --        view.ItemBtnList[i].onClick:Set(
    --            function()
    --                RequestUseItem(i)
    --            end
    --        )
    --    end
    -- 事件监听
    Event.addListener(Event.GENERAL_REBIRTH_PREVIEW_SUCCESS, GetPreviewDataBack)
    Event.addListener(Event.GENERAL_REBIRTH_PREVIEW_FAIL, _C:close())
    Event.addListener(Event.GENERAL_REBIRTH_SUCCESS, CaptainRebirthSuccess)
    Event.addListener(Event.General_USE_GOODS_SUCCESS, AddRebirthExpSuccess)
    Event.addListener(Event.General_USE_YUANBAO_SUCCESS, AddRebirthExpSuccess)
end

function _C:onOpen(index)
    if #myData > 0 then
        selectedCaptainIndex = 0
        view.GeneralList:GetChildAt(selectedCaptainIndex).onClick:Call()
    end
end

function _C:onInteractive(isOk)
end

function _C:onDestroy()
    Event.removeListener(Event.GENERAL_REBIRTH_PREVIEW_SUCCESS, GetPreviewDataBack)
    Event.removeListener(Event.GENERAL_REBIRTH_PREVIEW_FAIL, _C:close())
    Event.removeListener(Event.GENERAL_REBIRTH_SUCCESS, CaptainRebirthSuccess)
    Event.removeListener(Event.General_USE_GOODS_SUCCESS, AddRebirthExpSuccess)
    Event.removeListener(Event.General_USE_YUANBAO_SUCCESS, AddRebirthExpSuccess)
end