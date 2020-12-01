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
using UnityEditor;
using System.Collections;
using System.Collections.Generic;
using System.IO;
using System.Text;
using System.Security.Cryptography;
using ICSharpCode.SharpZipLib.Zip;
using LPCFramework;


public class AssetBundlePacker : EditorWindow
{
    static string ResFolder = "Assets/Resources/";
    private static List<string> _listFileIsBundleFolders = new List<string>(
       new string[] { "Audio", "Fonts", "Prefabs", "TestThreeAB" } );

    private static List<string> _listFolderIsBundleFolders = new List<string>(
       new string[] { "UI", "TestOneAB" });

    private static List<string> _listSceneBundleFolders = new List<string>(
       new string[] { "Scenes"});

    private static List<string> _listLuaFiles = new List<string>(
     new string[] { "Lua" });

    static string ResourcesExportFolder = "";
    static string UpdateZipFolder = "";

    static int CurrentPackcageVersion = 1;
    static string CurrentPackageRoot;
    static string CurrentManifest;
    
    static string ClientExportPath = "";

    void OnGUI()
    {
        ShowSelectBoardInfo("AssetBundle自动打包工具");
        OnAssetBundleBoardShow();        
    }

    private void ShowSelectBoardInfo(string operationName)
    {
        GUILayout.Label(operationName + "面板： ", EditorStyles.boldLabel);
        EditorGUILayout.Space();
    }

    #region AssetBundle资源打包
    private void OnAssetBundleBoardShow()
    {        
        GUILayout.Label("需要文件打包的文件夹:");
        for (int i = 0; i < _listFileIsBundleFolders.Count; i++)
        {
            GUILayout.BeginHorizontal();
            EditorGUILayout.LabelField((i + 1).ToString() + ":", ResFolder + _listFileIsBundleFolders[i]);
            GUILayout.EndHorizontal();
        }

        GUILayout.Label("需要文件夹打包的文件夹:");
        for (int i = 0; i < _listFolderIsBundleFolders.Count; i++)
        {
            GUILayout.BeginHorizontal();
            EditorGUILayout.LabelField((i + 1).ToString() + ":", ResFolder +_listFolderIsBundleFolders[i]);
            GUILayout.EndHorizontal();
        }

        GUILayout.Label("需要场景打包的文件夹:");
        for (int i = 0; i < _listSceneBundleFolders.Count; i++)
        {
            GUILayout.BeginHorizontal();
            EditorGUILayout.LabelField((i + 1).ToString() + ":", ResFolder + _listSceneBundleFolders[i]);
            GUILayout.EndHorizontal();
        }

        GUILayout.Label("需要Lua打包的文件夹:");
        for (int i = 0; i < _listLuaFiles.Count; i++)
        {
            GUILayout.BeginHorizontal();
            EditorGUILayout.LabelField((i + 1).ToString() + ":", ResFolder +_listLuaFiles[i]);
            GUILayout.EndHorizontal();
        }

        EditorGUILayout.LabelField("---------------------------------------------------------------------------------------------------------------");

        EditorGUILayout.Space();
                        
        if (GUILayout.Button("生成IOS 资源包"))
        {						
            BuildIosRes();
        }
        if (GUILayout.Button("生成Windows 资源包"))
        {
            BuildWindowsRes();
        }
        if (GUILayout.Button("生成Android 资源包"))
        {
            BuildAndRes();
        }        
    }

    private static List<String> getAllFileinDir(string dir)
    {
        List<String> fileList = new List<String>();
        fileList.AddRange(Directory.GetFiles(dir));
        string[] subDirs = Directory.GetDirectories(dir);
        foreach (string subdir in subDirs)
        {
            fileList.AddRange(getAllFileinDir(subdir));

        }
        return fileList;
    }

