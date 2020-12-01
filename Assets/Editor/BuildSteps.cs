using UnityEngine;
using UnityEditor;
using System.Collections;
using System.Collections.Generic;
using System;
using System.IO;
 
public class BuildSteps
{
    // App名称
    public const string APP_NAME = "male7";
    // 产品名称       
    public const string PRODUCT_NAME = "七雄争霸";

    // 工程中所有场景名称
    static string[] SCENES = null;
    // 生成的包存放路径
    static string m_targetPath = string.Empty;
    static BuildTarget m_buildTarget = BuildTarget.Android;
    static BuildTargetGroup m_buildTargetGroup = BuildTargetGroup.Android;
    static string m_dataPathPrefix = Application.dataPath + "/";
    static string m_streamingAssetsPath = m_dataPathPrefix + "StreamingAssets/";
    static string m_luaTargetFolderPath = m_dataPathPrefix + "Resources/Lua/";

    //目标平台
    public static void BulidTarget(string companyName, string target, string versionNum)
    {
        // 预处理
        PreProcess(companyName, target, versionNum);
        // 开始Build,等待吧～
        GenericBuild(BuildOptions.None);
        // 后处理
        PostProcess();
    }

    // 预处理
    public static void PreProcess(string companyName, string target, string versionNum)
    {
        Debug.Log("开始预处理过程...");

        //=========================================
        // 设置
        FindEnabledEditorScenes();
        SettingBuildEnv(companyName, target, versionNum);

        //=========================================
        // 处理XLua脚本
        CSObjectWrapEditor.Generator.ClearAll();
        CSObjectWrapEditor.Generator.GenAll();

        //=========================================
        // 处理FairyGUI的Package依赖
        LPCFramework.FairyGUIAnalysisTools.AnalysisFairyGUI();

        //=========================================
        // 拷贝所有lua并加上txt后缀
        RemoveDir(m_luaTargetFolderPath);
        CopyDir(m_dataPathPrefix + "Lua/", m_luaTargetFolderPath, ".txt");

        //CopyDir(m_dataPathPrefix + "ArtAssets/Shaders/", m_dataPathPrefix + "Resources/Shaders/");
        //PackLuaFiles();
        //=========================================

        AssetDatabase.Refresh();

        Debug.Log("预处理过程结束...");
    }

    private static void PostProcess()
    {
        Debug.Log("开始后处理过程...");

        // 删除临时文件夹
        RemoveDir(m_luaTargetFolderPath);
        //RemoveDir(m_dataPathPrefix + "Resources/Shaders/");

        AssetDatabase.Refresh();

        Debug.Log("后处理过程结束...");
        Debug.Log("版本发布结束！");
    }

    private static void SettingBuildEnv(string companyName, string target, string versionNum)
    {
        string target_dir = "";
        string target_name = "";
        m_buildTargetGroup = BuildTargetGroup.Android;
        m_buildTarget = BuildTarget.Android;
        string buildFolderPath = Application.dataPath.Replace("/Assets", "");

        //=========================================

        if (target == "Android")
        {
            target_dir = buildFolderPath + "/Builds/Android";
            target_name = companyName + "_" + APP_NAME + ".apk";
            m_buildTargetGroup = BuildTargetGroup.Android;
        }
        // 编译出来的为xcode工程
        else if (target == "iOS")
        {
            target_dir = buildFolderPath + "/Builds/iOS";
            target_name = APP_NAME;
            m_buildTargetGroup = BuildTargetGroup.iOS;
            m_buildTarget = BuildTarget.iOS;
        }
        else if (target == "Windows")
        {
            target_dir = buildFolderPath + "/Builds/Windows";
            target_name = APP_NAME + ".exe";
            m_buildTargetGroup = BuildTargetGroup.Standalone;
            m_buildTarget = BuildTarget.StandaloneWindows;

            Debug.Log("开始打包版本...");
        } else if (target == "OSX")
        {
            target_dir = buildFolderPath + "/Builds/OSX";
            target_name = APP_NAME + ".app";
            m_buildTargetGroup = BuildTargetGroup.Standalone;
            m_buildTarget = BuildTarget.StandaloneOSX;
        }
        else if (target == "Web")
        {
            target_dir = buildFolderPath + "/Builds/WebGL";
            target_name = APP_NAME;
            m_buildTargetGroup = BuildTargetGroup.WebGL;
            m_buildTarget = BuildTarget.WebGL;
        }
        else
            return;

        //=========================================

        PlayerSettings.productName = PRODUCT_NAME;
        PlayerSettings.applicationIdentifier = "com." + companyName + "." + APP_NAME;

        if(!string.IsNullOrEmpty(versionNum))
            PlayerSettings.bundleVersion = versionNum;

        PlayerSettings.iOS.appleDeveloperTeamID = "5R2M4GR8Y6";
        PlayerSettings.SetScriptingDefineSymbolsForGroup(m_buildTargetGroup, APP_NAME);

        //=========================================

        //每次build删除之前的残留
        if (Directory.Exists(target_dir))
        {
            if (File.Exists(target_name))
            {
                File.Delete(target_name);
            }
        }
        else
        {
            Directory.CreateDirectory(target_dir);
        }

        m_targetPath = target_dir + "/" + target_name;
    }

