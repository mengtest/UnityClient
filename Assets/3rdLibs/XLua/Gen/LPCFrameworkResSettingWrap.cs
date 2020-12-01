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
    public class LPCFrameworkResSettingWrap
    {
        public static void __Register(RealStatePtr L)
        {
			ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			Utils.BeginObjectRegister(typeof(LPCFramework.ResSetting), L, translator, 0, 0, 0, 0);
			
			
			
			
			
			Utils.EndObjectRegister(typeof(LPCFramework.ResSetting), L, translator, null, null,
			    null, null, null);

		    Utils.BeginClassRegister(typeof(LPCFramework.ResSetting), L, __CreateInstance, 4, 4, 2);
			Utils.RegisterFunc(L, Utils.CLS_IDX, "InitSetting", _m_InitSetting_xlua_st_);
            Utils.RegisterFunc(L, Utils.CLS_IDX, "AfterUpdateRefreshServerInfo", _m_AfterUpdateRefreshServerInfo_xlua_st_);
            Utils.RegisterFunc(L, Utils.CLS_IDX, "AppContentPath", _m_AppContentPath_xlua_st_);
            
			
            
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "UnderlyingSystemType", typeof(LPCFramework.ResSetting));
			Utils.RegisterFunc(L, Utils.CLS_GETTER_IDX, "LocalResVersion", _g_get_LocalResVersion);
            Utils.RegisterFunc(L, Utils.CLS_GETTER_IDX, "ServerResVersion", _g_get_ServerResVersion);
            Utils.RegisterFunc(L, Utils.CLS_GETTER_IDX, "GetCurVersionInfo", _g_get_GetCurVersionInfo);
            Utils.RegisterFunc(L, Utils.CLS_GETTER_IDX, "m_sUpdateServerURL", _g_get_m_sUpdateServerURL);
            
			Utils.RegisterFunc(L, Utils.CLS_SETTER_IDX, "ServerResVersion", _s_set_ServerResVersion);
            Utils.RegisterFunc(L, Utils.CLS_SETTER_IDX, "m_sUpdateServerURL", _s_set_m_sUpdateServerURL);
            
			Utils.EndClassRegister(typeof(LPCFramework.ResSetting), L, translator);
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int __CreateInstance(RealStatePtr L)
        {
            
            ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			try {
				if(LuaAPI.lua_gettop(L) == 1)
				{
					
					LPCFramework.ResSetting __cl_gen_ret = new LPCFramework.ResSetting();
					translator.Push(L, __cl_gen_ret);
                    
					return 1;
				}
				
			}
			catch(System.Exception __gen_e) {
				return LuaAPI.luaL_error(L, "c# exception:" + __gen_e);
			}
            return LuaAPI.luaL_error(L, "invalid arguments to LPCFramework.ResSetting constructor!");
            
        }
        
		
        
		
        
        
        
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_InitSetting_xlua_st_(RealStatePtr L)
        {
            
            
            
            try {
                
                {
                    
                    LPCFramework.ResSetting.InitSetting(  );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception __gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + __gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_AfterUpdateRefreshServerInfo_xlua_st_(RealStatePtr L)
        {
            
            
            
            try {
                
                {
                    
                    LPCFramework.ResSetting.AfterUpdateRefreshServerInfo(  );
                    
                    
                    
                    return 0;
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
                    
                        string __cl_gen_ret = LPCFramework.ResSetting.AppContentPath(  );
                        LuaAPI.lua_pushstring(L, __cl_gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception __gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + __gen_e);
            }
            
        }
        
        
        
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_LocalResVersion(RealStatePtr L)
        {
            
            try {
			    LuaAPI.xlua_pushinteger(L, LPCFramework.ResSetting.LocalResVersion);
            } catch(System.Exception __gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + __gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_ServerResVersion(RealStatePtr L)
        {
            
            try {
			    LuaAPI.xlua_pushinteger(L, LPCFramework.ResSetting.ServerResVersion);
            } catch(System.Exception __gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + __gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_GetCurVersionInfo(RealStatePtr L)
        {
            ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            try {
			    translator.Push(L, LPCFramework.ResSetting.GetCurVersionInfo);
            } catch(System.Exception __gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + __gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_m_sUpdateServerURL(RealStatePtr L)
        {
            
            try {
			    LuaAPI.lua_pushstring(L, LPCFramework.ResSetting.m_sUpdateServerURL);
            } catch(System.Exception __gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + __gen_e);
            }
            return 1;
        }
        
        
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _s_set_ServerResVersion(RealStatePtr L)
        {
            
            try {
			    LPCFramework.ResSetting.ServerResVersion = LuaAPI.xlua_tointeger(L, 1);
            
            } catch(System.Exception __gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + __gen_e);
            }
            return 0;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _s_set_m_sUpdateServerURL(RealStatePtr L)
        {
            
            try {
			    LPCFramework.ResSetting.m_sUpdateServerURL = LuaAPI.lua_tostring(L, 1);
            
            } catch(System.Exception __gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + __gen_e);
            }
            return 0;
        }
        
		
		
		
		
    }
}
