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
using UnityEngine.SceneManagement;
using System.Collections;
using System.Collections.Generic;
using XLua;
using System.IO;
using ICSharpCode.SharpZipLib.Zip;

namespace LPCFramework
{
    public enum AssetBundleTaskPriority
    {
        High,
        Low,
    }

    public class AssetBundleMgr : SingletonMonobehaviour<AssetBundleMgr>
    {
        // 当前版本资源主索引
        private AssetBundle curab = null;
        public AssetBundleManifest CurManifest
        {
            get;
            private set;
        }
                        
        private int _maxLoadNum;
        private int _nowLoadNum;
               
        private Queue<AssetBundleLoadingTask> _queueHighPriorityWaitLoad = new Queue<AssetBundleLoadingTask>();
        private Queue<AssetBundleLoadingTask> _queueLowPriorityWaitLoad = new Queue<AssetBundleLoadingTask>();

        public Dictionary<string, AssetBundleReference> LoadedABRefMap = new Dictionary<string, AssetBundleReference>();
                
        private AsyncOperation m_asyncSceneLoad = null;
        public event Action<string, float> onSceneLoadOutput;

        public void Init(int maxLoadNum)
        {                        
            //to do change server clear reference
            _maxLoadNum = maxLoadNum;
            _nowLoadNum = 0;
            CurManifest = null;
            if(UpdateMgr.Instance.isNativeVerison())
            {
                Debug.Log("Native Version ,No need to read manifest");
                return;
            }
            LoadVersionManifest();
        }

        void LoadVersionManifest()
        {
            if(ResSetting.GetCurVersionInfo == null)
            {
                UnityEngine.Debug.LogError("Never Happen ,fatal bug...");
                return;
            }
            string versionManifest = ResSetting.GetCurVersionInfo.GetManifestFile;

            if(string.IsNullOrEmpty(versionManifest))
            {
                UnityEngine.Debug.LogError("version is null ??");
                return;
            }

            if(!File.Exists(versionManifest))
            {
                Debug.LogFormat("<color=#FFFF33> No Manifest File in path {0}</color>", versionManifest);   
                return;
            }
            if (curab != null) curab.Unload(true);  
            curab = AssetBundle.LoadFromFile(versionManifest);

            if(curab == null)
            {
                Debug.LogError("[Error Load Manifest File] ,LoadFromFile is null :" + versionManifest);
                return;
            }

            CurManifest = (AssetBundleManifest)curab.LoadAsset("AssetBundleManifest");
            curab.Unload(false);
            Debug.Log("<color=#20F856>AssetBundleMgr初始化完毕</color>");
        }

        public void RequestLoadAsset(string assetBundleName, string assetName, Type systemTypeInstance, AssetBundleTaskPriority assetBundleTaskPriority, Action<UnityEngine.Object> action)
        {         
            AssetBundleLoadingTask ablt = new AssetBundleLoadingTask(assetBundleName, assetName, systemTypeInstance, action);            
            AddAssetBundleLoadTaskToQueue(ablt, assetBundleTaskPriority);
        }

        public void AddAssetBundleLoadTaskToQueue(AssetBundleLoadingTask assetBundleLoadTask, AssetBundleTaskPriority assetBundleTaskPriority)
        {
            switch (assetBundleTaskPriority)
            {
                case AssetBundleTaskPriority.High:
                    _queueHighPriorityWaitLoad.Enqueue(assetBundleLoadTask);
                    break;
                case AssetBundleTaskPriority.Low:
                    _queueLowPriorityWaitLoad.Enqueue(assetBundleLoadTask);
                    break;
            }
            FindLoadTask();
        }

        public void FindLoadTask()
        {
            while (_nowLoadNum < _maxLoadNum)
            {
                if (_queueHighPriorityWaitLoad.Count > 0)
                {
                    LoadAssetBundle(_queueHighPriorityWaitLoad.Dequeue());
                    _nowLoadNum += 1;
                }
                else
                {
                    if (_queueLowPriorityWaitLoad.Count > 0)
                    {
                        LoadAssetBundle(_queueLowPriorityWaitLoad.Dequeue());
                        _nowLoadNum += 1;
                    }
                }
                if ((_queueLowPriorityWaitLoad.Count == 0) && (_queueHighPriorityWaitLoad.Count == 0))
                {
                    break;
                }
            }
        }

