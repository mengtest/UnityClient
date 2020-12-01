using System.Collections;
using System.Collections.Generic;
using UnityEngine;
#if !Arts
using ProtoBuf;
#endif
namespace LPCFramework
{
    public class TerrainGroundGrid : MonoBehaviour
    {
        public enum MarkType
        {
            Default = 0,
            OpenSpace = 1,      // 空地
            Obstacle = 2,       // 障碍物
            Water = 3,          // 水面
            Max = 3,
        }

        private static TerrainGroundGrid _instance = null;

        public static TerrainGroundGrid Instance
        {
            get { return _instance; }
        }
        /// <summary>
        /// 勾选，TerrainGroundGrid是否工作。
        /// </summary>
        public bool On;

        public TerrainGroundCoordinate m_Coord;
        public GameObject m_NumberPrefab;

        private GameObjectPool m_NumberPool;
        private Vector2[] m_vUVOffset = null;
        private int m_iGridWidth = 0;

        private Color[] m_colorType = new Color[]
        {
            // 鼠标悬停颜色，目前没用到
            new Color(1.0f, 1.0f, 1.0f, 0.8f),
            // 空地颜色，其实没用到，直接UnMarkGrid就好
            new Color(0.0f, 0.0f, 0.0f, 0.0f),
            // 障碍物颜色
            //new Color(1.0f, 0.0f, 1.0f, 0.2f),
            Color.red,
            // 水颜色
            //new Color(0.0f, 1.0f, 0.5f, 0.2f),
            Color.blue,
        };
        // 当前标记的颜色类型
        private MarkType m_currentMarkColorType = MarkType.Default;
        // 是否开启手动标记
        private bool m_waitForManualMarking = false;
        // 是否开始着色
        private bool m_enableDrawing = false;
        // 保存文件目录
        private string m_saveFilePath = null;


        /************************************************************************************/

        /// <summary>
        /// 开启/关闭格子显示
        /// </summary>
        /// <param name="value"></param>
        public void EnableGridDisplay(bool value)
        {
            On = value;

            EnableGrid();
        }
        /// <summary>
        /// 设置标记类型
        /// </summary>
        public void SetMarkType(MarkType markType)
        {
            if (markType < MarkType.Default || markType > MarkType.Max)
                return;

            m_currentMarkColorType = markType;
            m_waitForManualMarking = false;
            m_enableDrawing = true;
        }
        /// <summary>
        /// 开启/关闭手动标记功能
        /// </summary>
        public void EnableManualMarking(bool value)
        {
            m_waitForManualMarking = value;
        }
        /// <summary>
        /// 开启/关闭标记笔刷
        /// </summary>
        public void EnableMarkDrawing(bool value)
        {
            m_enableDrawing = value;
        }
#if !Arts
        public bool SaveToFile(int mapId)
        {
            string fileName = string.Format("Block_Info{0}.proto", mapId);

            proto.BlockInfoProto info = new proto.BlockInfoProto();
            foreach(KeyValuePair<int, MarkType> item in m_gridsToDraw)
            {
                int iX = item.Key / m_Coord.m_iGridHeight;
                int iY = item.Key % m_Coord.m_iGridHeight;
                info.x.Add(iX);
                info.y.Add(iY);
                info.type.Add((int)item.Value);
            }

            return FileUtils.SerializeProto<proto.BlockInfoProto>(info, m_saveFilePath, fileName);
        }
        /// <summary>
        /// 读取本地图配置存档
        /// </summary>
        /// <param name="mapId"></param>
        public void ReadFromFile(int mapId)
        {
            string filePath = string.Format("{0}Block_Info{1}.proto", m_saveFilePath, mapId);

            proto.BlockInfoProto info = FileUtils.DeserializeProto<proto.BlockInfoProto>(filePath);
            if (null != info)
            {
                if (null != m_gridsToDraw)
                    m_gridsToDraw.Clear();

                for (int i = 0; i < info.x.Count; ++i)
                {
                    int index = info.x[i] * m_Coord.m_iGridHeight + info.y[i];
                    m_gridsToDraw.Add(index, (MarkType)info.type[i]);
                }

                DrawMarkedGrids(true);
            }
        }
#endif
        /************************************************************************************/

