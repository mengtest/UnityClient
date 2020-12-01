using System.IO;
using System.Text;
using System.Text.RegularExpressions;
using UnityEditor;
using UnityEditor.ProjectWindowCallback;
using UnityEngine;

public class LPCTools : MonoBehaviour
{
    static string versionTag = "-versionNum";
    static string versionNum = "0.0.1";
    const string companyName = "lightpaw";

    [MenuItem("版本/Build Windows")]
    static void BulidWindows()
    {
        CheckVersionNum();
        BuildSteps.BulidTarget(companyName, "Windows", versionNum);
    }

    [MenuItem("版本/Build Android")]
    static void BulidAndroid()
    {
        CheckVersionNum();
        BuildSteps.BulidTarget(companyName, "Android", versionNum);
    }

    [MenuItem("版本/Build iOS")]
    static void BulidiOS()
    {
        CheckVersionNum();
        BuildSteps.BulidTarget(companyName, "iOS", versionNum);
    }

    [MenuItem("版本/Build Web")]
    static void BulidWeb()
    {
        CheckVersionNum();
        BuildSteps.BulidTarget(companyName, "Web", versionNum);
    }
    // UnityCloud专用
    static void PreExportiOS()
    {
        CheckVersionNum();
        BuildSteps.PreProcess(companyName, "iOS", null);
    }

    // UnityCloud专用
    static void PreExportAndroid()
    {
        CheckVersionNum();
        BuildSteps.PreProcess(companyName, "Android", null);
    }

    // UnityCloud专用
    static void PreExportOSX()
    {
        CheckVersionNum();
        BuildSteps.PreProcess(companyName, "OSX", null);
    }

    static void CheckVersionNum()
    {
        string[] args = System.Environment.GetCommandLineArgs();

        for (int i = 0; i < args.Length; ++i)
        {
            if (versionTag == args[i])
            {
                int nextIndex = i + 1;
                if (nextIndex < args.Length && !string.IsNullOrEmpty(args[nextIndex]))
                {
                    versionNum = args[i + 1];
                }

                break;
            }
        }
    }

    [MenuItem("Assets/Create/Lua Singleton Script", false, 80)]
    private static void CreateNewLuaSingletonScript()
    {
        ProjectWindowUtil.StartNameEditingIfProjectWindowExists(0,
            ScriptableObject.CreateInstance<MyDoCreateScriptAsset>(),
            GetSelectedPathOrFallback() + "/New Lua.lua",
            null,
            "Assets/Editor/LuaTemplate/SingletonTemplate.lua");
    }

    [MenuItem("Assets/Create/Lua Class Script", false, 80)]
    private static void CreateNewLuaClassScript()
    {
        ProjectWindowUtil.StartNameEditingIfProjectWindowExists(0,
            ScriptableObject.CreateInstance<MyDoCreateScriptAsset>(),
            GetSelectedPathOrFallback() + "/New Lua.lua",
            null,
            "Assets/Editor/LuaTemplate/ClassTemplate.lua");
    }

    private static string GetSelectedPathOrFallback()
    {
        string path = "Assets";
        foreach (Object obj in Selection.GetFiltered(typeof(Object), SelectionMode.Assets))
        {
            path = AssetDatabase.GetAssetPath(obj);
            if (!string.IsNullOrEmpty(path) && File.Exists(path))
            {
                path = Path.GetDirectoryName(path);
                break;
            }
        }
        return path;
    }
}

class MyDoCreateScriptAsset : EndNameEditAction
{
    public override void Action(int instanceId, string pathName, string resourceFile)
    {
        Object o = CreateScriptAssetFromTemplate(pathName, resourceFile);
        ProjectWindowUtil.ShowCreatedAsset(o);
    }

    internal static Object CreateScriptAssetFromTemplate(string pathName, string resourceFile)
    {
        string fullPath = Path.GetFullPath(pathName);
        StreamReader streamReader = new StreamReader(resourceFile);
        string text = streamReader.ReadToEnd();
        streamReader.Close();
        string fileNameWithoutExtension = Path.GetFileNameWithoutExtension(pathName);

        text = Regex.Replace(text, "#NAME#", fileNameWithoutExtension);

        bool encoderShouldEmitUTF8Identifier = true;
        bool throwOnInvalidBytes = false;
        UTF8Encoding encoding = new UTF8Encoding(encoderShouldEmitUTF8Identifier, throwOnInvalidBytes);
        bool append = false;
        StreamWriter streamWriter = new StreamWriter(fullPath, append, encoding);
        streamWriter.Write(text);
        streamWriter.Close();
        AssetDatabase.ImportAsset(pathName);
        return AssetDatabase.LoadAssetAtPath(pathName, typeof(Object));
    }
}