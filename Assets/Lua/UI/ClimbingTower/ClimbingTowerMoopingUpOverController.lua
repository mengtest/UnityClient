local _C = UIManager.Controller(UIManager.ControllerName.ClimbingTowerMoopingUpOver, UIManager.ViewName.ClimbingTowerMoopingUpOver)
_C.IsPopupBox = true

local view = nil
-- 重楼实例化信息
local towerInsInfo = DataTrunk.PlayerInfo.TowerData
-- 参与扫荡武将
local moopingupCaptainList = nil
-- 武将列表信息
local captainListInfo = nil
-- 道具列表信息
local itemListInfo = nil
-- 武将库
local captainInsInfo = DataTrunk.PlayerInfo.MilitaryAffairsData.Captains

-- 返回
local function btnBack()
    _C:close()
end
-- item点击
local function onItemClick(item)
end
-- item渲染
local function onItemRender(index, obj)
    obj.gameObjectName = tostring(index + 1)

    local itemInfo = itemListInfo[index + 1]
    -- 刷新数据
    obj:GetController("State_C").selectedIndex = 1
    obj:GetController("Count_C").selectedIndex = 1
    obj:GetController("CornerMark_C").selectedIndex = 0

    obj:GetChild("title").text = itemInfo.Amount
    obj:GetChild("icon").url = itemInfo.Config.Icon

    -- 品质
    if itemInfo.ClassifyType == ItemClassifyType.Equip then
        obj:GetChild("quality").url = UIConfig.Item.EquipQuality[itemInfo.Config.Quality.Level]
    else
        obj:GetChild("quality").url = UIConfig.Item.DefaultQuality[itemInfo.Config.Quality]
    end
end
-- 更新武将信息
local function updateCaptainList()
    -- 武将
    view.CaptainList:RemoveChildrenToPool()
    for k, v in pairs(moopingupCaptainList) do
        local item = view.CaptainList:AddItemFromPool()

        -- 是否升级
        if v.captain.Level > v.befLevel then
            item:GetTransition("wujiang_shengji"):Play()
        else
            item:GetTransition("wujiang_shengji"):Stop()
        end

        -- 经验增加
        item:GetChild("txt_jinyan").text = string.format(Localization.Exp_1, v.exp)

        -- 经验条
        local expBar = item:GetChild("progressBar_1")
        expBar.max = CaptainLevelConfig:getConfigByLevel(v.captain.Level)
        expBar.value = v.captain.Exp

        -- 武将
        item:GetChild("txt_zi").text = v.captain.Name
        local heroCaptain = item:GetChild("img_di")
        heroCaptain:GetController("Quality_C").selectedIndex = v.captain.Quality - 1
        heroCaptain:GetChild("Text_Level").text = v.captain.Level
        heroCaptain:GetChild("Loader_Icon").url = v.captain.Head
        heroCaptain:GetChild("Label_GeneralType").icon = UIConfig.Race[v.captain.Race]

        view.CaptainList:AddChild(item)
    end
end
-- 获取扫荡信息
local function getMoopingupInfo()
    -- 扫荡结果
    local expAdd = 0
    local goods = { }
    local equips = { }
    local currencys = { }

    for k, v in pairs(towerInsInfo.LatestMoopingUp) do
        -- 经验增加
        expAdd = expAdd + v.CaptainExp
        -- 通货增加
        for k1, v1 in pairs(v.Currencys) do
            if currencys[v1.Id] ~= nil then
                currencys[v1.Id].Amount = currencys[v1.Id].Amount + v1.Amount
            else
                currencys[v1.Id] = v1
            end
        end
        -- 堆叠道具增加
        for k1, v1 in pairs(v.Goods) do
            if goods[v1.Id] ~= nil then
                goods[v1.Id].Amount = goods[v1.Id].Amount + v1.Amount
            else
                goods[v1.Id] = v1
            end
        end
        -- 装备增加
        for k1, v1 in pairs(v.Equips) do
            if equips[v1.Id] ~= nil then
                equips[v1.Id].Amount = equips[v1.Id].Amount + v1.Amount
            else
                equips[v1.Id] = v1
            end
        end
    end

    -- 武将
    for k, v in pairs(moopingupCaptainList) do
        v.exp = expAdd
    end
    updateCaptainList()

    -- 道具
    itemListInfo = { }
    for k, v in pairs(equips) do
        table.insert(itemListInfo, v)
    end
    for k, v in pairs(goods) do
        table.insert(itemListInfo, v)
    end
    for k, v in pairs(currencys) do
        table.insert(itemListInfo, v)
    end
    view.ItemList.numItems = 0
    view.ItemList.numItems = #itemListInfo

    view.EffectVictory_1:Play()
    view.EffectVictory_2:Play()
end
function _C:onCreat()
    view = _C.View

    view.BtnBack.onClick:Add(btnBack)
    view.ItemList.itemRenderer = onItemRender
    view.CaptainList.onClickItem:Add(onItemClick)
end
function _C:onOpen(data)
    moopingupCaptainList = data
    getMoopingupInfo()
end
function _C:onDestroy()
    view.BtnBack.onClick:Clear()
    view.ItemList.itemRenderer = nil
    view.CaptainList.onClickItem:Clear()
end
