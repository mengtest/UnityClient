-- DebugTool
-- 仅供开发使用，Release版本需要屏蔽！！！
-- 这里的填充文字不需要放入本地化文件中，只供开发期使用！！！

local _C = UIManager.SubController(UIManager.ControllerName.MainCityDebugTool, nil)
_C.view = nil

local OnShowNonePage
local OnShowCameraParameterPage
local OnShowSelectionPage

-- 主城Camera脚本
local mainCameraScript = nil
-- 主城Camera参数列表
local cameraParameterList = {}
-- 主城camera参数说明前缀
local cameraParameterDescPrefixList = 
{
    Gradient = "坡度\n Gradient = %s",
    ZoomFactor = "缩放系数\n Zoom Factor = %s",
    ZoomInLimit = "放大极限\n Zoom In Limit = %s",
    ZoomOutLimit = "缩小极限\n Zoom Out Limit = %s",
    FeatureCamMoveSpeed = "特写摄像机移动速度\n Feature Cam Move Speed = %s",
    MoveSpeed = "平移速度\n Move Speed = %s",
    FrontMaxDis = "向前最大距离\n Front Max Dis = %s",
    BackMaxDis = "向后最大距离\n Back Max Dis = %s",
    FrontSpringDis = "平移回弹距离-前\n Front Spring Dis = %s",
    BackSpringDis = "平移回弹距离-后\n Back Spring Dis = %s",
    FrontSpringSpeed = "回弹速度-前(向后)\n Front Spring Speed = %s",
    BackSpringSpeed = "回弹速度-后(向前)\n Back Spring Speed = %s",
    RotateSpeed = "旋转速度 Rotate\n Speed = %s",
    LeftMaxAngle = "最大旋转角度-左\n Left Max Angle = %s",
    RightMaxAngle = "最大旋转角度-右\n Right Max Angle = %s",
    LeftSpringAngle = "旋转回弹角度-左\n Left Spring Angle = %s",
    RightSpringAngle = "旋转回弹角度-右\n Right Spring Angle = %s",
    LeftSpringSpeed = "回弹速度-左(向右)\n Left Spring Speed = %s",
    RightSpringSpeed = "回弹速度-右(向左)\n Right Spring Speed = %s",
}
-- camera参数最多4套存档
local cameraParaSaveFileLimit = 4
-- 当前选择的camera参数下标，0表示默认
local currentChoosedCPIndex = 0
-- 默认的camera参数下标
local defaltCPIndex = 0
-- camera参数是否有变动
local isCameraParaterChanged = false

--****************************************************************************

local function OnCloseSelf()
    _C:close()
end

-- 显示Debug按钮，关闭其他页面
OnShowNonePage = function ()
    if not _C.IsOpen then
        return
    end

    _C.view.DTStateController.selectedIndex = 0
end

--*****************************主城摄像机参数页面*************************************

-- 深拷贝
local function DeepCopyCameraParameter(leftIndex, rightIndex)
    if leftIndex < 0 or leftIndex > cameraParaSaveFileLimit then
        return
    end

    if rightIndex < 0 or rightIndex > cameraParaSaveFileLimit then
        return
    end
    
    if cameraParameterList[rightIndex] == nil then
        return
    end

    if cameraParameterList[leftIndex] == nil then
        cameraParameterList[leftIndex] = {}
    end

    local leftTable = cameraParameterList[leftIndex]
    local rightTable = cameraParameterList[rightIndex]

    leftTable.Gradient = rightTable.Gradient
    leftTable.ZoomFactor = rightTable.ZoomFactor
    leftTable.ZoomInLimit = rightTable.ZoomInLimit
    leftTable.ZoomOutLimit = rightTable.ZoomOutLimit
    leftTable.FeatureCamMoveSpeed = rightTable.FeatureCamMoveSpeed
    leftTable.MoveSpeed = rightTable.MoveSpeed
    leftTable.FrontMaxDis = rightTable.FrontMaxDis
    leftTable.BackMaxDis = rightTable.BackMaxDis
    leftTable.FrontSpringDis = rightTable.FrontSpringDis
    leftTable.BackSpringDis = rightTable.BackSpringDis
    leftTable.FrontSpringSpeed = rightTable.FrontSpringSpeed
    leftTable.BackSpringSpeed = rightTable.BackSpringSpeed
    leftTable.RotateSpeed = rightTable.RotateSpeed
    leftTable.LeftMaxAngle = rightTable.LeftMaxAngle
    leftTable.RightMaxAngle = rightTable.RightMaxAngle
    leftTable.LeftSpringAngle = rightTable.LeftSpringAngle
    leftTable.RightSpringAngle = rightTable.RightSpringAngle
    leftTable.LeftSpringSpeed = rightTable.LeftSpringSpeed
    leftTable.RightSpringSpeed = rightTable.RightSpringSpeed
