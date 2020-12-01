-- ==============================================================================
--
-- Created: 2017-3-3
-- Author: Panda
-- Company: LightPaw
--
-- ==============================================================================

-- import xxxx

----------------------------------------------------------
-- 载入通用模块代码，保存为全局表，供其他脚本访问
----------------------------------------------------------
Class = require 'Common.Class'
Utils = require 'Common.Utils'
Event = require 'Event.Event'

DataTrunk = require "Data.DataTrunk"
NetworkManager = require "Manager.NetworkManager"
TimerManager = require "Manager.TimerManager"
LevelManager = require "Manager.LevelManager"
UIManager = require "Manager.UIManager"
ConfigManager = require "Manager.ConfigManager"
GameObjectManager = require "Manager.GameObjectManager"
AudioManager = require "Manager.AudioManager"

----------------------------------------------------------
-- 主逻辑
----------------------------------------------------------

GameManager = { }

-- 初始化
function GameManager:init()
    print('Hello World', '你看见我多少次，说明我重启了多少次~~~~')

    NetworkManager.initialize()
    UIManager.initialize()
    TimerManager.initialize()
    LevelManager.initialize()
    AudioManager.initialize()
    -- 播放BGM
    AudioManager.PlaySound('BGM_Login', 1)
end

-- 更新
function GameManager:update(deltaTime)
    TimerManager.update()
    LevelManager.update()
    UIManager.update()
end

-- 固定更新
function GameManager:fixedUpdate()
    TimerManager.fixedUpdate()
end

-- 销毁
function GameManager:onDestroy()
    UIManager.onDestroy()
    GameObjectManager.onDestroy()
    Event.clearAll()
end