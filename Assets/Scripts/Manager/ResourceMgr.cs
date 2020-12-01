using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using XLua;
using System;
using System.IO;
using System.Diagnostics;
using UnityEngine.SceneManagement;

namespace LPCFramework
{
    public class ResourceMgr
    {
        [LuaCallCSharp]
        public static void Load(string resourcePath, string assetname, Type systemTypeInstance, Action<UnityEngine.Object> action, AssetBundleTaskPriority assetBundleTaskPriority = AssetBundleTaskPriority.High)
        {
            try
            {
                bool loadFromAB = false;
                bool hasbundle = false;
                //先去热更目录寻找资源
                if (ResSetting.GetCurVersionInfo != null)
                    hasbundle = ResSetting.GetCurVersionInfo.isManifestFilsExist;
                if (hasbundle)
                {
                    string ab = resourcePath + ".ab";
                    loadFromAB = tryLoadFromAssetBundle(ab, assetname, systemTypeInstance, action, assetBundleTaskPriority, "Load From UniqueAB");

                    if (loadFromAB == false)
                    {
                        //木有小包，去整包里找找                    
                        string bigpkg = FileUtils.GetFilePath(resourcePath);
                        bigpkg += ".ab";
                        loadFromAB = tryLoadFromAssetBundle(bigpkg, assetname, systemTypeInstance, action, assetBundleTaskPriority, "Load From GroupAB");
                    }
                }

                if (loadFromAB == false)
                {
                    UnityEngine.Debug.LogFormat("<color=#33FFFF>Load From Resources {0} : {1}</color>", resourcePath, assetname);
                    UnityEngine.Object obj = Resources.Load(resourcePath, systemTypeInstance);
                    action(obj);
                }
            }
            catch (Exception e)
            {
                UnityEngine.Debug.LogError(e.Message + "  " + e.StackTrace);
                throw;
            }
        }

        [LuaCallCSharp]
        public static void Unload(string resourcePath)
        {
            //重要的事情说3遍，AB包之间减少依赖，同一份资源不要做很多个ab,如果做成一个，那么做成整包
            string ab = resourcePath + ".ab";
            AssetBundleMgr.Instance.UnloadAB(ab);
        }


        static Dictionary<string, AssetBundle> sceneBundles = new Dictionary<string, AssetBundle>();
        /// <summary>
        /// sceneab流程独立出来
        /// </summary>
        /// <param name="sname"></param>
        public static void TryLoadSceneAssetBundle(string sname)
        {
            if (sceneBundles.ContainsKey(sname))
            {
                UnityEngine.Debug.LogFormat("<color=#20F856>Already loaded Scene {0} From AB</color>", sname);
                return;
            }

            List<string> removed = new List<string>();
            foreach (var ab in sceneBundles)
            {
                if (ab.Key != sname)
                {
                    removed.Add(ab.Key);
                    if (ab.Value != null) ab.Value.Unload(true);
                }
            }
            foreach (var abname in removed)
            {
                sceneBundles.Remove(abname);
            }

            string scenename = "Scenes/" + sname;
            bool loadFromAB = false;
            if (!string.IsNullOrEmpty(scenename))
            {
                bool hadupdate = false;
                if (ResSetting.GetCurVersionInfo != null)
                    hadupdate = ResSetting.GetCurVersionInfo.isManifestFilsExist;
                if (hadupdate)
                {
                    string sceneab = scenename + ".ab";
                    string fullpath = ResSetting.GetCurVersionInfo.GetAssetBundleFullPath(sceneab);
                    if (File.Exists(fullpath))
                    {
                        AssetBundle ab = AssetBundle.LoadFromFile(fullpath);
                        sceneBundles.Add(sname, ab);
                        UnityEngine.Debug.LogFormat("<color=#20F856>Load Scene {0} From AB</color>", fullpath);
                    }
                    else
                    {
                        loadFromAB = false;

                    }
                }
            }

            if (loadFromAB == false)
            {
                UnityEngine.Debug.LogFormat("<color=#33FFFF>Load Scene{0} From Resources</color>", sname);
            }
        }

