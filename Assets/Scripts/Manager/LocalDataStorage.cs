using UnityEngine;
using XLua;

namespace LPCFramework
{
    [LuaCallCSharp]
    public class LocalDataStorage : Singleton<LocalDataStorage>
    {
        /// <summary>
        /// 保存数据(string)
        /// </summary>
        /// <param name="dataType">Data type.</param>
        public void SaveString(string dataType, string str)
        {
            PlayerPrefs.SetString(dataType, str);
        }

        /// <summary>
        /// 获取数据(string)
        /// </summary>
        /// <returns>The string.</returns>
        /// <param name="dataType">Data type.</param>
        public string GetString(string dataType)
        {
            return PlayerPrefs.GetString(dataType, string.Empty);
        }

        /// <summary>
        /// 保存数据(float)
        /// </summary>
        public void SaveFloat(string dataType, float value)
        {
            PlayerPrefs.SetFloat(dataType, value);
        }

        /// <summary>
        /// 获取数据(float)
        /// </summary>
        public float GetFloat(string dataType)
        {
            return PlayerPrefs.GetFloat(dataType, 1);
        }

        /// <summary>
        /// 保存数据(int)
        /// </summary>
        public void SaveInt(string dataType, int value)
        {
            PlayerPrefs.SetInt(dataType, value);
        }

        /// <summary>
        /// 获取数据(int)
        /// </summary>
        public float GetInt(string dataType)
        {
            return PlayerPrefs.GetInt(dataType, 1);
        }
        /// <summary>
        /// 是否含有key
        /// </summary>
        /// <param name="key"></param>
        /// <returns></returns>
        public bool HasKey(string key)
        {
            return PlayerPrefs.HasKey(key);
        }
        /// <summary>
        /// 清空数据
        /// </summary>
        public void Clear()
        {
            PlayerPrefs.DeleteAll();
        }
    }
}