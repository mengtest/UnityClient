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
using UnityEngine.SceneManagement;
using System.Collections.Generic;
using System.IO;
using XLua;
using UObject = UnityEngine.Object;

namespace LPCFramework
{
    /// <summary>
    /// 资源管理器
    /// 负责所有资源的加载、缓存、管理等
    /// </summary>
    public class ResourceManager : SingletonMonobehaviour<ResourceManager>, IManager
    {
        private string[] m_Variants = { };
        private AssetBundleManifest manifest;
        private AssetBundle shared, assetbundle;
        private Dictionary<string, AssetBundle> bundles;

        /// <summary>
        /// 初始化
        /// </summary>
        public void OnInitialize()
        {
            byte[] stream = null;
            string uri = string.Empty;
            bundles = new Dictionary<string, AssetBundle>();

            uri = LogicUtils.DataPath;
            if (!File.Exists(uri))
                return;

            stream = File.ReadAllBytes(uri);
            assetbundle = AssetBundle.LoadFromMemory(stream);
            manifest = assetbundle.LoadAsset<AssetBundleManifest>("AssetBundleManifest");
        }
        /// <summary>
        /// 更新逻辑
        /// </summary>
        public void OnUpdateLogic()
        {

        }

        /// <summary>
        /// 销毁资源
        /// </summary>
        public void OnDestruct()
        {
            if (shared != null)
                shared.Unload(true);

            if (manifest != null)
                manifest = null;

            Debug.Log("~ResourceManager was destroy!");
        }
        /// <summary>
        /// 指定路径加载Asset，完成后释放AssetBundle
        /// </summary>
        /// <typeparam name="T"></typeparam>
        /// <param name="path"></param>
        /// <param name="assetName"></param>
        /// <returns></returns>
        public T LoadAssetFromPath<T>(string path, string assetName, bool releaseImmediately=false) where T : UnityEngine.Object
        {
            T result = null;
            var loadedAssetBundle = AssetBundle.LoadFromFile(path);
            if (loadedAssetBundle != null)
                result = loadedAssetBundle.LoadAsset<T>(assetName);

            if (releaseImmediately || bundles.ContainsKey(loadedAssetBundle.name))
                loadedAssetBundle.Unload(false);
            else
                bundles.Add(loadedAssetBundle.name, loadedAssetBundle);

            return result;
        }

        /// <summary>
        /// 依据AssetBundle的名称和Asset的名称载入素材
        /// </summary>
        /// <typeparam name="T"></typeparam>
        /// <param name="abName"></param>
        /// <param name="assetName"></param>
        /// <returns></returns>
        public T LoadAsset<T>(string abName, string assetName) where T : UnityEngine.Object
        {
            abName = abName.ToLower();
            AssetBundle bundle = LoadAssetBundle(abName);

            if (bundle == null)
                return null;

            if (string.IsNullOrEmpty(assetName))
                return bundle.mainAsset as T;
            else
                return bundle.LoadAsset<T>(assetName);
        }
        /// <summary>
        /// 加载指定Bundle中所有资源
        /// </summary>
        /// <param name="bundle"></param>
        public void LoadAllAssetsInBundle(string abName)
        {
            abName = abName.ToLower();
            AssetBundle bundle = LoadAssetBundle(abName);

            if (bundle == null)
                return;

            bundle.LoadAllAssets();
        }
        /// <summary>
        /// 载入预制
        /// </summary>
        /// <param name="abName"></param>
        /// <param name="assetNames"></param>
        /// <param name="func"></param>
        public void LoadPrefab(string abName, string[] assetNames, LuaFunction func)
        {
            abName = abName.ToLower();
            List<UObject> result = new List<UObject>();
            for (int i = 0; i < assetNames.Length; i++)
            {
                UObject go = LoadAsset<UObject>(abName, assetNames[i]);
                if (go != null)
                    result.Add(go);
            }
            if (func != null)
                func.Call((object)result.ToArray());
        }

        /// <summary>
        /// 载入AssetBundle
        /// </summary>
        /// <param name="abname"></param>
        /// <returns></returns>
        public AssetBundle LoadAssetBundle(string abname)
        {
            if (!abname.EndsWith(ConstDefines.ExtName))
            {
                abname += ConstDefines.ExtName;
            }
            AssetBundle bundle = null;
            if (!bundles.ContainsKey(abname))
            {
                byte[] stream = null;
                string uri = LogicUtils.DataPath + abname;
                Debug.LogWarning("LoadFile::>> " + uri);
                LoadDependencies(abname);

                stream = File.ReadAllBytes(uri);
                bundle = AssetBundle.LoadFromMemory(stream); //关联数据的素材绑定
                bundles.Add(abname, bundle);
            }
            else
            {
                bundles.TryGetValue(abname, out bundle);
            }
            return bundle;
        }
        /// <summary>
        /// 载入依赖
        /// </summary>
        /// <param name="name"></param>
        private void LoadDependencies(string name)
        {
            if (manifest == null)
            {
                Debug.LogError("Please initialize AssetBundleManifest by calling AssetBundleManager.Initialize()");
                return;
            }
            // Get dependecies from the AssetBundleManifest object..
            string[] dependencies = manifest.GetAllDependencies(name);
            if (dependencies.Length == 0) return;

            for (int i = 0; i < dependencies.Length; i++)
                dependencies[i] = RemapVariantName(dependencies[i]);

            // Record and load all dependencies.
            for (int i = 0; i < dependencies.Length; i++)
            {
                LoadAssetBundle(dependencies[i]);
            }
        }

        // Remaps the asset bundle name to the best fitting asset bundle variant.
        private string RemapVariantName(string assetBundleName)
        {
            string[] bundlesWithVariant = manifest.GetAllAssetBundlesWithVariant();

            // If the asset bundle doesn't have variant, simply return.
            if (System.Array.IndexOf(bundlesWithVariant, assetBundleName) < 0)
                return assetBundleName;

            string[] split = assetBundleName.Split('.');

            int bestFit = int.MaxValue;
            int bestFitIndex = -1;
            // Loop all the assetBundles with variant to find the best fit variant assetBundle.
            for (int i = 0; i < bundlesWithVariant.Length; i++)
            {
                string[] curSplit = bundlesWithVariant[i].Split('.');
                if (curSplit[0] != split[0])
                    continue;

                int found = System.Array.IndexOf(m_Variants, curSplit[1]);
                if (found != -1 && found < bestFit)
                {
                    bestFit = found;
                    bestFitIndex = i;
                }
            }
            if (bestFitIndex != -1)
                return bundlesWithVariant[bestFitIndex];
            else
                return assetBundleName;
        }
    }
}
