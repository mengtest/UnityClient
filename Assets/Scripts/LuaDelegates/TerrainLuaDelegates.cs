using System;
using UnityEngine;
using XLua;
using System.Collections.Generic;

namespace LPCFramework
{
    [LuaCallCSharp]
    public class TerrainLuaDelegates
    {
        /// <summary>
        /// 根据策划给的每级别的城市设置占用格子，目前如下：
        /// 保证主城在中央，矩阵为nxn，其中n是奇数
        //public static readonly byte[][,] m_byOccupyGrids =
        //{
        //    new byte[,] {}, //0
        //new byte[,] //1
        //{
        //    {0,0,0,0,0,0,0},
        //    {0,0,0,1,0,0,0},
        //    {0,0,0,1,1,0,0},
        //    {0,1,1,1,1,1,0},
        //    {0,0,0,1,1,0,0},
        //    {0,0,0,1,0,0,0},
        //    {0,0,0,0,0,0,0},
        //}, 

        //new byte[,] //2
        //{
        //    {0,0,0,0,0,0,0},
        //    {0,0,0,1,0,0,0},
        //    {0,0,1,1,1,1,0},
        //    {0,1,1,1,1,1,0},
        //    {0,0,1,1,1,1,0},
        //    {0,0,0,1,0,0,0},
        //    {0,0,0,0,0,0,0},
        //}, 

        //new byte[,] //3
        //{
        //    {0,0,0,0,0,0,0},
        //    {0,0,1,1,1,0,0},
        //    {0,0,1,1,1,1,0},
        //    {0,1,1,1,1,1,0},
        //    {0,0,1,1,1,1,0},
        //    {0,0,1,1,1,0,0},
        //    {0,0,0,0,0,0,0},
        //}, 

        //new byte[,] //4
        //{
        //    {0,0,0,0,0,0,0},
        //    {0,1,1,1,1,1,0},
        //    {0,0,1,1,1,1,0},
        //    {0,1,1,1,1,1,0},
        //    {0,0,1,1,1,1,0},
        //    {0,1,1,1,1,1,0},
        //    {0,0,0,0,0,0,0},
        //}, 

        //new byte[,] //5
        //{
        //    {0,0,0,1,1,0,0},
        //    {0,1,1,1,1,1,0},
        //    {0,0,1,1,1,1,0},
        //    {0,1,1,1,1,1,0},
        //    {0,0,1,1,1,1,0},
        //    {0,1,1,1,1,1,0},
        //    {0,0,0,1,1,0,0},
        //}, 

        //new byte[,] //6
        //{
        //    {0,0,1,1,1,1,0},
        //    {0,1,1,1,1,1,0},
        //    {0,0,1,1,1,1,0},
        //    {0,1,1,1,1,1,0},
        //    {0,0,1,1,1,1,0},
        //    {0,1,1,1,1,1,0},
        //    {0,0,1,1,1,1,0},
        //}, 

        //new byte[,] //7
        //{
        //    {0,0,1,1,1,1,0},
        //    {0,1,1,1,1,1,0},
        //    {0,1,1,1,1,1,1},
        //    {0,1,1,1,1,1,0},
        //    {0,1,1,1,1,1,1},
        //    {0,1,1,1,1,1,0},
        //    {0,0,1,1,1,1,0},
        //}, 

        //new byte[,] //8
        //{
        //    {0,1,1,1,1,1,0},
        //    {0,1,1,1,1,1,0},
        //    {0,1,1,1,1,1,1},
        //    {1,1,1,1,1,1,1},
        //    {0,1,1,1,1,1,1},
        //    {0,1,1,1,1,1,0},
        //    {0,1,1,1,1,1,0},
        //}, 

        //};
        //来不及处理了。。。先空着
        /// </summary>
        /// <param name="iCityGrade"></param>
        /// <param name="inf"></param>
        public static void SetBigMapCityInference(int iCityGrade, byte[,] inf)
        {

        }

        /// <summary>
        /// 根据格子高度重设格子。
        /// 目前场景中，默认的高度为173，重设出来的为200x173个格子
        /// 如果需要改这个数值又不想改场景可以调用这个接口，但注意一定要在spawn城市资源点前做这件事情！！
        /// </summary>
        /// <param name="iGridHeight"></param>
        /// <returns></returns>
        public static bool ResetGroundGridHeight(int iGridHeight)
        {
            if (null == TerrainGroundCoordinate.m_Intantance)
            {
                return false;
            }
            TerrainGroundCoordinate.m_Intantance.CalculateGrodOddQ(iGridHeight);
            return true;
        }

        /// <summary>
        /// 告诉大地图控制摄像机了
        /// </summary>
        /// <returns>如果是false，说明场景里压根没有大地图啊亲</returns>
        public static bool GoBigMap()
        {
            if (null == TerrainGroundCoordinate.m_Intantance)
            {
                return false;
            }
            TerrainGroundCoordinate.m_Intantance.m_bControlUsingLua = true;
            TerrainGroundCoordinate.m_Intantance.EnterBigMap(true);
            TerrainGroundCoordinate.m_Intantance.m_pCB = OnClickGround;
            TerrainGroundCoordinate.m_Intantance.m_pCameraChangedCb = OnCameraFaceToChanged;
            TerrainGroundCoordinate.m_Intantance.SetMoveCityCallBack(OnMoveCityTo);
            return true;
        }

        /// <summary>
        /// 告诉大地图不控制摄像机了
        /// </summary>
        /// <returns></returns>
        public static bool LeaveBigMap()
        {
            if (null == TerrainGroundCoordinate.m_Intantance)
            {
                return false;
            }
            TerrainGroundCoordinate.m_Intantance.EnterBigMap(false);
            TerrainGroundCoordinate.m_Intantance.m_pCB = null;
            return true;
        }

        /// <summary>
        /// 设置摄像机参数
        /// </summary>
        /// <param name="fMotion">鼠标移动对应的摄像机移动的系数</param>
        /// <param name="fAcc">摄像机摩擦</param>
        /// <param name="fIsPressCheck">鼠标移动大于多少像素认为不是点击</param>
        /// <returns></returns>
        public static bool SetCameraParameters(float fMotion, float fAcc, float fIsPressCheck)
        {
            if (null == TerrainGroundCoordinate.m_Intantance)
            {
                return false;
            }
            TerrainGroundCoordinate.m_Intantance.SetCameraParameters(fMotion, fAcc, fIsPressCheck);
            return true;
        }

        public class BlockPointInfo
        {
            public int BlockX;
            public int BlockY;
            public int BlockType;
        }

