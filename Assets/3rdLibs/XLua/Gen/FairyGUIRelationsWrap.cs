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
    public class FairyGUIRelationsWrap
    {
        public static void __Register(RealStatePtr L)
        {
			ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			Utils.BeginObjectRegister(typeof(FairyGUI.Relations), L, translator, 0, 9, 2, 1);
			
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "Add", _m_Add);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "Remove", _m_Remove);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "Contains", _m_Contains);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "ClearFor", _m_ClearFor);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "ClearAll", _m_ClearAll);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "CopyFrom", _m_CopyFrom);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "Dispose", _m_Dispose);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "OnOwnerSizeChanged", _m_OnOwnerSizeChanged);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "Setup", _m_Setup);
			
			
			Utils.RegisterFunc(L, Utils.GETTER_IDX, "isEmpty", _g_get_isEmpty);
            Utils.RegisterFunc(L, Utils.GETTER_IDX, "handling", _g_get_handling);
            
			Utils.RegisterFunc(L, Utils.SETTER_IDX, "handling", _s_set_handling);
            
			Utils.EndObjectRegister(typeof(FairyGUI.Relations), L, translator, null, null,
			    null, null, null);

		    Utils.BeginClassRegister(typeof(FairyGUI.Relations), L, __CreateInstance, 1, 0, 0);
			
			
            
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "UnderlyingSystemType", typeof(FairyGUI.Relations));
			
			
			Utils.EndClassRegister(typeof(FairyGUI.Relations), L, translator);
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int __CreateInstance(RealStatePtr L)
        {
            
            ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			try {
				if(LuaAPI.lua_gettop(L) == 2 && translator.Assignable<FairyGUI.GObject>(L, 2))
				{
					FairyGUI.GObject owner = (FairyGUI.GObject)translator.GetObject(L, 2, typeof(FairyGUI.GObject));
					
					FairyGUI.Relations __cl_gen_ret = new FairyGUI.Relations(owner);
					translator.Push(L, __cl_gen_ret);
                    
					return 1;
				}
				
			}
			catch(System.Exception __gen_e) {
				return LuaAPI.luaL_error(L, "c# exception:" + __gen_e);
			}
            return LuaAPI.luaL_error(L, "invalid arguments to FairyGUI.Relations constructor!");
            
        }
        
		
        
		
        
        
        
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_Add(RealStatePtr L)
        {
            
            ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
            FairyGUI.Relations __cl_gen_to_be_invoked = (FairyGUI.Relations)translator.FastGetCSObj(L, 1);
            
            
			int __gen_param_count = LuaAPI.lua_gettop(L);
            
            try {
                if(__gen_param_count == 3&& translator.Assignable<FairyGUI.GObject>(L, 2)&& translator.Assignable<FairyGUI.RelationType>(L, 3)) 
                {
                    FairyGUI.GObject target = (FairyGUI.GObject)translator.GetObject(L, 2, typeof(FairyGUI.GObject));
                    FairyGUI.RelationType relationType;translator.Get(L, 3, out relationType);
                    
                    __cl_gen_to_be_invoked.Add( target, relationType );
                    
                    
                    
                    return 0;
                }
                if(__gen_param_count == 4&& translator.Assignable<FairyGUI.GObject>(L, 2)&& translator.Assignable<FairyGUI.RelationType>(L, 3)&& LuaTypes.LUA_TBOOLEAN == LuaAPI.lua_type(L, 4)) 
                {
                    FairyGUI.GObject target = (FairyGUI.GObject)translator.GetObject(L, 2, typeof(FairyGUI.GObject));
                    FairyGUI.RelationType relationType;translator.Get(L, 3, out relationType);
                    bool usePercent = LuaAPI.lua_toboolean(L, 4);
                    
                    __cl_gen_to_be_invoked.Add( target, relationType, usePercent );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception __gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + __gen_e);
            }
            
            return LuaAPI.luaL_error(L, "invalid arguments to FairyGUI.Relations.Add!");
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_Remove(RealStatePtr L)
        {
            
            ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
            FairyGUI.Relations __cl_gen_to_be_invoked = (FairyGUI.Relations)translator.FastGetCSObj(L, 1);
            
            
            try {
                
                {
                    FairyGUI.GObject target = (FairyGUI.GObject)translator.GetObject(L, 2, typeof(FairyGUI.GObject));
                    FairyGUI.RelationType relationType;translator.Get(L, 3, out relationType);
                    
                    __cl_gen_to_be_invoked.Remove( target, relationType );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception __gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + __gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_Contains(RealStatePtr L)
        {
            
            ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
            FairyGUI.Relations __cl_gen_to_be_invoked = (FairyGUI.Relations)translator.FastGetCSObj(L, 1);
            
            
            try {
                
                {
                    FairyGUI.GObject target = (FairyGUI.GObject)translator.GetObject(L, 2, typeof(FairyGUI.GObject));
                    
                        bool __cl_gen_ret = __cl_gen_to_be_invoked.Contains( target );
                        LuaAPI.lua_pushboolean(L, __cl_gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception __gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + __gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_ClearFor(RealStatePtr L)
        {
            
            ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
            FairyGUI.Relations __cl_gen_to_be_invoked = (FairyGUI.Relations)translator.FastGetCSObj(L, 1);
            
            
            try {
                
                {
                    FairyGUI.GObject target = (FairyGUI.GObject)translator.GetObject(L, 2, typeof(FairyGUI.GObject));
                    
                    __cl_gen_to_be_invoked.ClearFor( target );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception __gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + __gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_ClearAll(RealStatePtr L)
        {
            
            ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
            FairyGUI.Relations __cl_gen_to_be_invoked = (FairyGUI.Relations)translator.FastGetCSObj(L, 1);
            
            
            try {
                
                {
                    
                    __cl_gen_to_be_invoked.ClearAll(  );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception __gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + __gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_CopyFrom(RealStatePtr L)
        {
            
            ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
            FairyGUI.Relations __cl_gen_to_be_invoked = (FairyGUI.Relations)translator.FastGetCSObj(L, 1);
            
            
            try {
                
                {
                    FairyGUI.Relations source = (FairyGUI.Relations)translator.GetObject(L, 2, typeof(FairyGUI.Relations));
                    
                    __cl_gen_to_be_invoked.CopyFrom( source );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception __gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + __gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_Dispose(RealStatePtr L)
        {
            
            ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
            FairyGUI.Relations __cl_gen_to_be_invoked = (FairyGUI.Relations)translator.FastGetCSObj(L, 1);
            
            
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
        static int _m_OnOwnerSizeChanged(RealStatePtr L)
        {
            
            ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
            FairyGUI.Relations __cl_gen_to_be_invoked = (FairyGUI.Relations)translator.FastGetCSObj(L, 1);
            
            
            try {
                
                {
                    float dWidth = (float)LuaAPI.lua_tonumber(L, 2);
                    float dHeight = (float)LuaAPI.lua_tonumber(L, 3);
                    
                    __cl_gen_to_be_invoked.OnOwnerSizeChanged( dWidth, dHeight );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception __gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + __gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_Setup(RealStatePtr L)
        {
            
            ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
            FairyGUI.Relations __cl_gen_to_be_invoked = (FairyGUI.Relations)translator.FastGetCSObj(L, 1);
            
            
            try {
                
                {
                    FairyGUI.Utils.XML xml = (FairyGUI.Utils.XML)translator.GetObject(L, 2, typeof(FairyGUI.Utils.XML));
                    
                    __cl_gen_to_be_invoked.Setup( xml );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception __gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + __gen_e);
            }
            
        }
        
        
        
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_isEmpty(RealStatePtr L)
        {
            ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            try {
			
                FairyGUI.Relations __cl_gen_to_be_invoked = (FairyGUI.Relations)translator.FastGetCSObj(L, 1);
                LuaAPI.lua_pushboolean(L, __cl_gen_to_be_invoked.isEmpty);
            } catch(System.Exception __gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + __gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_handling(RealStatePtr L)
        {
            ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            try {
			
                FairyGUI.Relations __cl_gen_to_be_invoked = (FairyGUI.Relations)translator.FastGetCSObj(L, 1);
                translator.Push(L, __cl_gen_to_be_invoked.handling);
            } catch(System.Exception __gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + __gen_e);
            }
            return 1;
        }
        
        
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _s_set_handling(RealStatePtr L)
        {
            ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            try {
			
                FairyGUI.Relations __cl_gen_to_be_invoked = (FairyGUI.Relations)translator.FastGetCSObj(L, 1);
                __cl_gen_to_be_invoked.handling = (FairyGUI.GObject)translator.GetObject(L, 2, typeof(FairyGUI.GObject));
            
            } catch(System.Exception __gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + __gen_e);
            }
            return 0;
        }
        
		
		
		
		
    }
}