end

-- 读取主城Camera参数并保存到内存
local function ReadCameraParameterAndSaveTo(index)
    if cameraParameterList[index] == nil then
        cameraParameterList[index] = {}
    end
    
    -- 读取参数
    cameraParameterList[index].Gradient = mainCameraScript.m_gradient
    cameraParameterList[index].ZoomFactor = mainCameraScript.m_zoomFactor
    cameraParameterList[index].ZoomInLimit = mainCameraScript.m_zoomInLimit
    cameraParameterList[index].ZoomOutLimit = mainCameraScript.m_zoomOutLimit
    cameraParameterList[index].FeatureCamMoveSpeed = mainCameraScript.m_featureCamMoveSpeed
    cameraParameterList[index].MoveSpeed = mainCameraScript.m_moveSpeed
    cameraParameterList[index].FrontMaxDis = mainCameraScript.m_frontMaxDis
    cameraParameterList[index].BackMaxDis = mainCameraScript.m_backMaxDis
    cameraParameterList[index].FrontSpringDis = mainCameraScript.m_frontSpringDis
    cameraParameterList[index].BackSpringDis = mainCameraScript.m_backSpringDis
    cameraParameterList[index].FrontSpringSpeed = mainCameraScript.m_frontSpringSpeed
    cameraParameterList[index].BackSpringSpeed = mainCameraScript.m_backSpringSpeed
    cameraParameterList[index].RotateSpeed = mainCameraScript.m_rotateSpeed
    cameraParameterList[index].LeftMaxAngle = mainCameraScript.m_leftMaxAngle
    cameraParameterList[index].RightMaxAngle = mainCameraScript.m_rightMaxAngle
    cameraParameterList[index].LeftSpringAngle = mainCameraScript.m_leftSpringAngle
    cameraParameterList[index].RightSpringAngle = mainCameraScript.m_rightSpringAngle
    cameraParameterList[index].LeftSpringSpeed = mainCameraScript.m_leftSpringSpeed
    cameraParameterList[index].RightSpringSpeed = mainCameraScript.m_rightSpringSpeed
end

-- 读取主城摄像机默认参数
-- 界面创建时读取一次，后续使用OnSetDefaultCameraParameter()即可
local function OnReadCameraDefaultParameter()
    local mainCamera = CS.UnityEngine.GameObject.FindWithTag("CameraController")
    if mainCamera == nil then
        return
    end

    -- 获取Camera脚本
    mainCameraScript = mainCamera:GetComponent(typeof(CS.LPCFramework.CameraController))
    if mainCameraScript == nil then
        return
    end

    -- 读取默认参数
    ReadCameraParameterAndSaveTo(defaltCPIndex)
end

-- 读取存档文件，存入内存
local function OnReadSavedCameraParameter()
    for i=1, cameraParaSaveFileLimit do
        -- 读取存档
        for k, v in pairs(cameraParameterList[i]) do
            if type(k) == "string" then
                local key = k..i

                if not CS.LPCFramework.LocalDataStorage.Instance:HasKey(key) then
                    break;
                end

                local savedValue = CS.LPCFramework.LocalDataStorage.Instance:GetFloat(key)
                cameraParameterList[i][k] = savedValue
            end
        end
    end
