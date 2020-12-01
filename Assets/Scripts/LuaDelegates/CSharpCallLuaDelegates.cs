/*
* ==============================================================================
* 
* Created: 2017-3-3
* Author: Panda
* Company: LightPaw
* 
* ==============================================================================
*/
using XLua;
using UnityEngine;

namespace LPCFramework
{
    /// <summary>
    /// C#端与Lua脚本交互用的接口
    /// </summary>
    public class CSharpCallLuaDelegates : Singleton<CSharpCallLuaDelegates>
    {
        /// <summary>
        /// C#调用Main.lua方式
        /// 通过此接口与main.lua绑定
        /// </summary>
        [CSharpCallLua]
        public interface ILuaGameManager
        {
            void init();

            void update(float deltaTime);

            void fixedUpdate(float fixedDeltaTime);

            void onDestroy();
        }

        /// <summary>
        /// C#调用Network.lua方式
        /// 通过此接口与Network.lua绑定
        /// </summary>
        [CSharpCallLua]
        public interface ILuaNetwork
        {
            void onReceiveMsg(byte[] content);
        }
        
        public ILuaGameManager LuaGameManagerEntry { get; private set; }
        public ILuaNetwork LuaNetworkEntry { get; private set; }

        /// <summary>
        /// 初始化
        /// 绑定C#端的代理到Lua脚本
        /// </summary>
        public void Initialize()
        {
            // 载入Main.lua
            LuaManager.Instance.DoFile("Main");

            // 绑定代理
            LuaGameManagerEntry = LuaManager.Instance.BindToLua<ILuaGameManager>("GameManager");
            LuaNetworkEntry = LuaManager.Instance.BindToLua<ILuaNetwork>("NetworkManager");
        }
    }
}