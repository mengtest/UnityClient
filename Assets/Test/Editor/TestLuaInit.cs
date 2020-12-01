using System;
using UnityEngine;
using UnityEditor;
using NUnit.Framework;
using XLua;

namespace LPCFramework
{

    public class TestLuaInit {

        [Test]
        public void EditorTest()
        {
            GameObject obj = new GameObject();
            obj.AddComponentIfNotExist<SceneLoader>();
            obj.AddComponentIfNotExist<LuaManager>();
            obj.AddComponentIfNotExist<ResourceManager>();
            obj.AddComponentIfNotExist<GameManager>();

            LuaManager luaManager = obj.GetComponent<LuaManager>();

            luaManager.DoFile("Main");
        }
    }
}