end

-- 存档
local function OnWriteToSaveFile()
    if currentChoosedCPIndex <= defaltCPIndex or currentChoosedCPIndex > cameraParaSaveFileLimit then
        return
    end

    -- 读取现在的camera参数并保存到内存
    ReadCameraParameterAndSaveTo(currentChoosedCPIndex)

    -- 保存到存档
    for k,v in pairs(cameraParameterList[currentChoosedCPIndex]) do
        if type(k) == "string" then
            CS.LPCFramework.LocalDataStorage.Instance:SaveFloat(k..currentChoosedCPIndex, v)
        end
    end
end

-- 设置Camera参数，显示并同步改变主城摄像机参数
-- index, 0=default，1..N=userSavedData
local function OnSetCameraParameter(index)
    -- 设置当前下标
    currentChoosedCPIndex = index
    if currentChoosedCPIndex < defaltCPIndex or currentChoosedCPIndex > cameraParaSaveFileLimit then
        currentChoosedCPIndex = defaltCPIndex
    end

    local parameter = cameraParameterList[currentChoosedCPIndex]

    -- 如果值无效，拷贝默认值
    if parameter == nil and currentChoosedCPIndex > 0 then
        DeepCopyCameraParameter(currentChoosedCPIndex, defaltCPIndex)

        parameter = cameraParameterList[currentChoosedCPIndex]
    end
    
    -- 坡度
    --
    -- 设置说明
    local item = _C.view.DTCameraParameterList:GetChildAt(0)
    local label = item:GetChild("Label_Description")
    label.text = string.format(cameraParameterDescPrefixList.Gradient, parameter.Gradient)
    -- 设置Slider参数和回调
    local slider = item:GetChild("Slider_Value")
    slider.max = 30;
    slider.value = parameter.Gradient;
    mainCameraScript.m_gradient = parameter.Gradient
    slider.onChanged:Set(
    function()
        isCameraParaterChanged = true
        -- 精确到小数点后两位
        slider.value = slider.value - slider.value%0.01

        label.text = string.format(cameraParameterDescPrefixList.Gradient, slider.value)
        -- 摄像机参数同步修改
        mainCameraScript.m_gradient = slider.value
    end)

    -- 缩放系数
    --
    -- 设置说明
    local item = _C.view.DTCameraParameterList:GetChildAt(1)
    local label = item:GetChild("Label_Description")
    label.text = string.format(cameraParameterDescPrefixList.ZoomFactor, parameter.ZoomFactor)
    -- 设置Slider参数和回调
    local slider = item:GetChild("Slider_Value")
    slider.max = 1;
    slider.value = parameter.ZoomFactor;
    mainCameraScript.m_zoomFactor = parameter.ZoomFactor
    slider.onChanged:Set(
    function()
        isCameraParaterChanged = true
        -- 精确到小数点后两位
        slider.value = slider.value - slider.value%0.01
        label.text = string.format(cameraParameterDescPrefixList.ZoomFactor, slider.value)
        -- 摄像机参数同步修改
        mainCameraScript.m_zoomFactor = slider.value
    end)

    -- 放大极限
    --
    -- 设置说明
    local item = _C.view.DTCameraParameterList:GetChildAt(2)
    local label = item:GetChild("Label_Description")
    label.text = string.format(cameraParameterDescPrefixList.ZoomInLimit, parameter.ZoomInLimit)
    -- 设置Slider参数和回调
    local slider = item:GetChild("Slider_Value")
    slider.max = 100;
    slider.value = parameter.ZoomInLimit;
    mainCameraScript.m_zoomInLimit = parameter.ZoomInLimit
    slider.onChanged:Set(
    function()
        isCameraParaterChanged = true
        -- 精确到小数点后两位
        slider.value = slider.value - slider.value%0.01
        label.text = string.format(cameraParameterDescPrefixList.ZoomInLimit, slider.value)
        -- 摄像机参数同步修改
        mainCameraScript.m_zoomInLimit = slider.value
    end)

    -- 缩小极限
    --
    -- 设置说明
    local item = _C.view.DTCameraParameterList:GetChildAt(3)
    local label = item:GetChild("Label_Description")
    label.text = string.format(cameraParameterDescPrefixList.ZoomOutLimit, parameter.ZoomOutLimit)
    -- 设置Slider参数和回调
    local slider = item:GetChild("Slider_Value")
    slider.max = 100;
    slider.value = parameter.ZoomOutLimit;
    mainCameraScript.m_zoomOutLimit = parameter.ZoomOutLimit
    slider.onChanged:Set(
    function()
        isCameraParaterChanged = true
        -- 精确到小数点后两位
        slider.value = slider.value - slider.value%0.01
        label.text = string.format(cameraParameterDescPrefixList.ZoomOutLimit, slider.value)
        -- 摄像机参数同步修改
        mainCameraScript.m_zoomOutLimit = slider.value
    end)

    -- 特写摄像机移动速度
    --
    -- 设置说明
    local item = _C.view.DTCameraParameterList:GetChildAt(4)
    local label = item:GetChild("Label_Description")
    label.text = string.format(cameraParameterDescPrefixList.FeatureCamMoveSpeed, parameter.FeatureCamMoveSpeed)
    -- 设置Slider参数和回调
    local slider = item:GetChild("Slider_Value")
    slider.max = 100;
    slider.value = parameter.FeatureCamMoveSpeed;
    mainCameraScript.m_featureCamMoveSpeed = parameter.FeatureCamMoveSpeed
    slider.onChanged:Set(
    function()
        isCameraParaterChanged = true
        -- 精确到小数点后两位
        slider.value = slider.value - slider.value%0.01
        label.text = string.format(cameraParameterDescPrefixList.FeatureCamMoveSpeed, slider.value)
        -- 摄像机参数同步修改
        mainCameraScript.m_featureCamMoveSpeed = slider.value
    end)

    -- 平移速度
    --
    -- 设置说明
    local item = _C.view.DTCameraParameterList:GetChildAt(5)
    local label = item:GetChild("Label_Description")
    label.text = string.format(cameraParameterDescPrefixList.MoveSpeed, parameter.MoveSpeed)
    -- 设置Slider参数和回调
    local slider = item:GetChild("Slider_Value")
    slider.max = 10;
    slider.value = parameter.MoveSpeed;
    mainCameraScript.m_moveSpeed = parameter.MoveSpeed
    slider.onChanged:Set(
    function()
        isCameraParaterChanged = true
        -- 精确到小数点后两位
        slider.value = slider.value - slider.value%0.01
        label.text = string.format(cameraParameterDescPrefixList.MoveSpeed, slider.value)
        -- 摄像机参数同步修改
        mainCameraScript.m_moveSpeed = slider.value
    end)

    -- 向前最大距离
    --
    -- 设置说明
    local item = _C.view.DTCameraParameterList:GetChildAt(6)
    local label = item:GetChild("Label_Description")
    label.text = string.format(cameraParameterDescPrefixList.FrontMaxDis, parameter.FrontMaxDis)
    -- 设置Slider参数和回调
    local slider = item:GetChild("Slider_Value")
    slider.max = 10;
    slider.value = parameter.FrontMaxDis;
    mainCameraScript.m_frontMaxDis = parameter.FrontMaxDis
    slider.onChanged:Set(
    function()
        isCameraParaterChanged = true
        -- 精确到小数点后两位
        slider.value = slider.value - slider.value%0.01
        label.text = string.format(cameraParameterDescPrefixList.FrontMaxDis, slider.value)
        -- 摄像机参数同步修改
        mainCameraScript.m_frontMaxDis = slider.value
    end)

    -- 向后最大距离
    --
    -- 设置说明
    local item = _C.view.DTCameraParameterList:GetChildAt(7)
    local label = item:GetChild("Label_Description")
    label.text = string.format(cameraParameterDescPrefixList.BackMaxDis, parameter.BackMaxDis)
    -- 设置Slider参数和回调
    local slider = item:GetChild("Slider_Value")
    slider.max = 10;
    slider.value = parameter.BackMaxDis;
    mainCameraScript.m_backMaxDis = parameter.BackMaxDis
    slider.onChanged:Set(
    function()
        isCameraParaterChanged = true
        -- 精确到小数点后两位
        slider.value = slider.value - slider.value%0.01
        label.text = string.format(cameraParameterDescPrefixList.BackMaxDis, slider.value)
        -- 摄像机参数同步修改
        mainCameraScript.m_backMaxDis = slider.value
    end)

    -- 平移回弹距离-前
    --
    -- 设置说明
    local item = _C.view.DTCameraParameterList:GetChildAt(8)
    local label = item:GetChild("Label_Description")
    label.text = string.format(cameraParameterDescPrefixList.FrontSpringDis, parameter.FrontSpringDis)
    -- 设置Slider参数和回调
    local slider = item:GetChild("Slider_Value")
    slider.max = 10;
    slider.value = parameter.FrontSpringDis;
    mainCameraScript.m_frontSpringDis = parameter.FrontSpringDis
    slider.onChanged:Set(
    function()
        isCameraParaterChanged = true
        -- 精确到小数点后两位
        slider.value = slider.value - slider.value%0.01
        label.text = string.format(cameraParameterDescPrefixList.FrontSpringDis, slider.value)
        -- 摄像机参数同步修改
        mainCameraScript.m_frontSpringDis = slider.value
    end)

    -- 平移回弹距离-后
    --
    -- 设置说明
    local item = _C.view.DTCameraParameterList:GetChildAt(9)
    local label = item:GetChild("Label_Description")
    label.text = string.format(cameraParameterDescPrefixList.BackSpringDis, parameter.BackSpringDis)
    -- 设置Slider参数和回调
    local slider = item:GetChild("Slider_Value")
    slider.max = 10;
    slider.value = parameter.BackSpringDis;
    mainCameraScript.m_backSpringDis = parameter.BackSpringDis
    slider.onChanged:Set(
    function()
        isCameraParaterChanged = true
        -- 精确到小数点后两位
        slider.value = slider.value - slider.value%0.01
        label.text = string.format(cameraParameterDescPrefixList.BackSpringDis, slider.value)
        -- 摄像机参数同步修改
        mainCameraScript.m_backSpringDis = slider.value
    end)

    -- 回弹速度-前(向后)
    --
    -- 设置说明
    local item = _C.view.DTCameraParameterList:GetChildAt(10)
    local label = item:GetChild("Label_Description")
    label.text = string.format(cameraParameterDescPrefixList.FrontSpringSpeed, parameter.FrontSpringSpeed)
    -- 设置Slider参数和回调
    local slider = item:GetChild("Slider_Value")
    slider.max = 10;
    slider.value = parameter.FrontSpringSpeed;
    mainCameraScript.m_frontSpringSpeed = parameter.FrontSpringSpeed
    slider.onChanged:Set(
    function()
        isCameraParaterChanged = true
        -- 精确到小数点后两位
        slider.value = slider.value - slider.value%0.01
        label.text = string.format(cameraParameterDescPrefixList.FrontSpringSpeed, slider.value)
        -- 摄像机参数同步修改
        mainCameraScript.m_frontSpringSpeed = slider.value
    end)

    -- 回弹速度-后(向前)
    --
    -- 设置说明
    local item = _C.view.DTCameraParameterList:GetChildAt(11)
    local label = item:GetChild("Label_Description")
    label.text = string.format(cameraParameterDescPrefixList.BackSpringSpeed, parameter.BackSpringSpeed)
    -- 设置Slider参数和回调
    local slider = item:GetChild("Slider_Value")
    slider.max = 10;
    slider.value = parameter.BackSpringSpeed;
    mainCameraScript.m_backSpringSpeed = parameter.BackSpringSpeed
    slider.onChanged:Set(
    function()
        isCameraParaterChanged = true
        -- 精确到小数点后两位
        slider.value = slider.value - slider.value%0.01
        label.text = string.format(cameraParameterDescPrefixList.BackSpringSpeed, slider.value)
        -- 摄像机参数同步修改
        mainCameraScript.m_backSpringSpeed = slider.value
    end)

    -- 旋转速度
    --
    -- 设置说明
    local item = _C.view.DTCameraParameterList:GetChildAt(12)
    local label = item:GetChild("Label_Description")
    label.text = string.format(cameraParameterDescPrefixList.RotateSpeed, parameter.RotateSpeed)
    -- 设置Slider参数和回调
    local slider = item:GetChild("Slider_Value")
    slider.max = 360;
    slider.value = parameter.RotateSpeed;
    mainCameraScript.m_rotateSpeed = parameter.RotateSpeed
    slider.onChanged:Set(
    function()
        isCameraParaterChanged = true
        -- 精确到小数点后两位
        slider.value = slider.value - slider.value%0.01
        label.text = string.format(cameraParameterDescPrefixList.RotateSpeed, slider.value)
        -- 摄像机参数同步修改
        mainCameraScript.m_rotateSpeed = slider.value
    end)

    -- 最大旋转角度-左
    --
    -- 设置说明
    local item = _C.view.DTCameraParameterList:GetChildAt(13)
    local label = item:GetChild("Label_Description")
    label.text = string.format(cameraParameterDescPrefixList.LeftMaxAngle, parameter.LeftMaxAngle)
    -- 设置Slider参数和回调
    local slider = item:GetChild("Slider_Value")
    slider.max = 90;
    slider.value = parameter.LeftMaxAngle;
    mainCameraScript.m_leftMaxAngle = parameter.LeftMaxAngle
    slider.onChanged:Set(
    function()
        isCameraParaterChanged = true
        -- 精确到小数点后两位
        slider.value = slider.value - slider.value%0.01
        label.text = string.format(cameraParameterDescPrefixList.LeftMaxAngle, slider.value)
        -- 摄像机参数同步修改
        mainCameraScript.m_leftMaxAngle = slider.value
    end)

    -- 最大旋转角度-右
    --
    -- 设置说明
    local item = _C.view.DTCameraParameterList:GetChildAt(14)
    local label = item:GetChild("Label_Description")
    label.text = string.format(cameraParameterDescPrefixList.RightMaxAngle, parameter.RightMaxAngle)
    -- 设置Slider参数和回调
    local slider = item:GetChild("Slider_Value")
    slider.max = 90;
    slider.value = parameter.RightMaxAngle;
    mainCameraScript.m_rightMaxAngle = parameter.RightMaxAngle
    slider.onChanged:Set(
    function()
        isCameraParaterChanged = true
        -- 精确到小数点后两位
        slider.value = slider.value - slider.value%0.01
        label.text = string.format(cameraParameterDescPrefixList.RightMaxAngle, slider.value)
        -- 摄像机参数同步修改
        mainCameraScript.m_rightMaxAngle = slider.value
    end)

    -- 旋转回弹角度-左
    --
    -- 设置说明
    local item = _C.view.DTCameraParameterList:GetChildAt(15)
    local label = item:GetChild("Label_Description")
    label.text = string.format(cameraParameterDescPrefixList.LeftSpringAngle, parameter.LeftSpringAngle)
    -- 设置Slider参数和回调
    local slider = item:GetChild("Slider_Value")
    slider.max = 90;
    slider.value = parameter.LeftSpringAngle;
    mainCameraScript.m_leftSpringAngle = parameter.LeftSpringAngle
    slider.onChanged:Set(
    function()
        isCameraParaterChanged = true
        -- 精确到小数点后两位
        slider.value = slider.value - slider.value%0.01
        label.text = string.format(cameraParameterDescPrefixList.LeftSpringAngle, slider.value)
        -- 摄像机参数同步修改
        mainCameraScript.m_leftSpringAngle = slider.value
    end)

    -- 旋转回弹角度-右
    --
    -- 设置说明
    local item = _C.view.DTCameraParameterList:GetChildAt(16)
    local label = item:GetChild("Label_Description")
    label.text = string.format(cameraParameterDescPrefixList.RightSpringAngle, parameter.RightSpringAngle)
    -- 设置Slider参数和回调
    local slider = item:GetChild("Slider_Value")
    slider.max = 90;
    slider.value = parameter.RightSpringAngle;
    mainCameraScript.m_rightSpringAngle = parameter.RightSpringAngle
    slider.onChanged:Set(
    function()
        isCameraParaterChanged = true
        -- 精确到小数点后两位
        slider.value = slider.value - slider.value%0.01
        label.text = string.format(cameraParameterDescPrefixList.RightSpringAngle, slider.value)
        -- 摄像机参数同步修改
        mainCameraScript.m_rightSpringAngle = slider.value
    end)

    -- 回弹速度-左(向右)
    --
    -- 设置说明
    local item = _C.view.DTCameraParameterList:GetChildAt(17)
    local label = item:GetChild("Label_Description")
    label.text = string.format(cameraParameterDescPrefixList.LeftSpringSpeed, parameter.LeftSpringSpeed)
    -- 设置Slider参数和回调
    local slider = item:GetChild("Slider_Value")
    slider.max = 10;
    slider.value = parameter.LeftSpringSpeed;
    mainCameraScript.m_leftSpringSpeed = parameter.LeftSpringSpeed
    slider.onChanged:Set(
    function()
        isCameraParaterChanged = true
        -- 精确到小数点后两位
        slider.value = slider.value - slider.value%0.01
        label.text = string.format(cameraParameterDescPrefixList.LeftSpringSpeed, slider.value)
        -- 摄像机参数同步修改
        mainCameraScript.m_leftSpringSpeed = slider.value
    end)

    -- 回弹速度-右(向左)
    --
    -- 设置说明
    local item = _C.view.DTCameraParameterList:GetChildAt(18)
    local label = item:GetChild("Label_Description")
    label.text = string.format(cameraParameterDescPrefixList.RightSpringSpeed, slider.value)
    -- 设置Slider参数和回调
    local slider = item:GetChild("Slider_Value")
    slider.max = 10;
    slider.value = parameter.RightSpringSpeed;
    mainCameraScript.m_rightSpringSpeed = parameter.RightSpringSpeed
    slider.onChanged:Set(
    function()
        isCameraParaterChanged = true
        -- 精确到小数点后两位
        slider.value = slider.value - slider.value%0.01
        label.text = string.format(cameraParameterDescPrefixList.RightSpringSpeed, slider.value)
        -- 摄像机参数同步修改
        mainCameraScript.m_rightSpringSpeed = slider.value
    end)
