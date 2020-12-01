#if USE_UNI_LUA
using LuaAPI = UniLua.Lua;
using RealStatePtr = UniLua.ILuaState;
using LuaCSFunction = UniLua.CSharpFunctionDelegate;
#else
using LuaAPI = XLua.LuaDLL.Lua;
using RealStatePtr = System.IntPtr;
using LuaCSFunction = XLua.LuaDLL.lua_CSFunction;
#endif

using XLua;
using System.Collections.Generic;


namespace XLua.CSObjectWrap
{
    using Utils = XLua.Utils;
    public class LPCFrameworkTerrainLuaDelegatesWrap
    {
        public static void __Register(RealStatePtr L)
        {
			ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			Utils.BeginObjectRegister(typeof(LPCFramework.TerrainLuaDelegates), L, translator, 0, 0, 0, 0);
			
			
			
			
			
			Utils.EndObjectRegister(typeof(LPCFramework.TerrainLuaDelegates), L, translator, null, null,
			    null, null, null);

		    Utils.BeginClassRegister(typeof(LPCFramework.TerrainLuaDelegates), L, __CreateInstance, 88, 0, 0);
			Utils.RegisterFunc(L, Utils.CLS_IDX, "SetBigMapCityInference", _m_SetBigMapCityInference_xlua_st_);
            Utils.RegisterFunc(L, Utils.CLS_IDX, "ResetGroundGridHeight", _m_ResetGroundGridHeight_xlua_st_);
            Utils.RegisterFunc(L, Utils.CLS_IDX, "GoBigMap", _m_GoBigMap_xlua_st_);
            Utils.RegisterFunc(L, Utils.CLS_IDX, "LeaveBigMap", _m_LeaveBigMap_xlua_st_);
            Utils.RegisterFunc(L, Utils.CLS_IDX, "SetCameraParameters", _m_SetCameraParameters_xlua_st_);
            Utils.RegisterFunc(L, Utils.CLS_IDX, "SetTerrainParam", _m_SetTerrainParam_xlua_st_);
            Utils.RegisterFunc(L, Utils.CLS_IDX, "GetGridHeight", _m_GetGridHeight_xlua_st_);
            Utils.RegisterFunc(L, Utils.CLS_IDX, "GetGridWidth", _m_GetGridWidth_xlua_st_);
            Utils.RegisterFunc(L, Utils.CLS_IDX, "GetMapSize", _m_GetMapSize_xlua_st_);
            Utils.RegisterFunc(L, Utils.CLS_IDX, "GetMapCurveRadius", _m_GetMapCurveRadius_xlua_st_);
            Utils.RegisterFunc(L, Utils.CLS_IDX, "GetMapCurveDegree", _m_GetMapCurveDegree_xlua_st_);
            Utils.RegisterFunc(L, Utils.CLS_IDX, "GetOneGridHeight", _m_GetOneGridHeight_xlua_st_);
            Utils.RegisterFunc(L, Utils.CLS_IDX, "GetOneGridEdgeWidth", _m_GetOneGridEdgeWidth_xlua_st_);
            Utils.RegisterFunc(L, Utils.CLS_IDX, "GetOddQByPos", _m_GetOddQByPos_xlua_st_);
            Utils.RegisterFunc(L, Utils.CLS_IDX, "GetOddQByUV", _m_GetOddQByUV_xlua_st_);
            Utils.RegisterFunc(L, Utils.CLS_IDX, "GetPosNormalByOddQ", _m_GetPosNormalByOddQ_xlua_st_);
            Utils.RegisterFunc(L, Utils.CLS_IDX, "GetPosNormalByUV", _m_GetPosNormalByUV_xlua_st_);
            Utils.RegisterFunc(L, Utils.CLS_IDX, "GetUVByOddQ", _m_GetUVByOddQ_xlua_st_);
            Utils.RegisterFunc(L, Utils.CLS_IDX, "GetUVByPos", _m_GetUVByPos_xlua_st_);
            Utils.RegisterFunc(L, Utils.CLS_IDX, "ScreenPosToUV", _m_ScreenPosToUV_xlua_st_);
            Utils.RegisterFunc(L, Utils.CLS_IDX, "ScreenPosOddQ", _m_ScreenPosOddQ_xlua_st_);
            Utils.RegisterFunc(L, Utils.CLS_IDX, "CanSpawnGroundItem", _m_CanSpawnGroundItem_xlua_st_);
            Utils.RegisterFunc(L, Utils.CLS_IDX, "SpawnGroundCity", _m_SpawnGroundCity_xlua_st_);
            Utils.RegisterFunc(L, Utils.CLS_IDX, "SpawnGroundCityRandomPos", _m_SpawnGroundCityRandomPos_xlua_st_);
            Utils.RegisterFunc(L, Utils.CLS_IDX, "SpawnGroundItem", _m_SpawnGroundItem_xlua_st_);
            Utils.RegisterFunc(L, Utils.CLS_IDX, "SpawnGroundItemRandomPos", _m_SpawnGroundItemRandomPos_xlua_st_);
            Utils.RegisterFunc(L, Utils.CLS_IDX, "GetCityInfoById", _m_GetCityInfoById_xlua_st_);
            Utils.RegisterFunc(L, Utils.CLS_IDX, "GetGroundInfoPosById", _m_GetGroundInfoPosById_xlua_st_);
            Utils.RegisterFunc(L, Utils.CLS_IDX, "GetCityInfoByOddQPos", _m_GetCityInfoByOddQPos_xlua_st_);
            Utils.RegisterFunc(L, Utils.CLS_IDX, "GetGroundInfoOddQPos", _m_GetGroundInfoOddQPos_xlua_st_);
            Utils.RegisterFunc(L, Utils.CLS_IDX, "RemoveCity", _m_RemoveCity_xlua_st_);
            Utils.RegisterFunc(L, Utils.CLS_IDX, "UpdateCityInfo", _m_UpdateCityInfo_xlua_st_);
            Utils.RegisterFunc(L, Utils.CLS_IDX, "UpdateCityGradeAndModelGrade", _m_UpdateCityGradeAndModelGrade_xlua_st_);
            Utils.RegisterFunc(L, Utils.CLS_IDX, "ChangeCityGrade", _m_ChangeCityGrade_xlua_st_);
            Utils.RegisterFunc(L, Utils.CLS_IDX, "ChangeCityModelGrade", _m_ChangeCityModelGrade_xlua_st_);
            Utils.RegisterFunc(L, Utils.CLS_IDX, "ChangeCityUnionId", _m_ChangeCityUnionId_xlua_st_);
            Utils.RegisterFunc(L, Utils.CLS_IDX, "ChangeCityPlayerLevel", _m_ChangeCityPlayerLevel_xlua_st_);
            Utils.RegisterFunc(L, Utils.CLS_IDX, "ChangeCityPlayerName", _m_ChangeCityPlayerName_xlua_st_);
            Utils.RegisterFunc(L, Utils.CLS_IDX, "ChangeCityWhiteFlag", _m_ChangeCityWhiteFlag_xlua_st_);
            Utils.RegisterFunc(L, Utils.CLS_IDX, "ChangeCityPosition", _m_ChangeCityPosition_xlua_st_);
            Utils.RegisterFunc(L, Utils.CLS_IDX, "RemoveResource", _m_RemoveResource_xlua_st_);
            Utils.RegisterFunc(L, Utils.CLS_IDX, "SetResourceModelGrade", _m_SetResourceModelGrade_xlua_st_);
            Utils.RegisterFunc(L, Utils.CLS_IDX, "UnSelectAll", _m_UnSelectAll_xlua_st_);
            Utils.RegisterFunc(L, Utils.CLS_IDX, "SetDefaultRadius", _m_SetDefaultRadius_xlua_st_);
            Utils.RegisterFunc(L, Utils.CLS_IDX, "SelectCityAndNearBy", _m_SelectCityAndNearBy_xlua_st_);
            Utils.RegisterFunc(L, Utils.CLS_IDX, "SelectCityAndNearByWithRadius", _m_SelectCityAndNearByWithRadius_xlua_st_);
            Utils.RegisterFunc(L, Utils.CLS_IDX, "SelectCityAndNearByOddQ", _m_SelectCityAndNearByOddQ_xlua_st_);
            Utils.RegisterFunc(L, Utils.CLS_IDX, "SelectCityAndNearByOddQWithRadius", _m_SelectCityAndNearByOddQWithRadius_xlua_st_);
            Utils.RegisterFunc(L, Utils.CLS_IDX, "GetCameraPointToUV", _m_GetCameraPointToUV_xlua_st_);
            Utils.RegisterFunc(L, Utils.CLS_IDX, "GetCameraPointToOddQ", _m_GetCameraPointToOddQ_xlua_st_);
            Utils.RegisterFunc(L, Utils.CLS_IDX, "SelectCityAndNearByCamera", _m_SelectCityAndNearByCamera_xlua_st_);
            Utils.RegisterFunc(L, Utils.CLS_IDX, "SelectCityAndNearByCameraWithRadius", _m_SelectCityAndNearByCameraWithRadius_xlua_st_);
            Utils.RegisterFunc(L, Utils.CLS_IDX, "TurnCameraSelectMode", _m_TurnCameraSelectMode_xlua_st_);
            Utils.RegisterFunc(L, Utils.CLS_IDX, "IsCameraSelectModeOn", _m_IsCameraSelectModeOn_xlua_st_);
            Utils.RegisterFunc(L, Utils.CLS_IDX, "ShowLine", _m_ShowLine_xlua_st_);
            Utils.RegisterFunc(L, Utils.CLS_IDX, "HideLine", _m_HideLine_xlua_st_);
            Utils.RegisterFunc(L, Utils.CLS_IDX, "SamplePosition", _m_SamplePosition_xlua_st_);
            Utils.RegisterFunc(L, Utils.CLS_IDX, "CameraMoveTo", _m_CameraMoveTo_xlua_st_);
            Utils.RegisterFunc(L, Utils.CLS_IDX, "CameraMoveToOddQ", _m_CameraMoveToOddQ_xlua_st_);
            Utils.RegisterFunc(L, Utils.CLS_IDX, "CameraMoveToCity", _m_CameraMoveToCity_xlua_st_);
            Utils.RegisterFunc(L, Utils.CLS_IDX, "CameraMoveToResource", _m_CameraMoveToResource_xlua_st_);
            Utils.RegisterFunc(L, Utils.CLS_IDX, "SetMoveCityModeCameraScrollParam", _m_SetMoveCityModeCameraScrollParam_xlua_st_);
            Utils.RegisterFunc(L, Utils.CLS_IDX, "SetMoveCityCallbackFunction", _m_SetMoveCityCallbackFunction_xlua_st_);
            Utils.RegisterFunc(L, Utils.CLS_IDX, "SetMoveCityOccupyRadius", _m_SetMoveCityOccupyRadius_xlua_st_);
            Utils.RegisterFunc(L, Utils.CLS_IDX, "EnterMoveCityMode", _m_EnterMoveCityMode_xlua_st_);
            Utils.RegisterFunc(L, Utils.CLS_IDX, "EnterMoveMainCityModeWithOddQ", _m_EnterMoveMainCityModeWithOddQ_xlua_st_);
            Utils.RegisterFunc(L, Utils.CLS_IDX, "LeaveMoveCityMode", _m_LeaveMoveCityMode_xlua_st_);
            Utils.RegisterFunc(L, Utils.CLS_IDX, "EnterMoveCampsiteModeWithOddQ", _m_EnterMoveCampsiteModeWithOddQ_xlua_st_);
            Utils.RegisterFunc(L, Utils.CLS_IDX, "SetCanputCityColor", _m_SetCanputCityColor_xlua_st_);
            Utils.RegisterFunc(L, Utils.CLS_IDX, "SetCannotputCityColor", _m_SetCannotputCityColor_xlua_st_);
            Utils.RegisterFunc(L, Utils.CLS_IDX, "SetCanputGridColor", _m_SetCanputGridColor_xlua_st_);
            Utils.RegisterFunc(L, Utils.CLS_IDX, "SetCannotputGridColor", _m_SetCannotputGridColor_xlua_st_);
            Utils.RegisterFunc(L, Utils.CLS_IDX, "SetSelfEdgeColor", _m_SetSelfEdgeColor_xlua_st_);
            Utils.RegisterFunc(L, Utils.CLS_IDX, "SetFriendEdgeColor", _m_SetFriendEdgeColor_xlua_st_);
            Utils.RegisterFunc(L, Utils.CLS_IDX, "SetNoUnionEdgeColor", _m_SetNoUnionEdgeColor_xlua_st_);
            Utils.RegisterFunc(L, Utils.CLS_IDX, "SetEnemyEdgeColor", _m_SetEnemyEdgeColor_xlua_st_);
            Utils.RegisterFunc(L, Utils.CLS_IDX, "SetUnionColor", _m_SetUnionColor_xlua_st_);
            Utils.RegisterFunc(L, Utils.CLS_IDX, "SetClickGroundCallBack", _m_SetClickGroundCallBack_xlua_st_);
            Utils.RegisterFunc(L, Utils.CLS_IDX, "OnClickGround", _m_OnClickGround_xlua_st_);
            Utils.RegisterFunc(L, Utils.CLS_IDX, "SetOnCameraFaceToCallback", _m_SetOnCameraFaceToCallback_xlua_st_);
            Utils.RegisterFunc(L, Utils.CLS_IDX, "EnableGridDisplay", _m_EnableGridDisplay_xlua_st_);
            Utils.RegisterFunc(L, Utils.CLS_IDX, "SetMarkType", _m_SetMarkType_xlua_st_);
            Utils.RegisterFunc(L, Utils.CLS_IDX, "EnableManualMarking", _m_EnableManualMarking_xlua_st_);
            Utils.RegisterFunc(L, Utils.CLS_IDX, "EnableMarkDrawing", _m_EnableMarkDrawing_xlua_st_);
            Utils.RegisterFunc(L, Utils.CLS_IDX, "ReadGridPropertyFromFile", _m_ReadGridPropertyFromFile_xlua_st_);
            Utils.RegisterFunc(L, Utils.CLS_IDX, "SaveGridPropertyToFile", _m_SaveGridPropertyToFile_xlua_st_);
            Utils.RegisterFunc(L, Utils.CLS_IDX, "SetStaticItemAsTransparentItem", _m_SetStaticItemAsTransparentItem_xlua_st_);
            
			
            
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "UnderlyingSystemType", typeof(LPCFramework.TerrainLuaDelegates));
			
			
			Utils.EndClassRegister(typeof(LPCFramework.TerrainLuaDelegates), L, translator);
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int __CreateInstance(RealStatePtr L)
        {
            
            ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			try {
				if(LuaAPI.lua_gettop(L) == 1)
				{
					
					LPCFramework.TerrainLuaDelegates __cl_gen_ret = new LPCFramework.TerrainLuaDelegates();
					translator.Push(L, __cl_gen_ret);
                    
					return 1;
				}
				
			}
			catch(System.Exception __gen_e) {
				return LuaAPI.luaL_error(L, "c# exception:" + __gen_e);
			}
            return LuaAPI.luaL_error(L, "invalid arguments to LPCFramework.TerrainLuaDelegates constructor!");
            
        }
        
		
        
		
        
        
        
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_SetBigMapCityInference_xlua_st_(RealStatePtr L)
        {
            
            ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
            
            try {
                
                {
                    int iCityGrade = LuaAPI.xlua_tointeger(L, 1);
                    byte[,] inf = (byte[,])translator.GetObject(L, 2, typeof(byte[,]));
                    
                    LPCFramework.TerrainLuaDelegates.SetBigMapCityInference( iCityGrade, inf );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception __gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + __gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_ResetGroundGridHeight_xlua_st_(RealStatePtr L)
        {
            
            
            
            try {
                
                {
                    int iGridHeight = LuaAPI.xlua_tointeger(L, 1);
                    
                        bool __cl_gen_ret = LPCFramework.TerrainLuaDelegates.ResetGroundGridHeight( iGridHeight );
                        LuaAPI.lua_pushboolean(L, __cl_gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception __gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + __gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_GoBigMap_xlua_st_(RealStatePtr L)
        {
            
            
            
            try {
                
                {
                    
                        bool __cl_gen_ret = LPCFramework.TerrainLuaDelegates.GoBigMap(  );
                        LuaAPI.lua_pushboolean(L, __cl_gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception __gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + __gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_LeaveBigMap_xlua_st_(RealStatePtr L)
        {
            
            
            
            try {
                
                {
                    
                        bool __cl_gen_ret = LPCFramework.TerrainLuaDelegates.LeaveBigMap(  );
                        LuaAPI.lua_pushboolean(L, __cl_gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception __gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + __gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_SetCameraParameters_xlua_st_(RealStatePtr L)
        {
            
            
            
            try {
                
                {
                    float fMotion = (float)LuaAPI.lua_tonumber(L, 1);
                    float fAcc = (float)LuaAPI.lua_tonumber(L, 2);
                    float fIsPressCheck = (float)LuaAPI.lua_tonumber(L, 3);
                    
                        bool __cl_gen_ret = LPCFramework.TerrainLuaDelegates.SetCameraParameters( fMotion, fAcc, fIsPressCheck );
                        LuaAPI.lua_pushboolean(L, __cl_gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception __gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + __gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_SetTerrainParam_xlua_st_(RealStatePtr L)
        {
            
            ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
            
            try {
                
                {
                    int maxTouchCount = LuaAPI.xlua_tointeger(L, 1);
                    int invalidTouchId = LuaAPI.xlua_tointeger(L, 2);
                    int mouseTouchId = LuaAPI.xlua_tointeger(L, 3);
                    float touchStay = (float)LuaAPI.lua_tonumber(L, 4);
                    float holdTimeCheck = (float)LuaAPI.lua_tonumber(L, 5);
                    float moveDistanceCheck = (float)LuaAPI.lua_tonumber(L, 6);
                    float cameraTouchMoveMinSpeed = (float)LuaAPI.lua_tonumber(L, 7);
                    float cameraTouchMoveMaxSpeed = (float)LuaAPI.lua_tonumber(L, 8);
                    int cameraTouchMoveDeltaSpeed = LuaAPI.xlua_tointeger(L, 9);
                    int linePoolMin = LuaAPI.xlua_tointeger(L, 10);
                    int linePoolMax = LuaAPI.xlua_tointeger(L, 11);
                    int maincityPoolMin = LuaAPI.xlua_tointeger(L, 12);
                    int maincityPoolMax = LuaAPI.xlua_tointeger(L, 13);
                    int goldminePoolMin = LuaAPI.xlua_tointeger(L, 14);
                    int goldminePoolMax = LuaAPI.xlua_tointeger(L, 15);
                    int croplandPoolMin = LuaAPI.xlua_tointeger(L, 16);
                    int croplandPoolMax = LuaAPI.xlua_tointeger(L, 17);
                    int sawmillPoolMin = LuaAPI.xlua_tointeger(L, 18);
                    int sawmillPoolMax = LuaAPI.xlua_tointeger(L, 19);
                    int stonepitPoolMin = LuaAPI.xlua_tointeger(L, 20);
                    int stonepitPoolMax = LuaAPI.xlua_tointeger(L, 21);
                    int campsitePoolMin = LuaAPI.xlua_tointeger(L, 22);
                    int campsitePoolMax = LuaAPI.xlua_tointeger(L, 23);
                    float slopeRatio1 = (float)LuaAPI.lua_tonumber(L, 24);
                    float slopeRatio2 = (float)LuaAPI.lua_tonumber(L, 25);
                    int cityModelMinIndex = LuaAPI.xlua_tointeger(L, 26);
                    int cityModelMaxIndex = LuaAPI.xlua_tointeger(L, 27);
                    UnityEngine.Color playerCityProjectorColor;translator.Get(L, 28, out playerCityProjectorColor);
                    UnityEngine.Color playerUnionProjectorColor;translator.Get(L, 29, out playerUnionProjectorColor);
                    UnityEngine.Color noUnionProjectorColor;translator.Get(L, 30, out noUnionProjectorColor);
                    UnityEngine.Color enemyUnionProjectorColor;translator.Get(L, 31, out enemyUnionProjectorColor);
                    UnityEngine.Color penetrationColor;translator.Get(L, 32, out penetrationColor);
                    UnityEngine.Color canPutCityColor;translator.Get(L, 33, out canPutCityColor);
                    UnityEngine.Color canNotPutCityColor;translator.Get(L, 34, out canNotPutCityColor);
                    UnityEngine.Color canPutCityGiColor;translator.Get(L, 35, out canPutCityGiColor);
                    UnityEngine.Color canNotPutCityGiColor;translator.Get(L, 36, out canNotPutCityGiColor);
                    UnityEngine.Vector4 putCityShaderParam;translator.Get(L, 37, out putCityShaderParam);
                    System.Collections.Generic.List<LPCFramework.TerrainLuaDelegates.BlockPointInfo> blockPointInfo = (System.Collections.Generic.List<LPCFramework.TerrainLuaDelegates.BlockPointInfo>)translator.GetObject(L, 38, typeof(System.Collections.Generic.List<LPCFramework.TerrainLuaDelegates.BlockPointInfo>));
                    
                        bool __cl_gen_ret = LPCFramework.TerrainLuaDelegates.SetTerrainParam( maxTouchCount, invalidTouchId, mouseTouchId, touchStay, holdTimeCheck, moveDistanceCheck, cameraTouchMoveMinSpeed, cameraTouchMoveMaxSpeed, cameraTouchMoveDeltaSpeed, linePoolMin, linePoolMax, maincityPoolMin, maincityPoolMax, goldminePoolMin, goldminePoolMax, croplandPoolMin, croplandPoolMax, sawmillPoolMin, sawmillPoolMax, stonepitPoolMin, stonepitPoolMax, campsitePoolMin, campsitePoolMax, slopeRatio1, slopeRatio2, cityModelMinIndex, cityModelMaxIndex, playerCityProjectorColor, playerUnionProjectorColor, noUnionProjectorColor, enemyUnionProjectorColor, penetrationColor, canPutCityColor, canNotPutCityColor, canPutCityGiColor, canNotPutCityGiColor, putCityShaderParam, blockPointInfo );
                        LuaAPI.lua_pushboolean(L, __cl_gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception __gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + __gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_GetGridHeight_xlua_st_(RealStatePtr L)
        {
            
            
            
            try {
                
                {
                    
                        int __cl_gen_ret = LPCFramework.TerrainLuaDelegates.GetGridHeight(  );
                        LuaAPI.xlua_pushinteger(L, __cl_gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception __gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + __gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_GetGridWidth_xlua_st_(RealStatePtr L)
        {
            
            
            
            try {
                
                {
                    
                        int __cl_gen_ret = LPCFramework.TerrainLuaDelegates.GetGridWidth(  );
                        LuaAPI.xlua_pushinteger(L, __cl_gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception __gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + __gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_GetMapSize_xlua_st_(RealStatePtr L)
        {
            
            
            
            try {
                
                {
                    
                        float __cl_gen_ret = LPCFramework.TerrainLuaDelegates.GetMapSize(  );
                        LuaAPI.lua_pushnumber(L, __cl_gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception __gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + __gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_GetMapCurveRadius_xlua_st_(RealStatePtr L)
        {
            
            
            
            try {
                
                {
                    
                        float __cl_gen_ret = LPCFramework.TerrainLuaDelegates.GetMapCurveRadius(  );
                        LuaAPI.lua_pushnumber(L, __cl_gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception __gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + __gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_GetMapCurveDegree_xlua_st_(RealStatePtr L)
        {
            
            
            
            try {
                
                {
                    
                        float __cl_gen_ret = LPCFramework.TerrainLuaDelegates.GetMapCurveDegree(  );
                        LuaAPI.lua_pushnumber(L, __cl_gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception __gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + __gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_GetOneGridHeight_xlua_st_(RealStatePtr L)
        {
            
            
            
            try {
                
                {
                    
                        float __cl_gen_ret = LPCFramework.TerrainLuaDelegates.GetOneGridHeight(  );
                        LuaAPI.lua_pushnumber(L, __cl_gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception __gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + __gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_GetOneGridEdgeWidth_xlua_st_(RealStatePtr L)
        {
            
            
            
            try {
                
                {
                    
                        float __cl_gen_ret = LPCFramework.TerrainLuaDelegates.GetOneGridEdgeWidth(  );
                        LuaAPI.lua_pushnumber(L, __cl_gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception __gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + __gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_GetOddQByPos_xlua_st_(RealStatePtr L)
        {
            
            ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
            
            try {
                
                {
                    UnityEngine.Vector3 vPos;translator.Get(L, 1, out vPos);
                    
                        int[] __cl_gen_ret = LPCFramework.TerrainLuaDelegates.GetOddQByPos( vPos );
                        translator.Push(L, __cl_gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception __gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + __gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_GetOddQByUV_xlua_st_(RealStatePtr L)
        {
            
            ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
            
            try {
                
                {
                    UnityEngine.Vector2 vUV;translator.Get(L, 1, out vUV);
                    
                        int[] __cl_gen_ret = LPCFramework.TerrainLuaDelegates.GetOddQByUV( vUV );
                        translator.Push(L, __cl_gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception __gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + __gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_GetPosNormalByOddQ_xlua_st_(RealStatePtr L)
        {
            
            ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
            
            try {
                
                {
                    int iX = LuaAPI.xlua_tointeger(L, 1);
                    int iY = LuaAPI.xlua_tointeger(L, 2);
                    
                        UnityEngine.Vector3[] __cl_gen_ret = LPCFramework.TerrainLuaDelegates.GetPosNormalByOddQ( iX, iY );
                        translator.Push(L, __cl_gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception __gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + __gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_GetPosNormalByUV_xlua_st_(RealStatePtr L)
        {
            
            ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
            
            try {
                
                {
                    UnityEngine.Vector2 vUV;translator.Get(L, 1, out vUV);
                    
                        UnityEngine.Vector3[] __cl_gen_ret = LPCFramework.TerrainLuaDelegates.GetPosNormalByUV( vUV );
                        translator.Push(L, __cl_gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception __gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + __gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_GetUVByOddQ_xlua_st_(RealStatePtr L)
        {
            
            ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
            
            try {
                
                {
                    int iX = LuaAPI.xlua_tointeger(L, 1);
                    int iY = LuaAPI.xlua_tointeger(L, 2);
                    
                        UnityEngine.Vector2 __cl_gen_ret = LPCFramework.TerrainLuaDelegates.GetUVByOddQ( iX, iY );
                        translator.PushUnityEngineVector2(L, __cl_gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception __gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + __gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_GetUVByPos_xlua_st_(RealStatePtr L)
        {
            
            ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
            
            try {
                
                {
                    UnityEngine.Vector3 vPos;translator.Get(L, 1, out vPos);
                    
                        UnityEngine.Vector2 __cl_gen_ret = LPCFramework.TerrainLuaDelegates.GetUVByPos( vPos );
                        translator.PushUnityEngineVector2(L, __cl_gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception __gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + __gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_ScreenPosToUV_xlua_st_(RealStatePtr L)
        {
            
            ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
            
            try {
                
                {
                    UnityEngine.Vector2 vScreen;translator.Get(L, 1, out vScreen);
                    
                        object[] __cl_gen_ret = LPCFramework.TerrainLuaDelegates.ScreenPosToUV( vScreen );
                        translator.Push(L, __cl_gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception __gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + __gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_ScreenPosOddQ_xlua_st_(RealStatePtr L)
        {
            
            ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
            
            try {
                
                {
                    UnityEngine.Vector2 vScreen;translator.Get(L, 1, out vScreen);
                    
                        object[] __cl_gen_ret = LPCFramework.TerrainLuaDelegates.ScreenPosOddQ( vScreen );
                        translator.Push(L, __cl_gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception __gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + __gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_CanSpawnGroundItem_xlua_st_(RealStatePtr L)
        {
            
            
            
            try {
                
                {
                    int iOddQX = LuaAPI.xlua_tointeger(L, 1);
                    int iOddQY = LuaAPI.xlua_tointeger(L, 2);
                    
                        bool __cl_gen_ret = LPCFramework.TerrainLuaDelegates.CanSpawnGroundItem( iOddQX, iOddQY );
                        LuaAPI.lua_pushboolean(L, __cl_gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception __gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + __gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_SpawnGroundCity_xlua_st_(RealStatePtr L)
        {
            
            
            
            try {
                
                {
                    string sInflenceId = LuaAPI.lua_tostring(L, 1);
                    string sPlayerName = LuaAPI.lua_tostring(L, 2);
                    int iPlayerLevel = LuaAPI.xlua_tointeger(L, 3);
                    int iOddQX = LuaAPI.xlua_tointeger(L, 4);
                    int iOddQY = LuaAPI.xlua_tointeger(L, 5);
                    int iCityGrade = LuaAPI.xlua_tointeger(L, 6);
                    int iModelIndex = LuaAPI.xlua_tointeger(L, 7);
                    int iUnionId = LuaAPI.xlua_tointeger(L, 8);
                    string sUnionName = LuaAPI.lua_tostring(L, 9);
                    string sFlagGuildFlagName = LuaAPI.lua_tostring(L, 10);
                    bool bIsPlayerMainCity = LuaAPI.lua_toboolean(L, 11);
                    int buildingType = LuaAPI.xlua_tointeger(L, 12);
                    
                        int __cl_gen_ret = LPCFramework.TerrainLuaDelegates.SpawnGroundCity( sInflenceId, sPlayerName, iPlayerLevel, iOddQX, iOddQY, iCityGrade, iModelIndex, iUnionId, sUnionName, sFlagGuildFlagName, bIsPlayerMainCity, buildingType );
                        LuaAPI.xlua_pushinteger(L, __cl_gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception __gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + __gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_SpawnGroundCityRandomPos_xlua_st_(RealStatePtr L)
        {
            
            
            
            try {
                
                {
                    string sInflenceId = LuaAPI.lua_tostring(L, 1);
                    
                        int __cl_gen_ret = LPCFramework.TerrainLuaDelegates.SpawnGroundCityRandomPos( sInflenceId );
                        LuaAPI.xlua_pushinteger(L, __cl_gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception __gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + __gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_SpawnGroundItem_xlua_st_(RealStatePtr L)
        {
            
            
            
            try {
                
                {
                    int iId = LuaAPI.xlua_tointeger(L, 1);
                    string sInflenceId = LuaAPI.lua_tostring(L, 2);
                    int iOddQX = LuaAPI.xlua_tointeger(L, 3);
                    int iOddQY = LuaAPI.xlua_tointeger(L, 4);
                    byte byType = (byte)LuaAPI.lua_tonumber(L, 5);
                    int iModelIndex = LuaAPI.xlua_tointeger(L, 6);
                    
                        bool __cl_gen_ret = LPCFramework.TerrainLuaDelegates.SpawnGroundItem( iId, sInflenceId, iOddQX, iOddQY, byType, iModelIndex );
                        LuaAPI.lua_pushboolean(L, __cl_gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception __gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + __gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_SpawnGroundItemRandomPos_xlua_st_(RealStatePtr L)
        {
            
            
            
            try {
                
                {
                    int iId = LuaAPI.xlua_tointeger(L, 1);
                    string sInflenceId = LuaAPI.lua_tostring(L, 2);
                    
                        bool __cl_gen_ret = LPCFramework.TerrainLuaDelegates.SpawnGroundItemRandomPos( iId, sInflenceId );
                        LuaAPI.lua_pushboolean(L, __cl_gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception __gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + __gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_GetCityInfoById_xlua_st_(RealStatePtr L)
        {
            
            ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
            
            try {
                
                {
                    int iCityId = LuaAPI.xlua_tointeger(L, 1);
                    
                        LPCFramework.GroundItemInfo __cl_gen_ret = LPCFramework.TerrainLuaDelegates.GetCityInfoById( iCityId );
                        translator.Push(L, __cl_gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception __gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + __gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_GetGroundInfoPosById_xlua_st_(RealStatePtr L)
        {
            
            ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
            
            try {
                
                {
                    int iTreeId = LuaAPI.xlua_tointeger(L, 1);
                    
                        LPCFramework.GroundItemInfo __cl_gen_ret = LPCFramework.TerrainLuaDelegates.GetGroundInfoPosById( iTreeId );
                        translator.Push(L, __cl_gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception __gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + __gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_GetCityInfoByOddQPos_xlua_st_(RealStatePtr L)
        {
            
            ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
            
            try {
                
                {
                    int iX = LuaAPI.xlua_tointeger(L, 1);
                    int iY = LuaAPI.xlua_tointeger(L, 2);
                    
                        object __cl_gen_ret = LPCFramework.TerrainLuaDelegates.GetCityInfoByOddQPos( iX, iY );
                        translator.PushAny(L, __cl_gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception __gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + __gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_GetGroundInfoOddQPos_xlua_st_(RealStatePtr L)
        {
            
            ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
            
            try {
                
                {
                    int iX = LuaAPI.xlua_tointeger(L, 1);
                    int iY = LuaAPI.xlua_tointeger(L, 2);
                    
                        object __cl_gen_ret = LPCFramework.TerrainLuaDelegates.GetGroundInfoOddQPos( iX, iY );
                        translator.PushAny(L, __cl_gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception __gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + __gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_RemoveCity_xlua_st_(RealStatePtr L)
        {
            
            
            
            try {
                
                {
                    int iCityId = LuaAPI.xlua_tointeger(L, 1);
                    
                        bool __cl_gen_ret = LPCFramework.TerrainLuaDelegates.RemoveCity( iCityId );
                        LuaAPI.lua_pushboolean(L, __cl_gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception __gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + __gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_UpdateCityInfo_xlua_st_(RealStatePtr L)
        {
            
            
            
            try {
                
                {
                    int iCityId = LuaAPI.xlua_tointeger(L, 1);
                    int iLevel = LuaAPI.xlua_tointeger(L, 2);
                    int iCityModelLevel = LuaAPI.xlua_tointeger(L, 3);
                    string sPlayerName = LuaAPI.lua_tostring(L, 4);
                    int iPlayerLevel = LuaAPI.xlua_tointeger(L, 5);
                    int iUnionId = LuaAPI.xlua_tointeger(L, 6);
                    string sUnionName = LuaAPI.lua_tostring(L, 7);
                    int iNewPosX = LuaAPI.xlua_tointeger(L, 8);
                    int iNewPosY = LuaAPI.xlua_tointeger(L, 9);
                    
                        bool __cl_gen_ret = LPCFramework.TerrainLuaDelegates.UpdateCityInfo( iCityId, iLevel, iCityModelLevel, sPlayerName, iPlayerLevel, iUnionId, sUnionName, iNewPosX, iNewPosY );
                        LuaAPI.lua_pushboolean(L, __cl_gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception __gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + __gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_UpdateCityGradeAndModelGrade_xlua_st_(RealStatePtr L)
        {
            
            
            
            try {
                
                {
                    int iCityId = LuaAPI.xlua_tointeger(L, 1);
                    int iLevel = LuaAPI.xlua_tointeger(L, 2);
                    int iCityModelLevel = LuaAPI.xlua_tointeger(L, 3);
                    
                        bool __cl_gen_ret = LPCFramework.TerrainLuaDelegates.UpdateCityGradeAndModelGrade( iCityId, iLevel, iCityModelLevel );
                        LuaAPI.lua_pushboolean(L, __cl_gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception __gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + __gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_ChangeCityGrade_xlua_st_(RealStatePtr L)
        {
            
            
            
            try {
                
                {
                    int iCityId = LuaAPI.xlua_tointeger(L, 1);
                    int iNewGrade = LuaAPI.xlua_tointeger(L, 2);
                    
                        bool __cl_gen_ret = LPCFramework.TerrainLuaDelegates.ChangeCityGrade( iCityId, iNewGrade );
                        LuaAPI.lua_pushboolean(L, __cl_gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception __gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + __gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_ChangeCityModelGrade_xlua_st_(RealStatePtr L)
        {
            
            
            
            try {
                
                {
                    int iCityId = LuaAPI.xlua_tointeger(L, 1);
                    int iNewGrade = LuaAPI.xlua_tointeger(L, 2);
                    
                        bool __cl_gen_ret = LPCFramework.TerrainLuaDelegates.ChangeCityModelGrade( iCityId, iNewGrade );
                        LuaAPI.lua_pushboolean(L, __cl_gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception __gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + __gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_ChangeCityUnionId_xlua_st_(RealStatePtr L)
        {
            
            
            
			int __gen_param_count = LuaAPI.lua_gettop(L);
            
            try {
                if(__gen_param_count == 2&& LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 1)&& LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 2)) 
                {
                    int iCityId = LuaAPI.xlua_tointeger(L, 1);
                    int iUnionId = LuaAPI.xlua_tointeger(L, 2);
                    
                        bool __cl_gen_ret = LPCFramework.TerrainLuaDelegates.ChangeCityUnionId( iCityId, iUnionId );
                        LuaAPI.lua_pushboolean(L, __cl_gen_ret);
                    
                    
                    
                    return 1;
                }
                if(__gen_param_count == 3&& LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 1)&& LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 2)&& (LuaAPI.lua_isnil(L, 3) || LuaAPI.lua_type(L, 3) == LuaTypes.LUA_TSTRING)) 
                {
                    int iCityId = LuaAPI.xlua_tointeger(L, 1);
                    int iUnionId = LuaAPI.xlua_tointeger(L, 2);
                    string sUnionName = LuaAPI.lua_tostring(L, 3);
                    
                        bool __cl_gen_ret = LPCFramework.TerrainLuaDelegates.ChangeCityUnionId( iCityId, iUnionId, sUnionName );
                        LuaAPI.lua_pushboolean(L, __cl_gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception __gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + __gen_e);
            }
            
            return LuaAPI.luaL_error(L, "invalid arguments to LPCFramework.TerrainLuaDelegates.ChangeCityUnionId!");
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_ChangeCityPlayerLevel_xlua_st_(RealStatePtr L)
        {
            
            
            
            try {
                
                {
                    int iCityId = LuaAPI.xlua_tointeger(L, 1);
                    int iPlayerLevel = LuaAPI.xlua_tointeger(L, 2);
                    
                        bool __cl_gen_ret = LPCFramework.TerrainLuaDelegates.ChangeCityPlayerLevel( iCityId, iPlayerLevel );
                        LuaAPI.lua_pushboolean(L, __cl_gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception __gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + __gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_ChangeCityPlayerName_xlua_st_(RealStatePtr L)
        {
            
            
            
            try {
                
                {
                    int iCityId = LuaAPI.xlua_tointeger(L, 1);
                    string sPlayerName = LuaAPI.lua_tostring(L, 2);
                    
                        bool __cl_gen_ret = LPCFramework.TerrainLuaDelegates.ChangeCityPlayerName( iCityId, sPlayerName );
                        LuaAPI.lua_pushboolean(L, __cl_gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception __gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + __gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_ChangeCityWhiteFlag_xlua_st_(RealStatePtr L)
        {
            
            
            
            try {
                
                {
                    int iCityId = LuaAPI.xlua_tointeger(L, 1);
                    string sFlagGuildFlagName = LuaAPI.lua_tostring(L, 2);
                    
                        bool __cl_gen_ret = LPCFramework.TerrainLuaDelegates.ChangeCityWhiteFlag( iCityId, sFlagGuildFlagName );
                        LuaAPI.lua_pushboolean(L, __cl_gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception __gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + __gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_ChangeCityPosition_xlua_st_(RealStatePtr L)
        {
            
            
            
            try {
                
                {
                    int iCityId = LuaAPI.xlua_tointeger(L, 1);
                    int iNewPosX = LuaAPI.xlua_tointeger(L, 2);
                    int iNewPosY = LuaAPI.xlua_tointeger(L, 3);
                    
                        bool __cl_gen_ret = LPCFramework.TerrainLuaDelegates.ChangeCityPosition( iCityId, iNewPosX, iNewPosY );
                        LuaAPI.lua_pushboolean(L, __cl_gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception __gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + __gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_RemoveResource_xlua_st_(RealStatePtr L)
        {
            
            
            
            try {
                
                {
                    int iResourceId = LuaAPI.xlua_tointeger(L, 1);
                    
                        bool __cl_gen_ret = LPCFramework.TerrainLuaDelegates.RemoveResource( iResourceId );
                        LuaAPI.lua_pushboolean(L, __cl_gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception __gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + __gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_SetResourceModelGrade_xlua_st_(RealStatePtr L)
        {
            
            
            
            try {
                
                {
                    int iResourceId = LuaAPI.xlua_tointeger(L, 1);
                    int iNewGrade = LuaAPI.xlua_tointeger(L, 2);
                    
                        bool __cl_gen_ret = LPCFramework.TerrainLuaDelegates.SetResourceModelGrade( iResourceId, iNewGrade );
                        LuaAPI.lua_pushboolean(L, __cl_gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception __gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + __gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_UnSelectAll_xlua_st_(RealStatePtr L)
        {
            
            
            
            try {
                
                {
                    
                        bool __cl_gen_ret = LPCFramework.TerrainLuaDelegates.UnSelectAll(  );
                        LuaAPI.lua_pushboolean(L, __cl_gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception __gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + __gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_SetDefaultRadius_xlua_st_(RealStatePtr L)
        {
            
            
            
            try {
                
                {
                    float fRadius = (float)LuaAPI.lua_tonumber(L, 1);
                    
                        bool __cl_gen_ret = LPCFramework.TerrainLuaDelegates.SetDefaultRadius( fRadius );
                        LuaAPI.lua_pushboolean(L, __cl_gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception __gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + __gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_SelectCityAndNearBy_xlua_st_(RealStatePtr L)
        {
            
            
            
            try {
                
                {
                    int iCityId = LuaAPI.xlua_tointeger(L, 1);
                    
                        int __cl_gen_ret = LPCFramework.TerrainLuaDelegates.SelectCityAndNearBy( iCityId );
                        LuaAPI.xlua_pushinteger(L, __cl_gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception __gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + __gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_SelectCityAndNearByWithRadius_xlua_st_(RealStatePtr L)
        {
            
            
            
            try {
                
                {
                    int iCityId = LuaAPI.xlua_tointeger(L, 1);
                    float fRadius = (float)LuaAPI.lua_tonumber(L, 2);
                    
                        int __cl_gen_ret = LPCFramework.TerrainLuaDelegates.SelectCityAndNearByWithRadius( iCityId, fRadius );
                        LuaAPI.xlua_pushinteger(L, __cl_gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception __gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + __gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_SelectCityAndNearByOddQ_xlua_st_(RealStatePtr L)
        {
            
            
            
            try {
                
                {
                    int iOddQX = LuaAPI.xlua_tointeger(L, 1);
                    int iOddQY = LuaAPI.xlua_tointeger(L, 2);
                    
                        int __cl_gen_ret = LPCFramework.TerrainLuaDelegates.SelectCityAndNearByOddQ( iOddQX, iOddQY );
                        LuaAPI.xlua_pushinteger(L, __cl_gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception __gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + __gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_SelectCityAndNearByOddQWithRadius_xlua_st_(RealStatePtr L)
        {
            
            
            
            try {
                
                {
                    int iOddQX = LuaAPI.xlua_tointeger(L, 1);
                    int iOddQY = LuaAPI.xlua_tointeger(L, 2);
                    float fRadius = (float)LuaAPI.lua_tonumber(L, 3);
                    
                        int __cl_gen_ret = LPCFramework.TerrainLuaDelegates.SelectCityAndNearByOddQWithRadius( iOddQX, iOddQY, fRadius );
                        LuaAPI.xlua_pushinteger(L, __cl_gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception __gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + __gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_GetCameraPointToUV_xlua_st_(RealStatePtr L)
        {
            
            ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
            
            try {
                
                {
                    
                        UnityEngine.Vector2 __cl_gen_ret = LPCFramework.TerrainLuaDelegates.GetCameraPointToUV(  );
                        translator.PushUnityEngineVector2(L, __cl_gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception __gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + __gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_GetCameraPointToOddQ_xlua_st_(RealStatePtr L)
        {
            
            ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
            
            try {
                
                {
                    
                        int[] __cl_gen_ret = LPCFramework.TerrainLuaDelegates.GetCameraPointToOddQ(  );
                        translator.Push(L, __cl_gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception __gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + __gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_SelectCityAndNearByCamera_xlua_st_(RealStatePtr L)
        {
            
            
            
            try {
                
                {
                    
                        int __cl_gen_ret = LPCFramework.TerrainLuaDelegates.SelectCityAndNearByCamera(  );
                        LuaAPI.xlua_pushinteger(L, __cl_gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception __gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + __gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_SelectCityAndNearByCameraWithRadius_xlua_st_(RealStatePtr L)
        {
            
            
            
            try {
                
                {
                    float fRadius = (float)LuaAPI.lua_tonumber(L, 1);
                    
                        int __cl_gen_ret = LPCFramework.TerrainLuaDelegates.SelectCityAndNearByCameraWithRadius( fRadius );
                        LuaAPI.xlua_pushinteger(L, __cl_gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception __gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + __gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_TurnCameraSelectMode_xlua_st_(RealStatePtr L)
        {
            
            
            
            try {
                
                {
                    bool bOn = LuaAPI.lua_toboolean(L, 1);
                    
                        bool __cl_gen_ret = LPCFramework.TerrainLuaDelegates.TurnCameraSelectMode( bOn );
                        LuaAPI.lua_pushboolean(L, __cl_gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception __gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + __gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_IsCameraSelectModeOn_xlua_st_(RealStatePtr L)
        {
            
            
            
            try {
                
                {
                    
                        bool __cl_gen_ret = LPCFramework.TerrainLuaDelegates.IsCameraSelectModeOn(  );
                        LuaAPI.lua_pushboolean(L, __cl_gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception __gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + __gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_ShowLine_xlua_st_(RealStatePtr L)
        {
            
            ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
            
			int __gen_param_count = LuaAPI.lua_gettop(L);
            
            try {
                if(__gen_param_count == 5&& LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 1)&& LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 2)&& LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 3)&& LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 4)&& translator.Assignable<UnityEngine.Color>(L, 5)) 
                {
                    int iFromOddQX = LuaAPI.xlua_tointeger(L, 1);
                    int iFromOddQY = LuaAPI.xlua_tointeger(L, 2);
                    int iToOddQX = LuaAPI.xlua_tointeger(L, 3);
                    int iToOddQY = LuaAPI.xlua_tointeger(L, 4);
                    UnityEngine.Color c;translator.Get(L, 5, out c);
                    
                        int __cl_gen_ret = LPCFramework.TerrainLuaDelegates.ShowLine( iFromOddQX, iFromOddQY, iToOddQX, iToOddQY, c );
                        LuaAPI.xlua_pushinteger(L, __cl_gen_ret);
                    
                    
                    
                    return 1;
                }
                if(__gen_param_count == 3&& translator.Assignable<UnityEngine.Vector2>(L, 1)&& translator.Assignable<UnityEngine.Vector2>(L, 2)&& translator.Assignable<UnityEngine.Color>(L, 3)) 
                {
                    UnityEngine.Vector2 vPosFromUV;translator.Get(L, 1, out vPosFromUV);
                    UnityEngine.Vector2 vPosToUV;translator.Get(L, 2, out vPosToUV);
                    UnityEngine.Color c;translator.Get(L, 3, out c);
                    
                        int __cl_gen_ret = LPCFramework.TerrainLuaDelegates.ShowLine( vPosFromUV, vPosToUV, c );
                        LuaAPI.xlua_pushinteger(L, __cl_gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception __gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + __gen_e);
            }
            
            return LuaAPI.luaL_error(L, "invalid arguments to LPCFramework.TerrainLuaDelegates.ShowLine!");
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_HideLine_xlua_st_(RealStatePtr L)
        {
            
            
            
            try {
                
                {
                    int iId = LuaAPI.xlua_tointeger(L, 1);
                    
                        bool __cl_gen_ret = LPCFramework.TerrainLuaDelegates.HideLine( iId );
                        LuaAPI.lua_pushboolean(L, __cl_gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception __gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + __gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_SamplePosition_xlua_st_(RealStatePtr L)
        {
            
            ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
            
			int __gen_param_count = LuaAPI.lua_gettop(L);
            
            try {
                if(__gen_param_count == 4&& LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 1)&& LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 2)&& LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 3)&& LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 4)) 
                {
                    int iFromOddQX = LuaAPI.xlua_tointeger(L, 1);
                    int iFromOddQY = LuaAPI.xlua_tointeger(L, 2);
                    int iToOddQX = LuaAPI.xlua_tointeger(L, 3);
                    int iToOddQY = LuaAPI.xlua_tointeger(L, 4);
                    
                        XLua.LuaTable __cl_gen_ret = LPCFramework.TerrainLuaDelegates.SamplePosition( iFromOddQX, iFromOddQY, iToOddQX, iToOddQY );
                        translator.Push(L, __cl_gen_ret);
                    
                    
                    
                    return 1;
                }
                if(__gen_param_count == 2&& translator.Assignable<UnityEngine.Vector2>(L, 1)&& translator.Assignable<UnityEngine.Vector2>(L, 2)) 
                {
                    UnityEngine.Vector2 vPosFromUV;translator.Get(L, 1, out vPosFromUV);
                    UnityEngine.Vector2 vPosToUV;translator.Get(L, 2, out vPosToUV);
                    
                        UnityEngine.Vector3[] __cl_gen_ret = LPCFramework.TerrainLuaDelegates.SamplePosition( vPosFromUV, vPosToUV );
                        translator.Push(L, __cl_gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception __gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + __gen_e);
            }
            
            return LuaAPI.luaL_error(L, "invalid arguments to LPCFramework.TerrainLuaDelegates.SamplePosition!");
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_CameraMoveTo_xlua_st_(RealStatePtr L)
        {
            
            ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
            
            try {
                
                {
                    UnityEngine.Vector2 vUV;translator.Get(L, 1, out vUV);
                    string sCBFunction = LuaAPI.lua_tostring(L, 2);
                    string sCBKeyword = LuaAPI.lua_tostring(L, 3);
                    float fTime = (float)LuaAPI.lua_tonumber(L, 4);
                    
                        bool __cl_gen_ret = LPCFramework.TerrainLuaDelegates.CameraMoveTo( vUV, sCBFunction, sCBKeyword, fTime );
                        LuaAPI.lua_pushboolean(L, __cl_gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception __gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + __gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_CameraMoveToOddQ_xlua_st_(RealStatePtr L)
        {
            
            
            
            try {
                
                {
                    int iOddQX = LuaAPI.xlua_tointeger(L, 1);
                    int iOddQY = LuaAPI.xlua_tointeger(L, 2);
                    string sCBFunction = LuaAPI.lua_tostring(L, 3);
                    string sCBKeyword = LuaAPI.lua_tostring(L, 4);
                    float fTime = (float)LuaAPI.lua_tonumber(L, 5);
                    
                        bool __cl_gen_ret = LPCFramework.TerrainLuaDelegates.CameraMoveToOddQ( iOddQX, iOddQY, sCBFunction, sCBKeyword, fTime );
                        LuaAPI.lua_pushboolean(L, __cl_gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception __gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + __gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_CameraMoveToCity_xlua_st_(RealStatePtr L)
        {
            
            
            
            try {
                
                {
                    int iCityId = LuaAPI.xlua_tointeger(L, 1);
                    string sCBFunction = LuaAPI.lua_tostring(L, 2);
                    string sCBKeyword = LuaAPI.lua_tostring(L, 3);
                    float fTime = (float)LuaAPI.lua_tonumber(L, 4);
                    
                        bool __cl_gen_ret = LPCFramework.TerrainLuaDelegates.CameraMoveToCity( iCityId, sCBFunction, sCBKeyword, fTime );
                        LuaAPI.lua_pushboolean(L, __cl_gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception __gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + __gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_CameraMoveToResource_xlua_st_(RealStatePtr L)
        {
            
            
            
            try {
                
                {
                    int iTreeId = LuaAPI.xlua_tointeger(L, 1);
                    string sCBFunction = LuaAPI.lua_tostring(L, 2);
                    string sCBKeyword = LuaAPI.lua_tostring(L, 3);
                    float fTime = (float)LuaAPI.lua_tonumber(L, 4);
                    
                        bool __cl_gen_ret = LPCFramework.TerrainLuaDelegates.CameraMoveToResource( iTreeId, sCBFunction, sCBKeyword, fTime );
                        LuaAPI.lua_pushboolean(L, __cl_gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception __gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + __gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_SetMoveCityModeCameraScrollParam_xlua_st_(RealStatePtr L)
        {
            
            ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
            
            try {
                
                {
                    UnityEngine.Vector4 vP1;translator.Get(L, 1, out vP1);
                    UnityEngine.Vector3 vP2;translator.Get(L, 2, out vP2);
                    
                        bool __cl_gen_ret = LPCFramework.TerrainLuaDelegates.SetMoveCityModeCameraScrollParam( vP1, vP2 );
                        LuaAPI.lua_pushboolean(L, __cl_gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception __gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + __gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_SetMoveCityCallbackFunction_xlua_st_(RealStatePtr L)
        {
            
            
            
            try {
                
                {
                    string sFunction = LuaAPI.lua_tostring(L, 1);
                    
                    LPCFramework.TerrainLuaDelegates.SetMoveCityCallbackFunction( sFunction );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception __gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + __gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_SetMoveCityOccupyRadius_xlua_st_(RealStatePtr L)
        {
            
            
            
            try {
                
                {
                    int iRadius = LuaAPI.xlua_tointeger(L, 1);
                    
                        bool __cl_gen_ret = LPCFramework.TerrainLuaDelegates.SetMoveCityOccupyRadius( iRadius );
                        LuaAPI.lua_pushboolean(L, __cl_gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception __gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + __gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_EnterMoveCityMode_xlua_st_(RealStatePtr L)
        {
            
            
            
            try {
                
                {
                    float fCameraSlerp = (float)LuaAPI.lua_tonumber(L, 1);
                    
                        bool __cl_gen_ret = LPCFramework.TerrainLuaDelegates.EnterMoveCityMode( fCameraSlerp );
                        LuaAPI.lua_pushboolean(L, __cl_gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception __gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + __gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_EnterMoveMainCityModeWithOddQ_xlua_st_(RealStatePtr L)
        {
            
            
            
            try {
                
                {
                    float fCameraSlerp = (float)LuaAPI.lua_tonumber(L, 1);
                    int iOddQX = LuaAPI.xlua_tointeger(L, 2);
                    int iOddQY = LuaAPI.xlua_tointeger(L, 3);
                    int iCityLevel = LuaAPI.xlua_tointeger(L, 4);
                    int iModelIndex = LuaAPI.xlua_tointeger(L, 5);
                    string sGuildFlagName = LuaAPI.lua_tostring(L, 6);
                    string sPlayerName = LuaAPI.lua_tostring(L, 7);
                    
                        bool __cl_gen_ret = LPCFramework.TerrainLuaDelegates.EnterMoveMainCityModeWithOddQ( fCameraSlerp, iOddQX, iOddQY, iCityLevel, iModelIndex, sGuildFlagName, sPlayerName );
                        LuaAPI.lua_pushboolean(L, __cl_gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception __gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + __gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_LeaveMoveCityMode_xlua_st_(RealStatePtr L)
        {
            
            
            
            try {
                
                {
                    
                        bool __cl_gen_ret = LPCFramework.TerrainLuaDelegates.LeaveMoveCityMode(  );
                        LuaAPI.lua_pushboolean(L, __cl_gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception __gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + __gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_EnterMoveCampsiteModeWithOddQ_xlua_st_(RealStatePtr L)
        {
            
            
            
            try {
                
                {
                    float fCameraSlerp = (float)LuaAPI.lua_tonumber(L, 1);
                    int iOddQX = LuaAPI.xlua_tointeger(L, 2);
                    int iOddQY = LuaAPI.xlua_tointeger(L, 3);
                    int iCampLevel = LuaAPI.xlua_tointeger(L, 4);
                    int iCampModelIndex = LuaAPI.xlua_tointeger(L, 5);
                    string sGuildFlagName = LuaAPI.lua_tostring(L, 6);
                    string sPlayerName = LuaAPI.lua_tostring(L, 7);
                    
                        bool __cl_gen_ret = LPCFramework.TerrainLuaDelegates.EnterMoveCampsiteModeWithOddQ( fCameraSlerp, iOddQX, iOddQY, iCampLevel, iCampModelIndex, sGuildFlagName, sPlayerName );
                        LuaAPI.lua_pushboolean(L, __cl_gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception __gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + __gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_SetCanputCityColor_xlua_st_(RealStatePtr L)
        {
            
            ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
            
            try {
                
                {
                    UnityEngine.Color c;translator.Get(L, 1, out c);
                    
                        bool __cl_gen_ret = LPCFramework.TerrainLuaDelegates.SetCanputCityColor( c );
                        LuaAPI.lua_pushboolean(L, __cl_gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception __gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + __gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_SetCannotputCityColor_xlua_st_(RealStatePtr L)
        {
            
            ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
            
            try {
                
                {
                    UnityEngine.Color c;translator.Get(L, 1, out c);
                    
                        bool __cl_gen_ret = LPCFramework.TerrainLuaDelegates.SetCannotputCityColor( c );
                        LuaAPI.lua_pushboolean(L, __cl_gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception __gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + __gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_SetCanputGridColor_xlua_st_(RealStatePtr L)
        {
            
            ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
            
            try {
                
                {
                    UnityEngine.Color c;translator.Get(L, 1, out c);
                    
                        bool __cl_gen_ret = LPCFramework.TerrainLuaDelegates.SetCanputGridColor( c );
                        LuaAPI.lua_pushboolean(L, __cl_gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception __gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + __gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_SetCannotputGridColor_xlua_st_(RealStatePtr L)
        {
            
            ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
            
            try {
                
                {
                    UnityEngine.Color c;translator.Get(L, 1, out c);
                    
                        bool __cl_gen_ret = LPCFramework.TerrainLuaDelegates.SetCannotputGridColor( c );
                        LuaAPI.lua_pushboolean(L, __cl_gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception __gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + __gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_SetSelfEdgeColor_xlua_st_(RealStatePtr L)
        {
            
            ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
            
            try {
                
                {
                    UnityEngine.Color c;translator.Get(L, 1, out c);
                    
                        bool __cl_gen_ret = LPCFramework.TerrainLuaDelegates.SetSelfEdgeColor( c );
                        LuaAPI.lua_pushboolean(L, __cl_gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception __gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + __gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_SetFriendEdgeColor_xlua_st_(RealStatePtr L)
        {
            
            ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
            
            try {
                
                {
                    UnityEngine.Color c;translator.Get(L, 1, out c);
                    
                        bool __cl_gen_ret = LPCFramework.TerrainLuaDelegates.SetFriendEdgeColor( c );
                        LuaAPI.lua_pushboolean(L, __cl_gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception __gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + __gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_SetNoUnionEdgeColor_xlua_st_(RealStatePtr L)
        {
            
            ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
            
            try {
                
                {
                    UnityEngine.Color c;translator.Get(L, 1, out c);
                    
                        bool __cl_gen_ret = LPCFramework.TerrainLuaDelegates.SetNoUnionEdgeColor( c );
                        LuaAPI.lua_pushboolean(L, __cl_gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception __gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + __gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_SetEnemyEdgeColor_xlua_st_(RealStatePtr L)
        {
            
            ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
            
            try {
                
                {
                    UnityEngine.Color c;translator.Get(L, 1, out c);
                    
                        bool __cl_gen_ret = LPCFramework.TerrainLuaDelegates.SetEnemyEdgeColor( c );
                        LuaAPI.lua_pushboolean(L, __cl_gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception __gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + __gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_SetUnionColor_xlua_st_(RealStatePtr L)
        {
            
            ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
            
            try {
                
                {
                    int iUnionId = LuaAPI.xlua_tointeger(L, 1);
                    UnityEngine.Color c;translator.Get(L, 2, out c);
                    
                        bool __cl_gen_ret = LPCFramework.TerrainLuaDelegates.SetUnionColor( iUnionId, c );
                        LuaAPI.lua_pushboolean(L, __cl_gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception __gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + __gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_SetClickGroundCallBack_xlua_st_(RealStatePtr L)
        {
            
            
            
            try {
                
                {
                    string sFunctionName = LuaAPI.lua_tostring(L, 1);
                    
                    LPCFramework.TerrainLuaDelegates.SetClickGroundCallBack( sFunctionName );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception __gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + __gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_OnClickGround_xlua_st_(RealStatePtr L)
        {
            
            ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
            
            try {
                
                {
                    UnityEngine.Vector2 vUV;translator.Get(L, 1, out vUV);
                    int iOddQX = LuaAPI.xlua_tointeger(L, 2);
                    int iOddQY = LuaAPI.xlua_tointeger(L, 3);
                    LPCFramework.GroundItemInfo gi = (LPCFramework.GroundItemInfo)translator.GetObject(L, 4, typeof(LPCFramework.GroundItemInfo));
                    
                    LPCFramework.TerrainLuaDelegates.OnClickGround( vUV, iOddQX, iOddQY, gi );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception __gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + __gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_SetOnCameraFaceToCallback_xlua_st_(RealStatePtr L)
        {
            
            
            
            try {
                
                {
                    string camerafacetoCallback = LuaAPI.lua_tostring(L, 1);
                    
                    LPCFramework.TerrainLuaDelegates.SetOnCameraFaceToCallback( camerafacetoCallback );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception __gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + __gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_EnableGridDisplay_xlua_st_(RealStatePtr L)
        {
            
            
            
            try {
                
                {
                    bool value = LuaAPI.lua_toboolean(L, 1);
                    
                        bool __cl_gen_ret = LPCFramework.TerrainLuaDelegates.EnableGridDisplay( value );
                        LuaAPI.lua_pushboolean(L, __cl_gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception __gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + __gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_SetMarkType_xlua_st_(RealStatePtr L)
        {
            
            ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
            
            try {
                
                {
                    LPCFramework.TerrainGroundGrid.MarkType markType;translator.Get(L, 1, out markType);
                    
                        bool __cl_gen_ret = LPCFramework.TerrainLuaDelegates.SetMarkType( markType );
                        LuaAPI.lua_pushboolean(L, __cl_gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception __gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + __gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_EnableManualMarking_xlua_st_(RealStatePtr L)
        {
            
            
            
            try {
                
                {
                    bool value = LuaAPI.lua_toboolean(L, 1);
                    
                        bool __cl_gen_ret = LPCFramework.TerrainLuaDelegates.EnableManualMarking( value );
                        LuaAPI.lua_pushboolean(L, __cl_gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception __gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + __gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_EnableMarkDrawing_xlua_st_(RealStatePtr L)
        {
            
            
            
            try {
                
                {
                    bool value = LuaAPI.lua_toboolean(L, 1);
                    
                        bool __cl_gen_ret = LPCFramework.TerrainLuaDelegates.EnableMarkDrawing( value );
                        LuaAPI.lua_pushboolean(L, __cl_gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception __gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + __gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_ReadGridPropertyFromFile_xlua_st_(RealStatePtr L)
        {
            
            
            
            try {
                
                {
                    int mapId = LuaAPI.xlua_tointeger(L, 1);
                    
                        bool __cl_gen_ret = LPCFramework.TerrainLuaDelegates.ReadGridPropertyFromFile( mapId );
                        LuaAPI.lua_pushboolean(L, __cl_gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception __gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + __gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_SaveGridPropertyToFile_xlua_st_(RealStatePtr L)
        {
            
            
            
            try {
                
                {
                    int mapId = LuaAPI.xlua_tointeger(L, 1);
                    
                        bool __cl_gen_ret = LPCFramework.TerrainLuaDelegates.SaveGridPropertyToFile( mapId );
                        LuaAPI.lua_pushboolean(L, __cl_gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception __gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + __gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_SetStaticItemAsTransparentItem_xlua_st_(RealStatePtr L)
        {
            
            
            
            try {
                
                {
                    
                        bool __cl_gen_ret = LPCFramework.TerrainLuaDelegates.SetStaticItemAsTransparentItem(  );
                        LuaAPI.lua_pushboolean(L, __cl_gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception __gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + __gen_e);
            }
            
        }
        
        
        
        
        
        
		
		
		
		
    }
}
