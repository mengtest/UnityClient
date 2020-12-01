using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Random = UnityEngine.Random;

namespace LPCFramework
{
    public class TerrainParameters
    {
        // -- 多点触控参数
        public static int MAX_TOUCH_COUNT = 5;
        public static int INVALID_TOUCH_ID = -99;
        public static int MOUSE_TOUCH_ID = 99;
        public static float TOUCH_STAY = 0.1f;
        public static float HOLD_TIME_CHECK = 0.8f;
        public static float MOVE_DISTANCE_CHECK = 0.015f;

        // -- 滑动移动速度参数
        public static float CAMERA_TOUCH_MOVE_MIN_SPEED = 0.04f;
        public static float CAMERA_TOUCH_MOVE_MAX_SPEED = 0.15f;
        public static int CAMERA_TOUCH_MOVE_DELTA_SPEED = 15;

        // -- 连线object池大小
        public static int LINE_POOL_MIN = 3;
        public static int LINE_POOL_MAX = 10;

        // -- 主城object池大小
        public static int MAINCITY_POOL_MIN = 50;
        public static int MAINCITY_POOL_MAX = 100;

        // -- 金矿object池大小
        public static int GOLDMINE_POOL_MIN = 1;
        public static int GOLDMINE_POOL_MAX = 4;

        // -- 农田object池大小
        public static int CROPLAND_POOL_MIN = 1;
        public static int CROPLAND_POOL_MAX = 4;

        // -- 伐木场object池大小
        public static int SAWMILL_POOL_MIN = 1;
        public static int SAWMILL_POOL_MAX = 4;

        // -- 采石场object池大小
        public static int STONEPIT_POOL_MIN = 1;
        public static int STONEPIT_POOL_MAX = 4;

        // -- 行营object池大小
        public static int CAMPSITE_POOL_MIN = 5;
        public static int CAMPSITE_POOL_MAX = 15;

        // -- 陡坡的系数
        public static float SLOPE_RATIO1 = 0.85f;
        public static float SLOPE_RATIO2 = 0.96f;

        // -- GoundCityModelIndex
        public static int CITY_MODEL_MIN_INDEX = 1;
        public static int CITY_MODEL_MAX_INDEX = 3;

        // -- Color
        public static Color PLAYR_CITY_PROJECTOR_COLOR = Color.green;
        public static Color PLAYR_UNION_PROJECTOR_COLOR = Color.blue;
        public static Color NO_UNION_PROJECTOR_COLOR = Color.yellow;
        public static Color ENEMY_UNION_PROJECTOR_COLOR = Color.red;
        public static Color PENETRATION_COLOR = new Color(212.0f / 255.0f, 100.0f / 255.0f, 100.0f / 255.0f, 1.0f);
        public static Color CAN_PUT_CITY_COLOR = new Color(1.0f, 1.0f, 1.0f, 0.3f);
        public static Color CAN_NOT_PUT_CITY_COLOR = new Color(1.0f, 0.0f, 0.0f, 0.5f);
        public static Color CAN_PUT_CITY_GI_COLOR = new Color(0.0f, 1.0f, 0.0f, 0.5f);
        public static Color CAN_NOT_PUT_CITY_GUI_COLOR = new Color(0.5f, 0.3f, 0.3f, 0.5f);
        public static Vector4 PUT_CITY_SHADER_PARAM = new Vector4(200.0f, 0.5f, 0.0f, 0.0f);

        public static List<TerrainLuaDelegates.BlockPointInfo> BlockPointInfo;

        public static void SetParameter(
            int maxTouchCount,
            int invalidTouchId,
            int mouseTouchId,
            float touchStay,
            float holdTimeCheck,
            float moveDistanceCheck,
            float cameraTouchMoveMinSpeed,
            float cameraTouchMoveMaxSpeed,
            int cameraTouchMoveDeltaSpeed,
            int linePoolMin,
            int linePoolMax,
            int maincityPoolMin,
            int maincityPoolMax,
            int goldminePoolMin,
            int goldminePoolMax,
            int croplandPoolMin,
            int croplandPoolMax,
            int sawmillPoolMin,
            int sawmillPoolMax,
            int stonepitPoolMin,
            int stonepitPoolMax,
            int campsitePoolMin,
            int campsitePoolMax,
            float slopeRatio1,
            float slopeRatio2,
            int cityModelMinIndex,
            int cityModelMaxIndex,

            Color playerCityProjectorColor,
            Color playerUnionProjectorColor,
            Color noUnionProjectorColor,
            Color enemyUnionProjectorColor,
            Color penetrationColor,
            Color canPutCityColor,
            Color canNotPutCityColor,
            Color canPutCityGiColor,
            Color canNotPutCityGiColor,
            Vector4 putCityShaderParam,
            List<TerrainLuaDelegates.BlockPointInfo> block
        )
        {
            MAX_TOUCH_COUNT = maxTouchCount;
            INVALID_TOUCH_ID = invalidTouchId;
            MOUSE_TOUCH_ID = mouseTouchId;
            TOUCH_STAY = touchStay;
            HOLD_TIME_CHECK = holdTimeCheck;
            MOVE_DISTANCE_CHECK = moveDistanceCheck;

            CAMERA_TOUCH_MOVE_MIN_SPEED = cameraTouchMoveMinSpeed;
            CAMERA_TOUCH_MOVE_MAX_SPEED = cameraTouchMoveMaxSpeed;
            CAMERA_TOUCH_MOVE_DELTA_SPEED = cameraTouchMoveDeltaSpeed;

            LINE_POOL_MIN = linePoolMin;
            LINE_POOL_MAX = linePoolMax;

            MAINCITY_POOL_MIN = maincityPoolMin;
            MAINCITY_POOL_MAX = maincityPoolMax;

            GOLDMINE_POOL_MIN = goldminePoolMin;
            GOLDMINE_POOL_MAX = goldminePoolMax;

            CROPLAND_POOL_MIN = croplandPoolMin;
            CROPLAND_POOL_MAX = croplandPoolMax;

            SAWMILL_POOL_MIN = sawmillPoolMin;
            SAWMILL_POOL_MAX = sawmillPoolMax;

            STONEPIT_POOL_MIN = stonepitPoolMin;
            STONEPIT_POOL_MAX = stonepitPoolMax;

            CAMPSITE_POOL_MIN = campsitePoolMin;
            CAMPSITE_POOL_MAX = campsitePoolMax;

            SLOPE_RATIO1 = slopeRatio1;
            SLOPE_RATIO2 = slopeRatio2;

            CITY_MODEL_MIN_INDEX = cityModelMinIndex;
            CITY_MODEL_MAX_INDEX = cityModelMaxIndex;

            PLAYR_CITY_PROJECTOR_COLOR = playerCityProjectorColor;
            PLAYR_UNION_PROJECTOR_COLOR = playerUnionProjectorColor;
            NO_UNION_PROJECTOR_COLOR = noUnionProjectorColor;
            ENEMY_UNION_PROJECTOR_COLOR = enemyUnionProjectorColor;
            PENETRATION_COLOR = penetrationColor;
            CAN_PUT_CITY_COLOR = canPutCityColor;
            CAN_NOT_PUT_CITY_COLOR = canNotPutCityColor;
            CAN_PUT_CITY_GI_COLOR = canPutCityGiColor;
            CAN_NOT_PUT_CITY_GUI_COLOR = canNotPutCityGiColor;
            PUT_CITY_SHADER_PARAM = putCityShaderParam;

            BlockPointInfo = block;
        }
    }

    public class GroundItemInfo
    {
        public byte m_byGroundItemType;             //1-City, 21-GoldMine, 22-Cropland...
        public int m_iGroundItemId;                 //ID
        public string m_sGroundItemOwner;           //势力ID
        public string m_sPlayerName;                //势力玩家名
        public int m_iPlayerLevel;                  //势力玩家等级
        public int m_iGroundItemUnionId;            //势力所属联盟的ID
        public string m_sUnionFlagName;             //联盟旗号
        public string m_sWhiteFlag;                 //被插白旗的联盟旗号
        public bool m_bIsPlayerMainCity;            //是否玩家主城
        public Vector3 m_vGroundItemPos;            //世界坐标
        public Vector3 m_vGroundItemRotationUp;     //在地面上应该的normal
        public Vector3 m_vGroundItemRotationLook;   //在地面上应该的z朝向
        public Vector3 m_vGroundItemScale;          //在地面上应该的大小
        public bool m_bPenetrate;                   //（如果不是城市）是否在冲突格子中
        public bool m_bSelected;                    //（如果是城市）是否处于显示城市范围状态
        public int m_iItemGrade;                    //（如果是城市），城市的等级
        public int m_iOddQX;                        //坐标
        public int m_iOddQY;
        public int m_iModelIndex;                   //对于主城，就是各个级别的主城模型(1-3)，对于资源点，是空，半，满，分别对应1,2,3
        public TerrainGroundItem m_Script;          //画面中显示的GameObject身上（控制projector）的脚本，如果不在画面中显示则为空
        public GameObject m_GameObject;             //画面中显示的GameObject，如果不在画面中显示则为空

        //优化
        public GroundItemZoneLevel2 m_Zone;         //和static item一样了，分区判断显示隐藏
        public GameObjectPool m_Pool;               //不用每次都去根据type找。不会变
    }

    //用来优化两层
    public class GroundItemZoneLevel1
    {
        public static int ZoneWidth = 4;
        public Vector2 m_vLTCorner;
        public Vector2 m_vRTCorner;
        public Vector2 m_vLBCorner;
        public Vector2 m_vRBCorner;

        public Vector3 m_v3LTCorner;
        public Vector3 m_v3RTCorner;
        public Vector3 m_v3LBCorner;
        public Vector3 m_v3RBCorner;

        public Vector3 m_v3Center;
        public float m_fRadius;

        public GroundItemZoneLevel2[] m_List;

        public bool m_bSleeped = false;

        public void Sleep()
        {
            m_bSleeped = true;
            for (int i = 0; i < m_List.Length; ++i)
            {
                m_List[i].m_bShouldCheck = false;
            }
        }
    }

    //用来优化
    public class GroundItemZoneLevel2
    {
        public static int ZoneWidth = 4;
        public static int ZoneTotalSize = GroundItemZoneLevel1.ZoneWidth * ZoneWidth;

        public Vector2 m_vLTCorner;
        public Vector2 m_vRTCorner;
        public Vector2 m_vLBCorner;
        public Vector2 m_vRBCorner;

        public Vector3 m_v3LTCorner;
        public Vector3 m_v3RTCorner;
        public Vector3 m_v3LBCorner;
        public Vector3 m_v3RBCorner;

        public Vector3 m_v3Center;
        public float m_fRadius;

        public readonly List<TerrainGroundStaticItem> m_pItems = new List<TerrainGroundStaticItem>();
        public readonly List<GroundItemInfo> m_pDynamicItems = new List<GroundItemInfo>();

        public bool m_bSleeped = false;
        public bool m_bShouldCheck = false;

        public void Sleep()
        {
            m_bSleeped = true;
            for (int i = 0; i < m_pItems.Count; ++i)
            {
                if (m_pItems[i].gameObject.activeSelf)
                {
                    //set active好像还有点耗，或许紧紧enable renderer比较好
                    m_pItems[i].gameObject.SetActive(false);
                }
            }

            for (int i = 0; i < m_pDynamicItems.Count; ++i)
            {
                GroundItemInfo gi = m_pDynamicItems[i];
                if (null != gi.m_GameObject)
                {
                    gi.m_bPenetrate = gi.m_Script.IsPenentrate(); //这一步似乎没必要
                    gi.m_bSelected = gi.m_Script.IsSelected(); //这一步似乎没必要
                    gi.m_Pool.ReturnObjectToPool(((EBuildingType)gi.m_byGroundItemType).ToString(), gi.m_GameObject);
                    gi.m_GameObject = null;
                    gi.m_Script = null;
                }
            }
        }
    }

    public enum EMoveBuidingType
    {
        None,
        MoveMainCity,
        MoveCampsite,
    }
    /// <summary>
    /// 如果需要获取坐标，需要看下
    /// m_iGridHeight
    /// OddQToUV函数
    /// GetPosNormal函数
    /// GetPosNormalCurve函数
    /// </summary>
    public class TerrainGroundCoordinate : MonoBehaviour
    {
        public readonly List<GroundItemInfo> m_GroundItemInfos = new List<GroundItemInfo>();
        public readonly List<GroundItemInfo> m_CityGroundItemInfos = new List<GroundItemInfo>();

        public static TerrainGroundCoordinate m_Intantance = null;


        private float m_fTreeGrowStartTime;
        private float TREE_GROW_DURATION = 5;

        /// <summary>
        /// 如果设为false，则是可以直接在WorldMap场景运行
        /// </summary>
        public bool m_bControlUsingLua = false;
        private bool m_bEnterBigMap = false;
        public void EnterBigMap(bool bEnter)
        {
            m_bEnterBigMap = bEnter;
        }

        /// <summary>
        /// 是否是曲面。
        /// 对于曲面，需要填写：
        /// m_fCurveRadius, m_fCurveDegree, m_fGroundSize
        /// 对于平面，需要填写：什么都不用填写！
        /// </summary>
        public bool m_bCurve;
        public float m_fCurveRadius;
        public float m_fCurveDegree;
        public float m_fGroundSize;

        private float m_fMinHeight;
        private float m_fMaxHeight;

        //public int m_iVertexCount;

        //public float m_fWaterHeight;

        // 雾效最小最大值
        private Vector2 m_vFogDistance;

        #region Camera Parameters

        public Vector2 m_vHeightMinMax;
        public Vector3 m_vCameraDir;
        public Vector3 m_vCameraPos;
        public Vector2 m_vPlannerLeft;
        public Vector2 m_vPlannerUp;

        public void SetCurrentCameraParameter(Camera theCamera)
        {
            if (m_bCurve)
            {
                //我们移动Camera的时候，是不要随着地面起伏的，所以
                //设定camera的碰撞检测用的是标准球体，半径为m_fCurveRadius
                Ray ray = new Ray(theCamera.transform.position, theCamera.transform.forward);
                Vector3 vStart = ray.GetPoint(0.0F);
                Vector3 vCenter = Vector3.down * m_fCurveRadius;
                float fRadius = m_fCurveRadius;
                Vector3 vDown = (vCenter - vStart).normalized;
                float fCos = Vector3.Dot(vDown, ray.direction);
                if (fCos < 0.0f)
                {
                    Debug.LogError("现在的摄像机中心离开了地面?");
                    return;
                }
                float fDist = (vCenter - vStart).magnitude * fCos;
                Vector3 midPos = ray.GetPoint(fDist);
                float fMidPosDist = (midPos - vCenter).magnitude;
                if (fMidPosDist > fRadius)
                {
                    Debug.LogError("现在的摄像机中心离开了地面?");
                    return;
                }

                float fRealDist = fDist - Mathf.Sqrt(fRadius * fRadius - fMidPosDist * fMidPosDist);
                Vector3 vGroundPos = ray.GetPoint(fRealDist); //这是在m_fCurveRadius半径的球面上的点

                Vector3 vGroundNormal = vGroundPos - new Vector3(0.0f, -m_fCurveRadius, 0.0f);
                vGroundNormal.Normalize();
                theCamera.transform.LookAt(theCamera.transform.forward + theCamera.transform.position, vGroundNormal);

                Vector3 vDelta = vGroundPos - theCamera.transform.position;
                m_vCameraDir = -vDelta.normalized;

                Quaternion rotBack = Quaternion.FromToRotation(vGroundNormal, Vector3.up);
                m_vCameraDir = rotBack * m_vCameraDir;
                m_vCameraPos.z = vDelta.magnitude;
                m_vHeightMinMax = new Vector2(m_vCameraPos.z * 0.5f, m_vCameraPos.z * 1.5f);

                Vector2 vUv = PosToUV(vGroundPos);
                m_vCameraPos.x = (vUv.x - 0.5f) * m_fGroundSize;
                m_vCameraPos.y = (vUv.y - 0.5f) * m_fGroundSize;

                Vector3 vLeft = -theCamera.transform.right;
                Vector3 vUp = -theCamera.transform.forward;
                vLeft = -Vector3.Cross(Vector3.Cross(vLeft, Vector3.up), Vector3.up).normalized;
                vUp = -Vector3.Cross(Vector3.Cross(vUp, Vector3.up), Vector3.up).normalized;
                m_vPlannerLeft = new Vector2(vLeft.x, vLeft.z).normalized;
                m_vPlannerUp = new Vector2(vUp.x, vUp.z).normalized;

                //float fDegreeX = m_vCameraPos.x*m_fCurveDegree/m_fGroundSize;
                //float fDegreeY = m_vCameraPos.y*m_fCurveDegree/m_fGroundSize;
                //Vector3 vNormal = (Quaternion.AngleAxis(fDegreeX, new Vector3(0.0f, 0.0f, -1.0f))*
                //                   Quaternion.AngleAxis(fDegreeY, new Vector3(1.0f, 0.0f, 0.0f)))*Vector3.up;
                //Vector3 vCameraDir = (Quaternion.AngleAxis(fDegreeX, new Vector3(0.0f, 0.0f, -1.0f))*
                //                      Quaternion.AngleAxis(fDegreeY, new Vector3(1.0f, 0.0f, 0.0f)))*m_vCameraDir;
                //Vector3 vGround = vNormal*m_fCurveRadius - Vector3.up*m_fCurveRadius;

            }
            else
            {
                //摄像机的位置基于"ground size"计算
                float fcos = Vector3.Dot(theCamera.transform.forward, Vector3.down);
                if (fcos < 0.0f)
                {
                    Debug.LogError("现在的摄像机中心离开了地面?");
                    return;
                }
                float fLength = theCamera.transform.position.y / fcos;
                Vector3 vGround = theCamera.transform.position + theCamera.transform.forward * fLength;
                m_vCameraDir = (theCamera.transform.position - vGround);
                m_vCameraPos.z = m_vCameraDir.magnitude;
                m_vCameraDir.Normalize();
                m_vHeightMinMax = new Vector2(m_vCameraPos.z * 0.5f, m_vCameraPos.z * 1.5f);

                //vGround = new Vector3(m_vCameraPos.x, 0.0f, m_vCameraPos.y);
                //Camera.main.transform.position = vGround + m_vCameraDir * m_vCameraPos.z;
                //Camera.main.transform.LookAt(vGround);
                theCamera.transform.LookAt(theCamera.transform.forward + theCamera.transform.position, Vector3.up);

                Vector3 vLeft = -theCamera.transform.right;
                Vector3 vUp = -theCamera.transform.forward;
                vLeft = -Vector3.Cross(Vector3.Cross(vLeft, Vector3.up), Vector3.up).normalized;
                vUp = -Vector3.Cross(Vector3.Cross(vUp, Vector3.up), Vector3.up).normalized;
                m_vPlannerLeft = new Vector2(vLeft.x, vLeft.z).normalized;
                m_vPlannerUp = new Vector2(vUp.x, vUp.z).normalized;
            }

            Debug.Log("摄像机参数设置完毕,需要Apply到prefab和保存场景");
        }

        private Vector4 m_vCameraMotionParameters = new Vector4(0.02f, 5.0f, 625.0f, 0.0f);

        public void SetCameraParameters(float fMotion, float fAcc, float fIsPressCheck)
        {
            //m_vHeightMinMax = new Vector2(fMinHeight, fMaxHeight);
            //m_vCameraPos.z = fHeight;
            //m_vCameraDir = vDir;
            m_vCameraMotionParameters.x = fMotion;
            m_vCameraMotionParameters.y = fAcc;
            m_vCameraMotionParameters.z = fIsPressCheck * fIsPressCheck;
        }

        #endregion

        public GameObject m_pArrawPrefab;
        private GameObjectPool m_pLinePool = null;

        public GameObject m_pCityPrefab;
        public GameObject m_pSawmillPrefab;
        public GameObject m_pGoldMinePrefab;
        public GameObject m_pCroplandPrefab;
        public GameObject m_pStonePitPrefab;
        public GameObject m_pCampsitePrefab;

        private readonly Dictionary<byte, GameObjectPool> m_pGroundItemPool = new Dictionary<byte, GameObjectPool>(new ByteEqualityComparer());

        //我们换用Collider，不再用Heightmap
        //public Texture2D m_pHeightTexture;

        //正六边形，Odd-Q, 给出Height可以算出Width (通常大于Height w=h*sqrt(3)/1.5)
        public int m_iGridHeight = 100;
        //主城区域到边界的距离.
        public int m_iDistanceFromEdge = 10;
        public int m_iSpawnCityCount = 100;
        public int m_iSpawnTreeCount = 300;
        public float m_fFogDistance = 80.0f;

        [HideInInspector] public byte[,] m_byOccupy;
        [HideInInspector] private byte[,] m_byOccupyGround;
        [HideInInspector] public List<int>[] m_iCityIndexTable;

        private int m_iGridWidth = 1;

        private int m_iMainCityWidthBegin = 0;
        private int m_iMainCityWidthEnd = 0;
        private int m_iMainCityHeightBegin = 0;
        private int m_iMainCityHeightEnd = 0;


        public int GetGridWidth()
        {
            return m_iGridWidth;
        }

        #region 查询

        private readonly Dictionary<int, GroundItemInfo> m_pSelectableTable = new Dictionary<int, GroundItemInfo>(new IntEqualityComparer());
        private readonly Dictionary<int, GroundItemInfo> m_pUnselectableTable = new Dictionary<int, GroundItemInfo>(new IntEqualityComparer());
        private readonly Dictionary<int, GroundItemInfo> m_pSelectableTableById = new Dictionary<int, GroundItemInfo>(new IntEqualityComparer());
        private readonly Dictionary<int, GroundItemInfo> m_pUnselectableTableById = new Dictionary<int, GroundItemInfo>(new IntEqualityComparer());

        private readonly Dictionary<string, List<int>> m_InflenceIdToCities = new Dictionary<string, List<int>>();

        private int GetFirstCityIdByInflence(string sInf)
        {
            if (string.IsNullOrEmpty(sInf))
            {
                return -1;
            }
            List<int> cities;
            if (m_InflenceIdToCities.TryGetValue(sInf, out cities))
            {
                if (null != cities && cities.Count > 0)
                {
                    return cities[0];
                }
            }
            return -1;
        }

        public GroundItemInfo GetSelectableByPos(int iOddQX, int iOddQY)
        {
            if (iOddQX < 0 || iOddQX >= m_iGridWidth
             || iOddQY < 0 || iOddQY >= m_iGridHeight)
            {
                return null;
            }
            GroundItemInfo ret;
            m_pSelectableTable.TryGetValue(iOddQX * m_iGridHeight + iOddQY, out ret);
            return ret;
        }

        public GroundItemInfo GetUnSelectableByPos(int iOddQX, int iOddQY)
        {
            if (iOddQX < 0 || iOddQX >= m_iGridWidth
             || iOddQY < 0 || iOddQY >= m_iGridHeight)
            {
                return null;
            }

            GroundItemInfo ret;
            m_pUnselectableTable.TryGetValue(iOddQX * m_iGridHeight + iOddQY, out ret);

            if (null == ret)
            {
                //可能是一个属于某个城市的地面
                if (null != m_iCityIndexTable[iOddQX * m_iGridHeight + iOddQY] && m_iCityIndexTable[iOddQX * m_iGridHeight + iOddQY].Count > 0)
                {
                    Vector3 vPos, vNor;
                    GetPosNormal(OddQToUV(iOddQX, iOddQY), 0.0f, out vPos, out vNor);
                    GroundItemInfo ret_gi = new GroundItemInfo
                    {
                        m_byGroundItemType = 0,
                        m_iGroundItemId = m_iCityIndexTable[iOddQX * m_iGridHeight + iOddQY][0],
                        m_sGroundItemOwner = m_pSelectableTableById[m_iCityIndexTable[iOddQX * m_iGridHeight + iOddQY][0]].m_sGroundItemOwner,
                        m_vGroundItemPos = vPos, //世界坐标
                        m_bPenetrate = IsConfict(m_iCityIndexTable[iOddQX * m_iGridHeight + iOddQY]), // m_iCityIndexTable[iOddQX*m_iGridHeight + iOddQY].Count > 1,
                        m_iOddQX = iOddQX,
                        m_iOddQY = iOddQY,
                    };
                    GroundItemInfo ownerCity;
                    if (m_pSelectableTableById.TryGetValue(ret_gi.m_iGroundItemId, out ownerCity))
                    {
                        ret_gi.m_sGroundItemOwner = ownerCity.m_sGroundItemOwner;
                        ret_gi.m_iGroundItemUnionId = ownerCity.m_iGroundItemUnionId;
                        ret_gi.m_sPlayerName = ownerCity.m_sPlayerName;
                        ret_gi.m_iPlayerLevel = ownerCity.m_iPlayerLevel;
                        ret_gi.m_sUnionFlagName = ownerCity.m_sUnionFlagName;
                        ret_gi.m_bIsPlayerMainCity = ownerCity.m_bIsPlayerMainCity;
                    }
                    return ret_gi;
                }
            }
            else
            {
                int iCityId = GetFirstCityIdByInflence(ret.m_sGroundItemOwner);
                GroundItemInfo ownerCity;
                if (m_pSelectableTableById.TryGetValue(iCityId, out ownerCity))
                {
                    ret.m_iGroundItemUnionId = ownerCity.m_iGroundItemUnionId;
                    ret.m_sPlayerName = ownerCity.m_sPlayerName;
                    ret.m_iPlayerLevel = ownerCity.m_iPlayerLevel;
                    ret.m_sUnionFlagName = ownerCity.m_sUnionFlagName;
                    ret.m_bIsPlayerMainCity = ownerCity.m_bIsPlayerMainCity;
                }
            }
            return ret;
        }

        public GroundItemInfo GetSelectableById(int iId)
        {
            GroundItemInfo ret;
            m_pSelectableTableById.TryGetValue(iId, out ret);
            return ret;
        }

        public GroundItemInfo GetUnSelectableById(int iId)
        {
            GroundItemInfo ret;
            m_pUnselectableTableById.TryGetValue(iId, out ret);
            if (null != ret)
            {
                int iCityId = GetFirstCityIdByInflence(ret.m_sGroundItemOwner);
                GroundItemInfo ownerCity;
                if (m_pSelectableTableById.TryGetValue(iCityId, out ownerCity))
                {
                    ret.m_iGroundItemUnionId = ownerCity.m_iGroundItemUnionId;
                    ret.m_sUnionFlagName = ownerCity.m_sUnionFlagName;
                    ret.m_sPlayerName = ownerCity.m_sPlayerName;
                    ret.m_iPlayerLevel = ownerCity.m_iPlayerLevel;
                    ret.m_bIsPlayerMainCity = ownerCity.m_bIsPlayerMainCity;
                }
            }
            return ret;
        }

        #endregion

        #region 鼠标，键盘（测试），操作

        public delegate bool CapturalMouseEvent(Vector2 vScreenPos);

        private Vector2 m_vLastSpeed = new Vector2(0.0f, 0.0f);

        //等新的鼠标触控操作稳定无Bug了，把下面注释的删了
        //[Obsolete("不再用了")]
        //private bool m_bMouseDownOnTown = false;
        //private Vector2 m_vLastMousePos = Vector2.zero;
        //private Vector2 m_vMouseDownPos = Vector2.zero;
        //private float m_fLastMouseDeltaTime = 0.0f;
        //private bool m_bMouseDown = false;
        //等新的鼠标触控操作稳定无Bug了，把上面注释的删了

        private CapturalMouseEvent m_MouseCaptures = null;

        private static bool CapturalByUI(Vector2 vScreenPos)
        {
            return FairyGUI.Stage.isTouchOnUI;
        }

        /// <summary>
        /// 添加屏蔽鼠标点击的函数
        /// </summary>
        /// <param name="captural"></param>
        public void AddMouseCaptural(CapturalMouseEvent captural)
        {
            if (null == m_MouseCaptures)
            {
                m_MouseCaptures = CapturalByUI;
            }
            m_MouseCaptures += captural;
        }

        public void RemoveMouseCaptural(CapturalMouseEvent captural)
        {
            if (null == m_MouseCaptures)
            {
                m_MouseCaptures = CapturalByUI;
            }
            if (captural != null)
            {
                // ReSharper disable once DelegateSubtraction
                m_MouseCaptures -= captural;
            }
        }

        private void InputCheckWithTouch(float fDeltaTime)
        {
            if (!m_bControlUsingLua)
            {
                if (Input.GetKeyDown(KeyCode.H))
                {
                    GroundItemInfo playerCity;
                    if (m_pSelectableTableById.TryGetValue(m_iMyCity, out playerCity))
                    {
                        Vector2 vUV = OddQToUV(playerCity.m_iOddQX, playerCity.m_iOddQY);
                        MoveCameraTo(vUV, null, "", "", 1.0f);
                    }
                }

                if (Input.GetKeyDown(KeyCode.G))
                {
                    TurnSelectCitiesArroundCamera(!IsSelectCitiesArroundCameraOn());
                }

                if (Input.GetKeyDown(KeyCode.F))
                {
                    if (IsInMoveMainCityMode())
                    {
                        LeaveMoveMainCityMode();
                    }
                    else
                    {
                        EnterMoveMainCityMode(1.0f);
                    }
                }
            }

            if (null == m_MouseCaptures)
            {
                m_MouseCaptures = CapturalByUI;
            }

            CheckMouseAndTouch(fDeltaTime);
        }

