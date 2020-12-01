local _C = UIManager.SubController(UIManager.ControllerName.MainCityGM,nil)
_C.view = nil

local view = nil
-- GM命令数据
local gmData = DataTrunk.PlayerInfo.GMData.OrderList

-- 当前页签页
local currPages = 0

-- 菜单列表
local function MenuListRenderer(index, obj)
    local data = gmData[currPages].CMD[index + 1]

    if data.HasInput then
        local btn = obj:GetChild("Button_Order")
        local inputTextField = obj:GetChild("Text_Title")
        -- 描述
        btn.title = data.Desc
        -- 默认文本内容
        inputTextField.text = data.DefaultInput
        btn.onClick:Set( function()
            print(data.CMD .. " " .. inputTextField.text)
            NetworkManager.C2SGmProto(data.CMD .. " " .. inputTextField.text)
        end )
    else
        -- 描述
        obj.title = data.Desc
        obj.onClick:Set( function()
            print(data.CMD)
            NetworkManager.C2SGmProto(data.CMD)
        end )
    end
end

local function MenuListProvider(index)
    if gmData[currPages].CMD[index + 1].HasInput then
        return view.InputItem
    else
        return view.ButtonItem
    end
end

-- 页签列表
local function TabListRenderer(index, obj)
    local data = gmData[index + 1]
    obj.title = data.Tab
    obj.onClick:Set( function()
        currPages = index + 1
        view.MenuList.itemRenderer = MenuListRenderer
        view.MenuList.itemProvider = MenuListProvider
        view.MenuList.numItems = #data.CMD
    end )

end

-- 请求GM命令列表成功
-- orders:GmCmdListClass[]
local function RequestCMDListSuccess()
    if not _C.IsOpen then
        return
    end

    view.TabList.itemRenderer = TabListRenderer
    view.TabList.numItems = #gmData

    -- 默认显示第一页
    if gmData[1] ~= nil then
        currPages = 1
        view.MenuList.itemRenderer = MenuListRenderer
        view.MenuList.itemProvider = MenuListProvider
        view.MenuList.numItems = #gmData[1].CMD
    end
end

function _C:onCreat()
    view = _C.view
    
    -- 请求GM命令列表
    NetworkManager.C2SGMListCMD()

    Event.addListener(Event.GM_REQ_CMD_LIST_SUCCESS, RequestCMDListSuccess)
end

function _C:onDestroy()
    view.TabList.itemRenderer = nil
    view.MenuList.itemRenderer = nil
    view.MenuList.itemProvider = nil

    Event.removeListener(Event.GM_REQ_CMD_LIST_SUCCESS, RequestCMDListSuccess)
end

return _C