using System.Collections.Generic;
using System.IO;
using UnityEditor;
using UnityEngine;

namespace LPCFramework
{
    public class FairyGUIAnalysisTools : EditorWindow
    {
        // 文件路径定义
        static Dictionary<string, string> uiPathDefine = new Dictionary<string, string>();
        // UI文件路劲
        static string uiPath = "Assets/Resources/UI/";
        // Config文件路劲
        static string configPath = "Assets/Lua/Config/UIFileReference.lua";
        // 包Id默认长度
        static int packageIdLength = 8;
        // 包关键字
        static string pkgKeyWord = "<packageDescription id=";
        // 关键字
        static string keyword = "pkg=";
        // 嘻嘻路径
        static string uncertainPath = Application.dataPath + "/Resources/";

        /// <summary>
        /// 解析bytes
        /// </summary>
        [MenuItem("Tools/AnalysisFariyGUI")]
        public static void AnalysisFairyGUI()
        {
            InitPackages();
            DirectoryInfo TheFolder = new DirectoryInfo(uiPath);
            string luaContent = "UIFileReference =\n{\n";

            foreach (DirectoryInfo dir in TheFolder.GetDirectories())
            {
                foreach (FileInfo file in dir.GetFiles())
                {
                    if (file.Name.IndexOf("@") == -1)
                    {
                        string content = GetPackagesByPath(file);

                        if (content != string.Empty)
                            luaContent += string.Format("\t{0},\n", content);

                        break;
                    }
                }
            }

            luaContent += "}";
            FileStream fs = new FileStream(configPath, FileMode.OpenOrCreate, FileAccess.ReadWrite);
            StreamWriter sw = new StreamWriter(fs);
            sw.WriteLine(luaContent);
            sw.Close();
            EditorUtility.DisplayDialog("Garden提醒您", "解析成功\n生成路径:Assets/Lua/Config/UIFileReference", "ok");
            AssetDatabase.Refresh();
        }

        /// <summary>
        /// 初始化所有包
        /// </summary>
        private static void InitPackages()
        {
            uiPathDefine.Clear();

            DirectoryInfo TheFolder = new DirectoryInfo(uiPath);

            foreach (DirectoryInfo dir in TheFolder.GetDirectories())
            {
                foreach (FileInfo file in dir.GetFiles())
                {
                    if (file.Name.IndexOf("@") == -1)
                    {
                        StreamReader sr = new StreamReader(file.FullName);
                        string content = sr.ReadToEnd();
                        int firstIndex = content.IndexOf(pkgKeyWord);

                        if (firstIndex == -1)
                            return;

                        // 包Id
                        string pkgId = "";
                        // 包路径
                        string path = "";
                        pkgId = content.Substring(firstIndex + pkgKeyWord.Length + 1, packageIdLength);
                        // 截 + 替
                        path = file.FullName.Substring(uncertainPath.Length, file.FullName.Length - uncertainPath.Length - 6).Replace("\\", "/");
                        uiPathDefine.Add(pkgId, string.Format("\"{0}\"", path));
                        break;
                    }
                }
            }
        }

        /// <summary>
        /// 获取一个文件的引用包
        /// </summary>
        /// <param name="file"></param>
        /// <returns></returns>
        private static string GetPackagesByPath(FileInfo file)
        {
            StreamReader sr = new StreamReader(file.FullName);
            string content = sr.ReadToEnd();
            string pkgId;
            Dictionary<string, string> pkcDic = new Dictionary<string, string>();
            int firstIndex = content.IndexOf(keyword);

            if (firstIndex == -1)
                return string.Empty;

            for (int i = content.IndexOf(keyword); i <= content.LastIndexOf(keyword); i++)
            {
                i = content.IndexOf(keyword, i);
                pkgId = content.Substring(i + keyword.Length + 1, packageIdLength);
                string outStr = "";
                uiPathDefine.TryGetValue(pkgId, out outStr);
                pkcDic[outStr] = "[\"" + pkgId + "\"]" + " = " + outStr;// string.Format("[\"{0}\"] = {1}", pkgId, outStr);
            }

            string result = file.Name.Substring(0, file.Name.Length - 6) + " = { ";

            foreach (var item in pkcDic)
                result += string.Format("{0} , ", item.Value);

            return result + " }";
        }
    }
}