        //等新的鼠标触控操作稳定无Bug了，把下面注释的删了
        //[Obsolete("Using InputCheckWithTouch")]
        //private void UpdateMouseInput(float fDeltaTime)
        //{
        //    if (!m_bControlUsingLua)
        //    {
        //        if (Input.GetKeyDown(KeyCode.H))
        //        {
        //            GroundItemInfo playerCity;
        //            if (m_pSelectableTableById.TryGetValue(m_iMyCity, out playerCity))
        //            {
        //                Vector2 vUV = OddQToUV(playerCity.m_iOddQX, playerCity.m_iOddQY);
        //                MoveCameraTo(vUV, null, "", "", 1.0f);
        //            }
        //        }

        //        if (Input.GetKeyDown(KeyCode.G))
        //        {
        //            TurnSelectCitiesArroundCamera(!IsSelectCitiesArroundCameraOn());
        //        }

        //        if (Input.GetKeyDown(KeyCode.F))
        //        {
        //            if (IsInMoveMainCityMode())
        //            {
        //                LeaveMoveMainCityMode();
        //            }
        //            else
        //            {
        //                EnterMoveMainCityMode(1.0f);
        //            }
        //        }
        //    }

        //    if (null == m_MouseCaptures)
        //    {
        //        m_MouseCaptures = CapturalByUI;
        //    }

        //    Vector2 mouse = Input.mousePosition;

        //    foreach (Delegate del in m_MouseCaptures.GetInvocationList())
        //    {
        //        CapturalMouseEvent cap = del as CapturalMouseEvent;
        //        if (null != cap && cap(mouse))
        //        {
        //            return;
        //        }
        //    }

        //    #region 拖动摄像机

        //    if (Input.GetMouseButtonDown(0)) //按下左键
        //    {
        //        m_vLastMousePos = mouse;
        //        m_vLastSpeed = Vector2.zero;
        //        m_fLastMouseDeltaTime = Time.time;
        //        m_vMouseDownPos = Input.mousePosition;
        //        m_bMouseDown = true;
        //        m_bMouseDownOnTown = false;

        //        if (m_bMoveCityMode)
        //        {
        //            CheckPressMoveTownMode(m_vLastMousePos);
        //        }
        //    }

        //    if (Input.GetMouseButton(0))
        //    {
        //        if (!m_bMoveCityMode /* || !m_bMouseDownOnTown 迁城模式下不拖动*/)
        //        {
        //            Vector2 vDelta = (mouse - m_vLastMousePos) * m_vCameraMotionParameters.x;
        //            Vector2 vMove = m_vPlannerLeft*vDelta.x + m_vPlannerUp*vDelta.y;
        //            m_vCameraPos = new Vector3(vMove.x, vMove.y, 0.0f) + m_vCameraPos;
        //            m_vCameraPos.x = Mathf.Clamp(m_vCameraPos.x, m_fGroundSize * -0.5f, m_fGroundSize * 0.5f);
        //            m_vCameraPos.y = Mathf.Clamp(m_vCameraPos.y, m_fGroundSize * -0.5f, m_fGroundSize * 0.5f);

        //            if (Time.time - m_fLastMouseDeltaTime > 0.001f)
        //            {
        //                m_vLastSpeed = vDelta/(Time.time - m_fLastMouseDeltaTime);
        //            }

        //            m_vLastMousePos = mouse;
        //            m_bMouseDown = true;
        //        }
        //        else if (m_bMoveCityMode && m_bMouseDownOnTown) //m_bMoveCityMode = true && m_bMouseDownOnTown = true
        //        {
        //            CheckMouseDragMoveCityMode(mouse, fDeltaTime);
        //        }
        //    }
        //    else //mouse up
        //    {
        //        if (!m_bMoveCityMode /*|| !m_bMouseDownOnTown 迁城模式下不拖动*/)
        //        {
        //            if (m_bMouseDown)
        //            {
        //                m_bMouseDown = false;
        //                if ((m_vMouseDownPos - m_vLastMousePos).sqrMagnitude < m_vCameraMotionParameters.z && !m_bMoveCityMode)
        //                {
        //                    CheckPress(m_vLastMousePos);
        //                }
        //            }

        //            if (Mathf.Abs(m_vLastSpeed.x) > Time.deltaTime*m_vCameraMotionParameters.y)
        //            {
        //                m_vLastSpeed.x -= Mathf.Sign(m_vLastSpeed.x)*Time.deltaTime*m_vCameraMotionParameters.y;
        //            }
        //            else
        //            {
        //                m_vLastSpeed.x = 0.0f;
        //            }
        //            if (Mathf.Abs(m_vLastSpeed.y) > Time.deltaTime*m_vCameraMotionParameters.y)
        //            {
        //                m_vLastSpeed.y -= Mathf.Sign(m_vLastSpeed.y)*Time.deltaTime*m_vCameraMotionParameters.y;
        //            }
        //            else
        //            {
        //                m_vLastSpeed.y = 0.0f;
        //            }
        //            Vector2 vMove = m_vPlannerLeft*m_vLastSpeed.x*Time.deltaTime +
        //                            m_vPlannerUp*m_vLastSpeed.y*Time.deltaTime;
        //            m_vCameraPos = new Vector3(vMove.x, vMove.y, 0.0f) +
        //                           m_vCameraPos;
        //            m_vCameraPos.x = Mathf.Clamp(m_vCameraPos.x, m_fGroundSize * -0.5f, m_fGroundSize * 0.5f);
        //            m_vCameraPos.y = Mathf.Clamp(m_vCameraPos.y, m_fGroundSize * -0.5f, m_fGroundSize * 0.5f);
        //        }
        //        else
        //        {
        //            m_bMouseDownOnTown = false;
        //        }
        //    }

        //    m_vCameraPos.z += Input.mouseScrollDelta.y;
        //    m_vCameraPos.z = Mathf.Clamp(m_vCameraPos.z, m_vHeightMinMax.x, m_vHeightMinMax.y);

        //    #endregion
        //}

        public delegate void OnCameraFaceToChanged(int iOddQX, int iOddQY, float fDistance);

        public OnCameraFaceToChanged m_pCameraChangedCb = null;

        private int m_iLastCameraMoveToOddQX = -1;
        private int m_iLastCameraMoveToOddQY = -1;
        private void OnCameraMoved(Vector2 vNewUV)
        {
            int iNewOddQX, iNewOddQY;
            UVToNearestOddQ(vNewUV + m_vCameraOffset, out iNewOddQX, out iNewOddQY);
            if (iNewOddQX != m_iLastCameraMoveToOddQX
             || iNewOddQY != m_iLastCameraMoveToOddQY)
            {
                m_iLastCameraMoveToOddQX = iNewOddQX;
                m_iLastCameraMoveToOddQY = iNewOddQY;
                GroundItemInfo myCity;
                m_pSelectableTableById.TryGetValue(m_iMyCity, out myCity);
                float fDist = -1.0f;
                if (null != myCity)
                {

                    fDist = Mathf.Sqrt((iNewOddQX - myCity.m_iOddQX) * (iNewOddQX - myCity.m_iOddQX) +
                                       (iNewOddQY - myCity.m_iOddQY) * (iNewOddQY - myCity.m_iOddQY));
                }
                if (null != m_pCameraChangedCb)
                {
                    m_pCameraChangedCb(iNewOddQX, iNewOddQY, fDist);
                }
            }
        }

        public delegate void OnClickGroundCallBack(Vector2 vUV, int iOddQX, int iOddQY, GroundItemInfo gi);

        public OnClickGroundCallBack m_pCB = null;

        //等新的鼠标触控操作稳定无Bug了，把下面注释的删了
        //[Obsolete("使用新的多点触控模式")]
        //private void CheckPress(Vector2 vScreenPos)
        //{
        //    Vector2 vUV;
        //    bool bHasClick = TerrainRaycast(vScreenPos, out vUV);
        //    if (bHasClick)
        //    {
        //        int iOddQX, iOddQY;
        //        UVToNearestOddQ(vUV, out iOddQX, out iOddQY);
        //        if (null != m_pCB)
        //        {
        //            GroundItemInfo gi1 = GetSelectableByPos(iOddQX, iOddQY) ?? GetUnSelectableByPos(iOddQX, iOddQY);
        //            m_pCB(vUV, iOddQX, iOddQY, gi1);
        //        }

        //        if (!m_bControlUsingLua)
        //        {
        //            if (m_pSelectableTable.ContainsKey(iOddQX * m_iGridHeight + iOddQY))
        //            {
        //                GroundItemInfo item = m_pSelectableTable[iOddQX * m_iGridHeight + iOddQY];
        //                if (null != item.m_Script && !item.m_Script.IsSelected()) //不在画面内的的不给点
        //                {
        //                    OnSelectCity(item);
        //                }
        //            }
        //            else
        //            {
        //                GroundItemInfo gi = GetUnSelectableByPos(iOddQX, iOddQY);
        //                Debug.Log(null == gi ? "null" : gi.m_byGroundItemType.ToString());
        //                OnClickEmptyGrid(vUV);
        //            }
        //        }
        //    }
        //}

        //等新的鼠标触控操作稳定无Bug了，把下面注释的删了
        //[Obsolete("使用新的多点触控模式")]
        //private void CheckPressMoveTownMode(Vector2 vScreenPos)
        //{
        //    Vector2 vUV;
        //    bool bHasClick = TerrainRaycast(vScreenPos, out vUV);
        //    if (bHasClick)
        //    {
        //        int iOddQX, iOddQY;
        //        UVToNearestOddQ(vUV, out iOddQX, out iOddQY);

        //        //这个体验更好，但下面那个才是正确的，所以注释先留着
        //        bool bMouseDownOnCity = (m_iLastMoveCityOddQX == iOddQX || m_iLastMoveCityOddQY == iOddQY);
        //        /*
        //        int iDeltaY = (0 == (m_iLastMoveCityOddQX & 1)) ? -1 : 1;
        //        bool bMouseDownOnCity = (m_iLastMoveCityOddQX == iOddQX || m_iLastMoveCityOddQY == iOddQY)
        //                             || (m_iLastMoveCityOddQX + 1 == iOddQX || m_iLastMoveCityOddQY == iOddQY)
        //                             || (m_iLastMoveCityOddQX - 1 == iOddQX || m_iLastMoveCityOddQY == iOddQY)
        //                             || (m_iLastMoveCityOddQX == iOddQX || m_iLastMoveCityOddQY + 1 == iOddQY)
        //                             || (m_iLastMoveCityOddQX == iOddQX || m_iLastMoveCityOddQY - 1 == iOddQY)
        //                             || (m_iLastMoveCityOddQX + 1 == iOddQX || m_iLastMoveCityOddQY + iDeltaY == iOddQY)
        //                             || (m_iLastMoveCityOddQX - 1 == iOddQX || m_iLastMoveCityOddQY + iDeltaY == iOddQY);
        //        */
        //        if (bMouseDownOnCity)
        //        {
        //            m_bMouseDownOnTown = true;
        //        }
        //    }
        //}

        private Vector2 m_v2EdgeMoveSpeed = Vector2.zero;
        private Vector4 m_v4ScrollParam1 = new Vector4(0.15f, 0.85f, 0.15f, 0.85f);
        private Vector3 m_v3ScrollParam2 = new Vector4(0.1f, 0.1f, 0.15f);

        public void SetScrollParam(Vector4 v4ScrollParam1, Vector3 v3ScrollParam2)
        {
            m_v4ScrollParam1 = v4ScrollParam1;
            m_v3ScrollParam2 = v3ScrollParam2;
        }

        ////等新的鼠标触控操作稳定无Bug了，把下面注释的删了
        //[Obsolete("使用新的")]
        //private void CheckMouseDragMoveCityMode(Vector2 vScreenPos, float fDeltaTime)
        //{
        //    #region Camera Scroll

        //    if (vScreenPos.x < Screen.width * m_v4ScrollParam1.x)
        //    {
        //        m_v2EdgeMoveSpeed.x += m_v3ScrollParam2.y * fDeltaTime;
        //        m_v2EdgeMoveSpeed.x = Mathf.Min(m_v2EdgeMoveSpeed.x, m_v3ScrollParam2.x);
        //    }
        //    else if (vScreenPos.x > Screen.width * m_v4ScrollParam1.y)
        //    {
        //        m_v2EdgeMoveSpeed.x -= m_v3ScrollParam2.y * fDeltaTime;
        //        m_v2EdgeMoveSpeed.x = Mathf.Max(m_v2EdgeMoveSpeed.x, -m_v3ScrollParam2.x);
        //    }
        //    else
        //    {
        //        if (Mathf.Abs(m_v2EdgeMoveSpeed.x) < m_v3ScrollParam2.z * 1.5f * fDeltaTime)
        //        {
        //            m_v2EdgeMoveSpeed.x = 0.0f;
        //        }
        //        else
        //        {
        //            m_v2EdgeMoveSpeed.x -= Mathf.Sign(m_v2EdgeMoveSpeed.x) * m_v3ScrollParam2.z * fDeltaTime;
        //        }
        //    }

        //    if (vScreenPos.y < Screen.height * m_v4ScrollParam1.z)
        //    {
        //        m_v2EdgeMoveSpeed.y += m_v3ScrollParam2.y * fDeltaTime;
        //        m_v2EdgeMoveSpeed.y = Mathf.Min(m_v2EdgeMoveSpeed.y, m_v3ScrollParam2.x);
        //    }
        //    else if (vScreenPos.y > Screen.height * m_v4ScrollParam1.w)
        //    {
        //        m_v2EdgeMoveSpeed.y -= m_v3ScrollParam2.y * fDeltaTime;
        //        m_v2EdgeMoveSpeed.y = Mathf.Max(m_v2EdgeMoveSpeed.y, -m_v3ScrollParam2.x);
        //    }
        //    else
        //    {
        //        if (Mathf.Abs(m_v2EdgeMoveSpeed.y) < m_v3ScrollParam2.z * 1.5f * fDeltaTime)
        //        {
        //            m_v2EdgeMoveSpeed.y = 0.0f;
        //        }
        //        else
        //        {
        //            m_v2EdgeMoveSpeed.y -= Mathf.Sign(m_v2EdgeMoveSpeed.y) * m_v3ScrollParam2.z * fDeltaTime;
        //        }
        //    }
        //    m_vCameraPos.x += (m_v2EdgeMoveSpeed.x * m_vPlannerLeft + m_v2EdgeMoveSpeed.y * m_vPlannerUp).x * m_fGroundSize * fDeltaTime;
        //    m_vCameraPos.y += (m_v2EdgeMoveSpeed.x * m_vPlannerLeft + m_v2EdgeMoveSpeed.y * m_vPlannerUp).y * m_fGroundSize * fDeltaTime;
        //    m_vCameraPos.x = Mathf.Clamp(m_vCameraPos.x, m_fGroundSize * -0.5f, m_fGroundSize * 0.5f);
        //    m_vCameraPos.y = Mathf.Clamp(m_vCameraPos.y, m_fGroundSize * -0.5f, m_fGroundSize * 0.5f);

        //    #endregion

        //    Vector2 vUV;
        //    bool bHasClick = TerrainRaycast(vScreenPos, out vUV);
        //    if (bHasClick)
        //    {
        //        int iOddQX, iOddQY;
        //        UVToNearestOddQ(vUV, out iOddQX, out iOddQY);
        //        OnMoveTownTo(iOddQX, iOddQY);
        //    }
        //}

        #region Touch

        private int MaxTouchCount = TerrainParameters.MAX_TOUCH_COUNT;
        private int InvalidTouchId = TerrainParameters.INVALID_TOUCH_ID;
        private int MouseTouchId = TerrainParameters.MOUSE_TOUCH_ID;
        private float TouchStay = TerrainParameters.TOUCH_STAY; //按下时间小于这个数字的，都不管，避免敲击屏幕的闪抖
        private float HoldTimeCheck = TerrainParameters.HOLD_TIME_CHECK; //按下时间超过这个数字的（且没动），作为长按（触摸屏一般不是用mouse up判断）
        private float MoveDistanceCheck = TerrainParameters.MOVE_DISTANCE_CHECK; //移动距离大于这个的，（且按下时间大于0.1）直接作为拖动

        private STouchData[] m_sCurrentTouchData = null;
        private int m_iCurrentTouchNumber = 0;
        private int m_iCameraTouch1 = -1;
        private int m_iCameraTouch2 = -1;
        private float m_fStartScaleLength = -1.0f;
        private float m_fLastScale = -1.0f;

        private struct STouchData
        {
            public bool m_bHasTouch;
            public bool m_bHasProcessHit; //This means this hit has already done its work.(For example. pressed something when mouse down but not up yet)
            public bool m_bUseAsCamera;
            public bool m_bUseAsDragCity;
            public int m_iFingerID;
            public float m_fDownTime;
            public Vector3 m_vDownPos;
            public Vector3 m_vLastPos;
            public Vector3 m_vLastDeltaMove;
        }

        private void InitialOrClearTouchData()
        {
            m_sCurrentTouchData = new STouchData[MaxTouchCount];
            for (int i = 0; i < MaxTouchCount; ++i)
            {
                m_sCurrentTouchData[i].m_bHasTouch = false;
                m_sCurrentTouchData[i].m_iFingerID = InvalidTouchId;
            }
            m_iCurrentTouchNumber = 0;
            m_iCameraTouch1 = -1;
            m_iCameraTouch2 = -1;
            m_fStartScaleLength = -1.0f;
            m_vLastSpeed = Vector2.zero;
        }

        /// <summary>
        /// 是否允许操作摄像机
        /// </summary>
        /// <returns></returns>
        private bool CanOperateCamera()
        {
            return !m_bMoveCityMode;
        }

        /// <summary>
        /// 摄像机平动
        /// </summary>
        /// <param name="vDeltaMove"></param>
        private void ProcessCameraMovePlane(Vector3 vDeltaMove)
        {
            Vector2 vDelta = vDeltaMove * m_vCameraMotionParameters.x;
            Vector2 vMove = m_vPlannerLeft * vDelta.x + m_vPlannerUp * vDelta.y;
            m_vCameraPos = new Vector3(vMove.x, vMove.y, 0.0f) + m_vCameraPos;
            // 移动范围参数，[-0.5 , 0.5]。
            // 比如地图范围是100，默认（0，0，0）为地图中心点，
            // 这里的参数就限制摄像机只能在 -50到50之间移动，防止移动到地图边缘穿帮
            float rangeFactor = 0.5f;
            m_vCameraPos.x = Mathf.Clamp(m_vCameraPos.x, m_fGroundSize * -rangeFactor, m_fGroundSize * rangeFactor);
            m_vCameraPos.y = Mathf.Clamp(m_vCameraPos.y, m_fGroundSize * -rangeFactor, m_fGroundSize * rangeFactor);
        }

        /// <summary>
        /// 摄像机高低移动
        /// </summary>
        private void ProcessCameraMoveNearFar()
        {
            float fCurrentLenght = (m_sCurrentTouchData[m_iCameraTouch1].m_vLastPos - m_sCurrentTouchData[m_iCameraTouch2].m_vLastPos).magnitude;
            if (fCurrentLenght < 1.0f)
            {
                return;
            }
            m_vCameraPos.z += (m_fLastScale - fCurrentLenght) * 0.1f;
            m_vCameraPos.z = Mathf.Clamp(m_vCameraPos.z, m_vHeightMinMax.x, m_vHeightMinMax.y);
            m_fLastScale = fCurrentLenght;
        }

        /// <summary>
        /// 如果按中了东西，我们作为一个点击处理
        /// </summary>
        /// <param name="vPos"></param>
        /// <returns></returns>
        private bool CheckTouchPressPos(Vector3 vPos)
        {
            Vector2 vUV;
            bool bHasClick = TerrainRaycast(vPos, out vUV);
            if (bHasClick)
            {
                int iOddQX, iOddQY;
                UVToNearestOddQ(vUV, out iOddQX, out iOddQY);
                GroundItemInfo gi1 = GetSelectableByPos(iOddQX, iOddQY) ?? GetUnSelectableByPos(iOddQX, iOddQY);
                bool bHitSomething = null != gi1 && (0 != gi1.m_byGroundItemType || gi1.m_bIsPlayerMainCity);
                if (null != m_pCB)
                {
                    m_pCB(vUV, iOddQX, iOddQY, gi1);
                }

                if (!m_bControlUsingLua)
                {
                    if (m_pSelectableTable.ContainsKey(iOddQX * m_iGridHeight + iOddQY))
                    {
                        GroundItemInfo item = m_pSelectableTable[iOddQX * m_iGridHeight + iOddQY];
                        if (null != item.m_Script && !item.m_Script.IsSelected()) //不在画面内的的不给点
                        {
                            OnSelectCity(item);
                        }
                    }
                    else
                    {
                        GroundItemInfo gi = GetUnSelectableByPos(iOddQX, iOddQY);
                        Debug.Log(null == gi ? "null" : gi.m_byGroundItemType.ToString());
                        OnClickEmptyGrid(vUV);
                    }
                }

                return bHitSomething;
            }

            return false;
        }

        /// <summary>
        /// 给拖动的。比如迁城模式
        /// </summary>
        /// <param name="iTouch"></param>
        protected void CheckTouchUp(int iTouch)
        {
            if (!m_sCurrentTouchData[iTouch].m_bHasTouch)
            {
                //Why here?
                return;
            }

            if (m_sCurrentTouchData[iTouch].m_bUseAsDragCity)
            {
                //迁城
            }

            if (!m_sCurrentTouchData[iTouch].m_bHasProcessHit && !m_sCurrentTouchData[iTouch].m_bUseAsCamera)
            {
                m_sCurrentTouchData[iTouch].m_bHasProcessHit = true;
                CheckTouchPressPos(m_sCurrentTouchData[iTouch].m_vLastPos);
            }

            m_sCurrentTouchData[iTouch].m_bHasTouch = false;

            if (m_iCameraTouch1 == iTouch)
            {
                m_iCameraTouch1 = -1;
            }
            if (m_iCameraTouch2 == iTouch)
            {
                m_iCameraTouch2 = -1;
            }
        }

        /// <summary>
        /// 计算目前用于操作摄像机的touch数量（比如正在拖动摄像机的时候按下手指，或者正在缩放时松开）
        /// </summary>
        private void GatherTouches()
        {
            m_iCurrentTouchNumber = 0;
            for (int i = 0; i < m_sCurrentTouchData.Length; ++i)
            {
                if (m_sCurrentTouchData[i].m_bHasTouch)
                {
                    if (!m_sCurrentTouchData[i].m_bHasProcessHit
                     && !m_sCurrentTouchData[i].m_bUseAsCamera)
                    {
                        ++m_iCurrentTouchNumber;
                    }
                }
            }
        }

        private void CheckMouseAndTouch(float fDeltaTime)
        {

            RefreshTouch(fDeltaTime);
            if (!CanOperateCamera())
            {
                CheckOtherTouchDrags(fDeltaTime);
                return;
            }

            #region Check Camera Finger

            GatherTouches();

            //int ioldcameratouch1 = m_iCameraTouch1;
            //int ioldcameratouch2 = m_iCameraTouch2;
            //Vector3 vOldPos = transform.position;

            if (-1 != m_iCameraTouch1 && (!m_sCurrentTouchData[m_iCameraTouch1].m_bHasTouch || !m_sCurrentTouchData[m_iCameraTouch1].m_bUseAsCamera))
            {
                m_iCameraTouch1 = -1;
            }
            if (-1 != m_iCameraTouch2 && (!m_sCurrentTouchData[m_iCameraTouch2].m_bHasTouch || !m_sCurrentTouchData[m_iCameraTouch2].m_bUseAsCamera))
            {
                m_iCameraTouch2 = -1;
            }

            if (-1 == m_iCameraTouch1 && -1 == m_iCameraTouch2)
            {
                //目前没有用于操作摄像机的touch
                //如果现在有一个新的touch，且这货已经有0.3秒没动了，那应该算作点击地面了If there is one, and it not moved for 0.3 seconds, use it as Hit
                if (1 == m_iCurrentTouchNumber)
                {
                    //有一个新的touch
                    for (int i = 0; i < m_sCurrentTouchData.Length; ++i)
                    {
                        if (m_sCurrentTouchData[i].m_bHasTouch
                         && !m_sCurrentTouchData[i].m_bHasProcessHit
                         && m_sCurrentTouchData[i].m_fDownTime > TouchStay)
                        {
                            //它动了
                            if ((m_sCurrentTouchData[i].m_vLastPos - m_sCurrentTouchData[i].m_vDownPos).magnitude > MoveDistanceCheck * Screen.width)
                            {
                                m_sCurrentTouchData[i].m_bUseAsCamera = true;
                                m_iCameraTouch1 = i;
                            }
                            else if (m_sCurrentTouchData[i].m_fDownTime > HoldTimeCheck)
                            {
                                //这是一个长按。作为点击地面处理
                                m_sCurrentTouchData[i].m_bHasProcessHit = CheckTouchPressPos(m_sCurrentTouchData[i].m_vLastPos);

                                //并没有按中东西（城市，资源建筑... etc）
                                if (!m_sCurrentTouchData[i].m_bHasProcessHit)
                                {
                                    m_sCurrentTouchData[i].m_bUseAsCamera = true;
                                    m_iCameraTouch1 = i;
                                }
                            }
                            //先不管他
                        }
                    }
                }
                else if (m_iCurrentTouchNumber >= 2)
                {
                    //有2个新的touch, 缩放
                    int iCurrentCheck = 0;
                    for (int i = 0; i < m_sCurrentTouchData.Length; ++i)
                    {
                        if (m_sCurrentTouchData[i].m_bHasTouch
                        && !m_sCurrentTouchData[i].m_bHasProcessHit
                        && m_sCurrentTouchData[i].m_fDownTime > TouchStay
                        && iCurrentCheck < 2)
                        {
                            if ((m_sCurrentTouchData[i].m_vLastPos - m_sCurrentTouchData[i].m_vDownPos).magnitude > MoveDistanceCheck * Screen.width)
                            {
                                m_sCurrentTouchData[i].m_bUseAsCamera = true;
                                if (0 == iCurrentCheck)
                                {
                                    m_iCameraTouch1 = i;
                                }
                                else
                                {
                                    m_iCameraTouch2 = i;
                                }
                                ++iCurrentCheck;
                            }
                            else if (m_sCurrentTouchData[i].m_fDownTime > HoldTimeCheck)
                            {
                                m_sCurrentTouchData[i].m_bHasProcessHit = CheckTouchPressPos(m_sCurrentTouchData[i].m_vLastPos);
                                if (!m_sCurrentTouchData[i].m_bHasProcessHit)
                                {
                                    m_sCurrentTouchData[i].m_bUseAsCamera = true;
                                    if (0 == iCurrentCheck)
                                    {
                                        m_iCameraTouch1 = i;
                                    }
                                    else
                                    {
                                        m_iCameraTouch2 = i;
                                    }
                                    ++iCurrentCheck;
                                }
                            }
                            //先不管他
                        }
                        else if (m_sCurrentTouchData[i].m_bHasTouch && m_sCurrentTouchData[i].m_fDownTime > TouchStay && !m_sCurrentTouchData[i].m_bHasProcessHit)
                        {
                            //第三个手指，一定不是摄像机
                            if (m_sCurrentTouchData[i].m_fDownTime > HoldTimeCheck)
                            {
                                m_sCurrentTouchData[i].m_bHasProcessHit = CheckTouchPressPos(m_sCurrentTouchData[i].m_vLastPos);
                            }
                        }
                    }
                }
            }
            else if ((-1 == m_iCameraTouch1 && m_iCameraTouch2 != -1) || (-1 == m_iCameraTouch2 && m_iCameraTouch1 != -1))
            {
                //本来在拖动，看看是不是要变成缩放（后面逻辑和上面一模一样，我就不注释了）
                if (m_iCurrentTouchNumber > 0)
                {
                    int iCurrentCheck = 0;
                    for (int i = 0; i < m_sCurrentTouchData.Length; ++i)
                    {
                        if (m_sCurrentTouchData[i].m_bHasTouch
                         && !m_sCurrentTouchData[i].m_bUseAsCamera
                         && !m_sCurrentTouchData[i].m_bHasProcessHit
                         && m_sCurrentTouchData[i].m_fDownTime > TouchStay
                         && iCurrentCheck < 1)
                        {
                            if ((m_sCurrentTouchData[i].m_vLastPos - m_sCurrentTouchData[i].m_vDownPos).magnitude > MoveDistanceCheck * Screen.width)
                            {
                                m_sCurrentTouchData[i].m_bUseAsCamera = true;
                                if (-1 == m_iCameraTouch1)
                                {
                                    m_iCameraTouch1 = i;
                                }
                                else
                                {
                                    m_iCameraTouch2 = i;
                                }
                                ++iCurrentCheck;
                            }
                            else if (m_sCurrentTouchData[i].m_fDownTime > HoldTimeCheck && !m_sCurrentTouchData[i].m_bHasProcessHit)
                            {
                                m_sCurrentTouchData[i].m_bHasProcessHit = CheckTouchPressPos(m_sCurrentTouchData[i].m_vLastPos);
                                if (!m_sCurrentTouchData[i].m_bHasProcessHit)
                                {
                                    m_sCurrentTouchData[i].m_bUseAsCamera = true;
                                    if (-1 == m_iCameraTouch1)
                                    {
                                        m_iCameraTouch1 = i;
                                    }
                                    else
                                    {
                                        m_iCameraTouch2 = i;
                                    }
                                    ++iCurrentCheck;
                                }
                            }
                        }
                        else if (m_sCurrentTouchData[i].m_bHasTouch
                            && !m_sCurrentTouchData[i].m_bUseAsCamera
                            && !m_sCurrentTouchData[i].m_bHasProcessHit
                            && m_sCurrentTouchData[i].m_fDownTime > TouchStay
                            )
                        {
                            if (m_sCurrentTouchData[i].m_fDownTime > HoldTimeCheck)
                            {
                                m_sCurrentTouchData[i].m_bHasProcessHit = CheckTouchPressPos(m_sCurrentTouchData[i].m_vLastPos);
                            }
                        }
                    }
                }
            }
            else if (-1 != m_iCameraTouch1 && m_iCameraTouch2 != -1)
            {
                if (m_iCurrentTouchNumber > 0)
                {
                    for (int i = 0; i < m_sCurrentTouchData.Length; ++i)
                    {
                        if (m_sCurrentTouchData[i].m_bHasTouch
                         && !m_sCurrentTouchData[i].m_bUseAsCamera
                         && !m_sCurrentTouchData[i].m_bHasProcessHit
                         && m_sCurrentTouchData[i].m_fDownTime > TouchStay)
                        {
                            if (m_sCurrentTouchData[i].m_fDownTime > HoldTimeCheck)
                            {
                                m_sCurrentTouchData[i].m_bHasProcessHit = CheckTouchPressPos(m_sCurrentTouchData[i].m_vLastPos);
                            }
                        }
                    }
                }
            }

            #endregion

            #region Check Camera Move

            bool bCameraMoving = false;
            if (-1 != m_iCameraTouch2 && -1 == m_iCameraTouch1)
            {
                m_iCameraTouch1 = m_iCameraTouch2;
                m_iCameraTouch2 = -1;
                m_sCurrentTouchData[m_iCameraTouch1].m_bUseAsCamera = true;
            }
            if (-1 == m_iCameraTouch1 || -1 == m_iCameraTouch2)
            {
                m_fStartScaleLength = -1.0f;
            }
            if (-1 != m_iCameraTouch1 && -1 != m_iCameraTouch2)
            {
                if (m_fStartScaleLength > 0.0f)
                {
                    ProcessCameraMoveNearFar();
                    bCameraMoving = true;
                }
                else
                {
                    float fCurrentLenght = (m_sCurrentTouchData[m_iCameraTouch1].m_vLastPos - m_sCurrentTouchData[m_iCameraTouch2].m_vLastPos).magnitude;
                    m_fLastScale = fCurrentLenght;
                    m_fStartScaleLength = fCurrentLenght;
                }
            }
            else if (-1 != m_iCameraTouch1)
            {
                ProcessCameraMovePlane(m_sCurrentTouchData[m_iCameraTouch1].m_vLastDeltaMove);
                if (fDeltaTime > 0.0001f)
                {
                    m_vLastSpeed = m_sCurrentTouchData[m_iCameraTouch1].m_vLastDeltaMove / fDeltaTime;
                }
                bCameraMoving = true;
            }

            if (!bCameraMoving)
            {
                //摩擦力
                if (m_vLastSpeed.sqrMagnitude > fDeltaTime * fDeltaTime * 1.0f)
                {
                    float minSpeed = TerrainParameters.CAMERA_TOUCH_MOVE_MIN_SPEED;
                    float maxSpeed = TerrainParameters.CAMERA_TOUCH_MOVE_MAX_SPEED;
                    float deltaSpeed = TerrainParameters.CAMERA_TOUCH_MOVE_DELTA_SPEED;
                    m_vLastSpeed *= (1.0f - Mathf.Clamp(fDeltaTime * deltaSpeed, minSpeed, maxSpeed));
                    ProcessCameraMovePlane(m_vLastSpeed * fDeltaTime);
                }
                else
                {
                    m_vLastSpeed = Vector3.zero;
                }
            }

            #endregion

            #region Check others

            CheckOtherTouchDrags(fDeltaTime);

            #endregion
        }