        // Use this for initialization
        void Start()
        {
            _instance = this;
            m_saveFilePath = Application.dataPath + "/MapEditorSaveFiles/";
            m_Coord = TerrainGroundCoordinate.m_Intantance;
            EnableGridDisplay(false);
        }

        private void EnableGrid()
        {
            if (On)
            {
                float fEdgeWidth = m_Coord.GetEdigeWidth();
                float fGroundSize = m_Coord.m_fGroundSize;
                m_iGridWidth = Mathf.FloorToInt((fGroundSize - 2.0f * fEdgeWidth) / (1.5f * fEdgeWidth)) + 1;

                m_vUVOffset = new Vector2[6];
                m_vUVOffset[0] = new Vector2(fEdgeWidth / fGroundSize, 0.0f);
                m_vUVOffset[1] = new Vector2(0.5f * fEdgeWidth / fGroundSize, 0.5f * Mathf.Sqrt(3.0f) * fEdgeWidth / fGroundSize);
                m_vUVOffset[2] = new Vector2(-0.5f * fEdgeWidth / fGroundSize, 0.5f * Mathf.Sqrt(3.0f) * fEdgeWidth / fGroundSize);
                m_vUVOffset[3] = new Vector2(-fEdgeWidth / fGroundSize, 0.0f);
                m_vUVOffset[4] = new Vector2(-0.5f * fEdgeWidth / fGroundSize, -0.5f * Mathf.Sqrt(3.0f) * fEdgeWidth / fGroundSize);
                m_vUVOffset[5] = new Vector2(0.5f * fEdgeWidth / fGroundSize, -0.5f * Mathf.Sqrt(3.0f) * fEdgeWidth / fGroundSize);

                foreach (MeshRenderer mr in gameObject.GetComponentsInChildren<MeshRenderer>())
                {
                    mr.enabled = true;
                }

                m_NumberPool = new GameObjectPool("Number", m_NumberPrefab, 3, 100, transform);

                // 初始化标记参数
                m_waitForManualMarking = false;
                m_enableDrawing = false;
                m_currentMarkColorType = MarkType.Default;
            }
            else
            {
                foreach (MeshRenderer mr in gameObject.GetComponentsInChildren<MeshRenderer>())
                {
                    mr.enabled = false;
                }
            }
        }
        

        // Update is called once per frame
        void Update()
        {
#if UNITY_EDITOR || UNITY_STANDALONE
            if (On)
            {
                FollowMouse();
            }
#endif
        }

#region 跟随鼠标着色
        private bool m_drawing = false;
        private int iX, iY;
        private int m_iLastShowOddQX = -1;
        private int m_iLastShowOddQY = -1;
        /// <summary>
        /// 跟随鼠标，标注地表属性
        /// </summary>
        private void FollowMouse()
        {
            if (FairyGUI.Stage.isTouchOnUI)
                return;

            Vector2 vUV;
            bool bHit = m_Coord.TerrainRaycast(Input.mousePosition, out vUV);

            if (false == m_waitForManualMarking)
            {
                if (m_enableDrawing)
                {
                    // 鼠标左键按下开始着色
                    if (Input.GetMouseButtonDown(1))
                        m_drawing = true;
                    // 抬起停止着色
                    else if (Input.GetMouseButtonUp(1))
                        m_drawing = false;
                }

                if (bHit)
                {
                    m_Coord.UVToNearestOddQ(vUV, out iX, out iY);
                    if (iX != m_iLastShowOddQX || iY != m_iLastShowOddQY)
                    {
                        if (m_enableDrawing && m_drawing)
                        {
                            // 如果是空地，不显示任何颜色，将其从标记列表中剔除
                            if (m_currentMarkColorType == MarkType.OpenSpace)
                                UnMarkGrid(iX, iY);
                            else
                                MarkGrid(iX, iY, m_currentMarkColorType);

                            if (m_bGridIsDirty)
                            {
                                DrawMarkedGrids();
                            }
                        }

                        // 显示当前格子坐标，隐藏上个格子坐标
                        ShowNumberCoord(iX, iY);
                        HideNumberCoord(m_iLastShowOddQX, m_iLastShowOddQY);

                        m_iLastShowOddQX = iX;
                        m_iLastShowOddQY = iY;
                    }
                }
            }
        }
#endregion

        
        private readonly Dictionary<int, MarkType> m_gridsToDraw = new Dictionary<int, MarkType>();
        private bool m_bGridIsDirty = false;
        private int m_indexToDraw = 0;
        private int m_indexToRemove = 0;
        /// <summary>
        /// 标记格子
        /// </summary>
        /// <param name="iOddQX"></param>
        /// <param name="iOddQY"></param>
        /// <param name="markType"></param>
        private void MarkGrid(int iOddQX, int iOddQY, MarkType markType)
        {
            if (iOddQX < 0 || iOddQX >= m_iGridWidth || iOddQY < 0 || iOddQY >= m_Coord.m_iGridHeight)
            {
                return;
            }

            m_indexToDraw = iOddQX*m_Coord.m_iGridHeight + iOddQY;
            if (!m_gridsToDraw.ContainsKey(m_indexToDraw))
                m_gridsToDraw.Add(m_indexToDraw, markType);
            else
                m_gridsToDraw[m_indexToDraw] = markType;

            m_bGridIsDirty = true;
        }
        /// <summary>
        /// 消除格子标记
        /// </summary>
        /// <param name="iOddQX"></param>
        /// <param name="iOddQY"></param>
        private void UnMarkGrid(int iOddQX, int iOddQY)
        {
            if (iOddQX < 0 || iOddQX >= m_iGridWidth || iOddQY < 0 || iOddQY >= m_Coord.m_iGridHeight)
            {
                return;
            }

            m_indexToRemove = iOddQX * m_Coord.m_iGridHeight + iOddQY;
            m_bGridIsDirty = m_gridsToDraw.Remove(m_indexToRemove);
        }

#region 从Coordinate抄来的

