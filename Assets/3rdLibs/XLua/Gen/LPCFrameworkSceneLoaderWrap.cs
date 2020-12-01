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
    public class LPCFrameworkSceneLoaderWrap
    {
        public static void __Register(RealStatePtr L)
        {
			ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			Utils.BeginObjectRegister(typeof(LPCFramework.SceneLoader), L, translator, 0, 1, 0, 0);
			
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "LoadScene", _m_LoadScene);
			
			
			
			
			Utils.EndObjectRegister(typeof(LPCFramework.SceneLoader), L, translator, null, null,
			    null, null, null);

		    Utils.BeginClassRegister(typeof(LPCFramework.SceneLoader), L, __CreateInstance, 1, 0, 0);
			
			
            
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "UnderlyingSystemType", typeof(LPCFramework.SceneLoader));
			
			
			Utils.EndClassRegister(typeof(LPCFramework.SceneLoader), L, translator);
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int __CreateInstance(RealStatePtr L)
        {
            
            ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			try {
				if(LuaAPI.lua_gettop(L) == 1)
				{
					
					LPCFramework.SceneLoader __cl_gen_ret = new LPCFramework.SceneLoader();
					translator.Push(L, __cl_gen_ret);
                    
					return 1;
				}
				
			}
			catch(System.Exception __gen_e) {
				return LuaAPI.luaL_error(L, "c# exception:" + __gen_e);
			}
            return LuaAPI.luaL_error(L, "invalid arguments to LPCFramework.SceneLoader constructor!");
            
        }
        
		
        
		
        
        
        
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_LoadScene(RealStatePtr L)
        {
            
            ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
            LPCFramework.SceneLoader __cl_gen_to_be_invoked = (LPCFramework.SceneLoader)translator.FastGetCSObj(L, 1);
            
            
			int __gen_param_count = LuaAPI.lua_gettop(L);
            
            try {
                if(__gen_param_count == 6&& (LuaAPI.lua_isnil(L, 2) || LuaAPI.lua_type(L, 2) == LuaTypes.LUA_TSTRING)&& translator.Assignable<System.Action>(L, 3)&& translator.Assignable<System.Action<int>>(L, 4)&& translator.Assignable<System.Action>(L, 5)&& translator.Assignable<System.Action<string>>(L, 6)) 
                {
                    string sceneName = LuaAPI.lua_tostring(L, 2);
                    System.Action funcStart = translator.GetDelegate<System.Action>(L, 3);
                    System.Action<int> funcUpdate = translator.GetDelegate<System.Action<int>>(L, 4);
                    System.Action funcComplete = translator.GetDelegate<System.Action>(L, 5);
                    System.Action<string> error = translator.GetDelegate<System.Action<string>>(L, 6);
                    
                    __cl_gen_to_be_invoked.LoadScene( sceneName, funcStart, funcUpdate, funcComplete, error );
                    
                    
                    
                    return 0;
                }
                if(__gen_param_count == 5&& (LuaAPI.lua_isnil(L, 2) || LuaAPI.lua_type(L, 2) == LuaTypes.LUA_TSTRING)&& translator.Assignable<System.Action>(L, 3)&& translator.Assignable<System.Action<int>>(L, 4)&& translator.Assignable<System.Action>(L, 5)) 
                {
                    string sceneName = LuaAPI.lua_tostring(L, 2);
                    System.Action funcStart = translator.GetDelegate<System.Action>(L, 3);
                    System.Action<int> funcUpdate = translator.GetDelegate<System.Action<int>>(L, 4);
                    System.Action funcComplete = translator.GetDelegate<System.Action>(L, 5);
                    
                    __cl_gen_to_be_invoked.LoadScene( sceneName, funcStart, funcUpdate, funcComplete );
                    
                    
                    
                    return 0;
                }
                if(__gen_param_count == 4&& (LuaAPI.lua_isnil(L, 2) || LuaAPI.lua_type(L, 2) == LuaTypes.LUA_TSTRING)&& translator.Assignable<System.Action>(L, 3)&& translator.Assignable<System.Action<int>>(L, 4)) 
                {
                    string sceneName = LuaAPI.lua_tostring(L, 2);
                    System.Action funcStart = translator.GetDelegate<System.Action>(L, 3);
                    System.Action<int> funcUpdate = translator.GetDelegate<System.Action<int>>(L, 4);
                    
                    __cl_gen_to_be_invoked.LoadScene( sceneName, funcStart, funcUpdate );
                    
                    
                    
                    return 0;
                }
                if(__gen_param_count == 3&& (LuaAPI.lua_isnil(L, 2) || LuaAPI.lua_type(L, 2) == LuaTypes.LUA_TSTRING)&& translator.Assignable<System.Action>(L, 3)) 
                {
                    string sceneName = LuaAPI.lua_tostring(L, 2);
                    System.Action funcStart = translator.GetDelegate<System.Action>(L, 3);
                    
                    __cl_gen_to_be_invoked.LoadScene( sceneName, funcStart );
                    
                    
                    
                    return 0;
                }
                if(__gen_param_count == 2&& (LuaAPI.lua_isnil(L, 2) || LuaAPI.lua_type(L, 2) == LuaTypes.LUA_TSTRING)) 
                {
                    string sceneName = LuaAPI.lua_tostring(L, 2);
                    
                    __cl_gen_to_be_invoked.LoadScene( sceneName );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception __gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + __gen_e);
            }
            
            return LuaAPI.luaL_error(L, "invalid arguments to LPCFramework.SceneLoader.LoadScene!");
            
        }
        
        
        
        
        
        
		
		
		
		
    }
}