    static void BuildAllBundles(BuildTarget target,bool RefreshResourceVersion,bool isUnitTest)
    {
        ClearAssetBundleName();
        
        if(isUnitTest)
        {
            ClientExportPath = "ClientPackagesUnitTest/";
        }
        else
        {
            ClientExportPath = "ClientPackages/";
        }
        

        ////////////////////////////////////////////
        List<string> filebundles = new List<string>();
        List<string> folderbundles = new List<string>();
        List<string> scenebundles = new List<string>();
        foreach (var folder in _listFileIsBundleFolders)
        {
            string fd = ResFolder + folder;
            List<string> files = getAllFileinDir(fd);
            filebundles.AddRange(files);
        }

        foreach (var folder in _listFolderIsBundleFolders)
        {
            string fd = ResFolder + folder;
            List<string> files = getAllFileinDir(fd);
            folderbundles.AddRange(files);
        }

        foreach (var folder in _listSceneBundleFolders)
        {
            string fd = ResFolder + folder;
            List<string> files = getAllFileinDir(fd);
            scenebundles.AddRange(files);
        }

        ////////////////////////////////////////////////

        CheckAssetBundleVersion(target);
                
        foreach (var file in filebundles)//需要过滤的放在这里
        {
            if (!IsFileNeedPack(file))
                continue;

            string filepath = file;
            filepath = file.Replace("\\" , "/");
            //Debug.Log(filepath);            
            string filename = FileUtils.GetFileNamePathWithoutExtention(filepath).Replace(ResFolder, "");
            //Debug.LogWarning(filename);

            //filename = platformFolder + filename;

            AssetImporter.GetAtPath(filepath).assetBundleName = filename+".ab";
        }

        foreach(var file in folderbundles)
        {
            if (!IsFileNeedPack(file))
                continue;

            string filepath = file;
            filepath = file.Replace("\\", "/");
            //Debug.Log(filepath);

            string filename = FileUtils.GetFilePath(filepath).Replace(ResFolder, "");
            //Debug.LogWarning(filename);
            //filename = platformFolder + filename;

            AssetImporter.GetAtPath(filepath).assetBundleName = filename + ".ab";
        }

        foreach(var file in scenebundles)
        {
            if (!file.EndsWith(".unity")) continue;

            string filepath = file;
            filepath = file.Replace("\\", "/");            
            string filename = FileUtils.GetFileNamePathWithoutExtention(filepath).Replace(ResFolder, "");                        
            AssetImporter.GetAtPath(filepath).assetBundleName = filename + ".ab";
        }

        AssetDatabase.Refresh();

        BuildPipeline.BuildAssetBundles(CurrentPackageRoot, BuildAssetBundleOptions.ChunkBasedCompression|BuildAssetBundleOptions.DeterministicAssetBundle, target);
        
        AssetDatabase.Refresh();

        string manifestfilepath = CurrentPackageRoot + CurrentPackcageVersion;
        AssetBundle ab = AssetBundle.LoadFromFile(manifestfilepath);
        AssetBundleManifest manifest = (AssetBundleManifest)ab.LoadAsset("AssetBundleManifest");
        ab.Unload(false);
                      
        System.Threading.Thread.Sleep(1000);

        CopyLuaFiles(CurrentPackageRoot);

        if (!NeedGenerateNewVersion(CurrentPackageRoot))
        {
            Debug.Log("<color=#20F856>打包结束，无需更新</color>");
            return;
        }
        
        for(int i = 1;i<CurrentPackcageVersion;i++)
        {
            GenerateUpdateZip(i);
        }
        if(RefreshResourceVersion)
            RefreshResVersion();

        EditorUtility.ClearProgressBar();
        //EditorUtility.DisplayDialog("打包", "打包完成", "OK");
        ClearAssetBundleName();
        AssetDatabase.Refresh();
        Debug.Log("<color=#20F856>打包成功</color>");
    }

    static void RefreshResVersion()
    {
        string resfile = Application.dataPath + "/Resources/resversion.bytes";
        StringBuilder verSb = new StringBuilder();
        verSb.AppendLine(CurrentPackcageVersion.ToString());
        FileStream fs = new FileStream(resfile, FileMode.Create);

        byte[] data = Encoding.UTF8.GetBytes(verSb.ToString());
        fs.Write(data, 0, data.Length);
        fs.Flush();
        fs.Close();
        AssetDatabase.Refresh();
    }

