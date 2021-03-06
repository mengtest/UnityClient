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
    public class FairyGUIEventListenerWrap
    {
        public static void __Register(RealStatePtr L)
        {
			ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			Utils.BeginObjectRegister(typeof(FairyGUI.EventListener), L, translator, 0, 9, 4, 0);
			
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "AddCapture", _m_AddCapture);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "RemoveCapture", _m_RemoveCapture);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "Add", _m_Add);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "Remove", _m_Remove);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "Set", _m_Set);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "Clear", _m_Clear);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "Call", _m_Call);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "BubbleCall", _m_BubbleCall);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "BroadcastCall", _m_BroadcastCall);
			
			
			Utils.RegisterFunc(L, Utils.GETTER_IDX, "owner", _g_get_owner);
            Utils.RegisterFunc(L, Utils.GETTER_IDX, "type", _g_get_type);
            Utils.RegisterFunc(L, Utils.GETTER_IDX, "isEmpty", _g_get_isEmpty);
            Utils.RegisterFunc(L, Utils.GETTER_IDX, "isDispatching", _g_get_isDispatching);
            
			
			Utils.EndObjectRegister(typeof(FairyGUI.EventListener), L, translator, null, null,
			    null, null, null);

		    Utils.BeginClassRegister(typeof(FairyGUI.EventListener), L, __CreateInstance, 1, 0, 0);
			
			
            
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "UnderlyingSystemType", typeof(FairyGUI.EventListener));
			
			
			Utils.EndClassRegister(typeof(FairyGUI.EventListener), L, translator);
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int __CreateInstance(RealStatePtr L)
        {
            
            ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			try {
				if(LuaAPI.lua_gettop(L) == 3 && translator.Assignable<FairyGUI.EventDispatcher>(L, 2) && (LuaAPI.lua_isnil(L, 3) || LuaAPI.lua_type(L, 3) == LuaTypes.LUA_TSTRING))
				{
					FairyGUI.EventDispatcher owner = (FairyGUI.EventDispatcher)translator.GetObject(L, 2, typeof(FairyGUI.EventDispatcher));
					string type = LuaAPI.lua_tostring(L, 3);
					
					FairyGUI.EventListener __cl_gen_ret = new FairyGUI.EventListener(owner, type);
					translator.Push(L, __cl_gen_ret);
                    
					return 1;
				}
				
			}
			catch(System.Exception __gen_e) {
				return LuaAPI.luaL_error(L, "c# exception:" + __gen_e);
			}
            return LuaAPI.luaL_error(L, "invalid arguments to FairyGUI.EventListener constructor!");
            
        }
        
		
        
		
        
        
        
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_AddCapture(RealStatePtr L)
        {
            
            ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
            FairyGUI.EventListener __cl_gen_to_be_invoked = (FairyGUI.EventListener)translator.FastGetCSObj(L, 1);
            
            
            try {
                
                {
                    FairyGUI.EventCallback1 callback = translator.GetDelegate<FairyGUI.EventCallback1>(L, 2);
                    
                    __cl_gen_to_be_invoked.AddCapture( callback );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception __gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + __gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_RemoveCapture(RealStatePtr L)
        {
            
            ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
            FairyGUI.EventListener __cl_gen_to_be_invoked = (FairyGUI.EventListener)translator.FastGetCSObj(L, 1);
            
            
            try {
                
                {
                    FairyGUI.EventCallback1 callback = translator.GetDelegate<FairyGUI.EventCallback1>(L, 2);
                    
                    __cl_gen_to_be_invoked.RemoveCapture( callback );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception __gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + __gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_Add(RealStatePtr L)
        {
            
            ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
            FairyGUI.EventListener __cl_gen_to_be_invoked = (FairyGUI.EventListener)translator.FastGetCSObj(L, 1);
            
            
			int __gen_param_count = LuaAPI.lua_gettop(L);
            
            try {
                if(__gen_param_count == 2&& translator.Assignable<FairyGUI.EventCallback1>(L, 2)) 
                {
                    FairyGUI.EventCallback1 callback = translator.GetDelegate<FairyGUI.EventCallback1>(L, 2);
                    
                    __cl_gen_to_be_invoked.Add( callback );
                    
                    
                    
                    return 0;
                }
                if(__gen_param_count == 2&& translator.Assignable<FairyGUI.EventCallback0>(L, 2)) 
                {
                    FairyGUI.EventCallback0 callback = translator.GetDelegate<FairyGUI.EventCallback0>(L, 2);
                    
                    __cl_gen_to_be_invoked.Add( callback );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception __gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + __gen_e);
            }
            
            return LuaAPI.luaL_error(L, "invalid arguments to FairyGUI.EventListener.Add!");
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_Remove(RealStatePtr L)
        {
            
            ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
            FairyGUI.EventListener __cl_gen_to_be_invoked = (FairyGUI.EventListener)translator.FastGetCSObj(L, 1);
            
            
			int __gen_param_count = LuaAPI.lua_gettop(L);
            
            try {
                if(__gen_param_count == 2&& translator.Assignable<FairyGUI.EventCallback1>(L, 2)) 
                {
                    FairyGUI.EventCallback1 callback = translator.GetDelegate<FairyGUI.EventCallback1>(L, 2);
                    
                    __cl_gen_to_be_invoked.Remove( callback );
                    
                    
                    
                    return 0;
                }
                if(__gen_param_count == 2&& translator.Assignable<FairyGUI.EventCallback0>(L, 2)) 
                {
                    FairyGUI.EventCallback0 callback = translator.GetDelegate<FairyGUI.EventCallback0>(L, 2);
                    
                    __cl_gen_to_be_invoked.Remove( callback );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception __gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + __gen_e);
            }
            
            return LuaAPI.luaL_error(L, "invalid arguments to FairyGUI.EventListener.Remove!");
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_Set(RealStatePtr L)
        {
            
            ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
            FairyGUI.EventListener __cl_gen_to_be_invoked = (FairyGUI.EventListener)translator.FastGetCSObj(L, 1);
            
            
			int __gen_param_count = LuaAPI.lua_gettop(L);
            
            try {
                if(__gen_param_count == 2&& translator.Assignable<FairyGUI.EventCallback0>(L, 2)) 
                {
                    FairyGUI.EventCallback0 callback = translator.GetDelegate<FairyGUI.EventCallback0>(L, 2);
                    
                    __cl_gen_to_be_invoked.Set( callback );
                    
                    
                    
                    return 0;
                }
                if(__gen_param_count == 2&& translator.Assignable<FairyGUI.EventCallback1>(L, 2)) 
                {
                    FairyGUI.EventCallback1 callback = translator.GetDelegate<FairyGUI.EventCallback1>(L, 2);
                    
                    __cl_gen_to_be_invoked.Set( callback );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception __gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + __gen_e);
            }
            
            return LuaAPI.luaL_error(L, "invalid arguments to FairyGUI.EventListener.Set!");
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_Clear(RealStatePtr L)
        {
            
            ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
            FairyGUI.EventListener __cl_gen_to_be_invoked = (FairyGUI.EventListener)translator.FastGetCSObj(L, 1);
            
            
            try {
                
                {
                    
                    __cl_gen_to_be_invoked.Clear(  );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception __gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + __gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_Call(RealStatePtr L)
        {
            
            ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
            FairyGUI.EventListener __cl_gen_to_be_invoked = (FairyGUI.EventListener)translator.FastGetCSObj(L, 1);
            
            
			int __gen_param_count = LuaAPI.lua_gettop(L);
            
            try {
                if(__gen_param_count == 1) 
                {
                    
                        bool __cl_gen_ret = __cl_gen_to_be_invoked.Call(  );
                        LuaAPI.lua_pushboolean(L, __cl_gen_ret);
                    
                    
                    
                    return 1;
                }
                if(__gen_param_count == 2&& translator.Assignable<object>(L, 2)) 
                {
                    object data = translator.GetObject(L, 2, typeof(object));
                    
                        bool __cl_gen_ret = __cl_gen_to_be_invoked.Call( data );
                        LuaAPI.lua_pushboolean(L, __cl_gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception __gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + __gen_e);
            }
            
            return LuaAPI.luaL_error(L, "invalid arguments to FairyGUI.EventListener.Call!");
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_BubbleCall(RealStatePtr L)
        {
            
            ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
            FairyGUI.EventListener __cl_gen_to_be_invoked = (FairyGUI.EventListener)translator.FastGetCSObj(L, 1);
            
            
			int __gen_param_count = LuaAPI.lua_gettop(L);
            
            try {
                if(__gen_param_count == 1) 
                {
                    
                        bool __cl_gen_ret = __cl_gen_to_be_invoked.BubbleCall(  );
                        LuaAPI.lua_pushboolean(L, __cl_gen_ret);
                    
                    
                    
                    return 1;
                }
                if(__gen_param_count == 2&& translator.Assignable<object>(L, 2)) 
                {
                    object data = translator.GetObject(L, 2, typeof(object));
                    
                        bool __cl_gen_ret = __cl_gen_to_be_invoked.BubbleCall( data );
                        LuaAPI.lua_pushboolean(L, __cl_gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception __gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + __gen_e);
            }
            
            return LuaAPI.luaL_error(L, "invalid arguments to FairyGUI.EventListener.BubbleCall!");
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_BroadcastCall(RealStatePtr L)
        {
            
            ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
            FairyGUI.EventListener __cl_gen_to_be_invoked = (FairyGUI.EventListener)translator.FastGetCSObj(L, 1);
            
            
			int __gen_param_count = LuaAPI.lua_gettop(L);
            
            try {
                if(__gen_param_count == 1) 
                {
                    
                        bool __cl_gen_ret = __cl_gen_to_be_invoked.BroadcastCall(  );
                        LuaAPI.lua_pushboolean(L, __cl_gen_ret);
                    
                    
                    
                    return 1;
                }
                if(__gen_param_count == 2&& translator.Assignable<object>(L, 2)) 
                {
                    object data = translator.GetObject(L, 2, typeof(object));
                    
                        bool __cl_gen_ret = __cl_gen_to_be_invoked.BroadcastCall( data );
                        LuaAPI.lua_pushboolean(L, __cl_gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception __gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + __gen_e);
            }
            
            return LuaAPI.luaL_error(L, "invalid arguments to FairyGUI.EventListener.BroadcastCall!");
            
        }
        
        
        
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_owner(RealStatePtr L)
        {
            ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            try {
			
                FairyGUI.EventListener __cl_gen_to_be_invoked = (FairyGUI.EventListener)translator.FastGetCSObj(L, 1);
                translator.Push(L, __cl_gen_to_be_invoked.owner);
            } catch(System.Exception __gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + __gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_type(RealStatePtr L)
        {
            ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            try {
			
                FairyGUI.EventListener __cl_gen_to_be_invoked = (FairyGUI.EventListener)translator.FastGetCSObj(L, 1);
                LuaAPI.lua_pushstring(L, __cl_gen_to_be_invoked.type);
            } catch(System.Exception __gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + __gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_isEmpty(RealStatePtr L)
        {
            ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            try {
			
                FairyGUI.EventListener __cl_gen_to_be_invoked = (FairyGUI.EventListener)translator.FastGetCSObj(L, 1);
                LuaAPI.lua_pushboolean(L, __cl_gen_to_be_invoked.isEmpty);
            } catch(System.Exception __gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + __gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_isDispatching(RealStatePtr L)
        {
            ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            try {
			
                FairyGUI.EventListener __cl_gen_to_be_invoked = (FairyGUI.EventListener)translator.FastGetCSObj(L, 1);
                LuaAPI.lua_pushboolean(L, __cl_gen_to_be_invoked.isDispatching);
            } catch(System.Exception __gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + __gen_e);
            }
            return 1;
        }
        
        
        
		
		
		
		
    }
}
