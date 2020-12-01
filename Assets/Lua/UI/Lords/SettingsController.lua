local _C = UIManager.Controller(UIManager.ControllerName.Settings, UIManager.ViewName.Settings)
local _CchatBrief = require(UIManager.ControllerName.ChatBrief)
table.insert(_C.SubCtrl, _CchatBrief)

local view = nil
local ins = CS.LPCFramework.LocalDataStorage.Instance

local function BackBtnOnClick()
    _C:close()
end

-- 音乐滑动条
local function MusicSliderOnChanged()
    AudioManager.SetGolbalMusicVolume(view.MusicSlider.value)

    if view.MusicSlider.value == 0 then
        view.MusicToggle.selected = true
    else
        view.MusicToggle.selected = false
    end
end

-- 音效滑动条
local function EffectSliderOnChanged()
    AudioManager.SetGlobalAudioVolume(view.EffectSlider.value)

    if view.EffectSlider.value == 0 then
        view.EffectToggle.selected = true
    else
        view.EffectToggle.selected = false
    end
end

-- 音乐滑动条拖拽结束
local function MusicSlideronDragEnd()
    ins:SaveFloat("Music", view.MusicSlider.value)

    if view.MusicSlider.value == 0 then
        ins:SaveInt("MusicEnabled", 0)
    else
        ins:SaveInt("MusicEnabled", 1)
    end
end

-- 音效滑动条拖拽结束
local function EffectSlideronDragEnd()
    ins:SaveFloat("Effect", view.EffectSlider.value)
    
    if view.EffectSlider.value == 0 then
        ins:SaveInt("EffectEnabled", 0)
    else
        ins:SaveInt("EffectEnabled", 1)
    end
end

-- 音乐开关
local function MusicToggleOnClick()
    if view.MusicToggle.selected then
        view.MusicSlider.value = 0
        AudioManager.SetGolbalMusicVolume(0)
        ins:SaveInt("MusicEnabled", 0)
    else
        view.MusicSlider.value = ins:GetFloat("Music")
        AudioManager.SetGolbalMusicVolume(ins:GetFloat("Music"))
        ins:SaveInt("MusicEnabled", 1)
    end
end

-- 音效开关
local function EffectToggleOnClick()
    if view.EffectToggle.selected then
        view.EffectSlider.value = 0
        AudioManager.SetGlobalAudioVolume(0)
        ins:SaveInt("EffectEnabled", 0)
    else
        view.EffectSlider.value = ins:GetFloat("Effect")
        AudioManager.SetGlobalAudioVolume(ins:GetFloat("Effect"))
        ins:SaveInt("EffectEnabled", 1)
    end
end

function _C:onOpen()
    -- 读取并设置一下值(jeremy看这里)(0~1的float)
    view.MusicSlider.value = ins:GetFloat("Music")
    view.EffectSlider.value = ins:GetFloat("Effect")

    -- 音乐和音效的开关
    if ins:GetInt("MusicEnabled") == 0 then
        view.MusicToggle.selected = true
        view.MusicSlider.value = 0
    else
        view.MusicToggle.selected = false
    end

    if ins:GetInt("EffectEnabled") == 0 then
        view.EffectToggle.selected = true
        view.EffectSlider.value = 0
    else
        view.EffectToggle.selected = false
    end
end

function _C:onCreat()
    view = _C.View

    -- top left
    view.BackBtn.onClick:Set(BackBtnOnClick)
    view.MusicSlider.onChanged:Set(MusicSliderOnChanged)
    view.EffectSlider.onChanged:Set(EffectSliderOnChanged)
    view.MusicSlider.onGripTouchEnd:Set(MusicSlideronDragEnd)
    view.EffectSlider.onGripTouchEnd:Set(EffectSlideronDragEnd)
    view.MusicToggle.onChanged:Set(MusicToggleOnClick)
    view.EffectToggle.onChanged:Set(EffectToggleOnClick)
end

function _C:onInteractive(isOk)
    if isOk then
        _CchatBrief:setParent(view.UI)      
    end
end
