/*
* ==============================================================================
* 
* Created: 2017-4-13
* Author: Jeremy
* Company: LightPaw
* 
* ==============================================================================
*/

using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using XLua;
using System.IO;
namespace LPCFramework
{

    /// <summary>
    /// 客户端当前的版本资源信息
    /// </summary>
    [LuaCallCSharp]
    public class ResourceVersionInfo
    {
        public ResourceVersionInfo(int sversion)
        {
            serverSyncVersion = sversion;
        }
        //服务器同步过来的版本号
        private int serverSyncVersion = 1;

        //AssetBundle版本文件
        //string :ab path, string: ab version folder
        Dictionary<string, string> versionInfo = new Dictionary<string, string>();


        public bool isManifestFilsExist
        {
            get
            {
                return File.Exists(GetManifestFile);
            }
        }

        /// <summary>
        /// 当前对应版本manifest file
        /// </summary>
        public string GetManifestFile
        {
            get
            {
                string manifest = string.Format("{0}/{1}",serverSyncVersion,serverSyncVersion);
                string file = Application.persistentDataPath + "/" + manifest;

                return file;
            }
        }

        /// <summary>
        /// 当前对应版本version.txt
        /// </summary>
        public string GetVersionFile
        {
            get
            {
                string versionfile = string.Format("{0}/version.txt", serverSyncVersion);
                string version = Application.persistentDataPath + "/" +versionfile;
                return versionfile;
            }
        }

        /// <summary>
        /// 当前对应版本folder
        /// </summary>
        public string GetVersionFolder
        {
            get
            {
                string versionfolder = string.Format("{0}/", serverSyncVersion);
                string version = Application.persistentDataPath + "/" + versionfolder;
                return versionfolder;
            }
        }

        public string GetAssetBundleFullPath(string relativepath)
        {
            string abfolder = "";
            string abfullpath = "";
            relativepath = relativepath.ToLower();
            versionInfo.TryGetValue(relativepath,out abfolder);
            if (!string.IsNullOrEmpty(abfolder))
                abfullpath = Application.persistentDataPath + "/" + abfolder + "/" + relativepath;

            return abfullpath;
            
        }

        public bool isVersionFileExist()
        {
            string versionfile = string.Format("{0}/version.txt", serverSyncVersion);
            string version = Application.persistentDataPath + "/" + versionfile;
            return File.Exists(version);
        }


        /// <summary>
        /// 解析对应此服务器版本的资源文件列表,调用则重新解析一次
        /// </summary>
        public void DisassembleVersionList()
        {
            string versionfile = string.Format("{0}/version.txt",serverSyncVersion);
            string version = Application.persistentDataPath + "/"+ versionfile;

            if (!isVersionFileExist())
            {
                Debug.LogFormat("<color=#FFFF33> 检测不到version文件:{0} ,需要从服务器更新</color>", version);
                return;
            }
            versionInfo.Clear();
            StreamReader r = new StreamReader(version);
            string info = r.ReadToEnd();
            r.Close();
            string[] sArray = info.Split('\n');
            for(int i = 0;i<sArray.Length;i++)
            {
                if (string.IsNullOrEmpty(sArray[i]))
                    continue;

                string[] resinfo = sArray[i].Split(':');

                if(resinfo.Length == 3)
                {
                    string filepath = resinfo[0];
                    string fileversion = resinfo[2].Replace("\r","");

                    if (!versionInfo.ContainsKey(filepath))
                    {                        
                        versionInfo.Add(filepath, fileversion);
                    }
                }
            }
        }    
    }


    [LuaCallCSharp]
    public class ResSetting
    {
        // 更新服务器地址        
        public static string m_sUpdateServerURL = "http://192.168.1.73:16311/";

        //客户端资源版本号：依赖于客户端大版本号(由服务器决定是否可以降版本),版本发布时写入
        //在当前大版本中可以通过服务器配置资源版本号进入任意服务器
        //Resrouce文件夹下的资源版本，每次出大版本时所有资源都存在Resources文件夹下，并且将对应资源打成一个相应版本的AB
        //那么低于此大版本的包必须去appstore上更新版本。
        //测试时0 ,package publish ,will load from ab , 1 will load from resources
        static int localresversion;
        public static int LocalResVersion
        {
            get { return localresversion; }            
        }

        //当前所在服务器的资源版本
        //static int sResVer;
        public static int ServerResVersion
        {
            get;set;
        }
        
        public static void InitSetting()
        {
            TextAsset resinfo = Resources.Load<TextAsset>("resversion");
            if(resinfo != null)
            {                
                string version = resinfo.text.Replace("\r","");
                if (!int.TryParse(version, out localresversion))
                    localresversion = 1;
            }
            else
            {
                localresversion = 1;
            }
            CacheVersionInfo();
        }


        //当前缓存的服务器资源版本列表：切服务器时先比较资源版本号，如果相同则不需要重新解析一次
        static Dictionary<int, ResourceVersionInfo> cachedclientversions = new Dictionary<int, ResourceVersionInfo>();
                        
        public static ResourceVersionInfo GetCurVersionInfo
        {
            get
            {
                if (cachedclientversions.ContainsKey(ServerResVersion))
                    return cachedclientversions[ServerResVersion];

                return null;
            }                                  
        }

        static void CacheVersionInfo()
        {
            for(int i = localresversion+1 ;i<=ServerResVersion;i++)
            {
                ResourceVersionInfo info = new ResourceVersionInfo(i);
                if (info.isVersionFileExist())
                {
                    cachedclientversions.Add(i, info);
                    info.DisassembleVersionList();
                }
            }
        }

        public static void AfterUpdateRefreshServerInfo()
        {
            ResourceVersionInfo info = new ResourceVersionInfo(ServerResVersion);
            if (info.isVersionFileExist())
            {
                cachedclientversions.Add(ServerResVersion, info);
                info.DisassembleVersionList();
            }
        }

        public static string AppContentPath()
        {
            switch (Application.platform)
            {
                case RuntimePlatform.Android:
                    return "jar:file://" + Application.dataPath + "!/assets/";
                case RuntimePlatform.IPhonePlayer:
                    return "file://" + Application.dataPath + "/Raw/";
                default:
                    return "file://" + Application.dataPath + "/StreamingAssets/";
            }
        }
    }
}
