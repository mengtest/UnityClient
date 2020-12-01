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
using System.Collections;
using System.Collections.Generic;
using System;
using UnityEngine.UI;

namespace LPCFramework
{
    /// <summary>
    /// 交互对象
    /// </summary>
    [System.Serializable]
    public class Injection
    {
        public string name;
        public GameObject value;
    }

    /// <summary>
    /// GameObject附加此脚本，可指定一个与其交互的Lua脚本
    /// </summary>

    [LuaCallCSharp]
    public class LuaBehaviour : MonoBehaviour
    {
        public TextAsset luaScript;
        public Injection[] injections;

        private Action luaStart;
        private Action luaUpdate;
        private Action luaOnDestroy;

        private LuaTable scriptEnv;

        protected void Awake()
        {
            LuaTable meta = LuaManager.Instance.LuaVM.NewTable();
            meta.Set("__index", LuaManager.Instance.LuaVM.Global);
            scriptEnv.SetMetaTable(meta);
            meta.Dispose();

            scriptEnv.Set("self", this);
            foreach (var injection in injections)
            {
                scriptEnv.Set(injection.name, injection.value);
            }

            LuaManager.Instance.DoFile(luaScript.text, "LuaBehaviour", scriptEnv);

            Action luaAwake = scriptEnv.Get<Action>("Awake");
            scriptEnv.Get("Start", out luaStart);
            scriptEnv.Get("Update", out luaUpdate);
            scriptEnv.Get("Ondestroy", out luaOnDestroy);

            if (luaAwake != null)
            {
                luaAwake();
            }
        }

        protected void Start()
        {
            if (luaStart != null)
            {
                luaStart();
            }
        }

        protected void Update()
        {
            if (luaUpdate != null)
            {
                luaUpdate();
            }
        }

        protected virtual void OnDestroy()
        {
            if (luaOnDestroy != null)
            {
                luaOnDestroy();
            }

            luaOnDestroy = null;
            luaUpdate = null;
            luaStart = null;
            scriptEnv.Dispose();
            injections = null;

#if ASYNC_MODE
            string abName = name.ToLower().Replace("panel", "");
            ResManager.UnloadAssetBundle(abName + ConstDefines.ExtName);
#endif
            LogicUtils.ClearMemory();
            Debug.Log("~" + name + " was destroy!");
        }
    }
}