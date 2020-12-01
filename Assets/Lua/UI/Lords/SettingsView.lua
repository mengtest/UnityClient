local _V = UIManager.View()

function _V:LoadView()
    self.UI, self.PKG = UIManager.creatView("UI/Lords/Lords", "Lords", "SettingMain")

    -- top left
    self.BackBtn = self.UI:GetChild("Label_BackTitle"):GetChild("Button_Back")

    -- Sound
    local soundPanel = self.UI:GetChild("Component_SoundPanel")
    self.MusicSlider = soundPanel:GetChild("Slider_Music")
    --self.MusicSlider.value = 0.5
    --self.MusicSlider.max = 1
    self.EffectSlider = soundPanel:GetChild("Slider_Effect")
    --self.EffectSlider.value = 0.5
    --self.EffectSlider.max = 1
    self.MusicToggle = soundPanel:GetChild("Button_Music")
    self.EffectToggle = soundPanel:GetChild("Button_Effect")
end

return _V