using System.Collections.Generic;
using FairyGUI;
using UnityEngine;

namespace LPCFramework
{
    public enum ECityRange : byte
    {
        None,
        Grid1,
        Grid2,
        Grid3,
        Grid4,
        Grid5,
        Grid6,
        Grid7,
        Grid8,

        Max,
    }

    public enum EBuildingType : byte
    {
        None = 0,
        //-- 主城--
        MainCity = 1,
        //-- 行营--
        Campsite = 12,
        //-- 铜矿--
        GoldMine = 21,
        //-- 农田--
        Cropland = 22,
        //-- 伐木场--
        Sawmill = 23,
        //-- 采石场--
        StonePit = 24,
    }

    /// <summary>
    /// 主城升级
    /// </summary>
    public enum ECityBuildingState : byte
    {
        Grade1,
        Grade2,
        Grade3,
        Max,
    }

    /// <summary>
    /// 资源点状态
    /// </summary>
    public enum EResourceBuildingState : byte
    {
        Empty,
        Half,
        Full,
        Max,
    }

    public class TerrainGroundItem : MonoBehaviour
    {
        #region 势力范围

        public static readonly byte[][,] m_byOccupyGrids =
        {
            new byte[,] //0
            {
                {0,0,0,0,0,0,0},
                {0,0,0,0,0,0,0},
                {0,0,0,0,0,0,0},
                {0,0,0,1,0,0,0},
                {0,0,0,0,0,0,0},
                {0,0,0,0,0,0,0},
                {0,0,0,0,0,0,0},
            },
            new byte[,] //1
            {
                {0,0,0,0,0,0,0},
                {0,0,0,1,0,0,0},
                {0,0,0,1,1,0,0},
                {0,1,1,1,1,1,0},
                {0,0,0,1,1,0,0},
                {0,0,0,1,0,0,0},
                {0,0,0,0,0,0,0},
            },

            new byte[,] //2
            {
                {0,0,0,0,0,0,0},
                {0,0,0,1,0,0,0},
                {0,0,1,1,1,1,0},
                {0,1,1,1,1,1,0},
                {0,0,1,1,1,1,0},
                {0,0,0,1,0,0,0},
                {0,0,0,0,0,0,0},
            },

            new byte[,] //3
            {
                {0,0,0,0,0,0,0},
                {0,0,1,1,1,0,0},
                {0,0,1,1,1,1,0},
                {0,1,1,1,1,1,0},
                {0,0,1,1,1,1,0},
                {0,0,1,1,1,0,0},
                {0,0,0,0,0,0,0},
            },

            new byte[,] //4
            {
                {0,0,0,0,0,0,0},
                {0,1,1,1,1,1,0},
                {0,0,1,1,1,1,0},
                {0,1,1,1,1,1,0},
                {0,0,1,1,1,1,0},
                {0,1,1,1,1,1,0},
                {0,0,0,0,0,0,0},
            },

            new byte[,] //5
            {
                {0,0,0,1,1,0,0},
                {0,1,1,1,1,1,0},
                {0,0,1,1,1,1,0},
                {0,1,1,1,1,1,0},
                {0,0,1,1,1,1,0},
                {0,1,1,1,1,1,0},
                {0,0,0,1,1,0,0},
            },

            new byte[,] //6
            {
                {0,0,1,1,1,1,0},
                {0,1,1,1,1,1,0},
                {0,0,1,1,1,1,0},
                {0,1,1,1,1,1,0},
                {0,0,1,1,1,1,0},
                {0,1,1,1,1,1,0},
                {0,0,1,1,1,1,0},
            },

            new byte[,] //7
            {
                {0,0,1,1,1,1,0},
                {0,1,1,1,1,1,0},
                {0,1,1,1,1,1,1},
                {0,1,1,1,1,1,0},
                {0,1,1,1,1,1,1},
                {0,1,1,1,1,1,0},
                {0,0,1,1,1,1,0},
            },

            new byte[,] //8
            {
                {0,0,1,1,1,1,1},
                {0,1,1,1,1,1,0},
                {0,1,1,1,1,1,1},
                {1,1,1,1,1,1,1},
                {0,1,1,1,1,1,1},
                {0,1,1,1,1,1,0},
                {0,0,1,1,1,1,1},
            },
        };

