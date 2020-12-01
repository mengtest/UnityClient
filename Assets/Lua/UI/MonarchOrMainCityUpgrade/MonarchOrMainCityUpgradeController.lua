local _C = UIManager.Controller(UIManager.ControllerName.MonarchOrMainCityUpgrade, UIManager.ViewName.MonarchOrMainCityUpgrade)
_C.IsPopupBox = true
local view = nil

-- typeId 0 ¾ýÖ÷,1 ³Ç³Ø
function _C:onOpen(typeId)
    if typeId == 0 or typeId == 1 then
        view.Type_C.selectedIndex = typeId
        view.Effect_T:Play( function() _C:close() end)
    end
end

function _C:onCreat()
    view = _C.View
end