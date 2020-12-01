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
using System.Collections.Generic;

namespace LPCFramework
{
    // Singleton base class, each class need to be a singleton should 
    // derived from this class
    public class Singleton<T> where T : new()
    {
        // Instead of compile time check, we provide a run time check
        // to make sure there is only one instance.


        protected static T instance = default(T);

        public static T Instance
        {
            get
            {
                if (instance == null)
                {
                    instance = new T();
                }
                return instance;
            }

        }
    }
    /// <summary>
    /// Monobehaviour type singleton
    /// </summary>
    /// <typeparam name="T"></typeparam>
    public class SingletonMonobehaviour<T> : UnityEngine.MonoBehaviour where T : SingletonMonobehaviour<T>
    {
        private static T _Instance;

        public static T Instance
        {
            get
            {
                if (_Instance == null)
                {
                    _Instance = (T)GameObject.FindObjectOfType(typeof(T));
                    if (_Instance == null)
                    {
                        GameObject instanceObject = GameObject.Find(ConstDefines.GameManagerObj);
                        if(instanceObject == null)
                            instanceObject = new GameObject(ConstDefines.GameManagerObj);
                        _Instance = instanceObject.AddComponent<T>();
                    }
                    _Instance.OnInstance();
                }
                return _Instance;
            }
        }
        public virtual void OnInstance()
        { }
    }

}