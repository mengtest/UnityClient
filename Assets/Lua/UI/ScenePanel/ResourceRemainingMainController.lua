local UIController = UIManager.Controller(UIManager.ControllerName.ResourceRemaining, UIManager.ViewName.ResourceRemaining)

local MilityListRenderer = nil

local UIController:onCreat()
    UIController.View.MilitaryList = MilityListRenderer
end

function MilityListRenderer(index, obj)
    obj:GetChild("text_qihao").text = ""
    obj:GetChild("text_junzhu").text = ""
    obj:GetChild("text_state").text = ""
    obj:GetChild("text_fuzai").text = ""
end

local UIController:onOpen()

end