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
    public class LPCFrameworkFileUtilsWrap
    {
        public static void __Register(RealStatePtr L)
        {
			ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			Utils.BeginObjectRegister(typeof(LPCFramework.FileUtils), L, translator, 0, 0, 0, 0);
			
			
			
			
			
			Utils.EndObjectRegister(typeof(LPCFramework.FileUtils), L, translator, null, null,
			    null, null, null);

		    Utils.BeginClassRegister(typeof(LPCFramework.FileUtils), L, __CreateInstance, 17, 0, 0);
			Utils.RegisterFunc(L, Utils.CLS_IDX, "ReadFileToString", _m_ReadFileToString_xlua_st_);
            Utils.RegisterFunc(L, Utils.CLS_IDX, "ReadFileToBytes", _m_ReadFileToBytes_xlua_st_);
            Utils.RegisterFunc(L, Utils.CLS_IDX, "WriteFile", _m_WriteFile_xlua_st_);
            Utils.RegisterFunc(L, Utils.CLS_IDX, "GetFileName", _m_GetFileName_xlua_st_);
            Utils.RegisterFunc(L, Utils.CLS_IDX, "GetFileNameWithoutExtention", _m_GetFileNameWithoutExtention_xlua_st_);
            Utils.RegisterFunc(L, Utils.CLS_IDX, "GetFilePath", _m_GetFilePath_xlua_st_);
            Utils.RegisterFunc(L, Utils.CLS_IDX, "GetFileNamePathWithoutExtention", _m_GetFileNamePathWithoutExtention_xlua_st_);
            Utils.RegisterFunc(L, Utils.CLS_IDX, "GetFileParentFolder", _m_GetFileParentFolder_xlua_st_);
            Utils.RegisterFunc(L, Utils.CLS_IDX, "ZipFile", _m_ZipFile_xlua_st_);
            Utils.RegisterFunc(L, Utils.CLS_IDX, "UnZipFiles", _m_UnZipFiles_xlua_st_);
            Utils.RegisterFunc(L, Utils.CLS_IDX, "HashToMD5Hex", _m_HashToMD5Hex_xlua_st_);
            Utils.RegisterFunc(L, Utils.CLS_IDX, "GetMD5ForString", _m_GetMD5ForString_xlua_st_);
            Utils.RegisterFunc(L, Utils.CLS_IDX, "GetMD5ForFile", _m_GetMD5ForFile_xlua_st_);
            Utils.RegisterFunc(L, Utils.CLS_IDX, "Encrypt", _m_Encrypt_xlua_st_);
            Utils.RegisterFunc(L, Utils.CLS_IDX, "EncryptAll", _m_EncryptAll_xlua_st_);
            Utils.RegisterFunc(L, Utils.CLS_IDX, "RC4", _m_RC4_xlua_st_);
            
			
            
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "UnderlyingSystemType", typeof(LPCFramework.FileUtils));
			
			
			Utils.EndClassRegister(typeof(LPCFramework.FileUtils), L, translator);
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int __CreateInstance(RealStatePtr L)
        {
            
            ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			try {
				if(LuaAPI.lua_gettop(L) == 1)
				{
					
					LPCFramework.FileUtils __cl_gen_ret = new LPCFramework.FileUtils();
					translator.Push(L, __cl_gen_ret);
                    
					return 1;
				}
				
			}
			catch(System.Exception __gen_e) {
				return LuaAPI.luaL_error(L, "c# exception:" + __gen_e);
			}
            return LuaAPI.luaL_error(L, "invalid arguments to LPCFramework.FileUtils constructor!");
            
        }
        
		
        
		
        
        
        
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_ReadFileToString_xlua_st_(RealStatePtr L)
        {
            
            
            
            try {
                
                {
                    string path = LuaAPI.lua_tostring(L, 1);
                    
                        string __cl_gen_ret = LPCFramework.FileUtils.ReadFileToString( path );
                        LuaAPI.lua_pushstring(L, __cl_gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception __gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + __gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_ReadFileToBytes_xlua_st_(RealStatePtr L)
        {
            
            
            
            try {
                
                {
                    string path = LuaAPI.lua_tostring(L, 1);
                    
                        byte[] __cl_gen_ret = LPCFramework.FileUtils.ReadFileToBytes( path );
                        LuaAPI.lua_pushstring(L, __cl_gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception __gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + __gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_WriteFile_xlua_st_(RealStatePtr L)
        {
            
            
            
            try {
                
                {
                    string path = LuaAPI.lua_tostring(L, 1);
                    byte[] content = LuaAPI.lua_tobytes(L, 2);
                    
                        bool __cl_gen_ret = LPCFramework.FileUtils.WriteFile( path, content );
                        LuaAPI.lua_pushboolean(L, __cl_gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception __gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + __gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_GetFileName_xlua_st_(RealStatePtr L)
        {
            
            
            
			int __gen_param_count = LuaAPI.lua_gettop(L);
            
            try {
                if(__gen_param_count == 2&& (LuaAPI.lua_isnil(L, 1) || LuaAPI.lua_type(L, 1) == LuaTypes.LUA_TSTRING)&& LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 2)) 
                {
                    string path = LuaAPI.lua_tostring(L, 1);
                    char separator = (char)LuaAPI.xlua_tointeger(L, 2);
                    
                        string __cl_gen_ret = LPCFramework.FileUtils.GetFileName( path, separator );
                        LuaAPI.lua_pushstring(L, __cl_gen_ret);
                    
                    
                    
                    return 1;
                }
                if(__gen_param_count == 1&& (LuaAPI.lua_isnil(L, 1) || LuaAPI.lua_type(L, 1) == LuaTypes.LUA_TSTRING)) 
                {
                    string path = LuaAPI.lua_tostring(L, 1);
                    
                        string __cl_gen_ret = LPCFramework.FileUtils.GetFileName( path );
                        LuaAPI.lua_pushstring(L, __cl_gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception __gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + __gen_e);
            }
            
            return LuaAPI.luaL_error(L, "invalid arguments to LPCFramework.FileUtils.GetFileName!");
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_GetFileNameWithoutExtention_xlua_st_(RealStatePtr L)
        {
            
            
            
			int __gen_param_count = LuaAPI.lua_gettop(L);
            
            try {
                if(__gen_param_count == 2&& (LuaAPI.lua_isnil(L, 1) || LuaAPI.lua_type(L, 1) == LuaTypes.LUA_TSTRING)&& LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 2)) 
                {
                    string fileName = LuaAPI.lua_tostring(L, 1);
                    char separator = (char)LuaAPI.xlua_tointeger(L, 2);
                    
                        string __cl_gen_ret = LPCFramework.FileUtils.GetFileNameWithoutExtention( fileName, separator );
                        LuaAPI.lua_pushstring(L, __cl_gen_ret);
                    
                    
                    
                    return 1;
                }
                if(__gen_param_count == 1&& (LuaAPI.lua_isnil(L, 1) || LuaAPI.lua_type(L, 1) == LuaTypes.LUA_TSTRING)) 
                {
                    string fileName = LuaAPI.lua_tostring(L, 1);
                    
                        string __cl_gen_ret = LPCFramework.FileUtils.GetFileNameWithoutExtention( fileName );
                        LuaAPI.lua_pushstring(L, __cl_gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception __gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + __gen_e);
            }
            
            return LuaAPI.luaL_error(L, "invalid arguments to LPCFramework.FileUtils.GetFileNameWithoutExtention!");
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_GetFilePath_xlua_st_(RealStatePtr L)
        {
            
            
            
            try {
                
                {
                    string path = LuaAPI.lua_tostring(L, 1);
                    
                        string __cl_gen_ret = LPCFramework.FileUtils.GetFilePath( path );
                        LuaAPI.lua_pushstring(L, __cl_gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception __gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + __gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_GetFileNamePathWithoutExtention_xlua_st_(RealStatePtr L)
        {
            
            
            
            try {
                
                {
                    string fileName = LuaAPI.lua_tostring(L, 1);
                    
                        string __cl_gen_ret = LPCFramework.FileUtils.GetFileNamePathWithoutExtention( fileName );
                        LuaAPI.lua_pushstring(L, __cl_gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception __gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + __gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_GetFileParentFolder_xlua_st_(RealStatePtr L)
        {
            
            
            
            try {
                
                {
                    string filename = LuaAPI.lua_tostring(L, 1);
                    
                        string __cl_gen_ret = LPCFramework.FileUtils.GetFileParentFolder( filename );
                        LuaAPI.lua_pushstring(L, __cl_gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception __gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + __gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_ZipFile_xlua_st_(RealStatePtr L)
        {
            
            ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
            
			int __gen_param_count = LuaAPI.lua_gettop(L);
            
            try {
                if(__gen_param_count == 3&& (LuaAPI.lua_isnil(L, 1) || LuaAPI.lua_type(L, 1) == LuaTypes.LUA_TSTRING)&& (LuaAPI.lua_isnil(L, 2) || LuaAPI.lua_type(L, 2) == LuaTypes.LUA_TSTRING)&& translator.Assignable<ICSharpCode.SharpZipLib.Zip.FastZipEvents>(L, 3)) 
                {
                    string filename = LuaAPI.lua_tostring(L, 1);
                    string sourcedirectory = LuaAPI.lua_tostring(L, 2);
                    ICSharpCode.SharpZipLib.Zip.FastZipEvents zipevent = (ICSharpCode.SharpZipLib.Zip.FastZipEvents)translator.GetObject(L, 3, typeof(ICSharpCode.SharpZipLib.Zip.FastZipEvents));
                    
                    LPCFramework.FileUtils.ZipFile( filename, sourcedirectory, zipevent );
                    
                    
                    
                    return 0;
                }
                if(__gen_param_count == 2&& (LuaAPI.lua_isnil(L, 1) || LuaAPI.lua_type(L, 1) == LuaTypes.LUA_TSTRING)&& (LuaAPI.lua_isnil(L, 2) || LuaAPI.lua_type(L, 2) == LuaTypes.LUA_TSTRING)) 
                {
                    string filename = LuaAPI.lua_tostring(L, 1);
                    string sourcedirectory = LuaAPI.lua_tostring(L, 2);
                    
                    LPCFramework.FileUtils.ZipFile( filename, sourcedirectory );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception __gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + __gen_e);
            }
            
            return LuaAPI.luaL_error(L, "invalid arguments to LPCFramework.FileUtils.ZipFile!");
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_UnZipFiles_xlua_st_(RealStatePtr L)
        {
            
            ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
            
			int __gen_param_count = LuaAPI.lua_gettop(L);
            
            try {
                if(__gen_param_count == 3&& (LuaAPI.lua_isnil(L, 1) || LuaAPI.lua_type(L, 1) == LuaTypes.LUA_TSTRING)&& (LuaAPI.lua_isnil(L, 2) || LuaAPI.lua_type(L, 2) == LuaTypes.LUA_TSTRING)&& translator.Assignable<System.Action<float>>(L, 3)) 
                {
                    string file = LuaAPI.lua_tostring(L, 1);
                    string dir = LuaAPI.lua_tostring(L, 2);
                    System.Action<float> process = translator.GetDelegate<System.Action<float>>(L, 3);
                    
                        bool __cl_gen_ret = LPCFramework.FileUtils.UnZipFiles( file, dir, process );
                        LuaAPI.lua_pushboolean(L, __cl_gen_ret);
                    
                    
                    
                    return 1;
                }
                if(__gen_param_count == 2&& (LuaAPI.lua_isnil(L, 1) || LuaAPI.lua_type(L, 1) == LuaTypes.LUA_TSTRING)&& (LuaAPI.lua_isnil(L, 2) || LuaAPI.lua_type(L, 2) == LuaTypes.LUA_TSTRING)) 
                {
                    string file = LuaAPI.lua_tostring(L, 1);
                    string dir = LuaAPI.lua_tostring(L, 2);
                    
                        bool __cl_gen_ret = LPCFramework.FileUtils.UnZipFiles( file, dir );
                        LuaAPI.lua_pushboolean(L, __cl_gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception __gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + __gen_e);
            }
            
            return LuaAPI.luaL_error(L, "invalid arguments to LPCFramework.FileUtils.UnZipFiles!");
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_HashToMD5Hex_xlua_st_(RealStatePtr L)
        {
            
            
            
            try {
                
                {
                    string sourceStr = LuaAPI.lua_tostring(L, 1);
                    
                        string __cl_gen_ret = LPCFramework.FileUtils.HashToMD5Hex( sourceStr );
                        LuaAPI.lua_pushstring(L, __cl_gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception __gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + __gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_GetMD5ForString_xlua_st_(RealStatePtr L)
        {
            
            
            
            try {
                
                {
                    string source = LuaAPI.lua_tostring(L, 1);
                    
                        string __cl_gen_ret = LPCFramework.FileUtils.GetMD5ForString( source );
                        LuaAPI.lua_pushstring(L, __cl_gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception __gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + __gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_GetMD5ForFile_xlua_st_(RealStatePtr L)
        {
            
            
            
            try {
                
                {
                    string file = LuaAPI.lua_tostring(L, 1);
                    
                        string __cl_gen_ret = LPCFramework.FileUtils.GetMD5ForFile( file );
                        LuaAPI.lua_pushstring(L, __cl_gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception __gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + __gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_Encrypt_xlua_st_(RealStatePtr L)
        {
            
            
            
            try {
                
                {
                    byte[] input = LuaAPI.lua_tobytes(L, 1);
                    
                    LPCFramework.FileUtils.Encrypt( ref input );
                    LuaAPI.lua_pushstring(L, input);
                        
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception __gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + __gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_EncryptAll_xlua_st_(RealStatePtr L)
        {
            
            
            
            try {
                
                {
                    byte[] input = LuaAPI.lua_tobytes(L, 1);
                    
                    LPCFramework.FileUtils.EncryptAll( ref input );
                    LuaAPI.lua_pushstring(L, input);
                        
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception __gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + __gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_RC4_xlua_st_(RealStatePtr L)
        {
            
            
            
			int __gen_param_count = LuaAPI.lua_gettop(L);
            
            try {
                if(__gen_param_count == 2&& (LuaAPI.lua_isnil(L, 1) || LuaAPI.lua_type(L, 1) == LuaTypes.LUA_TSTRING)&& (LuaAPI.lua_isnil(L, 2) || LuaAPI.lua_type(L, 2) == LuaTypes.LUA_TSTRING)) 
                {
                    string str = LuaAPI.lua_tostring(L, 1);
                    string pass = LuaAPI.lua_tostring(L, 2);
                    
                        string __cl_gen_ret = LPCFramework.FileUtils.RC4( str, pass );
                        LuaAPI.lua_pushstring(L, __cl_gen_ret);
                    
                    
                    
                    return 1;
                }
                if(__gen_param_count == 2&& (LuaAPI.lua_isnil(L, 1) || LuaAPI.lua_type(L, 1) == LuaTypes.LUA_TSTRING)&& (LuaAPI.lua_isnil(L, 2) || LuaAPI.lua_type(L, 2) == LuaTypes.LUA_TSTRING)) 
                {
                    byte[] data = LuaAPI.lua_tobytes(L, 1);
                    string pass = LuaAPI.lua_tostring(L, 2);
                    
                        byte[] __cl_gen_ret = LPCFramework.FileUtils.RC4( data, pass );
                        LuaAPI.lua_pushstring(L, __cl_gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception __gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + __gen_e);
            }
            
            return LuaAPI.luaL_error(L, "invalid arguments to LPCFramework.FileUtils.RC4!");
            
        }
        
        
        
        
        
        
		
		
		
		
    }
}
