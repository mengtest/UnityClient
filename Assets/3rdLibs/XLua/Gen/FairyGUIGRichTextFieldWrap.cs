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
    public class FairyGUIGRichTextFieldWrap
    {
        public static void __Register(RealStatePtr L)
        {
			ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			Utils.BeginObjectRegister(typeof(FairyGUI.GRichTextField), L, translator, 0, 0, 2, 1);
			
			
			
			Utils.RegisterFunc(L, Utils.GETTER_IDX, "richTextField", _g_get_richTextField);
            Utils.RegisterFunc(L, Utils.GETTER_IDX, "emojies", _g_get_emojies);
            
			Utils.RegisterFunc(L, Utils.SETTER_IDX, "emojies", _s_set_emojies);
            
			Utils.EndObjectRegister(typeof(FairyGUI.GRichTextField), L, translator, null, null,
			    null, null, null);

		    Utils.BeginClassRegister(typeof(FairyGUI.GRichTextField), L, __CreateInstance, 1, 0, 0);
			
			
            
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "UnderlyingSystemType", typeof(FairyGUI.GRichTextField));
			
			
			Utils.EndClassRegister(typeof(FairyGUI.GRichTextField), L, translator);
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int __CreateInstance(RealStatePtr L)
        {
            
            ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			try {
				if(LuaAPI.lua_gettop(L) == 1)
				{
					
					FairyGUI.GRichTextField __cl_gen_ret = new FairyGUI.GRichTextField();
					translator.Push(L, __cl_gen_ret);
                    
					return 1;
				}
				
			}
			catch(System.Exception __gen_e) {
				return LuaAPI.luaL_error(L, "c# exception:" + __gen_e);
			}
            return LuaAPI.luaL_error(L, "invalid arguments to FairyGUI.GRichTextField constructor!");
            
        }
        
		
        
		
        
        
        
        
        
        
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_richTextField(RealStatePtr L)
        {
            ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            try {
			
                FairyGUI.GRichTextField __cl_gen_to_be_invoked = (FairyGUI.GRichTextField)translator.FastGetCSObj(L, 1);
                translator.Push(L, __cl_gen_to_be_invoked.richTextField);
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
			
                FairyGUI.GRichTextField __cl_gen_to_be_invoked = (FairyGUI.GRichTextField)translator.FastGetCSObj(L, 1);
                translator.Push(L, __cl_gen_to_be_invoked.emojies);
            } catch(System.Exception __gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + __gen_e);
            }
            return 1;
        }
        
        
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _s_set_emojies(RealStatePtr L)
        {
            ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            try {
			
                FairyGUI.GRichTextField __cl_gen_to_be_invoked = (FairyGUI.GRichTextField)translator.FastGetCSObj(L, 1);
                __cl_gen_to_be_invoked.emojies = (System.Collections.Generic.Dictionary<uint, FairyGUI.Emoji>)translator.GetObject(L, 2, typeof(System.Collections.Generic.Dictionary<uint, FairyGUI.Emoji>));
            
            } catch(System.Exception __gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + __gen_e);
            }
            return 0;
        }
        
		
		
		
		
    }
}
