/*
* ==============================================================================
* 
* Created: 2017-4-13
* Author: Jeremy
* Company: LightPaw
* 
* ==============================================================================
*/

using System;
using UnityEngine;
using UnityEngine.UI;
using System.Collections;
using System.IO;
using System.Collections.Generic;
using Random = UnityEngine.Random;
namespace LPCFramework
{
    public delegate void OnUpdateComplete();
    public class UpdateMgr : MonoBehaviour
    {
        private static UpdateMgr s_instance;
        // 远程资源服务器下载地址列表
        private List<string> m_remoteUriList = new List<string>();

        //客户端通过服务器发送来的版本号查找出来的自身版本号
        private int curResVersion ;        
        private long downloadfilelength;
        private long downloadfileorilength;

        // 当前使用的远程服务器的index
        private int m_remoteUriIndex = 0;
                                                                                  
        OnUpdateComplete onUpdateComplete;
        
        void Awake()
        {
            s_instance = this;            
            DownloadMgr.Instance.Init();
        }

        public void CheckUpdate(OnUpdateComplete updateComplete)
        {
            SetDownloadURI();
            ResSetting.InitSetting();
            onUpdateComplete = updateComplete;
            CheckVersion();            
        }

        public void CheckVersion()
        {
            if (IsVersionNeedUpdate())
            {
                StartCoroutine(ShowDownLoadInfo());
            }
            else
            {                
                UpdateComplete();
            }
        }

        void UpdateComplete()
        {
            Debug.Log("<color=#20F856>验证版本完成</color>");            
            AssetBundleMgr.Instance.Init(10);

            if (onUpdateComplete != null)
            {
                onUpdateComplete.Invoke();
            }
        }

        public bool isNativeVerison()
        {
            return ResSetting.ServerResVersion == ResSetting.LocalResVersion;
        }

        /// <summary>
        /// 根据服务器的版本号检测当前版本是否需要更新
        /// </summary>        
        public bool IsVersionNeedUpdate()
        {
            //服务器资源版本号小于发布版本号,那么无法更新需要去appstore上更新
            if (ResSetting.ServerResVersion < ResSetting.LocalResVersion)
            {
                Debug.LogError("[Update Manager] ,当前版本由于程序集更新 无法回滚到 服务器对应的版本 ！ 服务器版本为：" + ResSetting.ServerResVersion + "  程序集版本为：" + ResSetting.LocalResVersion);
                curResVersion = ResSetting.LocalResVersion;
                return false;
            }

            //服务器资源版本号与发布版本号一致,那么不需要更新
            if (ResSetting.ServerResVersion == ResSetting.LocalResVersion)
            {
                Debug.LogFormat("<color=#CDCD00>[Update Manager] ; 程序集{0}与服务器资源版本号{1}一致，无需更新</color>", ResSetting.LocalResVersion, ResSetting.ServerResVersion);
                curResVersion = ResSetting.ServerResVersion;
                return false;
            }

            string findversionf = Application.persistentDataPath + "/" + ResSetting.ServerResVersion + "/version.txt";

            //服务器资源版本与本地热更包版本号一致，那么不需要更新
            if (File.Exists(findversionf))
            {
                Debug.LogFormat("<color=#CDCD00>[Update Manager] ;  客户端资源版本与服务器版本号一致，无需更新</color>", ResSetting.LocalResVersion, ResSetting.ServerResVersion);
                curResVersion = ResSetting.ServerResVersion;
                return false;
            }

            curResVersion = ResSetting.ServerResVersion - 1;
            while (true)
            {
                if (curResVersion < ResSetting.LocalResVersion)
                {
                    curResVersion = ResSetting.LocalResVersion;
                    Debug.LogError("[Update Manager] ,当前版本由于程序集更新 无法回滚到 服务器对应的版本 ！ 服务器版本为：" + ResSetting.ServerResVersion);
                    return false;
                }
                else
                {
                    if (curResVersion == ResSetting.LocalResVersion)
                    {
                        Debug.LogFormat("<color=#CDCD00>[Update Manager] ; 检测到客户端需要从整包更新 {0} to {1}</color>", curResVersion, ResSetting.ServerResVersion);
                        return true;
                    }
                    else
                    {
                        string versionf = Application.persistentDataPath + "/" + curResVersion + "/version.txt";
                        if (File.Exists(versionf))
                        {
                            Debug.LogFormat("<color=#CDCD00>[Update Manager] ; 检测到客户端需要从资源包更新 {0} to {1}</color>", curResVersion, ResSetting.ServerResVersion);
                            return true;
                        }

                    }
                }
                curResVersion--;
            }
        }
        private IEnumerator ShowDownLoadInfo()
        {
            Debug.Log("<color=#20F856>显示下载文件数据</color>");
            string zipinfo = string.Format("{0}-{1}.info?", curResVersion, ResSetting.ServerResVersion);
            WWW www = new WWW(m_remoteUriList[m_remoteUriIndex] + zipinfo);// + Random.Range(100000, 999999).ToString());
            yield return www;
            if (www.error != null)
            {
                if (ChangeDownloadUri())
                {
                    yield return StartCoroutine(ShowDownLoadInfo());
                }
                else
                {
                    Debug.LogError("info文件加载失败:" + www.error);
                }
                yield break;
            }

            using (MemoryStream ms = new MemoryStream(www.bytes))
            {
                using (StreamReader sr = new StreamReader(ms))
                {
                    string strline;
                    strline = sr.ReadLine();                    
                    string[] info = strline.Split(':');
                    if (info.Length == 3)
                    {
                        downloadfilelength = long.Parse(info[1]);
                        downloadfileorilength = long.Parse(info[2]);
                    }
                    sr.Close();
                }
                ms.Close();
            }
            www.Dispose();
            
            Debug.LogFormat("<color=#20F856>下载文件数据读取完成,需要下载{0}大小的更新包,原始大小为:{1} </color>",downloadfilelength,downloadfileorilength);

            bool UserSelectDown = true;//todo lua ui callback ,do update ()=>{BeginUpdate(allowuseCarrierData);} 

            //这里需要弹出2个界面 ： 1 检测到当前需要下载一个X大小的文件包，是否下载？
            //2 ： 检测一下玩家的网络环境，如果是非wifi情况下，让玩家选择是否允许非wifi下载。
            bool allwithwifi = false;//允许的话后面无需判断直接下载即可

            //no ui ,call update now.

            Debug.Log("<color=#20F856>开始更新</color>");            
            string downloadfolder = Application.persistentDataPath;
            string zipfile = string.Format("{0}-{1}", curResVersion, ResSetting.ServerResVersion);



            DownloadMgr.Instance.CreateDownloadTask(string.Format("{0}.zip", zipfile), downloadfolder, zipfile, ".zip", downloadfilelength, allwithwifi);
            DownloadMgr.Instance.BeginDownload();

            long downloadSize = DownloadMgr.Instance.GetCurDownloadSize();
            RegisterDownloadEvent();
        }

