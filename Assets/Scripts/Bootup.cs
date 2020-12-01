/*
* ==============================================================================
* 
* Created: 2017-3-3
* Author: Panda
* Company: LightPaw
* 
* ==============================================================================
*/

using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

/// <summary>
/// LightPaw Client(LPC) Framework
/// </summary>
namespace LPCFramework
{
    /// <summary>
    /// 框架总入口
    /// </summary>
    public class Bootup : MonoBehaviour
    {
        private string m_managerName = "GameManager";
        private GameObject m_gameObject = null;
        
        // Use this for initialization
        void Awake()
        {
            if (GameObject.Find(m_managerName) == null)
            {
                m_gameObject = gameObject;
                m_gameObject.name = m_managerName;

                SystemInfoUtils.Instance.RecordSystemInfo();
                InitSettings();
                InitGameMangerObject();
            }
        }
        /// <summary>
        /// 初始化全局游戏管理者对象 
        /// </summary>
        private void InitGameMangerObject()
        {
            m_gameObject.AddComponentIfNotExist<SceneLoader>();
            m_gameObject.AddComponentIfNotExist<LuaManager>();
            m_gameObject.AddComponentIfNotExist<ResourceManager>();
            //if (ConstDefines.DebugMode)
            //{
            //    UITesterManager.Initialize(m_gameObject, new UITesterManager.UITestInitializeParameters
            //    {
            //        m_DoFile = (sFile) => { LuaManager.Instance.DoFile(sFile); },
            //        m_CallFunction = (sFunction) => { LuaManager.Instance.CallFunction(sFunction); },
            //    });
            //}
            m_gameObject.AddComponentIfNotExist<GameManager>();

            DontDestroyOnLoad(m_gameObject);
        }
        /// <summary>
        /// 初始化游戏设置
        /// </summary>
        private void InitSettings()
        {
            Screen.sleepTimeout = SleepTimeout.NeverSleep;
            Application.runInBackground = true;
            Application.targetFrameRate = ConstDefines.GameFrameRate;
        }
    }
}