        /// <summary>
        /// 除了摄像机拖动以外的拖动
        /// </summary>
        /// <param name="fDeltaTime"></param>
        private void CheckOtherTouchDrags(float fDeltaTime)
        {
            #region 迁城

            if (m_bMoveCityMode)
            {
                for (int i = 0; i < m_sCurrentTouchData.Length; ++i)
                {
                    if (m_sCurrentTouchData[i].m_bHasTouch && m_sCurrentTouchData[i].m_bUseAsDragCity)
                    {
                        Vector2 vScreenPos = m_sCurrentTouchData[i].m_vLastPos;

                        #region Camera Scroll

                        if (vScreenPos.x < Screen.width * m_v4ScrollParam1.x)
                        {
                            m_v2EdgeMoveSpeed.x += m_v3ScrollParam2.y * fDeltaTime;
                            m_v2EdgeMoveSpeed.x = Mathf.Min(m_v2EdgeMoveSpeed.x, m_v3ScrollParam2.x);
                        }
                        else if (vScreenPos.x > Screen.width * m_v4ScrollParam1.y)
                        {
                            m_v2EdgeMoveSpeed.x -= m_v3ScrollParam2.y * fDeltaTime;
                            m_v2EdgeMoveSpeed.x = Mathf.Max(m_v2EdgeMoveSpeed.x, -m_v3ScrollParam2.x);
                        }
                        else
                        {
                            if (Mathf.Abs(m_v2EdgeMoveSpeed.x) < m_v3ScrollParam2.z * 1.5f * fDeltaTime)
                            {
                                m_v2EdgeMoveSpeed.x = 0.0f;
                            }
                            else
                            {
                                m_v2EdgeMoveSpeed.x -= Mathf.Sign(m_v2EdgeMoveSpeed.x) * m_v3ScrollParam2.z * fDeltaTime;
                            }
                        }

                        if (vScreenPos.y < Screen.height * m_v4ScrollParam1.z)
                        {
                            m_v2EdgeMoveSpeed.y += m_v3ScrollParam2.y * fDeltaTime;
                            m_v2EdgeMoveSpeed.y = Mathf.Min(m_v2EdgeMoveSpeed.y, m_v3ScrollParam2.x);
                        }
                        else if (vScreenPos.y > Screen.height * m_v4ScrollParam1.w)
                        {
                            m_v2EdgeMoveSpeed.y -= m_v3ScrollParam2.y * fDeltaTime;
                            m_v2EdgeMoveSpeed.y = Mathf.Max(m_v2EdgeMoveSpeed.y, -m_v3ScrollParam2.x);
                        }
                        else
                        {
                            if (Mathf.Abs(m_v2EdgeMoveSpeed.y) < m_v3ScrollParam2.z * 1.5f * fDeltaTime)
                            {
                                m_v2EdgeMoveSpeed.y = 0.0f;
                            }
                            else
                            {
                                m_v2EdgeMoveSpeed.y -= Mathf.Sign(m_v2EdgeMoveSpeed.y) * m_v3ScrollParam2.z * fDeltaTime;
                            }
                        }
                        m_vCameraPos.x += (m_v2EdgeMoveSpeed.x * m_vPlannerLeft + m_v2EdgeMoveSpeed.y * m_vPlannerUp).x * m_fGroundSize * fDeltaTime;
                        m_vCameraPos.y += (m_v2EdgeMoveSpeed.x * m_vPlannerLeft + m_v2EdgeMoveSpeed.y * m_vPlannerUp).y * m_fGroundSize * fDeltaTime;
                        m_vCameraPos.x = Mathf.Clamp(m_vCameraPos.x, m_fGroundSize * -0.5f, m_fGroundSize * 0.5f);
                        m_vCameraPos.y = Mathf.Clamp(m_vCameraPos.y, m_fGroundSize * -0.5f, m_fGroundSize * 0.5f);

                        #endregion

                        //Debug.Log("In bUseAsMovingCity Mouse Down:" + vScreenPos);

                        Vector2 vUV;
                        bool bHasClick = TerrainRaycast(vScreenPos, out vUV);
                        if (bHasClick)
                        {
                            int iOddQX, iOddQY;
                            UVToNearestOddQ(vUV, out iOddQX, out iOddQY);
                            OnMoveTownTo(iOddQX, iOddQY);
                        }
                    }
                }
            }

            #endregion            
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="fDeltaTime"></param>
        private void RefreshTouch(float fDeltaTime)
        {
            //已有touch的追踪
            for (int i = 0; i < m_sCurrentTouchData.Length; ++i)
            {
                if (m_sCurrentTouchData[i].m_bHasTouch)
                {
                    bool bHasMatch = false;
                    Touch unityTouchCopy = new Touch();
                    if (Application.platform == RuntimePlatform.Android || Application.platform == RuntimePlatform.IPhonePlayer)
                    {
                        foreach (Touch unityTouch in Input.touches)
                        {
                            // 在远古时代（android1.6，unity3.x）
                            // 有的手机无法返回正确的touchId，曾亲测Nexus one（谷歌第一个亲儿子）就有这个Bug你敢信
                            // 如果如今还有这个问题，一个Workaround是通过touch的位置判断match。
                            // 自从Unity4.x以来我还没有遇到过这个问题，所以我暂时信它的ID
                            if (unityTouch.fingerId == m_sCurrentTouchData[i].m_iFingerID)
                            {
                                unityTouchCopy = unityTouch;
                                bHasMatch = true;
                                break;
                            }
                        }
                    }
                    else
                    {
                        if (Input.GetMouseButtonUp(0) && MouseTouchId == m_sCurrentTouchData[i].m_iFingerID)
                        {
                            unityTouchCopy.fingerId = MouseTouchId;
                            unityTouchCopy.phase = TouchPhase.Ended;
                            unityTouchCopy.position = new Vector2(Input.mousePosition.x, Input.mousePosition.y);
                            bHasMatch = true;
                        }
                        else if (Input.GetMouseButton(0) && MouseTouchId == m_sCurrentTouchData[i].m_iFingerID)
                        {
                            unityTouchCopy.fingerId = MouseTouchId;
                            unityTouchCopy.phase = TouchPhase.Moved;
                            unityTouchCopy.position = new Vector2(Input.mousePosition.x, Input.mousePosition.y);
                            bHasMatch = true;
                        }
                    }

                    if (!bHasMatch)
                    {
                        CheckTouchUp(i);
                        m_sCurrentTouchData[i].m_bHasTouch = false;
                        if (m_iCameraTouch1 == i)
                        {
                            m_iCameraTouch1 = -1;
                        }
                        if (m_iCameraTouch2 == i)
                        {
                            m_iCameraTouch2 = -1;
                        }
                    }
                    else
                    {
                        m_sCurrentTouchData[i].m_fDownTime += fDeltaTime;
                        m_sCurrentTouchData[i].m_vLastDeltaMove = new Vector3(unityTouchCopy.position.x, unityTouchCopy.position.y, 0.0f) - m_sCurrentTouchData[i].m_vLastPos;
                        m_sCurrentTouchData[i].m_vLastPos = new Vector3(unityTouchCopy.position.x, unityTouchCopy.position.y, 0.0f);
                        if (TouchPhase.Canceled == unityTouchCopy.phase || TouchPhase.Ended == unityTouchCopy.phase)
                        {
                            CheckTouchUp(i);
                            if (m_iCameraTouch1 == i)
                            {
                                m_iCameraTouch1 = -1;
                            }
                            if (m_iCameraTouch2 == i)
                            {
                                m_iCameraTouch2 = -1;
                            }

                            m_sCurrentTouchData[i].m_bHasTouch = false;
                        }
                    }
                }
            }

            //新的touch的追踪
            if (Application.platform == RuntimePlatform.Android || Application.platform == RuntimePlatform.IPhonePlayer)
            {
                foreach (Touch unityTouch in Input.touches)
                {
                    if (TouchPhase.Canceled != unityTouch.phase
                        && TouchPhase.Ended != unityTouch.phase
                        && GetTouchIndexByID(unityTouch.fingerId) < 0)
                    {
                        RegisterTouch(unityTouch);
                    }
                }
            }
            else
            {
                if (Input.GetMouseButtonDown(0) && GetTouchIndexByID(MouseTouchId) < 0)
                {
                    Touch unityTouch = new Touch();
                    unityTouch.fingerId = MouseTouchId;
                    unityTouch.phase = TouchPhase.Began;
                    unityTouch.position = new Vector2(Input.mousePosition.x, Input.mousePosition.y);
                    RegisterTouch(unityTouch);
                }
            }
        }

        private int GetTouchIndexByID(int iFingerID)
        {
            for (int i = 0; i < m_sCurrentTouchData.Length; ++i)
            {
                if (m_sCurrentTouchData[i].m_bHasTouch && iFingerID == m_sCurrentTouchData[i].m_iFingerID)
                {
                    return i;
                }
            }
            return -1;
        }

        //相当于Mouse Down
        private void RegisterTouch(Touch sTouch)
        {
            int iFindIndex = -1;
            for (int i = 0; i < m_sCurrentTouchData.Length; ++i)
            {
                if (!m_sCurrentTouchData[i].m_bHasTouch)
                {
                    iFindIndex = i;
                    break;
                }
            }

            if (iFindIndex >= 0) //如果是-1，说明是第六根手指了。
            {
                #region UI

                //被UI阻挡
                bool bBlockByUI = false;
                foreach (Delegate del in m_MouseCaptures.GetInvocationList())
                {
                    CapturalMouseEvent cap = del as CapturalMouseEvent;
                    if (null != cap && cap(sTouch.position))
                    {
                        bBlockByUI = true;
                        break;
                    }
                }

                if (bBlockByUI)
                {
                    m_sCurrentTouchData[iFindIndex].m_bHasTouch = true;
                    m_sCurrentTouchData[iFindIndex].m_bHasProcessHit = true;
                    m_sCurrentTouchData[iFindIndex].m_bUseAsCamera = false;
                    m_sCurrentTouchData[iFindIndex].m_bUseAsDragCity = false;
                    m_sCurrentTouchData[iFindIndex].m_fDownTime = 0.0f;
                    m_sCurrentTouchData[iFindIndex].m_iFingerID = sTouch.fingerId;
                    m_sCurrentTouchData[iFindIndex].m_vDownPos = new Vector3(sTouch.position.x, sTouch.position.y, 0.0f);
                    m_sCurrentTouchData[iFindIndex].m_vLastPos = new Vector3(sTouch.position.x, sTouch.position.y, 0.0f);
                    m_sCurrentTouchData[iFindIndex].m_vLastDeltaMove = Vector3.zero;
                    return;
                }

                #endregion

                #region 迁城

                //这套新的，支持多点触控迁城。一边拖动城市一边拖动摄像机什么的（假如允许拖的话）
                if (m_bMoveCityMode)
                {
                    bool bAlreadyDragging = false;
                    for (int i = 0; i < m_sCurrentTouchData.Length; ++i)
                    {
                        if (m_sCurrentTouchData[i].m_bHasTouch && m_sCurrentTouchData[i].m_bUseAsDragCity)
                        {
                            bAlreadyDragging = true;
                            break;
                        }
                    }

                    if (!bAlreadyDragging)
                    {
                        bool bUseAsMovingCity = false;
                        Vector2 vUV;
                        bool bHasClick = TerrainRaycast(sTouch.position, out vUV);
                        if (bHasClick)
                        {
                            int iOddQX, iOddQY;
                            UVToNearestOddQ(vUV, out iOddQX, out iOddQY);

                            //这个体验更好，但下面那个才是正确的，所以注释先留着
                            bool bMouseDownOnCity = (m_iLastMoveCityOddQX == iOddQX || m_iLastMoveCityOddQY == iOddQY);
                            /*
                            int iDeltaY = (0 == (m_iLastMoveCityOddQX & 1)) ? -1 : 1;
                            bool bMouseDownOnCity = (m_iLastMoveCityOddQX == iOddQX || m_iLastMoveCityOddQY == iOddQY)
                                                 || (m_iLastMoveCityOddQX + 1 == iOddQX || m_iLastMoveCityOddQY == iOddQY)
                                                 || (m_iLastMoveCityOddQX - 1 == iOddQX || m_iLastMoveCityOddQY == iOddQY)
                                                 || (m_iLastMoveCityOddQX == iOddQX || m_iLastMoveCityOddQY + 1 == iOddQY)
                                                 || (m_iLastMoveCityOddQX == iOddQX || m_iLastMoveCityOddQY - 1 == iOddQY)
                                                 || (m_iLastMoveCityOddQX + 1 == iOddQX || m_iLastMoveCityOddQY + iDeltaY == iOddQY)
                                                 || (m_iLastMoveCityOddQX - 1 == iOddQX || m_iLastMoveCityOddQY + iDeltaY == iOddQY);
                            */
                            if (bMouseDownOnCity)
                            {
                                bUseAsMovingCity = true;
                            }
                        }

                        if (bUseAsMovingCity)
                        {
                            m_sCurrentTouchData[iFindIndex].m_bHasTouch = true;
                            m_sCurrentTouchData[iFindIndex].m_bHasProcessHit = true;
                            m_sCurrentTouchData[iFindIndex].m_bUseAsCamera = false;
                            m_sCurrentTouchData[iFindIndex].m_bUseAsDragCity = true;
                            m_sCurrentTouchData[iFindIndex].m_fDownTime = 0.0f;
                            m_sCurrentTouchData[iFindIndex].m_iFingerID = sTouch.fingerId;
                            m_sCurrentTouchData[iFindIndex].m_vDownPos = new Vector3(sTouch.position.x, sTouch.position.y, 0.0f);
                            m_sCurrentTouchData[iFindIndex].m_vLastPos = new Vector3(sTouch.position.x, sTouch.position.y, 0.0f);
                            m_sCurrentTouchData[iFindIndex].m_vLastDeltaMove = Vector3.zero;
                            Debug.Log("In bUseAsMovingCity Mouse Down");
                            return;
                        }
                    }
                }

                #endregion

                #region 默认的

                //注意，前面都return了，不然的话，这里要判断has touch = false
                m_sCurrentTouchData[iFindIndex].m_bHasTouch = true;
                m_sCurrentTouchData[iFindIndex].m_bHasProcessHit = false;
                m_sCurrentTouchData[iFindIndex].m_bUseAsCamera = false;
                m_sCurrentTouchData[iFindIndex].m_bUseAsDragCity = false;
                m_sCurrentTouchData[iFindIndex].m_fDownTime = 0.0f;
                m_sCurrentTouchData[iFindIndex].m_iFingerID = sTouch.fingerId;
                m_sCurrentTouchData[iFindIndex].m_vDownPos = new Vector3(sTouch.position.x, sTouch.position.y, 0.0f);
                m_sCurrentTouchData[iFindIndex].m_vLastPos = new Vector3(sTouch.position.x, sTouch.position.y, 0.0f);
                m_sCurrentTouchData[iFindIndex].m_vLastDeltaMove = Vector3.zero;

                #endregion
            }
        }

        #endregion

        #endregion

        /// <summary>
        /// 六边形格子高度
        /// </summary>
        private float m_fHeightSep = 1.0f;
        public float GetHeightSep() { return m_fHeightSep; }

        /// <summary>
        /// 六边形的边长
        /// </summary>
        private float m_fEdgeWidth = 1.0f;
        public float GetEdigeWidth() { return m_fEdgeWidth; }

        private Vector2[] m_vUVOffset = null;

        //我们换用Collider，不再用Heightmap
        //private Color32[] m_pHeightPixes = null;

        // Use this for initialization
        // ReSharper disable once UnusedMember.Local
        // 提升到Awake,先于TerrainGroundStaticItem.Start
        private void Awake()
        {
            //m_pHeightPixes = m_pHeightTexture.GetPixels32();
            int iHeight = m_iGridHeight;
            m_iGridHeight = -1;
            if (!m_bCurve)
            {
                Vector3 vMeshSize = GetComponent<MeshFilter>().sharedMesh.bounds.extents;
                Vector3 vMeshCenter = GetComponent<MeshFilter>().sharedMesh.bounds.center;

                //我们假定不会去改地表的scale, rotation, position（作为一个标准）
                m_fGroundSize = Mathf.Min(vMeshSize.x, vMeshSize.z) * 2;
                m_fMaxHeight = vMeshCenter.y + vMeshSize.y;
                m_fMinHeight = vMeshCenter.y - vMeshSize.y;
            }

            m_vFogDistance = new Vector2(RenderSettings.fogStartDistance, RenderSettings.fogEndDistance);

            CalculateGrodOddQ(iHeight);
            InitialZoneList();
            CreateGroundTexture();
            ApplyChanged();
            InitPool();
            if (!m_bControlUsingLua)
            {
                #region 摆城市

                for (int i = 0; i < m_iSpawnCityCount; ++i)
                {
                    SpawnGroundCity("a", "", 1, -1, -1, -1, -1, -1, "a", "b", false, EBuildingType.MainCity);
                }

                #endregion

                #region 摆树

                for (int i = 0; i < m_iSpawnTreeCount; ++i)
                {
                    SpawnGroundItem(i, "a", -1, -1, 0, -1);
                }

                #endregion

                #region 摆行营
                for (int i = 0; i < m_iSpawnCityCount; ++i)
                {
                    SpawnGroundCity("Campsite", "行营Test", 1, -1, -1, -1, -1, -1, "行营Test", "", false, EBuildingType.Campsite);
                }

                #endregion
            }

            InitialOrClearTouchData();

            if (!m_bControlUsingLua)
            {
                m_dicUnionColor.Add(1, Color.gray);
                m_dicUnionColor.Add(2, Color.magenta);
                m_dicUnionColor.Add(3, Color.white);
            }

            m_Intantance = this;
        }

        public void CalculateGrodOddQ(int iHeight)
        {
            if (m_iGridHeight == iHeight)
            {
                return;
            }
            m_iGridHeight = iHeight;
            m_fHeightSep = m_fGroundSize / (m_iGridHeight + 0.5f);
            m_fEdgeWidth = m_fHeightSep / Mathf.Sqrt(3.0f);
            m_iGridWidth = Mathf.FloorToInt((m_fGroundSize - 2.0f * m_fEdgeWidth) / (1.5f * m_fEdgeWidth)) + 1;

            m_iMainCityWidthBegin = m_iDistanceFromEdge;
            m_iMainCityWidthEnd = m_iGridWidth - m_iDistanceFromEdge;
            m_iMainCityHeightBegin = m_iDistanceFromEdge;
            m_iMainCityHeightEnd = m_iGridHeight - m_iDistanceFromEdge;

            #region Intial Occupy Table 去掉倾斜度太夸张的格子，（换成Collider后很难处理“水下”的概念）

            m_byOccupy = new byte[m_iGridWidth, m_iGridHeight];
            m_byOccupyGround = new byte[m_iGridWidth, m_iGridHeight];
            m_iCityIndexTable = new List<int>[m_iGridWidth * m_iGridHeight];
            m_vUVOffset = new Vector2[]
            {
                new Vector2(m_fEdgeWidth / m_fGroundSize, 0.0f),
                new Vector2(0.5f * m_fEdgeWidth / m_fGroundSize, 0.5f * Mathf.Sqrt(3.0f) * m_fEdgeWidth / m_fGroundSize),
                new Vector2(-0.5f * m_fEdgeWidth / m_fGroundSize, 0.5f * Mathf.Sqrt(3.0f) * m_fEdgeWidth / m_fGroundSize),
                new Vector2(-m_fEdgeWidth / m_fGroundSize, 0.0f),
                new Vector2(-0.5f * m_fEdgeWidth / m_fGroundSize, -0.5f * Mathf.Sqrt(3.0f) * m_fEdgeWidth / m_fGroundSize),
                new Vector2(0.5f * m_fEdgeWidth / m_fGroundSize, -0.5f * Mathf.Sqrt(3.0f) * m_fEdgeWidth / m_fGroundSize),
            };

            // Vector3[] pos6 = new Vector3[m_vUVOffset.Length];
            // Vector3[] nor6 = new Vector3[m_vUVOffset.Length];
            for (int i = 0; i < m_iGridWidth; ++i)
            {
                for (int j = 0; j < m_iGridHeight; ++j)
                {
                    if (0 == i || 0 == j || (m_iGridWidth - 1) == i || (m_iGridHeight - 1) == j)
                    {
                        m_byOccupy[i, j] = 1;
                        m_byOccupyGround[i, j] = 1;
                        continue;
                    }

                    // Vector2 uv = OddQToUV(i, j);
                    // Vector3 pos, nor;
                    // GetPosNormal(uv, 0.0f, out pos, out nor);
                    // for (int k = 0; k < m_vUVOffset.Length; ++k)
                    // {
                    //     Vector3 pos1, nor1;
                    //     GetPosNormal(uv + m_vUVOffset[k], 0.0f, out pos1, out nor1);
                    //     pos6[k] = pos1;
                    //     nor6[k] = nor1;
                    // }
                    // Vector3 pos0, nor0;
                    // GetPosNormal(uv, 0.0f, out pos0, out nor0);

                    // #region 在水下

                    // if (pos.y < m_fWaterHeight)
                    // {
                    //    m_byOccupy[i, j] = 1;
                    //    m_byOccupyGround[i, j] = 1;
                    // }
                    // else
                    // {
                    //    for (int k = 0; k < 6; ++k)
                    //    {
                    //        if (pos6[k].y < m_fWaterHeight)
                    //        {
                    //            m_byOccupy[i, j] = 1;
                    //            m_byOccupyGround[i, j] = 1;
                    //            break;
                    //        }
                    //    }
                    // }

                    // #endregion

                    // #region 在陡坡

                    // if (0 == m_byOccupy[i, j])
                    // {
                    //     if (nor.y < TerrainParameters.SLOPE_RATIO1)
                    //     {
                    //         m_byOccupy[i, j] = 1;
                    //         m_byOccupyGround[i, j] = 1;
                    //     }
                    //     else
                    //     {
                    //         for (int k = 0; k < m_vUVOffset.Length; ++k)
                    //         {
                    //             if (Vector3.Dot(nor6[k], nor) < TerrainParameters.SLOPE_RATIO2)
                    //             {
                    //                 m_byOccupy[i, j] = 1;
                    //                 m_byOccupyGround[i, j] = 1;
                    //                 break;
                    //             }
                    //         }
                    //     }
                    // }

                    // #endregion
                }
            }

            #endregion

            #region 静态物件的格子索引

            m_lstStaticItems = new List<TerrainGroundStaticItem>[m_iGridWidth * m_iGridHeight];
            //for (int i = 0; i < m_lstAllStaticItems.Count; ++i)
            //{
            //    //重新计算UV
            //    Vector2 vUv = PosToUV(m_lstAllStaticItems[i].transform.position);
            //    int iX, iY;
            //    UVToNearestOddQ(vUv, out iX, out iY);
            //    if (null == m_lstStaticItems[iX*m_iGridHeight + iY])
            //    {
            //        m_lstStaticItems[iX * m_iGridHeight + iY] = new List<TerrainGroundStaticItem>();
            //    }
            //    m_lstStaticItems[iX * m_iGridHeight + iY].Add(m_lstAllStaticItems[i]);
            //}

            #endregion
        }

        public void SetTerrainParameters(
            int maxTouchCount,
            int invalidTouchId,
            int mouseTouchId,
            float touchStay,
            float holdTimeCheck,
            float moveDistanceCheck,
            float cameraTouchMoveMinSpeed,
            float cameraTouchMoveMaxSpeed,
            int cameraTouchMoveDeltaSpeed,
            int linePoolMin,
            int linePoolMax,
            int maincityPoolMin,
            int maincityPoolMax,
            int goldminePoolMin,
            int goldminePoolMax,
            int croplandPoolMin,
            int croplandPoolMax,
            int sawmillPoolMin,
            int sawmillPoolMax,
            int stonepitPoolMin,
            int stonepitPoolMax,
            int campsitePoolMin,
            int campsitePoolMax,
            float slopeRatio1,
            float slopeRatio2,
            int cityModelMinIndex,
            int cityModelMaxIndex,

            Color playerCityProjectorColor,
            Color playerUnionProjectorColor,
            Color noUnionProjectorColor,
            Color enemyUnionProjectorColor,
            Color penetrationColor,
            Color canPutCityColor,
            Color canNotPutCityColor,
            Color canPutCityGiColor,
            Color canNotPutCityGiColor,
            Vector4 putCityShaderParam,

            List<TerrainLuaDelegates.BlockPointInfo> blockPointInfo)
        {
            TerrainParameters.SetParameter(
                maxTouchCount,
                invalidTouchId,
                mouseTouchId,
                touchStay,
                holdTimeCheck,
                moveDistanceCheck,
                cameraTouchMoveMinSpeed,
                cameraTouchMoveMaxSpeed,
                cameraTouchMoveDeltaSpeed,
                linePoolMin,
                linePoolMax,
                maincityPoolMin,
                maincityPoolMax,
                goldminePoolMin,
                goldminePoolMax,
                croplandPoolMin,
                croplandPoolMax,
                sawmillPoolMin,
                sawmillPoolMax,
                stonepitPoolMin,
                stonepitPoolMax,
                campsitePoolMin,
                campsitePoolMax,
                slopeRatio1,
                slopeRatio2,
                cityModelMinIndex,
                cityModelMaxIndex,

                playerCityProjectorColor,
                playerUnionProjectorColor,
                noUnionProjectorColor,
                enemyUnionProjectorColor,
                penetrationColor,
                canPutCityColor,
                canNotPutCityColor,
                canPutCityGiColor,
                canNotPutCityGiColor,
                putCityShaderParam,
                blockPointInfo);

            resizePool();
            initBlockPoint();
        }

        #region 初始化Pool
        public void InitPool()
        {
            int poolInitCount = TerrainParameters.LINE_POOL_MIN;
            int poolMaxCount = TerrainParameters.LINE_POOL_MAX;
            m_pLinePool = new GameObjectPool("Arraw", m_pArrawPrefab, poolInitCount, poolMaxCount, transform);

            EBuildingType ebtype = EBuildingType.MainCity;
            poolInitCount = TerrainParameters.MAINCITY_POOL_MIN;
            poolMaxCount = TerrainParameters.MAINCITY_POOL_MAX;
            m_pGroundItemPool[(byte)ebtype] = new GameObjectPool(ebtype.ToString(), m_pCityPrefab, poolInitCount, poolMaxCount, transform);

            ebtype = EBuildingType.GoldMine;
            poolInitCount = TerrainParameters.GOLDMINE_POOL_MIN;
            poolMaxCount = TerrainParameters.GOLDMINE_POOL_MAX;
            m_pGroundItemPool[(byte)ebtype] = new GameObjectPool(ebtype.ToString(), m_pGoldMinePrefab, poolInitCount, poolMaxCount, transform);

            ebtype = EBuildingType.Cropland;
            poolInitCount = TerrainParameters.CROPLAND_POOL_MIN;
            poolMaxCount = TerrainParameters.CROPLAND_POOL_MAX;
            m_pGroundItemPool[(byte)ebtype] = new GameObjectPool(ebtype.ToString(), m_pCroplandPrefab, poolInitCount, poolMaxCount, transform);

            ebtype = EBuildingType.Sawmill;
            poolInitCount = TerrainParameters.SAWMILL_POOL_MIN;
            poolMaxCount = TerrainParameters.SAWMILL_POOL_MAX;
            m_pGroundItemPool[(byte)ebtype] = new GameObjectPool(ebtype.ToString(), m_pSawmillPrefab, poolInitCount, poolMaxCount, transform);

            ebtype = EBuildingType.StonePit;
            poolInitCount = TerrainParameters.STONEPIT_POOL_MIN;
            poolMaxCount = TerrainParameters.STONEPIT_POOL_MAX;
            m_pGroundItemPool[(byte)ebtype] = new GameObjectPool(ebtype.ToString(), m_pStonePitPrefab, poolInitCount, poolMaxCount, transform);

            ebtype = EBuildingType.Campsite;
            poolInitCount = TerrainParameters.CAMPSITE_POOL_MIN;
            poolMaxCount = TerrainParameters.CAMPSITE_POOL_MAX;
            m_pGroundItemPool[(byte)ebtype] = new GameObjectPool(ebtype.ToString(), m_pCampsitePrefab, poolInitCount, poolMaxCount, transform);
        }

        private void resizePool()
        {
            int poolInitCount = TerrainParameters.LINE_POOL_MIN;
            int poolMaxCount = TerrainParameters.LINE_POOL_MAX;
            m_pLinePool.GameObjectPoolResize(poolInitCount, poolMaxCount);

            EBuildingType ebtype = EBuildingType.MainCity;
            poolInitCount = TerrainParameters.MAINCITY_POOL_MIN;
            poolMaxCount = TerrainParameters.MAINCITY_POOL_MAX;
            m_pGroundItemPool[(byte)ebtype].GameObjectPoolResize(poolInitCount, poolMaxCount);
            ebtype = EBuildingType.GoldMine;
            poolInitCount = TerrainParameters.GOLDMINE_POOL_MIN;
            poolMaxCount = TerrainParameters.GOLDMINE_POOL_MAX;
            m_pGroundItemPool[(byte)ebtype].GameObjectPoolResize(poolInitCount, poolMaxCount);
            ebtype = EBuildingType.Cropland;
            poolInitCount = TerrainParameters.CROPLAND_POOL_MIN;
            poolMaxCount = TerrainParameters.CROPLAND_POOL_MAX;
            m_pGroundItemPool[(byte)ebtype].GameObjectPoolResize(poolInitCount, poolMaxCount);
            ebtype = EBuildingType.Sawmill;
            poolInitCount = TerrainParameters.SAWMILL_POOL_MIN;
            poolMaxCount = TerrainParameters.SAWMILL_POOL_MAX;
            m_pGroundItemPool[(byte)ebtype].GameObjectPoolResize(poolInitCount, poolMaxCount);
            ebtype = EBuildingType.StonePit;
            poolInitCount = TerrainParameters.STONEPIT_POOL_MIN;
            poolMaxCount = TerrainParameters.STONEPIT_POOL_MAX;
            m_pGroundItemPool[(byte)ebtype].GameObjectPoolResize(poolInitCount, poolMaxCount);
            ebtype = EBuildingType.Campsite;
            poolInitCount = TerrainParameters.CAMPSITE_POOL_MIN;
            poolMaxCount = TerrainParameters.CAMPSITE_POOL_MAX;
            m_pGroundItemPool[(byte)ebtype].GameObjectPoolResize(poolInitCount, poolMaxCount);
        }

        private void initBlockPoint()
        {
            foreach (var item in TerrainParameters.BlockPointInfo)
            {
                if (item.BlockX < m_iGridWidth && item.BlockY < m_iGridHeight)
                {
                    m_byOccupy[item.BlockX, item.BlockY] = 1;
                    m_byOccupyGround[item.BlockX, item.BlockY] = 1;
                }
                else
                {
                    Debug.LogError("block point | x or y index is out of range, please check it : " + item.BlockX + " " + item.BlockY);
                }
            }
        }

        #endregion

        /// <summary>
        /// OddQ坐标是否有效
        /// </summary>
        /// <param name="iX"></param>
        /// <param name="iY"></param>
        /// <returns></returns>
        private bool IsOddQCoordinateValid(int iX, int iY)
        {
            // 非法，越界
            if (iX < 0 || iX >= m_iGridWidth || iY < 0 || iY >= m_iGridHeight)
                return false;

            return true;
        }

        #region 地面静态物件以及优化

        private readonly GroundItemZoneLevel1[] m_lstItemZoneLevel1 = new GroundItemZoneLevel1[GroundItemZoneLevel1.ZoneWidth * GroundItemZoneLevel1.ZoneWidth];
        private readonly GroundItemZoneLevel2[] m_lstItemZoneLevel2 = new GroundItemZoneLevel2[GroundItemZoneLevel2.ZoneTotalSize * GroundItemZoneLevel2.ZoneTotalSize];

        private List<TerrainGroundStaticItem>[] m_lstStaticItems = null;
        //private readonly List<TerrainGroundStaticItem> m_lstAllStaticItems = new List<TerrainGroundStaticItem>();

        //为了避免重复的取Camera，所有地面静止物体加入到列表里，然后统一在Coordinate里做循环。
        public void AddStaticItem(TerrainGroundStaticItem item)
        {
            Vector2 vUv = PosToUV(item.transform.position);
            GetZoneByUV(vUv).m_pItems.Add(item);

            //m_lstAllStaticItems.Add(item); //以备重设格子
            if (!item.m_bCannotHide)
            {
                int iX, iY;
                UVToNearestOddQ(vUv, out iX, out iY);

                // 格子外的物体不需要加入列表，只需要做到一点，随着camera移动裁剪即可
                if (false == IsOddQCoordinateValid(iX, iY))
                {
                    return;
                }

                if (null == m_lstStaticItems[iX * m_iGridHeight + iY])
                {
                    m_lstStaticItems[iX * m_iGridHeight + iY] = new List<TerrainGroundStaticItem>();
                }
                m_lstStaticItems[iX * m_iGridHeight + iY].Add(item);
            }
        }
        /// <summary>
        /// 设置静态物体透明化，地图编辑器专用
        /// 退出场景后恢复原样
        /// </summary>
        public void SetStaticItemAsTransparentItem()
        {
            for (int i = 0; i < m_lstStaticItems.Length; ++i)
            {
                if (m_lstStaticItems[i] != null)
                {
                    for (int j = 0; j < m_lstStaticItems[i].Count; ++j)
                    {
                        if (m_lstStaticItems[i][j] != null)
                        {
                            m_lstStaticItems[i][j].SetTransparentMaterial();
                        }
                    }
                }
            }
        }

        private void HideStaticItemOddQ(int iX, int iY, int lvl)
        {
            // 使用下一级的范围覆盖树木,如果是最大等级 则使用最大等级
            lvl += 1;
            if (lvl >= TerrainGroundItem.m_byOccupyGrids.Length)
                lvl = TerrainGroundItem.m_byOccupyGrids.Length - 1;
            byte[,] occupyGrids = TerrainGroundItem.m_byOccupyGrids[lvl];

            if (occupyGrids == null)
            {
                return;
            }

            int halfX = occupyGrids.GetLength(0) / 2;
            int halfY = occupyGrids.GetLength(1) / 2;
            for (int i = 0; i < occupyGrids.GetLength(0); i++)
            {
                for (int j = 0; j < occupyGrids.GetLength(1); j++)
                {
                    if (occupyGrids[i, j] == 0)
                    {
                        continue;
                    }

                    int newX = iX + i - halfX;
                    int newY = iY + j - halfY;
                    List<TerrainGroundStaticItem> lstItem = m_lstStaticItems[newX * m_iGridHeight + newY];
                    if (null != lstItem)
                    {
                        for (int k = 0; k < lstItem.Count; ++k)
                        {
                            lstItem[k].m_bHideByCityOrResources = true;
                            if (lstItem[k].gameObject.activeSelf)
                            {
                                lstItem[k].gameObject.SetActive(false);
                            }
                        }
                    }
                }
            }
        }

        private void ResumeStaticItemOddQ(int iX, int iY, int lvl)
        {
            m_fTreeGrowStartTime = Time.time;
            // 使用下一级的范围恢复树木,如果是最大等级 则使用最大等级
            lvl += 1;
            if (lvl >= TerrainGroundItem.m_byOccupyGrids.Length)
                lvl = TerrainGroundItem.m_byOccupyGrids.Length - 1;
            byte[,] occupyGrids = TerrainGroundItem.m_byOccupyGrids[lvl];

            if (occupyGrids == null)
            {
                return;
            }

            StartCoroutine(TreeGrowUp(occupyGrids, iX, iY, lvl));
        }

        private IEnumerator TreeGrowUp(byte[,] occupyGrids, int iX, int iY, int lvl)
        {
            while (Time.time - m_fTreeGrowStartTime <= TREE_GROW_DURATION)
            {
                int halfX = occupyGrids.GetLength(0) / 2;
                int halfY = occupyGrids.GetLength(1) / 2;
                for (int i = 0; i < occupyGrids.GetLength(0); i++)
                {
                    for (int j = 0; j < occupyGrids.GetLength(1); j++)
                    {
                        if (occupyGrids[i, j] == 0)
                        {
                            continue;
                        }

                        int newX = iX + i - halfX;
                        int newY = iY + j - halfY;
                        List<TerrainGroundStaticItem> lstItem = m_lstStaticItems[newX * m_iGridHeight + newY];
                        if (null != lstItem)
                        {
                            for (int k = 0; k < lstItem.Count; ++k)
                            {
                                lstItem[k].m_bHideByCityOrResources = false;
                                lstItem[k].transform.localScale = Vector3.Lerp(new Vector3(0, 0, 0), lstItem[k].m_vLocalScale, (Time.time - m_fTreeGrowStartTime) / TREE_GROW_DURATION);
                            }
                        }
                    }
                }

                yield return null;
            }
        }

        private GroundItemZoneLevel2 GetZoneByUV(Vector2 vUv)
        {
            int iX = Mathf.Clamp(Mathf.FloorToInt(vUv.x * GroundItemZoneLevel2.ZoneTotalSize), 0, GroundItemZoneLevel2.ZoneTotalSize - 1);
            int iY = Mathf.Clamp(Mathf.FloorToInt(vUv.y * GroundItemZoneLevel2.ZoneTotalSize), 0, GroundItemZoneLevel2.ZoneTotalSize - 1);
            return m_lstItemZoneLevel2[iX * GroundItemZoneLevel2.ZoneTotalSize + iY];
        }

        private void InitialZoneList()
        {
            float fSep1 = 1.0f / GroundItemZoneLevel1.ZoneWidth;
            float fSep2 = 1.0f / GroundItemZoneLevel2.ZoneTotalSize;

            for (int i = 0; i < GroundItemZoneLevel1.ZoneWidth; ++i)
            {
                for (int j = 0; j < GroundItemZoneLevel1.ZoneWidth; ++j)
                {
                    GroundItemZoneLevel1 newOne = new GroundItemZoneLevel1
                    {
                        m_vLTCorner = new Vector2(i * fSep1, j * fSep1),
                        m_vRTCorner = new Vector2((i + 1) * fSep1, j * fSep1),
                        m_vLBCorner = new Vector2(i * fSep1, (j + 1) * fSep1),
                        m_vRBCorner = new Vector2((i + 1) * fSep1, (j + 1) * fSep1),
                    };

                    Vector3 vlt, vltn, vrt, vrtn, vlb, vlbn, vrb, vrbn;
                    GetPosNormal(newOne.m_vLTCorner, 0.0f, out vlt, out vltn);
                    GetPosNormal(newOne.m_vRTCorner, 0.0f, out vrt, out vrtn);
                    GetPosNormal(newOne.m_vLBCorner, 0.0f, out vlb, out vlbn);
                    GetPosNormal(newOne.m_vRBCorner, 0.0f, out vrb, out vrbn);
                    newOne.m_v3LTCorner = vlt;
                    newOne.m_v3RTCorner = vrt;
                    newOne.m_v3LBCorner = vlb;
                    newOne.m_v3RBCorner = vrb;

                    newOne.m_v3Center = 0.25f * (vlt + vrt + vlb + vrb);
                    newOne.m_fRadius = Mathf.Max(
                        (newOne.m_v3Center - vlt).magnitude,
                        (newOne.m_v3Center - vrt).magnitude,
                        (newOne.m_v3Center - vlb).magnitude,
                        (newOne.m_v3Center - vrb).magnitude
                        );
                    newOne.m_List = new GroundItemZoneLevel2[GroundItemZoneLevel2.ZoneWidth * GroundItemZoneLevel2.ZoneWidth];

                    for (int x = 0; x < GroundItemZoneLevel2.ZoneWidth; ++x)
                    {
                        for (int y = 0; y < GroundItemZoneLevel2.ZoneWidth; ++y)
                        {
                            int iX = i * GroundItemZoneLevel2.ZoneWidth + x;
                            int iY = j * GroundItemZoneLevel2.ZoneWidth + y;

                            GroundItemZoneLevel2 newOne2 = new GroundItemZoneLevel2
                            {
                                m_vLTCorner = new Vector2(iX * fSep2, iY * fSep2),
                                m_vRTCorner = new Vector2((iX + 1) * fSep2, iY * fSep2),
                                m_vLBCorner = new Vector2(iX * fSep2, (iY + 1) * fSep2),
                                m_vRBCorner = new Vector2((iX + 1) * fSep2, (iY + 1) * fSep2),
                            };

                            GetPosNormal(newOne2.m_vLTCorner, 0.0f, out vlt, out vltn);
                            GetPosNormal(newOne2.m_vRTCorner, 0.0f, out vrt, out vrtn);
                            GetPosNormal(newOne2.m_vLBCorner, 0.0f, out vlb, out vlbn);
                            GetPosNormal(newOne2.m_vRBCorner, 0.0f, out vrb, out vrbn);
                            newOne2.m_v3LTCorner = vlt;
                            newOne2.m_v3RTCorner = vrt;
                            newOne2.m_v3LBCorner = vlb;
                            newOne2.m_v3RBCorner = vrb;

                            newOne2.m_v3Center = 0.25f * (vlt + vrt + vlb + vrb);
                            newOne2.m_fRadius = Mathf.Max(
                                (newOne2.m_v3Center - vlt).magnitude,
                                (newOne2.m_v3Center - vrt).magnitude,
                                (newOne2.m_v3Center - vlb).magnitude,
                                (newOne2.m_v3Center - vrb).magnitude
                                );

                            newOne.m_List[x * GroundItemZoneLevel2.ZoneWidth + y] = newOne2;

                            m_lstItemZoneLevel2[iX * GroundItemZoneLevel2.ZoneTotalSize + iY] = newOne2;
                        }
                    }
                    m_lstItemZoneLevel1[i * GroundItemZoneLevel1.ZoneWidth + j] = newOne;
                }
            }
        }

        #endregion

        // Update is called once per frame
        // ReSharper disable once UnusedMember.Local
        private void Update()
        {
            if (!m_bEnterBigMap && m_bControlUsingLua)
            {
                return;
            }

            #region 摄像机移动以及检测点击

            bool bCameraCB = false;
            if (m_fCameraMoveTimeFull < 0.0f)
            {
                #region 鼠标点击

                InputCheckWithTouch(Time.deltaTime);
                //UpdateMouseInput(Time.deltaTime);

                #endregion
            }
            else
            {
                m_fCameraMoveTime += Time.deltaTime;
                float fRate = Mathf.Clamp01(m_fCameraMoveTime / m_fCameraMoveTimeFull);
                if (m_fCameraMoveTime >= m_fCameraMoveTimeFull)
                {
                    fRate = 1.0f;
                    m_fCameraMoveTimeFull = -1.0f;
                    bCameraCB = true;
                }

                fRate = 0.5f - 0.5f * Mathf.Cos(fRate * Mathf.PI);
                Vector2 vUVTOBe = m_vCameraMoveFrom * (1.0f - fRate) + m_vCameraMoveTo * fRate;
                m_vCameraPos.x = m_fGroundSize * (vUVTOBe.x - 0.5f);
                m_vCameraPos.y = m_fGroundSize * (vUVTOBe.y - 0.5f);
                m_vCameraPos.x = Mathf.Clamp(m_vCameraPos.x, m_fGroundSize * -0.5f, m_fGroundSize * 0.5f);
                m_vCameraPos.y = Mathf.Clamp(m_vCameraPos.y, m_fGroundSize * -0.5f, m_fGroundSize * 0.5f);
            }

            Vector3 vGround;
            if (m_bCurve)
            {
                float fDegreeX = m_vCameraPos.x * m_fCurveDegree / m_fGroundSize;
                float fDegreeY = m_vCameraPos.y * m_fCurveDegree / m_fGroundSize;
                Vector3 vNormal = (Quaternion.AngleAxis(fDegreeX, new Vector3(0.0f, 0.0f, -1.0f)) * Quaternion.AngleAxis(fDegreeY, new Vector3(1.0f, 0.0f, 0.0f))) * Vector3.up;
                Vector3 vCameraDir = (Quaternion.AngleAxis(fDegreeX, new Vector3(0.0f, 0.0f, -1.0f)) * Quaternion.AngleAxis(fDegreeY, new Vector3(1.0f, 0.0f, 0.0f))) * m_vCameraDir;
                vGround = vNormal * m_fCurveRadius - Vector3.up * m_fCurveRadius;

                Camera.main.transform.position = vGround + vCameraDir * m_vCameraPos.z;
                Camera.main.transform.LookAt(vGround, vNormal);
            }
            else
            {
                vGround = new Vector3(m_vCameraPos.x, 0.0f, m_vCameraPos.y);
                Camera.main.transform.position = vGround + m_vCameraDir * m_vCameraPos.z;
                if (m_iCameraTouch2 != -1)
                {
                    // 获得相机现在看的中心点
                    Vector2 vUV = CameraPointTo();
                    Vector3 cameraPointToPos, cameraPointToNomal;
                    GetPosNormal(vUV, 0, out cameraPointToPos, out cameraPointToNomal);
                    Camera.main.transform.LookAt(cameraPointToPos);

                    //雾效随镜头拉近拉远而变化
                    //滑动开始前的固定距离
                    double fStartDistance = Math.Sqrt(m_fCameraHeight * m_fCameraHeight + m_fCameraOffset * m_fCameraOffset);
                    //当前滑动的距离
                    double fCurrentDistance = m_fCameraOffset / Math.Cos(Camera.main.transform.localEulerAngles.x * Math.PI / 180);
                    float fIncreaseValue = (float)(fCurrentDistance - fStartDistance);
                    // 设置雾效参数
                    RenderSettings.fogEndDistance = m_vFogDistance.y + fIncreaseValue;
                    RenderSettings.fogStartDistance = m_vFogDistance.x + fIncreaseValue;
                }
            }
            OnCameraMoved(new Vector2(m_vCameraPos.x / m_fGroundSize + 0.5f, m_vCameraPos.y / m_fGroundSize + 0.5f));

            if (bCameraCB) //我们在移动发生后再CB
            {
                if (!string.IsNullOrEmpty(m_sCameraCBFunction) && null != m_pCameraMoveCb)
                {
                    m_pCameraMoveCb(m_sCameraCBFunction, m_sCameraCBKeyword, true);
                }
                m_pCameraMoveCb = null;
                m_sCameraCBFunction = "";
                m_sCameraCBKeyword = "";
            }

            #endregion

            #region 影藏和显示

            Camera cMain = Camera.main;
            Vector3 vCameraPos = cMain.transform.position;
            Vector3 vCameraForward = cMain.transform.forward;
            float fov = Mathf.Sin(cMain.fieldOfView * 0.5f * Mathf.Deg2Rad);
            fov = (1 + cMain.aspect * cMain.aspect) * fov * fov / (1 + cMain.aspect * cMain.aspect * fov * fov);
            fov = Mathf.Sqrt(1.0f - fov);

            //仅决定需要检查谁
            for (int i = 0; i < m_lstItemZoneLevel1.Length; ++i)
            {
                GroundItemZoneLevel1 lst = m_lstItemZoneLevel1[i];

                Vector3 vBallToCamera = lst.m_v3Center - vCameraPos;
                Vector3 vBallCenterToRadius =
                    Vector3.Cross(Vector3.Cross(vCameraForward, vBallToCamera), vCameraForward).normalized * lst.m_fRadius;

                Vector3 vNearest = vCameraPos + vCameraForward * Vector3.Dot(vBallToCamera, vCameraForward);

                bool bInteract =
                    Vector3.Dot((vBallToCamera - vBallCenterToRadius).normalized, vCameraForward) > fov
                  || (lst.m_v3Center - vNearest).sqrMagnitude < lst.m_fRadius * lst.m_fRadius;

                //vBallCenterToRadius是球距离视锥最近的点，如果看不到他就看不到了
                if (bInteract && vBallToCamera.magnitude - lst.m_fRadius < m_fFogDistance)
                {
                    //Debug.Log("zone :" + i + "has item :" + lst.m_pItems.Count);

                    lst.m_bSleeped = false;
                    for (int j = 0; j < lst.m_List.Length; ++j)
                    {
                        GroundItemZoneLevel2 lstLevel2 = lst.m_List[j];

                        if (0 == lstLevel2.m_pItems.Count && 0 == lstLevel2.m_pDynamicItems.Count)
                        {
                            if (!lstLevel2.m_bSleeped)
                            {
                                lstLevel2.Sleep();
                            }
                            continue;
                        }

                        vBallToCamera = lstLevel2.m_v3Center - vCameraPos;
                        vBallCenterToRadius = Vector3.Cross(Vector3.Cross(vCameraForward, vBallToCamera), vCameraForward).normalized * lstLevel2.m_fRadius;
                        vNearest = vCameraPos + vCameraForward * Vector3.Dot(vBallToCamera, vCameraForward);
                        bInteract = Vector3.Dot((vBallToCamera - vBallCenterToRadius).normalized, vCameraForward) > fov
                          || (lstLevel2.m_v3Center - vNearest).sqrMagnitude < lstLevel2.m_fRadius * lstLevel2.m_fRadius;

                        if (bInteract && vBallToCamera.magnitude - lstLevel2.m_fRadius < m_fFogDistance)
                        {
                            lstLevel2.m_bShouldCheck = true;
                        }
                        else
                        {
                            lstLevel2.m_bShouldCheck = false;
                        }
                    }
                }
                else if (!lst.m_bSleeped)
                {
                    lst.Sleep();
                }
            }

            for (int i = 0; i < m_lstItemZoneLevel2.Length; ++i)
            {
                GroundItemZoneLevel2 lst = m_lstItemZoneLevel2[i];
                if (m_lstItemZoneLevel2[i].m_bShouldCheck)
                {
                    lst.m_bSleeped = false;
                    for (int j = 0; j < lst.m_pItems.Count; ++j)
                    {
                        TerrainGroundStaticItem item = lst.m_pItems[j];
                        if (item.m_bHideByCityOrResources || item.m_bCannotHide)
                        {
                            continue;
                        }
                        Vector3 vToCamera = item.transform.position - vCameraPos;
                        float fMag = vToCamera.magnitude;
                        if (Vector3.Dot(vToCamera, vCameraForward) < fMag * fov || fMag > m_fFogDistance)
                        {
                            if (item.gameObject.activeSelf)
                            {
                                item.gameObject.SetActive(false);
                            }
                        }
                        else
                        {
                            if (!item.gameObject.activeSelf)
                            {
                                item.gameObject.SetActive(true);
                            }
                        }
                    }

                    for (int j = 0; j < lst.m_pDynamicItems.Count; ++j)
                    {
                        GroundItemInfo gi = lst.m_pDynamicItems[j];
                        Vector3 vToCamera = gi.m_vGroundItemPos - vCameraPos;
                        float fMag = vToCamera.magnitude;
                        if (Vector3.Dot(vToCamera, vCameraForward) < fMag * fov || fMag > m_fFogDistance)
                        {
                            if (null != gi.m_GameObject)
                            {
                                gi.m_bPenetrate = gi.m_Script.IsPenentrate(); //这一步似乎没必要
                                gi.m_bSelected = gi.m_Script.IsSelected(); //这一步似乎没必要
                                gi.m_Pool.ReturnObjectToPool(((EBuildingType)gi.m_byGroundItemType).ToString(), gi.m_GameObject);
                                gi.m_GameObject = null;
                                gi.m_Script = null;
                            }
                        }
                        else
                        {
                            if (null == gi.m_GameObject)
                            {
                                switch ((EBuildingType)gi.m_byGroundItemType)
                                {
                                    case EBuildingType.MainCity:
                                    case EBuildingType.Campsite:
                                        gi.m_GameObject = gi.m_Pool.NextAvailableObject();
                                        gi.m_GameObject.transform.position = gi.m_vGroundItemPos;
                                        gi.m_GameObject.transform.LookAt(gi.m_vGroundItemPos + gi.m_vGroundItemRotationLook, gi.m_vGroundItemRotationUp);
                                        //美术应该就是按照地图大小做的尺寸,不再改
                                        //gi.m_GameObject.transform.localScale = gi.m_vGroundItemScale;
                                        gi.m_Script = gi.m_GameObject.GetComponent<TerrainGroundItem>();
                                        gi.m_Script.Initial(this, gi, gi.m_iOddQX, gi.m_iOddQY, gi.m_iItemGrade, gi.m_iModelIndex);
                                        gi.m_Script.OnSelected(gi.m_bSelected);
                                        gi.m_Script.UpdateUIContent(gi);
                                        gi.m_Script.enabled = true;

                                        break;
                                    case EBuildingType.Cropland:
                                    case EBuildingType.GoldMine:
                                    case EBuildingType.Sawmill:
                                    case EBuildingType.StonePit:
                                        gi.m_GameObject = gi.m_Pool.NextAvailableObject();
                                        gi.m_GameObject.transform.position = gi.m_vGroundItemPos;
                                        gi.m_GameObject.transform.LookAt(gi.m_vGroundItemPos + gi.m_vGroundItemRotationLook, gi.m_vGroundItemRotationUp);
                                        //美术应该就是按照地图大小做的尺寸,不再改
                                        //gi.m_GameObject.transform.localScale = gi.m_vGroundItemScale;
                                        gi.m_Script = gi.m_GameObject.GetComponent<TerrainGroundItem>();
                                        gi.m_Script.Initial(this, gi, gi.m_iOddQX, gi.m_iOddQY, 0, gi.m_iModelIndex);
                                        gi.m_Script.OnPenentrate(gi.m_bPenetrate, true);
                                        gi.m_Script.enabled = true;
                                        break;
                                }
                            }
                        }
                    }
                }
                else if (!lst.m_bSleeped)
                {
                    lst.Sleep();
                }
            }

            #endregion

            if (m_bSelectCitiesArroundCamera)
            {
                UpdateCameraSelection();
            }
        }

        #region 造城造建筑

        private int m_iMyUnion = 0;
        public int MyUnion() { return m_iMyUnion; }
        private int m_iMyCity = -1;
        public int MyCity() { return m_iMyCity; }
        private GroundItemInfo PutPrefabAt(int iId, int iGrade, byte byType, int iX, int iY, int iModelIndex)
        {
            Vector2 vUv = OddQToUV(iX, iY);
            Vector3 vPos, vNormal;
            if (byType == (byte)EBuildingType.Campsite)
            {
                GetPosNormal(vUv, 0.6f, out vPos, out vNormal);
            }
            else
            {
                GetPosNormal(vUv, 0.0f, out vPos, out vNormal);
            }
            Vector3 vLookDir = Vector3.Cross(vNormal, Vector3.left).normalized;
            Vector3 vScale = Vector3.one * m_fHeightSep;

            GroundItemInfo itemInfo = new GroundItemInfo
            {
                m_bPenetrate = false,
                m_bSelected = false,
                m_iGroundItemId = iId,
                m_iItemGrade = iGrade,
                m_byGroundItemType = byType,
                m_vGroundItemPos = vPos,
                m_vGroundItemRotationLook = vLookDir,
                m_vGroundItemRotationUp = vNormal,
                m_vGroundItemScale = vScale,
                m_iOddQX = iX,
                m_iOddQY = iY,
                m_iModelIndex = iModelIndex,
                m_Zone = GetZoneByUV(vUv),
                m_Pool = m_pGroundItemPool[byType],
            };
            itemInfo.m_Zone.m_pDynamicItems.Add(itemInfo);
            return itemInfo;
        }

        private readonly int[] m_iTestRandomUnion = { 0, 1, 2, 3 };
        private readonly string[] m_sTestRandomUnion = { "", "Union A", "Union B", "Union C" };
        private int m_iCityId = 0;

        private readonly Dictionary<int, string> m_sUnionNameDic = new Dictionary<int, string>(new IntEqualityComparer());


        private int m_iMinModelIndex = TerrainParameters.CITY_MODEL_MIN_INDEX;
        private int m_iMaxModelIndex = TerrainParameters.CITY_MODEL_MAX_INDEX;

        private void SetOccupied(int iX, int iY, GroundItemInfo item, string sInflenceId, int m_iCityId)
        {
            int iDeltaY2 = (0 == (iX & 1)) ? -1 : 1;

            m_byOccupy[iX, iY] = 1;
            m_pSelectableTable[iX * m_iGridHeight + iY] = item;
            if (iX - 1 >= 0)
            {
                m_byOccupy[iX - 1, iY] = 1;
                m_pSelectableTable[(iX - 1) * m_iGridHeight + iY] = item;
                if (iY + iDeltaY2 >= 0 && iY + iDeltaY2 < m_iGridHeight)
                {
                    m_byOccupy[iX - 1, iY + iDeltaY2] = 1;
                    m_pSelectableTable[(iX - 1) * m_iGridHeight + iY + iDeltaY2] = item;
                }
            }
            if (iX + 1 < m_iGridHeight)
            {
                m_byOccupy[iX + 1, iY] = 1;
                m_pSelectableTable[(iX + 1) * m_iGridHeight + iY] = item;
                if (iY + iDeltaY2 >= 0 && iY + iDeltaY2 < m_iGridHeight)
                {
                    m_byOccupy[iX + 1, iY + iDeltaY2] = 1;
                    m_pSelectableTable[(iX + 1) * m_iGridHeight + iY + iDeltaY2] = item;
                }
            }

            if (iY - 1 >= 0)
            {
                m_byOccupy[iX, iY - 1] = 1;
                m_pSelectableTable[iX * m_iGridHeight + iY - 1] = item;
            }
            if (iY + 1 < m_iGridHeight)
            {
                m_byOccupy[iX, iY + 1] = 1;
                m_pSelectableTable[iX * m_iGridHeight + iY + 1] = item;
            }

            if (m_pSelectableTableById.ContainsKey(m_iCityId))
            {
                Debug.LogWarning("重复的city id: " + m_iCityId);
            }
            m_pSelectableTableById[m_iCityId] = item;
            m_GroundItemInfos.Add(item);
            m_CityGroundItemInfos.Add(item);
            if (m_InflenceIdToCities.ContainsKey(sInflenceId))
            {
                if (null == m_InflenceIdToCities[sInflenceId])
                {
                    m_InflenceIdToCities[sInflenceId] = new List<int>();
                }
                m_InflenceIdToCities[sInflenceId].Add(m_iCityId);
            }
            else
            {
                m_InflenceIdToCities[sInflenceId] = new List<int>();
                m_InflenceIdToCities[sInflenceId].Add(m_iCityId);
            }
        }

        private void CheckSize(int iX, int iY, int iCityGrade, int iCityId)
        {
            #region 范围检测

            byte[,] occupy = TerrainGroundItem.m_byOccupyGrids[iCityGrade];
            int iWidth = occupy.GetLength(0);
            int iHalfWidth = (iWidth + 1) / 2;
            int iHeight = occupy.GetLength(1);
            bool bOffset = (0 != (iX & 1));
            if (0 == (iHalfWidth & 1))
            {
                bOffset = !bOffset;
            }

            for (int x = 0; x < iWidth; ++x)
            {
                for (int y = 0; y < iHeight; ++y)
                {
                    int iCheckX = iX - (iWidth - 1) / 2 + x;
                    int iOffset = (bOffset && (0 == (iCheckX & 1)) ? 1 : 0);
                    int iCheckY = iY - (iHeight - 1) / 2 + y + iOffset;
                    if (0 == (iHalfWidth & 1) && bOffset)
                    {
                        --iCheckY;
                    }
                    int iGrid = iCheckX * m_iGridHeight + iCheckY;
                    if (iCheckX >= 0 && iCheckX < m_iGridWidth
                     && iCheckY >= 0 && iCheckY < m_iGridHeight
                     && 1 == occupy[x, y])
                    {
                        if (null == m_iCityIndexTable[iGrid])
                        {
                            m_iCityIndexTable[iGrid] = new List<int>();
                        }
                        if (!m_iCityIndexTable[iGrid].Contains(iCityId))
                        {
                            m_iCityIndexTable[iGrid].Add(iCityId);
                        }
                    }
                }
            }

            #endregion
        }
        /// <summary>
        /// 造城
        /// </summary>
        /// <param name="sInflenceId"></param>
        /// <param name="sPlayerName"></param>
        /// <param name="iPlayerLevel"></param>
        /// <param name="iOddQX"></param>
        /// <param name="iOddQY"></param>
        /// <param name="iCityGrade"></param>
        /// <param name="iModelIndex"></param>
        /// <param name="iUnionId"></param>
        /// <param name="sUnionName"></param> 
        /// <param name="bIsPlayer"></param>
        /// <returns></returns>
        public int SpawnGroundCity(string sInflenceId, string sPlayerName, int iPlayerLevel, int iOddQX, int iOddQY,
            int iCityGrade, int iModelIndex, int iUnionId, string sUnionName, string sFlagGuildFlagName, bool bIsPlayer, EBuildingType type)
        {
            // 格子外的物体不做处理
            if (false == IsOddQCoordinateValid(iOddQX, iOddQY))
            {
                Debug.LogWarning(string.Format("不能建城，非法坐标: {0}, {1}", iOddQX, iOddQY));
                return -1;
            }

            ++m_iCityId;

            if (iUnionId > 0)
            {
                m_sUnionNameDic[iUnionId] = sUnionName;
            }
            if (iModelIndex < 0)
            {
                iModelIndex = Random.Range(m_iMinModelIndex, m_iMaxModelIndex + 1);
            }
            iModelIndex = Mathf.Clamp(iModelIndex, m_iMinModelIndex, m_iMaxModelIndex);
            int iX = iOddQX, iY = iOddQY;
            bool bRandom = false;
            if (iCityGrade < 0)
            {
                iCityGrade = Random.Range((int)ECityRange.Grid1, (int)ECityRange.Max);
            }
            iCityGrade = Mathf.Clamp(iCityGrade, (int)ECityRange.Grid1, (int)ECityRange.Grid8);
            if (iOddQX < 0 || iOddQY < 0)
            {
                iX = Random.Range(m_iMainCityWidthBegin, m_iMainCityWidthEnd - 1);
                iY = Random.Range(m_iMainCityHeightBegin, m_iMainCityHeightEnd - 1);
                bRandom = true;
            }

            if (bRandom)
            {
                iUnionId = m_iTestRandomUnion[Random.Range(0, m_sTestRandomUnion.Length)];
                sUnionName = m_sTestRandomUnion[Random.Range(0, m_sTestRandomUnion.Length)];
                bIsPlayer = -1 == m_iMyCity;
            }

            if (bRandom)
            {
                int iDeltaY = (0 == (iX & 1)) ? -1 : 1;
                if (1 == m_byOccupy[iX, iY]
                 || 1 == m_byOccupy[iX + 1, iY]
                 || 1 == m_byOccupy[iX - 1, iY]
                 || 1 == m_byOccupy[iX, iY + 1]
                 || 1 == m_byOccupy[iX, iY - 1]
                 || 1 == m_byOccupy[iX + 1, iY + iDeltaY]
                 || 1 == m_byOccupy[iX - 1, iY + iDeltaY])
                {
                    iX = Random.Range(m_iMainCityWidthBegin, m_iMainCityWidthEnd - 1);
                    iY = Random.Range(m_iMainCityHeightBegin, m_iMainCityHeightEnd - 1);
                }
                iDeltaY = (0 == (iX & 1)) ? -1 : 1;
                if (1 == m_byOccupy[iX, iY]
                 || 1 == m_byOccupy[iX + 1, iY]
                 || 1 == m_byOccupy[iX - 1, iY]
                 || 1 == m_byOccupy[iX, iY + 1]
                 || 1 == m_byOccupy[iX, iY - 1]
                 || 1 == m_byOccupy[iX + 1, iY + iDeltaY]
                 || 1 == m_byOccupy[iX - 1, iY + iDeltaY])
                {
                    iX = Random.Range(m_iMainCityWidthBegin, m_iMainCityWidthEnd - 1);
                    iY = Random.Range(m_iMainCityHeightBegin, m_iMainCityHeightEnd - 1);
                }
            }
            GroundItemInfo item = PutPrefabAt(m_iCityId, iCityGrade, (byte)type, iX, iY, iModelIndex);
            item.m_sGroundItemOwner = sInflenceId;
            item.m_iGroundItemUnionId = iUnionId;
            item.m_sPlayerName = sPlayerName;
            item.m_iPlayerLevel = iPlayerLevel;
            item.m_sUnionFlagName = sUnionName;
            item.m_sWhiteFlag = sFlagGuildFlagName;
            item.m_bIsPlayerMainCity = bIsPlayer;
            if (bIsPlayer)
            {
                m_iMyCity = m_iCityId;
                m_iMyUnion = iUnionId;
            }

            SetOccupied(iX, iY, item, sInflenceId, m_iCityId);
            CheckSize(iX, iY, iCityGrade, m_iCityId);

            #region 如果是玩家的主城，设为选中状态

            if (!m_bMoveCityMode && !m_bSelectCitiesArroundCamera)
            {
                if (AddSeleteMyCity())
                {
                    RefreshGroundPenentration();
                }
            }

            #endregion

            HideStaticItemOddQ(iX, iY, iCityGrade);

            return m_iCityId;
        }

        /// <summary>
        /// 造资源建筑
        /// </summary>
        /// <param name="iId"></param>
        /// <param name="sInflenceId"></param>
        /// <param name="iOddQX"></param>
        /// <param name="iOddQY"></param>
        /// <param name="byType"></param>
        /// <param name="iModelIndex"></param>
        public void SpawnGroundItem(int iId, string sInflenceId, int iOddQX, int iOddQY, byte byType, int iModelIndex)
        {
            // 格子外的物体不做处理
            if (false == IsOddQCoordinateValid(iOddQX, iOddQY))
            {
                Debug.LogWarning(string.Format("不能建资源点，非法坐标: {0}, {1}", iOddQX, iOddQY));
                return;
            }

            //++m_iGroundResourcesId;
            if (iModelIndex < 0)
            {
                iModelIndex = Random.Range(m_iMinModelIndex, m_iMaxModelIndex + 1);
            }
            iModelIndex = Mathf.Clamp(iModelIndex, m_iMinModelIndex, m_iMaxModelIndex);
            int iX = iOddQX, iY = iOddQY;
            bool bRandome = false;
            if (0 == byType)
            {
                byType = (byte)Random.Range((byte)EBuildingType.GoldMine, (byte)EBuildingType.StonePit + 1);
            }
            byType = (byte)Mathf.Clamp(byType, (byte)EBuildingType.GoldMine, (byte)EBuildingType.StonePit);
            if (iX < 0 || iY < 0)
            {
                iX = Random.Range(0, m_iGridWidth);
                iY = Random.Range(0, m_iGridHeight);
                bRandome = true;
            }

            if (bRandome)
            {
                if (1 == m_byOccupy[iX, iY])
                {
                    iX = Random.Range(0, m_iGridWidth);
                    iY = Random.Range(0, m_iGridHeight);
                }
                if (1 == m_byOccupy[iX, iY])
                {
                    iX = Random.Range(0, m_iGridWidth);
                    iY = Random.Range(0, m_iGridHeight);
                }
            }

            GroundItemInfo item = PutPrefabAt(iId, 1, byType, iX, iY, iModelIndex);
            item.m_sGroundItemOwner = sInflenceId;
            item.m_bPenetrate = IsConfict(m_iCityIndexTable[iX * m_iGridHeight + iY]);
            m_byOccupy[iX, iY] = 1;
            m_pUnselectableTable[iX * m_iGridHeight + iY] = item;
            if (m_pUnselectableTableById.ContainsKey(iId))
            {
                Debug.LogWarning("重复的资源 id: " + iId);
            }
            if (string.IsNullOrEmpty(sInflenceId))
            {
                Debug.LogWarning("资源的势力id为空");
            }
            m_pUnselectableTableById[iId] = item;
            m_GroundItemInfos.Add(item);

            HideStaticItemOddQ(iX, iY, item.m_iItemGrade);
            //return m_iGroundResourcesId;
        }
        #endregion

        #region 坐标转换

        /// <summary>
        /// 如果设置了m_iGridHeight，可以直接生成一套(h*sqrt(3)/1.5 x h)的六边形格子系统
        /// 然后传入odd-q的格子位置(iX, iY)返回一个UV=(0-1.0, 0-1.0)
        /// </summary>
        /// <param name="iX"></param>
        /// <param name="iY"></param>
        /// <returns></returns>
        public Vector2 OddQToUV(int iX, int iY)
        {
            float fX = m_fEdgeWidth + 1.5f * m_fEdgeWidth * iX;
            float fY = (iY + 0.5f + 0.5f * (iX & 1)) * m_fHeightSep;
            return new Vector2(Mathf.Clamp01(fX / m_fGroundSize), Mathf.Clamp01(fY / m_fGroundSize));
        }

        /// <summary>
        /// 坐标转换
        /// </summary>
        /// <param name="vUV"></param>
        /// <param name="iX"></param>
        /// <param name="iY"></param>
        public void UVToNearestOddQ(Vector2 vUV, out int iX, out int iY)
        {
            iX = Mathf.RoundToInt((vUV.x * m_fGroundSize - m_fEdgeWidth) / (1.5f * m_fEdgeWidth));
            iY = Mathf.RoundToInt((vUV.y * m_fGroundSize) / m_fHeightSep - 0.5f - 0.5f * (iX & 1));
        }

        /// <summary>
        /// 给一个3维的点，返回UV
        /// </summary>
        /// <param name="vPos"></param>
        /// <param name="bPosOnGround">不再支持heightmap的方式</param>
        /// <returns></returns>
        public Vector2 PosToUV(Vector3 vPos, bool bPosOnGround = true)
        {
            //平面的
            if (!m_bCurve)
            {
                return new Vector2(vPos.x / m_fGroundSize + 0.5f, vPos.z / m_fGroundSize + 0.5f);
            }

            //这是借助Heightmap的方式,暂时关掉
            //float fRealRadius1 = (vPos - Vector3.down * m_fCurveRadius).magnitude;//m_fCurveRadius + (m_fMaxHeight - m_fMinHeight) * 0.5f;
            //float fDegreeX = Mathf.Asin(vPos.x / Mathf.Sqrt(fRealRadius1 * fRealRadius1 - vPos.z * vPos.z)) * Mathf.Rad2Deg;
            //float fDegreeY = Mathf.Asin(vPos.z / (Mathf.Sqrt(fRealRadius1 * fRealRadius1 - vPos.x * vPos.x) / Mathf.Cos(fDegreeX * Mathf.Deg2Rad))) * Mathf.Rad2Deg;

            //if (!bPosOnGround)
            //{
            //    //we are almost there
            //    int iSearchX = Mathf.Clamp(Mathf.RoundToInt((fDegreeX / m_fCurveDegree + 0.5f) * m_iVertexCount), 0, m_iVertexCount);
            //    int iSearchY = Mathf.Clamp(Mathf.RoundToInt((fDegreeY / m_fCurveDegree + 0.5f) * m_iVertexCount), 0, m_iVertexCount);
            //    int iSearchWidth = Mathf.CeilToInt((m_fMaxHeight - m_fMinHeight) * 0.5f * m_iVertexCount / m_fGroundSize);
            //    iSearchWidth = Mathf.Max(iSearchWidth, 1); //at least 1

            //    float fFinalHeight = (m_fMaxHeight - m_fMinHeight) * 0.5f;
            //    float fClosest = -1.0f;
            //    int iHalfCount = (m_iVertexCount - 1) / 2;
            //    for (int i = iSearchX - iSearchWidth; i < iSearchX + iSearchWidth + 1; ++i)
            //    {
            //        for (int j = iSearchY - iSearchWidth; j < iSearchY + iSearchWidth + 1; ++j)
            //        {
            //            if (i > 0 && i < m_iVertexCount
            //             && j > 0 && j < m_iVertexCount)
            //            {
            //                Color32 c1 = m_pHeightPixes[i * m_iVertexCount + j];
            //                float fdx1 = m_fCurveDegree * 0.5f * (i - iHalfCount) / iHalfCount;
            //                float fdy1 = m_fCurveDegree * 0.5f * (j - iHalfCount) / iHalfCount;
            //                Vector3 n1 = (Quaternion.AngleAxis(fdx1, new Vector3(0.0f, 0.0f, -1.0f)) * Quaternion.AngleAxis(fdy1, new Vector3(1.0f, 0.0f, 0.0f))) * Vector3.up;
            //                float fHeight = (c1.r * (1 << 16) + c1.g * (1 << 8) + c1.b) * (m_fMaxHeight - m_fMinHeight) / (1 << 24) + m_fMinHeight;
            //                Vector3 p1 = (m_fCurveRadius + fHeight) * n1 - Vector3.up * m_fCurveRadius;

            //                float fDist = (p1.x - vPos.x) * (p1.x - vPos.x) + (p1.z - vPos.z) * (p1.z - vPos.z);
            //                if (fClosest < 0.0f || fDist < fClosest)
            //                {
            //                    fClosest = fDist;
            //                    fFinalHeight = fHeight;
            //                }
            //            }
            //        }
            //    }

            //    fRealRadius1 = m_fCurveRadius + fFinalHeight;
            //    fDegreeX = Mathf.Asin(vPos.x / Mathf.Sqrt(fRealRadius1 * fRealRadius1 - vPos.z * vPos.z)) * Mathf.Rad2Deg;
            //    fDegreeY = Mathf.Asin(vPos.z / Mathf.Sqrt(fRealRadius1 * fRealRadius1 - vPos.x * vPos.x) / Mathf.Cos(fDegreeX * Mathf.Deg2Rad)) * Mathf.Rad2Deg;                


            //}

            //return new Vector2(fDegreeX / m_fCurveDegree + 0.5f, fDegreeY / m_fCurveDegree + 0.5f);

            float fRealRadius1 = (vPos - Vector3.down * m_fCurveRadius).magnitude;
            float fDegreeX = Mathf.Asin(vPos.x / Mathf.Sqrt(fRealRadius1 * fRealRadius1 - vPos.z * vPos.z)) * Mathf.Rad2Deg;
            float fDegreeY = Mathf.Asin(vPos.z / (Mathf.Sqrt(fRealRadius1 * fRealRadius1 - vPos.x * vPos.x) / Mathf.Cos(fDegreeX * Mathf.Deg2Rad))) * Mathf.Rad2Deg;
            return new Vector2(fDegreeX / m_fCurveDegree + 0.5f, fDegreeY / m_fCurveDegree + 0.5f);
        }

        /// <summary>
        /// 传入UV（0-1,0-1），返回地表的位置和法线。
        /// 用于平面的地表
        /// 有传闻美术觉得贴图精度不够要换回terrain转mesh的做法，这个函数实现保留着
        /// </summary>
        //public void GetPosNormal(Vector2 vUv, out Vector3 vPos, out Vector3 vNormal)
        //{
        //    float fX = vUv.x * (m_iVertexCount - 1);
        //    float fY = vUv.y * (m_iVertexCount - 1);
        //    int iX = Mathf.FloorToInt(fX);
        //    int iY = Mathf.FloorToInt(fY);
        //    float fracX = fX - iX;
        //    float fracY = fY - iY;
        //    if (iX < 0) { iX = 0; fracX = 0.0f; }
        //    if (iX >= m_iVertexCount - 1) { iX = m_iVertexCount - 2; fracX = 1.0f; }
        //    if (iY < 0) { iY = 0; fracY = 0.0f; }
        //    if (iY >= m_iVertexCount - 1) { iY = m_iVertexCount - 2; fracY = 1.0f; }

        //    if (fracX + fracY < 1.0f)
        //    {
        //        Color32 c1 = m_pHeightPixes[iX * m_iVertexCount + iY];
        //        Color32 c2 = m_pHeightPixes[(iX + 1) * m_iVertexCount + iY];
        //        Color32 c3 = m_pHeightPixes[iX * m_iVertexCount + (iY + 1)];
        //        Vector3 p1 = new Vector3(
        //            ((iX + 0) / (m_iVertexCount - 1.0f) - 0.5f) * m_fGroundSize,
        //            (c1.r * (1 << 16) + c1.g * (1 << 8) + c1.b) * (m_fMaxHeight - m_fMinHeight) / (1 << 24) + m_fMinHeight,
        //            ((iY + 0) / (m_iVertexCount - 1.0f) - 0.5f) * m_fGroundSize);

        //        Vector3 p2 = new Vector3(
        //            ((iX + 1) / (m_iVertexCount - 1.0f) - 0.5f) * m_fGroundSize,
        //            (c2.r * (1 << 16) + c2.g * (1 << 8) + c2.b) * (m_fMaxHeight - m_fMinHeight) / (1 << 24) + m_fMinHeight,
        //            ((iY + 0) / (m_iVertexCount - 1.0f) - 0.5f) * m_fGroundSize);

        //        Vector3 p3 = new Vector3(
        //            ((iX + 0) / (m_iVertexCount - 1.0f) - 0.5f) * m_fGroundSize,
        //            (c3.r * (1 << 16) + c3.g * (1 << 8) + c3.b) * (m_fMaxHeight - m_fMinHeight) / (1 << 24) + m_fMinHeight,
        //            ((iY + 1) / (m_iVertexCount - 1.0f) - 0.5f) * m_fGroundSize);

        //        vPos = p1 + (p2 - p1) * fracX + (p3 - p1) * fracY;
        //        vNormal = Vector3.Cross(p3 - p1, p2 - p1).normalized;
        //    }
        //    else
        //    {
        //        Color32 c1 = m_pHeightPixes[(iX + 1) * m_iVertexCount + (iY + 1)];
        //        Color32 c2 = m_pHeightPixes[iX * m_iVertexCount + (iY + 1)];
        //        Color32 c3 = m_pHeightPixes[(iX + 1) * m_iVertexCount + iY];
        //        Vector3 p1 = new Vector3(
        //            ((iX + 1) / (m_iVertexCount - 1.0f) - 0.5f) * m_fGroundSize,
        //            (c1.r * (1 << 16) + c1.g * (1 << 8) + c1.b) * (m_fMaxHeight - m_fMinHeight) / (1 << 24) + m_fMinHeight,
        //            ((iY + 1) / (m_iVertexCount - 1.0f) - 0.5f) * m_fGroundSize);

        //        Vector3 p2 = new Vector3(
        //            ((iX + 0) / (m_iVertexCount - 1.0f) - 0.5f) * m_fGroundSize,
        //            (c2.r * (1 << 16) + c2.g * (1 << 8) + c2.b) * (m_fMaxHeight - m_fMinHeight) / (1 << 24) + m_fMinHeight,
        //            ((iY + 1) / (m_iVertexCount - 1.0f) - 0.5f) * m_fGroundSize);

        //        Vector3 p3 = new Vector3(
        //            ((iX + 1) / (m_iVertexCount - 1.0f) - 0.5f) * m_fGroundSize,
        //            (c3.r * (1 << 16) + c3.g * (1 << 8) + c3.b) * (m_fMaxHeight - m_fMinHeight) / (1 << 24) + m_fMinHeight,
        //            ((iY + 0) / (m_iVertexCount - 1.0f) - 0.5f) * m_fGroundSize);

        //        vPos = p1 + (p2 - p1) * (1.0f - fracX) + (p3 - p1) * (1.0f - fracY);
        //        vNormal = Vector3.Cross(p3 - p1, p2 - p1).normalized;                
        //    }
        //}

        /// <summary>
        /// 传入UV（0-1,0-1），返回地表的位置和法线。
        /// 用于曲面的地表
        /// </summary>
        /// <param name="vUv"></param>
        /// <param name="fOffset">地表往上太高offset</param>
        /// <param name="vPos"></param>
        /// <param name="vNormal"></param>
        public void GetPosNormal(Vector2 vUv, float fOffset, out Vector3 vPos, out Vector3 vNormal)
        {
            //使用Heightmap计算，是取出最近的三角形，然后计算位置，发现。
            //使用MeshCollider不需要这些(但是会更耗)
            //我把这段代码留着，也有可能做一个工具预先从美术3DMAX的模型里计算出Heightmap
            //float fX = vUv.x * (m_iVertexCount - 1);
            //float fY = vUv.y * (m_iVertexCount - 1);
            //int iX = Mathf.FloorToInt(fX);
            //int iY = Mathf.FloorToInt(fY);
            //float fracX = fX - iX;
            //float fracY = fY - iY;
            //if (iX < 0) { iX = 0; fracX = 0.0f; }
            //if (iX >= m_iVertexCount - 1) { iX = m_iVertexCount - 2; fracX = 1.0f; }
            //if (iY < 0) { iY = 0; fracY = 0.0f; }
            //if (iY >= m_iVertexCount - 1) { iY = m_iVertexCount - 2; fracY = 1.0f; }
            //int iHalfCount = (m_iVertexCount - 1)/2;

            //if (null == m_pHeightPixes || m_pHeightPixes.Length != m_pHeightTexture.width * m_pHeightTexture.height)
            //{
            //    m_pHeightPixes = m_pHeightTexture.GetPixels32();
            //}

            //if (fracX + fracY < 1.0f)
            //{
            //    Color32 c1 = m_pHeightPixes[iX * m_iVertexCount + iY];
            //    Color32 c2 = m_pHeightPixes[(iX + 1) * m_iVertexCount + iY];
            //    Color32 c3 = m_pHeightPixes[iX * m_iVertexCount + (iY + 1)];
            //    float fdx1 = m_fCurveDegree * 0.5f * (iX - iHalfCount) / iHalfCount;
            //    float fdy1 = m_fCurveDegree * 0.5f * (iY - iHalfCount) / iHalfCount;
            //    Vector3 n1 = (Quaternion.AngleAxis(fdx1, new Vector3(0.0f, 0.0f, -1.0f)) * Quaternion.AngleAxis(fdy1, new Vector3(1.0f, 0.0f, 0.0f))) * Vector3.up;

            //    float fdx2 = m_fCurveDegree * 0.5f * (iX + 1 - iHalfCount) / iHalfCount;
            //    float fdy2 = m_fCurveDegree * 0.5f * (iY - iHalfCount) / iHalfCount;
            //    Vector3 n2 = (Quaternion.AngleAxis(fdx2, new Vector3(0.0f, 0.0f, -1.0f)) * Quaternion.AngleAxis(fdy2, new Vector3(1.0f, 0.0f, 0.0f))) * Vector3.up;

            //    float fdx3 = m_fCurveDegree * 0.5f * (iX - iHalfCount) / iHalfCount;
            //    float fdy3 = m_fCurveDegree * 0.5f * (iY + 1 - iHalfCount) / iHalfCount;
            //    Vector3 n3 = (Quaternion.AngleAxis(fdx3, new Vector3(0.0f, 0.0f, -1.0f)) * Quaternion.AngleAxis(fdy3, new Vector3(1.0f, 0.0f, 0.0f))) * Vector3.up;

            //    Vector3 p1 = (m_fCurveRadius + (c1.r * (1 << 16) + c1.g * (1 << 8) + c1.b) * (m_fMaxHeight - m_fMinHeight) / (1 << 24) + m_fMinHeight + fOffset) * n1 - Vector3.up * m_fCurveRadius;
            //    Vector3 p2 = (m_fCurveRadius + (c2.r * (1 << 16) + c2.g * (1 << 8) + c2.b) * (m_fMaxHeight - m_fMinHeight) / (1 << 24) + m_fMinHeight + fOffset) * n2 - Vector3.up * m_fCurveRadius;
            //    Vector3 p3 = (m_fCurveRadius + (c3.r * (1 << 16) + c3.g * (1 << 8) + c3.b) * (m_fMaxHeight - m_fMinHeight) / (1 << 24) + m_fMinHeight + fOffset) * n3 - Vector3.up * m_fCurveRadius;

            //    vPos = p1 + (p2 - p1) * fracX + (p3 - p1) * fracY;
            //    vNormal = Vector3.Cross(p3 - p1, p2 - p1).normalized;
            //}
            //else
            //{
            //    Color32 c1 = m_pHeightPixes[(iX + 1) * m_iVertexCount + (iY + 1)];
            //    Color32 c2 = m_pHeightPixes[iX * m_iVertexCount + (iY + 1)];
            //    Color32 c3 = m_pHeightPixes[(iX + 1) * m_iVertexCount + iY];

            //    float fdx1 = m_fCurveDegree * 0.5f * (iX + 1 - iHalfCount) / iHalfCount;
            //    float fdy1 = m_fCurveDegree * 0.5f * (iY + 1- iHalfCount) / iHalfCount;
            //    Vector3 n1 = (Quaternion.AngleAxis(fdx1, new Vector3(0.0f, 0.0f, -1.0f)) * Quaternion.AngleAxis(fdy1, new Vector3(1.0f, 0.0f, 0.0f))) * Vector3.up;

            //    float fdx2 = m_fCurveDegree * 0.5f * (iX - iHalfCount) / iHalfCount;
            //    float fdy2 = m_fCurveDegree * 0.5f * (iY + 1 - iHalfCount) / iHalfCount;
            //    Vector3 n2 = (Quaternion.AngleAxis(fdx2, new Vector3(0.0f, 0.0f, -1.0f)) * Quaternion.AngleAxis(fdy2, new Vector3(1.0f, 0.0f, 0.0f))) * Vector3.up;

            //    float fdx3 = m_fCurveDegree * 0.5f * (iX + 1 - iHalfCount) / iHalfCount;
            //    float fdy3 = m_fCurveDegree * 0.5f * (iY - iHalfCount) / iHalfCount;
            //    Vector3 n3 = (Quaternion.AngleAxis(fdx3, new Vector3(0.0f, 0.0f, -1.0f)) * Quaternion.AngleAxis(fdy3, new Vector3(1.0f, 0.0f, 0.0f))) * Vector3.up;

            //    Vector3 p1 = (m_fCurveRadius + (c1.r * (1 << 16) + c1.g * (1 << 8) + c1.b) * (m_fMaxHeight - m_fMinHeight) / (1 << 24) + m_fMinHeight + fOffset) * n1 - Vector3.up * m_fCurveRadius;
            //    Vector3 p2 = (m_fCurveRadius + (c2.r * (1 << 16) + c2.g * (1 << 8) + c2.b) * (m_fMaxHeight - m_fMinHeight) / (1 << 24) + m_fMinHeight + fOffset) * n2 - Vector3.up * m_fCurveRadius;
            //    Vector3 p3 = (m_fCurveRadius + (c3.r * (1 << 16) + c3.g * (1 << 8) + c3.b) * (m_fMaxHeight - m_fMinHeight) / (1 << 24) + m_fMinHeight + fOffset) * n3 - Vector3.up * m_fCurveRadius;

            //    vPos = p1 + (p2 - p1) * (1.0f - fracX) + (p3 - p1) * (1.0f - fracY);
            //    vNormal = Vector3.Cross(p3 - p1, p2 - p1).normalized;
            //}

            if (!m_bCurve)
            {
                //平面的，从上往下raycast
                float fRayLength = 2.0f * (m_fMaxHeight - m_fMinHeight);
                float fStartY = m_fMaxHeight + 0.25f * fRayLength;
                Vector3 vRayStart = new Vector3(m_fGroundSize * (vUv.x - 0.5f), fStartY, m_fGroundSize * (vUv.y - 0.5f));
                RaycastHit hitp;
                if (Physics.Raycast(new Ray(vRayStart, Vector3.down), out hitp, fRayLength,
                    LayerMask.GetMask("WorldmapGround")))
                {
                    vPos = hitp.point + hitp.normal * fOffset;
                    vNormal = hitp.normal;
                }
                else
                {
                    vNormal = Vector3.up;
                    vPos = vRayStart + Vector3.down * 0.5f * fRayLength + vNormal * fOffset;
                }
                return;
            }

            //先计算角度
            Vector3 vCenter = new Vector3(0.0f, -m_fCurveRadius, 0.0f);
            float fDegreeX = (vUv.x - 0.5f) * m_fCurveDegree;
            float fDegreeY = (vUv.y - 0.5f) * m_fCurveDegree;
            Vector3 vNormal0 = (Quaternion.AngleAxis(fDegreeX, new Vector3(0.0f, 0.0f, -1.0f)) * Quaternion.AngleAxis(fDegreeY, new Vector3(1.0f, 0.0f, 0.0f))) * Vector3.up;
            Vector3 vStart = vNormal0 * m_fCurveRadius * 1.5f + vCenter;
            Vector3 vDir = -vNormal0.normalized;
            RaycastHit hit;
            if (Physics.Raycast(new Ray(vStart, vDir), out hit, m_fCurveRadius,
                LayerMask.GetMask("WorldmapGround")))
            {
                vPos = hit.point + hit.normal * fOffset;
                vNormal = hit.normal;
            }
            else
            {
                vNormal = vNormal0.normalized;
                vPos = vStart + vDir * 0.5f * m_fCurveRadius + vNormal * fOffset;
            }
        }

        #endregion

        #region Click Check

        //private const int m_iRecursive = 2; 用于GetGroundUVUsingRay
        public bool TerrainRaycast(Vector2 vScreenPos, out Vector2 vUV)
        {
            Ray ray = Camera.main.ScreenPointToRay(vScreenPos);
            return TerrainRaycast(ray, out vUV);
        }

        public bool TerrainRaycast(Ray ray, out Vector2 vUV)
        {
            //这是利用简单的球面与向量计算。我们有Collider了可以有更精确的做法
            //vUV = Vector2.zero;
            //float fHeight = (m_fMaxHeight - m_fMinHeight) * 0.5f;
            //bool bHasClick = true;
            //for (int i = 0; i < m_iRecursive; ++i)
            //{
            //    if (bHasClick)
            //    {
            //        bHasClick = GetGroundUVUsingRay(ray, fHeight, out vUV);
            //        if (bHasClick)
            //        {
            //            Vector3 vNor, vNewPos;
            //            GetPosNormal(vUV, 0.0f, out vNewPos, out vNor);
            //            fHeight = vNewPos.y;
            //        }
            //    }
            //}

            //return bHasClick;

            vUV = Vector2.zero;
            RaycastHit hit;
            if (Physics.Raycast(ray, out hit, 100f, LayerMask.GetMask("WorldmapGround")))
            {
                vUV = PosToUV(hit.point);
                return true;
            }
            return false;
        }

        ///// <summary>
        ///// 这是利用简单的球面与向量计算。我们有Collider了可以有更精确的做法，这个函数可能不再需要了
        ///// 代码留着以备需要
        ///// </summary>
        ///// <param name="ray"></param>
        ///// <param name="fHeight"></param>
        ///// <param name="vUV"></param>
        ///// <returns></returns>
        //private bool GetGroundUVUsingRay(Ray ray, float fHeight, out Vector2 vUV)
        //{
        //    vUV = Vector2.zero;
        //    Vector3 vPos;
        //    if (!FindGroundPosUsingAnverageRadius(ray, fHeight, out vPos))
        //    {
        //        return false;
        //    }
        //    //Debug.Log("has click pos:" + vPos);
        //    vUV = PosToUV(vPos);

        //    return true;
        //}

        ///// <summary>
        ///// 这是利用简单的球面与向量计算。我们有Collider了可以有更精确的做法
        ///// 代码留着以备需要
        ///// </summary>
        ///// <param name="ray"></param>
        ///// <param name="fHeight"></param>
        ///// <param name="vPos"></param>
        ///// <returns></returns>
        //private bool FindGroundPosUsingAnverageRadius(Ray ray, float fHeight, out Vector3 vPos)
        //{
        //    vPos = Vector3.zero;
        //    Vector3 vStart = ray.GetPoint(0.0F);
        //    Vector3 vCenter = Vector3.down*m_fCurveRadius;
        //    float fRadius = m_fCurveRadius + fHeight;
        //    Vector3 vDown = (vCenter - vStart).normalized;
        //    float fCos = Vector3.Dot(vDown, ray.direction);
        //    if (fCos < 0.0f)
        //    {
        //        return false;
        //    }

        //    float fDist = (vCenter - vStart).magnitude * fCos;
        //    Vector3 midPos = ray.GetPoint(fDist);
        //    float fMidPosDist = (midPos - vCenter).magnitude;
        //    if (fMidPosDist > fRadius)
        //    {
        //        return false;
        //    }
        //    float fRealDist = fDist - Mathf.Sqrt(fRadius*fRadius - fMidPosDist*fMidPosDist);
        //    vPos = ray.GetPoint(fRealDist);
        //    return true;
        //}

        #endregion

        #region Draw Grid 相当于给格子着色, 画冲突，画迁城模式下的面片，都用到它

        private Mesh m_pDrawingMesh = null;
        private readonly List<Vector3> m_v3PenetratePoses = new List<Vector3>();
        private readonly List<Vector3> m_v3PenetrateNors = new List<Vector3>();
        private readonly List<Vector2> m_v3PenetrateUVs = new List<Vector2>();
        private readonly List<Color> m_v3PenetrateColors = new List<Color>();
        private readonly List<int> m_iPenetrateIndexes = new List<int>();

        private void CreateGroundTexture()
        {
            m_v3PenetratePoses.Clear();
            m_v3PenetrateNors.Clear();
            m_v3PenetrateUVs.Clear();
            m_iPenetrateIndexes.Clear();
            m_v3PenetrateColors.Clear();
            if (null == m_pDrawingMesh)
            {
                GameObject go = new GameObject("Ground");//Instantiate(m_pCubePrefab, Vector3.zero, Quaternion.identity);
                go.AddComponent<MeshFilter>();
                go.AddComponent<MeshRenderer>();
                go.transform.localScale = Vector3.one;
                Material mat = new Material(Shader.Find("LPCFramework/TerrainToMeshInteract"));
                mat.SetTexture("_MainTex", gameObject.GetComponent<MeshRenderer>().sharedMaterial.mainTexture);
                m_pDrawingMesh = new Mesh
                {
                    vertices = m_v3PenetratePoses.ToArray(),
                    normals = m_v3PenetrateNors.ToArray(),
                    uv = m_v3PenetrateUVs.ToArray(),
                    colors = m_v3PenetrateColors.ToArray()
                };
                m_pDrawingMesh.SetIndices(m_iPenetrateIndexes.ToArray(), MeshTopology.Triangles, 0, false);
                m_pDrawingMesh.UploadMeshData(false);

                go.GetComponent<MeshFilter>().sharedMesh = m_pDrawingMesh;
                go.GetComponent<MeshRenderer>().sharedMaterial = mat;
            }
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="vUV"></param>
        /// <param name="c"></param>
        private void DrawGridAtUV(Vector2 vUV, Color c)
        {
            int iVertexBufferStart = m_v3PenetratePoses.Count;
            for (int k = 0; k < 6; ++k)
            {
                Vector3 pos1, nor1;
                Vector2 vNewUV = vUV + m_vUVOffset[k];
                GetPosNormal(vNewUV, 0.1f, out pos1, out nor1);
                m_v3PenetratePoses.Add(pos1);
                m_v3PenetrateNors.Add(nor1);
                m_v3PenetrateUVs.Add(vNewUV);
                m_v3PenetrateColors.Add(c);
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

        private void ApplyChanged()
        {
            //如果不清0，设置vertex时会报错
            m_pDrawingMesh.SetIndices(new int[0], MeshTopology.Triangles, 0, false);
            m_pDrawingMesh.vertices = m_v3PenetratePoses.ToArray();
            m_pDrawingMesh.normals = m_v3PenetrateNors.ToArray();
            m_pDrawingMesh.uv = m_v3PenetrateUVs.ToArray();
            m_pDrawingMesh.colors = m_v3PenetrateColors.ToArray();
            m_pDrawingMesh.SetIndices(m_iPenetrateIndexes.ToArray(), MeshTopology.Triangles, 0, false);
            m_pDrawingMesh.RecalculateBounds();
            m_pDrawingMesh.UploadMeshData(false);
        }
        #endregion

        #region 画冲突

        private class Penetration
        {
            public int m_iKey = 0;
            public int m_iX = 0;
            public int m_iY = 0;
            public int m_iFrame = 0;
            //public bool m_bNew = false; not using any more
            public GroundItemInfo m_Item = null;
        }

        private int m_iPenentrationCheckFrame = 0;
        private readonly Dictionary<int, Penetration> m_PenetrationDataIndex = new Dictionary<int, Penetration>(new IntEqualityComparer());
        private readonly List<Penetration> m_PenetrationData = new List<Penetration>();

        /// <summary>
        /// 供CSharp测试的代码，点击到城市的事件
        /// </summary>
        /// <param name="item"></param>
        private void OnSelectCity(GroundItemInfo item)
        {
            SelectCitiesAtOddQWithDefaultRadius(item.m_iOddQX, item.m_iOddQY);
        }

        private void RefreshGroundPenentration()
        {
            if (m_bMoveCityMode)
            {
                return;
            }

            #region 检测冲突

            ++m_iPenentrationCheckFrame;
            for (int i = 0; i < m_pSelectedItems.Count; ++i)
            {
                byte[,] occupy = TerrainGroundItem.m_byOccupyGrids[m_pSelectedItems[i].m_Item.m_iItemGrade];
                int iWidth = occupy.GetLength(0);
                int iHalfWidth = (iWidth + 1) / 2;
                int iHeight = occupy.GetLength(1);
                bool bOffset = (0 != (m_pSelectedItems[i].m_Item.m_iOddQX & 1));
                if (0 == (iHalfWidth & 1))
                {
                    bOffset = !bOffset;
                }

                for (int x = 0; x < iWidth; ++x)
                {
                    for (int y = 0; y < iHeight; ++y)
                    {
                        int iX = m_pSelectedItems[i].m_Item.m_iOddQX - (iWidth - 1) / 2 + x;
                        int iOffset = (bOffset && (0 == (iX & 1)) ? 1 : 0);
                        int iY = m_pSelectedItems[i].m_Item.m_iOddQY - (iHeight - 1) / 2 + y + iOffset;
                        if (0 == (iHalfWidth & 1) && bOffset)
                        {
                            --iY;
                        }
                        int iGrid = iX * m_iGridHeight + iY;
                        if (iX >= 0 && iX < m_iGridWidth
                         && iY >= 0 && iY < m_iGridHeight
                         && 1 == occupy[x, y]
                         && null != m_iCityIndexTable[iGrid]
                         && m_iCityIndexTable[iGrid].Count > 1
                         && IsConfict(m_iCityIndexTable[iGrid]))
                        {
                            //这里就是冲突了
                            if (m_PenetrationDataIndex.ContainsKey(iGrid))
                            {
                                m_PenetrationDataIndex[iGrid].m_iFrame = m_iPenentrationCheckFrame;
                            }
                            else
                            {
                                GroundItemInfo item;
                                m_pUnselectableTable.TryGetValue(iGrid, out item);
                                Penetration data = new Penetration
                                {
                                    m_iKey = iGrid,
                                    m_iX = iX,
                                    m_iY = iY,
                                    m_iFrame = m_iPenentrationCheckFrame,
                                    m_Item = item,
                                };
                                m_PenetrationData.Add(data);
                                m_PenetrationDataIndex.Add(iGrid, data);
                            }
                        }
                    }
                }
            }

            #endregion

            #region 画冲突

            CreateGroundTexture();
            for (int i = 0; i < m_PenetrationData.Count; ++i)
            {
                Penetration p = m_PenetrationData[i];
                if (p.m_iFrame == m_iPenentrationCheckFrame)
                {
                    DrawGridAtUV(OddQToUV(p.m_iX, p.m_iY), m_cPenetration);
                    if (null != p.m_Item)
                    {
                        p.m_Item.m_bPenetrate = true;
                        if (null != p.m_Item.m_Script)
                        {
                            p.m_Item.m_Script.OnPenentrate(true, false);
                        }
                    }
                }
                else
                {
                    if (null != p.m_Item)
                    {
                        p.m_Item.m_bPenetrate = false;
                        if (null != p.m_Item.m_Script)
                        {
                            p.m_Item.m_Script.OnPenentrate(false, false);
                        }
                    }
                    m_PenetrationDataIndex.Remove(p.m_iKey);
                }
            }
            m_PenetrationData.RemoveAll(data => data.m_iFrame != m_iPenentrationCheckFrame);
            ApplyChanged();

            #endregion
        }

        private readonly HashSet<int> m_ConflictHash = new HashSet<int>();

        private bool IsConfict(List<int> cityIds)
        {
            if (null == cityIds)
            {
                return false;
            }
            m_ConflictHash.Clear();
            int iEmptyUnionId = 0;
            for (int i = 0; i < cityIds.Count; ++i)
            {
                GroundItemInfo gi;
                if (m_pSelectableTableById.TryGetValue(cityIds[i], out gi))
                {
                    if (gi.m_iGroundItemUnionId <= 0)
                    {
                        ++iEmptyUnionId; //空的union id是没有加入任何联盟的。互相之间是冲突的.
                    }
                    else if (!m_ConflictHash.Contains(gi.m_iGroundItemUnionId))
                    {
                        m_ConflictHash.Add(gi.m_iGroundItemUnionId);
                    }
                }

                if (m_ConflictHash.Count + iEmptyUnionId > 1)
                {
                    return true;
                }
            }
            return false;
        }

        #endregion

        #region 显示城市区域

        private class SelectCityData
        {
            public GroundItemInfo m_Item;
            public int m_iFrame;
        }
        private int m_iSelectCheckFrame = 0;

        private readonly List<SelectCityData> m_pSelectedItems = new List<SelectCityData>();
        private readonly Dictionary<int, SelectCityData> m_pSelectedItemTable = new Dictionary<int, SelectCityData>(new IntEqualityComparer());

        private float m_fSelectCitiesRadius = 25.0f;

        public void UnSelectAll(bool bAlsoUnselectPlayerCity = false)
        {
            ++m_iSelectCheckFrame;
            for (int i = 0; i < m_pSelectedItems.Count; ++i)
            {
                m_pSelectedItems[i].m_Item.m_bSelected = false;
                if (null != m_pSelectedItems[i].m_Item.m_Script)
                {
                    m_pSelectedItems[i].m_Item.m_Script.OnSelected(false);
                }
            }
            m_pSelectedItems.Clear();

            if (!bAlsoUnselectPlayerCity)
            {
                AddSeleteMyCity();
                RefreshGroundPenentration();
            }
        }

        ///// <summary>
        ///// 新的显示冲突区域的做法，这个函数其实已经不需要了
        ///// 直接用UnSelectAll
        ///// </summary>
        ///// <param name="bClearPenentration"></param>
        //public void UnSelectAllAndClearPenentration(bool bClearPenentration = true)
        //{
        //    //如果不需要ClearPenentration说明是从别的选择进来的
        //    //此时可以放心的反选自己城市,因为之后还会重选一遍
        //    //如果是true，那么是从接口过来的，此时冲突区域因为在UnSelectAll中有AddSeleteMyCity
        //    //也会重新计算一遍
        //    UnSelectAll(!bClearPenentration);
        //}

        public void SetSelectCitiesDefaultRadius(float fRadius)
        {
            m_fSelectCitiesRadius = fRadius;
        }

        public int SelectCitiesAtOddQWithDefaultRadius(int iOddQX, int iOddQY)
        {
            return SelectCitiesAtOddQWithRadius(iOddQX, iOddQY, m_fSelectCitiesRadius);
        }

        public int SelectCitiesAtOddQWithRadius(int iOddQX, int iOddQY, float fRadius)
        {
            ++m_iSelectCheckFrame;

            #region 反选所有,清除冲突区域
            //UnSelectAllAndClearPenentration(false);
            UnSelectAll(true);
            #endregion

            #region 根据距离计算需要选中的城市

            float fSphereDistance = fRadius / m_fGroundSize;
            fSphereDistance *= fSphereDistance;
            Vector2 vUV = OddQToUV(iOddQX, iOddQY);

            for (int i = 0; i < m_CityGroundItemInfos.Count; ++i)
            {
                GroundItemInfo gi = m_CityGroundItemInfos[i];
                if (EBuildingType.MainCity == (EBuildingType)gi.m_byGroundItemType ||
                    EBuildingType.Campsite == (EBuildingType)gi.m_byGroundItemType)
                {
                    Vector2 vUV2 = OddQToUV(gi.m_iOddQX, gi.m_iOddQY);
                    if ((vUV - vUV2).sqrMagnitude < fSphereDistance || gi.m_bIsPlayerMainCity)
                    {
                        gi.m_bSelected = true;
                        if (null != gi.m_Script)
                        {
                            gi.m_Script.OnSelected(true);
                        }

                        if (m_pSelectedItemTable.ContainsKey(gi.m_iGroundItemId))
                        {
                            m_pSelectedItemTable[gi.m_iGroundItemId].m_iFrame = m_iSelectCheckFrame;
                        }
                        else
                        {
                            m_pSelectedItemTable.Add(gi.m_iGroundItemId, new SelectCityData
                            {
                                m_Item = gi,
                                m_iFrame = m_iSelectCheckFrame,
                            });
                        }
                        m_pSelectedItems.Add(m_pSelectedItemTable[gi.m_iGroundItemId]);
                    }
                }
            }
            AddSeleteMyCity();

            #endregion

            #region 计算冲突

            RefreshGroundPenentration();

            #endregion

            return m_pSelectedItems.Count;
        }

        //最后选中自己是一个很难处理的需求
        private readonly List<GroundItemInfo> m_pShouldSelectWithMe = new List<GroundItemInfo>();
        private bool AddSeleteMyCity()
        {
            GroundItemInfo myCity;
            bool bChanged = false;
            if (m_pSelectableTableById.TryGetValue(m_iMyCity, out myCity))
            {
                m_pShouldSelectWithMe.Clear();
                m_pShouldSelectWithMe.Add(myCity);

                byte[,] occupy = TerrainGroundItem.m_byOccupyGrids[myCity.m_iItemGrade];
                int iWidth = occupy.GetLength(0);
                int iHalfWidth = (iWidth + 1) / 2;
                int iHeight = occupy.GetLength(1);
                bool bOffset = (0 != (myCity.m_iOddQX & 1));
                if (0 == (iHalfWidth & 1))
                {
                    bOffset = !bOffset;
                }

                for (int x = 0; x < iWidth; ++x)
                {
                    for (int y = 0; y < iHeight; ++y)
                    {
                        int iX = myCity.m_iOddQX - (iWidth - 1) / 2 + x;
                        int iOffset = (bOffset && (0 == (iX & 1)) ? 1 : 0);
                        int iY = myCity.m_iOddQY - (iHeight - 1) / 2 + y + iOffset;
                        if (0 == (iHalfWidth & 1) && bOffset)
                        {
                            --iY;
                        }
                        int iGrid = iX * m_iGridHeight + iY;
                        if (iX >= 0 && iX < m_iGridWidth
                         && iY >= 0 && iY < m_iGridHeight
                         && 1 == occupy[x, y]
                         && null != m_iCityIndexTable[iGrid]
                         && m_iCityIndexTable[iGrid].Count > 1
                         && IsConfict(m_iCityIndexTable[iGrid]))
                        {
                            for (int i = 0; i < m_iCityIndexTable[iGrid].Count; ++i)
                            {
                                int iConflictId = m_iCityIndexTable[iGrid][i];
                                GroundItemInfo selectWithMe;
                                if (iConflictId != m_iMyCity
                                 && m_pSelectableTableById.TryGetValue(iConflictId, out selectWithMe))
                                {
                                    m_pShouldSelectWithMe.Add(selectWithMe);
                                }
                            }
                        }
                    }
                }

                //m_pShouldSelectWithMe就是包括自己以及所有和自己冲突的城市了
                for (int i = 0; i < m_pShouldSelectWithMe.Count; ++i)
                {
                    GroundItemInfo gi = m_pShouldSelectWithMe[i];
                    gi.m_bSelected = true; //标记为选中
                    if (null != gi.m_Script)
                    {
                        gi.m_Script.OnSelected(true); //显示边界
                    }

                    if (m_pSelectedItemTable.ContainsKey(gi.m_iGroundItemId))
                    {
                        //如果是true，那么说明本来就处于显示状态（比如，因为半径显示的缘故）
                        if (m_pSelectedItemTable[gi.m_iGroundItemId].m_iFrame != m_iSelectCheckFrame)
                        {
                            m_pSelectedItemTable[gi.m_iGroundItemId].m_iFrame = m_iSelectCheckFrame;
                            m_pSelectedItems.Add(m_pSelectedItemTable[gi.m_iGroundItemId]);
                            bChanged = true;
                        }
                    }
                    else
                    {
                        m_pSelectedItemTable.Add(gi.m_iGroundItemId, new SelectCityData
                        {
                            m_Item = gi,
                            m_iFrame = m_iSelectCheckFrame,
                        });
                        m_pSelectedItems.Add(m_pSelectedItemTable[gi.m_iGroundItemId]);
                        bChanged = true;
                    }
                }
            }
            return bChanged;
        }

        #region 摄像机中心显示模式

        private bool m_bSelectCitiesArroundCamera = false;

        public void TurnSelectCitiesArroundCamera(bool bOn)
        {
            m_bSelectCitiesArroundCamera = bOn;
            if (!m_bSelectCitiesArroundCamera)
            {
                //UnSelectAllAndClearPenentration();
                UnSelectAll();
            }
        }

        public bool IsSelectCitiesArroundCameraOn()
        {
            return m_bSelectCitiesArroundCamera;
        }

        private void UpdateCameraSelection()
        {
            ++m_iSelectCheckFrame;
            float fSphereDistance = m_fSelectCitiesRadius / m_fGroundSize;
            fSphereDistance *= fSphereDistance;
            Vector2 vUV = CameraPointTo();
            bool bChanged = false;

            m_pShouldSelectWithMe.Clear();
            GroundItemInfo myCity;
            if (m_pSelectableTableById.TryGetValue(m_iMyCity, out myCity))
            {
                m_pShouldSelectWithMe.Add(myCity);

                byte[,] occupy = TerrainGroundItem.m_byOccupyGrids[myCity.m_iItemGrade];
                int iWidth = occupy.GetLength(0);
                int iHalfWidth = (iWidth + 1) / 2;
                int iHeight = occupy.GetLength(1);
                bool bOffset = (0 != (myCity.m_iOddQX & 1));
                if (0 == (iHalfWidth & 1))
                {
                    bOffset = !bOffset;
                }

                for (int x = 0; x < iWidth; ++x)
                {
                    for (int y = 0; y < iHeight; ++y)
                    {
                        int iX = myCity.m_iOddQX - (iWidth - 1) / 2 + x;
                        int iOffset = (bOffset && (0 == (iX & 1)) ? 1 : 0);
                        int iY = myCity.m_iOddQY - (iHeight - 1) / 2 + y + iOffset;
                        if (0 == (iHalfWidth & 1) && bOffset)
                        {
                            --iY;
                        }
                        int iGrid = iX * m_iGridHeight + iY;
                        if (iX >= 0 && iX < m_iGridWidth
                         && iY >= 0 && iY < m_iGridHeight
                         && 1 == occupy[x, y]
                         && null != m_iCityIndexTable[iGrid]
                         && m_iCityIndexTable[iGrid].Count > 1
                         && IsConfict(m_iCityIndexTable[iGrid]))
                        {
                            for (int i = 0; i < m_iCityIndexTable[iGrid].Count; ++i)
                            {
                                int iConflictId = m_iCityIndexTable[iGrid][i];
                                GroundItemInfo selectWithMe;
                                if (iConflictId != m_iMyCity
                                 && m_pSelectableTableById.TryGetValue(iConflictId, out selectWithMe))
                                {
                                    m_pShouldSelectWithMe.Add(selectWithMe);
                                }
                            }
                        }
                    }
                }
            }

            //蛋疼的m_pShouldSelectWithMe就是需要一直显示的

            for (int i = 0; i < m_CityGroundItemInfos.Count; ++i)
            {
                GroundItemInfo gi = m_CityGroundItemInfos[i];
                if (EBuildingType.MainCity == (EBuildingType)gi.m_byGroundItemType ||
                    EBuildingType.Campsite == (EBuildingType)gi.m_byGroundItemType)
                {
                    Vector2 vUV2 = OddQToUV(gi.m_iOddQX, gi.m_iOddQY);
                    if ((vUV - vUV2).sqrMagnitude < fSphereDistance || m_pShouldSelectWithMe.Contains(gi))
                    {
                        gi.m_bSelected = true;
                        if (null != gi.m_Script)
                        {
                            gi.m_Script.OnSelected(true);
                        }

                        if (m_pSelectedItemTable.ContainsKey(gi.m_iGroundItemId))
                        {
                            //iframe == m_iSelectCheckFrame - 1的是当前显示区域的城市们
                            //iframe < m_iSelectCheckFrame - 1的是当前没显示区域的城市们
                            if (m_pSelectedItemTable[gi.m_iGroundItemId].m_iFrame < m_iSelectCheckFrame - 1)
                            {
                                //last time not selected
                                bChanged = true;
                                m_pSelectedItems.Add(m_pSelectedItemTable[gi.m_iGroundItemId]);
                            }
                            m_pSelectedItemTable[gi.m_iGroundItemId].m_iFrame = m_iSelectCheckFrame;
                        }
                        else
                        {
                            bChanged = true;
                            m_pSelectedItemTable.Add(gi.m_iGroundItemId, new SelectCityData
                            {
                                m_Item = gi,
                                m_iFrame = m_iSelectCheckFrame,
                            });
                            m_pSelectedItems.Add(m_pSelectedItemTable[gi.m_iGroundItemId]);
                        }
                    }
                }
            }

            //之前选中的这次没被选中的，去掉Projector
            for (int i = 0; i < m_pSelectedItems.Count; ++i)
            {
                if (m_pSelectedItems[i].m_iFrame < m_iSelectCheckFrame)
                {
                    m_pSelectedItems[i].m_Item.m_bSelected = false;
                    if (null != m_pSelectedItems[i].m_Item.m_Script)
                    {
                        m_pSelectedItems[i].m_Item.m_Script.OnSelected(false);
                    }
                }
                else
                {
                    m_pSelectedItems[i].m_Item.m_bSelected = true;
                    if (null != m_pSelectedItems[i].m_Item.m_Script)
                    {
                        m_pSelectedItems[i].m_Item.m_Script.OnSelected(true);
                    }
                }
            }
            int iRemove = m_pSelectedItems.RemoveAll(data => data.m_iFrame < m_iSelectCheckFrame);
            bChanged = bChanged || (iRemove > 0);

            if (bChanged)
            {
                RefreshGroundPenentration();
            }
        }

        #endregion

        #endregion

        #region Draw Line

        private bool m_bSetStart = true;
        private int m_iLastClickEmptyX = -1;
        private int m_iLastClickEmptyY = -1;
        private readonly Dictionary<int, GameObject> m_pShowingLines = new Dictionary<int, GameObject>(new IntEqualityComparer());
        private int m_iNextLineId = 0;

        /// <summary>
        /// 直线过去的，就不对其格子，直接用UV
        /// </summary>
        /// <param name="vUV"></param>
        private void OnClickEmptyGrid(Vector2 vUV)
        {
            int iX, iY;
            UVToNearestOddQ(vUV, out iX, out iY);
            if (iX == m_iLastClickEmptyX && iY == m_iLastClickEmptyY)
            {
                //点在同一个格子里，无视了
                return;
            }
            m_iLastClickEmptyX = iX;
            m_iLastClickEmptyY = iY;
        }

        /// <summary>
        /// line.material.mainTextureScale 可以改变箭头密集程度
        /// </summary>
        /// <param name="vFrom"></param>
        /// <param name="vTo"></param>
        /// <param name="fOffset"></param>
        /// <param name="c"></param>
        /// <returns></returns>
        public int ShowLine(Vector2 vFrom, Vector2 vTo, float fOffset, Color c)
        {
            GameObject lineObj = m_pLinePool.NextAvailableObject();
            LineRenderer line = lineObj.GetComponent<LineRenderer>();
            line.startWidth = m_fEdgeWidth;
            line.endWidth = m_fEdgeWidth;
            line.material.mainTextureScale = new Vector2(1.0f, 1.0f);
            line.material.SetFloat("_SpeedX", -10.0f * m_fEdgeWidth);
            line.material.SetColor("_TintColor", c);
            line.useWorldSpace = true;
            line.numCornerVertices = 2;

            ++m_iNextLineId;
            m_pShowingLines.Add(m_iNextLineId, lineObj);

            float fLength = (vTo - vFrom).magnitude;
            //float fSep = 1.0f/m_iVertexCount;
            float fSep = 1.0f / m_iGridWidth;
            int iStep = Mathf.CeilToInt(fLength / fSep) + 1;
            //Debug.Log(string.Format("l: {0}, s: {1}, s: {2}", fLength, fSep, iStep));
            Vector2 dir = (vTo - vFrom) / fLength; //normalize, since we already calculate length, just divide it

            line.positionCount = iStep;
            Vector3[] vPoses = new Vector3[iStep];
            for (int i = 0; i < iStep; ++i)
            {
                float fNextPoint = Mathf.Min(fLength, i * fSep);
                Vector2 vUVToDraw = vFrom + dir * fNextPoint;
                Vector3 vPos, vNor;
                GetPosNormal(vUVToDraw, fOffset, out vPos, out vNor);
                vPoses[i] = vPos;
            }
            line.SetPositions(vPoses);
            return m_iNextLineId;
        }

        /// <summary>
        /// 使用ShowLine返回的id来隐藏行军线
        /// </summary>
        /// <param name="iLineId"></param>
        /// <returns></returns>
        public bool HideLine(int iLineId)
        {
            if (!m_pShowingLines.ContainsKey(iLineId))
            {
                return false;
            }
            GameObject line = m_pShowingLines[iLineId];
            m_pLinePool.ReturnObjectToPool("Arraw", line);

            return true;
        }

        /// <summary>
        /// 返回的是位置列表+Normal列表
        /// </summary>
        /// <param name="vFrom"></param>
        /// <param name="vTo"></param>
        /// <param name="fOffset"></param>
        /// <returns></returns>
        public Vector3[] SamplePosition(Vector2 vFrom, Vector2 vTo, float fOffset)
        {
            float fLength = (vTo - vFrom).magnitude;
            //float fSep = 1.0f / m_iVertexCount;
            float fSep = 1.0f / m_iGridWidth;
            int iStep = Mathf.CeilToInt(fLength / fSep) + 1;
            //Debug.Log(string.Format("l: {0}, s: {1}, s: {2}", fLength, fSep, iStep));
            Vector2 dir = (vTo - vFrom) / fLength; //normalize, since we already calculate length, just divide it

            Vector3[] vPoses = new Vector3[iStep * 2];
            for (int i = 0; i < iStep; ++i)
            {
                float fNextPoint = Mathf.Min(fLength, i * fSep);
                Vector2 vUVToDraw = vFrom + dir * fNextPoint;
                Vector3 vPos, vNor;
                GetPosNormal(vUVToDraw, fOffset, out vPos, out vNor);
                vPoses[iStep + i] = vNor;
                vPoses[i] = vPos;
            }
            return vPoses;
        }

        #endregion

        #region 主城,资源点修改

        /// <summary>
        /// 修改主城的势力范围等级
        /// </summary>
        /// <param name="iCityId"></param>
        /// <param name="iGrid"></param>
        /// <returns></returns>
        public bool SetCityGrade(int iCityId, int iGrid)
        {
            GroundItemInfo gi;
            m_pSelectableTableById.TryGetValue(iCityId, out gi);
            iGrid = Mathf.Clamp(iGrid, (int)ECityRange.Grid1, (int)ECityRange.Grid8);
            if (null == gi)
            {
                Debug.LogWarning("SetCityGrade failed!");
                return false;
            }

            if (gi.m_iItemGrade == iGrid)
            {
                return true;
            }

            gi.m_iItemGrade = iGrid;
            if (null != gi.m_Script)
            {
                //更新Projector
                gi.m_Script.m_eRegion = (ECityRange)iGrid;
                //更新UI显示
                gi.m_Script.UpdateUIContent(gi);
            }

            // 升级后需要判断可建造的资源点
            CheckSize(gi.m_iOddQX, gi.m_iOddQY, iGrid, iCityId);

            RefreshGroundPenentration();
            return true;
        }

        /// <summary>
        /// 修改主城的所属联盟
        /// </summary>
        /// <param name="iCityId"></param>
        /// <param name="iNewUnionId"></param>
        /// <param name="sUnionName"></param>
        /// <returns></returns>
        public bool SetCityUnionId(int iCityId, int iNewUnionId, string sUnionName)
        {
            GroundItemInfo gi;
            m_pSelectableTableById.TryGetValue(iCityId, out gi);
            if (null == gi)
            {
                return false;
            }

            if (iNewUnionId > 0)
            {
                m_sUnionNameDic[iNewUnionId] = sUnionName;
            }

            if (gi.m_iGroundItemUnionId == iNewUnionId && gi.m_sUnionFlagName == sUnionName)
            {
                return true;
            }

            gi.m_iGroundItemUnionId = iNewUnionId;
            gi.m_sUnionFlagName = sUnionName;
            if (gi.m_bIsPlayerMainCity)
            {
                m_iMyUnion = iNewUnionId;
            }
            if (null != gi.m_Script)
            {
                gi.m_Script.UpdateUIContent(gi);
            }

            //更新Projector颜色
            for (int i = 0; i < m_pSelectedItems.Count; ++i)
            {
                if (null != m_pSelectedItems[i].m_Item.m_Script)
                {
                    m_pSelectedItems[i].m_Item.m_Script.OnSelected(true);
                }
            }
            //更新冲突
            RefreshGroundPenentration();
            return true;
        }

        /// <summary>
        /// 假定这个Union ID的名字是我们知道的
        /// </summary>
        /// <param name="iCityId"></param>
        /// <param name="iNewUnionId"></param>
        /// <returns></returns>
        public bool SetCityUnionId(int iCityId, int iNewUnionId)
        {
            GroundItemInfo gi;
            m_pSelectableTableById.TryGetValue(iCityId, out gi);
            if (null == gi)
            {
                return false;
            }

            string sUnionName = "";
            if (iNewUnionId > 0)
            {
                if (!m_sUnionNameDic.ContainsKey(iNewUnionId))
                {
                    return false;
                }
                sUnionName = m_sUnionNameDic[iNewUnionId];
            }

            if (gi.m_iGroundItemUnionId == iNewUnionId)
            {
                return true;
            }

            gi.m_iGroundItemUnionId = iNewUnionId;
            gi.m_sUnionFlagName = sUnionName;
            if (gi.m_bIsPlayerMainCity)
            {
                m_iMyUnion = iNewUnionId;
            }
            if (null != gi.m_Script)
            {
                gi.m_Script.UpdateUIContent(gi);
            }

            //更新Projector颜色
            for (int i = 0; i < m_pSelectedItems.Count; ++i)
            {
                if (null != m_pSelectedItems[i].m_Item.m_Script)
                {
                    m_pSelectedItems[i].m_Item.m_Script.OnSelected(true);
                }
            }
            //更新冲突
            RefreshGroundPenentration();
            return true;
        }

        /// <summary>
        /// 注意：这里假定一个玩家只有一个城
        /// </summary>
        /// <param name="iCityId"></param>
        /// <param name="iPlayerLevel"></param>
        /// <returns></returns>
        public bool SetCityPlayerLevel(int iCityId, int iPlayerLevel)
        {
            GroundItemInfo gi;
            m_pSelectableTableById.TryGetValue(iCityId, out gi);
            if (null == gi)
            {
                return false;
            }
            if (gi.m_iPlayerLevel == iPlayerLevel)
            {
                return true;
            }

            gi.m_iPlayerLevel = iPlayerLevel;
            if (null != gi.m_Script)
            {
                gi.m_Script.UpdateUIContent(gi);
            }
            return true;
        }

        /// <summary>
        /// 注意：这里假定一个玩家只有一个城
        /// </summary>
        /// <param name="iCityId"></param>
        /// <param name="sPlayerName"></param>
        /// <returns></returns>
        public bool SetCityPlayerName(int iCityId, string sPlayerName)
        {
            GroundItemInfo gi;
            m_pSelectableTableById.TryGetValue(iCityId, out gi);
            if (null == gi)
            {
                return false;
            }
            if (gi.m_sPlayerName == sPlayerName)
            {
                return true;
            }

            gi.m_sPlayerName = sPlayerName;
            if (null != gi.m_Script)
            {
                gi.m_Script.UpdateUIContent(gi);
            }
            return true;
        }

        /// <summary>
        /// 注意：这里假定一个玩家只有一个城
        /// </summary>
        /// <param name="iCityId"></param>
        /// <param name="sPlayerName"></param>
        /// <returns></returns>
        public bool SetCityWhiteFlag(int iCityId, string sWhiteFlage)
        {
            GroundItemInfo gi;
            m_pSelectableTableById.TryGetValue(iCityId, out gi);
            if (null == gi)
            {
                return false;
            }
            if (gi.m_sWhiteFlag == sWhiteFlage)
            {
                return true;
            }

            gi.m_sWhiteFlag = sWhiteFlage;
            if (null != gi.m_Script)
            {
                gi.m_Script.UpdateUIContent(gi);
            }
            return true;
        }

        /// <summary>
        /// 去掉主城
        /// </summary>
        /// <param name="iCityId"></param>
        /// <returns></returns>
        public bool RemoveCity(int iCityId)
        {
            GroundItemInfo gi;
            m_pSelectableTableById.TryGetValue(iCityId, out gi);
            if (null == gi)
            {
                return false;
            }

            if (null != gi.m_GameObject)
            {
                gi.m_Pool.ReturnObjectToPool(((EBuildingType)gi.m_byGroundItemType).ToString(), gi.m_GameObject);
            }
            gi.m_Zone.m_pDynamicItems.Remove(gi);

            int iX = gi.m_iOddQX, iY = gi.m_iOddQY;
            int iDeltaY = (0 == (iX & 1)) ? -1 : 1;
            if (m_pSelectableTable.ContainsKey(iX * m_iGridHeight + iY)
             && m_pSelectableTable[iX * m_iGridHeight + iY].m_iGroundItemId == iCityId)
            {
                m_byOccupy[iX, iY] = 0;
                m_pSelectableTable.Remove(iX * m_iGridHeight + iY);
            }
            if (iX + 1 < m_iGridWidth
             && m_pSelectableTable.ContainsKey((iX + 1) * m_iGridHeight + iY)
             && m_pSelectableTable[(iX + 1) * m_iGridHeight + iY].m_iGroundItemId == iCityId)
            {
                m_byOccupy[iX + 1, iY] = 0;
                m_pSelectableTable.Remove((iX + 1) * m_iGridHeight + iY);
            }
            if (iX >= 1
             && m_pSelectableTable.ContainsKey((iX - 1) * m_iGridHeight + iY)
             && m_pSelectableTable[(iX - 1) * m_iGridHeight + iY].m_iGroundItemId == iCityId)
            {
                m_byOccupy[iX - 1, iY] = 0;
                m_pSelectableTable.Remove((iX - 1) * m_iGridHeight + iY);
            }
            if (iY + 1 < m_iGridHeight
             && m_pSelectableTable.ContainsKey(iX * m_iGridHeight + iY + 1)
             && m_pSelectableTable[iX * m_iGridHeight + iY + 1].m_iGroundItemId == iCityId)
            {
                m_byOccupy[iX, iY + 1] = 0;
                m_pSelectableTable.Remove(iX * m_iGridHeight + iY + 1);
            }
            if (iY > 1
             && m_pSelectableTable.ContainsKey(iX * m_iGridHeight + iY - 1)
             && m_pSelectableTable[iX * m_iGridHeight + iY - 1].m_iGroundItemId == iCityId)
            {
                m_byOccupy[iX, iY - 1] = 0;
                m_pSelectableTable.Remove(iX * m_iGridHeight + iY - 1);
            }
            if (iX + 1 < m_iGridWidth && iY + iDeltaY >= 0 && iY + iDeltaY < m_iGridHeight
             && m_pSelectableTable.ContainsKey((iX + 1) * m_iGridHeight + iY + iDeltaY)
             && m_pSelectableTable[(iX + 1) * m_iGridHeight + iY + iDeltaY].m_iGroundItemId == iCityId)
            {
                m_byOccupy[iX + 1, iY + iDeltaY] = 0;
                m_pSelectableTable.Remove((iX + 1) * m_iGridHeight + iY + iDeltaY);
            }
            if (iX > 1 && iY + iDeltaY >= 0 && iY + iDeltaY < m_iGridHeight
             && m_pSelectableTable.ContainsKey((iX - 1) * m_iGridHeight + iY + iDeltaY)
             && m_pSelectableTable[(iX - 1) * m_iGridHeight + iY + iDeltaY].m_iGroundItemId == iCityId)
            {
                m_byOccupy[iX - 1, iY + iDeltaY] = 0;
                m_pSelectableTable.Remove((iX - 1) * m_iGridHeight + iY + iDeltaY);
            }

            #region 范围

            byte[,] occupy = TerrainGroundItem.m_byOccupyGrids[gi.m_iItemGrade];
            int iWidth = occupy.GetLength(0);
            int iHalfWidth = (iWidth + 1) / 2;
            int iHeight = occupy.GetLength(1);
            bool bOffset = (0 != (iX & 1));
            if (0 == (iHalfWidth & 1))
            {
                bOffset = !bOffset;
            }

            for (int x = 0; x < iWidth; ++x)
            {
                for (int y = 0; y < iHeight; ++y)
                {
                    int iCheckX = iX - (iWidth - 1) / 2 + x;
                    int iOffset = (bOffset && (0 == (iCheckX & 1)) ? 1 : 0);
                    int iCheckY = iY - (iHeight - 1) / 2 + y + iOffset;
                    if (0 == (iHalfWidth & 1) && bOffset)
                    {
                        --iCheckY;
                    }
                    int iGrid = iCheckX * m_iGridHeight + iCheckY;
                    if (iCheckX >= 0 && iCheckX < m_iGridWidth
                     && iCheckY >= 0 && iCheckY < m_iGridHeight
                     && 1 == occupy[x, y])
                    {
                        if (null != m_iCityIndexTable[iGrid])
                        {
                            m_iCityIndexTable[iGrid].Remove(iCityId);
                        }
                    }
                }
            }

            #endregion

            if (m_InflenceIdToCities.ContainsKey(gi.m_sGroundItemOwner) && null != m_InflenceIdToCities[gi.m_sGroundItemOwner])
            {
                m_InflenceIdToCities[gi.m_sGroundItemOwner].RemoveAll(id => id == iCityId);
            }

            m_pSelectableTableById.Remove(iCityId);
            m_pSelectedItemTable.Remove(iCityId);
            m_pSelectedItems.RemoveAll(theCity => theCity.m_Item.m_iGroundItemId == iCityId);
            m_GroundItemInfos.RemoveAll(theCity => theCity.m_iGroundItemId == iCityId && (EBuildingType)theCity.m_byGroundItemType == (EBuildingType)gi.m_byGroundItemType);
            m_CityGroundItemInfos.RemoveAll(theCity => theCity.m_iGroundItemId == iCityId && (EBuildingType)theCity.m_byGroundItemType == (EBuildingType)gi.m_byGroundItemType);

            ResumeStaticItemOddQ(iX, iY, gi.m_iItemGrade);
            RefreshGroundPenentration();
            return true;
        }

        /// <summary>
        /// 干掉资源点
        /// </summary>
        /// <param name="iResourceId"></param>
        /// <returns></returns>
        public bool RemoveResource(int iResourceId)
        {
            GroundItemInfo gi;
            m_pUnselectableTableById.TryGetValue(iResourceId, out gi);
            if (null == gi)
            {
                return false;
            }

            int iGridId = gi.m_iOddQX * m_iGridHeight + gi.m_iOddQY;
            if (m_pUnselectableTable.ContainsKey(iGridId))
            {
                m_pUnselectableTable.Remove(iGridId);
            }

            if (null != gi.m_Script)
            {
                EBuildingType etype = gi.m_Script.m_eBuildingType;
                if (null != gi.m_GameObject)
                {
                    gi.m_Pool.ReturnObjectToPool(etype.ToString(), gi.m_GameObject);
                }
            }
            gi.m_Zone.m_pDynamicItems.Remove(gi);
            m_pUnselectableTableById.Remove(iResourceId);
            m_GroundItemInfos.RemoveAll(theCity => theCity.m_iGroundItemId == iResourceId && (EBuildingType)theCity.m_byGroundItemType != EBuildingType.MainCity);
            ResumeStaticItemOddQ(gi.m_iOddQX, gi.m_iOddQY, gi.m_iItemGrade);
            return true;
        }

        /// <summary>
        /// 改变主城位置
        /// </summary>
        /// <param name="iCityId"></param>
        /// <param name="iOddQX"></param>
        /// <param name="iOddQY"></param>
        /// <returns></returns>
        public bool ChangeCityPosition(int iCityId, int iOddQX, int iOddQY)
        {
            GroundItemInfo gi;
            m_pSelectableTableById.TryGetValue(iCityId, out gi);
            if (null == gi)
            {
                return false;
            }

            if (iOddQX == gi.m_iOddQX && iOddQY == gi.m_iOddQY)
            {
                return true;
            }

            gi.m_Zone.m_pDynamicItems.Remove(gi);
            int iX = gi.m_iOddQX, iY = gi.m_iOddQY;
            int iDeltaY = (0 == (iX & 1)) ? -1 : 1;
            if (m_pSelectableTable.ContainsKey(iX * m_iGridHeight + iY)
             && m_pSelectableTable[iX * m_iGridHeight + iY].m_iGroundItemId == iCityId)
            {
                m_byOccupy[iX, iY] = 0;
                m_pSelectableTable.Remove(iX * m_iGridHeight + iY);
            }
            if (iX + 1 < m_iGridWidth
             && m_pSelectableTable.ContainsKey((iX + 1) * m_iGridHeight + iY)
             && m_pSelectableTable[(iX + 1) * m_iGridHeight + iY].m_iGroundItemId == iCityId)
            {
                m_byOccupy[iX + 1, iY] = 0;
                m_pSelectableTable.Remove((iX + 1) * m_iGridHeight + iY);
            }
            if (iX >= 1
             && m_pSelectableTable.ContainsKey((iX - 1) * m_iGridHeight + iY)
             && m_pSelectableTable[(iX - 1) * m_iGridHeight + iY].m_iGroundItemId == iCityId)
            {
                m_byOccupy[iX - 1, iY] = 0;
                m_pSelectableTable.Remove((iX - 1) * m_iGridHeight + iY);
            }
            if (iY + 1 < m_iGridHeight
             && m_pSelectableTable.ContainsKey(iX * m_iGridHeight + iY + 1)
             && m_pSelectableTable[iX * m_iGridHeight + iY + 1].m_iGroundItemId == iCityId)
            {
                m_byOccupy[iX, iY + 1] = 0;
                m_pSelectableTable.Remove(iX * m_iGridHeight + iY + 1);
            }
            if (iY > 1
             && m_pSelectableTable.ContainsKey(iX * m_iGridHeight + iY - 1)
             && m_pSelectableTable[iX * m_iGridHeight + iY - 1].m_iGroundItemId == iCityId)
            {
                m_byOccupy[iX, iY - 1] = 0;
                m_pSelectableTable.Remove(iX * m_iGridHeight + iY - 1);
            }
            if (iX + 1 < m_iGridWidth && iY + iDeltaY >= 0 && iY + iDeltaY < m_iGridHeight
             && m_pSelectableTable.ContainsKey((iX + 1) * m_iGridHeight + iY + 1)
             && m_pSelectableTable[(iX + 1) * m_iGridHeight + iY + 1].m_iGroundItemId == iCityId)
            {
                m_byOccupy[iX + 1, iY + 1] = 0;
                m_pSelectableTable.Remove((iX + 1) * m_iGridHeight + iY + 1);
            }
            if (iX > 1 && iY + iDeltaY >= 0 && iY + iDeltaY < m_iGridHeight
             && m_pSelectableTable.ContainsKey((iX - 1) * m_iGridHeight + iY + 1)
             && m_pSelectableTable[(iX - 1) * m_iGridHeight + iY + 1].m_iGroundItemId == iCityId)
            {
                m_byOccupy[iX - 1, iY + 1] = 0;
                m_pSelectableTable.Remove((iX - 1) * m_iGridHeight + iY + 1);
            }
            ResumeStaticItemOddQ(iX, iY, gi.m_iItemGrade);

            #region 范围

            byte[,] occupy = TerrainGroundItem.m_byOccupyGrids[gi.m_iItemGrade];
            int iWidth = occupy.GetLength(0);
            int iHalfWidth = (iWidth + 1) / 2;
            int iHeight = occupy.GetLength(1);
            bool bOffset = (0 != (iX & 1));
            if (0 == (iHalfWidth & 1))
            {
                bOffset = !bOffset;
            }

            for (int x = 0; x < iWidth; ++x)
            {
                for (int y = 0; y < iHeight; ++y)
                {
                    int iCheckX = iX - (iWidth - 1) / 2 + x;
                    int iOffset = (bOffset && (0 == (iCheckX & 1)) ? 1 : 0);
                    int iCheckY = iY - (iHeight - 1) / 2 + y + iOffset;
                    if (0 == (iHalfWidth & 1) && bOffset)
                    {
                        --iCheckY;
                    }
                    int iGrid = iCheckX * m_iGridHeight + iCheckY;
                    if (iCheckX >= 0 && iCheckX < m_iGridWidth
                     && iCheckY >= 0 && iCheckY < m_iGridHeight
                     && 1 == occupy[x, y])
                    {
                        if (null != m_iCityIndexTable[iGrid])
                        {
                            m_iCityIndexTable[iGrid].Remove(iCityId);
                        }
                    }
                }
            }

            #endregion

            iX = iOddQX;
            iY = iOddQY;
            HideStaticItemOddQ(iX, iY, gi.m_iItemGrade);
            gi.m_iOddQX = iX;
            gi.m_iOddQY = iY;
            Vector2 vUv = OddQToUV(iX, iY);
            gi.m_Zone = GetZoneByUV(vUv);
            gi.m_Zone.m_pDynamicItems.Add(gi);
            Vector3 vPos, vNormal;
            if (gi.m_byGroundItemType == (byte)EBuildingType.MainCity)
                GetPosNormal(vUv, 0.0f, out vPos, out vNormal);
            else
                GetPosNormal(vUv, 0.6f, out vPos, out vNormal);
            Vector3 vLookDir = Vector3.Cross(vNormal, Vector3.left).normalized;
            gi.m_vGroundItemPos = vPos;
            gi.m_vGroundItemRotationUp = vNormal;
            gi.m_vGroundItemRotationLook = vLookDir;

            //如果我们的城市正处于显示状态，我们要改位置
            if (null != gi.m_GameObject)
            {
                //旧的扔了
                gi.m_Pool.ReturnObjectToPool(((EBuildingType)gi.m_byGroundItemType).ToString(), gi.m_GameObject);
                gi.m_GameObject = null;
                gi.m_Script = null;

                //讲道理不需要的，下一次update会自动摆出来
                /*
                //新的来
                gi.m_GameObject = m_pGroundItemPool[gi.m_byGroundItemType].NextAvailableObject();
                gi.m_GameObject.transform.position = gi.m_vGroundItemPos;
                gi.m_GameObject.transform.LookAt(gi.m_vGroundItemPos + gi.m_vGroundItemRotationLook, gi.m_vGroundItemRotationUp);
                //美术应该就是按照地图大小做的尺寸,不再改
                //gi.m_GameObject.transform.localScale = gi.m_vGroundItemScale;
                gi.m_Script = gi.m_GameObject.GetComponent<TerrainGroundItem>();
                gi.m_Script.Initial(this, gi, gi.m_iOddQX, gi.m_iOddQY, gi.m_iItemGrade, gi.m_iModelIndex);
                gi.m_Script.OnSelected(gi.m_bSelected);
                gi.m_Script.enabled = true;
                 */
            }

            int iDeltaY2 = (0 == (iX & 1)) ? -1 : 1;
            m_byOccupy[iX, iY] = 1;
            m_pSelectableTable[iX * m_iGridHeight + iY] = gi;
            if (iX - 1 >= 0)
            {
                m_byOccupy[iX - 1, iY] = 1;
                m_pSelectableTable[(iX - 1) * m_iGridHeight + iY] = gi;
                if (iY + iDeltaY2 >= 0 && iY + iDeltaY2 < m_iGridHeight)
                {
                    m_byOccupy[iX - 1, iY + iDeltaY2] = 1;
                    m_pSelectableTable[(iX - 1) * m_iGridHeight + iY + iDeltaY2] = gi;
                }
            }
            if (iX + 1 < m_iGridHeight)
            {
                m_byOccupy[iX + 1, iY] = 1;
                m_pSelectableTable[(iX + 1) * m_iGridHeight + iY] = gi;
                if (iY + iDeltaY2 >= 0 && iY + iDeltaY2 < m_iGridHeight)
                {
                    m_byOccupy[iX + 1, iY + iDeltaY2] = 1;
                    m_pSelectableTable[(iX + 1) * m_iGridHeight + iY + iDeltaY2] = gi;
                }
            }

            if (iY - 1 >= 0)
            {
                m_byOccupy[iX, iY - 1] = 1;
                m_pSelectableTable[iX * m_iGridHeight + iY - 1] = gi;
            }
            if (iY + 1 < m_iGridHeight)
            {
                m_byOccupy[iX, iY + 1] = 1;
                m_pSelectableTable[iX * m_iGridHeight + iY + 1] = gi;
            }

            #region 范围

            bOffset = (0 != (iX & 1));
            if (0 == (iHalfWidth & 1))
            {
                bOffset = !bOffset;
            }

            for (int x = 0; x < iWidth; ++x)
            {
                for (int y = 0; y < iHeight; ++y)
                {
                    int iCheckX = iX - (iWidth - 1) / 2 + x;
                    int iOffset = (bOffset && (0 == (iCheckX & 1)) ? 1 : 0);
                    int iCheckY = iY - (iHeight - 1) / 2 + y + iOffset;
                    if (0 == (iHalfWidth & 1) && bOffset)
                    {
                        --iCheckY;
                    }
                    int iGrid = iCheckX * m_iGridHeight + iCheckY;
                    if (iCheckX >= 0 && iCheckX < m_iGridWidth
                     && iCheckY >= 0 && iCheckY < m_iGridHeight
                     && 1 == occupy[x, y])
                    {
                        if (null == m_iCityIndexTable[iGrid])
                        {
                            m_iCityIndexTable[iGrid] = new List<int>();
                        }
                        m_iCityIndexTable[iGrid].Add(iCityId);
                    }
                }
            }

            #endregion

            RefreshGroundPenentration();
            return true;
        }

        /// <summary>
        /// 改变主城的模型
        /// </summary>
        /// <param name="iCityId"></param>
        /// <param name="iGrade"></param>
        /// <returns></returns>
        public bool ChangeCityModelGrade(int iCityId, int iGrade)
        {
            GroundItemInfo gi;
            m_pSelectableTableById.TryGetValue(iCityId, out gi);
            iGrade = Mathf.Clamp(iGrade, m_iMinModelIndex, m_iMaxModelIndex);
            if (null == gi)
            {
                return false;
            }

            if (gi.m_iModelIndex == iGrade)
            {
                return true;
            }

            gi.m_iModelIndex = iGrade;
            if (null != gi.m_Script)
            {
                gi.m_Script.SetCityModelGrate(iGrade);
            }
            return true;
        }

        /// <summary>
        /// 改变资源建筑模型
        /// </summary>
        /// <param name="iResourceId"></param>
        /// <param name="iGrade"></param>
        /// <returns></returns>
        public bool ChangeResourceModelGrade(int iResourceId, int iGrade)
        {
            GroundItemInfo gi;
            m_pUnselectableTableById.TryGetValue(iResourceId, out gi);
            iGrade = Mathf.Clamp(iGrade, m_iMinModelIndex, m_iMaxModelIndex);
            if (null == gi)
            {
                return false;
            }

            gi.m_iModelIndex = iGrade;
            if (null != gi.m_Script)
            {
                gi.m_Script.SetResourceState((EResourceBuildingState)iGrade);
            }
            return true;
        }

        #endregion

        #region Camera Move

        public delegate void CameraMoveCallback(string sFunction, string sKeyword, bool bFinished);
        private float m_fCameraMoveTimeFull = -1.0f;
        private float m_fCameraMoveTime = -1.0f;
        private Vector2 m_vCameraMoveFrom = Vector2.zero;
        private Vector2 m_vCameraMoveTo = Vector2.zero;

        private string m_sCameraCBFunction = "";
        private string m_sCameraCBKeyword = "";
        private CameraMoveCallback m_pCameraMoveCb = null;
        private Vector2 m_vCameraOffset;
        private float m_fCameraOffset;
        private float m_fCameraHeight;
        /// <summary>
        /// 移动摄像机到某个位置
        /// 注意：cb或者sFunction为空，都不会回调。如果不是Lua来的调用，随便加一个“sFunction”
        /// </summary>
        /// <param name="vUV"></param>
        /// <param name="cb"></param>
        /// <param name="sFunction"></param>
        /// <param name="sKeyword"></param>
        /// <param name="fSep"></param>
        public void MoveCameraTo(Vector2 vUV, CameraMoveCallback cb, string sFunction, string sKeyword, float fSep)
        {
            if (m_fCameraMoveTimeFull > 0.0f)
            {
                if (!string.IsNullOrEmpty(m_sCameraCBFunction) && null != m_pCameraMoveCb)
                {
                    m_pCameraMoveCb(m_sCameraCBFunction, m_sCameraCBKeyword, false);
                }
            }
            m_sCameraCBFunction = sFunction;
            m_sCameraCBKeyword = sKeyword;
            m_pCameraMoveCb = cb;
            fSep = Mathf.Max(fSep, 0.001f); //至少一帧
            //if (fSep > 0.05f)
            {
                m_fCameraMoveTimeFull = fSep;
                m_fCameraMoveTime = 0.0f;

                m_vCameraMoveFrom = new Vector2(m_vCameraPos.x / m_fGroundSize + 0.5f, m_vCameraPos.y / m_fGroundSize + 0.5f);
                Vector3 pos, normal;
                // 获取地表的高度
                GetPosNormal(vUV, 0f, out pos, out normal);
                m_fCameraHeight = pos.y;
                // 计算摄像机的偏移量.
                m_fCameraOffset = (float)(Math.Abs(pos.y) / Math.Tan(Camera.main.transform.localEulerAngles.x * Math.PI / 180));
                // 计算摄像机在x,z方向的偏移分量
                Vector2 offset = new Vector2((float)(m_fCameraOffset * Math.Sin(Camera.main.transform.localEulerAngles.y * Math.PI / 180)), (float)(m_fCameraOffset * Math.Cos(Camera.main.transform.localEulerAngles.y * Math.PI / 180)));
                // 计算偏移量所对应的uv
                Vector2 uvOffset = PosToUV(new Vector3(offset.x, 0, offset.y));

                // 由于坐标原点对应的uv为(0.5, 0.5), 所以此处需要减去
                Vector2 newUvOffset = uvOffset - new Vector2(0.5f, 0.5f);
                int oddQX, oddQY;
                UVToNearestOddQ(newUvOffset, out oddQX, out oddQY);
                m_vCameraMoveTo = vUV - newUvOffset;
                m_vCameraOffset = newUvOffset;
            }
            /*
            else
            {
                m_fCameraMoveTimeFull = -1.0f;
                m_fCameraMoveTime = -1.0f;

                m_vCameraPos.x = m_fGroundSize * (vUV.x - 0.5f);
                m_vCameraPos.y = m_fGroundSize * (vUV.y - 0.5f);
                if (!string.IsNullOrEmpty(m_sCameraCBFunction) && null != m_pCameraMoveCb)
                {
                    m_pCameraMoveCb(m_sCameraCBFunction, m_sCameraCBKeyword, true);
                }
                m_pCameraMoveCb = null;
                m_sCameraCBFunction = "";
                m_sCameraCBKeyword = "";
            }
             */
        }

        /// <summary>
        /// 获取摄像机朝向的OddQ
        /// </summary>
        /// <returns></returns>
        public Vector2 CameraPointTo()
        {
            return new Vector2(m_vCameraPos.x / m_fGroundSize + 0.5f, m_vCameraPos.y / m_fGroundSize + 0.5f) + m_vCameraOffset;
        }

        #endregion

        #region 迁城模式

        public delegate void OnMoveCity(int iOddQX, int iOddQY, bool bCanPut);
        private OnMoveCity m_pMoveCityCallBack = null;
        public void SetMoveCityCallBack(OnMoveCity cb)
        {
            m_pMoveCityCallBack = cb;
        }

        public void SetMoveCityOccupyRadius(int iNewRadius)
        {
            m_iCityOccupyRadius = iNewRadius;
        }

        [Obsolete("现在根据城市区域来显示")]
        public void SetMoveCityShowRadius(int iNewRadius)
        {
            //m_iShowCanPutCityDefaultRadius = iNewRadius;
        }

        private bool m_bMoveCityMode = false;
        private EMoveBuidingType m_eMoveType = EMoveBuidingType.None;
        private EBuildingType m_eLastMoveBuildingType = EBuildingType.None;
        private GameObject m_pMyCityMoving = null;
        private byte[,] m_byOccupyCity = null;
        private byte[,] m_byOccupyCamp = null;
        private GroundItemInfo m_MovingCityGI = null;

        public bool EnterMoveMainCityMode(float fMoveCamera)
        {
            if (m_bMoveCityMode)
            {
                return false;
            }

            GroundItemInfo playerCity;
            if (m_pSelectableTableById.TryGetValue(m_iMyCity, out playerCity) && null != playerCity)
            {
                return EnterMoveMainCityMode(fMoveCamera, playerCity.m_iOddQX, playerCity.m_iOddQY, 0, 1, "", "");
            }
            return false;
        }

        /// <summary>
        /// 进入迁城模式, 为了在切换到新的地区的时候能够在拖动的模型UI上显示玩家信息,需要传入cityLevel,guildFlagName, playerName
        /// </summary>
        /// <param name="fMoveCamera"></param>
        /// <param name="iOddQX"></param>
        /// <param name="iOddQY"></param>
        /// <param name="cityLevel"></param>
        /// <param name="guildFlagName"></param>
        /// <param name="playerName"></param>
        /// <returns></returns>
        public bool EnterMoveMainCityMode(float fMoveCamera, int iOddQX, int iOddQY, int cityLevel, int modelIndex, string guildFlagName, string playerName, EMoveBuidingType type = EMoveBuidingType.None)
        {
            if (m_bMoveCityMode)
            {
                return false;
            }

            m_eMoveType = type;
            GroundItemInfo playerCity;
            EBuildingType buildingType = EBuildingType.None;

            int iMyBuilding = -1;
            switch (m_eMoveType)
            {
                case EMoveBuidingType.MoveMainCity:
                    buildingType = EBuildingType.MainCity;
                    iMyBuilding = m_iMyCity;
                    break;
                case EMoveBuidingType.MoveCampsite:
                    buildingType = EBuildingType.Campsite;
                    iMyBuilding = m_iMyCity;
                    break;
            }

            if (m_pSelectableTableById.TryGetValue(iMyBuilding, out playerCity) && (EBuildingType)playerCity.m_byGroundItemType == buildingType)
            {
                if (playerCity.m_bIsPlayerMainCity)
                {
                    bool shouldCreatNew = m_MovingCityGI == null || m_MovingCityGI.m_byGroundItemType != playerCity.m_byGroundItemType;
                    m_MovingCityGI = playerCity;
                    m_bMoveCityMode = true;
                    m_v2EdgeMoveSpeed = Vector2.zero;

                    Vector2 vUV = OddQToUV(iOddQX, iOddQY);
                    SetCityOccutyByte();
                    SetCampOccupyByte();

                    MovingCityCheck();
                    UnSelectAll(true);
                    CreateCityMoveCityMode(playerCity, shouldCreatNew);
                    UpdateCanPutGrid(iOddQX, iOddQY, 1);
                    MoveCameraTo(vUV, InMoveCityModeCameraCallback, "1", "", fMoveCamera);
                    InitialOrClearTouchData();

                    return true;
                }
            }
            // 如果查找不到 则是在新的地区新建主城或者行营 需要有拖动的虚影.
            else
            {
                playerCity = PutPrefabAt(0, cityLevel, (byte)buildingType, iOddQX, iOddQY, modelIndex);
                playerCity.m_GameObject = playerCity.m_Pool.NextAvailableObject();
                playerCity.m_bIsPlayerMainCity = true;
                playerCity.m_iPlayerLevel = cityLevel;
                playerCity.m_sPlayerName = playerName;
                playerCity.m_sUnionFlagName = guildFlagName;
                playerCity.m_Script = playerCity.m_GameObject.GetComponent<TerrainGroundItem>();
                playerCity.m_Script.UpdateUIContent(playerCity);
                m_MovingCityGI = playerCity;
                m_bMoveCityMode = true;
                m_v2EdgeMoveSpeed = Vector2.zero;

                Vector2 vUV = OddQToUV(iOddQX, iOddQY);

                SetCityOccutyByte();
                SetCampOccupyByte();

                MovingCityCheck();
                UnSelectAll(true);
                CreateCityMoveCityMode(playerCity, true);
                UpdateCanPutGrid(iOddQX, iOddQY, 1);
                MoveCameraTo(vUV, InMoveCityModeCameraCallback, "1", "", fMoveCamera);
                InitialOrClearTouchData();
                return true;
            }
            return false;
        }

        private void SetCityOccutyByte()
        {
            //初始化格子
            m_byOccupyCity = new byte[m_iGridWidth, m_iGridHeight];

            //城市占用7个格子，地图最边缘以及行营所在区域需要排除，否则屁股漏在外面了。
            for (int i = 0; i < m_iMainCityHeightBegin; ++i)
            {
                for (int j = 0; j < m_iGridWidth; ++j)
                {
                    m_byOccupyCity[j, i] = 1;
                }
            }
            for (int i = m_iMainCityHeightEnd; i < m_iGridHeight; ++i)
            {
                for (int j = 0; j < m_iGridWidth; ++j)
                {
                    m_byOccupyCity[j, i] = 1;
                }
            }

            //下面两个循环和上面有四个角的重叠
            for (int i = 0; i < m_iMainCityWidthBegin; ++i)
            {
                for (int j = 0; j < m_iGridHeight; ++j)
                {
                    m_byOccupyCity[i, j] = 1;
                }
            }
            for (int i = m_iMainCityWidthEnd; i < m_iGridWidth; ++i)
            {
                for (int j = 0; j < m_iGridHeight; ++j)
                {
                    m_byOccupyCity[i, j] = 1;
                }
            }
        }

        private void SetCampOccupyByte()
        {
            m_byOccupyCamp = new byte[m_iGridWidth, m_iGridHeight];
            //行营需要排除地图边缘的格子,也就是以前主城的范围
            for (int i = 0; i < m_iGridHeight; ++i)
            {
                m_byOccupyCamp[0, i] = 1;
                m_byOccupyCamp[m_iGridWidth - 1, i] = 1;
            }

            for (int i = 0; i < m_iGridWidth; ++i)
            {
                m_byOccupyCamp[i, 0] = 1;
                m_byOccupyCamp[i, m_iGridHeight - 1] = 1;

            }
        }

        private void MovingCityCheck()
        {
            for (int i = 0; i < m_CityGroundItemInfos.Count; ++i)
            {
                GroundItemInfo gi = m_CityGroundItemInfos[i];
                if (gi.m_bIsPlayerMainCity)
                {
                    m_byOccupyCity[gi.m_iOddQX, gi.m_iOddQY] = 1;
                    m_byOccupyCamp[gi.m_iOddQX, gi.m_iOddQY] = 1;
                }
                //如果是盟友。我们要保证我们城市占的7个格子不和盟友7个格子重合
                //画图后得知，这几乎相当于排除距离平方<=5的格子（有两个例外格子）
                else if (m_iMyUnion > 0 && m_iMyUnion == gi.m_iGroundItemUnionId)
                {
                    bool bEven = (0 == (gi.m_iOddQX & 1));
                    for (int x = gi.m_iOddQX - 3; x <= gi.m_iOddQX + 3; ++x)
                    {
                        for (int y = gi.m_iOddQX - 3; y <= gi.m_iOddQX + 3; ++y)
                        {
                            //地图边缘上面已经标记过了，所以从1到width - 1
                            if (x >= 1 && x < m_iGridWidth - 1 && y >= 1 && y < m_iGridHeight - 1)
                            {
                                if ((x - gi.m_iOddQX) * (x - gi.m_iOddQX)
                                  + (y - gi.m_iOddQY) * (y - gi.m_iOddQY) <= 5)
                                {
                                    if (bEven)
                                    {
                                        //偶数两个例外格子是y=oddqy+2, x=oddqx+-1
                                        if (!(y == gi.m_iOddQY + 2 && (x == gi.m_iOddQX + 1 || x == gi.m_iOddQX - 1)))
                                        {
                                            m_byOccupyCity[x, y] = 1;
                                            m_byOccupyCamp[x, y] = 1;
                                        }
                                    }
                                    else
                                    {
                                        if (!(y == gi.m_iOddQY - 2 && (x == gi.m_iOddQX + 1 || x == gi.m_iOddQX - 1)))
                                        {
                                            m_byOccupyCity[x, y] = 1;
                                            m_byOccupyCamp[x, y] = 1;
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
                else
                {
                    for (int x = gi.m_iOddQX - m_iCityOccupyRadius; x < gi.m_iOddQX + m_iCityOccupyRadius; ++x)
                    {
                        for (int y = gi.m_iOddQY - m_iCityOccupyRadius; y < gi.m_iOddQY + m_iCityOccupyRadius; ++y)
                        {
                            if ((x - gi.m_iOddQX) * (x - gi.m_iOddQX) + (y - gi.m_iOddQY) * (y - gi.m_iOddQY) < m_iCityOccupyRadius * m_iCityOccupyRadius)
                            {
                                if (x >= 0 && x < m_iGridWidth && y >= 0 && y < m_iGridHeight)
                                {
                                    m_byOccupyCity[x, y] = 1;
                                    m_byOccupyCamp[x, y] = 1;
                                }
                            }
                        }
                    }
                }
            }
        }

        private void InMoveCityModeCameraCallback(string sFunction, string sKeyword, bool bFinished)
        {
            UpdateCanPutGrid(0, 0, 2);
        }

        public bool LeaveMoveMainCityMode()
        {
            if (!m_bMoveCityMode)
            {
                return false;
            }

            m_bMoveCityMode = false;
            if (m_eMoveType == EMoveBuidingType.MoveMainCity)
                m_eLastMoveBuildingType = EBuildingType.MainCity;
            else if (m_eMoveType == EMoveBuidingType.MoveCampsite)
                m_eLastMoveBuildingType = EBuildingType.Campsite;
            HideMoveCityGO();
            UnSelectAll();

            if (!m_bControlUsingLua && m_bLastCalculatedCanputCity)
            {
                ChangeCityPosition(m_iMyCity, m_iLastMoveCityOddQX, m_iLastMoveCityOddQY);
            }
            InitialOrClearTouchData();
            return true;
        }

        public bool IsInMoveMainCityMode()
        {
            return m_bMoveCityMode;
        }

        private int m_iLastMoveCityOddQX = -1;
        private int m_iLastMoveCityOddQY = -1;
        private bool m_bLastCalculatedCanputCity = false;
        //private int m_iShowCanPutCityDefaultRadius = 10;
        private int m_iCityOccupyRadius = 5;
        private void OnMoveTownTo(int iOddQX, int iOddQY)
        {
            if (m_iLastMoveCityOddQX == iOddQX && m_iLastMoveCityOddQY == iOddQY)
            {
                return;
            }

            UpdateCanPutGrid(iOddQX, iOddQY, 0);
        }

        /// <summary>
        /// iCallbackMode = 0。正常。
        /// iCallbackMode = 1，仅更新格子，不callback
        /// iCallbackMode = 2，仅 callback
        /// </summary>
        /// <param name="iOddQX"></param>
        /// <param name="iOddQY"></param>
        /// <param name="iCallbackMode"></param>
        private void UpdateCanPutGrid(int iOddQX, int iOddQY, int iCallbackMode)
        {
            if (2 == iCallbackMode)
            {
                if (null != m_pMoveCityCallBack)
                {
                    m_pMoveCityCallBack(m_iLastMoveCityOddQX, m_iLastMoveCityOddQY, m_bLastCalculatedCanputCity);
                }
                return;
            }
            m_iLastMoveCityOddQX = iOddQX;
            m_iLastMoveCityOddQY = iOddQY;

            //update can put
            bool bCanPut = false;

            //我们只画区域内的
            if (null != m_MovingCityGI)
            {
                CreateGroundTexture();
                int iX = iOddQX, iY = iOddQY;
                byte[,] occupy = TerrainGroundItem.m_byOccupyGrids[m_MovingCityGI.m_iItemGrade];
                int iWidth = occupy.GetLength(0);
                int iHalfWidth = (iWidth + 1) / 2;
                int iHeight = occupy.GetLength(1);
                bool bOffset = (0 != (iX & 1));
                if (0 == (iHalfWidth & 1))
                {
                    bOffset = !bOffset;
                }

                for (int x = 0; x < iWidth; ++x)
                {
                    for (int y = 0; y < iHeight; ++y)
                    {
                        int iCheckX = iX - (iWidth - 1) / 2 + x;
                        int iOffset = (bOffset && (0 == (iCheckX & 1)) ? 1 : 0);
                        int iCheckY = iY - (iHeight - 1) / 2 + y + iOffset;
                        if (0 == (iHalfWidth & 1) && bOffset)
                        {
                            --iCheckY;
                        }

                        //int iGrid = iCheckX * m_iGridHeight + iCheckY;
                        if (iCheckX >= 0 && iCheckX < m_iGridWidth
                         && iCheckY >= 0 && iCheckY < m_iGridHeight
                         && 1 == occupy[x, y])
                        {
                            bool inMainCityZone = iCheckX >= m_iMainCityWidthBegin
                                                  && iCheckX < m_iMainCityWidthEnd
                                                  && iCheckY >= m_iMainCityHeightBegin
                                                  && iCheckY < m_iMainCityHeightEnd;
                            if ((iCheckX - iOddQX) * (iCheckX - iOddQX) + (iCheckY - iOddQY) * (iCheckY - iOddQY) < m_iCityOccupyRadius * m_iCityOccupyRadius)
                            {
                                byte[,] byOccupy = null;
                                switch (m_eMoveType)
                                {
                                    case EMoveBuidingType.MoveMainCity:
                                        byOccupy = m_byOccupyCity;
                                        break;
                                    case EMoveBuidingType.MoveCampsite:
                                        byOccupy = m_byOccupyCamp;
                                        break;
                                }
                                bool bValid = (0 == m_byOccupyGround[iCheckX, iCheckY] && 0 == byOccupy[iCheckX, iCheckY]);
                                DrawGridAtUV(OddQToUV(iCheckX, iCheckY), bValid ? m_cCanPutCity : m_cCanNotPutCity);
                                if (iCheckX == iOddQX && iCheckY == iOddQY)
                                {
                                    if (m_MovingCityGI.m_bIsPlayerMainCity)
                                    {
                                        if (m_MovingCityGI.m_byGroundItemType == (byte)EBuildingType.Campsite)
                                            bCanPut = bValid;
                                        else
                                            bCanPut = bValid && inMainCityZone;

                                    }
                                }
                            }
                        }
                    }
                }
                ApplyChanged();
            }

            m_bLastCalculatedCanputCity = bCanPut;
            //put transparent city
            PutMoveCityToPos((EBuildingType)m_MovingCityGI.m_byGroundItemType, iOddQX, iOddQY, bCanPut);

            //event
            if (null != m_pMoveCityCallBack && 1 != iCallbackMode)
            {
                m_pMoveCityCallBack(iOddQX, iOddQY, bCanPut);
            }
        }

        /// <summary>
        /// 创造一个假城
        /// </summary>
        /// <param name="gi"></param>
        private void CreateCityMoveCityMode(GroundItemInfo gi, bool shouldCreatNew)
        {
            if (null == m_pMyCityMoving || shouldCreatNew)
            {
                EBuildingType buildingType = EBuildingType.None;
                switch (m_eMoveType)
                {
                    case EMoveBuidingType.MoveMainCity:
                        buildingType = EBuildingType.MainCity;
                        break;
                    case EMoveBuidingType.MoveCampsite:
                        buildingType = EBuildingType.Campsite;
                        break;
                }

                // 由于这次迁徙和上次迁徙的建筑类型不同,需要先归还上次迁移的gameObject,防止它无家可归
                if (m_pMyCityMoving != null)
                    m_pGroundItemPool[(byte)m_eLastMoveBuildingType].ReturnObjectToPool(m_eLastMoveBuildingType.ToString(), m_pMyCityMoving);
                m_pMyCityMoving = m_pGroundItemPool[(byte)buildingType].NextAvailableObject();
                TerrainGroundItem item = m_pMyCityMoving.GetComponent<TerrainGroundItem>();

                item.Initial(this, gi, gi.m_iOddQX, gi.m_iOddQY, gi.m_iItemGrade, gi.m_iModelIndex);
                item.enabled = false;
                item.m_pShadowProjector.gameObject.SetActive(false);

                //美术应该就是按照地图大小做的尺寸,不再改
                m_pMyCityMoving.transform.localScale = Vector3.one * 1.05f;
                //m_pMyCityMoving.transform.localScale = gi.m_vGroundItemScale * 1.05f;

                for (int i = 0; i < item.m_pModels.Length; ++i)
                {
                    foreach (MeshRenderer mr in item.m_pModels[i].GetComponentsInChildren<MeshRenderer>(true))
                    {
                        mr.material.shader = Shader.Find("LPCFramework/Transparent/TransparentCity");
                        mr.material.SetVector("_Shake", m_v4PutCityShaderParam);
                    }
                }
            }

            m_pMyCityMoving.SetActive(true);

            TerrainGroundItem itemscript = m_pMyCityMoving.GetComponent<TerrainGroundItem>();
            itemscript.ForceShowRange((ECityRange)gi.m_iItemGrade, gi.m_iGroundItemUnionId);
            itemscript.UpdateUIContent(gi);
            for (int i = 0; i < itemscript.m_pModels.Length; ++i)
            {
                itemscript.m_pModels[i].SetActive(i == (gi.m_iModelIndex - 1));
            }
        }

        private void HideMoveCityGO()
        {
            m_pMyCityMoving.SetActive(false);
        }

        private void PutMoveCityToPos(EBuildingType type, int iOddQX, int iOddQY, bool bCanPut)
        {
            //put to position
            Vector2 vUv = OddQToUV(iOddQX, iOddQY);
            Vector3 vPos, vNormal;
            if (type == EBuildingType.MainCity)
                GetPosNormal(vUv, 0.0f, out vPos, out vNormal);
            else
                GetPosNormal(vUv, 0.6f, out vPos, out vNormal);

            Vector3 vLookDir = Vector3.Cross(vNormal, Vector3.left).normalized;
            m_pMyCityMoving.transform.position = vPos;
            m_pMyCityMoving.transform.LookAt(vPos + vLookDir, vNormal);

            //set color
            TerrainGroundItem item = m_pMyCityMoving.GetComponent<TerrainGroundItem>();
            item.ResetProjectorPos();
            for (int i = 0; i < item.m_pModels.Length; ++i)
            {
                foreach (MeshRenderer mr in item.m_pModels[i].GetComponentsInChildren<MeshRenderer>(true))
                {
                    mr.material.SetVector("_Color", bCanPut ? m_cCanPutCityGI : m_cCanNotPutCityGI);
                }
            }
        }

        #endregion

        #region Color Table

        public Color m_cPlayerCityProjector = TerrainParameters.PLAYR_CITY_PROJECTOR_COLOR;
        public Color m_cPlayerUnionProjector = TerrainParameters.PLAYR_UNION_PROJECTOR_COLOR;
        public Color m_cNoUnionProjector = TerrainParameters.NO_UNION_PROJECTOR_COLOR;
        public Color m_cEnemyUnionProjector = TerrainParameters.ENEMY_UNION_PROJECTOR_COLOR;
        public Color m_cPenetration = TerrainParameters.PENETRATION_COLOR;

        public Color m_cCanPutCity = TerrainParameters.CAN_PUT_CITY_COLOR;
        public Color m_cCanNotPutCity = TerrainParameters.CAN_NOT_PUT_CITY_COLOR;

        public Color m_cCanPutCityGI = TerrainParameters.CAN_PUT_CITY_GI_COLOR;
        public Color m_cCanNotPutCityGI = TerrainParameters.CAN_NOT_PUT_CITY_GUI_COLOR;

        public Vector4 m_v4PutCityShaderParam = TerrainParameters.PUT_CITY_SHADER_PARAM;
        public readonly Dictionary<int, Color> m_dicUnionColor = new Dictionary<int, Color>(new IntEqualityComparer());

        #endregion

        #region For mono build, JIT (on iOS it was JIT, not sure what it is now)

        /// <summary>
        /// 为了规避Mono在iOS上用mono编译时的一个坑。在iOS上是JIT,值类型的Dictionary需要这个
        /// </summary>
        public class IntEqualityComparer : IEqualityComparer<int>
        {
            public bool Equals(int a, int b)
            {
                return a == b;
            }

            public int GetHashCode(int data)
            {
                return data.GetHashCode();
            }
        }

        public class ByteEqualityComparer : IEqualityComparer<byte>
        {
            public bool Equals(byte a, byte b)
            {
                return a == b;
            }

            public int GetHashCode(byte data)
            {
                return data.GetHashCode();
            }
        }

        #endregion
    }
}
