local AudioManager = { }

local AudioConfig = require "Config.AudioConfig"
-- 播放背景音乐
-- <param name="name" type="string">音乐名称</param>
-- <param name="option" type="int">音乐操作选项</param>
--  public enum ControlMusic
--  {
--      Play = 1,
--      Pause,
--      UnPause,
--      Stop,
--  }

function AudioManager.initialize()
end

function AudioManager.PlaySound(name, option)
    local audiodata = AudioConfig[name]
    if (audiodata ~= nil) then
        CS.LPCFramework.AudioManager.Instance:PlayAudio(name, audiodata.audioType, audiodata.volume, audiodata.channel, option)
    else
        print("error try to play a no exist audio ,name is " .. name)
    end
end

function AudioManager.PlayAudio(name, audiotype, volume, channel, option)
    CS.LPCFramework.AudioManager.Instance:PlayAudio(name, audiotype, volume, channel, option)
end

-- 全局声效
function AudioManager.SetGlobalAudioVolume(volume)
    CS.LPCFramework.AudioManager.Instance:SetGlobalAudioVolume(volume)
end

-- 全局音乐
function AudioManager.SetGolbalMusicVolume(volume)
    CS.LPCFramework.AudioManager.Instance:SetGolbalMusicVolume(volume)
end

return AudioManager