        private void LoadAssetBundle(AssetBundleLoadingTask assetBundleLoadTask)
        {
            //如果这个ab已经加载过了
            if(LoadedABRefMap.ContainsKey(assetBundleLoadTask.m_assetBundleName))
            {
                AssetBundleReference abreference = LoadedABRefMap[assetBundleLoadTask.m_assetBundleName];
                if (abreference == null || abreference.assetbundle == null)
                {
                    // reload this assetbundle
                    LoadedABRefMap.Remove(assetBundleLoadTask.m_assetBundleName);                    
                    BeginLoadAssetBundle(assetBundleLoadTask);
                }
                else
                {
                    AssetBundle loadedab = abreference.assetbundle;
                    UnityEngine.Object targetObj = null;
                    if (assetBundleLoadTask.m_systemTypeInstance != null)
                    {
                        targetObj = LoadedABRefMap[assetBundleLoadTask.m_assetBundleName].assetbundle.LoadAsset(assetBundleLoadTask.m_assetName, assetBundleLoadTask.m_systemTypeInstance);       
                    }
                    else
                    {
                        targetObj = LoadedABRefMap[assetBundleLoadTask.m_assetBundleName].assetbundle.LoadAsset(assetBundleLoadTask.m_assetName);           
                    }
                    for (int i = 0; i < assetBundleLoadTask.m_actionList.Count; i++)
                    {
                        assetBundleLoadTask.m_actionList[i](targetObj);
                    }
                    abreference.AddDependsRef();
                    assetBundleLoadTask.ClearSelf();
                    _nowLoadNum -= 1;
                    FindLoadTask();                    
                }               
            }
            else
            {                
                BeginLoadAssetBundle(assetBundleLoadTask);
            }            
        }
        
        void BeginLoadAssetBundle(AssetBundleLoadingTask assetBundleLoadTask)
        {
            string[] dependentAssetBundles = CurManifest.GetAllDependencies(assetBundleLoadTask.m_assetBundleName);                  
            List<string> needdepends = new List<string>();
            for(int i = 0;i< dependentAssetBundles.Length; i++)
            {
                if (LoadedABRefMap.ContainsKey(dependentAssetBundles[i]))
                {
                    AssetBundleReference abreference = LoadedABRefMap[dependentAssetBundles[i]];
                    if (abreference == null || abreference.assetbundle == null)
                    {                        
                        LoadedABRefMap.Remove(dependentAssetBundles[i]);
                        needdepends.Add(dependentAssetBundles[i]);                        
                    }         
                }
                else
                {
                    needdepends.Add(dependentAssetBundles[i]);                    
                }
            }

            if(needdepends.Count == 0)
            {
                AllDependentABLoad(assetBundleLoadTask);
            }
            else
            {
                for (int i = 0; i < needdepends.Count; i++)
                {
                    string abpath = ResSetting.GetCurVersionInfo.GetAssetBundleFullPath(needdepends[i]);
                    AssetBundle ab = AssetBundle.LoadFromFile(abpath);                    

                    if (ab == null)
                    {
                        Debug.LogError("depend ab load fail : path is :" + abpath);
                        return;
                    }

                    AssetBundleReference abref = new AssetBundleReference(ab, needdepends[i]);
                    LoadedABRefMap.Add(needdepends[i],abref);                    
                }

                AllDependentABLoad(assetBundleLoadTask);
            }

        }

        public void AllDependentABLoad(AssetBundleLoadingTask assetBundleLoadTask)
        {
            if (assetBundleLoadTask.m_isScene)
            {
                //StartCoroutine(OnSceneAllDependentABLoad(assetBundleLoadTask));// todo
            }
            else
            {
                OnAssetAllDependentABLoad(assetBundleLoadTask);
            }
        }