    private static string[] FindEnabledEditorScenes()
    {
        List<string> EditorScenes = new List<string>();
        foreach (EditorBuildSettingsScene scene in EditorBuildSettings.scenes)
        {
            if (!scene.enabled) continue;
            EditorScenes.Add(scene.path);
        }

        SCENES = EditorScenes.ToArray();
        return SCENES;
    }

    static void GenericBuild(BuildOptions build_options)
    {
        if (m_buildTarget == BuildTarget.NoTarget)
        {
            Debug.LogError("未选择打包平台！！！");
            return;
        }

        EditorUserBuildSettings.SwitchActiveBuildTarget(m_buildTargetGroup, m_buildTarget);
        string res = BuildPipeline.BuildPlayer(SCENES, m_targetPath, m_buildTarget, build_options);

        if (res.Length > 0)
        {
            throw new Exception("BuildPlayer failure: " + res);
        }
        else
        {
            Debug.Log("生成版本成功！");
        }
    }
    // 打包目录
    private static void PackLuaFiles()
    {
        Debug.Log("打包文件中...");
        string tempPath = m_dataPathPrefix + "TempBuildPackage/";

        RemoveDir(tempPath);
        RemoveDir(m_streamingAssetsPath);

        Directory.CreateDirectory(tempPath);
        Directory.CreateDirectory(m_streamingAssetsPath);

        CopyDir(m_dataPathPrefix + "Resources/Lua", tempPath + "Lua");
        LPCFramework.FileUtils.ZipFile(m_streamingAssetsPath + LPCFramework.ConstDefines.SourceFileName, tempPath);

        RemoveDir(tempPath);
        Debug.Log("打包文件成功！");
    }
    // 拷贝目录
    private static void CopyDir(string srcPath, string tarPath, string extension=null)
    {
        try
        {
            bool needAddExtension = !string.IsNullOrEmpty(extension);

            // 检查目标目录是否以目录分割字符结束如果不是则添加
            if (tarPath[tarPath.Length - 1] != System.IO.Path.DirectorySeparatorChar)
            {
                tarPath += System.IO.Path.DirectorySeparatorChar;
            }
            // 判断目标目录是否存在如果不存在则新建
            if (!System.IO.Directory.Exists(tarPath))
            {
                System.IO.Directory.CreateDirectory(tarPath);
            }
            // 得到源目录的文件列表，该里面是包含文件以及目录路径的一个数组
            // 如果你指向copy目标文件下面的文件而不包含目录请使用下面的方法
            // string[] fileList = Directory.GetFiles（srcPath）；
            string[] fileList = System.IO.Directory.GetFileSystemEntries(srcPath);
            // 遍历所有的文件和目录
            foreach (string file in fileList)
            {
                string targetFileName = tarPath + System.IO.Path.GetFileName(file);

                // 先当作目录处理如果存在这个目录就递归Copy该目录下面的文件
                if (System.IO.Directory.Exists(file))
                {
                    CopyDir(file, targetFileName, extension);
                }
                // 否则直接Copy文件
                else
                {
                    // 剔除meta文件
                    if (targetFileName.EndsWith(".meta"))
                        continue;

                    // 添加后缀
                    if (needAddExtension)
                        targetFileName = targetFileName + extension;

                    System.IO.File.Copy(file, targetFileName, true);
                }
            }
        }
        catch (Exception e)
        {
            throw;
        }
    }
    // 删除目录
    private static void RemoveDir(string dir)
    {
        if (Directory.Exists(dir))
        {
            Directory.Delete(dir, true);
        }
    }
}