        private Mesh m_pDrawingMesh = null;
        private readonly List<Vector3> m_v3PenetratePoses = new List<Vector3>();
        private readonly List<Vector3> m_v3PenetrateNors = new List<Vector3>();
        private readonly List<Vector2> m_v3PenetrateUVs = new List<Vector2>();
        private readonly List<Color> m_v3PenetrateColors = new List<Color>();
        private readonly List<int> m_iPenetrateIndexes = new List<int>();

        private void DrawMarkedGrids(bool redraw=false)
        {
            if (m_indexToRemove > 0 || redraw)
            {
                m_v3PenetratePoses.Clear();
                m_v3PenetrateNors.Clear();
                m_v3PenetrateUVs.Clear();
                m_iPenetrateIndexes.Clear();
                m_v3PenetrateColors.Clear();
            }
            if (null == m_pDrawingMesh)
            {
                Material mat = new Material(Shader.Find("LPCFramework/TerrainToMeshInteract"));
                mat.SetTexture("_MainTex", m_Coord.gameObject.GetComponent<MeshRenderer>().sharedMaterial.mainTexture);
                m_pDrawingMesh = new Mesh
                {
                    vertices = m_v3PenetratePoses.ToArray(),
                    normals = m_v3PenetrateNors.ToArray(),
                    uv = m_v3PenetrateUVs.ToArray(),
                    colors = m_v3PenetrateColors.ToArray()
                };
                m_pDrawingMesh.SetIndices(m_iPenetrateIndexes.ToArray(), MeshTopology.Triangles, 0, false);
                m_pDrawingMesh.UploadMeshData(false);

                gameObject.GetComponent<MeshFilter>().sharedMesh = m_pDrawingMesh;
                gameObject.GetComponent<MeshRenderer>().sharedMaterial = mat;
            }
            
            // 删除一个格子，重画所有的
            if (m_indexToRemove > 0 || redraw)
            {
                m_indexToRemove = 0;

                foreach (int index in m_gridsToDraw.Keys)
                    UpdatePenetrateIndexes(index);
            }
            else
                UpdatePenetrateIndexes(m_indexToDraw);

            m_pDrawingMesh.SetIndices(new int[0], MeshTopology.Triangles, 0, false);
            m_pDrawingMesh.vertices = m_v3PenetratePoses.ToArray();
            m_pDrawingMesh.normals = m_v3PenetrateNors.ToArray();
            m_pDrawingMesh.uv = m_v3PenetrateUVs.ToArray();
            m_pDrawingMesh.colors = m_v3PenetrateColors.ToArray();
            m_pDrawingMesh.SetIndices(m_iPenetrateIndexes.ToArray(), MeshTopology.Triangles, 0, false);
            m_pDrawingMesh.RecalculateBounds();
            m_pDrawingMesh.UploadMeshData(false);

            m_bGridIsDirty = false;
        }