    static void CheckAssetBundleVersion(BuildTarget target)
    {
        string platformFolder = "";
        switch (target)
        {
            case BuildTarget.iOS:
                platformFolder = "IOS/";
                break;
            case BuildTarget.Android:
                platformFolder = "Android/";
                break;
            case BuildTarget.StandaloneWindows:
                platformFolder = "Win/";
                break;
            default:
                Debug.LogError("暂不支持此版本! " + target.ToString());
                return;
        }
        ResourcesExportFolder = Application.dataPath + "/../../" + ClientExportPath + platformFolder;
        if (!Directory.Exists(ResourcesExportFolder))
            Directory.CreateDirectory(ResourcesExportFolder);
        UpdateZipFolder = ResourcesExportFolder + "UpdateZip/";
        if (!Directory.Exists(UpdateZipFolder))
            Directory.CreateDirectory(UpdateZipFolder);

        int prePackageVersion = 1;        
        while(true)
        {
            string versionFile = string.Format("{0}{1}/version.txt", ResourcesExportFolder, prePackageVersion);
            FileInfo fileinfo = new FileInfo(versionFile);
            if(fileinfo.Exists)
            {
                prePackageVersion++;
            }
            else
            {
                prePackageVersion--;
                break;                
            }
        }

        CurrentPackcageVersion = prePackageVersion + 1;
                
        //string versionFolder = string.Format("{0}/", prePackageVersion);//pre version folder,may not exist
        //PrePackageRoot = ResourcesExportFolder + versionFolder;
        //PreManifest = PrePackageRoot + PrePackageVersion;

        string versionFolder = string.Format("{0}/", CurrentPackcageVersion);// cur pack version folder
        CurrentPackageRoot = ResourcesExportFolder + versionFolder;
        CurrentManifest = CurrentPackageRoot+ CurrentPackcageVersion;
        if (Directory.Exists(CurrentPackageRoot))
        {
            Debug.LogError("The Last Pack Has Error,Will Delete This");
            Directory.Delete(CurrentPackageRoot, true);
        }
        Directory.CreateDirectory(CurrentPackageRoot);
    }

    private static void CopyLuaFiles(string fatherPath)
    {        
        List<string> luafiles = new List<string>();

        string luaTargetPath = fatherPath + "Lua/";
        if (Directory.Exists(luaTargetPath))        
            Directory.Delete(luaTargetPath, true);
        
        Directory.CreateDirectory(luaTargetPath);

        foreach (var folder in _listLuaFiles)
        {
            string fd = "Assets/" + folder;
            if (!Directory.Exists(fd))
            {
                Debug.Log(string.Format("<color=#FF6100>不存在{0}的目录,lua代码提取取消</color>", fd));
                return;
            }
            List<string> files = getAllFileinDir(fd);
            luafiles.AddRange(files);
        }        
        
        foreach(var luafile in luafiles)
        {
            if (!luafile.EndsWith(".lua")) continue;

            string filerelev = luafile.Replace("\\", "/").Replace(ResFolder, "");             
            string newfile = fatherPath + filerelev;
            string path = Path.GetDirectoryName(newfile);
            if (!Directory.Exists(path)) Directory.CreateDirectory(path);
            if (File.Exists(newfile))            
                File.Delete(newfile);            
            File.Copy(luafile, newfile, true);            
        }
        AssetDatabase.Refresh();        
    }

