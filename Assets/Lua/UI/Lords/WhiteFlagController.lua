local UIController = UIManager.SubController(UIManager.ControllerName.WhiteFlag)
UIController.view = nil
UIController.Id = ""

function UIController:onCreat()
    self.view.WhiteFlagUIBg.onClick:Set(self.CloseUI)
    Event.addListener(Event.WHITE_FLAG, self.UpdateWhiteFlag)
    Event.addListener(Event.WHITE_FLAG_FAIL, self.UpdateWhiteFlagFail)
end

function UIController.CloseUI()
    UIController.view.WhiteFlag_C.selectedIndex = 0
end

function UIController.UpdateWhiteFlag(data)
    UIController.view.WhiteFlag_C.selectedIndex = 1
    UIController.view.FlagAllianceName.text = data.white_flag_guild_name
    UIController.view.FlagPlayerName.text = data.white_flag_hero_name
    local startTime = data.white_flag_disappear_time - RegionCommonConfig.Config.WhiteFlagDuration
    UIController.view.FlagDataTime.text = Utils.getTimeStamp_Full(startTime)
    UIController.view.FlagExpire.text = Utils.getTimeStamp_Full(data.white_flag_disappear_time)
    
    -- TODO : 查看别人的联盟 现在功能还未完成 等待
    UIController.view.ViewHisAlliance.onClick:Set(function()
        UIManager.openController(UIManager.ControllerName.Alliance)
    end)
end

function UIController.UpdateWhiteFlagFail()
    UIController.view.Flag_C.selectedIndex = 1
    UIController.CloseUI()
end

function UIController.GetFlagDetail(id)
    UIController.Id = id
    NetworkManager.C2SWhiteFlagDetailProto(id)
end

function UIController:onDestroy()
    self.view.ViewHisAlliance.onClick:Clear()
    self.view.WhiteFlagUIBg.onClick:Clear()
    Event.removeListener(Event.WHITE_FLAG, self.UpdateWhiteFlag)
    Event.removeListener(Event.WHITE_FLAG_FAIL, self.UpdateWhiteFlagFail)
end

return UIController