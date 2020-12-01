using System.Collections.Generic;
using System.IO;
using UnityEngine;
using UnityEditor;
using UnityEditor.Callbacks;
#if UNITY_IPHONE
using UnityEditor.iOS.Xcode;
#endif

public class MyBuildPostprocess : MonoBehaviour
{
    internal static void CopyAndReplaceDirectory(string srcPath, string dstPath)
    {
        if (Directory.Exists(dstPath))
            Directory.Delete(dstPath);
        if (File.Exists(dstPath))
            File.Delete(dstPath);

        Directory.CreateDirectory(dstPath);

        foreach (var file in Directory.GetFiles(srcPath))
            File.Copy(file, Path.Combine(dstPath, Path.GetFileName(file)));

        foreach (var dir in Directory.GetDirectories(srcPath))
            CopyAndReplaceDirectory(dir, Path.Combine(dstPath, Path.GetFileName(dir)));
    }

    [PostProcessBuild(999)]
    public static void OnPostprocessBuild(BuildTarget buildTarget, string path)
    {
#if UNITY_IPHONE
        // 仅在iOS运行
        if (buildTarget == BuildTarget.iOS)
        {
            string projectPath = path + "/Unity-iPhone.xcodeproj/project.pbxproj";

            PBXProject pbxProject = new PBXProject();
            pbxProject.ReadFromFile(projectPath);

            string target = pbxProject.TargetGuidByName("Unity-iPhone");

            pbxProject.SetBuildProperty(target, "ENABLE_BITCODE", "NO");

            // Add custom system frameworks. Duplicate frameworks are ignored.
            //proj.AddFrameworkToProject(target, "AssetsLibrary.framework", false);

            // Add Custom framework, Add user packages to project. Most other source or resource files and packages 
            // can be added the same way.
            //CopyAndReplaceDirectory("Assets/Lib/mylib.framework", Path.Combine(path, "Frameworks/mylib.framework"));
            //proj.AddFileToBuild(target, proj.AddFile("Frameworks/mylib.framework", "Frameworks/mylib.framework", PBXSourceTree.Source));

            // Set a custom link flag
            //proj.AddBuildProperty(target, "OTHER_LDFLAGS", "-ObjC");

            pbxProject.WriteToFile(projectPath);
        }
#endif
    }
}