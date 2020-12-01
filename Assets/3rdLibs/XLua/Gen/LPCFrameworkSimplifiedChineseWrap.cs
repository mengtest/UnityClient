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
    public class LPCFrameworkSimplifiedChineseWrap
    {
        public static void __Register(RealStatePtr L)
        {
			ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			Utils.BeginObjectRegister(typeof(LPCFramework.SimplifiedChinese), L, translator, 0, 0, 1, 1);
			
			
			
			Utils.RegisterFunc(L, Utils.GETTER_IDX, "UnicodeSc", _g_get_UnicodeSc);
            
			Utils.RegisterFunc(L, Utils.SETTER_IDX, "UnicodeSc", _s_set_UnicodeSc);
            
			Utils.EndObjectRegister(typeof(LPCFramework.SimplifiedChinese), L, translator, null, null,
			    null, null, null);

		    Utils.BeginClassRegister(typeof(LPCFramework.SimplifiedChinese), L, __CreateInstance, 1, 0, 0);
			
			
            
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "UnderlyingSystemType", typeof(LPCFramework.SimplifiedChinese));
			
			
			Utils.EndClassRegister(typeof(LPCFramework.SimplifiedChinese), L, translator);
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int __CreateInstance(RealStatePtr L)
        {
            
            ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			try {
				if(LuaAPI.lua_gettop(L) == 1)
				{
					
					LPCFramework.SimplifiedChinese __cl_gen_ret = new LPCFramework.SimplifiedChinese();
					translator.Push(L, __cl_gen_ret);
                    
					return 1;
				}
				
			}
			catch(System.Exception __gen_e) {
				return LuaAPI.luaL_error(L, "c# exception:" + __gen_e);
			}
            return LuaAPI.luaL_error(L, "invalid arguments to LPCFramework.SimplifiedChinese constructor!");
            
        }
        
		
        
		
        
        
        
        
        
        
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_UnicodeSc(RealStatePtr L)
        {
            ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            try {
			
                LPCFramework.SimplifiedChinese __cl_gen_to_be_invoked = (LPCFramework.SimplifiedChinese)translator.FastGetCSObj(L, 1);
                translator.Push(L, __cl_gen_to_be_invoked.UnicodeSc);
            } catch(System.Exception __gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + __gen_e);
            }
            return 1;
        }
        
        
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _s_set_UnicodeSc(RealStatePtr L)
        {
            ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            try {
			
                LPCFramework.SimplifiedChinese __cl_gen_to_be_invoked = (LPCFramework.SimplifiedChinese)translator.FastGetCSObj(L, 1);
                __cl_gen_to_be_invoked.UnicodeSc = (uint[])translator.GetObject(L, 2, typeof(uint[]));
            
            } catch(System.Exception __gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + __gen_e);
            }
            return 0;
        }
        
		
		
		
		
    }
}
