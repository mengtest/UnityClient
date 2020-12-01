/*
* ==============================================================================
* 
* Created: 2017-3-3
* Author: Panda
* Company: LightPaw
* 
* ==============================================================================
*/
using UnityEngine;
using XLua;
using System.IO;

namespace LPCFramework
{
    /// <summary>
    /// Lua虚拟机管理器
    /// 负责与Lua环境之间的交互
    /// </summary>
    public class LuaManager : SingletonMonobehaviour<LuaManager>, IManager
    {
        //all lua behaviour shared one luaenv only!
        private static LuaEnv m_luaVM = newLuaVM();

        internal static float LastGCTime = 0;
        internal const float GCInterval = 1;            //Lua GC in every second

        /// <summary>
        /// Lua虚拟机
        /// </summary>
        public LuaEnv LuaVM
        {
            get
            {
                return m_luaVM;
            }
        }

        public static LuaEnv newLuaVM()
        {
            LuaEnv result = new LuaEnv();
            result.AddLoader(CustomLoader);
            return result;
        }

        /// <summary>
        /// 初始化
        /// </summary>
        public void OnInitialize()
        {
            if(null == m_luaVM)
                m_luaVM = newLuaVM();
        }
        /// <summary>
        /// 逻辑更新
        /// </summary>
        public void OnUpdateLogic()
        {
            if (m_luaVM == null)
                return;

            if (Time.time - LuaManager.LastGCTime > GCInterval)
            {
                m_luaVM.Tick();
                LuaManager.LastGCTime = Time.time;
            }

            if (CSharpCallLuaDelegates.Instance.LuaGameManagerEntry != null)
                CSharpCallLuaDelegates.Instance.LuaGameManagerEntry.update(Time.deltaTime);
        }
        /// <summary>
        /// 固定更新
        /// </summary>
        private void FixedUpdate()
        {
            if (m_luaVM == null)
                return;

            if (CSharpCallLuaDelegates.Instance.LuaGameManagerEntry != null)
                CSharpCallLuaDelegates.Instance.LuaGameManagerEntry.fixedUpdate(Time.fixedDeltaTime);
        }
        /// <summary>
        /// 析构
        /// </summary>
        public void OnDestruct()
        {
            if (CSharpCallLuaDelegates.Instance.LuaGameManagerEntry != null)
                CSharpCallLuaDelegates.Instance.LuaGameManagerEntry.onDestroy();

            m_luaVM.Dispose();
            m_luaVM = null;

            Debug.Log("~LuaManager was destroyed!");
        }

        /// <summary>
        /// 自定义文件读取方式，返回byte[]，如对文件解密
        /// </summary>
        /// <param name="fileName"></param>
        /// <returns></returns>
        private static byte[] CustomLoader(ref string fileName)
        {
            return ResourceMgr.LoadLua(fileName);
        }

        /// <summary>
        /// 执行Lua文件
        /// </summary>
        public object[] DoFile(string filename, string chunkName = "chunk", LuaTable env = null)
        {
            return m_luaVM.DoString("require '" + filename + "'", chunkName, env);
        }
        /// <summary>
        /// 调用Lua全局方法中的指定方法
        /// </summary>
        public object[] CallFunction(string funcName, params object[] args)
        {
            LuaFunction func = m_luaVM.Global.Get<LuaFunction>(funcName);
            if (func != null)
            {
                return func.Call(args);
            }
            return null;
        }
        /// <summary>
        /// 执行Lua方法
        /// </summary>
        public static object[] CallGlobalMethod(string module, string func, params object[] args)
        {
            return LuaManager.Instance.CallFunction(module + "." + func, args);
        }
        /// <summary>
        /// 绑定C# class, interface, delegate等到lua
        /// </summary>
        /// <typeparam name="T"></typeparam>
        /// <param name="key"></param>
        /// <returns></returns>
        public T BindToLua<T>(string key)
        {
            T f = m_luaVM.Global.Get<T>(key);
            return f;
        }
        public T BindToLuaInPath<T>(string key)
        {
            T f = m_luaVM.Global.GetInPath<T>(key);
            return f;
        }
        /// <summary>
        /// 重启LuaGC
        /// </summary>
        public void LuaGC()
        {
            m_luaVM.RestartGc();
        }
    }
}