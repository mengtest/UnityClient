local _V = UIManager.View()

function _V:LoadView()
    self.UI, self.PKG = UIManager.creatView("UI/Popup/Popup", "Popup", "Component_PopupWindow")

    -- main window
    local window = self.UI:GetChild("Component_Main")

    -- controller
    -- 类型控制器
    -- 0 文本
    -- 1 文本+副文本
    -- 2 居中文本(据说是断线重连的时候用)
    -- 3 标题+物品列表
    self.Style_C = window:GetController("Type_C")
    -- 按钮控制器
    -- 0 [取消] [确认]
    -- 1 [确认]
    -- 2 无按钮
    self.Btn_C = window:GetController("ButtonCount_C")

    self.Content = window:GetChild("Text_Describe")
    self.SubContent = window:GetChild("Text_SubContent")
    self.Title = window:GetChild("Text_Title")
    self.List = window:GetChild("List_Prop")
    self.LeftBtn = window:GetChild("Button_Cancel")
    self.RightBtn = window:GetChild("Button_Confirm")
    self.Input_Amount = window:GetChild("Input_Amount")
    self.BG = self.UI:GetChild("Component_BG")
end

return _V