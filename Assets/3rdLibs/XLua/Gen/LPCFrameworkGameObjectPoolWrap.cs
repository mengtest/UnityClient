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
    public class LPCFrameworkGameObjectPoolWrap
    {
        public static void __Register(RealStatePtr L)
        {
			ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			Utils.BeginObjectRegister(typeof(LPCFramework.GameObjectPool), L, translator, 0, 4, 0, 0);
			
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "NextAvailableObject", _m_NextAvailableObject);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "ReturnObjectToPool", _m_ReturnObjectToPool);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "OnDestroy", _m_OnDestroy);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "GameObjectPoolResize", _m_GameObjectPoolResize);
			
			
			
			
			Utils.EndObjectRegister(typeof(LPCFramework.GameObjectPool), L, translator, null, null,
			    null, null, null);

		    Utils.BeginClassRegister(typeof(LPCFramework.GameObjectPool), L, __CreateInstance, 1, 0, 0);
			
			
            
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "UnderlyingSystemType", typeof(LPCFramework.GameObjectPool));
			
			
			Utils.EndClassRegister(typeof(LPCFramework.GameObjectPool), L, translator);
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int __CreateInstance(RealStatePtr L)
        {
            
            ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			try {
				if(LuaAPI.lua_gettop(L) == 6 && (LuaAPI.lua_isnil(L, 2) || LuaAPI.lua_type(L, 2) == LuaTypes.LUA_TSTRING) && translator.Assignable<UnityEngine.GameObject>(L, 3) && LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 4) && LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 5) && translator.Assignable<UnityEngine.Transform>(L, 6))
				{
					string poolName = LuaAPI.lua_tostring(L, 2);
					UnityEngine.GameObject poolObjectPrefab = (UnityEngine.GameObject)translator.GetObject(L, 3, typeof(UnityEngine.GameObject));
					int initCount = LuaAPI.xlua_tointeger(L, 4);
					int maxSize = LuaAPI.xlua_tointeger(L, 5);
					UnityEngine.Transform poolRoot = (UnityEngine.Transform)translator.GetObject(L, 6, typeof(UnityEngine.Transform));
					
					LPCFramework.GameObjectPool __cl_gen_ret = new LPCFramework.GameObjectPool(poolName, poolObjectPrefab, initCount, maxSize, poolRoot);
					translator.Push(L, __cl_gen_ret);
                    
					return 1;
				}
				
			}
			catch(System.Exception __gen_e) {
				return LuaAPI.luaL_error(L, "c# exception:" + __gen_e);
			}
            return LuaAPI.luaL_error(L, "invalid arguments to LPCFramework.GameObjectPool constructor!");
            
        }
        
		
        
		
        
        
        
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_NextAvailableObject(RealStatePtr L)
        {
            
            ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
            LPCFramework.GameObjectPool __cl_gen_to_be_invoked = (LPCFramework.GameObjectPool)translator.FastGetCSObj(L, 1);
            
            
			int __gen_param_count = LuaAPI.lua_gettop(L);
            
            try {
                if(__gen_param_count == 2&& LuaTypes.LUA_TBOOLEAN == LuaAPI.lua_type(L, 2)) 
                {
                    bool force = LuaAPI.lua_toboolean(L, 2);
                    
                        UnityEngine.GameObject __cl_gen_ret = __cl_gen_to_be_invoked.NextAvailableObject( force );
                        translator.Push(L, __cl_gen_ret);
                    
                    
                    
                    return 1;
                }
                if(__gen_param_count == 1) 
                {
                    
                        UnityEngine.GameObject __cl_gen_ret = __cl_gen_to_be_invoked.NextAvailableObject(  );
                        translator.Push(L, __cl_gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception __gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + __gen_e);
            }
            
            return LuaAPI.luaL_error(L, "invalid arguments to LPCFramework.GameObjectPool.NextAvailableObject!");
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_ReturnObjectToPool(RealStatePtr L)
        {
            
            ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
            LPCFramework.GameObjectPool __cl_gen_to_be_invoked = (LPCFramework.GameObjectPool)translator.FastGetCSObj(L, 1);
            
            
            try {
                
                {
                    string pool = LuaAPI.lua_tostring(L, 2);
                    UnityEngine.GameObject go = (UnityEngine.GameObject)translator.GetObject(L, 3, typeof(UnityEngine.GameObject));
                    
                    __cl_gen_to_be_invoked.ReturnObjectToPool( pool, go );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception __gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + __gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_OnDestroy(RealStatePtr L)
        {
            
            ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
            LPCFramework.GameObjectPool __cl_gen_to_be_invoked = (LPCFramework.GameObjectPool)translator.FastGetCSObj(L, 1);
            
            
            try {
                
                {
                    
                    __cl_gen_to_be_invoked.OnDestroy(  );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception __gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + __gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_GameObjectPoolResize(RealStatePtr L)
        {
            
            ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
            LPCFramework.GameObjectPool __cl_gen_to_be_invoked = (LPCFramework.GameObjectPool)translator.FastGetCSObj(L, 1);
            
            
            try {
                
                {
                    int resize = LuaAPI.xlua_tointeger(L, 2);
                    int resizeMax = LuaAPI.xlua_tointeger(L, 3);
                    
                    __cl_gen_to_be_invoked.GameObjectPoolResize( resize, resizeMax );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception __gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + __gen_e);
            }
            
        }
        
        
        
        
        
        
		
		
		
		
    }
}