        /*新的贴图很赞，大小都一样的，所以不再需要这个了，这个注释暂留着
        //这是根据贴图来的
        private static readonly Vector2[] m_pProjectorSizes =
        {
            new Vector2(1.0f, 1.0f),
            new Vector2(1.0f, 1.0f),
            new Vector2(1.0f, 1.0f),
            new Vector2(1.0f, 1.0f),
            new Vector2(1.0f, 1.0f),
            new Vector2(1.0f, 1.0f),
            new Vector2(1.0f, 1.0f),
            new Vector2(1.0f, 1.0f),
        };
        */

        /// <summary>
        /// 当前显示的势力范围
        /// </summary>
        public ECityRange m_eRegion = ECityRange.None;

        /// <summary>
        /// 是否显示了势力范围
        /// </summary>
        /// <returns></returns>
        public bool IsSelected()
        {
            return m_bSelected;
        }

        /// <summary>
        /// 是否是可以显示势力范围的
        /// </summary>
        public bool m_bSelectable;

        /// <summary>
        /// 是否在显示势力范围
        /// </summary>
        protected bool m_bSelected = false;

        /// <summary>
        /// 画projector
        /// </summary>
        public void OnSelected(bool bSelected)
        {
            //Debug.Log(bSelected);
            //我们不在这里画，说不定active是false
            m_bSelected = bSelected;
            m_eModelRange = ECityRange.Max;
        }

        protected ECityRange m_eModelRange = ECityRange.None;
        protected void SetProjectorAs(ECityRange eRange)
        {
            if (null == m_pProjector)
            {
                return;
            }
            m_eModelRange = eRange;
            if (ECityRange.None == eRange)
            {
                m_pProjector.enabled = false;
                return;
            }

            /*
            Vector3 vCenter = Vector3.down * m_Owner.m_fCurveRadius;
            Vector3 vToCenter = vCenter - transform.position;
            Vector3 vUp = Vector3.Cross(vToCenter, Vector3.left);
            */
            m_pProjector._Material = GetMat(eRange,
                null == m_pGI ? 0 : m_pGI.m_iGroundItemUnionId,
                null != m_pGI && (m_Owner.MyCity() == m_pGI.m_iGroundItemId));

            //m_pProjector.material = GetMat(eRange,
            //    null == m_pGI ? 0 : m_pGI.m_iGroundItemUnionId,
            //    null != m_pGI && (m_Owner.MyCity() == m_pGI.m_iGroundItemId));

            m_pProjector.enabled = true;

        }

        //这个是为了给迁城模式那个假城显示边界用的
        public void ForceShowRange(ECityRange range, int iUnion)
        {
            m_pProjector._Material = GetMat(range, iUnion, true);
            //m_pProjector.material = GetMat(range, iUnion, true);            
            m_pProjector.enabled = true;
        }

        private void UpdateSelectedProjector()
        {
            ECityRange eRangeToShow = m_bSelected ? m_eRegion : ECityRange.None;
            if (m_eModelRange != eRangeToShow)
            {
                SetProjectorAs(eRangeToShow);
            }
        }
        #endregion

        #region Serialized Data

        /// <summary>
        /// 如果是主城，放置的是各个级别的主城
        /// 如果是资源点，放置的是各个状态的资源点
        /// </summary>
        public GameObject[] m_pModels;

        /// <summary>
        /// 当前显示的模型
        /// </summary>
        private GameObject m_pModel = null;

        /// <summary>
        /// 势力范围projector
        /// </summary>
        public ShadowProjector m_pProjector;

        /// <summary>
        /// 不同势力范围projector的材质球
        /// </summary>
        public Material[] m_pProjectorMats;

        /// <summary>
        /// 影子用Projector会更省
        /// 和模型的数量一致
        /// </summary>
        public Material[] m_pShadowProjectors;

        /// <summary>
        /// 当前显示的模型对应的Projector
        /// </summary>
        public GameObject m_pShadowProjector = null;

