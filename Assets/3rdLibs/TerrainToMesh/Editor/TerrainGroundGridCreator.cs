using System.Collections;
using System.Collections.Generic;
using System.IO;
using UnityEditor;
using UnityEngine;

namespace LPCFramework
{

    public class TerrainGroundGridCreator : EditorWindow 
    {
        // 资源目录
        private string m_sGridRootPrefabPath = "Assets/ArtAssets/MapEditor/GridRoot.prefab";
        private string m_sGridNodePrefabPath = "Assets/ArtAssets/MapEditor/GridNode.prefab";

        [MenuItem("GameObject/Terrain to Mesh/Terrain to Mesh Grid Create")]
        public static void ShowWindow()
        {
            GetWindow(typeof(TerrainGroundGridCreator));
        }

        private TerrainGroundCoordinate m_Coord = null;

        private void OnGUI()
        {
            m_Coord = (TerrainGroundCoordinate)EditorGUILayout.ObjectField("选择地面", m_Coord, typeof(TerrainGroundCoordinate), true);

            if (null != m_Coord)
            {
                if (GUILayout.Button("Create"))
                {
                    string sFolder = EditorUtility.SaveFolderPanel("生成的Mesh保存文件夹，建议为不同场景建立文件夹", Application.dataPath + "/ArtAssets/MapEditor/GenByTool", "");
                    if (Directory.Exists(sFolder))
                    {
                        string sOutFolder = sFolder.Replace("\\", "/");
                        string sDataFolder = Application.dataPath.Replace("\\", "/");
                        string sPath = "Assets" + sOutFolder.Replace(sDataFolder, "");

                        int iTotalMeshNumber = AddGrids(sPath);
                        GenPrefab(sPath, iTotalMeshNumber);
                    }
                }
            }
        }

