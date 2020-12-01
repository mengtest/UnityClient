local baseData = require "Data.BaseData"
local miscData = require "Data.MiscData"
local loginData = require "Data.LoginData"
local gmData = require "Data.GMData"
local itemsData = require "Data.ItemsData"
local battleData = require "Data.BattleData"
local monarchsData = require "Data.MonarchsData"
local internalAffairsData = require "Data.InternalAffairsData"
local militaryAffairsData = require "Data.MilitaryAffairsData"
local mailData = require "Data.MailData"
local regionData = require "Data.RegionData"
local towerData = require "Data.TowerData"
local chatData = require "Data.ChatData"
local taskData = require "Data.TaskData"
local allianceData = require "Data.AllianceData"
local captainSoulData = require "Data.CaptainSoulData"
local towerBackroom = require "Data.TowerBackroomData"
local shopData = require "Data.ShopData"
local regionMilitaryInfoData = require "Data.RegionMilitaryInfoData"
local regionBaseInfoData = require "Data.RegionBaseData"
local pvp100Data = require "Data.Pvp100Data"
local rankingData = require "Data.RankingData"

local DataTrunk = { }
-- 同步完成
DataTrunk.SyncComplete = false
-- 玩家信息--
DataTrunk.PlayerInfo = {
    -- 君主信息--
    MonarchsData = monarchsData,
    -- 内政信息--
    InternalAffairsData = internalAffairsData,
    -- 军政信息--
    MilitaryAffairsData = militaryAffairsData,
    -- 战斗信息--
    BattleData = battleData,
    -- 邮件信息
    MailData = mailData,
    -- 区域信息
    RegionData = regionData,
    -- 道具信息
    ItemsData = itemsData,
    -- 千重楼信息
    TowerData = towerData,
    -- 社交信息
    ChatData = chatData,
    -- 任务信息
    TaskData = taskData,
    -- GM信息
    GMData = gmData,
    -- 联盟信息
    AllianceData = allianceData,
    -- 将魂信息
    CaptainSoulData = captainSoulData,
    -- 重楼密室
    TowerBackroom = towerBackroom,
    -- 商店信息
    ShopData = shopData,
    -- 野外军情信息
    MilitaryInfoData = regionMilitaryInfoData,
    -- 野外基地信息
    RegionBaseData = regionBaseInfoData,
    -- 百战千军
    Pvp100Data = pvp100Data,

    -- 排行榜
    RankingData = rankingData
}
function DataTrunk.clear()
    monarchsData:clear()
    internalAffairsData:clear()
    militaryAffairsData:clear()
    battleData:clear()
    mailData:clear()
    regionData:clear()
    itemsData:clear()
    towerData:clear()
    towerBackroom:clear()
    chatData:clear()
    captainSoulData:clear()
    allianceData:clear()
    taskData:clear()
    shopData:clear()
    pvp100Data:clear()

    miscData.HeartBeatTimer:pause()
    miscData.SyncTimeTimer:pause()
    DataTrunk.SyncComplete = false
end
function DataTrunk.clearConfig()
    baseData:clear()
end
-- 初始化
function DataTrunk.initialize()
    internalAffairsData:init()
end

return DataTrunk