        /// <summary>
        /// 设置地形参数
        /// </summary>
        /// <returns></returns>
        public static bool SetTerrainParam(
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

            List<BlockPointInfo> blockPointInfo
            )
        {
            if (null == TerrainGroundCoordinate.m_Intantance)
            {
                return false;
            }
            TerrainGroundCoordinate.m_Intantance.SetTerrainParameters(
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

            return true;
        }

        #region Get Ground Parameter

        /// <summary>
        /// 获得大地图的一些基础属性，如果需要自己做一些计算的话
        /// 这是地面顶点数（heightmap的边长）
        /// </summary>
        /// <returns></returns>
        [Obsolete("No Use anymore")]
        public static int GetVertexCount()
        {
            if (null == TerrainGroundCoordinate.m_Intantance)
            {
                return 1;
            }
            return 1;//TerrainGroundCoordinate.m_Intantance.m_iVertexCount;
        }

        /// <summary>
        /// OddQ格子数量高，比如173
        /// </summary>
        /// <returns></returns>
        public static int GetGridHeight()
        {
            if (null == TerrainGroundCoordinate.m_Intantance)
            {
                return 1;
            }
            return TerrainGroundCoordinate.m_Intantance.m_iGridHeight;
        }

        /// <summary>
        /// OddQ格子数量宽，比如200
        /// </summary>
        /// <returns></returns>
        public static int GetGridWidth()
        {
            if (null == TerrainGroundCoordinate.m_Intantance)
            {
                return 1;
            }
            return TerrainGroundCoordinate.m_Intantance.GetGridWidth();
        }

        /// <summary>
        /// 地面展开成平面后的边长（米）
        /// </summary>
        /// <returns></returns>
        public static float GetMapSize()
        {
            if (null == TerrainGroundCoordinate.m_Intantance)
            {
                return 1.0f;
            }
            return TerrainGroundCoordinate.m_Intantance.m_fGroundSize;
        }

        /// <summary>
        /// 地面曲面的半径（米）
        /// </summary>
        /// <returns></returns>
        public static float GetMapCurveRadius()
        {
            if (null == TerrainGroundCoordinate.m_Intantance)
            {
                return 1.0f;
            }
            return TerrainGroundCoordinate.m_Intantance.m_fCurveRadius;
        }

        /// <summary>
        /// 地面曲面的夹角
        /// </summary>
        /// <returns></returns>
        public static float GetMapCurveDegree()
        {
            if (null == TerrainGroundCoordinate.m_Intantance)
            {
                return 0.0f;
            }
            return TerrainGroundCoordinate.m_Intantance.m_fCurveDegree;
        }

        /// <summary>
        /// 一个六边形格子的高度（米）
        /// </summary>
        /// <returns></returns>
        public static float GetOneGridHeight()
        {
            if (null == TerrainGroundCoordinate.m_Intantance)
            {
                return 1.0f;
            }
            return TerrainGroundCoordinate.m_Intantance.GetHeightSep();
        }

        /// <summary>
        /// 一个六边形格子的边长，或者说宽的一半（米）
        /// </summary>
        /// <returns></returns>
        public static float GetOneGridEdgeWidth()
        {
            if (null == TerrainGroundCoordinate.m_Intantance)
            {
                return 1.0f;
            }
            return TerrainGroundCoordinate.m_Intantance.GetEdigeWidth();
        }

        #endregion

        #region Conventional

        /// <summary>
        /// 坐标转换。现在有三套坐标：
        /// OddQ坐标
        /// UV: 将大地图展开成平面后的坐标，(0-1, 0-1)
        /// Position：世界坐标。下面的函数里将假设给出的Position至少在地表附近。
        /// 如果Position不在地表附近，将不可能给出唯一的，对应的OddQ或者UV坐标，原因是地面有起伏的。同一个位置有不同的投影方式。
        /// 所以暂时假定是Position在地表附近。
        /// 也可以有别的约定，比如约定为球坐标投影等等。但是根据需求考虑的话上面这个假定似乎更合理。
        /// </summary>
        /// <param name="vPos"></param>
        /// <returns>x,y</returns>
        public static int[] GetOddQByPos(Vector3 vPos)
        {
            if (null == TerrainGroundCoordinate.m_Intantance)
            {
                return new[] { 0, 0 };
            }
            Vector2 vUV = TerrainGroundCoordinate.m_Intantance.PosToUV(vPos);
            return GetOddQByUV(vUV);
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="vUV"></param>
        /// <returns>x,y</returns>
        public static int[] GetOddQByUV(Vector2 vUV)
        {
            if (null == TerrainGroundCoordinate.m_Intantance)
            {
                return new[] { 0, 0 };
            }
            int iX, iY;
            TerrainGroundCoordinate.m_Intantance.UVToNearestOddQ(vUV, out iX, out iY);
            return new[] { iX, iY };
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="iX"></param>
        /// <param name="iY"></param>
        /// <returns>pos, normal</returns>
        public static Vector3[] GetPosNormalByOddQ(int iX, int iY)
        {
            if (null == TerrainGroundCoordinate.m_Intantance)
            {
                return new[] { Vector3.zero, Vector3.up };
            }
            return GetPosNormalByUV(TerrainGroundCoordinate.m_Intantance.OddQToUV(iX, iY));
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="vUV"></param>
        /// <returns>pos, normal</returns>
        public static Vector3[] GetPosNormalByUV(Vector2 vUV)
        {
            if (null == TerrainGroundCoordinate.m_Intantance)
            {
                return new[] { Vector3.zero, Vector3.up };
            }
            Vector3 vPos, vNor;
            TerrainGroundCoordinate.m_Intantance.GetPosNormal(
                vUV,
                0.0f,
                out vPos,
                out vNor
                );
            return new[] { vPos, vNor };
        }

        public static Vector2 GetUVByOddQ(int iX, int iY)
        {
            if (null == TerrainGroundCoordinate.m_Intantance)
            {
                return Vector2.zero;
            }
            return TerrainGroundCoordinate.m_Intantance.OddQToUV(iX, iY);
        }

        public static Vector2 GetUVByPos(Vector3 vPos)
        {
            if (null == TerrainGroundCoordinate.m_Intantance)
            {
                return Vector2.zero;
            }
            return TerrainGroundCoordinate.m_Intantance.PosToUV(vPos);
        }

        /// <summary>
        /// 屏幕坐标做伪RayCast计算出来的对应的地面上的坐标
        /// </summary>
        /// <param name="vScreen"></param>
        /// <returns>是否cast hit到地面，x, y</returns>
        public static object[] ScreenPosToUV(Vector2 vScreen)
        {
            if (null == TerrainGroundCoordinate.m_Intantance)
            {
                return new object[] { false, Vector2.zero };
            }
            Vector2 vUV;
            bool bHit = TerrainGroundCoordinate.m_Intantance.TerrainRaycast(vScreen, out vUV);
            return new object[] { bHit, vUV };
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="vScreen"></param>
        /// <returns>是否cast hit到地面，vector3</returns>
        public static object[] ScreenPosOddQ(Vector2 vScreen)
        {
            if (null == TerrainGroundCoordinate.m_Intantance)
            {
                return new object[] { false, 0, 0 };
            }
            Vector2 vUV;
            bool bHit = TerrainGroundCoordinate.m_Intantance.TerrainRaycast(vScreen, out vUV);
            int iX = 0, iY = 0;
            if (bHit)
            {
                TerrainGroundCoordinate.m_Intantance.UVToNearestOddQ(vUV, out iX, out iY);
            }
            return new object[] { bHit, iX, iY };
        }

        #endregion

        #region Spawn

        /// <summary>
        /// 这个点能不能放东西？（可能被占用了，可能在水下，可能是个斜坡）
        /// </summary>
        /// <param name="iOddQX"></param>
        /// <param name="iOddQY"></param>
        /// <returns></returns>
        public static bool CanSpawnGroundItem(int iOddQX, int iOddQY)
        {
            if (null == TerrainGroundCoordinate.m_Intantance)
            {
                return true;
            }
            return 0 == TerrainGroundCoordinate.m_Intantance.m_byOccupy[iOddQX, iOddQY];
        }

        /// <summary>
        /// 摆一个城
        /// TODO 感觉这个接口会无限增大，建议写成struct或者table传递比较灵活
        /// 这个struct写在lua里比较合适。但不太清楚是否可以在Lua里写一个struct给CSharp用，可能用table更好。
        /// 但是也不太清楚table的传递，所以这个接口暂时我先不改
        /// </summary>
        /// <param name="sInflenceId"></param>
        /// <param name="iPlayerLevel"></param>
        /// <param name="iOddQX"></param>
        /// <param name="iOddQY"></param>
        /// <param name="iCityGrade">1-8,势力范围等级</param>
        /// <param name="iModelIndex">1-3,模型等级</param>
        /// <param name="iUnionId">所属联盟id</param>
        /// <param name="sUnionName"></param>
        /// <param name="bIsPlayerMainCity">是否为玩家主城</param>
        /// <param name="sPlayerName"></param>
        /// <returns></returns>
        public static int SpawnGroundCity(string sInflenceId, string sPlayerName, int iPlayerLevel, int iOddQX, int iOddQY,
            int iCityGrade, int iModelIndex, int iUnionId, string sUnionName, string sFlagGuildFlagName, bool bIsPlayerMainCity, int buildingType)
        {
            if (null == TerrainGroundCoordinate.m_Intantance)
            {
                return -1;
            }

            return TerrainGroundCoordinate.m_Intantance.SpawnGroundCity(sInflenceId, sPlayerName, iPlayerLevel, iOddQX, iOddQY,
                iCityGrade, iModelIndex, iUnionId, sUnionName, sFlagGuildFlagName, bIsPlayerMainCity, (EBuildingType)buildingType);
        }

        /// <summary>
        /// 随机摆一个城，测试用
        /// </summary>
        /// <param name="sInflenceId"></param>
        /// <returns></returns>
        public static int SpawnGroundCityRandomPos(string sInflenceId)
        {
            if (null == TerrainGroundCoordinate.m_Intantance)
            {
                return -1;
            }

            return TerrainGroundCoordinate.m_Intantance.SpawnGroundCity(sInflenceId, "a", 1, -1, -1, -1, -1, -1, "a", "b", false, EBuildingType.MainCity);
        }

        /// <summary>
        /// 摆一个资源点
        /// </summary>
        /// <param name="iId"></param>
        /// <param name="sInflenceId"></param>
        /// <param name="iOddQX"></param>
        /// <param name="iOddQY"></param>
        /// <param name="byType"></param>
        /// <param name="iModelIndex">1-3,表示空，半，满</param>
        /// <returns></returns>
        public static bool SpawnGroundItem(int iId, string sInflenceId, int iOddQX, int iOddQY, byte byType, int iModelIndex)
        {
            if (null == TerrainGroundCoordinate.m_Intantance)
            {
                return false;
            }
            TerrainGroundCoordinate.m_Intantance.SpawnGroundItem(iId, sInflenceId, iOddQX, iOddQY, byType, iModelIndex);
            return true;
        }

        /// <summary>
        /// 随机摆一个树，测试用
        /// </summary>
        /// <param name="iId"></param>
        /// <param name="sInflenceId"></param>
        /// <returns></returns>
        public static bool SpawnGroundItemRandomPos(int iId, string sInflenceId)
        {
            if (null == TerrainGroundCoordinate.m_Intantance)
            {
                return false;
            }
            TerrainGroundCoordinate.m_Intantance.SpawnGroundItem(iId, sInflenceId, -1, -1, 0, -1);
            return true;
        }

        #endregion

        #region Ground Item Infomation

        /// <summary>
        /// 获取城市信息
        /// </summary>
        /// <param name="iCityId"></param>
        /// <returns></returns>
        public static GroundItemInfo GetCityInfoById(int iCityId)
        {
            if (null != TerrainGroundCoordinate.m_Intantance)
            {
                return TerrainGroundCoordinate.m_Intantance.GetSelectableById(iCityId);
            }
            return null;
        }

        /// <summary>
        /// 获取资源点信息
        /// </summary>
        /// <param name="iTreeId"></param>
        /// <returns></returns>
        public static GroundItemInfo GetGroundInfoPosById(int iTreeId)
        {
            if (null != TerrainGroundCoordinate.m_Intantance)
            {
                return TerrainGroundCoordinate.m_Intantance.GetUnSelectableById(iTreeId);
            }
            return null;
        }

        /// <summary>
        /// 获取城市信息（注意城市占7个格子的，这个x,y是这7个格子中任意一个就可以找到这个城市）
        /// </summary>
        /// <param name="iX"></param>
        /// <param name="iY"></param>
        /// <returns></returns>
        public static object GetCityInfoByOddQPos(int iX, int iY)
        {
            if (null != TerrainGroundCoordinate.m_Intantance)
            {
                return TerrainGroundCoordinate.m_Intantance.GetSelectableByPos(iX, iY);
            }
            return null;
        }

        /// <summary>
        /// 获取格子上的资源点信息
        /// 现在即使没有资源点，如果属于某个城市也能取出来了。type为0
        /// </summary>
        /// <param name="iX"></param>
        /// <param name="iY"></param>
        /// <returns></returns>
        public static object GetGroundInfoOddQPos(int iX, int iY)
        {
            if (null != TerrainGroundCoordinate.m_Intantance)
            {
                return TerrainGroundCoordinate.m_Intantance.GetUnSelectableByPos(iX, iY);
            }
            return null;
        }

        #endregion

        #region Operations

        #region 主城修改

        /// <summary>
        /// 删除城市（这个接口可能要测测）
        /// </summary>
        /// <param name="iCityId"></param>
        /// <returns></returns>
        public static bool RemoveCity(int iCityId)
        {
            if (null == TerrainGroundCoordinate.m_Intantance)
            {
                return false;
            }
            return TerrainGroundCoordinate.m_Intantance.RemoveCity(iCityId);
        }

        /// <summary>
        /// 更新城市信息
        /// </summary>
        /// <param name="iCityId"></param>
        /// <param name="iLevel"></param>
        /// <param name="iCityModelLevel"></param>
        /// <param name="iPlayerLevel"></param>
        /// <param name="iUnionId"></param>
        /// <param name="sUnionName"></param>
        /// <param name="iNewPosX"></param>
        /// <param name="iNewPosY"></param>
        /// <param name="sPlayerName"></param>
        /// <returns></returns>
        public static bool UpdateCityInfo(int iCityId, int iLevel, int iCityModelLevel, string sPlayerName, int iPlayerLevel, int iUnionId, string sUnionName, int iNewPosX, int iNewPosY)
        {
            if (null == TerrainGroundCoordinate.m_Intantance)
            {
                return false;
            }

            bool result = TerrainGroundCoordinate.m_Intantance.SetCityGrade(iCityId, iLevel) &&
                          TerrainGroundCoordinate.m_Intantance.ChangeCityModelGrade(iCityId, iCityModelLevel) &&
                          TerrainGroundCoordinate.m_Intantance.SetCityUnionId(iCityId, iUnionId, sUnionName) &&
                          TerrainGroundCoordinate.m_Intantance.SetCityPlayerLevel(iCityId, iPlayerLevel) &&
                          TerrainGroundCoordinate.m_Intantance.SetCityPlayerName(iCityId, sPlayerName) &&
                          TerrainGroundCoordinate.m_Intantance.ChangeCityPosition(iCityId, iNewPosX, iNewPosY);

            return result;
        }
        /// <summary>
        /// 升级一个城池的等级和它的模型等级
        /// </summary>
        /// <param name="iCityId"></param>
        /// <param name="iLevel"></param>
        /// <param name="iCityModelLevel"></param>
        /// <returns></returns>
        public static bool UpdateCityGradeAndModelGrade(int iCityId, int iLevel, int iCityModelLevel)
        {
            if (null == TerrainGroundCoordinate.m_Intantance)
            {
                return false;
            }
            bool result = TerrainGroundCoordinate.m_Intantance.SetCityGrade(iCityId, iLevel) &&
                TerrainGroundCoordinate.m_Intantance.ChangeCityModelGrade(iCityId, iCityModelLevel);

            return result;
        }
        /// <summary>
        /// 改变城市区域级别, iNewGrade = 1-8
        /// </summary>
        /// <param name="iCityId"></param>
        /// <param name="iNewGrade"></param>
        /// <returns></returns>
        public static bool ChangeCityGrade(int iCityId, int iNewGrade)
        {
            if (null == TerrainGroundCoordinate.m_Intantance)
            {
                return false;
            }
            return TerrainGroundCoordinate.m_Intantance.SetCityGrade(iCityId, iNewGrade);
        }

        /// <summary>
        /// 改变城市模型级别, iNewGrade = 1-3
        /// </summary>
        /// <param name="iCityId"></param>
        /// <param name="iNewGrade"></param>
        /// <returns></returns>
        public static bool ChangeCityModelGrade(int iCityId, int iNewGrade)
        {
            if (null == TerrainGroundCoordinate.m_Intantance)
            {
                return false;
            }
            return TerrainGroundCoordinate.m_Intantance.ChangeCityModelGrade(iCityId, iNewGrade);
        }

        /// <summary>
        /// 改变城市所属的联盟Id
        /// </summary>
        /// <param name="iCityId"></param>
        /// <param name="iUnionId"></param>
        /// <param name="sUnionName"></param>
        /// <returns></returns>
        public static bool ChangeCityUnionId(int iCityId, int iUnionId, string sUnionName)
        {
            if (null == TerrainGroundCoordinate.m_Intantance)
            {
                return false;
            }
            return TerrainGroundCoordinate.m_Intantance.SetCityUnionId(iCityId, iUnionId, sUnionName);
        }

        /// <summary>
        /// 改变城市所属的联盟Id
        /// 并且假定这个Id对应的名字是曾经传给过csharp的
        /// </summary>
        /// <param name="iCityId"></param>
        /// <param name="iUnionId"></param>
        /// <returns></returns>
        public static bool ChangeCityUnionId(int iCityId, int iUnionId)
        {
            if (null == TerrainGroundCoordinate.m_Intantance)
            {
                return false;
            }
            return TerrainGroundCoordinate.m_Intantance.SetCityUnionId(iCityId, iUnionId);
        }

        /// <summary>
        /// 更新玩家等级
        /// </summary>
        /// <param name="iCityId"></param>
        /// <param name="iPlayerLevel"></param>
        /// <returns></returns>
        public static bool ChangeCityPlayerLevel(int iCityId, int iPlayerLevel)
        {
            if (null == TerrainGroundCoordinate.m_Intantance)
            {
                return false;
            }
            return TerrainGroundCoordinate.m_Intantance.SetCityPlayerLevel(iCityId, iPlayerLevel);
        }

        /// <summary>
        /// 更新玩家名字
        /// </summary>
        /// <param name="iCityId"></param>
        /// <param name="sPlayerName"></param>
        /// <returns></returns>
        public static bool ChangeCityPlayerName(int iCityId, string sPlayerName)
        {
            if (null == TerrainGroundCoordinate.m_Intantance)
            {
                return false;
            }
            return TerrainGroundCoordinate.m_Intantance.SetCityPlayerName(iCityId, sPlayerName);
        }

        /// <summary>
        /// 更新插的白旗
        /// </summary>
        /// <param name="iCityId"></param>
        /// <param name="sFlagGuildFlagName"></param>
        /// <returns></returns>
        public static bool ChangeCityWhiteFlag(int iCityId, string sFlagGuildFlagName)
        {
            if (null == TerrainGroundCoordinate.m_Intantance)
            {
                return false;
            }
            return TerrainGroundCoordinate.m_Intantance.SetCityWhiteFlag(iCityId, sFlagGuildFlagName);
        }

        /// <summary>
        /// 改变城市位置（需要多测测）
        /// </summary>
        /// <param name="iCityId"></param>
        /// <param name="iNewPosX"></param>
        /// <param name="iNewPosY"></param>
        /// <returns></returns>
        public static bool ChangeCityPosition(int iCityId, int iNewPosX, int iNewPosY)
        {
            if (null == TerrainGroundCoordinate.m_Intantance)
            {
                return false;
            }
            return TerrainGroundCoordinate.m_Intantance.ChangeCityPosition(iCityId, iNewPosX, iNewPosY);
        }

        #endregion

        #region 改变资源点模型级别

        /// <summary>
        /// 干掉资源点
        /// </summary>
        /// <param name="iResourceId"></param>
        /// <returns></returns>
        public static bool RemoveResource(int iResourceId)
        {
            if (null == TerrainGroundCoordinate.m_Intantance)
            {
                return false;
            }
            return TerrainGroundCoordinate.m_Intantance.RemoveResource(iResourceId);
        }

        /// <summary>
        /// 改变城市模型级别, iNewGrade = 1-3
        /// </summary>
        /// <param name="iResourceId"></param>
        /// <param name="iNewGrade"></param>
        /// <returns></returns>
        public static bool SetResourceModelGrade(int iResourceId, int iNewGrade)
        {
            if (null == TerrainGroundCoordinate.m_Intantance)
            {
                return false;
            }
            return TerrainGroundCoordinate.m_Intantance.ChangeResourceModelGrade(iResourceId, iNewGrade);
        }

        #endregion

        #region 显示区域与冲突

        /// <summary>
        /// 不显示所有区域
        /// </summary>
        /// <returns></returns>
        public static bool UnSelectAll()
        {
            if (null == TerrainGroundCoordinate.m_Intantance)
            {
                return false;
            }
            TerrainGroundCoordinate.m_Intantance.UnSelectAll();
            return true;
        }

        /// <summary>
        /// 设置默认的选择半径（球面上的）
        /// </summary>
        /// <param name="fRadius"></param>
        /// <returns></returns>
        public static bool SetDefaultRadius(float fRadius)
        {
            if (null != TerrainGroundCoordinate.m_Intantance)
            {
                TerrainGroundCoordinate.m_Intantance.SetSelectCitiesDefaultRadius(fRadius);
            }
            return false;
        }

        /// <summary>
        /// 选择城市，以及默认半径的周围城市
        /// </summary>
        /// <param name="iCityId"></param>
        /// <returns>被选中的城市数量</returns>
        public static int SelectCityAndNearBy(int iCityId)
        {
            if (null != TerrainGroundCoordinate.m_Intantance)
            {
                GroundItemInfo item = TerrainGroundCoordinate.m_Intantance.GetSelectableById(iCityId);
                if (null != item)
                {
                    return TerrainGroundCoordinate.m_Intantance.SelectCitiesAtOddQWithDefaultRadius(item.m_iOddQX, item.m_iOddQY);
                }

            }
            return 0;
        }

        public static int SelectCityAndNearByWithRadius(int iCityId, float fRadius)
        {
            if (null != TerrainGroundCoordinate.m_Intantance)
            {
                GroundItemInfo item = TerrainGroundCoordinate.m_Intantance.GetSelectableById(iCityId);
                if (null != item)
                {
                    return TerrainGroundCoordinate.m_Intantance.SelectCitiesAtOddQWithRadius(item.m_iOddQX, item.m_iOddQY, fRadius);
                }

            }
            return 0;
        }

        /// <summary>
        /// 根据OddQ坐标来选择城市
        /// </summary>
        /// <param name="iOddQX"></param>
        /// <param name="iOddQY"></param>
        /// <returns></returns>
        public static int SelectCityAndNearByOddQ(int iOddQX, int iOddQY)
        {
            if (null != TerrainGroundCoordinate.m_Intantance)
            {
                Debug.Log("SelectCityAndNearByOddQ: x=" + iOddQX + " y=" + iOddQY);
                return TerrainGroundCoordinate.m_Intantance.SelectCitiesAtOddQWithDefaultRadius(iOddQX, iOddQY);
            }
            return 0;
        }

        public static int SelectCityAndNearByOddQWithRadius(int iOddQX, int iOddQY, float fRadius)
        {
            if (null != TerrainGroundCoordinate.m_Intantance)
            {
                return TerrainGroundCoordinate.m_Intantance.SelectCitiesAtOddQWithRadius(iOddQX, iOddQY, fRadius);

            }
            return 0;
        }

        /// <summary>
        /// 摄像机目前看向的位置UV
        /// </summary>
        /// <returns></returns>
        public static Vector2 GetCameraPointToUV()
        {
            if (null != TerrainGroundCoordinate.m_Intantance)
            {
                return TerrainGroundCoordinate.m_Intantance.CameraPointTo();

            }
            return Vector2.zero;
        }

        /// <summary>
        /// 摄像机目前看向的位置OddQ
        /// </summary>
        /// <returns></returns>
        public static int[] GetCameraPointToOddQ()
        {
            if (null != TerrainGroundCoordinate.m_Intantance)
            {
                Vector2 uv = TerrainGroundCoordinate.m_Intantance.CameraPointTo();
                return GetOddQByUV(uv);

            }
            return GetOddQByUV(Vector2.zero);
        }

        /// <summary>
        /// 以摄像机看向的位置为中心，以默认半径，显示城市区域
        /// </summary>
        /// <returns>被显示的个数</returns>
        public static int SelectCityAndNearByCamera()
        {
            if (null != TerrainGroundCoordinate.m_Intantance)
            {
                Vector2 vUV = TerrainGroundCoordinate.m_Intantance.CameraPointTo();
                int iX, iY;
                TerrainGroundCoordinate.m_Intantance.UVToNearestOddQ(vUV, out iX, out iY);
                return TerrainGroundCoordinate.m_Intantance.SelectCitiesAtOddQWithDefaultRadius(iX, iY);
            }
            return 0;
        }

        /// <summary>
        /// 以摄像机看向的位置为中心，以给定半径，显示城市区域
        /// </summary>
        /// <returns>被显示的个数</returns>
        public static int SelectCityAndNearByCameraWithRadius(float fRadius)
        {
            if (null != TerrainGroundCoordinate.m_Intantance)
            {
                Vector2 vUV = TerrainGroundCoordinate.m_Intantance.CameraPointTo();
                int iX, iY;
                TerrainGroundCoordinate.m_Intantance.UVToNearestOddQ(vUV, out iX, out iY);
                return TerrainGroundCoordinate.m_Intantance.SelectCitiesAtOddQWithRadius(iX, iY, fRadius);
            }
            return 0;
        }

        /// <summary>
        /// 打开"显示区域"模式，会一直根据摄像机中心显示默认半径城市的区域
        /// </summary>
        /// <param name="bOn"></param>
        /// <returns></returns>
        public static bool TurnCameraSelectMode(bool bOn)
        {
            Debug.Log("TurnCameraSelectMode:" + bOn);
            if (null != TerrainGroundCoordinate.m_Intantance)
            {
                TerrainGroundCoordinate.m_Intantance.TurnSelectCitiesArroundCamera(bOn);
                return true;
            }
            return false;
        }

        /// <summary>
        /// "显示区域模式"是否被打开
        /// </summary>
        /// <returns></returns>
        public static bool IsCameraSelectModeOn()
        {
            if (null != TerrainGroundCoordinate.m_Intantance)
            {
                return TerrainGroundCoordinate.m_Intantance.IsSelectCitiesArroundCameraOn();
            }
            return false;
        }

        #endregion

        #region 画线

        [Obsolete("Use ShowLine with color instead")]
        public static int ShowLine(Vector2 vPosFromUV, Vector2 vPosToUV)
        {
            if (null == TerrainGroundCoordinate.m_Intantance)
            {
                return -1;
            }
            return TerrainGroundCoordinate.m_Intantance.ShowLine(vPosFromUV, vPosToUV, 0.2f, Color.yellow);
        }

        /// <summary>
        /// 画一条线
        /// </summary>
        /// <param name="vPosFromUV"></param>
        /// <param name="vPosToUV"></param>
        /// <param name="c"></param>
        /// <returns></returns>
        public static int ShowLine(Vector2 vPosFromUV, Vector2 vPosToUV, Color c)
        {
            if (null == TerrainGroundCoordinate.m_Intantance)
            {
                return -1;
            }
            return TerrainGroundCoordinate.m_Intantance.ShowLine(vPosFromUV, vPosToUV, 0.2f, c);
        }

        public static int ShowLine(int iFromOddQX, int iFromOddQY, int iToOddQX, int iToOddQY, Color c)
        {
            if (null == TerrainGroundCoordinate.m_Intantance)
            {
                return -1;
            }
            Vector2 vPosFromUV = GetUVByOddQ(iFromOddQX, iFromOddQY);
            Vector2 vPosToUV = GetUVByOddQ(iToOddQX, iToOddQY);
            return TerrainGroundCoordinate.m_Intantance.ShowLine(vPosFromUV, vPosToUV, 0.2f, c);
        }

        public static bool HideLine(int iId)
        {
            if (null == TerrainGroundCoordinate.m_Intantance)
            {
                return false;
            }
            return TerrainGroundCoordinate.m_Intantance.HideLine(iId);
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="vPosFromUV"></param>
        /// <param name="vPosToUV"></param>
        /// <returns>返回的列表长度是根据模型的vertex count来的。比如跨度为15个顶点，返回列表为30，其中前15个是位置，后15个是法线</returns>
        public static Vector3[] SamplePosition(Vector2 vPosFromUV, Vector2 vPosToUV)
        {
            if (null == TerrainGroundCoordinate.m_Intantance)
            {
                return null;
            }
            return TerrainGroundCoordinate.m_Intantance.SamplePosition(vPosFromUV, vPosToUV, 0.2f);
        }

        public static XLua.LuaTable SamplePosition(int iFromOddQX, int iFromOddQY, int iToOddQX, int iToOddQY)
        {
            if (null == TerrainGroundCoordinate.m_Intantance)
            {
                return null;
            }
            Vector2 vPosFromUV = GetUVByOddQ(iFromOddQX, iFromOddQY);
            Vector2 vPosToUV = GetUVByOddQ(iToOddQX, iToOddQY);
            Vector3[] allPoints = TerrainGroundCoordinate.m_Intantance.SamplePosition(vPosFromUV, vPosToUV, 0.2f);
            XLua.LuaTable luaTable = LuaManager.Instance.LuaVM.NewTable();
            for (int i = 0; i < allPoints.Length / 2; i++)
            {
                XLua.LuaTable temp = LuaManager.Instance.LuaVM.NewTable();
                temp.Set<string, float>("x", allPoints[i].x);
                temp.Set<string, float>("y", allPoints[i].y);
                temp.Set<string, float>("z", allPoints[i].z);
                luaTable.Set<int, XLua.LuaTable>(i + 1, temp);
            }
            return luaTable;
        }

        #endregion

        #region 摄像机运动

        /// <summary>
        /// 摄像机移动到位置
        /// </summary>
        /// <param name="vUV"></param>
        /// <param name="sCBFunction">回调函数，为空则无回调</param>
        /// <param name="sCBKeyword">回调关键字，将会传回给lua，可以为空</param>
        /// <param name="fTime">移动间隔</param>
        /// <returns></returns>
        public static bool CameraMoveTo(Vector2 vUV, string sCBFunction, string sCBKeyword, float fTime)
        {
            if (null == TerrainGroundCoordinate.m_Intantance)
            {
                return false;
            }
            TerrainGroundCoordinate.m_Intantance.MoveCameraTo(vUV, CameraMoveCallback, sCBFunction, sCBKeyword, fTime);
            return true;
        }

        public static bool CameraMoveToOddQ(int iOddQX, int iOddQY, string sCBFunction, string sCBKeyword, float fTime)
        {
            if (null == TerrainGroundCoordinate.m_Intantance)
            {
                return false;
            }
            Vector2 vUV = GetUVByOddQ(iOddQX, iOddQY);
            TerrainGroundCoordinate.m_Intantance.MoveCameraTo(vUV, CameraMoveCallback, sCBFunction, sCBKeyword, fTime);
            return true;
        }

        public static bool CameraMoveToCity(int iCityId, string sCBFunction, string sCBKeyword, float fTime)
        {
            if (null == TerrainGroundCoordinate.m_Intantance)
            {
                return false;
            }
            GroundItemInfo gi = GetCityInfoById(iCityId);
            if (null == gi)
            {
                return false;
            }
            return CameraMoveToOddQ(gi.m_iOddQX, gi.m_iOddQY, sCBFunction, sCBKeyword, fTime);
        }

        public static bool CameraMoveToResource(int iTreeId, string sCBFunction, string sCBKeyword, float fTime)
        {
            if (null == TerrainGroundCoordinate.m_Intantance)
            {
                return false;
            }
            GroundItemInfo gi = GetGroundInfoPosById(iTreeId);
            if (null == gi)
            {
                return false;
            }
            return CameraMoveToOddQ(gi.m_iOddQX, gi.m_iOddQY, sCBFunction, sCBKeyword, fTime);
        }

        #endregion

        #endregion

        #region 迁城模式

        /// <summary>
        /// 设置城市被拖到屏幕边缘的滚动的参数
        /// vP1.x,y,z,w分别是屏幕左，右，下，上，开始滚动的数值。
        /// 目前分别是0.15,0.85,0.15,0.85。 应该根据UI遮挡来设置。
        /// vP2.x.y.z分别是最大滚动速度，开始滚动加速度，停止滚动摩擦力。
        /// 目前为0.1，0.1,0.15
        /// </summary>
        /// <param name="vP1"></param>
        /// <param name="vP2"></param>
        /// <returns></returns>
        public static bool SetMoveCityModeCameraScrollParam(Vector4 vP1, Vector3 vP2)
        {
            if (null == TerrainGroundCoordinate.m_Intantance)
            {
                return false;
            }
            TerrainGroundCoordinate.m_Intantance.SetScrollParam(vP1, vP2);
            return true;
        }

        private static string m_sMoveCityCBFunction = "";

        /// <summary>
        /// 设置迁城拖动城市的回调函数，见
        /// OnMoveCityTo
        /// </summary>
        /// <param name="sFunction"></param>
        public static void SetMoveCityCallbackFunction(string sFunction)
        {
            m_sMoveCityCBFunction = sFunction;
        }

        /// <summary>
        /// 设置默认的，迁城模式下显示的格子的半径（不能全地图显示，否则太卡）
        /// </summary>
        /// <param name="iRadius"></param>
        /// <returns></returns>
        [Obsolete("现在根据城市区域来显示")]
        public static bool SetMoveCityGridShowDefauldRadius(int iRadius)
        {
            if (null == TerrainGroundCoordinate.m_Intantance)
            {
                return false;
            }
            TerrainGroundCoordinate.m_Intantance.SetMoveCityShowRadius(iRadius);
            return true;
        }

        /// <summary>
        /// 设置默认的，迁城模式下阻碍迁城的城市的半径，目前按照策划案是5
        /// </summary>
        /// <param name="iRadius"></param>
        /// <returns></returns>
        public static bool SetMoveCityOccupyRadius(int iRadius)
        {
            if (null == TerrainGroundCoordinate.m_Intantance)
            {
                return false;
            }
            TerrainGroundCoordinate.m_Intantance.SetMoveCityOccupyRadius(iRadius);
            return true;
        }

        /// <summary>
        /// 进入迁城模式
        /// </summary>
        /// <param name="fCameraSlerp">摄像机移动到玩家主城的时间</param>
        /// <returns>如果没有设置过玩家的主城，或者正在迁城模式中，也会返回false</returns>
        public static bool EnterMoveCityMode(float fCameraSlerp)
        {
            if (null == TerrainGroundCoordinate.m_Intantance)
            {
                return false;
            }
            return TerrainGroundCoordinate.m_Intantance.EnterMoveMainCityMode(fCameraSlerp);
        }

        public static bool EnterMoveMainCityModeWithOddQ(float fCameraSlerp, int iOddQX, int iOddQY, int iCityLevel, int iModelIndex, string sGuildFlagName, string sPlayerName)
        {
            if (null == TerrainGroundCoordinate.m_Intantance)
            {
                return false;
            }
            return TerrainGroundCoordinate.m_Intantance.EnterMoveMainCityMode(fCameraSlerp, iOddQX, iOddQY, iCityLevel, iModelIndex, sGuildFlagName, sPlayerName, EMoveBuidingType.MoveMainCity);
        }

        /// <summary>
        /// 离开迁城模式。不会做任何真正的“迁城”
        /// 如果不在迁城模式里，返回false
        /// 这时，玩家的主城在最后一次调用OnMoveCityTo的位置
        /// </summary>
        /// <returns></returns>
        public static bool LeaveMoveCityMode()
        {
            if (null == TerrainGroundCoordinate.m_Intantance)
            {
                return false;
            }
            return TerrainGroundCoordinate.m_Intantance.LeaveMoveMainCityMode();
        }

        /// <summary>
        /// 进入迁行营模式。
        /// </summary>
        /// <returns></returns>
        public static bool EnterMoveCampsiteModeWithOddQ(float fCameraSlerp, int iOddQX, int iOddQY, int iCampLevel, int iCampModelIndex, string sGuildFlagName, string sPlayerName)
        {
            if (null == TerrainGroundCoordinate.m_Intantance)
            {
                return false;
            }
            return TerrainGroundCoordinate.m_Intantance.EnterMoveMainCityMode(fCameraSlerp, iOddQX, iOddQY, iCampLevel, iCampModelIndex, sGuildFlagName, sPlayerName, EMoveBuidingType.MoveCampsite);
        }

        #endregion

        #region 颜色

        #region 迁城模式

        /// <summary>
        /// 迁城模式下的颜色设定
        /// SetCanputCityColor, SetCannotputCityColor 迁城模式下的假城呼吸的颜色
        /// SetCanputGridColor, SetCannotputGridColor 迁城模式下的格子的
        /// </summary>
        /// <param name="c"></param>
        /// <returns></returns>
        public static bool SetCanputCityColor(Color c)
        {
            if (null == TerrainGroundCoordinate.m_Intantance)
            {
                return false;
            }
            TerrainGroundCoordinate.m_Intantance.m_cCanPutCityGI = c;
            return true;
        }

        public static bool SetCannotputCityColor(Color c)
        {
            if (null == TerrainGroundCoordinate.m_Intantance)
            {
                return false;
            }
            TerrainGroundCoordinate.m_Intantance.m_cCanNotPutCityGI = c;
            return true;
        }

        public static bool SetCanputGridColor(Color c)
        {
            if (null == TerrainGroundCoordinate.m_Intantance)
            {
                return false;
            }
            TerrainGroundCoordinate.m_Intantance.m_cCanPutCity = c;
            return true;
        }

        public static bool SetCannotputGridColor(Color c)
        {
            if (null == TerrainGroundCoordinate.m_Intantance)
            {
                return false;
            }
            TerrainGroundCoordinate.m_Intantance.m_cCanNotPutCity = c;
            return true;
        }

        #endregion

        #region 边界

        /// <summary>
        /// 边界颜色确定：
        /// 1. 如果是玩家主城，使用SetSelfEdgeColor
        /// 2. 如果是玩家同盟（玩家union id不为空，且与这个城市union id相同，使用SetFriendEdgeColor
        /// 3. 如果是没加入Union，使用SetNoUnionEdgeColor的颜色
        /// 4. 以上皆不是，看看是否有SetUnionColor。如果有，使用这个union id对应的颜色
        /// 5. 以上皆没有，使用SetEnemyEdgeColor
        /// </summary>
        /// <param name="c"></param>
        /// <returns></returns>
        public static bool SetSelfEdgeColor(Color c)
        {
            if (null == TerrainGroundCoordinate.m_Intantance)
            {
                return false;
            }
            TerrainGroundCoordinate.m_Intantance.m_cPlayerCityProjector = c;
            return true;
        }

        public static bool SetFriendEdgeColor(Color c)
        {
            if (null == TerrainGroundCoordinate.m_Intantance)
            {
                return false;
            }
            TerrainGroundCoordinate.m_Intantance.m_cPlayerUnionProjector = c;
            return true;
        }

        public static bool SetNoUnionEdgeColor(Color c)
        {
            if (null == TerrainGroundCoordinate.m_Intantance)
            {
                return false;
            }
            TerrainGroundCoordinate.m_Intantance.m_cNoUnionProjector = c;
            return true;
        }

        public static bool SetEnemyEdgeColor(Color c)
        {
            if (null == TerrainGroundCoordinate.m_Intantance)
            {
                return false;
            }
            TerrainGroundCoordinate.m_Intantance.m_cEnemyUnionProjector = c;
            return true;
        }

        public static bool SetUnionColor(int iUnionId, Color c)
        {
            if (null == TerrainGroundCoordinate.m_Intantance)
            {
                return false;
            }

            if (iUnionId <= 0)
            {
                Debug.Log("SetUnionColor with empty union id: " + iUnionId);
                return false;
            }

            TerrainGroundCoordinate.m_Intantance.m_dicUnionColor[iUnionId] = c;
            return true;
        }

        #endregion

        #endregion

        #region Event

        private static string m_sCallBackFunction = "";

        /// <summary>
        /// 点击地面的时候的回调
        /// 主要还是恶心的鼠标操作如果放到CSharp，直接通过mouseposition看是否选中，会有操作上的冲突（移动摄像机）
        /// 注意如果LeaveBigMap了，是不会收到事件的
        /// 见OnClickGround
        /// </summary>
        /// <param name="sFunctionName"></param>
        public static void SetClickGroundCallBack(string sFunctionName)
        {
            m_sCallBackFunction = sFunctionName;
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="vUV">精确地点击位置</param>
        /// <param name="iOddQX">距离点击位置最近的OddQ坐标</param>
        /// <param name="iOddQY"></param>
        /// <param name="gi">Ground Info的查找搬到TerrainGroundCoordinate里</param>
        public static void OnClickGround(Vector2 vUV, int iOddQX, int iOddQY, GroundItemInfo gi)
        {
            if (!string.IsNullOrEmpty(m_sCallBackFunction) && null != TerrainGroundCoordinate.m_Intantance)
            {
                Vector3[] vPosNormal = GetPosNormalByOddQ(iOddQX, iOddQY);
                LuaManager.Instance.CallFunction(m_sCallBackFunction, vUV, iOddQX, iOddQY, vPosNormal[0], vPosNormal[1], gi);
            }
        }

        private static void CameraMoveCallback(string sFunction, string sKeyword, bool bFinished)
        {
            if (!string.IsNullOrEmpty(sFunction))
            {
                LuaManager.Instance.CallFunction(sFunction, sKeyword, bFinished);
            }
        }

        /// <summary>
        /// 城市被拖到位置x,y
        /// 注意，当进入迁城模式的时候也会调用一次
        /// </summary>
        /// <param name="iOddQX"></param>
        /// <param name="iOddQY"></param>
        /// <param name="bCanPut"></param>
        private static void OnMoveCityTo(int iOddQX, int iOddQY, bool bCanPut)
        {
            if (!string.IsNullOrEmpty(m_sMoveCityCBFunction))
            {
                Vector3[] vPosNormal = GetPosNormalByOddQ(iOddQX, iOddQY);
                LuaManager.Instance.CallFunction(m_sMoveCityCBFunction, iOddQX, iOddQY, bCanPut, vPosNormal[0], vPosNormal[1]);
            }
        }

        private static string m_sCameraFaceToCBFunction = "";

        public static void SetOnCameraFaceToCallback(string camerafacetoCallback)
        {
            m_sCameraFaceToCBFunction = camerafacetoCallback;
        }

        private static void OnCameraFaceToChanged(int iOddQX, int iOddQY, float fDistance)
        {
            if (!string.IsNullOrEmpty(m_sCameraFaceToCBFunction))
            {
                LuaManager.Instance.CallFunction(m_sCameraFaceToCBFunction, iOddQX, iOddQY, fDistance);
            }
        }

        #endregion

        #region 地表格子

        /// <summary>
        /// 开启/关闭格子显示
        /// </summary>
        /// <param name="markType"></param>
        /// <returns></returns>
        public static bool EnableGridDisplay(bool value)
        {
            if (null == TerrainGroundGrid.Instance)
            {
                return false;
            }
            TerrainGroundGrid.Instance.EnableGridDisplay(value);
            return true;
        }
        /// <summary>
        /// 设置地表格子标记类型
        /// </summary>
        public static bool SetMarkType(TerrainGroundGrid.MarkType markType)
        {
            if (null == TerrainGroundGrid.Instance)
            {
                return false;
            }
            TerrainGroundGrid.Instance.SetMarkType(markType);
            return true;
        }
        /// <summary>
        /// 开启/关闭手动标记功能
        /// </summary>
        public static bool EnableManualMarking(bool value)
        {
            if (null == TerrainGroundGrid.Instance)
            {
                return false;
            }
            TerrainGroundGrid.Instance.EnableManualMarking(value);
            return true;
        }
        /// <summary>
        /// 开启/关闭标记笔刷
        /// </summary>
        public static bool EnableMarkDrawing(bool value)
        {
            if (null == TerrainGroundGrid.Instance)
            {
                return false;
            }
            TerrainGroundGrid.Instance.EnableMarkDrawing(value);
            return true;
        }
        /// <summary>
        /// 读取配置文件，加载格子属性
        /// </summary>
        /// <param name="mapId"></param>
        /// <returns></returns>
        public static bool ReadGridPropertyFromFile(int mapId)
        {
            if (null == TerrainGroundGrid.Instance)
            {
                return false;
            }
            TerrainGroundGrid.Instance.ReadFromFile(mapId);
            return true;
        }
        /// <summary>
        /// 保存配置文件，记录格子属性
        /// </summary>
        /// <param name="mapId"></param>
        /// <returns></returns>
        public static bool SaveGridPropertyToFile(int mapId)
        {
            if (null == TerrainGroundGrid.Instance)
            {
                return false;
            }
            return TerrainGroundGrid.Instance.SaveToFile(mapId);
        }
        /// <summary>
        /// 设置静态物体透明化，地图编辑器专用
        /// 退出场景后恢复原样
        /// </summary>
        /// <returns></returns>
        public static bool SetStaticItemAsTransparentItem()
        {
            if (null == TerrainGroundCoordinate.m_Intantance)
            {
                return false;
            }
            TerrainGroundCoordinate.m_Intantance.SetStaticItemAsTransparentItem();
            return true;
        }
        #endregion 地表格子
    }
}