end

-- 保存文件提示
local function SaveFilePopup(callback, paras)
    -- 参数值有改动，提示是否保存
    if isCameraParaterChanged then
        isCameraParaterChanged = false

        -- 如果是默认参数页，弹出不保存提示
        if currentChoosedCPIndex == defaltCPIndex then
            UIManager.openController(UIManager.ControllerName.Popup,
            {
                UIManager.PopupStyle.ContentConfirm,
                content = "请注意，默认页的参数将不会保存！\n如需保存，请切换其他存档页",

                btnTitle = "知道啦",
                btnFunc = function()
                    isCameraParaterChanged = false
                    callback(paras)
                end
            } )
        else
            -- 弹出二级弹框
            UIManager.openController(UIManager.ControllerName.Popup,
            {
                UIManager.PopupStyle.ContentYesNo,
                content = "参数值有改动，是否保存？",

                btnTitle = {"忽略", "保存"},
                btnFunc = 
                {
                function()
                    callback(paras)
                end,

                function()
                    OnWriteToSaveFile()
                    callback(paras)
                end
                }
            } )
        end
    else
        callback(paras)
    end
end

-- 尝试切换到另一个camera参数存档
local function TryToChangeToAnotherSavedFile(newIndex)
    if newIndex < defaltCPIndex or newIndex > cameraParaSaveFileLimit then
        return
    end

    SaveFilePopup(OnSetCameraParameter, newIndex)