        void OnAssetAllDependentABLoad(AssetBundleLoadingTask assetBundleLoadTask)
        {            
            string abpath = ResSetting.GetCurVersionInfo.GetAssetBundleFullPath(assetBundleLoadTask.m_assetBundleName);
            AssetBundle ab = AssetBundle.LoadFromFile(abpath);            
            
            if (ab == null)
            {
                Debug.LogError("After All depend ab load ,to Load Assetbundle Fail : path is :" + abpath);
                return;
            }            

            AssetBundleReference abref = new AssetBundleReference(ab, assetBundleLoadTask.m_assetBundleName);
            abref.AddDependsRef();
            LoadedABRefMap.Add(assetBundleLoadTask.m_assetBundleName,abref);

            UnityEngine.Object targetObj = null;
            if (assetBundleLoadTask.m_systemTypeInstance == null)
            {
                targetObj = ab.LoadAsset(assetBundleLoadTask.m_assetName);                          
            }
            else
            {
                targetObj = ab.LoadAsset(assetBundleLoadTask.m_assetName, assetBundleLoadTask.m_systemTypeInstance);                
            }
            for (int i = 0; i < assetBundleLoadTask.m_actionList.Count; i++)
            {
                assetBundleLoadTask.m_actionList[i](targetObj);
            }
            assetBundleLoadTask.ClearSelf();            
            _nowLoadNum -= 1;
            FindLoadTask();            
        }

        //Release Assetbundle
        public void UnloadAB(string assetBundleName)
        {
            AssetBundleReference abref = null;
            LoadedABRefMap.TryGetValue(assetBundleName,out abref);
            if (abref != null)
            {
                abref.SubDependsRef();
            }   
        }
    }


    /// <summary>
    /// AB的依赖处理
    /// </summary>
    public class AssetBundleReference
    {
        public AssetBundle assetbundle
        {
            get;
            private set;
        }
        string abname;
        string[] dependlist;
        public int RefCount
        {
            get;
            private set;
        }

        public AssetBundleReference(AssetBundle ab ,string abname)
        {
            this.assetbundle = ab;
            this.abname = abname;
            this.dependlist = AssetBundleMgr.Instance.CurManifest.GetAllDependencies(this.abname);
            RefCount =0;
        }

        public void AddDependsRef()
        {            
            if (assetbundle == null) return;

            if(dependlist != null && dependlist.Length > 0)
            {
                int length = dependlist.Length;
                for(int i = 0;i<length;i++)
                {
                    AssetBundleReference abref = null;
                    AssetBundleMgr.Instance.LoadedABRefMap.TryGetValue(dependlist[i],out abref);
                    if(abref != null)
                    {
                        abref.AddWeakRef();
                    }
                }                
            }
            AddWeakRef();         
        }
        public void AddWeakRef()
        {            
            RefCount++;         
        }

        public void SubDependsRef()
        {            
            if (assetbundle == null) return;

            if (dependlist != null && dependlist.Length > 0)
            {
                int length = dependlist.Length;
                for (int i = 0; i < length; i++)
                {
                    AssetBundleReference abref = null;
                    AssetBundleMgr.Instance.LoadedABRefMap.TryGetValue(dependlist[i], out abref);
                    if (abref != null)
                    {
                        abref.SubWeakRef();
                    }
                }
            }

            SubWeakRef();            
        }    
        
        public void SubWeakRef()
        {            
            RefCount--;            
            if (RefCount == 0)
            {
                AssetBundleMgr.Instance.LoadedABRefMap.Remove(abname);
                assetbundle.Unload(true);
                assetbundle = null;                
            }
        }
           
    }

    public class AssetBundleLoadingTask
    {
        public string m_assetBundleName;
        public string m_assetName;                
        public Type m_systemTypeInstance;
        public List<Action<UnityEngine.Object>> m_actionList = new List<Action<UnityEngine.Object>>();                
        public bool m_isScene;

        public AssetBundleLoadingTask(string assetBundleName, string assetName, Type systemTypeInstance, Action<UnityEngine.Object> onFinAction, bool isScene = false)
        {
            m_assetBundleName = assetBundleName;
            m_assetName = assetName;            
            m_systemTypeInstance = systemTypeInstance;
            m_isScene = isScene;
            m_actionList.Add(onFinAction);
        }

        public void ClearSelf()
        {
            m_actionList = null;                   
        }
    }
}