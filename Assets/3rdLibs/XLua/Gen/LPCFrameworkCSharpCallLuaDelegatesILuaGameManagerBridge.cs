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
using System;


namespace XLua.CSObjectWrap
{
    public class LPCFrameworkCSharpCallLuaDelegatesILuaGameManagerBridge : LuaBase, LPCFramework.CSharpCallLuaDelegates.ILuaGameManager
    {
	    public static LuaBase __Create(int reference, LuaEnv luaenv)
		{
		    return new LPCFrameworkCSharpCallLuaDelegatesILuaGameManagerBridge(reference, luaenv);
		}
		
		public LPCFrameworkCSharpCallLuaDelegatesILuaGameManagerBridge(int reference, LuaEnv luaenv) : base(reference, luaenv)
        {
        }
		
        
		public void init()
		{
#if THREAD_SAFT || HOTFIX_ENABLE
            lock (luaEnv.luaEnvLock)
            {
#endif
				RealStatePtr L = luaEnv.L;
				int err_func = LuaAPI.load_error_func(L, luaEnv.errorFuncRef);
				
				
				LuaAPI.lua_getref(L, luaReference);
				LuaAPI.xlua_pushasciistring(L, "init");
				if (0 != LuaAPI.xlua_pgettable(L, -2))
				{
					luaEnv.ThrowExceptionFromError(err_func - 1);
				}
				if(!LuaAPI.lua_isfunction(L, -1))
				{
					LuaAPI.xlua_pushasciistring(L, "no such function init");
					luaEnv.ThrowExceptionFromError(err_func - 1);
				}
				LuaAPI.lua_pushvalue(L, -2);
				LuaAPI.lua_remove(L, -3);
				
				int __gen_error = LuaAPI.lua_pcall(L, 1, 0, err_func);
				if (__gen_error != 0)
					luaEnv.ThrowExceptionFromError(err_func - 1);
				
				
				
				LuaAPI.lua_settop(L, err_func - 1);
				
#if THREAD_SAFT || HOTFIX_ENABLE
            }
#endif
		}
        
		public void update(float deltaTime)
		{
#if THREAD_SAFT || HOTFIX_ENABLE
            lock (luaEnv.luaEnvLock)
            {
#endif
				RealStatePtr L = luaEnv.L;
				int err_func = LuaAPI.load_error_func(L, luaEnv.errorFuncRef);
				
				
				LuaAPI.lua_getref(L, luaReference);
				LuaAPI.xlua_pushasciistring(L, "update");
				if (0 != LuaAPI.xlua_pgettable(L, -2))
				{
					luaEnv.ThrowExceptionFromError(err_func - 1);
				}
				if(!LuaAPI.lua_isfunction(L, -1))
				{
					LuaAPI.xlua_pushasciistring(L, "no such function update");
					luaEnv.ThrowExceptionFromError(err_func - 1);
				}
				LuaAPI.lua_pushvalue(L, -2);
				LuaAPI.lua_remove(L, -3);
				LuaAPI.lua_pushnumber(L, deltaTime);
				
				int __gen_error = LuaAPI.lua_pcall(L, 2, 0, err_func);
				if (__gen_error != 0)
					luaEnv.ThrowExceptionFromError(err_func - 1);
				
				
				
				LuaAPI.lua_settop(L, err_func - 1);
				
#if THREAD_SAFT || HOTFIX_ENABLE
            }
#endif
		}
        
		public void fixedUpdate(float fixedDeltaTime)
		{
#if THREAD_SAFT || HOTFIX_ENABLE
            lock (luaEnv.luaEnvLock)
            {
#endif
				RealStatePtr L = luaEnv.L;
				int err_func = LuaAPI.load_error_func(L, luaEnv.errorFuncRef);
				
				
				LuaAPI.lua_getref(L, luaReference);
				LuaAPI.xlua_pushasciistring(L, "fixedUpdate");
				if (0 != LuaAPI.xlua_pgettable(L, -2))
				{
					luaEnv.ThrowExceptionFromError(err_func - 1);
				}
				if(!LuaAPI.lua_isfunction(L, -1))
				{
					LuaAPI.xlua_pushasciistring(L, "no such function fixedUpdate");
					luaEnv.ThrowExceptionFromError(err_func - 1);
				}
				LuaAPI.lua_pushvalue(L, -2);
				LuaAPI.lua_remove(L, -3);
				LuaAPI.lua_pushnumber(L, fixedDeltaTime);
				
				int __gen_error = LuaAPI.lua_pcall(L, 2, 0, err_func);
				if (__gen_error != 0)
					luaEnv.ThrowExceptionFromError(err_func - 1);
				
				
				
				LuaAPI.lua_settop(L, err_func - 1);
				
#if THREAD_SAFT || HOTFIX_ENABLE
            }
#endif
		}
        
		public void onDestroy()
		{
#if THREAD_SAFT || HOTFIX_ENABLE
            lock (luaEnv.luaEnvLock)
            {
#endif
				RealStatePtr L = luaEnv.L;
				int err_func = LuaAPI.load_error_func(L, luaEnv.errorFuncRef);
				
				
				LuaAPI.lua_getref(L, luaReference);
				LuaAPI.xlua_pushasciistring(L, "onDestroy");
				if (0 != LuaAPI.xlua_pgettable(L, -2))
				{
					luaEnv.ThrowExceptionFromError(err_func - 1);
				}
				if(!LuaAPI.lua_isfunction(L, -1))
				{
					LuaAPI.xlua_pushasciistring(L, "no such function onDestroy");
					luaEnv.ThrowExceptionFromError(err_func - 1);
				}
				LuaAPI.lua_pushvalue(L, -2);
				LuaAPI.lua_remove(L, -3);
				
				int __gen_error = LuaAPI.lua_pcall(L, 1, 0, err_func);
				if (__gen_error != 0)
					luaEnv.ThrowExceptionFromError(err_func - 1);
				
				
				
				LuaAPI.lua_settop(L, err_func - 1);
				
#if THREAD_SAFT || HOTFIX_ENABLE
            }
#endif
		}
        

        
        
        
		
		
	}
}
