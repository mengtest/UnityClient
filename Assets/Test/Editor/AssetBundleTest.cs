using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEditor;
using NUnit.Framework;
using System.IO;
using System.Text;

public class AssetBundleTest : MonoBehaviour
{
    [Test]
    public void TestGenAssetBundle()
    {
        string platform = "";
        string ResourcesExportFolder = Application.dataPath + "/../../" + "ClientPackagesUnitTest/";

        if (Directory.Exists(ResourcesExportFolder))
            Directory.Delete(ResourcesExportFolder, true);


#if UNITY_ANDROID
        Debug.Log(" UNITY_ANDROID");
        AssetBundlePacker.BuildUnitTest("Android");
        platform = "Android/";
#elif UNITY_IPHONE || UNITY_IOS
        Debug.Log("IOS");
        AssetBundlePacker.BuildUnitTest("iOS");
        platform = "IOS/";
#else
        Debug.Log(" UNITY_WIN");
        AssetBundlePacker.BuildUnitTest("Windows");
        platform = "Win/";
#endif

        {
            string versiontxt = ResourcesExportFolder + platform + "1/version.txt";

            StreamReader r = new StreamReader(versiontxt);
            string info = r.ReadToEnd();
            string[] sArray = info.Split('\n');
            for (int i = 0; i < sArray.Length; i++)
            {
                if (string.IsNullOrEmpty(sArray[i]))
                {
                    continue;
                }
                Debug.Log("<color=#20F856>read version : " + sArray[i] + " </color>");
            }

            r.Close();
        }


        string newfile = Application.dataPath + "/Resources/Prefabs/testnew.txt";
        FileStream fs = new FileStream(newfile, FileMode.Create);
        byte[]data = Encoding.UTF8.GetBytes("testnew");
        fs.Write(data, 0, data.Length);
        fs.Flush();
        fs.Close();

        AssetDatabase.Refresh();


#if UNITY_ANDROID
        Debug.Log(" UNITY_ANDROID");
        AssetBundlePacker.BuildUnitTest("Android");        
#elif UNITY_IPHONE || UNITY_IOS
        Debug.Log("IOS");
        AssetBundlePacker.BuildUnitTest("iOS");        
#else
        Debug.Log(" UNITY_WIN");
        AssetBundlePacker.BuildUnitTest("Windows");
#endif

        File.Delete(newfile);
        AssetDatabase.Refresh();

        {
            string versiontxt = ResourcesExportFolder + platform + "2/version.txt";
            StreamReader r = new StreamReader(versiontxt);
            string info = r.ReadToEnd();
            string[] sArray = info.Split('\n');
            for (int i = 0; i < sArray.Length; i++)
            {
                if (string.IsNullOrEmpty(sArray[i]))
                {
                    continue;
                }
                Debug.Log("<color=#20F856>read version : " + sArray[i] + " </color>");
            }

            r.Close();
        }


    }

}
