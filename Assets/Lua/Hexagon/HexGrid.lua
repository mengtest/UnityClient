local HexMetrics = require 'Hexagon.HexMetrics'
local HexCoordinates = require 'Hexagon.HexCoordinates'
local HexCell = require 'Hexagon.HexCell'
local HexMesh = require 'Hexagon.HexMesh'

-- 六边形网格
local HexGrid = {}

    local xCount = 0
    local zCount = 0

    local gridPrefabPath = "Prefabs/Scene/DynamicData/HexGrid"
    local gridParent = nil

    local cellLabelPrefab = nil

    local allCells= nil             -- 地图上所有的单元格子
    local SOICellList = nil         -- 势力范围单元格子列表，由下标来区分某个君主的领地; SOI = SphereOfInfluence
    local gridCanvas = nil          -- 格子坐标画布

    local defaultAllianceColor = CS.UnityEngine.Color.blue      -- 默认联盟颜色
    local defaultHostileColor = CS.UnityEngine.Color.red        -- 默认敌对颜色
    local defaultConflictColor = CS.UnityEngine.Color.red       -- 默认冲突颜色

    --------------------------------------------------------------------------
    -- local functions
    --------------------------------------------------------------------------

    -- 转换Hexgon坐标为Odd-q模式
    -- <param name="x" type="int"></param>
    -- <param name="z" type="int"></param>
    -- <return type="int, int">
    local function convertToOddQ(x, z)
        local xModify = math.floor(x / 2)
        return x, -z - xModify - (x % 2)
    end
    
    -- 重置势力范围格子为普通格子
    -- <param name="tag" type="string">标签</param>
    local function resetCells(tag)
        if tag == nil then
            return
        end

        if SOICellList[tag] == nil then
            return
        end

        for k,v in pairs(SOICellList[tag]) do
            if v ~= nil then
                v.color = nil
                v.tag = nil
            end
        end
    end

    -- 创建单元格子
    -- <param name="x" type="int">hex</param>
    -- <param name="z" type="int">等级</param>
    -- <param name="index" type="int">等级</param>
    local function createCell(x, z, index)
        local position = CS.UnityEngine.Vector3.zero
        local xModify = math.floor(x / 2)
        position.x = x * (HexMetrics.outerRadius * 1.5)
        position.y = 0
        position.z = -(z + x * 0.5 - xModify) * (HexMetrics.innerRadius * 2)

        allCells[index] = HexCell()
        allCells[index].position = position
        allCells[index].coordinates = HexCoordinates(x, z)
        allCells[index].color = nil
        allCells[index].tag = nil

