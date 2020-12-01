local _C = UIManager.Controller(UIManager.ControllerName.CreatRole, UIManager.ViewName.CreatRole)
local view = nil
local msgInputMaxLen = 14

-- 进入主城
local function toMainCity()
    if not _C.IsOpen then
        return
    end

    _C:close()
    -- 加载界面，进入主城
    LevelManager.loadScene(LevelType.MainCity)
end

-- 返回
local function btnBack()
    _C:close()
    -- 返回login
    UIManager.openController(UIManager.ControllerName.LoginMain)
end
-- 创建角色
local function btnCreatRole()
    local name = view.PlayerName.text
    -- 合法判断
    if not Utils.isLegalName(name) then
        return
    end
    -- 敏感词判断
    if Utils.isSensitiveWord(name) then
        UIManager.showTip( { content = Localization.ContainsSensitiveWords, result = false })
        return
    end
    local male =(view.SexStat.selectedIndex == 0) or false
    -- 创建角色
    NetworkManager.C2SCreateHeroProto(name, male)
end
-- 角色选择
local function btnSelectedMale()
    view.SexStat.selectedIndex = 0
    view.EffectFemale:Stop()
    view.EffectMale:Play(-1, 0, nil)
end
-- 角色选择
local function btnSelectedFemale()
    view.SexStat.selectedIndex = 1
    view.EffectMale:Stop()
    view.EffectFemale:Play(-1, 0, nil)
end
-- 角色输入框失焦时
local function nameInputFocusOut()
    -- 最大字数限制
    local name = view.PlayerName.text

    if Utils.stringLen_2(name) > msgInputMaxLen then
        name = Utils.stringSub(name, 1, msgInputMaxLen)
        view.PlayerName.text = name
    end
end
-- 随机名字
local function randomName()
    -- 设置随机种子
    math.randomseed(tostring(TimerManager.currentTime):reverse():sub(1, 6))

    getName = function()
        -- 君主拼接
        local name = Localization.Monarch
        -- 后十位拼接
        local id
        for i = 1, 10 do
            -- id = math.random(1, 2)
            -- if id == 1 then
            --    name = name .. string.char(math.random(65, 90))
            -- else
            name = name .. math.random(0, 9)
            -- end
        end
        -- 含有敏感词
        if Utils.isSensitiveWord(name) then
            return getName()
        else
            return name
        end
    end

    view.PlayerName.text = getName()
end
function _C:onCreat()
    view = _C.View
    view.BtnBack.onClick:Add(btnBack)
    view.BtnCreat.onClick:Add(btnCreatRole)
    view.BtnSelecteMale.onClick:Add(btnSelectedMale)
    view.BtnSelecteFemale.onClick:Add(btnSelectedFemale)
    view.PlayerName.onFocusOut:Add(nameInputFocusOut)

    Event.addListener(Event.CREATE_ROLE_SUCCEED, toMainCity)
end

function _C:onOpen(data)
    randomName()
    btnSelectedMale()
end

function _C:onDestroy()
    view.BtnBack.onClick:Clear()
    view.BtnCreat.onClick:Clear()
    view.BtnSelecteMale.onClick:Clear()
    view.BtnSelecteFemale.onClick:Clear()
    view.PlayerName.onFocusOut:Clear()

    Event.removeListener(Event.CREATE_ROLE_SUCCEED, toMainCity)
end
