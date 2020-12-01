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
    public class FairyGUIContainerWrap
    {
        public static void __Register(RealStatePtr L)
        {
			ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			Utils.BeginObjectRegister(typeof(FairyGUI.Container), L, translator, 0, 22, 14, 13);
			
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "AddChild", _m_AddChild);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "AddChildAt", _m_AddChildAt);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "Contains", _m_Contains);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "GetChildAt", _m_GetChildAt);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "GetChild", _m_GetChild);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "GetChildIndex", _m_GetChildIndex);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "RemoveChild", _m_RemoveChild);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "RemoveChildAt", _m_RemoveChildAt);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "RemoveChildren", _m_RemoveChildren);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "SetChildIndex", _m_SetChildIndex);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "SwapChildren", _m_SwapChildren);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "SwapChildrenAt", _m_SwapChildrenAt);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "ChangeChildrenOrder", _m_ChangeChildrenOrder);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "GetBounds", _m_GetBounds);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "GetRenderCamera", _m_GetRenderCamera);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "HitTest", _m_HitTest);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "GetHitTestLocalPoint", _m_GetHitTestLocalPoint);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "IsAncestorOf", _m_IsAncestorOf);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "InvalidateBatchingState", _m_InvalidateBatchingState);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "SetChildrenLayer", _m_SetChildrenLayer);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "Update", _m_Update);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "Dispose", _m_Dispose);
			
			
			Utils.RegisterFunc(L, Utils.GETTER_IDX, "numChildren", _g_get_numChildren);
            Utils.RegisterFunc(L, Utils.GETTER_IDX, "clipRect", _g_get_clipRect);
            Utils.RegisterFunc(L, Utils.GETTER_IDX, "mask", _g_get_mask);
            Utils.RegisterFunc(L, Utils.GETTER_IDX, "touchable", _g_get_touchable);
            Utils.RegisterFunc(L, Utils.GETTER_IDX, "contentRect", _g_get_contentRect);
            Utils.RegisterFunc(L, Utils.GETTER_IDX, "fairyBatching", _g_get_fairyBatching);
            Utils.RegisterFunc(L, Utils.GETTER_IDX, "renderMode", _g_get_renderMode);
            Utils.RegisterFunc(L, Utils.GETTER_IDX, "renderCamera", _g_get_renderCamera);
            Utils.RegisterFunc(L, Utils.GETTER_IDX, "opaque", _g_get_opaque);
            Utils.RegisterFunc(L, Utils.GETTER_IDX, "clipSoftness", _g_get_clipSoftness);
            Utils.RegisterFunc(L, Utils.GETTER_IDX, "hitArea", _g_get_hitArea);
            Utils.RegisterFunc(L, Utils.GETTER_IDX, "touchChildren", _g_get_touchChildren);
            Utils.RegisterFunc(L, Utils.GETTER_IDX, "onUpdate", _g_get_onUpdate);
            Utils.RegisterFunc(L, Utils.GETTER_IDX, "reversedMask", _g_get_reversedMask);
            
			Utils.RegisterFunc(L, Utils.SETTER_IDX, "clipRect", _s_set_clipRect);
            Utils.RegisterFunc(L, Utils.SETTER_IDX, "mask", _s_set_mask);
            Utils.RegisterFunc(L, Utils.SETTER_IDX, "touchable", _s_set_touchable);
            Utils.RegisterFunc(L, Utils.SETTER_IDX, "contentRect", _s_set_contentRect);
            Utils.RegisterFunc(L, Utils.SETTER_IDX, "fairyBatching", _s_set_fairyBatching);
            Utils.RegisterFunc(L, Utils.SETTER_IDX, "renderMode", _s_set_renderMode);
            Utils.RegisterFunc(L, Utils.SETTER_IDX, "renderCamera", _s_set_renderCamera);
            Utils.RegisterFunc(L, Utils.SETTER_IDX, "opaque", _s_set_opaque);
            Utils.RegisterFunc(L, Utils.SETTER_IDX, "clipSoftness", _s_set_clipSoftness);
            Utils.RegisterFunc(L, Utils.SETTER_IDX, "hitArea", _s_set_hitArea);
            Utils.RegisterFunc(L, Utils.SETTER_IDX, "touchChildren", _s_set_touchChildren);
            Utils.RegisterFunc(L, Utils.SETTER_IDX, "onUpdate", _s_set_onUpdate);
            Utils.RegisterFunc(L, Utils.SETTER_IDX, "reversedMask", _s_set_reversedMask);
            
			Utils.EndObjectRegister(typeof(FairyGUI.Container), L, translator, null, null,
			    null, null, null);

		    Utils.BeginClassRegister(typeof(FairyGUI.Container), L, __CreateInstance, 1, 0, 0);
			
			
            
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "UnderlyingSystemType", typeof(FairyGUI.Container));
			
			
			Utils.EndClassRegister(typeof(FairyGUI.Container), L, translator);
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int __CreateInstance(RealStatePtr L)
        {
            
            ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			try {
				if(LuaAPI.lua_gettop(L) == 1)
				{
					
					FairyGUI.Container __cl_gen_ret = new FairyGUI.Container();
					translator.Push(L, __cl_gen_ret);
                    
					return 1;
				}
				if(LuaAPI.lua_gettop(L) == 2 && (LuaAPI.lua_isnil(L, 2) || LuaAPI.lua_type(L, 2) == LuaTypes.LUA_TSTRING))
				{
					string gameObjectName = LuaAPI.lua_tostring(L, 2);
					
					FairyGUI.Container __cl_gen_ret = new FairyGUI.Container(gameObjectName);
					translator.Push(L, __cl_gen_ret);
                    
					return 1;
				}
				if(LuaAPI.lua_gettop(L) == 2 && translator.Assignable<UnityEngine.GameObject>(L, 2))
				{
					UnityEngine.GameObject attachTarget = (UnityEngine.GameObject)translator.GetObject(L, 2, typeof(UnityEngine.GameObject));
					
					FairyGUI.Container __cl_gen_ret = new FairyGUI.Container(attachTarget);
					translator.Push(L, __cl_gen_ret);
                    
					return 1;
				}
				
			}
			catch(System.Exception __gen_e) {
				return LuaAPI.luaL_error(L, "c# exception:" + __gen_e);
			}
            return LuaAPI.luaL_error(L, "invalid arguments to FairyGUI.Container constructor!");
            
        }
        
		
        
		
        
        
        
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_AddChild(RealStatePtr L)
        {
            
            ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
            FairyGUI.Container __cl_gen_to_be_invoked = (FairyGUI.Container)translator.FastGetCSObj(L, 1);
            
            
            try {
                
                {
                    FairyGUI.DisplayObject child = (FairyGUI.DisplayObject)translator.GetObject(L, 2, typeof(FairyGUI.DisplayObject));
                    
                        FairyGUI.DisplayObject __cl_gen_ret = __cl_gen_to_be_invoked.AddChild( child );
                        translator.Push(L, __cl_gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception __gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + __gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_AddChildAt(RealStatePtr L)
        {
            
            ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
            FairyGUI.Container __cl_gen_to_be_invoked = (FairyGUI.Container)translator.FastGetCSObj(L, 1);
            
            
            try {
                
                {
                    FairyGUI.DisplayObject child = (FairyGUI.DisplayObject)translator.GetObject(L, 2, typeof(FairyGUI.DisplayObject));
                    int index = LuaAPI.xlua_tointeger(L, 3);
                    
                        FairyGUI.DisplayObject __cl_gen_ret = __cl_gen_to_be_invoked.AddChildAt( child, index );
                        translator.Push(L, __cl_gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception __gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + __gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_Contains(RealStatePtr L)
        {
            
            ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
            FairyGUI.Container __cl_gen_to_be_invoked = (FairyGUI.Container)translator.FastGetCSObj(L, 1);
            
            
            try {
                
                {
                    FairyGUI.DisplayObject child = (FairyGUI.DisplayObject)translator.GetObject(L, 2, typeof(FairyGUI.DisplayObject));
                    
                        bool __cl_gen_ret = __cl_gen_to_be_invoked.Contains( child );
                        LuaAPI.lua_pushboolean(L, __cl_gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception __gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + __gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_GetChildAt(RealStatePtr L)
        {
            
            ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
            FairyGUI.Container __cl_gen_to_be_invoked = (FairyGUI.Container)translator.FastGetCSObj(L, 1);
            
            
            try {
                
                {
                    int index = LuaAPI.xlua_tointeger(L, 2);
                    
                        FairyGUI.DisplayObject __cl_gen_ret = __cl_gen_to_be_invoked.GetChildAt( index );
                        translator.Push(L, __cl_gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception __gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + __gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_GetChild(RealStatePtr L)
        {
            
            ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
            FairyGUI.Container __cl_gen_to_be_invoked = (FairyGUI.Container)translator.FastGetCSObj(L, 1);
            
            
            try {
                
                {
                    string name = LuaAPI.lua_tostring(L, 2);
                    
                        FairyGUI.DisplayObject __cl_gen_ret = __cl_gen_to_be_invoked.GetChild( name );
                        translator.Push(L, __cl_gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception __gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + __gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_GetChildIndex(RealStatePtr L)
        {
            
            ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
            FairyGUI.Container __cl_gen_to_be_invoked = (FairyGUI.Container)translator.FastGetCSObj(L, 1);
            
            
            try {
                
                {
                    FairyGUI.DisplayObject child = (FairyGUI.DisplayObject)translator.GetObject(L, 2, typeof(FairyGUI.DisplayObject));
                    
                        int __cl_gen_ret = __cl_gen_to_be_invoked.GetChildIndex( child );
                        LuaAPI.xlua_pushinteger(L, __cl_gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception __gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + __gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_RemoveChild(RealStatePtr L)
        {
            
            ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
            FairyGUI.Container __cl_gen_to_be_invoked = (FairyGUI.Container)translator.FastGetCSObj(L, 1);
            
            
			int __gen_param_count = LuaAPI.lua_gettop(L);
            
            try {
                if(__gen_param_count == 2&& translator.Assignable<FairyGUI.DisplayObject>(L, 2)) 
                {
                    FairyGUI.DisplayObject child = (FairyGUI.DisplayObject)translator.GetObject(L, 2, typeof(FairyGUI.DisplayObject));
                    
                        FairyGUI.DisplayObject __cl_gen_ret = __cl_gen_to_be_invoked.RemoveChild( child );
                        translator.Push(L, __cl_gen_ret);
                    
                    
                    
                    return 1;
                }
                if(__gen_param_count == 3&& translator.Assignable<FairyGUI.DisplayObject>(L, 2)&& LuaTypes.LUA_TBOOLEAN == LuaAPI.lua_type(L, 3)) 
                {
                    FairyGUI.DisplayObject child = (FairyGUI.DisplayObject)translator.GetObject(L, 2, typeof(FairyGUI.DisplayObject));
                    bool dispose = LuaAPI.lua_toboolean(L, 3);
                    
                        FairyGUI.DisplayObject __cl_gen_ret = __cl_gen_to_be_invoked.RemoveChild( child, dispose );
                        translator.Push(L, __cl_gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception __gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + __gen_e);
            }
            
            return LuaAPI.luaL_error(L, "invalid arguments to FairyGUI.Container.RemoveChild!");
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_RemoveChildAt(RealStatePtr L)
        {
            
            ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
            FairyGUI.Container __cl_gen_to_be_invoked = (FairyGUI.Container)translator.FastGetCSObj(L, 1);
            
            
			int __gen_param_count = LuaAPI.lua_gettop(L);
            
            try {
                if(__gen_param_count == 2&& LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 2)) 
                {
                    int index = LuaAPI.xlua_tointeger(L, 2);
                    
                        FairyGUI.DisplayObject __cl_gen_ret = __cl_gen_to_be_invoked.RemoveChildAt( index );
                        translator.Push(L, __cl_gen_ret);
                    
                    
                    
                    return 1;
                }
                if(__gen_param_count == 3&& LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 2)&& LuaTypes.LUA_TBOOLEAN == LuaAPI.lua_type(L, 3)) 
                {
                    int index = LuaAPI.xlua_tointeger(L, 2);
                    bool dispose = LuaAPI.lua_toboolean(L, 3);
                    
                        FairyGUI.DisplayObject __cl_gen_ret = __cl_gen_to_be_invoked.RemoveChildAt( index, dispose );
                        translator.Push(L, __cl_gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception __gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + __gen_e);
            }
            
            return LuaAPI.luaL_error(L, "invalid arguments to FairyGUI.Container.RemoveChildAt!");
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_RemoveChildren(RealStatePtr L)
        {
            
            ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
            FairyGUI.Container __cl_gen_to_be_invoked = (FairyGUI.Container)translator.FastGetCSObj(L, 1);
            
            
			int __gen_param_count = LuaAPI.lua_gettop(L);
            
            try {
                if(__gen_param_count == 1) 
                {
                    
                    __cl_gen_to_be_invoked.RemoveChildren(  );
                    
                    
                    
                    return 0;
                }
                if(__gen_param_count == 4&& LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 2)&& LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 3)&& LuaTypes.LUA_TBOOLEAN == LuaAPI.lua_type(L, 4)) 
                {
                    int beginIndex = LuaAPI.xlua_tointeger(L, 2);
                    int endIndex = LuaAPI.xlua_tointeger(L, 3);
                    bool dispose = LuaAPI.lua_toboolean(L, 4);
                    
                    __cl_gen_to_be_invoked.RemoveChildren( beginIndex, endIndex, dispose );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception __gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + __gen_e);
            }
            
            return LuaAPI.luaL_error(L, "invalid arguments to FairyGUI.Container.RemoveChildren!");
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_SetChildIndex(RealStatePtr L)
        {
            
            ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
            FairyGUI.Container __cl_gen_to_be_invoked = (FairyGUI.Container)translator.FastGetCSObj(L, 1);
            
            
            try {
                
                {
                    FairyGUI.DisplayObject child = (FairyGUI.DisplayObject)translator.GetObject(L, 2, typeof(FairyGUI.DisplayObject));
                    int index = LuaAPI.xlua_tointeger(L, 3);
                    
                    __cl_gen_to_be_invoked.SetChildIndex( child, index );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception __gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + __gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_SwapChildren(RealStatePtr L)
        {
            
            ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
            FairyGUI.Container __cl_gen_to_be_invoked = (FairyGUI.Container)translator.FastGetCSObj(L, 1);
            
            
            try {
                
                {
                    FairyGUI.DisplayObject child1 = (FairyGUI.DisplayObject)translator.GetObject(L, 2, typeof(FairyGUI.DisplayObject));
                    FairyGUI.DisplayObject child2 = (FairyGUI.DisplayObject)translator.GetObject(L, 3, typeof(FairyGUI.DisplayObject));
                    
                    __cl_gen_to_be_invoked.SwapChildren( child1, child2 );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception __gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + __gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_SwapChildrenAt(RealStatePtr L)
        {
            
            ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
            FairyGUI.Container __cl_gen_to_be_invoked = (FairyGUI.Container)translator.FastGetCSObj(L, 1);
            
            
            try {
                
                {
                    int index1 = LuaAPI.xlua_tointeger(L, 2);
                    int index2 = LuaAPI.xlua_tointeger(L, 3);
                    
                    __cl_gen_to_be_invoked.SwapChildrenAt( index1, index2 );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception __gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + __gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_ChangeChildrenOrder(RealStatePtr L)
        {
            
            ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
            FairyGUI.Container __cl_gen_to_be_invoked = (FairyGUI.Container)translator.FastGetCSObj(L, 1);
            
            
            try {
                
                {
                    System.Collections.Generic.List<int> indice = (System.Collections.Generic.List<int>)translator.GetObject(L, 2, typeof(System.Collections.Generic.List<int>));
                    System.Collections.Generic.List<FairyGUI.DisplayObject> objs = (System.Collections.Generic.List<FairyGUI.DisplayObject>)translator.GetObject(L, 3, typeof(System.Collections.Generic.List<FairyGUI.DisplayObject>));
                    
                    __cl_gen_to_be_invoked.ChangeChildrenOrder( indice, objs );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception __gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + __gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_GetBounds(RealStatePtr L)
        {
            
            ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
            FairyGUI.Container __cl_gen_to_be_invoked = (FairyGUI.Container)translator.FastGetCSObj(L, 1);
            
            
            try {
                
                {
                    FairyGUI.DisplayObject targetSpace = (FairyGUI.DisplayObject)translator.GetObject(L, 2, typeof(FairyGUI.DisplayObject));
                    
                        UnityEngine.Rect __cl_gen_ret = __cl_gen_to_be_invoked.GetBounds( targetSpace );
                        translator.Push(L, __cl_gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception __gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + __gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_GetRenderCamera(RealStatePtr L)
        {
            
            ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
            FairyGUI.Container __cl_gen_to_be_invoked = (FairyGUI.Container)translator.FastGetCSObj(L, 1);
            
            
            try {
                
                {
                    
                        UnityEngine.Camera __cl_gen_ret = __cl_gen_to_be_invoked.GetRenderCamera(  );
                        translator.Push(L, __cl_gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception __gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + __gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_HitTest(RealStatePtr L)
        {
            
            ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
            FairyGUI.Container __cl_gen_to_be_invoked = (FairyGUI.Container)translator.FastGetCSObj(L, 1);
            
            
            try {
                
                {
                    UnityEngine.Vector2 stagePoint;translator.Get(L, 2, out stagePoint);
                    bool forTouch = LuaAPI.lua_toboolean(L, 3);
                    
                        FairyGUI.DisplayObject __cl_gen_ret = __cl_gen_to_be_invoked.HitTest( stagePoint, forTouch );
                        translator.Push(L, __cl_gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception __gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + __gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_GetHitTestLocalPoint(RealStatePtr L)
        {
            
            ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
            FairyGUI.Container __cl_gen_to_be_invoked = (FairyGUI.Container)translator.FastGetCSObj(L, 1);
            
            
            try {
                
                {
                    
                        UnityEngine.Vector2 __cl_gen_ret = __cl_gen_to_be_invoked.GetHitTestLocalPoint(  );
                        translator.PushUnityEngineVector2(L, __cl_gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception __gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + __gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_IsAncestorOf(RealStatePtr L)
        {
            
            ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
            FairyGUI.Container __cl_gen_to_be_invoked = (FairyGUI.Container)translator.FastGetCSObj(L, 1);
            
            
            try {
                
                {
                    FairyGUI.DisplayObject obj = (FairyGUI.DisplayObject)translator.GetObject(L, 2, typeof(FairyGUI.DisplayObject));
                    
                        bool __cl_gen_ret = __cl_gen_to_be_invoked.IsAncestorOf( obj );
                        LuaAPI.lua_pushboolean(L, __cl_gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception __gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + __gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_InvalidateBatchingState(RealStatePtr L)
        {
            
            ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
            FairyGUI.Container __cl_gen_to_be_invoked = (FairyGUI.Container)translator.FastGetCSObj(L, 1);
            
            
            try {
                
                {
                    bool childrenChanged = LuaAPI.lua_toboolean(L, 2);
                    
                    __cl_gen_to_be_invoked.InvalidateBatchingState( childrenChanged );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception __gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + __gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_SetChildrenLayer(RealStatePtr L)
        {
            
            ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
            FairyGUI.Container __cl_gen_to_be_invoked = (FairyGUI.Container)translator.FastGetCSObj(L, 1);
            
            
            try {
                
                {
                    int value = LuaAPI.xlua_tointeger(L, 2);
                    
                    __cl_gen_to_be_invoked.SetChildrenLayer( value );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception __gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + __gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_Update(RealStatePtr L)
        {
            
            ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
            FairyGUI.Container __cl_gen_to_be_invoked = (FairyGUI.Container)translator.FastGetCSObj(L, 1);
            
            
            try {
                
                {
                    FairyGUI.UpdateContext context = (FairyGUI.UpdateContext)translator.GetObject(L, 2, typeof(FairyGUI.UpdateContext));
                    
                    __cl_gen_to_be_invoked.Update( context );
                    
                    
                    
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
            
            
            FairyGUI.Container __cl_gen_to_be_invoked = (FairyGUI.Container)translator.FastGetCSObj(L, 1);
            
            
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
        static int _g_get_numChildren(RealStatePtr L)
        {
            ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            try {
			
                FairyGUI.Container __cl_gen_to_be_invoked = (FairyGUI.Container)translator.FastGetCSObj(L, 1);
                LuaAPI.xlua_pushinteger(L, __cl_gen_to_be_invoked.numChildren);
            } catch(System.Exception __gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + __gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_clipRect(RealStatePtr L)
        {
            ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            try {
			
                FairyGUI.Container __cl_gen_to_be_invoked = (FairyGUI.Container)translator.FastGetCSObj(L, 1);
                translator.Push(L, __cl_gen_to_be_invoked.clipRect);
            } catch(System.Exception __gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + __gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_mask(RealStatePtr L)
        {
            ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            try {
			
                FairyGUI.Container __cl_gen_to_be_invoked = (FairyGUI.Container)translator.FastGetCSObj(L, 1);
                translator.Push(L, __cl_gen_to_be_invoked.mask);
            } catch(System.Exception __gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + __gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_touchable(RealStatePtr L)
        {
            ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            try {
			
                FairyGUI.Container __cl_gen_to_be_invoked = (FairyGUI.Container)translator.FastGetCSObj(L, 1);
                LuaAPI.lua_pushboolean(L, __cl_gen_to_be_invoked.touchable);
            } catch(System.Exception __gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + __gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_contentRect(RealStatePtr L)
        {
            ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            try {
			
                FairyGUI.Container __cl_gen_to_be_invoked = (FairyGUI.Container)translator.FastGetCSObj(L, 1);
                translator.Push(L, __cl_gen_to_be_invoked.contentRect);
            } catch(System.Exception __gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + __gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_fairyBatching(RealStatePtr L)
        {
            ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            try {
			
                FairyGUI.Container __cl_gen_to_be_invoked = (FairyGUI.Container)translator.FastGetCSObj(L, 1);
                LuaAPI.lua_pushboolean(L, __cl_gen_to_be_invoked.fairyBatching);
            } catch(System.Exception __gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + __gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_renderMode(RealStatePtr L)
        {
            ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            try {
			
                FairyGUI.Container __cl_gen_to_be_invoked = (FairyGUI.Container)translator.FastGetCSObj(L, 1);
                translator.Push(L, __cl_gen_to_be_invoked.renderMode);
            } catch(System.Exception __gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + __gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_renderCamera(RealStatePtr L)
        {
            ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            try {
			
                FairyGUI.Container __cl_gen_to_be_invoked = (FairyGUI.Container)translator.FastGetCSObj(L, 1);
                translator.Push(L, __cl_gen_to_be_invoked.renderCamera);
            } catch(System.Exception __gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + __gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_opaque(RealStatePtr L)
        {
            ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            try {
			
                FairyGUI.Container __cl_gen_to_be_invoked = (FairyGUI.Container)translator.FastGetCSObj(L, 1);
                LuaAPI.lua_pushboolean(L, __cl_gen_to_be_invoked.opaque);
            } catch(System.Exception __gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + __gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_clipSoftness(RealStatePtr L)
        {
            ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            try {
			
                FairyGUI.Container __cl_gen_to_be_invoked = (FairyGUI.Container)translator.FastGetCSObj(L, 1);
                translator.Push(L, __cl_gen_to_be_invoked.clipSoftness);
            } catch(System.Exception __gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + __gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_hitArea(RealStatePtr L)
        {
            ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            try {
			
                FairyGUI.Container __cl_gen_to_be_invoked = (FairyGUI.Container)translator.FastGetCSObj(L, 1);
                translator.Push(L, __cl_gen_to_be_invoked.hitArea);
            } catch(System.Exception __gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + __gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_touchChildren(RealStatePtr L)
        {
            ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            try {
			
                FairyGUI.Container __cl_gen_to_be_invoked = (FairyGUI.Container)translator.FastGetCSObj(L, 1);
                LuaAPI.lua_pushboolean(L, __cl_gen_to_be_invoked.touchChildren);
            } catch(System.Exception __gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + __gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_onUpdate(RealStatePtr L)
        {
            ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            try {
			
                FairyGUI.Container __cl_gen_to_be_invoked = (FairyGUI.Container)translator.FastGetCSObj(L, 1);
                translator.Push(L, __cl_gen_to_be_invoked.onUpdate);
            } catch(System.Exception __gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + __gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_reversedMask(RealStatePtr L)
        {
            ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            try {
			
                FairyGUI.Container __cl_gen_to_be_invoked = (FairyGUI.Container)translator.FastGetCSObj(L, 1);
                LuaAPI.lua_pushboolean(L, __cl_gen_to_be_invoked.reversedMask);
            } catch(System.Exception __gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + __gen_e);
            }
            return 1;
        }
        
        
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _s_set_clipRect(RealStatePtr L)
        {
            ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            try {
			
                FairyGUI.Container __cl_gen_to_be_invoked = (FairyGUI.Container)translator.FastGetCSObj(L, 1);
                System.Nullable<UnityEngine.Rect> __cl_gen_value;translator.Get(L, 2, out __cl_gen_value);
				__cl_gen_to_be_invoked.clipRect = __cl_gen_value;
            
            } catch(System.Exception __gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + __gen_e);
            }
            return 0;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _s_set_mask(RealStatePtr L)
        {
            ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            try {
			
                FairyGUI.Container __cl_gen_to_be_invoked = (FairyGUI.Container)translator.FastGetCSObj(L, 1);
                __cl_gen_to_be_invoked.mask = (FairyGUI.DisplayObject)translator.GetObject(L, 2, typeof(FairyGUI.DisplayObject));
            
            } catch(System.Exception __gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + __gen_e);
            }
            return 0;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _s_set_touchable(RealStatePtr L)
        {
            ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            try {
			
                FairyGUI.Container __cl_gen_to_be_invoked = (FairyGUI.Container)translator.FastGetCSObj(L, 1);
                __cl_gen_to_be_invoked.touchable = LuaAPI.lua_toboolean(L, 2);
            
            } catch(System.Exception __gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + __gen_e);
            }
            return 0;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _s_set_contentRect(RealStatePtr L)
        {
            ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            try {
			
                FairyGUI.Container __cl_gen_to_be_invoked = (FairyGUI.Container)translator.FastGetCSObj(L, 1);
                UnityEngine.Rect __cl_gen_value;translator.Get(L, 2, out __cl_gen_value);
				__cl_gen_to_be_invoked.contentRect = __cl_gen_value;
            
            } catch(System.Exception __gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + __gen_e);
            }
            return 0;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _s_set_fairyBatching(RealStatePtr L)
        {
            ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            try {
			
                FairyGUI.Container __cl_gen_to_be_invoked = (FairyGUI.Container)translator.FastGetCSObj(L, 1);
                __cl_gen_to_be_invoked.fairyBatching = LuaAPI.lua_toboolean(L, 2);
            
            } catch(System.Exception __gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + __gen_e);
            }
            return 0;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _s_set_renderMode(RealStatePtr L)
        {
            ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            try {
			
                FairyGUI.Container __cl_gen_to_be_invoked = (FairyGUI.Container)translator.FastGetCSObj(L, 1);
                UnityEngine.RenderMode __cl_gen_value;translator.Get(L, 2, out __cl_gen_value);
				__cl_gen_to_be_invoked.renderMode = __cl_gen_value;
            
            } catch(System.Exception __gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + __gen_e);
            }
            return 0;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _s_set_renderCamera(RealStatePtr L)
        {
            ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            try {
			
                FairyGUI.Container __cl_gen_to_be_invoked = (FairyGUI.Container)translator.FastGetCSObj(L, 1);
                __cl_gen_to_be_invoked.renderCamera = (UnityEngine.Camera)translator.GetObject(L, 2, typeof(UnityEngine.Camera));
            
            } catch(System.Exception __gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + __gen_e);
            }
            return 0;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _s_set_opaque(RealStatePtr L)
        {
            ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            try {
			
                FairyGUI.Container __cl_gen_to_be_invoked = (FairyGUI.Container)translator.FastGetCSObj(L, 1);
                __cl_gen_to_be_invoked.opaque = LuaAPI.lua_toboolean(L, 2);
            
            } catch(System.Exception __gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + __gen_e);
            }
            return 0;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _s_set_clipSoftness(RealStatePtr L)
        {
            ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            try {
			
                FairyGUI.Container __cl_gen_to_be_invoked = (FairyGUI.Container)translator.FastGetCSObj(L, 1);
                System.Nullable<UnityEngine.Vector4> __cl_gen_value;translator.Get(L, 2, out __cl_gen_value);
				__cl_gen_to_be_invoked.clipSoftness = __cl_gen_value;
            
            } catch(System.Exception __gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + __gen_e);
            }
            return 0;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _s_set_hitArea(RealStatePtr L)
        {
            ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            try {
			
                FairyGUI.Container __cl_gen_to_be_invoked = (FairyGUI.Container)translator.FastGetCSObj(L, 1);
                __cl_gen_to_be_invoked.hitArea = (FairyGUI.IHitTest)translator.GetObject(L, 2, typeof(FairyGUI.IHitTest));
            
            } catch(System.Exception __gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + __gen_e);
            }
            return 0;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _s_set_touchChildren(RealStatePtr L)
        {
            ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            try {
			
                FairyGUI.Container __cl_gen_to_be_invoked = (FairyGUI.Container)translator.FastGetCSObj(L, 1);
                __cl_gen_to_be_invoked.touchChildren = LuaAPI.lua_toboolean(L, 2);
            
            } catch(System.Exception __gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + __gen_e);
            }
            return 0;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _s_set_onUpdate(RealStatePtr L)
        {
            ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            try {
			
                FairyGUI.Container __cl_gen_to_be_invoked = (FairyGUI.Container)translator.FastGetCSObj(L, 1);
                __cl_gen_to_be_invoked.onUpdate = translator.GetDelegate<FairyGUI.EventCallback0>(L, 2);
            
            } catch(System.Exception __gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + __gen_e);
            }
            return 0;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _s_set_reversedMask(RealStatePtr L)
        {
            ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            try {
			
                FairyGUI.Container __cl_gen_to_be_invoked = (FairyGUI.Container)translator.FastGetCSObj(L, 1);
                __cl_gen_to_be_invoked.reversedMask = LuaAPI.lua_toboolean(L, 2);
            
            } catch(System.Exception __gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + __gen_e);
            }
            return 0;
        }
        
		
		
		
		
    }
}