end
-- 设置为默认的camera参数
local function OnSetDefaultCameraParameter()
    TryToChangeToAnotherSavedFile(defaltCPIndex)
end

-- 初始化摄像机页面
local function OnInitCameraPage()
    -- 左下角按钮
    _C.view.DTCameraDefaultSaveFileBtn.title = "默认参数"
    _C.view.DTCameraDefaultSaveFileBtn.onClick:Set(
    function()
        OnSetDefaultCameraParameter()
        _C.view.DTCurrentLoadedCPFileLabel.text = _C.view.DTCameraDefaultSaveFileBtn.title
    end)

    -- 初始化参数列表
    _C.view.DTCameraParameterList:RemoveChildrenToPool()
    local cameraParameterCount = Utils.GetTableLength(cameraParameterDescPrefixList)
    for i=1, cameraParameterCount do
        _C.view.DTCameraParameterList:AddItemFromPool()
    end

    -- 初始化Camera存档列表
    _C.view.DTCameraSaveFileList:RemoveChildrenToPool()
    for i=1, cameraParaSaveFileLimit do
        local item = _C.view.DTCameraSaveFileList:AddItemFromPool()
        item.title = "存档 "..i
        -- 注册回调函数
        item.onClick:Set(
        function()
            TryToChangeToAnotherSavedFile(i)
            _C.view.DTCurrentLoadedCPFileLabel.text = item.title
        end
        )
    end

    -- 新建camera参数列表
    cameraParameterList = {}
    -- 获取摄像机参数
    OnReadCameraDefaultParameter()

    -- 初始化camera参数列表
    for i=1, cameraParaSaveFileLimit do
        -- 拷贝默认参数
        DeepCopyCameraParameter(i, 0)
    end
    -- 读取存档文件
    OnReadSavedCameraParameter()
