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
using System;
using System.Collections.Generic;
#if !Arts
using XLua;
#endif

namespace LPCFramework
{
    /// <summary>
    /// 游戏对象池
    /// </summary>
#if !Arts
    [LuaCallCSharp]
#endif
    public class GameObjectPool
    {
        private int maxSize;
        private int poolSize;
        private string poolName;
        private Transform poolRoot;
        private GameObject poolObjectPrefab;
        private Stack<GameObject> availableObjStack = new Stack<GameObject>();

        /// <summary>
        /// 新建对象池
        /// </summary>
        /// <param name="poolName">池名称</param>
        /// <param name="poolObjectPrefab">对象的prefab</param>
        /// <param name="initCount">初始数量</param>
        /// <param name="maxSize">最大数量</param>
        /// <param name="poolRoot">池子依赖的根目录</param>
        public GameObjectPool(string poolName, GameObject poolObjectPrefab, int initCount, int maxSize, Transform poolRoot)
        {
            if (poolObjectPrefab == null)
            {
                Debug.LogWarning("[warning] GameObject prefab should not be null! Pool name: " + poolName);
                return;
            }

            this.poolName = poolName;
            this.poolSize = 0;
            this.maxSize = maxSize;
            this.poolRoot = poolRoot;
            this.poolObjectPrefab = poolObjectPrefab;

            // 池子大小不能超过上限
            if (initCount > maxSize)
                initCount = maxSize;

            if (availableObjStack == null)
                availableObjStack = new Stack<GameObject>();

            // 生成对象
            for (int index = 0; index < initCount; index++)
            {
                AddObjectToPool(NewObjectInstance());
            }
        }
        /// <summary>
        /// 对象加入池中
        /// </summary>
        /// <param name="go"></param>
        private void AddObjectToPool(GameObject go)
        {
            // 如果池已满，则销毁想要入池的对象
            if (poolSize >= maxSize)
            {
                go.transform.parent = null;
                UnityEngine.Object.Destroy(go);
                return;
            }

            //add to pool
            go.SetActive(false);
            availableObjStack.Push(go);
            go.transform.SetParent(poolRoot, false);

            ++poolSize;
        }
        /// <summary>
        /// 从池子中取出对象，如果没有的话，新生成一个
        /// </summary>
        /// <returns></returns>
        private GameObject PopObjectFromPool()
        {
            GameObject go = null;
            if (poolSize > 0)
            {
                go = availableObjStack.Pop();
                --poolSize;
            }
            else
            {
                Debug.LogWarning("[warning] No object available in pool  " + poolName + ", trying to instantiate a new one");

                go = NewObjectInstance();
                if (go != null)
                    go.transform.SetParent(poolRoot, false);
            }

            if (go != null)
                go.SetActive(true);

            return go;
        }
        /// <summary>
        /// 生成新对象
        /// </summary>
        /// <returns></returns>
        private GameObject NewObjectInstance()
        {
            if (poolObjectPrefab == null)
                return null;

            return GameObject.Instantiate(poolObjectPrefab) as GameObject;
        }
        /// <summary>
        /// 获取一个对象
        /// </summary>
        /// <param name="force">在池中没对象时，是否强制新加一个</param>
        /// <returns></returns>
        public GameObject NextAvailableObject(bool force = false)
        {
            return PopObjectFromPool();
        }

        /// <summary>
        /// 返还对象到池子里
        /// </summary>
        /// <param name="pool"></param>
        /// <param name="po"></param>
        public void ReturnObjectToPool(string pool, GameObject go)
        {
            if (poolName.Equals(pool))
            {
                AddObjectToPool(go);
            }
            else
            {
                Debug.LogError(string.Format("[error] Trying to add object to incorrect pool {0} ", poolName));
            }
        }
        /// <summary>
        /// 析构，销毁对象池和池内的所有对象
        /// </summary>
        public void OnDestroy()
        {
            // 清空所有缓存对象
            if (availableObjStack != null)
            {
                while (availableObjStack.Count > 0)
                {
                    GameObject obj = availableObjStack.Pop();
                    if (obj != null)
                        GameObject.Destroy(obj);
                }

                availableObjStack.Clear();
                availableObjStack = null;
            }

            this.poolName = string.Empty;
            this.poolSize = 0;
            this.maxSize = 0;
            this.poolRoot = null;
            this.poolObjectPrefab = null;
        }

        /// <summary>
        /// 重新调整池子的大小
        /// </summary>
        public void GameObjectPoolResize(int resize, int resizeMax)
        {
            if (resize > resizeMax)
                resize = resizeMax;
            maxSize = resizeMax;
            if (poolSize > resize)
            {
                for (int i = 0; i < poolSize - resize; i++)
                {
                    GameObject go = availableObjStack.Pop();
                    UnityEngine.GameObject.Destroy(go);
                    --poolSize;
                }
            }
            else if (poolSize < resize)
            {
                for (int i = 0; i < resize - poolSize; i++)
                {
                    AddObjectToPool(NewObjectInstance());
                }
            }
        }
    }
}
