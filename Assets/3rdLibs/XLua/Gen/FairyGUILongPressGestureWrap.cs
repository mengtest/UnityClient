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
    public class FairyGUILongPressGestureWrap
    {
        public static void __Register(RealStatePtr L)
        {
			ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			Utils.BeginObjectRegister(typeof(FairyGUI.LongPressGesture), L, translator, 0, 3, 8, 4);
			
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "Dispose", _m_Dispose);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "Enable", _m_Enable);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "Cancel", _m_Cancel);
			
			
			Utils.RegisterFunc(L, Utils.GETTER_IDX, "host", _g_get_host);
            Utils.RegisterFunc(L, Utils.GETTER_IDX, "onBegin", _g_get_onBegin);
            Utils.RegisterFunc(L, Utils.GETTER_IDX, "onEnd", _g_get_onEnd);
            Utils.RegisterFunc(L, Utils.GETTER_IDX, "onAction", _g_get_onAction);
            Utils.RegisterFunc(L, Utils.GETTER_IDX, "trigger", _g_get_trigger);
            Utils.RegisterFunc(L, Utils.GETTER_IDX, "interval", _g_get_interval);
            Utils.RegisterFunc(L, Utils.GETTER_IDX, "once", _g_get_once);
            Utils.RegisterFunc(L, Utils.GETTER_IDX, "holdRangeRadius", _g_get_holdRangeRadius);
            
			Utils.RegisterFunc(L, Utils.SETTER_IDX, "trigger", _s_set_trigger);
            Utils.RegisterFunc(L, Utils.SETTER_IDX, "interval", _s_set_interval);
            Utils.RegisterFunc(L, Utils.SETTER_IDX, "once", _s_set_once);
            Utils.RegisterFunc(L, Utils.SETTER_IDX, "holdRangeRadius", _s_set_holdRangeRadius);
            
			Utils.EndObjectRegister(typeof(FairyGUI.LongPressGesture), L, translator, null, null,
			    null, null, null);

		    Utils.BeginClassRegister(typeof(FairyGUI.LongPressGesture), L, __CreateInstance, 1, 2, 2);
			
			
            
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "UnderlyingSystemType", typeof(FairyGUI.LongPressGesture));
			Utils.RegisterFunc(L, Utils.CLS_GETTER_IDX, "TRIGGER", _g_get_TRIGGER);
            Utils.RegisterFunc(L, Utils.CLS_GETTER_IDX, "INTERVAL", _g_get_INTERVAL);
            
			Utils.RegisterFunc(L, Utils.CLS_SETTER_IDX, "TRIGGER", _s_set_TRIGGER);
            Utils.RegisterFunc(L, Utils.CLS_SETTER_IDX, "INTERVAL", _s_set_INTERVAL);
            
			Utils.EndClassRegister(typeof(FairyGUI.LongPressGesture), L, translator);
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int __CreateInstance(RealStatePtr L)
        {
            
            ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			try {
				if(LuaAPI.lua_gettop(L) == 2 && translator.Assignable<FairyGUI.GObject>(L, 2))
				{
					FairyGUI.GObject host = (FairyGUI.GObject)translator.GetObject(L, 2, typeof(FairyGUI.GObject));
					
					FairyGUI.LongPressGesture __cl_gen_ret = new FairyGUI.LongPressGesture(host);
					translator.Push(L, __cl_gen_ret);
                    
					return 1;
				}
				
			}
			catch(System.Exception __gen_e) {
				return LuaAPI.luaL_error(L, "c# exception:" + __gen_e);
			}
            return LuaAPI.luaL_error(L, "invalid arguments to FairyGUI.LongPressGesture constructor!");
            
        }
        
		
        
		
        
        
        
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_Dispose(RealStatePtr L)
        {
            
            ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
            FairyGUI.LongPressGesture __cl_gen_to_be_invoked = (FairyGUI.LongPressGesture)translator.FastGetCSObj(L, 1);
            
            
            try {
                
                {
                    
                    __cl_gen_to_be_invoked.Dispose(  );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception __gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + __gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_Enable(RealStatePtr L)
        {
            
            ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
            FairyGUI.LongPressGesture __cl_gen_to_be_invoked = (FairyGUI.LongPressGesture)translator.FastGetCSObj(L, 1);
            
            
            try {
                
                {
                    bool value = LuaAPI.lua_toboolean(L, 2);
                    
                    __cl_gen_to_be_invoked.Enable( value );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception __gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + __gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_Cancel(RealStatePtr L)
        {
            
            ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
            FairyGUI.LongPressGesture __cl_gen_to_be_invoked = (FairyGUI.LongPressGesture)translator.FastGetCSObj(L, 1);
            
            
            try {
                
                {
                    
                    __cl_gen_to_be_invoked.Cancel(  );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception __gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + __gen_e);
            }
            
        }
        
        
        
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_host(RealStatePtr L)
        {
            ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            try {
			
                FairyGUI.LongPressGesture __cl_gen_to_be_invoked = (FairyGUI.LongPressGesture)translator.FastGetCSObj(L, 1);
                translator.Push(L, __cl_gen_to_be_invoked.host);
            } catch(System.Exception __gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + __gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_onBegin(RealStatePtr L)
        {
            ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            try {
			
                FairyGUI.LongPressGesture __cl_gen_to_be_invoked = (FairyGUI.LongPressGesture)translator.FastGetCSObj(L, 1);
                translator.Push(L, __cl_gen_to_be_invoked.onBegin);
            } catch(System.Exception __gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + __gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_onEnd(RealStatePtr L)
        {
            ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            try {
			
                FairyGUI.LongPressGesture __cl_gen_to_be_invoked = (FairyGUI.LongPressGesture)translator.FastGetCSObj(L, 1);
                translator.Push(L, __cl_gen_to_be_invoked.onEnd);
            } catch(System.Exception __gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + __gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_onAction(RealStatePtr L)
        {
            ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            try {
			
                FairyGUI.LongPressGesture __cl_gen_to_be_invoked = (FairyGUI.LongPressGesture)translator.FastGetCSObj(L, 1);
                translator.Push(L, __cl_gen_to_be_invoked.onAction);
            } catch(System.Exception __gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + __gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_trigger(RealStatePtr L)
        {
            ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            try {
			
                FairyGUI.LongPressGesture __cl_gen_to_be_invoked = (FairyGUI.LongPressGesture)translator.FastGetCSObj(L, 1);
                LuaAPI.lua_pushnumber(L, __cl_gen_to_be_invoked.trigger);
            } catch(System.Exception __gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + __gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_interval(RealStatePtr L)
        {
            ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            try {
			
                FairyGUI.LongPressGesture __cl_gen_to_be_invoked = (FairyGUI.LongPressGesture)translator.FastGetCSObj(L, 1);
                LuaAPI.lua_pushnumber(L, __cl_gen_to_be_invoked.interval);
            } catch(System.Exception __gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + __gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_once(RealStatePtr L)
        {
            ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            try {
			
                FairyGUI.LongPressGesture __cl_gen_to_be_invoked = (FairyGUI.LongPressGesture)translator.FastGetCSObj(L, 1);
                LuaAPI.lua_pushboolean(L, __cl_gen_to_be_invoked.once);
            } catch(System.Exception __gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + __gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_holdRangeRadius(RealStatePtr L)
        {
            ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            try {
			
                FairyGUI.LongPressGesture __cl_gen_to_be_invoked = (FairyGUI.LongPressGesture)translator.FastGetCSObj(L, 1);
                LuaAPI.xlua_pushinteger(L, __cl_gen_to_be_invoked.holdRangeRadius);
            } catch(System.Exception __gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + __gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_TRIGGER(RealStatePtr L)
        {
            
            try {
			    LuaAPI.lua_pushnumber(L, FairyGUI.LongPressGesture.TRIGGER);
            } catch(System.Exception __gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + __gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_INTERVAL(RealStatePtr L)
        {
            
            try {
			    LuaAPI.lua_pushnumber(L, FairyGUI.LongPressGesture.INTERVAL);
            } catch(System.Exception __gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + __gen_e);
            }
            return 1;
        }
        
        
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _s_set_trigger(RealStatePtr L)
        {
            ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            try {
			
                FairyGUI.LongPressGesture __cl_gen_to_be_invoked = (FairyGUI.LongPressGesture)translator.FastGetCSObj(L, 1);
                __cl_gen_to_be_invoked.trigger = (float)LuaAPI.lua_tonumber(L, 2);
            
            } catch(System.Exception __gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + __gen_e);
            }
            return 0;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _s_set_interval(RealStatePtr L)
        {
            ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            try {
			
                FairyGUI.LongPressGesture __cl_gen_to_be_invoked = (FairyGUI.LongPressGesture)translator.FastGetCSObj(L, 1);
                __cl_gen_to_be_invoked.interval = (float)LuaAPI.lua_tonumber(L, 2);
            
            } catch(System.Exception __gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + __gen_e);
            }
            return 0;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _s_set_once(RealStatePtr L)
        {
            ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            try {
			
                FairyGUI.LongPressGesture __cl_gen_to_be_invoked = (FairyGUI.LongPressGesture)translator.FastGetCSObj(L, 1);
                __cl_gen_to_be_invoked.once = LuaAPI.lua_toboolean(L, 2);
            
            } catch(System.Exception __gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + __gen_e);
            }
            return 0;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _s_set_holdRangeRadius(RealStatePtr L)
        {
            ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            try {
			
                FairyGUI.LongPressGesture __cl_gen_to_be_invoked = (FairyGUI.LongPressGesture)translator.FastGetCSObj(L, 1);
                __cl_gen_to_be_invoked.holdRangeRadius = LuaAPI.xlua_tointeger(L, 2);
            
            } catch(System.Exception __gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + __gen_e);
            }
            return 0;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _s_set_TRIGGER(RealStatePtr L)
        {
            
            try {
			    FairyGUI.LongPressGesture.TRIGGER = (float)LuaAPI.lua_tonumber(L, 1);
            
            } catch(System.Exception __gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + __gen_e);
            }
            return 0;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _s_set_INTERVAL(RealStatePtr L)
        {
            
            try {
			    FairyGUI.LongPressGesture.INTERVAL = (float)LuaAPI.lua_tonumber(L, 1);
            
            } catch(System.Exception __gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + __gen_e);
            }
            return 0;
        }
        
		
		
		
		
    }
}