        private void RegisterDownloadEvent()
        {
            DownloadMgr.Instance.download_progress = DownLoadProcess;
            DownloadMgr.Instance.unzip_length = UnzipProcess;
            DownloadMgr.Instance.update_result = UpdateResult;            
        }
        
        void UnzipProcess(long unziplength)
        {
            float process = (float)unziplength / downloadfileorilength;
            Debug.Log("解压进度  "+process);
        }

        void DownLoadProcess(string process)
        {
            Debug.Log("下载进度  " + process);
        }
        void UpdateResult(bool result)
        {
            if(result)
            {
                Debug.Log("<color=#20F800>资源更新成功</color>");
                ResSetting.AfterUpdateRefreshServerInfo();
                UpdateComplete();
            }
            else
            {
                Debug.Log("<color=#CC0033>资源更新失败</color>");
                // todo  UI ，退出游戏
            }
        }
        

        public void ResetUseUri()
        {
            m_remoteUriIndex = 0;
        }

        public string GetNowUseUri()
        {
            return m_remoteUriList[m_remoteUriIndex];
        }

        public bool ChangeDownloadUri()
        {
            bool changeSuccess = false;

            if (m_remoteUriIndex + 1 >= m_remoteUriList.Count)
            {
                m_remoteUriIndex = 0;
            }

            if (m_remoteUriIndex + 1 < m_remoteUriList.Count)
            {
                m_remoteUriIndex += 1;
                changeSuccess = true;
            }
            return changeSuccess;
        }

        public static UpdateMgr Instance
        {
            get
            {
                if (s_instance == null)
                {
                    GameObject go = new GameObject("UpdateMgr", typeof(UpdateMgr));
                    GameObject.DontDestroyOnLoad(go);
                }
                return s_instance;
            }
        }

        private string DownloadURI(string fileName)
        {
            string remoteUri = this.m_remoteUriList[m_remoteUriIndex];
            return string.Format("{0}{1}", remoteUri, fileName);
        }

        private void SetDownloadURI()
        {            
            this.m_remoteUriList.Add(ResSetting.m_sUpdateServerURL);            
            this.m_remoteUriIndex = 0;
            for (int i = 0; i < this.m_remoteUriList.Count; i++)
            {
#if UNITY_ANDROID
            this.m_remoteUriList[i] = this.m_remoteUriList[i] + "Android/UpdateZip/";
#elif UNITY_IPHONE || UNITY_IOS
            this.m_remoteUriList[i] = this.m_remoteUriList[i] + "IOS/UpdateZip/";
#else 
            this.m_remoteUriList[i] = this.m_remoteUriList[i] + "Win/UpdateZip/";
#endif
            }
        }

        private void FixedUpdate()
        {
            DownloadMgr.Instance.FixedUpdate();
        }

        void OnDestroy()
        {
            DownloadMgr.Instance.ClearAllTask();
        }
    }
}