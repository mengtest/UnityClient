local HexMetrics = require 'Hexagon.HexMetrics'
local HexCell= require 'Hexagon.HexCell'

local HexMesh = {}
    local meshPrefabPath = "Prefabs/Scene/DynamicData/HexMesh"
    local meshParentName = "HexMeshRoot"
    local meshParent = nil
    local meshPrefab = nil
    local hexMeshList = nil
    local isInitialized = false

    -- 添加三角
    -- <param name="tag" type="string">标签</param>
    -- <param name="v1" type="Vector3">三角形顶点1</param>
    -- <param name="v2" type="Vector3">三角形顶点2</param>
    -- <param name="v3" type="Vector3">三角形顶点3</param>
    local function addTriangle (tag, v1, v2, v3)
        if hexMeshList == nil or hexMeshList[tag] == nil then
            return
        end

		local vertexIndex = #hexMeshList[tag].vertices
		table.insert(hexMeshList[tag].vertices, v1)
        table.insert(hexMeshList[tag].vertices, v2)
        table.insert(hexMeshList[tag].vertices, v3)

        table.insert(hexMeshList[tag].triangles, vertexIndex)
        table.insert(hexMeshList[tag].triangles, vertexIndex + 1)
        table.insert(hexMeshList[tag].triangles, vertexIndex + 2)
	end

    -- 插入顶点颜色
    -- <param name="tag" type="string">标签</param>
    -- <param name="color" type="Color">顶点颜色</param>
    local function addTriangleColor (tag, color)
        if hexMeshList == nil or hexMeshList[tag] == nil then
            return
        end

		table.insert(hexMeshList[tag].colors, color)
		table.insert(hexMeshList[tag].colors, color)
		table.insert(hexMeshList[tag].colors, color)
	end

    -- 三角化
    -- <param name="tag" type="string">标签</param>
    -- <param name="cell" type="HexCell">六边形单元格</param>
    local function triangulate (tag, cell)
        if hexMeshList == nil or hexMeshList[tag] == nil or cell == nil then
            return
        end

		local center = cell.position;
        local length = #HexMetrics.corners - 1
        
		for i = 0, length do
            local nextIndex = i + 1
			addTriangle(tag, center, center + HexMetrics.corners[i], center + HexMetrics.corners[nextIndex])
			addTriangleColor(tag, cell.color);
		end
	end

    -- 初始化
	function HexMesh.init()
        
        hexMeshList = {}

        meshParent = CS.UnityEngine.GameObject.Find(meshParentName)
        if meshParent == nil then
            meshParent = CS.UnityEngine.GameObject(meshParentName)
        end

        meshPrefab = CS.LPCFramework.LogicUtils.LoadResource(meshPrefabPath)

        isInitialized = true
	end

    -- 添加一个新的mesh
    -- <param name="tag" type="string">标签</param>
    -- <param name="needCollider" type="bool">是否需要Mesh Collider</param>
    function HexMesh:addNewMesh(tag, needCollider)
        needCollider = needCollider or false

        if isInitialized == false then
            self:init()
        end

        if hexMeshList[tag] == nil then
            -- 新建对象，添加meshFilter和meshCollider
            hexMeshList[tag] = {}
            hexMeshList[tag].mesh = CS.UnityEngine.Mesh()
            hexMeshList[tag].gameObject = CS.UnityEngine.Object.Instantiate(meshPrefab, meshParent.transform)
            hexMeshList[tag].meshFilter = hexMeshList[tag].gameObject:GetComponent(typeof(CS.UnityEngine.MeshFilter))
            hexMeshList[tag].meshCollider = hexMeshList[tag].gameObject:GetComponent(typeof(CS.UnityEngine.MeshCollider))
            hexMeshList[tag].vertices = {}
		    hexMeshList[tag].colors = {}
		    hexMeshList[tag].triangles = {}
            -- 初始化
            hexMeshList[tag].init = function ()
                hexMeshList[tag].gameObject.name = "HexMesh"..tag
                hexMeshList[tag].meshFilter.mesh = hexMeshList[tag].mesh
            end
            
            -- 清除Mesh数据
            hexMeshList[tag].resetMesh = function ()
                hexMeshList[tag].mesh:Clear()
		        hexMeshList[tag].vertices = {}
		        hexMeshList[tag].colors = {}
		        hexMeshList[tag].triangles = {}
            end

            -- 重新绘制Mesh
            hexMeshList[tag].refreashMesh = function ()
                hexMeshList[tag].mesh.vertices = hexMeshList[tag].vertices
		        hexMeshList[tag].mesh.colors = hexMeshList[tag].colors
		        hexMeshList[tag].mesh.triangles = hexMeshList[tag].triangles
		        hexMeshList[tag].mesh:RecalculateNormals()

                -- 设置collider mesh
                if needCollider == true then
		            hexMeshList[tag].meshCollider.sharedMesh = hexMeshList[tag].mesh
                end
            end
        end

        hexMeshList[tag].init()
    end

    -- 绘制mesh
    -- <param name="tag" type="string">标签</param>
    -- <param name="cells" type="HexCell[]">六边形单元格数组</param>
    function HexMesh:draw(tag, cells)
        if isInitialized == false then
            self:init()
        else
            if hexMeshList[tag] == nil then
                self:addNewMesh(tag)
            else
                hexMeshList[tag]:resetMesh()
            end
        end

        -- 重新计算三角
		for i = 0, #cells do
			triangulate(tag, cells[i])
		end

        -- 重新绘制Mesh
        hexMeshList[tag]:refreashMesh()

--        -- 绘制
--		hexMeshList[tag].mesh.vertices = hexMeshList[tag].vertices
--		hexMeshList[tag].mesh.colors = hexMeshList[tag].colors
--		hexMeshList[tag].mesh.triangles = hexMeshList[tag].triangles
--		hexMeshList[tag].mesh.RecalculateNormals()
--        -- 设置collider
--        if hexMeshList[tag].meshCollider ~= nil then
--		    hexMeshList[tag].meshCollider.sharedMesh = hexMeshList[tag].mesh
--        end
	end

return HexMesh