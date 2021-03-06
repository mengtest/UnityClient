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
    public class FairyGUIGRootWrap
    {
        public static void __Register(RealStatePtr L)
        {
			ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			Utils.BeginObjectRegister(typeof(FairyGUI.GRoot), L, translator, 0, 22, 6, 2);
			
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "SetContentScaleFactor", _m_SetContentScaleFactor);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "ApplyContentScaleFactor", _m_ApplyContentScaleFactor);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "ShowWindow", _m_ShowWindow);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "HideWindow", _m_HideWindow);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "HideWindowImmediately", _m_HideWindowImmediately);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "BringToFront", _m_BringToFront);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "ShowModalWait", _m_ShowModalWait);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "CloseModalWait", _m_CloseModalWait);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "CloseAllExceptModals", _m_CloseAllExceptModals);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "CloseAllWindows", _m_CloseAllWindows);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "GetTopWindow", _m_GetTopWindow);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "DisplayObjectToGObject", _m_DisplayObjectToGObject);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "ShowPopup", _m_ShowPopup);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "GetPoupPosition", _m_GetPoupPosition);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "TogglePopup", _m_TogglePopup);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "HidePopup", _m_HidePopup);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "ShowTooltips", _m_ShowTooltips);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "ShowTooltipsWin", _m_ShowTooltipsWin);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "HideTooltips", _m_HideTooltips);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "EnableSound", _m_EnableSound);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "DisableSound", _m_DisableSound);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "PlayOneShotSound", _m_PlayOneShotSound);
			
			
			Utils.RegisterFunc(L, Utils.GETTER_IDX, "hasModalWindow", _g_get_hasModalWindow);
            Utils.RegisterFunc(L, Utils.GETTER_IDX, "modalWaiting", _g_get_modalWaiting);
            Utils.RegisterFunc(L, Utils.GETTER_IDX, "touchTarget", _g_get_touchTarget);
            Utils.RegisterFunc(L, Utils.GETTER_IDX, "hasAnyPopup", _g_get_hasAnyPopup);
            Utils.RegisterFunc(L, Utils.GETTER_IDX, "focus", _g_get_focus);
            Utils.RegisterFunc(L, Utils.GETTER_IDX, "soundVolume", _g_get_soundVolume);
            
			Utils.RegisterFunc(L, Utils.SETTER_IDX, "focus", _s_set_focus);
            Utils.RegisterFunc(L, Utils.SETTER_IDX, "soundVolume", _s_set_soundVolume);
            
			Utils.EndObjectRegister(typeof(FairyGUI.GRoot), L, translator, null, null,
			    null, null, null);

		    Utils.BeginClassRegister(typeof(FairyGUI.GRoot), L, __CreateInstance, 1, 2, 0);
			
			
            
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "UnderlyingSystemType", typeof(FairyGUI.GRoot));
			Utils.RegisterFunc(L, Utils.CLS_GETTER_IDX, "contentScaleFactor", _g_get_contentScaleFactor);
            Utils.RegisterFunc(L, Utils.CLS_GETTER_IDX, "inst", _g_get_inst);
            
			
			Utils.EndClassRegister(typeof(FairyGUI.GRoot), L, translator);
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int __CreateInstance(RealStatePtr L)
        {
            
            ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			try {
				if(LuaAPI.lua_gettop(L) == 1)
				{
					
					FairyGUI.GRoot __cl_gen_ret = new FairyGUI.GRoot();
					translator.Push(L, __cl_gen_ret);
                    
					return 1;
				}
				
			}
			catch(System.Exception __gen_e) {
				return LuaAPI.luaL_error(L, "c# exception:" + __gen_e);
			}
            return LuaAPI.luaL_error(L, "invalid arguments to FairyGUI.GRoot constructor!");
            
        }
        
		
        
		
        
        
        
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_SetContentScaleFactor(RealStatePtr L)
        {
            
            ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
            FairyGUI.GRoot __cl_gen_to_be_invoked = (FairyGUI.GRoot)translator.FastGetCSObj(L, 1);
            
            
			int __gen_param_count = LuaAPI.lua_gettop(L);
            
            try {
                if(__gen_param_count == 3&& LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 2)&& LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 3)) 
                {
                    int designResolutionX = LuaAPI.xlua_tointeger(L, 2);
                    int designResolutionY = LuaAPI.xlua_tointeger(L, 3);
                    
                    __cl_gen_to_be_invoked.SetContentScaleFactor( designResolutionX, designResolutionY );
                    
                    
                    
                    return 0;
                }
                if(__gen_param_count == 4&& LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 2)&& LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 3)&& translator.Assignable<FairyGUI.UIContentScaler.ScreenMatchMode>(L, 4)) 
                {
                    int designResolutionX = LuaAPI.xlua_tointeger(L, 2);
                    int designResolutionY = LuaAPI.xlua_tointeger(L, 3);
                    FairyGUI.UIContentScaler.ScreenMatchMode screenMatchMode;translator.Get(L, 4, out screenMatchMode);
                    
                    __cl_gen_to_be_invoked.SetContentScaleFactor( designResolutionX, designResolutionY, screenMatchMode );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception __gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + __gen_e);
            }
            
            return LuaAPI.luaL_error(L, "invalid arguments to FairyGUI.GRoot.SetContentScaleFactor!");
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_ApplyContentScaleFactor(RealStatePtr L)
        {
            
            ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
            FairyGUI.GRoot __cl_gen_to_be_invoked = (FairyGUI.GRoot)translator.FastGetCSObj(L, 1);
            
            
            try {
                
                {
                    
                    __cl_gen_to_be_invoked.ApplyContentScaleFactor(  );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception __gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + __gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_ShowWindow(RealStatePtr L)
        {
            
            ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
            FairyGUI.GRoot __cl_gen_to_be_invoked = (FairyGUI.GRoot)translator.FastGetCSObj(L, 1);
            
            
            try {
                
                {
                    FairyGUI.Window win = (FairyGUI.Window)translator.GetObject(L, 2, typeof(FairyGUI.Window));
                    
                    __cl_gen_to_be_invoked.ShowWindow( win );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception __gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + __gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_HideWindow(RealStatePtr L)
        {
            
            ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
            FairyGUI.GRoot __cl_gen_to_be_invoked = (FairyGUI.GRoot)translator.FastGetCSObj(L, 1);
            
            
            try {
                
                {
                    FairyGUI.Window win = (FairyGUI.Window)translator.GetObject(L, 2, typeof(FairyGUI.Window));
                    
                    __cl_gen_to_be_invoked.HideWindow( win );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception __gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + __gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_HideWindowImmediately(RealStatePtr L)
        {
            
            ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
            FairyGUI.GRoot __cl_gen_to_be_invoked = (FairyGUI.GRoot)translator.FastGetCSObj(L, 1);
            
            
			int __gen_param_count = LuaAPI.lua_gettop(L);
            
            try {
                if(__gen_param_count == 2&& translator.Assignable<FairyGUI.Window>(L, 2)) 
                {
                    FairyGUI.Window win = (FairyGUI.Window)translator.GetObject(L, 2, typeof(FairyGUI.Window));
                    
                    __cl_gen_to_be_invoked.HideWindowImmediately( win );
                    
                    
                    
                    return 0;
                }
                if(__gen_param_count == 3&& translator.Assignable<FairyGUI.Window>(L, 2)&& LuaTypes.LUA_TBOOLEAN == LuaAPI.lua_type(L, 3)) 
                {
                    FairyGUI.Window win = (FairyGUI.Window)translator.GetObject(L, 2, typeof(FairyGUI.Window));
                    bool dispose = LuaAPI.lua_toboolean(L, 3);
                    
                    __cl_gen_to_be_invoked.HideWindowImmediately( win, dispose );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception __gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + __gen_e);
            }
            
            return LuaAPI.luaL_error(L, "invalid arguments to FairyGUI.GRoot.HideWindowImmediately!");
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_BringToFront(RealStatePtr L)
        {
            
            ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
            FairyGUI.GRoot __cl_gen_to_be_invoked = (FairyGUI.GRoot)translator.FastGetCSObj(L, 1);
            
            
            try {
                
                {
                    FairyGUI.Window win = (FairyGUI.Window)translator.GetObject(L, 2, typeof(FairyGUI.Window));
                    
                    __cl_gen_to_be_invoked.BringToFront( win );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception __gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + __gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_ShowModalWait(RealStatePtr L)
        {
            
            ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
            FairyGUI.GRoot __cl_gen_to_be_invoked = (FairyGUI.GRoot)translator.FastGetCSObj(L, 1);
            
            
            try {
                
                {
                    
                    __cl_gen_to_be_invoked.ShowModalWait(  );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception __gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + __gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_CloseModalWait(RealStatePtr L)
        {
            
            ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
            FairyGUI.GRoot __cl_gen_to_be_invoked = (FairyGUI.GRoot)translator.FastGetCSObj(L, 1);
            
            
            try {
                
                {
                    
                    __cl_gen_to_be_invoked.CloseModalWait(  );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception __gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + __gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_CloseAllExceptModals(RealStatePtr L)
        {
            
            ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
            FairyGUI.GRoot __cl_gen_to_be_invoked = (FairyGUI.GRoot)translator.FastGetCSObj(L, 1);
            
            
            try {
                
                {
                    
                    __cl_gen_to_be_invoked.CloseAllExceptModals(  );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception __gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + __gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_CloseAllWindows(RealStatePtr L)
        {
            
            ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
            FairyGUI.GRoot __cl_gen_to_be_invoked = (FairyGUI.GRoot)translator.FastGetCSObj(L, 1);
            
            
            try {
                
                {
                    
                    __cl_gen_to_be_invoked.CloseAllWindows(  );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception __gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + __gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_GetTopWindow(RealStatePtr L)
        {
            
            ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
            FairyGUI.GRoot __cl_gen_to_be_invoked = (FairyGUI.GRoot)translator.FastGetCSObj(L, 1);
            
            
            try {
                
                {
                    
                        FairyGUI.Window __cl_gen_ret = __cl_gen_to_be_invoked.GetTopWindow(  );
                        translator.Push(L, __cl_gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception __gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + __gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_DisplayObjectToGObject(RealStatePtr L)
        {
            
            ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
            FairyGUI.GRoot __cl_gen_to_be_invoked = (FairyGUI.GRoot)translator.FastGetCSObj(L, 1);
            
            
            try {
                
                {
                    FairyGUI.DisplayObject obj = (FairyGUI.DisplayObject)translator.GetObject(L, 2, typeof(FairyGUI.DisplayObject));
                    
                        FairyGUI.GObject __cl_gen_ret = __cl_gen_to_be_invoked.DisplayObjectToGObject( obj );
                        translator.Push(L, __cl_gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception __gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + __gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_ShowPopup(RealStatePtr L)
        {
            
            ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
            FairyGUI.GRoot __cl_gen_to_be_invoked = (FairyGUI.GRoot)translator.FastGetCSObj(L, 1);
            
            
			int __gen_param_count = LuaAPI.lua_gettop(L);
            
            try {
                if(__gen_param_count == 2&& translator.Assignable<FairyGUI.GObject>(L, 2)) 
                {
                    FairyGUI.GObject popup = (FairyGUI.GObject)translator.GetObject(L, 2, typeof(FairyGUI.GObject));
                    
                    __cl_gen_to_be_invoked.ShowPopup( popup );
                    
                    
                    
                    return 0;
                }
                if(__gen_param_count == 3&& translator.Assignable<FairyGUI.GObject>(L, 2)&& translator.Assignable<FairyGUI.GObject>(L, 3)) 
                {
                    FairyGUI.GObject popup = (FairyGUI.GObject)translator.GetObject(L, 2, typeof(FairyGUI.GObject));
                    FairyGUI.GObject target = (FairyGUI.GObject)translator.GetObject(L, 3, typeof(FairyGUI.GObject));
                    
                    __cl_gen_to_be_invoked.ShowPopup( popup, target );
                    
                    
                    
                    return 0;
                }
                if(__gen_param_count == 4&& translator.Assignable<FairyGUI.GObject>(L, 2)&& translator.Assignable<FairyGUI.GObject>(L, 3)&& translator.Assignable<object>(L, 4)) 
                {
                    FairyGUI.GObject popup = (FairyGUI.GObject)translator.GetObject(L, 2, typeof(FairyGUI.GObject));
                    FairyGUI.GObject target = (FairyGUI.GObject)translator.GetObject(L, 3, typeof(FairyGUI.GObject));
                    object downward = translator.GetObject(L, 4, typeof(object));
                    
                    __cl_gen_to_be_invoked.ShowPopup( popup, target, downward );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception __gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + __gen_e);
            }
            
            return LuaAPI.luaL_error(L, "invalid arguments to FairyGUI.GRoot.ShowPopup!");
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_GetPoupPosition(RealStatePtr L)
        {
            
            ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
            FairyGUI.GRoot __cl_gen_to_be_invoked = (FairyGUI.GRoot)translator.FastGetCSObj(L, 1);
            
            
            try {
                
                {
                    FairyGUI.GObject popup = (FairyGUI.GObject)translator.GetObject(L, 2, typeof(FairyGUI.GObject));
                    FairyGUI.GObject target = (FairyGUI.GObject)translator.GetObject(L, 3, typeof(FairyGUI.GObject));
                    object downward = translator.GetObject(L, 4, typeof(object));
                    
                        UnityEngine.Vector2 __cl_gen_ret = __cl_gen_to_be_invoked.GetPoupPosition( popup, target, downward );
                        translator.PushUnityEngineVector2(L, __cl_gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception __gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + __gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_TogglePopup(RealStatePtr L)
        {
            
            ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
            FairyGUI.GRoot __cl_gen_to_be_invoked = (FairyGUI.GRoot)translator.FastGetCSObj(L, 1);
            
            
			int __gen_param_count = LuaAPI.lua_gettop(L);
            
            try {
                if(__gen_param_count == 2&& translator.Assignable<FairyGUI.GObject>(L, 2)) 
                {
                    FairyGUI.GObject popup = (FairyGUI.GObject)translator.GetObject(L, 2, typeof(FairyGUI.GObject));
                    
                    __cl_gen_to_be_invoked.TogglePopup( popup );
                    
                    
                    
                    return 0;
                }
                if(__gen_param_count == 3&& translator.Assignable<FairyGUI.GObject>(L, 2)&& translator.Assignable<FairyGUI.GObject>(L, 3)) 
                {
                    FairyGUI.GObject popup = (FairyGUI.GObject)translator.GetObject(L, 2, typeof(FairyGUI.GObject));
                    FairyGUI.GObject target = (FairyGUI.GObject)translator.GetObject(L, 3, typeof(FairyGUI.GObject));
                    
                    __cl_gen_to_be_invoked.TogglePopup( popup, target );
                    
                    
                    
                    return 0;
                }
                if(__gen_param_count == 4&& translator.Assignable<FairyGUI.GObject>(L, 2)&& translator.Assignable<FairyGUI.GObject>(L, 3)&& translator.Assignable<object>(L, 4)) 
                {
                    FairyGUI.GObject popup = (FairyGUI.GObject)translator.GetObject(L, 2, typeof(FairyGUI.GObject));
                    FairyGUI.GObject target = (FairyGUI.GObject)translator.GetObject(L, 3, typeof(FairyGUI.GObject));
                    object downward = translator.GetObject(L, 4, typeof(object));
                    
                    __cl_gen_to_be_invoked.TogglePopup( popup, target, downward );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception __gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + __gen_e);
            }
            
            return LuaAPI.luaL_error(L, "invalid arguments to FairyGUI.GRoot.TogglePopup!");
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_HidePopup(RealStatePtr L)
        {
            
            ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
            FairyGUI.GRoot __cl_gen_to_be_invoked = (FairyGUI.GRoot)translator.FastGetCSObj(L, 1);
            
            
			int __gen_param_count = LuaAPI.lua_gettop(L);
            
            try {
                if(__gen_param_count == 1) 
                {
                    
                    __cl_gen_to_be_invoked.HidePopup(  );
                    
                    
                    
                    return 0;
                }
                if(__gen_param_count == 2&& translator.Assignable<FairyGUI.GObject>(L, 2)) 
                {
                    FairyGUI.GObject popup = (FairyGUI.GObject)translator.GetObject(L, 2, typeof(FairyGUI.GObject));
                    
                    __cl_gen_to_be_invoked.HidePopup( popup );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception __gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + __gen_e);
            }
            
            return LuaAPI.luaL_error(L, "invalid arguments to FairyGUI.GRoot.HidePopup!");
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_ShowTooltips(RealStatePtr L)
        {
            
            ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
            FairyGUI.GRoot __cl_gen_to_be_invoked = (FairyGUI.GRoot)translator.FastGetCSObj(L, 1);
            
            
            try {
                
                {
                    string msg = LuaAPI.lua_tostring(L, 2);
                    
                    __cl_gen_to_be_invoked.ShowTooltips( msg );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception __gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + __gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_ShowTooltipsWin(RealStatePtr L)
        {
            
            ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
            FairyGUI.GRoot __cl_gen_to_be_invoked = (FairyGUI.GRoot)translator.FastGetCSObj(L, 1);
            
            
            try {
                
                {
                    FairyGUI.GObject tooltipWin = (FairyGUI.GObject)translator.GetObject(L, 2, typeof(FairyGUI.GObject));
                    
                    __cl_gen_to_be_invoked.ShowTooltipsWin( tooltipWin );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception __gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + __gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_HideTooltips(RealStatePtr L)
        {
            
            ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
            FairyGUI.GRoot __cl_gen_to_be_invoked = (FairyGUI.GRoot)translator.FastGetCSObj(L, 1);
            
            
            try {
                
                {
                    
                    __cl_gen_to_be_invoked.HideTooltips(  );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception __gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + __gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_EnableSound(RealStatePtr L)
        {
            
            ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
            FairyGUI.GRoot __cl_gen_to_be_invoked = (FairyGUI.GRoot)translator.FastGetCSObj(L, 1);
            
            
            try {
                
                {
                    
                    __cl_gen_to_be_invoked.EnableSound(  );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception __gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + __gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_DisableSound(RealStatePtr L)
        {
            
            ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
            FairyGUI.GRoot __cl_gen_to_be_invoked = (FairyGUI.GRoot)translator.FastGetCSObj(L, 1);
            
            
            try {
                
                {
                    
                    __cl_gen_to_be_invoked.DisableSound(  );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception __gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + __gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_PlayOneShotSound(RealStatePtr L)
        {
            
            ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
            FairyGUI.GRoot __cl_gen_to_be_invoked = (FairyGUI.GRoot)translator.FastGetCSObj(L, 1);
            
            
			int __gen_param_count = LuaAPI.lua_gettop(L);
            
            try {
                if(__gen_param_count == 2&& translator.Assignable<UnityEngine.AudioClip>(L, 2)) 
                {
                    UnityEngine.AudioClip clip = (UnityEngine.AudioClip)translator.GetObject(L, 2, typeof(UnityEngine.AudioClip));
                    
                    __cl_gen_to_be_invoked.PlayOneShotSound( clip );
                    
                    
                    
                    return 0;
                }
                if(__gen_param_count == 3&& translator.Assignable<UnityEngine.AudioClip>(L, 2)&& LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 3)) 
                {
                    UnityEngine.AudioClip clip = (UnityEngine.AudioClip)translator.GetObject(L, 2, typeof(UnityEngine.AudioClip));
                    float volumeScale = (float)LuaAPI.lua_tonumber(L, 3);
                    
                    __cl_gen_to_be_invoked.PlayOneShotSound( clip, volumeScale );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception __gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + __gen_e);
            }
            
            return LuaAPI.luaL_error(L, "invalid arguments to FairyGUI.GRoot.PlayOneShotSound!");
            
        }
        
        
        
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_contentScaleFactor(RealStatePtr L)
        {
            
            try {
			    LuaAPI.lua_pushnumber(L, FairyGUI.GRoot.contentScaleFactor);
            } catch(System.Exception __gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + __gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_inst(RealStatePtr L)
        {
            ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            try {
			    translator.Push(L, FairyGUI.GRoot.inst);
            } catch(System.Exception __gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + __gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_hasModalWindow(RealStatePtr L)
        {
            ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            try {
			
                FairyGUI.GRoot __cl_gen_to_be_invoked = (FairyGUI.GRoot)translator.FastGetCSObj(L, 1);
                LuaAPI.lua_pushboolean(L, __cl_gen_to_be_invoked.hasModalWindow);
            } catch(System.Exception __gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + __gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_modalWaiting(RealStatePtr L)
        {
            ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            try {
			
                FairyGUI.GRoot __cl_gen_to_be_invoked = (FairyGUI.GRoot)translator.FastGetCSObj(L, 1);
                LuaAPI.lua_pushboolean(L, __cl_gen_to_be_invoked.modalWaiting);
            } catch(System.Exception __gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + __gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_touchTarget(RealStatePtr L)
        {
            ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            try {
			
                FairyGUI.GRoot __cl_gen_to_be_invoked = (FairyGUI.GRoot)translator.FastGetCSObj(L, 1);
                translator.Push(L, __cl_gen_to_be_invoked.touchTarget);
            } catch(System.Exception __gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + __gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_hasAnyPopup(RealStatePtr L)
        {
            ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            try {
			
                FairyGUI.GRoot __cl_gen_to_be_invoked = (FairyGUI.GRoot)translator.FastGetCSObj(L, 1);
                LuaAPI.lua_pushboolean(L, __cl_gen_to_be_invoked.hasAnyPopup);
            } catch(System.Exception __gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + __gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_focus(RealStatePtr L)
        {
            ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            try {
			
                FairyGUI.GRoot __cl_gen_to_be_invoked = (FairyGUI.GRoot)translator.FastGetCSObj(L, 1);
                translator.Push(L, __cl_gen_to_be_invoked.focus);
            } catch(System.Exception __gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + __gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_soundVolume(RealStatePtr L)
        {
            ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            try {
			
                FairyGUI.GRoot __cl_gen_to_be_invoked = (FairyGUI.GRoot)translator.FastGetCSObj(L, 1);
                LuaAPI.lua_pushnumber(L, __cl_gen_to_be_invoked.soundVolume);
            } catch(System.Exception __gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + __gen_e);
            }
            return 1;
        }
        
        
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _s_set_focus(RealStatePtr L)
        {
            ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            try {
			
                FairyGUI.GRoot __cl_gen_to_be_invoked = (FairyGUI.GRoot)translator.FastGetCSObj(L, 1);
                __cl_gen_to_be_invoked.focus = (FairyGUI.GObject)translator.GetObject(L, 2, typeof(FairyGUI.GObject));
            
            } catch(System.Exception __gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + __gen_e);
            }
            return 0;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _s_set_soundVolume(RealStatePtr L)
        {
            ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            try {
			
                FairyGUI.GRoot __cl_gen_to_be_invoked = (FairyGUI.GRoot)translator.FastGetCSObj(L, 1);
                __cl_gen_to_be_invoked.soundVolume = (float)LuaAPI.lua_tonumber(L, 2);
            
            } catch(System.Exception __gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + __gen_e);
            }
            return 0;
        }
        
		
		
		
		
    }
}
