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
    public class LPCFrameworkResourceVersionInfoWrap
    {
        public static void __Register(RealStatePtr L)
        {
			ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			Utils.BeginObjectRegister(typeof(LPCFramework.ResourceVersionInfo), L, translator, 0, 3, 4, 0);
			
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "GetAssetBundleFullPath", _m_GetAssetBundleFullPath);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "isVersionFileExist", _m_isVersionFileExist);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "DisassembleVersionList", _m_DisassembleVersionList);
			
			
			Utils.RegisterFunc(L, Utils.GETTER_IDX, "isManifestFilsExist", _g_get_isManifestFilsExist);
            Utils.RegisterFunc(L, Utils.GETTER_IDX, "GetManifestFile", _g_get_GetManifestFile);
            Utils.RegisterFunc(L, Utils.GETTER_IDX, "GetVersionFile", _g_get_GetVersionFile);
            Utils.RegisterFunc(L, Utils.GETTER_IDX, "GetVersionFolder", _g_get_GetVersionFolder);
            
			
			Utils.EndObjectRegister(typeof(LPCFramework.ResourceVersionInfo), L, translator, null, null,
			    null, null, null);

		    Utils.BeginClassRegister(typeof(LPCFramework.ResourceVersionInfo), L, __CreateInstance, 1, 0, 0);
			
			
            
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "UnderlyingSystemType", typeof(LPCFramework.ResourceVersionInfo));
			
			
			Utils.EndClassRegister(typeof(LPCFramework.ResourceVersionInfo), L, translator);
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int __CreateInstance(RealStatePtr L)
        {
            
            ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			try {
				if(LuaAPI.lua_gettop(L) == 2 && LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 2))
				{
					int sversion = LuaAPI.xlua_tointeger(L, 2);
					
					LPCFramework.ResourceVersionInfo __cl_gen_ret = new LPCFramework.ResourceVersionInfo(sversion);
					translator.Push(L, __cl_gen_ret);
                    
					return 1;
				}
				
			}
			catch(System.Exception __gen_e) {
				return LuaAPI.luaL_error(L, "c# exception:" + __gen_e);
			}
            return LuaAPI.luaL_error(L, "invalid arguments to LPCFramework.ResourceVersionInfo constructor!");
            
        }
        
		
        
		
        
        
        
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_GetAssetBundleFullPath(RealStatePtr L)
        {
            
            ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
            LPCFramework.ResourceVersionInfo __cl_gen_to_be_invoked = (LPCFramework.ResourceVersionInfo)translator.FastGetCSObj(L, 1);
            
            
            try {
                
                {
                    string relativepath = LuaAPI.lua_tostring(L, 2);
                    
                        string __cl_gen_ret = __cl_gen_to_be_invoked.GetAssetBundleFullPath( relativepath );
                        LuaAPI.lua_pushstring(L, __cl_gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception __gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + __gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_isVersionFileExist(RealStatePtr L)
        {
            
            ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
            LPCFramework.ResourceVersionInfo __cl_gen_to_be_invoked = (LPCFramework.ResourceVersionInfo)translator.FastGetCSObj(L, 1);
            
            
            try {
                
                {
                    
                        bool __cl_gen_ret = __cl_gen_to_be_invoked.isVersionFileExist(  );
                        LuaAPI.lua_pushboolean(L, __cl_gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception __gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + __gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_DisassembleVersionList(RealStatePtr L)
        {
            
            ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
            LPCFramework.ResourceVersionInfo __cl_gen_to_be_invoked = (LPCFramework.ResourceVersionInfo)translator.FastGetCSObj(L, 1);
            
            
            try {
                
                {
                    
                    __cl_gen_to_be_invoked.DisassembleVersionList(  );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception __gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + __gen_e);
            }
            
        }
        
        
        
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_isManifestFilsExist(RealStatePtr L)
        {
            ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            try {
			
                LPCFramework.ResourceVersionInfo __cl_gen_to_be_invoked = (LPCFramework.ResourceVersionInfo)translator.FastGetCSObj(L, 1);
                LuaAPI.lua_pushboolean(L, __cl_gen_to_be_invoked.isManifestFilsExist);
            } catch(System.Exception __gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + __gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_GetManifestFile(RealStatePtr L)
        {
            ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            try {
			
                LPCFramework.ResourceVersionInfo __cl_gen_to_be_invoked = (LPCFramework.ResourceVersionInfo)translator.FastGetCSObj(L, 1);
                LuaAPI.lua_pushstring(L, __cl_gen_to_be_invoked.GetManifestFile);
            } catch(System.Exception __gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + __gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_GetVersionFile(RealStatePtr L)
        {
            ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            try {
			
                LPCFramework.ResourceVersionInfo __cl_gen_to_be_invoked = (LPCFramework.ResourceVersionInfo)translator.FastGetCSObj(L, 1);
                LuaAPI.lua_pushstring(L, __cl_gen_to_be_invoked.GetVersionFile);
            } catch(System.Exception __gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + __gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_GetVersionFolder(RealStatePtr L)
        {
            ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            try {
			
                LPCFramework.ResourceVersionInfo __cl_gen_to_be_invoked = (LPCFramework.ResourceVersionInfo)translator.FastGetCSObj(L, 1);
                LuaAPI.lua_pushstring(L, __cl_gen_to_be_invoked.GetVersionFolder);
            } catch(System.Exception __gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + __gen_e);
            }
            return 1;
        }
        
        
        
		
		
		
		
    }
}