        private void UpdatePenetrateIndexes(int index)
        {
            // 如果没有此下标
            if (!m_gridsToDraw.ContainsKey(index))
                return;

            int iVertexBufferStart = m_v3PenetratePoses.Count;
            for (int k = 0; k < 6; ++k)
            {
                Vector3 pos1, nor1;
                int iX = index / m_Coord.m_iGridHeight;
                int iY = index % m_Coord.m_iGridHeight;

                Vector2 vNewUV = m_Coord.OddQToUV(iX, iY) + m_vUVOffset[k];
                m_Coord.GetPosNormal(vNewUV, 0.1f, out pos1, out nor1);
                m_v3PenetratePoses.Add(pos1);
                m_v3PenetrateNors.Add(nor1);
                m_v3PenetrateUVs.Add(vNewUV);
                m_v3PenetrateColors.Add(m_colorType[(int)m_gridsToDraw[index]]);
            }

            m_iPenetrateIndexes.Add(iVertexBufferStart + 2);
            m_iPenetrateIndexes.Add(iVertexBufferStart + 1);
            m_iPenetrateIndexes.Add(iVertexBufferStart + 0);

            m_iPenetrateIndexes.Add(iVertexBufferStart + 3);
            m_iPenetrateIndexes.Add(iVertexBufferStart + 2);
            m_iPenetrateIndexes.Add(iVertexBufferStart + 0);

            m_iPenetrateIndexes.Add(iVertexBufferStart + 5);
            m_iPenetrateIndexes.Add(iVertexBufferStart + 3);
            m_iPenetrateIndexes.Add(iVertexBufferStart + 0);

            m_iPenetrateIndexes.Add(iVertexBufferStart + 4);
            m_iPenetrateIndexes.Add(iVertexBufferStart + 3);
            m_iPenetrateIndexes.Add(iVertexBufferStart + 5);
        }

#endregion

        private readonly Dictionary<int, TextMesh> m_dicNumbers = new Dictionary<int, TextMesh>();

        private void ShowNumberCoord(int iOddQX, int iOddQY)
        {
            if (iOddQX < 0 || iOddQX >= m_iGridWidth || iOddQY < 0 || iOddQY >= m_Coord.m_iGridHeight)
            {
                return;
            }

            if (!m_dicNumbers.ContainsKey(iOddQX*m_Coord.m_iGridHeight + iOddQY) 
             || null == m_dicNumbers[iOddQX*m_Coord.m_iGridHeight + iOddQY])
            {
                GameObject go = m_NumberPool.NextAvailableObject();
                go.SetActive(true);
                Vector3 vPos, vNor;
                m_Coord.GetPosNormal(m_Coord.OddQToUV(iOddQX, iOddQY), 0.5f, out vPos, out vNor);
                go.transform.position = vPos;
                go.transform.LookAt(2.0f * vPos - Camera.main.transform.position);

                m_dicNumbers[iOddQX*m_Coord.m_iGridHeight + iOddQY] = go.GetComponent<TextMesh>();
                m_dicNumbers[iOddQX*m_Coord.m_iGridHeight + iOddQY].text = iOddQX + "," + iOddQY;
            }
        }

        private void HideNumberCoord(int iOddQX, int iOddQY)
        {
            if (iOddQX < 0 || iOddQX >= m_iGridWidth || iOddQY < 0 || iOddQY >= m_Coord.m_iGridHeight)
            {
                return;
            }

            if (m_dicNumbers.ContainsKey(iOddQX*m_Coord.m_iGridHeight + iOddQY) 
             && null != m_dicNumbers[iOddQX*m_Coord.m_iGridHeight + iOddQY])
            {
                GameObject go = m_dicNumbers[iOddQX*m_Coord.m_iGridHeight + iOddQY].gameObject;
                m_dicNumbers[iOddQX*m_Coord.m_iGridHeight + iOddQY] = null;
                m_NumberPool.ReturnObjectToPool("Number", go);
            }
        }

    }

}