    public static bool NeedGenerateNewVersion(string resfolder)
    {
        string versionFolder = string.Format("{0}/", CurrentPackcageVersion-1);//pre version folder,may not exist
        string prePackageRoot = ResourcesExportFolder + versionFolder;
        string preversiontxt = prePackageRoot + "/version.txt";
        Dictionary<string, string[]> prevermd5 = GenFileMD5VersionInfo(preversiontxt);

        StringBuilder verSb = new StringBuilder();
        List<string> files = getAllFileinDir(resfolder);
        
        List<string> updatefiles = new List<string>();
        foreach (var file in files)
        {
            if (file.EndsWith(".manifest") || file.Equals(CurrentManifest)) continue;
           
            string curfile = file.Replace("\\", "/").Replace(CurrentPackageRoot, "").ToLower();
            string cmd5 = BuildFileMD5(file);
            string cver = CurrentPackcageVersion.ToString();

            string[] prever = null;
            verSb.Append(curfile);
            verSb.Append(":");
            if (prevermd5.TryGetValue(curfile, out prever))
            {
                string pmd5 = prever[0];
                string pver = prever[1];
                if (pmd5 != cmd5)
                {
                    verSb.Append(cmd5);
                    verSb.Append(":");
                    verSb.AppendLine(cver);
                    updatefiles.Add(curfile);
                }
                else
                {
                    verSb.Append(pmd5);
                    verSb.Append(":");
                    verSb.AppendLine(pver);
                }
            }
            else
            {
                verSb.Append(cmd5);
                verSb.Append(":");
                verSb.AppendLine(cver);
                updatefiles.Add(curfile);
            }               
        }
        if (updatefiles.Count == 0)
        {
            Debug.LogWarning("---------------  [Same Version] ------------  " + CurrentPackageRoot);
            DirectoryInfo dirinfo = new DirectoryInfo(CurrentPackageRoot);
            dirinfo.Delete(true);

            //EditorUtility.DisplayDialog("打包", "打包完成,本次版本与上次版本没有变化", "OK");
            Debug.Log("<color=#20F856>打包完成,本次版本与上次版本没有变化</color>");
            return false;
        }

        FileStream fs = new FileStream(resfolder + "/" + "version.txt", FileMode.Create);
        byte[] data = Encoding.UTF8.GetBytes(verSb.ToString());        
        fs.Write(data, 0, data.Length);
        fs.Flush();
        fs.Close();

        return true;
    }
    static Dictionary<string, string[]> GenFileMD5VersionInfo(string versionfile)
    {
        Dictionary<string, string[]> md5verinfo = new Dictionary<string, string[]>();

        if (File.Exists(versionfile))
        {
            StreamReader r = new StreamReader(versionfile);
            string info = r.ReadToEnd();
            string[] sArray = info.Split('\n');
            for (int i = 0; i < sArray.Length; i++)
            {
                if (string.IsNullOrEmpty(sArray[i]))
                {
                    continue;
                }
                string[] detailArray = sArray[i].Split(':');
                string[] mdver = new string[] { detailArray[1], detailArray[2].Replace("\r","") };
                md5verinfo.Add(detailArray[0], mdver);
            }
            r.Close();
            r.Dispose();
        }
        return md5verinfo;
    }