--        Text label = Instantiate<Text>(cellLabelPrefab)
--        label.rectTransform.SetParent(gridCanvas.transform, false)
--        label.rectTransform.anchoredPosition = new Vector2(position.x, position.z)
--        label.text = cell.coordinates.ToStringOnSeparateLines()
    end

    -- 添加一个新的mesh
    -- <param name="tag" type="string[]">标签</param>
    -- <param name="needCollider" type="bool">是否需要Mesh Collider</param>
    local function createHexMesh(tag, needCollider)
        HexMesh:addNewMesh(tag, needCollider)
    end

    -- 重新计算某个指定的势力范围
    local function calcSphereOfInfluence(baseHexX, baseHexZ, level, tag, isHostile, conflictCells)
        
        -- 重置为普通单元格
        if SOICellList[tag] ~= nil then
            resetCells(tag)
        end

        SOICellList[tag] = {}

        -- 设置颜色
        local color = defaultAllianceColor
        if isHostile == true then
            color = defaultHostileColor
        end

        -- 处理冲突格子
        if conflictCells ~= nil then
            for k, v in pairs(conflictCells) do
                if v ~= nil then
                    -- key转换为格子所在下标
                    k = (v[0] + baseHexX) * zCount + (v[1] + baseHexZ)
                end
            end
        end
        
        -- 第一个为主城自己
        local index = baseHexX * zCount + baseHexZ
        if allCells[index] ~= nil then
            allCells[index].color = color
            allCells[index].tag = tag
            table.insert(SOICellList[tag], allCells[index])
        end

        local isOdd = false
        if baseHexX % 2 ~= 0 then isOdd = true end
        if SphereOfInfluenceConfig[isOdd] ~= nil then
            -- 遍历每个等级
            for k,v in pairs(SphereOfInfluenceConfig[isOdd]) do
                if k <= level and v ~= nil then
                    -- 遍历每组offset
                    for k2, v2 in pairs(v) do
                        if v2 ~= nil then
                            -- 计算hexCoodinates
                            local x = baseHexX + v2[1]
                            local z = baseHexZ + v2[2]
                            index = x * zCount + z
                            if allCells[index] ~= nil then
                                -- 冲突格子有特殊颜色
                                if conflictCells ~= nil and conflictCells[index] ~= nil then
                                    allCells[index].color = defaultConflictColor
                                else
                                    allCells[index].color = color
                                end
                                
                                allCells[index].tag = tag

                                table.insert(SOICellList[tag], allCells[index])
                            end
                        end
                    end

                end
            end
        end
    end

    -- 重新绘制某个指定的势力范围
    local function repaintSphereOfInfluence(tag)
        if SOICellList[tag] == nil then
            print("[Warning] Cant find sephere of influence under tag: " + tag)
            return
        end

        HexMesh:draw(tag, SOICellList[tag])
    end
    --------------------------------------------------------------------------
    -- public functions
    --------------------------------------------------------------------------

    function HexGrid:init(xGridCount, zGridCount)
        xCount = xGridCount
        zCount = zGridCount

        local prefab = CS.LPCFramework.LogicUtils.LoadResource(gridPrefabPath)
        if prefab ~= nil then
            gridParent = CS.UnityEngine.GameObject.Instantiate(prefab)
        end

        -- 初始化HexMesh
        HexMesh.init()
        --gridCanvas = GetComponentInChildren<Canvas>();
        
        allCells = {}
        SOICellList = {}

        -- 创建所有格子
        local i = 0
        for x = 0, xCount - 1 do
            for z = 0, zCount - 1 do
                createCell(x, z, i)
                i = i + 1
            end
        end

    end

    -- 创建势力范围
    -- <param name="baseHexX" type="int">坐标X</param>
    -- <param name="baseHexZ" type="int">坐标Z</param>
    -- <param name="level" type="int">等级</param>
    -- <param name="tag" type="string">标签,如君主Id</param>
    -- <param name="isHostile" type="bool">是否为敌对势力</param>
    -- <param name="conflictCells" type="table">冲突单元格子，如conflictCells =｛｛1，1｝，｛2，2｝｝</param>
    -- <param name="needCollider" type="bool">是否需要碰撞</param>
    function HexGrid:createSphereOfInfluence(baseHexX, baseHexZ, level, tag, isHostile, conflictCells, needCollider)
        needCollider = needCollider or false

        createHexMesh(tag, needCollider)
        calcSphereOfInfluence(baseHexX, baseHexZ, level, tag, isHostile, conflictCells)
        repaintSphereOfInfluence(tag)
    end

    -- 标记格子颜色
    -- <param name="position" type="CS.UnityEngine.Vector3"></param>
    function HexGrid:getCell(position)
        position = gridParent.transform:InverseTransformPoint(position)
        local hexCoordinates = HexCoordinates:FromPosition(position)

        -- 找到坐标对应的格子
        local xModify = math.floor(hexCoordinates.X / 2)
        local index = hexCoordinates.X * zCount - hexCoordinates.Z - xModify - hexCoordinates.X % 2
        local cell = allCells[index]
        
        return cell
    end

    -- 根据格子查找位置
    function HexGrid:getPosition(baseX, baseZ)
        local position = CS.UnityEngine.Vector3.zero
        local xModify = math.floor(baseX / 2)
        position.x = baseX * (HexMetrics.outerRadius * 1.5)
        position.y = 0
        position.z = -(baseZ + baseX * 0.5 - xModify) * (HexMetrics.innerRadius * 2)

        return position
    end


return HexGrid