        public static byte[] LoadLua(string filepath)
        {
            try
            {
#if UNITY_EDITOR
                // 例：Lua文件中类似require "aaa.bbb"时，自动转换为路径aaa/bbb
                filepath = filepath.Replace(".", "/");

                if (false == filepath.EndsWith(ConstDefines.LuaExt))
                {
                    filepath = filepath + ConstDefines.LuaExt;
                }

                string script = string.Format("{0}/{1}{2}", Application.dataPath, ConstDefines.LuaFolderName, filepath);

                if (File.Exists(script))
                {
                    FileStream fs = File.Open(script, FileMode.Open);
                    if (fs != null)
                    {
                        long length = fs.Length;
                        byte[] bytes = new byte[length];
                        fs.Read(bytes, 0, bytes.Length);
                        fs.Close();

                        // 解密
                        if (ConstDefines.EncryptLua)
                        {
                            FileUtils.EncryptAll(ref bytes); //RC4 解密lua文件
                        }

                        // 转换为utf8
                        using (Stream stream = new MemoryStream(bytes))
                        {
                            using (StreamReader sr = new StreamReader(stream))
                            {
                                string code = sr.ReadToEnd();
                                return System.Text.Encoding.UTF8.GetBytes(code); ;
                            }
                        }
                    }
                }
                else
                {
                    UnityEngine.Debug.LogError("[error] Cant find " + script);
                }
                return null;
#else
                
                filepath = ("Lua/" + filepath).ToLower();

                if (filepath.EndsWith(".lua"))
                {
                    UnityEngine.Debug.LogError("[Error] Not allowed .lua param " + filepath);
                    return null;
                }

                filepath = filepath.Replace(".","/");

                byte[] luadata = null;
                bool loadFromAB = false;
                bool hadupdate = false;
                if (ResSetting.GetCurVersionInfo != null)
                    hadupdate = ResSetting.GetCurVersionInfo.isManifestFilsExist;
                if (hadupdate)
                {                    
                    string luafile = filepath + ".lua.txt";
                    string fullpath = ResSetting.GetCurVersionInfo.GetAssetBundleFullPath(luafile);

                    if(File.Exists(fullpath))
                    {
                        FileStream fs = System.IO.File.Open(fullpath, FileMode.Open);
                        if(fs != null)
                        {
                            long length = fs.Length;
                            byte[] bytes = new byte[length];
                            fs.Read(bytes, 0, bytes.Length);
                            fs.Close();

                            // 解密
                            if (ConstDefines.EncryptLua)
                            {
                                FileUtils.EncryptAll(ref bytes); //RC4 解密lua文件
                            }

                            // 转换为utf8
                            using (Stream stream = new MemoryStream(bytes))
                            {
                                using (StreamReader sr = new StreamReader(stream))
                                {
                                    string code = sr.ReadToEnd();
                                    luadata = System.Text.Encoding.UTF8.GetBytes(code);
                                    UnityEngine.Debug.LogFormat("<color=#20F856>Load  Lua From Update Folder {0}</color>", fullpath);
                                    loadFromAB = true;
                                }
                            }
                        }
                        else
                        {
                            loadFromAB = false;
                        }

                    }
                }

                if(loadFromAB == false)
                {
                    // 加上.lua后缀（文件格式: xxx.lua.txt）
                    if (false == filepath.EndsWith(ConstDefines.LuaExt))
                    {
                        filepath = filepath + ConstDefines.LuaExt;
                    }

                    TextAsset luatxt = Resources.Load<TextAsset>(filepath);
                    if (luatxt == null)
                    {
                        UnityEngine.Debug.LogError("No This Lua File :" + filepath);
                    }
                    else
                    {
                        luadata = System.Text.Encoding.UTF8.GetBytes(luatxt.text);
                        UnityEngine.Debug.LogFormat("<color=#33FFFF>Load  Lua From Resources {0}</color>", filepath);
                    }
                }

                return luadata;
#endif
            }
            catch (Exception e)
            {
                UnityEngine.Debug.LogError(e.Message + "  " + e.StackTrace);
                throw;
            }
        }

        /// <summary>
        /// UI比较特殊，有FairyGUI做管理所以资源不走abmgr流程，单独提2个接口
        /// </summary>
        [LuaCallCSharp]
        public static FairyGUI.UIPackage LoadUI(string uipath)
        {
            FairyGUI.UIPackage pkg = null;
            try
            {
                bool loadFromAB = false;
                //先去热更目录寻找资源
                bool hasbundle = false;
                //先去热更目录寻找资源
                if (ResSetting.GetCurVersionInfo != null)
                    hasbundle = ResSetting.GetCurVersionInfo.isManifestFilsExist;
                if (hasbundle)
                {
                    string abname = FileUtils.GetFilePath(uipath) + ".ab";
                    string abpath = ResSetting.GetCurVersionInfo.GetAssetBundleFullPath(abname);
                    AssetBundle ab = AssetBundle.LoadFromFile(abpath);

                    if (ab != null)
                    {
                        UnityEngine.Debug.LogFormat("<color=#20F856>Load UIPackage{0} From AB</color>", uipath);
                        pkg = FairyGUI.UIPackage.AddPackage(ab);
                        loadFromAB = true;
                    }
                }

                if (loadFromAB == false)
                {
                    UnityEngine.Debug.LogFormat("<color=#33FFFF>Load UIPackage{0} From Resources</color>", uipath);
                    pkg = FairyGUI.UIPackage.AddPackage(uipath);
                }
            }
            catch (Exception e)
            {
                UnityEngine.Debug.LogError(e.Message + "  " + e.StackTrace);
                throw;
            }
            return pkg;
        }
        [LuaCallCSharp]
        public static void UnLoadUI(string uipath, bool destroyRes)
        {
            FairyGUI.UIPackage.RemovePackage(uipath, destroyRes);
        }
        static bool tryLoadFromAssetBundle(string resourcePath, string assetname, Type systemTypeInstance, Action<UnityEngine.Object> action, AssetBundleTaskPriority assetBundleTaskPriority, string msg)
        {
            if (!string.IsNullOrEmpty(resourcePath))
            {
                string abpath = ResSetting.GetCurVersionInfo.GetAssetBundleFullPath(resourcePath);
                if (!System.IO.File.Exists(abpath)) return false;

                AssetBundleMgr.Instance.RequestLoadAsset(resourcePath, assetname, systemTypeInstance, assetBundleTaskPriority,
                 delegate (UnityEngine.Object obj)
                 {
                     UnityEngine.Debug.LogFormat("<color=#20F856>{0} : {1} : {2}</color>", msg, resourcePath, assetname);
                     action(obj);
                 });
                return true;
            }

            return false;
        }
    }
}