        ///
        /// <summary>
        /// Prefab里保存。自己是什么
        /// </summary>
        public EBuildingType m_eBuildingType;

        /// <summary>
        /// 不去Find了，直接拖到Prefab
        /// </summary>
        public UIPanel m_UIPanel;

        /// <summary>
        /// 用来面朝摄像机
        /// </summary>
        public Transform m_UIRotationBase;

        #endregion

        #region Materials

        /// <summary>
        /// Projector的material像sharedMaterial一样，要染色的话，必须新建一个
        /// </summary>
        private static readonly Dictionary<string, Material> m_MaterialDic = new Dictionary<string, Material>();

        private float m_fShadowMaxSize;
        private float m_fEnlargeStartTime;

        public Material GetMat(ECityRange range, int iUnion, bool bPlayer)
        {
            string sKey = "Union_" + iUnion + "_" + range;
            if (bPlayer)
            {
                sKey = "Player" + range;
            }
            if (!m_MaterialDic.ContainsKey(sKey))
            {
                Material newMat = new Material(m_pProjectorMats[(int)range - 1]);
                if (bPlayer)
                {
                    newMat.SetColor("_Color", m_Owner.m_cPlayerCityProjector);
                }
                else if (m_Owner.MyUnion() > 0 && m_Owner.MyUnion() == iUnion)
                {
                    newMat.SetColor("_Color", m_Owner.m_cPlayerUnionProjector);
                }
                else if (0 == iUnion)
                {
                    newMat.SetColor("_Color", m_Owner.m_cNoUnionProjector);
                }
                else
                {
                    if (iUnion > 1 && m_Owner.m_dicUnionColor.ContainsKey(iUnion))
                    {
                        newMat.SetColor("_Color", m_Owner.m_dicUnionColor[iUnion]);
                    }
                    else
                    {
                        newMat.SetColor("_Color", m_Owner.m_cEnemyUnionProjector);
                    }
                }
                m_MaterialDic.Add(sKey, newMat);
            }
            return m_MaterialDic[sKey];
        }

        #endregion

        #region Interface

        protected TerrainGroundCoordinate m_Owner = null;
        protected GroundItemInfo m_pGI = null;
        public int m_iPosX;
        public int m_iPosY;

        /// <summary>
        /// 这一步可以不用。目前还不清楚大地图上要摆多少个OddQ格子。
        /// 我暂时用一个城市占用一个7个格子，一个树占用一个格子。
        /// 大地图上可以放多少OddQ格子是TerrainGroundCoordinate的Start中设定的。（见TerrainGroundCoordinate.m_iGridHeight）
        /// 因此根据格子的数量决定了格子的大小，决定了城市的大小，以及Projector的大小
        /// 当格子数量是固定的时候，这一步可以干掉
        /// </summary>
        /// <param name="pOwner"></param>
        /// <param name="gi"></param>
        /// <param name="iPosX"></param>
        /// <param name="iPosY"></param>
        /// <param name="iGrade"></param>
        /// <param name="iModel">对于主城，是0-2，对于资源点，其实也是0-2</param>
        public void Initial(TerrainGroundCoordinate pOwner, GroundItemInfo gi, int iPosX, int iPosY, int iGrade, int iModel)
        {
            //如果是重用的，不需要设置orthographicSize
            bool bReUse = null != m_Owner;
            m_Owner = pOwner;
            m_pGI = gi;
            m_iPosX = iPosX;
            m_iPosY = iPosY;
            m_eRegion = (ECityRange)iGrade;
            m_eModelRange = ECityRange.Max;

            //设置投影的大小和朝向
            Vector3 vCenter = Vector3.down * pOwner.m_fCurveRadius;
            Vector3 vToCenter = vCenter - transform.position;

            Vector3 vUp = -(Quaternion.FromToRotation(Vector3.up, -vToCenter.normalized) * Vector3.forward);//Vector3.Cross(vToCenter, Vector3.left);
            if (null != m_pProjector)
            {
                //m_pProjector.transform.LookAt(vCenter, vUp);
                m_pProjector.enabled = false;

                if (!bReUse)
                {
                    //m_pProjector.orthographicSize = m_pProjector.orthographicSize * 3.5f * pOwner.GetHeightSep();

                    m_pProjector.ShadowSize = m_pProjector.ShadowSize * 3.5f * pOwner.GetHeightSep() * 2;//m_pProjector.orthographicSize * 3.5f * pOwner.GetHeightSep();    
                    m_pProjector.FixShadowPos();
                    m_fShadowMaxSize = m_pProjector.ShadowSize;
                }
            }

            //Projector shadow = m_pShadowProjector.GetComponent<Projector>();
            if (!bReUse)
            {
                //不再缩放
                //shadow.orthographicSize = shadow.orthographicSize * pOwner.GetHeightSep();
            }
            //vUp = Vector3.Cross(vToCenter, new Vector3(-0.7f, 0.0f, 0.3f)); //暂且写死，根据光的方向来定，但是光的方向也是死的
            vUp = Vector3.Cross(vToCenter, new Vector3(0.8f, 0.0f, -0.2f));
            //m_pShadowProjector.transform.LookAt(vCenter, vUp);

            #region 设置模型

            m_iCurrentModelIndex = -1;
            SetToModel(iModel);

            #endregion
        }

