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
    public class FairyGUIGSliderWrap
    {
        public static void __Register(RealStatePtr L)
        {
			ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			Utils.BeginObjectRegister(typeof(FairyGUI.GSlider), L, translator, 0, 2, 5, 3);
			
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "ConstructFromXML", _m_ConstructFromXML);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "Setup_AfterAdd", _m_Setup_AfterAdd);
			
			
			Utils.RegisterFunc(L, Utils.GETTER_IDX, "onChanged", _g_get_onChanged);
            Utils.RegisterFunc(L, Utils.GETTER_IDX, "onGripTouchEnd", _g_get_onGripTouchEnd);
            Utils.RegisterFunc(L, Utils.GETTER_IDX, "titleType", _g_get_titleType);
            Utils.RegisterFunc(L, Utils.GETTER_IDX, "max", _g_get_max);
            Utils.RegisterFunc(L, Utils.GETTER_IDX, "value", _g_get_value);
            
			Utils.RegisterFunc(L, Utils.SETTER_IDX, "titleType", _s_set_titleType);
            Utils.RegisterFunc(L, Utils.SETTER_IDX, "max", _s_set_max);
            Utils.RegisterFunc(L, Utils.SETTER_IDX, "value", _s_set_value);
            
			Utils.EndObjectRegister(typeof(FairyGUI.GSlider), L, translator, null, null,
			    null, null, null);

		    Utils.BeginClassRegister(typeof(FairyGUI.GSlider), L, __CreateInstance, 1, 0, 0);
			
			
            
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "UnderlyingSystemType", typeof(FairyGUI.GSlider));
			
			
			Utils.EndClassRegister(typeof(FairyGUI.GSlider), L, translator);
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int __CreateInstance(RealStatePtr L)
        {
            
            ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			try {
				if(LuaAPI.lua_gettop(L) == 1)
				{
					
					FairyGUI.GSlider __cl_gen_ret = new FairyGUI.GSlider();
					translator.Push(L, __cl_gen_ret);
                    
					return 1;
				}
				
			}
			catch(System.Exception __gen_e) {
				return LuaAPI.luaL_error(L, "c# exception:" + __gen_e);
			}
            return LuaAPI.luaL_error(L, "invalid arguments to FairyGUI.GSlider constructor!");
            
        }
        
		
        
		
        
        
        
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_ConstructFromXML(RealStatePtr L)
        {
            
            ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
            FairyGUI.GSlider __cl_gen_to_be_invoked = (FairyGUI.GSlider)translator.FastGetCSObj(L, 1);
            
            
            try {
                
                {
                    FairyGUI.Utils.XML cxml = (FairyGUI.Utils.XML)translator.GetObject(L, 2, typeof(FairyGUI.Utils.XML));
                    
                    __cl_gen_to_be_invoked.ConstructFromXML( cxml );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception __gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + __gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_Setup_AfterAdd(RealStatePtr L)
        {
            
            ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
            FairyGUI.GSlider __cl_gen_to_be_invoked = (FairyGUI.GSlider)translator.FastGetCSObj(L, 1);
            
            
            try {
                
                {
                    FairyGUI.Utils.XML cxml = (FairyGUI.Utils.XML)translator.GetObject(L, 2, typeof(FairyGUI.Utils.XML));
                    
                    __cl_gen_to_be_invoked.Setup_AfterAdd( cxml );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception __gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + __gen_e);
            }
            
        }
        
        
        
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_onChanged(RealStatePtr L)
        {
            ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            try {
			
                FairyGUI.GSlider __cl_gen_to_be_invoked = (FairyGUI.GSlider)translator.FastGetCSObj(L, 1);
                translator.Push(L, __cl_gen_to_be_invoked.onChanged);
            } catch(System.Exception __gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + __gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_onGripTouchEnd(RealStatePtr L)
        {
            ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            try {
			
                FairyGUI.GSlider __cl_gen_to_be_invoked = (FairyGUI.GSlider)translator.FastGetCSObj(L, 1);
                translator.Push(L, __cl_gen_to_be_invoked.onGripTouchEnd);
            } catch(System.Exception __gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + __gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_titleType(RealStatePtr L)
        {
            ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            try {
			
                FairyGUI.GSlider __cl_gen_to_be_invoked = (FairyGUI.GSlider)translator.FastGetCSObj(L, 1);
                translator.Push(L, __cl_gen_to_be_invoked.titleType);
            } catch(System.Exception __gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + __gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_max(RealStatePtr L)
        {
            ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            try {
			
                FairyGUI.GSlider __cl_gen_to_be_invoked = (FairyGUI.GSlider)translator.FastGetCSObj(L, 1);
                LuaAPI.lua_pushnumber(L, __cl_gen_to_be_invoked.max);
            } catch(System.Exception __gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + __gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_value(RealStatePtr L)
        {
            ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            try {
			
                FairyGUI.GSlider __cl_gen_to_be_invoked = (FairyGUI.GSlider)translator.FastGetCSObj(L, 1);
                LuaAPI.lua_pushnumber(L, __cl_gen_to_be_invoked.value);
            } catch(System.Exception __gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + __gen_e);
            }
            return 1;
        }
        
        
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _s_set_titleType(RealStatePtr L)
        {
            ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            try {
			
                FairyGUI.GSlider __cl_gen_to_be_invoked = (FairyGUI.GSlider)translator.FastGetCSObj(L, 1);
                FairyGUI.ProgressTitleType __cl_gen_value;translator.Get(L, 2, out __cl_gen_value);
				__cl_gen_to_be_invoked.titleType = __cl_gen_value;
            
            } catch(System.Exception __gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + __gen_e);
            }
            return 0;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _s_set_max(RealStatePtr L)
        {
            ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            try {
			
                FairyGUI.GSlider __cl_gen_to_be_invoked = (FairyGUI.GSlider)translator.FastGetCSObj(L, 1);
                __cl_gen_to_be_invoked.max = LuaAPI.lua_tonumber(L, 2);
            
            } catch(System.Exception __gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + __gen_e);
            }
            return 0;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _s_set_value(RealStatePtr L)
        {
            ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            try {
			
                FairyGUI.GSlider __cl_gen_to_be_invoked = (FairyGUI.GSlider)translator.FastGetCSObj(L, 1);
                __cl_gen_to_be_invoked.value = LuaAPI.lua_tonumber(L, 2);
            
            } catch(System.Exception __gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + __gen_e);
            }
            return 0;
        }
        
		
		
		
		
    }
}
