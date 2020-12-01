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
    public class LPCFrameworkLogicUtilsWrap
    {
        public static void __Register(RealStatePtr L)
        {
			ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			Utils.BeginObjectRegister(typeof(LPCFramework.LogicUtils), L, translator, 0, 0, 0, 0);
			
			
			
			
			
			Utils.EndObjectRegister(typeof(LPCFramework.LogicUtils), L, translator, null, null,
			    null, null, null);

		    Utils.BeginClassRegister(typeof(LPCFramework.LogicUtils), L, __CreateInstance, 14, 3, 0);
			Utils.RegisterFunc(L, Utils.CLS_IDX, "Int", _m_Int_xlua_st_);
            Utils.RegisterFunc(L, Utils.CLS_IDX, "Float", _m_Float_xlua_st_);
            Utils.RegisterFunc(L, Utils.CLS_IDX, "Long", _m_Long_xlua_st_);
            Utils.RegisterFunc(L, Utils.CLS_IDX, "Random", _m_Random_xlua_st_);
            Utils.RegisterFunc(L, Utils.CLS_IDX, "Uid", _m_Uid_xlua_st_);
            Utils.RegisterFunc(L, Utils.CLS_IDX, "GetTime", _m_GetTime_xlua_st_);
            Utils.RegisterFunc(L, Utils.CLS_IDX, "UnpackFiles", _m_UnpackFiles_xlua_st_);
            Utils.RegisterFunc(L, Utils.CLS_IDX, "LoadResource", _m_LoadResource_xlua_st_);
            Utils.RegisterFunc(L, Utils.CLS_IDX, "GetRelativePath", _m_GetRelativePath_xlua_st_);
            Utils.RegisterFunc(L, Utils.CLS_IDX, "AppContentPath", _m_AppContentPath_xlua_st_);
            Utils.RegisterFunc(L, Utils.CLS_IDX, "WorldToScreenPoint", _m_WorldToScreenPoint_xlua_st_);
            Utils.RegisterFunc(L, Utils.CLS_IDX, "ClearMemory", _m_ClearMemory_xlua_st_);
            Utils.RegisterFunc(L, Utils.CLS_IDX, "SetSortingLayer", _m_SetSortingLayer_xlua_st_);
            
			
            
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "UnderlyingSystemType", typeof(LPCFramework.LogicUtils));
			Utils.RegisterFunc(L, Utils.CLS_GETTER_IDX, "DataPath", _g_get_DataPath);
            Utils.RegisterFunc(L, Utils.CLS_GETTER_IDX, "NetAvailable", _g_get_NetAvailable);
            Utils.RegisterFunc(L, Utils.CLS_GETTER_IDX, "IsWifi", _g_get_IsWifi);
            
			
			Utils.EndClassRegister(typeof(LPCFramework.LogicUtils), L, translator);
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int __CreateInstance(RealStatePtr L)
        {
            
            ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			try {
				if(LuaAPI.lua_gettop(L) == 1)
				{
					
					LPCFramework.LogicUtils __cl_gen_ret = new LPCFramework.LogicUtils();
					translator.Push(L, __cl_gen_ret);
                    
					return 1;
				}
				
			}
			catch(System.Exception __gen_e) {
				return LuaAPI.luaL_error(L, "c# exception:" + __gen_e);
			}
            return LuaAPI.luaL_error(L, "invalid arguments to LPCFramework.LogicUtils constructor!");
            
        }
        
		
        
		
        
        
        
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_Int_xlua_st_(RealStatePtr L)
        {
            
            ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
            
            try {
                
                {
                    object o = translator.GetObject(L, 1, typeof(object));
                    
                        int __cl_gen_ret = LPCFramework.LogicUtils.Int( o );
                        LuaAPI.xlua_pushinteger(L, __cl_gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception __gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + __gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_Float_xlua_st_(RealStatePtr L)
        {
            
            ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
            
            try {
                
                {
                    object o = translator.GetObject(L, 1, typeof(object));
                    
                        float __cl_gen_ret = LPCFramework.LogicUtils.Float( o );
                        LuaAPI.lua_pushnumber(L, __cl_gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception __gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + __gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_Long_xlua_st_(RealStatePtr L)
        {
            
            ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
            
            try {
                
                {
                    object o = translator.GetObject(L, 1, typeof(object));
                    
                        long __cl_gen_ret = LPCFramework.LogicUtils.Long( o );
                        LuaAPI.lua_pushint64(L, __cl_gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception __gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + __gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_Random_xlua_st_(RealStatePtr L)
        {
            
            
            
			int __gen_param_count = LuaAPI.lua_gettop(L);
            
            try {
                if(__gen_param_count == 2&& LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 1)&& LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 2)) 
                {
                    int min = LuaAPI.xlua_tointeger(L, 1);
                    int max = LuaAPI.xlua_tointeger(L, 2);
                    
                        int __cl_gen_ret = LPCFramework.LogicUtils.Random( min, max );
                        LuaAPI.xlua_pushinteger(L, __cl_gen_ret);
                    
                    
                    
                    return 1;
                }
                if(__gen_param_count == 2&& LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 1)&& LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 2)) 
                {
                    float min = (float)LuaAPI.lua_tonumber(L, 1);
                    float max = (float)LuaAPI.lua_tonumber(L, 2);
                    
                        float __cl_gen_ret = LPCFramework.LogicUtils.Random( min, max );
                        LuaAPI.lua_pushnumber(L, __cl_gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception __gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + __gen_e);
            }
            
            return LuaAPI.luaL_error(L, "invalid arguments to LPCFramework.LogicUtils.Random!");
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_Uid_xlua_st_(RealStatePtr L)
        {
            
            
            
            try {
                
                {
                    string uid = LuaAPI.lua_tostring(L, 1);
                    
                        string __cl_gen_ret = LPCFramework.LogicUtils.Uid( uid );
                        LuaAPI.lua_pushstring(L, __cl_gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception __gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + __gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_GetTime_xlua_st_(RealStatePtr L)
        {
            
            
            
            try {
                
                {
                    
                        long __cl_gen_ret = LPCFramework.LogicUtils.GetTime(  );
                        LuaAPI.lua_pushint64(L, __cl_gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception __gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + __gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_UnpackFiles_xlua_st_(RealStatePtr L)
        {
            
            
            
            try {
                
                {
                    string file = LuaAPI.lua_tostring(L, 1);
                    string dir = LuaAPI.lua_tostring(L, 2);
                    
                        bool __cl_gen_ret = LPCFramework.LogicUtils.UnpackFiles( file, dir );
                        LuaAPI.lua_pushboolean(L, __cl_gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception __gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + __gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_LoadResource_xlua_st_(RealStatePtr L)
        {
            
            ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
            
            try {
                
                {
                    string path = LuaAPI.lua_tostring(L, 1);
                    
                        UnityEngine.Object __cl_gen_ret = LPCFramework.LogicUtils.LoadResource( path );
                        translator.Push(L, __cl_gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception __gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + __gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_GetRelativePath_xlua_st_(RealStatePtr L)
        {
            
            
            
            try {
                
                {
                    
                        string __cl_gen_ret = LPCFramework.LogicUtils.GetRelativePath(  );
                        LuaAPI.lua_pushstring(L, __cl_gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception __gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + __gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_AppContentPath_xlua_st_(RealStatePtr L)
        {
            
            
            
            try {
                
                {
                    
                        string __cl_gen_ret = LPCFramework.LogicUtils.AppContentPath(  );
                        LuaAPI.lua_pushstring(L, __cl_gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception __gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + __gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_WorldToScreenPoint_xlua_st_(RealStatePtr L)
        {
            
            ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
            
            try {
                
                {
                    UnityEngine.GameObject go = (UnityEngine.GameObject)translator.GetObject(L, 1, typeof(UnityEngine.GameObject));
                    
                        UnityEngine.Vector3 __cl_gen_ret = LPCFramework.LogicUtils.WorldToScreenPoint( go );
                        translator.PushUnityEngineVector3(L, __cl_gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception __gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + __gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_ClearMemory_xlua_st_(RealStatePtr L)
        {
            
            
            
            try {
                
                {
                    
                    LPCFramework.LogicUtils.ClearMemory(  );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception __gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + __gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_SetSortingLayer_xlua_st_(RealStatePtr L)
        {
            
            ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
            
            try {
                
                {
                    UnityEngine.Transform target = (UnityEngine.Transform)translator.GetObject(L, 1, typeof(UnityEngine.Transform));
                    string layerId = LuaAPI.lua_tostring(L, 2);
                    
                    LPCFramework.LogicUtils.SetSortingLayer( target, layerId );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception __gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + __gen_e);
            }
            
        }
        
        
        
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_DataPath(RealStatePtr L)
        {
            
            try {
			    LuaAPI.lua_pushstring(L, LPCFramework.LogicUtils.DataPath);
            } catch(System.Exception __gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + __gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_NetAvailable(RealStatePtr L)
        {
            
            try {
			    LuaAPI.lua_pushboolean(L, LPCFramework.LogicUtils.NetAvailable);
            } catch(System.Exception __gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + __gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_IsWifi(RealStatePtr L)
        {
            
            try {
			    LuaAPI.lua_pushboolean(L, LPCFramework.LogicUtils.IsWifi);
            } catch(System.Exception __gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + __gen_e);
            }
            return 1;
        }
        
        
        
		
		
		
		
    }
}