        /// <summary>
        /// 每次摆出来的时候都要调整下影子projector的方向
        /// </summary>
        public void ResetShadowPos()
        {
            Vector3 vCenter = Vector3.down * m_Owner.m_fCurveRadius;
            Vector3 vToCenter = vCenter - transform.position;
            Projector shadow = m_pShadowProjector.GetComponent<Projector>();
            shadow.orthographicSize = shadow.orthographicSize * m_Owner.GetHeightSep();
            Vector3 vUp = Vector3.Cross(vToCenter, new Vector3(-0.7f, 0.0f, 0.3f)); //暂且写死，根据光的方向来定，但是光的方向也是死的
            m_pShadowProjector.transform.LookAt(vCenter, vUp);
        }

        /// <summary>
        /// 迁城模式下，城市要不断移动，所以需要根据城市新的normal调整projector的朝向。
        /// </summary>
        public void ResetProjectorPos()
        {
            //Vector3 vCenter = Vector3.down * m_Owner.m_fCurveRadius;
            //Vector3 vToCenter = vCenter - transform.position;
            //Vector3 vUp = -(Quaternion.FromToRotation(Vector3.up, -vToCenter.normalized) * Vector3.forward);//Vector3.Cross(vToCenter, Vector3.left);
            //m_pProjector.transform.LookAt(vCenter, vUp);
            m_pProjector.FixShadowPos();
        }

        #endregion

        #region 模型

        private int m_iCurrentModelIndex = -1;

        /// <summary>
        /// 如果是资源点
        /// </summary>
        /// <param name="eState"></param>
        public void SetResourceState(EResourceBuildingState eState)
        {
            SetToModel((int)eState);
        }

        public void SetCityModelGrate(int iGrade)
        {
            SetToModel(iGrade);
        }

        private void SetToModel(int iIndex)
        {
            if (m_iCurrentModelIndex == iIndex)
            {
                return;
            }
            m_iCurrentModelIndex = iIndex;
            m_pModel = m_pModels[iIndex - 1];
            // m_pShadowProjector.GetComponent<Projector>().material = m_pShadowProjectors[iIndex - 1];
            m_pShadowProjector.GetComponent<ShadowProjector>()._Material = m_pShadowProjectors[iIndex - 1];
            for (int i = 0; i < m_pModels.Length; ++i)
            {
                m_pModels[i].SetActive(iIndex - 1 == i);
            }
        }

        #endregion

        #region 资源点冲突

        /// <summary>
        /// 设置资源点是否是冲突的
        /// </summary>
        protected bool m_bPenentrate = false;

        /// <summary>
        /// 资源点是否是冲突的
        /// </summary>
        /// <returns></returns>
        public bool IsPenentrate()
        {
            return m_bPenentrate;
        }

        /// <summary>
        /// 目前模型上资源点是否是冲突的
        /// </summary>
        protected bool m_bModelIsPenentrate = false;

