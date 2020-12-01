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
using System.Collections.Generic;
using System.IO;
using System.Security.Cryptography;
using System.Text;
using UnityEngine;
using ICSharpCode.SharpZipLib.Zip;
using YamlDotNet.Serialization;
using YamlDotNet.Serialization.NamingConventions;
using XLua;
using FairyGUI;

namespace LPCFramework
{
    /// <summary>
    /// 逻辑工具集
    /// </summary>
    [LuaCallCSharp]
    public class LogicUtils
    {
        private static string AppDataPath;

        private static Deserializer YamlDeserializer = new DeserializerBuilder().WithNamingConvention(new CamelCaseNamingConvention()).Build();

        public static int Int(object o)
        {
            return Convert.ToInt32(o);
        }

        public static float Float(object o)
        {
            return (float)Math.Round(Convert.ToSingle(o), 2);
        }

        public static long Long(object o)
        {
            return Convert.ToInt64(o);
        }

        public static int Random(int min, int max)
        {
            return UnityEngine.Random.Range(min, max);
        }

        public static float Random(float min, float max)
        {
            return UnityEngine.Random.Range(min, max);
        }

        public static string Uid(string uid)
        {
            int position = uid.LastIndexOf('_');
            return uid.Remove(0, position + 1);
        }

        public static long GetTime()
        {
            TimeSpan ts = new TimeSpan(DateTime.UtcNow.Ticks - new DateTime(1970, 1, 1, 0, 0, 0).Ticks);
            return (long)ts.TotalMilliseconds;
        }

        #region 文件操作

        /// <summary>
        /// zip解压
        /// </summary>
        /// <param name="file"></param>
        /// <param name="dir"></param>
        /// <returns></returns>
        public static bool UnpackFiles(string file, string dir)
        {
            try
            {
                if (!Directory.Exists(dir))
                    Directory.CreateDirectory(dir);

                ZipInputStream s = new ZipInputStream(File.OpenRead(file));
                ZipConstants.DefaultCodePage = 65001;
                ZipEntry theEntry;
                while ((theEntry = s.GetNextEntry()) != null)
                {

                    string directoryName = Path.GetDirectoryName(theEntry.Name);
                    string fileName = Path.GetFileName(theEntry.Name);

                    if (directoryName != String.Empty)
                        Directory.CreateDirectory(dir + directoryName);

                    if (fileName != String.Empty)
                    {
                        FileStream streamWriter = File.Create(dir + theEntry.Name);

                        int size = 2048;
                        byte[] data = new byte[2048];
                        while (true)
                        {
                            size = s.Read(data, 0, data.Length);
                            if (size > 0)
                            {
                                streamWriter.Write(data, 0, size);
                            }
                            else
                            {
                                break;
                            }
                        }

                        streamWriter.Close();
                    }
                }
                s.Close();
                return true;
            }
            catch (Exception)
            {
                throw;
            }
        }

        /// <summary>
        /// 加载指定文件
        /// </summary>
        /// <param name="folder"></param>
        /// <param name="fileName"></param>
        /// <returns></returns>
        public static UnityEngine.Object LoadResource(string path)
        {
            if (string.IsNullOrEmpty(path))
            {
                Debug.Log("[error] Path cant be null!");
                return null;
            }

            UnityEngine.Object target;
            // 开发模式从Resource目录加载
            if (ConstDefines.DebugMode)
            {
                target = Resources.Load(path) as UnityEngine.Object;
            }
            else
            {
                // todo: 根据打包策略决定如何加载资源

                //target = ResourceManager.Instance.LoadAsset<UnityEngine.Object>(assetBundleName, fileName);
            }

            if (target == null)
                Debug.Log("[error] Cant load file from " + path);

            return target;
        }
        /// <summary>
        /// 反序列化YAML字符串到指定的类型对象
        /// </summary>
        /// <typeparam name="T">反虚拟化的对象类型。</typeparam>
        /// <param name="content">文件内容</param>
        /// <returns>反序列化的对象。抛出异常或者返回null都表示失败。</returns>
        public static T DeserializeYAMLContent<T>(string content) where T : class
        {
            if (string.IsNullOrEmpty(content))
                return null;

            T tOut = null;
            try
            {
                tOut = YamlDeserializer.Deserialize<T>(content);
            }
            catch (Exception e)
            {
                Debug.LogError("[error] 解析YAML文件错误: " + e);
            }

            return tOut;
        }



        #endregion 文件操作

        #region 各平台文件路径
        /// <summary>
        /// 取得数据存放目录
        /// </summary>
        public static string DataPath
        {
            get
            {
                if (string.IsNullOrEmpty(AppDataPath))
                {
                    string game = ConstDefines.AppName.ToLower();

                    // Debug模式
                    if (ConstDefines.DebugMode)
                    {
                        AppDataPath = Application.dataPath + "/Resources/";
                    }
                    // 移动平台
                    else if (Application.isMobilePlatform)
                    {
                        AppDataPath = Application.persistentDataPath + "/";
                    }
                    // osx平台
                    else if (Application.platform == RuntimePlatform.OSXEditor)
                    {
                        int i = Application.dataPath.LastIndexOf('/');
                        AppDataPath = Application.dataPath.Substring(0, i + 1) + game + "/";
                    }
                    else
                    {
                        AppDataPath = Application.dataPath + "/StreamingAssets/";
                    }
                }

                return AppDataPath;
            }
        }
        /// <summary>
        /// 获取绝对路径
        /// </summary>
        /// <returns></returns>
        public static string GetRelativePath()
        {
            return "file:///" + DataPath;
        }
        /// <summary>
        /// 应用程序内容路径
        /// </summary>
        public static string AppContentPath()
        {
            string path = string.Empty;
            switch (Application.platform)
            {
                case RuntimePlatform.Android:
                    path = "jar:file://" + Application.dataPath + "!/assets/";
                    break;
                case RuntimePlatform.IPhonePlayer:
                    path = Application.dataPath + "/Raw/";
                    break;
                default:
                    path = "file:///" + Application.dataPath + "/StreamingAssets/";
                    break;
            }
            return path;
        }
        #endregion

        #region 网络
        /// <summary>
        /// 网络可用
        /// </summary>
        public static bool NetAvailable
        {
            get
            {
                return Application.internetReachability != NetworkReachability.NotReachable;
            }
        }

        /// <summary>
        /// 是否是无线
        /// </summary>
        public static bool IsWifi
        {
            get
            {
                return Application.internetReachability == NetworkReachability.ReachableViaLocalAreaNetwork;
            }
        }
        #endregion

        public static Vector3 WorldToScreenPoint(GameObject go)
        {
            Vector3 v = Camera.main.WorldToViewportPoint(go.transform.position);
            v = new Vector3(v.x * GRoot.inst.width, (1 - v.y) * GRoot.inst.height);
            return v;
        }
        /// <summary>
        /// 清理内存
        /// </summary>
        public static void ClearMemory()
        {
            GC.Collect();
            Resources.UnloadUnusedAssets();

            LuaManager.Instance.LuaGC();
        }
        /// <summary>
        /// 改变sortingLayer
        /// </summary>
        public static void SetSortingLayer(Transform target, string layerId)
        {
            foreach (Transform child in target)
            {
                Renderer render = child.GetComponent<Renderer>();
                if (null != render)
                {
                    render.sortingLayerID = SortingLayer.NameToID(layerId);
                }
                // 进入此节点的子节点查找
                SetSortingLayer(child, layerId);
            }
        }
    }
}