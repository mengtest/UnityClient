local _C = UIManager.Controller(UIManager.ControllerName.GemHelp, UIManager.ViewName.GemHelp)
_C.IsPopupBox = true
local view = nil
-- 类型
local selectedType = nil
-- 显示列表
local ShowList = { }

local function searchSameTypeGems(typegem)
    ShowList = { }
    for k, v in ipairs(GemDataConfig.Config) do
        if GemDataConfig.Config[k].GemType == typegem then
            table.insert(ShowList, GemDataConfig.Config[k])
        end
    end
    table.sort(ShowList, function(data1, data2)
        return data1.Level > data2.Level
    end )
end

local function getGemTotalExp(gem)
    local needLevel1Gems = 1
    for i = 1, gem.Level do
        if gem.PreLevel ~= 0 then
            gem = GemDataConfig:getConfigById(gem.PreLevel)
            needLevel1Gems = needLevel1Gems * gem.UpgradeNeedCount
        end
    end
    return needLevel1Gems
end

local function onGemHelpRender(index, obj)
    obj.gameObjectName = tostring(index)
    local gemInfo = ShowList[index + 1]
    obj:GetChild("Loader_GemIcon").url = gemInfo.Icon
    obj:GetChild("Txt_PowerPoint").text = "+" .. getGemTotalExp(gemInfo)
end

function _C:onCreat()
    view = _C.View
    -- 按钮绑定
    view.BackBtn.onClick:Set( function() _C:close() end)
    -- 事件监听
    -- Event.addListener(Event.GENERAL_RENAME_CUCCESS, GeneralRenameSucc)
end

function _C:onOpen(typegem)
    selectedType = typegem
    if selectedType ~= nil then
        searchSameTypeGems(selectedType)
        view.GemList.itemRenderer = onGemHelpRender
        view.GemList.numItems = Utils.GetTableLength(ShowList)
    end
end

function _C:onInteractive(isOk)
end

function _C:onDestroy()
    -- Event.removeListener(Event.GENERAL_RENAME_CUCCESS, GeneralRenameSucc)
end