        /// <summary>
        /// 设为冲突状态
        /// </summary>
        /// <param name="bPenentrate"></param>
        /// <param name="bForceRefresh"></param>
        public void OnPenentrate(bool bPenentrate, bool bForceRefresh)
        {
            //我们不在这里画，说不定active是false
            m_bPenentrate = bPenentrate;
            if (bForceRefresh)
            {
                m_bModelIsPenentrate = !m_bPenentrate;
            }
        }

        private void UpdatePenentrate()
        {
            if (m_bModelIsPenentrate != m_bPenentrate)
            {
                m_bModelIsPenentrate = m_bPenentrate;
                //                m_pShadowProjector.GetComponent<Projector>().enabled = !m_bPenentrate;
                m_pShadowProjector.GetComponent<ShadowProjector>().enabled = !m_bPenentrate;
                Renderer[] rs = m_pModel.GetComponentsInChildren<Renderer>(true);

                //TODO 最好是换Material，但是现在的树还有带多个Material的，不建议这么做。等到有正式的模型了再优化这里
                if (rs.Length > 0)
                {
                    for (int i = 0; i < rs.Length; ++i)
                    {
                        //rs[i].material = m_PenentrateMat;
                        for (int j = 0; j < rs[i].materials.Length; ++j)
                        {
                            if (rs[i].materials[j].HasProperty("_Penentrate"))
                            {
                                rs[i].materials[j].SetFloat("_Penentrate", m_bModelIsPenentrate ? 1.0f : 0.0f);
                            }
                            if (rs[i].materials[j].HasProperty("_PenentrateColor"))
                            {
                                rs[i].materials[j].SetColor("_PenentrateColor", m_Owner.m_cPenetration);
                            }
                        }
                    }
                }
            }
        }

        #endregion

        #region UI显示

        //懒惰获取
        private Controller m_Controller;
        private GTextField m_Level;
        private GTextField m_Name;
        private GTextField m_WhiteFlag;
        private GImage m_WhiteFlagTex;
        public void UpdateUIContent(GroundItemInfo gi)
        {
            if (null == m_UIPanel)
            {
                return;
            }

            if (null == m_Controller || null == m_Level || null == m_Name)
            {
                GComponent UI = m_UIPanel.ui;
                UI.SetScale(2.5f, 2.5f);
                m_Controller = UI.GetController("Type_C");
                m_Level = UI.GetChild("txt_ccdengji").asTextField;
                m_Name = UI.GetChild("txt_junzhuming").asTextField;
                m_WhiteFlag = UI.GetChild("TextField_WhiteFlag").asTextField;
                m_WhiteFlagTex = UI.GetChild("Image_WhiteFlag").asImage;
            }

            if (null == m_Controller)
            {
                return;
            }

            // 改颜色，用来标示玩家阵营（0盟友、1中立、2敌人）
            // 检测下type的区间，我就不写了
            m_Controller.selectedIndex = (gi.m_bIsPlayerMainCity || (m_Owner.MyUnion() > 0 && gi.m_iGroundItemUnionId == m_Owner.MyUnion()))
                ? 0 : (0 == gi.m_iGroundItemUnionId) ? 1 : 2;

            // 改内容
            if (null != m_Level)
            {
                m_Level.text = gi.m_iItemGrade.ToString();
            }

            string content = string.Format("[{0}]{1}", gi.m_sUnionFlagName, gi.m_sPlayerName);
            if (string.IsNullOrEmpty(gi.m_sUnionFlagName))
            {
                content = gi.m_sPlayerName;
            }

            if (null != m_Name)
            {
                m_Name.text = content;
            }

            if (null != m_WhiteFlag)
            {
                m_WhiteFlag.text = gi.m_sWhiteFlag;
            }

            m_WhiteFlagTex.visible = !string.IsNullOrEmpty(gi.m_sWhiteFlag);
        }

        #endregion

        public void Update()
        {
            #region 冲突的资源点

            UpdatePenentrate();

            #endregion

            #region 势力范围

            UpdateSelectedProjector();

            #endregion

            if (null != m_UIRotationBase)
            {
                m_UIRotationBase.transform.rotation = Camera.main.transform.rotation;
            }
        }
    }
}