    static void GenerateUpdateZip(int  prePackageVersion)
    {
        Debug.Log("<color=#20F856>Update Version From :" + prePackageVersion + " to " + CurrentPackcageVersion + "</color>");

        string versionFolder = string.Format("{0}/", prePackageVersion);//pre version folder,may not exist
        string prePackageRoot = ResourcesExportFolder + versionFolder;

        string preversiontxt = prePackageRoot + "/version.txt";
        string curversiontxt = CurrentPackageRoot + "/version.txt";
                
        Dictionary<string, string[]> prevermd5 = GenFileMD5VersionInfo(preversiontxt);
        Dictionary<string, string[]> curvermd5 = GenFileMD5VersionInfo(curversiontxt);

        Dictionary<string,string> update_filerelative = new Dictionary<string,string>();        

        StringBuilder update_version = new StringBuilder();

        foreach (var curmd5 in curvermd5)
        {
            string cmd5 = curmd5.Value[0];
            string cver = curmd5.Value[1];

            string[] prever = null;
            update_version.Append(curmd5.Key);
            update_version.Append(":");
            if (prevermd5.TryGetValue(curmd5.Key,out prever))
            {
                string pmd5 = prever[0];
                string pver = prever[1];
                if (pver != cver)
                {                                        
                    update_version.Append(cmd5);
                    update_version.Append(":");
                    update_version.AppendLine(cver);
                    update_filerelative.Add(curmd5.Key, cver);
                }
                else
                {                                     
                    update_version.Append(pmd5);
                    update_version.Append(":");
                    update_version.AppendLine(pver);
                }
            }
            else
            {
                update_version.Append(cmd5);
                update_version.Append(":");
                update_version.AppendLine(cver);
                update_filerelative.Add(curmd5.Key, cver);                
            }
        }
        
        //有非manifes的文件更新，那么再把manifes加进来
        update_filerelative.Add(CurrentPackcageVersion.ToString(),CurrentPackcageVersion.ToString());

        string zipfolder = "";
        if (File.Exists(preversiontxt))
            zipfolder = string.Format("{0}{1}-{2}", UpdateZipFolder, prePackageVersion, CurrentPackcageVersion, CurrentPackcageVersion);
        else
            zipfolder = string.Format("{0}{1}", UpdateZipFolder, CurrentPackcageVersion);

        Directory.CreateDirectory(zipfolder);

        foreach(var needupfile in update_filerelative)
        {
            string sourcefile = CurrentPackageRoot + needupfile.Key;
            string destfile = string.Format("{0}/{1}/{2}",zipfolder,needupfile.Value,needupfile.Key);
            if (File.Exists(destfile))
            {
                Debug.LogError("Error ,new Version file exist??? "+destfile);
                File.Delete(destfile);
            }
            string path = Path.GetDirectoryName(destfile);
            if (!Directory.Exists(path)) Directory.CreateDirectory(path);

            File.Copy(sourcefile, destfile, true);
        }

        string verfile = string.Format("{0}/{1}/version.txt",zipfolder,CurrentPackcageVersion);
        FileStream fs = new FileStream(verfile, FileMode.Create);
        byte[] data = Encoding.UTF8.GetBytes(update_version.ToString());
        fs.Write(data, 0, data.Length);
        fs.Flush();
        fs.Close();
       
        zipfolder = zipfolder.Replace("\\","/");
        DirectoryInfo sourceZipFolder = new DirectoryInfo(zipfolder);
        
        string packdic = zipfolder + "/../";
        DirectoryInfo packagedirectory = new DirectoryInfo(packdic);        
        
        string zipfullname = zipfolder + ".zip";
        FastZipEvents getprogress = new FastZipEvents();

        getprogress.DirectoryFailure = DirectoryFailureHandler;
        getprogress.FileFailure = FileFailureHandler;
        getprogress.Progress = ProgressHandler;

        filesize = 0;
        filezipsize = 0;
        List<string> files = getAllFileinDir(sourceZipFolder.FullName);
        foreach(var file in files)
        {
            FileInfo fileinfo = new FileInfo(file);            
            filesize += fileinfo.Length;
        }
        Debug.Log("Source File Size is :"+filesize);


        ZipVersionSuccess = true;
        FileUtils.ZipFile(zipfullname, sourceZipFolder.FullName, getprogress);
        while (!ZipVersionSuccess)//不知道为什么反正是压缩挂了，那么重新压缩一遍
        {
            ZipVersionSuccess = true;
            FileUtils.ZipFile(zipfullname, sourceZipFolder.FullName, getprogress);
        }
        
        WriteCurZipInfo(zipfullname, zipfolder);        
    }

    static void WriteCurZipInfo(string zippath,string zipfolder)
    {
        FileInfo zipfile = new FileInfo(zippath);
        StringBuilder verSb = new StringBuilder();
        verSb.AppendLine("zipsize:" + zipfile.Length +":"+ filesize);
        FileStream fs = new FileStream(zipfolder + ".info", FileMode.Create);
        byte[] data = Encoding.UTF8.GetBytes(verSb.ToString());
        fs.Write(data, 0, data.Length);
        fs.Flush();
        fs.Close();
    }

    static long filesize;      //压缩前文件大小
    static long filezipsize;   //压缩后文件大小
    static bool ZipVersionSuccess = true;  //压缩是否成功

    static void DirectoryFailureHandler(object sender, ICSharpCode.SharpZipLib.Core.ScanFailureEventArgs e)
    {
        Debug.LogError("zip directoty fail :" + e.Name);
        ZipVersionSuccess = false;//什么鬼，zip压缩还会挂，只好重新再压缩一遍
    }

