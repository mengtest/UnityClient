local _C = UIManager.Controller(UIManager.ControllerName.MonarchOrMainCityUpgrade, UIManager.ViewName.MonarchOrMainCityUpgrade)
_C.IsPopupBox = true
local view = nil

-- typeId 0 ����,1 �ǳ�
function _C:onOpen(typeId)
    if typeId == 0 or typeId == 1 then
        view.Type_C.selectedIndex = typeId
        view.Effect_T:Play( function() _C:close() end)
    end
end

function _C:onCreat()
    view = _C.View
end