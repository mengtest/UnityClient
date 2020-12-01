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

namespace LPCFramework
{
    /// <summary>
    /// 配置数据读取类都继承于该类
    /// </summary>
    /// <typeparam name="T"></typeparam>
    public class ConfigParserSingleton<T> where T : ConfigParserSingleton<T>
    {
        protected static T _Instance;

        /// <summary>
        /// 获得单件对象的实例。
        /// </summary>
        public static T Instance
        {
            get
            {
                return _Instance;
            }
        }

        /// <summary>
        /// 反序列化
        /// </summary>
        public static void Load(string fileName, bool inRootFloder=false)
        {
            string folderName = string.Empty;
            if (!inRootFloder)
                folderName = "Config";

            fileName = string.Format("{0}/{1}", folderName, fileName);
            TextAsset textRes = LogicUtils.LoadResource(fileName) as TextAsset;
            if (textRes != null)
                Parse(textRes.text, fileName);
            else
                Debug.LogError("[error] Cant load file: " + fileName);
        }
        /// <summary>
        /// 解析文件
        /// </summary>
        /// <param name="content"></param>
        protected static void Parse(string content, string fileName)
        {
            try
            {
                content = content.Trim();
                T t = LogicUtils.DeserializeYAMLContent<T>(content);

                if (t != null)
                {
                    t.Normalize();
                    _Instance = t;
                    Instance.Check();
                }
            }
            catch (Exception e)
            {
                Debug.LogError(string.Format("[error] 解析YAML文件错误: {0}, {1}", fileName, e));
            }
        }

        /// <summary>
        /// 做一些规格化操作
        /// </summary>
        protected virtual void Normalize()
        {

        }

        /// <summary>
        /// 逻辑检查
        /// </summary>
        protected virtual void Check()
        {

        }
    }
}