local _C = UIManager.Controller(UIManager.ControllerName.ExpeditionTarget, UIManager.ViewName.ExpeditionTarget)
local view = nil

--返回
local function btnToBack()
	_C:close()
end
--敌对
local function btnHostile()
end
--盟友
local function btnAllies()
end
--冲突
local function btnConflict()
end
--滚动
local function renderListHostileItem(index, obj)
	print("敌对", index)
end
--滚动
local function renderListAlliesItem(index, obj)
	print("盟军", index)
end
--滚动
local function renderListConflictItem(index, obj)
	print("冲突", index)
end
function _C:onCreat()
	view = _C.View
	
	view.HostileList.itemRenderer = renderListHostileItem
	view.AlliesList.itemRenderer = renderListAlliesItem
	view.ConflictList.itemRenderer = renderListConflictItem
	view.BtnBack.onClick:Add(btnToBack)
	view.BtnHostile.onClick:Add(btnHostile)
	view.BtnAllies.onClick:Add(btnAllies)
	view.BtnConflict.onClick:Add(btnConflict)
end

function _C:onOpen()
	--测试
	view.HostileList.numItems = 100
	view.AlliesList.numItems = 20
	view.ConflictList.numItems = 10
end

function _C:onDestroy()
	view.HostileList.itemRenderer = nil
	view.AlliesList.itemRenderer = nil
	view.ConflictList.itemRenderer = nil
	view.BtnBack.onClick:Clear()
	view.BtnHostile.onClick:Clear()
	view.BtnAllies.onClick:Clear()
	view.BtnConflict.onClick:Clear()
end