    static void FileFailureHandler(object sender, ICSharpCode.SharpZipLib.Core.ScanFailureEventArgs e)
    {
        Debug.LogError("zip file fail :" + e.Name);
        ZipVersionSuccess = false;//什么鬼，zip压缩还会挂，只好重新再压缩一遍
    }

    static void ProgressHandler(object sender, ICSharpCode.SharpZipLib.Core.ProgressEventArgs e)
    {                        
        filezipsize += e.Processed;
        float percent = (float)filezipsize / filesize;
        
        EditorUtility.DisplayProgressBar("提示", "版本压缩中..", percent);
    }


    static bool IsFileNeedPack(string filename)
    {
        if (filename.EndsWith(".prefab") || filename.EndsWith(".mp3") || filename.EndsWith(".shader") || filename.EndsWith(".ttf") ||
            filename.EndsWith(".bytes") || filename.EndsWith(".png") || filename.EndsWith(".txt"))
            return true;

        return false;
    }

    public static void BuildUnitTest(string target)
    {
        if (target == "Android")
        {
            BuildAllBundles(BuildTarget.Android, false, true);
        }
        if (target == "iOS")
        {
            BuildAllBundles(BuildTarget.iOS, false, true);
        }
        if (target == "Windows")
        {
            BuildAllBundles(BuildTarget.StandaloneWindows, false, true);
        }
    }

    /// <summary>
    /// 客户端重新发版本是调用
    /// </summary>
    /// <param name="target"></param>
    public static void BuildPublishVersionResources(string target)
    {
        if (target == "Android")
        {
            BuildAllBundles(BuildTarget.Android, true,false);
        }
        if(target == "iOS")
        {
            BuildAllBundles(BuildTarget.iOS, true,false);
        }
        if(target == "Windows")
        {
            BuildAllBundles(BuildTarget.StandaloneWindows, true,false);
        }
    }

    /// <summary>
    /// 客户端只更新热更的资源时调用
    /// </summary>
    /// <param name="target"></param>
    public static void BuildUpdateVersionResources(string target)
    {
        if (target == "Android")
        {
            BuildAllBundles(BuildTarget.Android, false, false);
        }
        if (target == "iOS")
        {
            BuildAllBundles(BuildTarget.iOS, false, false);
        }
        if (target == "Windows")
        {
            BuildAllBundles(BuildTarget.StandaloneWindows, false, false);
        }
    }

    /// <summary>
    /// 单独在窗口中调用
    /// </summary>
    static void BuildWindowsRes()
    {        
        BuildAllBundles(BuildTarget.StandaloneWindows,false,false);
    }
    static void BuildAndRes()
    {     
        BuildAllBundles(BuildTarget.Android,false,false);
    }

    static void BuildIosRes()
    {     
        BuildAllBundles(BuildTarget.iOS,false,false);
    }

    static string BuildFileMD5(string filePath)
    {
        FileStream fs = new FileStream(filePath, FileMode.Open);
        MD5 md5 = MD5.Create();
        byte[] hash = md5.ComputeHash(fs);
        StringBuilder sb = new StringBuilder();
        for (int i = 0; i < hash.Length; i++)
        {
            sb.Append(hash[i].ToString("x2"));
        }
        fs.Close();
        fs.Dispose();        
        return sb.ToString();
    }
    static void ClearAssetBundleName()
    {
        int length = AssetDatabase.GetAllAssetBundleNames().Length;
        string[] oldAssetBundleNames = new string[length];
        for (int i = 0; i < length; i++)
        {
            oldAssetBundleNames[i] = AssetDatabase.GetAllAssetBundleNames()[i];
        }

        for (int j = 0; j < oldAssetBundleNames.Length; j++)
        {
            AssetDatabase.RemoveAssetBundleName(oldAssetBundleNames[j], true);
        }
        Debug.Log("<color=#20F856>所有的assetBundle名称已清除</color>");
    }           
    #endregion

    [MenuItem("Tools/资源打包工具")]
    public static void OpenAssetBundleWindows()
    {
        EditorWindow.GetWindow(typeof(AssetBundlePacker), true , "资源打包工具");
    }
    
}
