local _C = UIManager.Controller(UIManager.ControllerName.GeneralRebirthResult, UIManager.ViewName.GeneralRebirthResult)
_C.IsPopupBox = true
local view = nil

local function InitUI(data)
    -- 半身像
    view.Icon.url = data.Captain.Head
    view.Name.text = data.Captain.Name
    view.Quality.selectedIndex = data.Captain.Quality - 1
    view.RaceCom.icon = data.Captain.Race
    view.Level.text = data.Captain.Level
    -- 转生前
    view.BfGrowUpLimitNum.text = data.BfRebirthData.GrowUpLimit
    view.BfPropertyNum.text = data.BfRebirthData.Property
    view.BfGrowUpNum.text = data.BfRebirthData.GrowUp
    view.BfCommandNum.text = data.BfRebirthData.Command
    -- 转生后
    view.AfGrowUpLimitNum.text = data.AfRebirthData.GrowUpLimit
    view.AfPropertyNum.text = data.AfRebirthData.Property
    view.AfGrowUpNum.text = data.AfRebirthData.GrowUp
    view.AfCommandNum.text = data.AfRebirthData.Command
    view.RebirthTimesCom.title = Localization["RebirthLevelName" .. data.Captain.RebirthLevel]
end

function _C:onCreat()
    view = _C.View
    -- 点击底图关闭界面
    view.Background.onClick:Set( function() _C:close() end)
end

function _C:onOpen(data)
    InitUI(data)
end