end

-- 显示camera参数页面
OnShowCameraParameterPage = function()
    if not _C.IsOpen then
        return
    end

    -- 设置返回按钮callback
    _C.view.DTBackBtn.title = "主城摄像机参数"
    _C.view.DTBackBtn.onClick:Set(
    function()
        SaveFilePopup(OnShowSelectionPage)
    end
    )

    _C.view.DTCurrentLoadedCPFileLabel.text = _C.view.DTCameraDefaultSaveFileBtn.title
    OnSetDefaultCameraParameter()

    _C.view.DTStateController.selectedIndex = 2
end

--*****************************选项页面*************************************

-- 初始化选项页面
local function OnInitSelectionPage()
    -- 设置选项
    _C.view.DTSelectionList:RemoveChildrenToPool()
    local cameraParameterBtn = _C.view.DTSelectionList:AddItemFromPool()
    cameraParameterBtn.title = "摄像机参数"
    cameraParameterBtn.onClick:Set(OnShowCameraParameterPage)
end

-- 显示选项页面
OnShowSelectionPage = function ()
    if not _C.IsOpen then
        return
    end

    -- 设置返回按钮callback
    _C.view.DTBackBtn.title = "Debug选项"
    _C.view.DTBackBtn.onClick:Set(OnShowNonePage)

    _C.view.DTStateController.selectedIndex = 1
end

--****************************************************************************

-- 初始化数据
local function OnInitDatas()
    -- MainCity界面上的Debug button
    _C.view.DebugToolBtn.title = "调试"
    _C.view.DebugToolBtn.onClick:Set(OnShowSelectionPage)

    OnInitSelectionPage()
    OnInitCameraPage()

    -- 默认只显示Debug按钮
    OnShowNonePage()
end

--****************************************************************************

-- 默认与MainCityUI一同打开，一同关闭，所以初始化默认写到onCreate里
function _C:onCreat()
    OnInitDatas()
end

function _C:onDestroy()

end

return _C