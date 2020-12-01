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
using System.Collections;
using System;
using System.IO;
using XLua;

namespace LPCFramework
{
    /// <summary>
    /// 游戏逻辑管理器
    /// </summary>
    public class GameManager : SingletonMonobehaviour<GameManager>, IManager
    {
        // 是否已初始化
        protected static bool m_isInitialized = false;

        protected string m_appPath = string.Empty;// + ConstDefines.AppName.ToLower() + "/";

        /// <summary>
        /// 引擎自带函数-初始化
        /// </summary>
        void Awake()
        {
            OnInitialize();
        }
        /// <summary>
        /// 引擎自带函数-更新
        /// </summary>
        void Update()
        {
            OnUpdateLogic();

#if UNITY_EDITOR || UNITY_STANDALONE
            CheckUserInput();
#endif

        }
        /// <summary>
        /// 引擎自带函数-析构
        /// </summary>
        void OnDestroy()
        {
            OnDestruct();
        }
        /// <summary>
        /// 初始化
        /// </summary>
        public void OnInitialize()
        {
            m_appPath = Application.persistentDataPath + "/";

            // 检查资源
            //CheckExtractResource();

            OnLateInitialize();
        }

        private void OnLateInitialize()
        {
            if (NetworkManager.Instance != null)
            {
                NetworkManager.Instance.OnInitialize();
            }

            if (LuaManager.Instance != null)
            {
                LuaManager.Instance.OnInitialize();
            }

            if (ResourceManager.Instance != null)
            {
                ResourceManager.Instance.OnInitialize();
            }

            if (AudioManager.Instance != null)
            {
                AudioManager.Instance.OnInitialize();
            }


            //test 
            //ResSetting.ServerResVersion = 1;
            //UpdateMgr.Instance.CheckVersion();


            // 初始化游戏逻辑
            OnInitializeGameLogic();
        }
        /// <summary>
        /// 逻辑更新
        /// </summary>
        public void OnUpdateLogic()
        {
            if (!m_isInitialized)
                return;

            if (NetworkManager.Instance != null)
            {
                NetworkManager.Instance.OnUpdateLogic();
            }
            if (LuaManager.Instance != null)
            {
                LuaManager.Instance.OnUpdateLogic();
            }
            if (ResourceManager.Instance != null)
            {
                ResourceManager.Instance.OnUpdateLogic();
            }
        }

        /// <summary>
        /// 析构函数
        /// </summary>
        public void OnDestruct()
        {
            if (NetworkManager.Instance != null)
            {
                NetworkManager.Instance.OnDestruct();
            }
            if (LuaManager.Instance != null)
            {
                LuaManager.Instance.OnDestruct();
            }
            if (ResourceManager.Instance != null)
            {
                ResourceManager.Instance.OnDestruct();
            }

            if (AudioManager.Instance != null)
            {
                AudioManager.Instance.OnDestruct();
            }

            Debug.Log("~GameManager was destroyed!");
        }
        /// <summary>
        /// 热重启，不需要关闭游戏，Editor模式下也不需要停止play
        /// </summary>
        public void OnReboot()
        {
            OnDestruct();
            OnInitialize();
        }
        /// <summary>
        /// 初始化，开始加载游戏逻辑
        /// </summary>
        private void OnInitializeGameLogic()
        {
            // 加载MainLua，绑定C#代理到Lua脚本
            CSharpCallLuaDelegates.Instance.Initialize();

            // 进入Lua脚本逻辑
            if (CSharpCallLuaDelegates.Instance.LuaGameManagerEntry != null)
                CSharpCallLuaDelegates.Instance.LuaGameManagerEntry.init();

            m_isInitialized = true;
        }
        /// <summary>
        /// 检测用户输入
        /// </summary>
        private void CheckUserInput()
        {
            // 一键热重启
            if (Input.GetKeyUp(KeyCode.F5))
                OnReboot();
        }

        #region 解压文件
        /// <summary>
        /// 检查抽取资源
        /// </summary>
        public void CheckExtractResource()
        {
            bool isExists = Directory.Exists(m_appPath) &&
                Directory.Exists(m_appPath + ConstDefines.LuaFolderName);

            //文件已经解压过或者编辑器下，直接跳过
            if (isExists || Application.isEditor)
            {
                OnLateInitialize();
                return;
            }

            //启动抽取数据协成
            StartCoroutine(OnExtractResource());
        }
        /// <summary>
        /// 开始抽取原始资源
        /// </summary>
        /// <returns></returns>
        private IEnumerator OnExtractResource()
        {
            //目标目录
            string resourcePath = LogicUtils.AppContentPath() + ConstDefines.SourceFileName;   //游戏资源包路径

            // 清空内容
            if (Directory.Exists(m_appPath))
                Directory.Delete(m_appPath, true);

            Directory.CreateDirectory(m_appPath);

            // 读取原始资源
            byte[] bytes = null;

#if UNITY_EDITOR || UNITY_STANDALONE || UNITY_ANDROID

            WWW www = new WWW(resourcePath);
            yield return www;
            if (www.error != null)
            {
                Debug.LogError("[error] Read raw source failed!!! " + www.error);
                yield break;
            }
            bytes = www.bytes;
#elif UNITY_IPHONE

            bytes = FileUtils.ReadFileToBytes(resourcePath);
	        if(bytes == null)
		        Debug.LogError("[error] Read raw source failed!!! " + resourcePath); 

#endif
            if (bytes != null)
            {
                // 拷贝原始资源到Persistent Data Path
                string targetFilePath = m_appPath + ConstDefines.SourceFileName;
                FileUtils.WriteFile(targetFilePath, bytes);
                //解压缩
                FileUtils.UnZipFiles(targetFilePath, m_appPath);

                yield return new WaitForEndOfFrame();

                //删除临时zip包
                File.Delete(@targetFilePath);

                yield return new WaitForEndOfFrame();
                Debug.Log(">>>>Extracting raw files completed!!!");
            }

            OnLateInitialize();
        }
        #endregion
    }
}