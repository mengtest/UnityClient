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
    public class FairyGUIGTextInputWrap
    {
        public static void __Register(RealStatePtr L)
        {
			ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			Utils.BeginObjectRegister(typeof(FairyGUI.GTextInput), L, translator, 0, 2, 15, 11);
			
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "ReplaceSelection", _m_ReplaceSelection);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "Setup_BeforeAdd", _m_Setup_BeforeAdd);
			
			
			Utils.RegisterFunc(L, Utils.GETTER_IDX, "onFocusIn", _g_get_onFocusIn);
            Utils.RegisterFunc(L, Utils.GETTER_IDX, "onFocusOut", _g_get_onFocusOut);
            Utils.RegisterFunc(L, Utils.GETTER_IDX, "onChanged", _g_get_onChanged);
            Utils.RegisterFunc(L, Utils.GETTER_IDX, "inputTextField", _g_get_inputTextField);
            Utils.RegisterFunc(L, Utils.GETTER_IDX, "text", _g_get_text);
            Utils.RegisterFunc(L, Utils.GETTER_IDX, "editable", _g_get_editable);
            Utils.RegisterFunc(L, Utils.GETTER_IDX, "hideInput", _g_get_hideInput);
            Utils.RegisterFunc(L, Utils.GETTER_IDX, "maxLength", _g_get_maxLength);
            Utils.RegisterFunc(L, Utils.GETTER_IDX, "restrict", _g_get_restrict);
            Utils.RegisterFunc(L, Utils.GETTER_IDX, "displayAsPassword", _g_get_displayAsPassword);
            Utils.RegisterFunc(L, Utils.GETTER_IDX, "caretPosition", _g_get_caretPosition);
            Utils.RegisterFunc(L, Utils.GETTER_IDX, "promptText", _g_get_promptText);
            Utils.RegisterFunc(L, Utils.GETTER_IDX, "keyboardInput", _g_get_keyboardInput);
            Utils.RegisterFunc(L, Utils.GETTER_IDX, "keyboardType", _g_get_keyboardType);
            Utils.RegisterFunc(L, Utils.GETTER_IDX, "emojies", _g_get_emojies);
            
			Utils.RegisterFunc(L, Utils.SETTER_IDX, "text", _s_set_text);
            Utils.RegisterFunc(L, Utils.SETTER_IDX, "editable", _s_set_editable);
            Utils.RegisterFunc(L, Utils.SETTER_IDX, "hideInput", _s_set_hideInput);
            Utils.RegisterFunc(L, Utils.SETTER_IDX, "maxLength", _s_set_maxLength);
            Utils.RegisterFunc(L, Utils.SETTER_IDX, "restrict", _s_set_restrict);
            Utils.RegisterFunc(L, Utils.SETTER_IDX, "displayAsPassword", _s_set_displayAsPassword);
            Utils.RegisterFunc(L, Utils.SETTER_IDX, "caretPosition", _s_set_caretPosition);
            Utils.RegisterFunc(L, Utils.SETTER_IDX, "promptText", _s_set_promptText);
            Utils.RegisterFunc(L, Utils.SETTER_IDX, "keyboardInput", _s_set_keyboardInput);
            Utils.RegisterFunc(L, Utils.SETTER_IDX, "keyboardType", _s_set_keyboardType);
            Utils.RegisterFunc(L, Utils.SETTER_IDX, "emojies", _s_set_emojies);
            
			Utils.EndObjectRegister(typeof(FairyGUI.GTextInput), L, translator, null, null,
			    null, null, null);

		    Utils.BeginClassRegister(typeof(FairyGUI.GTextInput), L, __CreateInstance, 1, 0, 0);
			
			
            
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "UnderlyingSystemType", typeof(FairyGUI.GTextInput));
			
			
			Utils.EndClassRegister(typeof(FairyGUI.GTextInput), L, translator);
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int __CreateInstance(RealStatePtr L)
        {
            
            ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			try {
				if(LuaAPI.lua_gettop(L) == 1)
				{
					
					FairyGUI.GTextInput __cl_gen_ret = new FairyGUI.GTextInput();
					translator.Push(L, __cl_gen_ret);
                    
					return 1;
				}
				
			}
			catch(System.Exception __gen_e) {
				return LuaAPI.luaL_error(L, "c# exception:" + __gen_e);
			}
            return LuaAPI.luaL_error(L, "invalid arguments to FairyGUI.GTextInput constructor!");
            
        }
        
		
        
		
        
        
        
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_ReplaceSelection(RealStatePtr L)
        {
            
            ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
            FairyGUI.GTextInput __cl_gen_to_be_invoked = (FairyGUI.GTextInput)translator.FastGetCSObj(L, 1);
            
            
            try {
                
                {
                    string value = LuaAPI.lua_tostring(L, 2);
                    
                    __cl_gen_to_be_invoked.ReplaceSelection( value );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception __gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + __gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_Setup_BeforeAdd(RealStatePtr L)
        {
            
            ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
            FairyGUI.GTextInput __cl_gen_to_be_invoked = (FairyGUI.GTextInput)translator.FastGetCSObj(L, 1);
            
            
            try {
                
                {
                    FairyGUI.Utils.XML xml = (FairyGUI.Utils.XML)translator.GetObject(L, 2, typeof(FairyGUI.Utils.XML));
                    
                    __cl_gen_to_be_invoked.Setup_BeforeAdd( xml );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception __gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + __gen_e);
            }
            
        }
        
        
        
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_onFocusIn(RealStatePtr L)
        {
            ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            try {
			
                FairyGUI.GTextInput __cl_gen_to_be_invoked = (FairyGUI.GTextInput)translator.FastGetCSObj(L, 1);
                translator.Push(L, __cl_gen_to_be_invoked.onFocusIn);
            } catch(System.Exception __gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + __gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_onFocusOut(RealStatePtr L)
        {
            ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            try {
			
                FairyGUI.GTextInput __cl_gen_to_be_invoked = (FairyGUI.GTextInput)translator.FastGetCSObj(L, 1);
                translator.Push(L, __cl_gen_to_be_invoked.onFocusOut);
            } catch(System.Exception __gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + __gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_onChanged(RealStatePtr L)
        {
            ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            try {
			
                FairyGUI.GTextInput __cl_gen_to_be_invoked = (FairyGUI.GTextInput)translator.FastGetCSObj(L, 1);
                translator.Push(L, __cl_gen_to_be_invoked.onChanged);
            } catch(System.Exception __gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + __gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_inputTextField(RealStatePtr L)
        {
            ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            try {
			
                FairyGUI.GTextInput __cl_gen_to_be_invoked = (FairyGUI.GTextInput)translator.FastGetCSObj(L, 1);
                translator.Push(L, __cl_gen_to_be_invoked.inputTextField);
            } catch(System.Exception __gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + __gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_text(RealStatePtr L)
        {
            ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            try {
			
                FairyGUI.GTextInput __cl_gen_to_be_invoked = (FairyGUI.GTextInput)translator.FastGetCSObj(L, 1);
                LuaAPI.lua_pushstring(L, __cl_gen_to_be_invoked.text);
            } catch(System.Exception __gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + __gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_editable(RealStatePtr L)
        {
            ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            try {
			
                FairyGUI.GTextInput __cl_gen_to_be_invoked = (FairyGUI.GTextInput)translator.FastGetCSObj(L, 1);
                LuaAPI.lua_pushboolean(L, __cl_gen_to_be_invoked.editable);
            } catch(System.Exception __gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + __gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_hideInput(RealStatePtr L)
        {
            ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            try {
			
                FairyGUI.GTextInput __cl_gen_to_be_invoked = (FairyGUI.GTextInput)translator.FastGetCSObj(L, 1);
                LuaAPI.lua_pushboolean(L, __cl_gen_to_be_invoked.hideInput);
            } catch(System.Exception __gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + __gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_maxLength(RealStatePtr L)
        {
            ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            try {
			
                FairyGUI.GTextInput __cl_gen_to_be_invoked = (FairyGUI.GTextInput)translator.FastGetCSObj(L, 1);
                LuaAPI.xlua_pushinteger(L, __cl_gen_to_be_invoked.maxLength);
            } catch(System.Exception __gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + __gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_restrict(RealStatePtr L)
        {
            ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            try {
			
                FairyGUI.GTextInput __cl_gen_to_be_invoked = (FairyGUI.GTextInput)translator.FastGetCSObj(L, 1);
                LuaAPI.lua_pushstring(L, __cl_gen_to_be_invoked.restrict);
            } catch(System.Exception __gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + __gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_displayAsPassword(RealStatePtr L)
        {
            ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            try {
			
                FairyGUI.GTextInput __cl_gen_to_be_invoked = (FairyGUI.GTextInput)translator.FastGetCSObj(L, 1);
                LuaAPI.lua_pushboolean(L, __cl_gen_to_be_invoked.displayAsPassword);
            } catch(System.Exception __gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + __gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_caretPosition(RealStatePtr L)
        {
            ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            try {
			
                FairyGUI.GTextInput __cl_gen_to_be_invoked = (FairyGUI.GTextInput)translator.FastGetCSObj(L, 1);
                LuaAPI.xlua_pushinteger(L, __cl_gen_to_be_invoked.caretPosition);
            } catch(System.Exception __gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + __gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_promptText(RealStatePtr L)
        {
            ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            try {
			
                FairyGUI.GTextInput __cl_gen_to_be_invoked = (FairyGUI.GTextInput)translator.FastGetCSObj(L, 1);
                LuaAPI.lua_pushstring(L, __cl_gen_to_be_invoked.promptText);
            } catch(System.Exception __gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + __gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_keyboardInput(RealStatePtr L)
        {
            ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            try {
			
                FairyGUI.GTextInput __cl_gen_to_be_invoked = (FairyGUI.GTextInput)translator.FastGetCSObj(L, 1);
                LuaAPI.lua_pushboolean(L, __cl_gen_to_be_invoked.keyboardInput);
            } catch(System.Exception __gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + __gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_keyboardType(RealStatePtr L)
        {
            ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            try {
			
                FairyGUI.GTextInput __cl_gen_to_be_invoked = (FairyGUI.GTextInput)translator.FastGetCSObj(L, 1);
                LuaAPI.xlua_pushinteger(L, __cl_gen_to_be_invoked.keyboardType);
            } catch(System.Exception __gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + __gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_emojies(RealStatePtr L)
        {
            ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            try {
			
                FairyGUI.GTextInput __cl_gen_to_be_invoked = (FairyGUI.GTextInput)translator.FastGetCSObj(L, 1);
                translator.Push(L, __cl_gen_to_be_invoked.emojies);
            } catch(System.Exception __gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + __gen_e);
            }
            return 1;
        }
        
        
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _s_set_text(RealStatePtr L)
        {
            ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            try {
			
                FairyGUI.GTextInput __cl_gen_to_be_invoked = (FairyGUI.GTextInput)translator.FastGetCSObj(L, 1);
                __cl_gen_to_be_invoked.text = LuaAPI.lua_tostring(L, 2);
            
            } catch(System.Exception __gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + __gen_e);
            }
            return 0;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _s_set_editable(RealStatePtr L)
        {
            ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            try {
			
                FairyGUI.GTextInput __cl_gen_to_be_invoked = (FairyGUI.GTextInput)translator.FastGetCSObj(L, 1);
                __cl_gen_to_be_invoked.editable = LuaAPI.lua_toboolean(L, 2);
            
            } catch(System.Exception __gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + __gen_e);
            }
            return 0;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _s_set_hideInput(RealStatePtr L)
        {
            ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            try {
			
                FairyGUI.GTextInput __cl_gen_to_be_invoked = (FairyGUI.GTextInput)translator.FastGetCSObj(L, 1);
                __cl_gen_to_be_invoked.hideInput = LuaAPI.lua_toboolean(L, 2);
            
            } catch(System.Exception __gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + __gen_e);
            }
            return 0;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _s_set_maxLength(RealStatePtr L)
        {
            ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            try {
			
                FairyGUI.GTextInput __cl_gen_to_be_invoked = (FairyGUI.GTextInput)translator.FastGetCSObj(L, 1);
                __cl_gen_to_be_invoked.maxLength = LuaAPI.xlua_tointeger(L, 2);
            
            } catch(System.Exception __gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + __gen_e);
            }
            return 0;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _s_set_restrict(RealStatePtr L)
        {
            ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            try {
			
                FairyGUI.GTextInput __cl_gen_to_be_invoked = (FairyGUI.GTextInput)translator.FastGetCSObj(L, 1);
                __cl_gen_to_be_invoked.restrict = LuaAPI.lua_tostring(L, 2);
            
            } catch(System.Exception __gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + __gen_e);
            }
            return 0;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _s_set_displayAsPassword(RealStatePtr L)
        {
            ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            try {
			
                FairyGUI.GTextInput __cl_gen_to_be_invoked = (FairyGUI.GTextInput)translator.FastGetCSObj(L, 1);
                __cl_gen_to_be_invoked.displayAsPassword = LuaAPI.lua_toboolean(L, 2);
            
            } catch(System.Exception __gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + __gen_e);
            }
            return 0;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _s_set_caretPosition(RealStatePtr L)
        {
            ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            try {
			
                FairyGUI.GTextInput __cl_gen_to_be_invoked = (FairyGUI.GTextInput)translator.FastGetCSObj(L, 1);
                __cl_gen_to_be_invoked.caretPosition = LuaAPI.xlua_tointeger(L, 2);
            
            } catch(System.Exception __gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + __gen_e);
            }
            return 0;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _s_set_promptText(RealStatePtr L)
        {
            ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            try {
			
                FairyGUI.GTextInput __cl_gen_to_be_invoked = (FairyGUI.GTextInput)translator.FastGetCSObj(L, 1);
                __cl_gen_to_be_invoked.promptText = LuaAPI.lua_tostring(L, 2);
            
            } catch(System.Exception __gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + __gen_e);
            }
            return 0;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _s_set_keyboardInput(RealStatePtr L)
        {
            ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            try {
			
                FairyGUI.GTextInput __cl_gen_to_be_invoked = (FairyGUI.GTextInput)translator.FastGetCSObj(L, 1);
                __cl_gen_to_be_invoked.keyboardInput = LuaAPI.lua_toboolean(L, 2);
            
            } catch(System.Exception __gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + __gen_e);
            }
            return 0;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _s_set_keyboardType(RealStatePtr L)
        {
            ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            try {
			
                FairyGUI.GTextInput __cl_gen_to_be_invoked = (FairyGUI.GTextInput)translator.FastGetCSObj(L, 1);
                __cl_gen_to_be_invoked.keyboardType = LuaAPI.xlua_tointeger(L, 2);
            
            } catch(System.Exception __gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + __gen_e);
            }
            return 0;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _s_set_emojies(RealStatePtr L)
        {
            ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            try {
			
                FairyGUI.GTextInput __cl_gen_to_be_invoked = (FairyGUI.GTextInput)translator.FastGetCSObj(L, 1);
                __cl_gen_to_be_invoked.emojies = (System.Collections.Generic.Dictionary<uint, FairyGUI.Emoji>)translator.GetObject(L, 2, typeof(System.Collections.Generic.Dictionary<uint, FairyGUI.Emoji>));
            
            } catch(System.Exception __gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + __gen_e);
            }
            return 0;
        }
        
		
		
		
		
    }
}