        //生成显示格子的Mesh
        /// <summary>
        /// 主要问题在于mesh顶点数量的限制。比如说200x173的格子，需要约20万个顶点。 
        /// 我们一竖条一竖条的生成
        /// </summary>
        /// <param name="sFolder"></param>
        private int AddGrids(string sFolder)
        {
            int iGridHeight = m_Coord.m_iGridHeight;
            float fGroundSize = m_Coord.m_fGroundSize;
            float fHeightSep = fGroundSize / (iGridHeight + 0.5f);
            float fEdgeWidth = fHeightSep / Mathf.Sqrt(3.0f);
            int iGridWidth = Mathf.FloorToInt((fGroundSize - 2.0f * fEdgeWidth) / (1.5f * fEdgeWidth)) + 1;

            int iRowStep = 10000/iGridHeight; //这是每个mesh包含多少“竖条"
            int iTotalMeshNumber = iGridWidth/iRowStep + 1; //因为mesh定点数量限制，我们将生成多个mesh，这个是数量

            Vector2[] vUVOffset = new Vector2[6];
            vUVOffset[5] = new Vector2(fEdgeWidth / fGroundSize, 0.0f);
            vUVOffset[4] = new Vector2(0.5f * fEdgeWidth / fGroundSize, 0.5f * Mathf.Sqrt(3.0f) * fEdgeWidth / fGroundSize);
            vUVOffset[3] = new Vector2(-0.5f * fEdgeWidth / fGroundSize, 0.5f * Mathf.Sqrt(3.0f) * fEdgeWidth / fGroundSize);
            vUVOffset[2] = new Vector2(-fEdgeWidth / fGroundSize, 0.0f);
            vUVOffset[1] = new Vector2(-0.5f * fEdgeWidth / fGroundSize, -0.5f * Mathf.Sqrt(3.0f) * fEdgeWidth / fGroundSize);
            vUVOffset[0] = new Vector2(0.5f * fEdgeWidth / fGroundSize, -0.5f * Mathf.Sqrt(3.0f) * fEdgeWidth / fGroundSize);

            Vector3 vpos, vnor;
            for (int i = 0; i < iTotalMeshNumber; ++i)
            {
                List<Vector3> vVectors = new List<Vector3>();
                List<Vector2> vUvs = new List<Vector2>();
                List<int> trangles = new List<int>();
                int iIndexNow = 0;
                int iRawStart = i*iRowStep;

                for (int j = 0; j < iRowStep && j + iRawStart < iGridWidth; ++j)
                {
                    int iX = j + iRawStart;
                    int iRealHeight = 0 == (iX & 1) ? iGridHeight : (iGridHeight - 1);
                    Vector3[] thisRowVector3s = new Vector3[iRealHeight * 4 + 2];
                    Vector2[] thisRowUVs = new Vector2[iRealHeight * 4 + 2];
                    int[] thisRowTrangles = new int[iRealHeight * 12];

                    #region 这里加入一竖条

                    for (int k = 0; k < iRealHeight; ++k)
                    {
                        float fX = fEdgeWidth + 1.5f * fEdgeWidth * iX;
                        float fY = (k + 0.5f + 0.5f * (iX & 1)) * fHeightSep;
                        Vector2 vUvNow = new Vector2(Mathf.Clamp01(fX / fGroundSize), Mathf.Clamp01(fY / fGroundSize));

                        if (0 == k)
                        {
                            //加入最上面两个点
                            m_Coord.GetPosNormal(vUvNow + vUVOffset[0], 0.1f, out vpos, out vnor);
                            thisRowVector3s[0] = vpos;
                            thisRowUVs[0] = new Vector2(0.0f, 0.0f);
                            m_Coord.GetPosNormal(vUvNow + vUVOffset[1], 0.1f, out vpos, out vnor);
                            thisRowVector3s[1] = vpos;
                            thisRowUVs[1] = new Vector2(1.0f, 0.0f);
                        }

                        m_Coord.GetPosNormal(vUvNow + vUVOffset[2], 0.1f, out vpos, out vnor);
                        thisRowVector3s[k * 4 + 2] = vpos;
                        thisRowUVs[k * 4 + 2] = new Vector2(1.0f, 0.5f);

                        m_Coord.GetPosNormal(vUvNow + vUVOffset[3], 0.1f, out vpos, out vnor);
                        thisRowVector3s[k * 4 + 3] = vpos;
                        thisRowUVs[k * 4 + 3] = new Vector2(1.0f, 1.0f);

                        m_Coord.GetPosNormal(vUvNow + vUVOffset[4], 0.1f, out vpos, out vnor);
                        thisRowVector3s[k * 4 + 4] = vpos;
                        thisRowUVs[k * 4 + 4] = new Vector2(0.0f, 1.0f);

                        m_Coord.GetPosNormal(vUvNow + vUVOffset[5], 0.1f, out vpos, out vnor);
                        thisRowVector3s[k * 4 + 5] = vpos;
                        thisRowUVs[k * 4 + 5] = new Vector2(0.0f, 0.5f);

                        int i0 = 0;
                        int i1 = 1;
                        int iStartNow = iIndexNow + k * 4;
                        if (0 != k)
                        {
                            i1 = -1;                            
                        }

                        thisRowTrangles[k * 12 + 0] = iStartNow + i0;
                        thisRowTrangles[k * 12 + 1] = iStartNow + i1;
                        thisRowTrangles[k * 12 + 2] = iStartNow + 2;

                        thisRowTrangles[k * 12 + 3] = iStartNow + i0;
                        thisRowTrangles[k * 12 + 4] = iStartNow + 2;
                        thisRowTrangles[k * 12 + 5] = iStartNow + 5;

                        thisRowTrangles[k * 12 + 6] = iStartNow + 2;
                        thisRowTrangles[k * 12 + 7] = iStartNow + 3;
                        thisRowTrangles[k * 12 + 8] = iStartNow + 4;

                        thisRowTrangles[k * 12 + 9] = iStartNow + 2;
                        thisRowTrangles[k * 12 + 10] = iStartNow + 4;
                        thisRowTrangles[k * 12 + 11] = iStartNow + 5;
                    }

                    #endregion

                    iIndexNow += thisRowVector3s.Length;
                    vVectors.AddRange(thisRowVector3s);
                    vUvs.AddRange(thisRowUVs);
                    trangles.AddRange(thisRowTrangles);
                }

                //这里生成Mesh
                Mesh newMesh = new Mesh();
                newMesh.vertices = vVectors.ToArray();
                newMesh.uv = vUvs.ToArray();
                newMesh.SetIndices(trangles.ToArray(), MeshTopology.Triangles, 0);

                AssetDatabase.CreateAsset(newMesh, sFolder + "/GridMesh" + i + ".asset");
            }

            return iTotalMeshNumber;
        }
        /// <summary>
        /// 生成prefab
        /// </summary>
        /// <param name="sFolder"></param>
        private void GenPrefab(string sFolder, int iTotalMeshNumber)
        {
            Object gridRootResource = AssetDatabase.LoadAssetAtPath<Object>(m_sGridRootPrefabPath);
            Object gridNodeResource = AssetDatabase.LoadAssetAtPath<Object>(m_sGridNodePrefabPath);
            
            if(gridRootResource == null)
            {
                Debug.LogError("缺少资源" + m_sGridRootPrefabPath);
                return;
            }

            if (gridNodeResource == null)
            {
                Debug.LogError("缺少资源" + m_sGridNodePrefabPath);
                return;
            }

            GameObject gridRootObject = GameObject.Instantiate(gridRootResource) as GameObject;
            // 太高0.2米，防止和地面重合
            gridRootObject.transform.position = gridRootObject.transform.position + new Vector3(0f, 0.2f, 0f);

            // 生成NodeGrid
            for (int i = 0; i < iTotalMeshNumber; ++i)
            {
                Mesh mesh = AssetDatabase.LoadAssetAtPath<Mesh>(sFolder + "/GridMesh" + i + ".asset");

                GameObject node = GameObject.Instantiate(gridNodeResource, gridRootObject.transform) as GameObject;
                node.name = node.name + i;
                node.GetComponent<MeshFilter>().mesh = mesh;
            }

            PrefabUtility.CreatePrefab(sFolder + "/MapGrid.prefab", gridRootObject);
            GameObject.DestroyImmediate(gridRootObject);
            AssetDatabase.Refresh();

            Debug.Log("[TerrainGroundGridCreator] 生成地图格子成功！");
        }
    }
}

