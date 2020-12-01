
/*
Based on ObjExporter.cs, this "wrapper" lets you export to .OBJ directly from the editor menu.
 
This should be put in your "Editor"-folder. Use by selecting the objects you want to export, and select
the appropriate menu item from "Custom->Export". Exported models are put in a folder called
"ExportedObj" in the root of your Unity-project. Textures should also be copied and placed in the
same folder.
N.B. there may be a bug so if the custom option doesn't come up refer to this thread http://answers.unity3d.com/questions/317951/how-to-use-editorobjexporter-obj-saving-script-fro.html */
 
using UnityEngine;
using UnityEditor;
using System.Collections;
using System.Collections.Generic;
using System.IO;
using System.Text;
using System;
using UnityEngine.SceneManagement;
using Object = UnityEngine.Object;

namespace LPCFramework
{
    internal struct ObjMaterial
    {
        public string name;
        public string textureName;
    }

    public class EditorObjExporter : ScriptableObject
    {
        private static int vertexOffset = 0;
        private static int normalOffset = 0;
        private static int uvOffset = 0;


        //User should probably be able to change this. It is currently left as an excercise for
        //the reader.
        private static string targetFolder = "ExportedObj";


        private static string MeshToString(MeshFilter mf, Dictionary<string, ObjMaterial> materialList)
        {
            Mesh m = mf.sharedMesh;
            Material[] mats = mf.GetComponent<Renderer>().sharedMaterials;

            StringBuilder sb = new StringBuilder();

            sb.Append("g ").Append(mf.name).Append("\n");
            foreach (Vector3 lv in m.vertices)
            {
                Vector3 wv = mf.transform.TransformPoint(lv);

                //This is sort of ugly - inverting x-component since we're in
                //a different coordinate system than "everyone" is "used to".
                sb.Append(string.Format("v {0} {1} {2}\n", -wv.x, wv.y, wv.z));
            }
            sb.Append("\n");

            foreach (Vector3 lv in m.normals)
            {
                Vector3 wv = mf.transform.TransformDirection(lv);

                sb.Append(string.Format("vn {0} {1} {2}\n", -wv.x, wv.y, wv.z));
            }
            sb.Append("\n");

            foreach (Vector3 v in m.uv)
            {
                sb.Append(string.Format("vt {0} {1}\n", v.x, v.y));
            }

            for (int material = 0; material < m.subMeshCount; material ++)
            {
                sb.Append("\n");
                sb.Append("usemtl ").Append(mats[material].name).Append("\n");
                sb.Append("usemap ").Append(mats[material].name).Append("\n");

                //See if this material is already in the materiallist.
                try
                {
                    ObjMaterial objMaterial = new ObjMaterial();

                    objMaterial.name = mats[material].name;

                    if (mats[material].mainTexture)
                        objMaterial.textureName = AssetDatabase.GetAssetPath(mats[material].mainTexture);
                    else
                        objMaterial.textureName = null;

                    materialList.Add(objMaterial.name, objMaterial);
                }
                catch (ArgumentException)
                {
                    //Already in the dictionary
                }


                int[] triangles = m.GetTriangles(material);
                for (int i = 0; i < triangles.Length; i += 3)
                {
                    //Because we inverted the x-component, we also needed to alter the triangle winding.
                    sb.Append(string.Format("f {1}/{1}/{1} {0}/{0}/{0} {2}/{2}/{2}\n",
                        triangles[i] + 1 + vertexOffset, triangles[i + 1] + 1 + normalOffset,
                        triangles[i + 2] + 1 + uvOffset));
                }
            }

            vertexOffset += m.vertices.Length;
            normalOffset += m.normals.Length;
            uvOffset += m.uv.Length;

            return sb.ToString();
        }

        private static string MeshToString(SMeshAndTransform mesh)
        {
            StringBuilder sb = new StringBuilder();

            sb.Append("g ").Append(mesh.m_sName).Append("\n");
            foreach (Vector3 lv in mesh.m_Mesh.vertices)
            {
                Vector3 newV = mesh.m_Transform.TransformPoint(lv);
                sb.Append(string.Format("v {0} {1} {2}\n", -newV.x, newV.y, newV.z));
            }
            sb.Append("\n");

            foreach (Vector3 lv in mesh.m_Mesh.normals)
            {
                Vector3 newV = mesh.m_Transform.TransformVector(lv);
                sb.Append(string.Format("vn {0} {1} {2}\n", -newV.x, newV.y, newV.z));
            }
            sb.Append("\n");

            foreach (Vector3 v in mesh.m_Mesh.uv)
            {
                sb.Append(string.Format("vt {0} {1}\n", v.x, v.y));
            }

            int[] triangles = mesh.m_Mesh.triangles;
            for (int i = 0; i < triangles.Length; i += 3)
            {
                //Because we inverted the x-component, we also needed to alter the triangle winding.
                sb.Append(string.Format("f {1}/{1}/{1} {0}/{0}/{0} {2}/{2}/{2}\n",
                    triangles[i] + 1 + vertexOffset, triangles[i + 1] + 1 + normalOffset,
                    triangles[i + 2] + 1 + uvOffset));
            }

            vertexOffset += mesh.m_Mesh.vertices.Length;
            normalOffset += mesh.m_Mesh.normals.Length;
            uvOffset += mesh.m_Mesh.uv.Length;

            return sb.ToString();
        }

        private static string MeshToString(Mesh m)
        {
            StringBuilder sb = new StringBuilder();

            sb.Append("g ").Append(m.name).Append("\n");
            foreach (Vector3 lv in m.vertices)
            {
                sb.Append(string.Format("v {0} {1} {2}\n", -lv.x, lv.y, lv.z));
            }
            sb.Append("\n");

            foreach (Vector3 lv in m.normals)
            {
                sb.Append(string.Format("vn {0} {1} {2}\n", -lv.x, lv.y, lv.z));
            }
            sb.Append("\n");

            foreach (Vector3 v in m.uv)
            {
                sb.Append(string.Format("vt {0} {1}\n", v.x, v.y));
            }

            int[] triangles = m.triangles;
            for (int i = 0; i < triangles.Length; i += 3)
            {
                //Because we inverted the x-component, we also needed to alter the triangle winding.
                sb.Append(string.Format("f {1}/{1}/{1} {0}/{0}/{0} {2}/{2}/{2}\n",
                    triangles[i] + 1 + vertexOffset, triangles[i + 1] + 1 + normalOffset,
                    triangles[i + 2] + 1 + uvOffset));
            }

            vertexOffset += m.vertices.Length;
            normalOffset += m.normals.Length;
            uvOffset += m.uv.Length;

            return sb.ToString();
        }

        private static void Clear()
        {
            vertexOffset = 0;
            normalOffset = 0;
            uvOffset = 0;
        }

        private static Dictionary<string, ObjMaterial> PrepareFileWrite()
        {
            Clear();

            return new Dictionary<string, ObjMaterial>();
        }

        private static void MaterialsToFile(Dictionary<string, ObjMaterial> materialList, string folder, string filename)
        {
            using (StreamWriter sw = new StreamWriter(folder + "/" + filename + ".mtl"))
            {
                foreach (KeyValuePair<string, ObjMaterial> kvp in materialList)
                {
                    sw.Write("\n");
                    sw.Write("newmtl {0}\n", kvp.Key);
                    sw.Write("Ka  0.6 0.6 0.6\n");
                    sw.Write("Kd  0.6 0.6 0.6\n");
                    sw.Write("Ks  0.9 0.9 0.9\n");
                    sw.Write("d  1.0\n");
                    sw.Write("Ns  0.0\n");
                    sw.Write("illum 2\n");

                    if (kvp.Value.textureName != null)
                    {
                        string destinationFile = kvp.Value.textureName;


                        int stripIndex = destinationFile.LastIndexOf('/'); //FIXME: Should be Path.PathSeparator;

                        if (stripIndex >= 0)
                            destinationFile = destinationFile.Substring(stripIndex + 1).Trim();


                        string relativeFile = destinationFile;

                        destinationFile = folder + "/" + destinationFile;

                        Debug.Log("Copying texture from " + kvp.Value.textureName + " to " + destinationFile);

                        try
                        {
                            //Copy the source file
                            File.Copy(kvp.Value.textureName, destinationFile);
                        }
                        catch
                        {

                        }


                        sw.Write("map_Kd {0}", relativeFile);
                    }

                    sw.Write("\n\n\n");
                }
            }
        }

        private static void MeshToFile(MeshFilter mf, string folder, string filename)
        {
            Dictionary<string, ObjMaterial> materialList = PrepareFileWrite();

            using (StreamWriter sw = new StreamWriter(folder + "/" + filename + ".obj"))
            {
                sw.Write("mtllib ./" + filename + ".mtl\n");

                sw.Write(MeshToString(mf, materialList));
            }

            MaterialsToFile(materialList, folder, filename);
        }

        private static void MeshesToFile(MeshFilter[] mf, string folder, string filename)
        {
            Dictionary<string, ObjMaterial> materialList = PrepareFileWrite();

            using (StreamWriter sw = new StreamWriter(folder + "/" + filename + ".obj"))
            {
                sw.Write("mtllib ./" + filename + ".mtl\n");

                for (int i = 0; i < mf.Length; i++)
                {
                    sw.Write(MeshToString(mf[i], materialList));
                }
            }

            MaterialsToFile(materialList, folder, filename);
        }

        private static void MeshesToFile(List<SMeshAndTransform> meshes, string sFileName)
        {
            using (StreamWriter sw = new StreamWriter(sFileName))
            {
                for (int i = 0; i < meshes.Count; ++i)
                {
                    sw.Write(MeshToString(meshes[i]));
                }
            }
        }

        private static void MeshesToFile(Mesh[] mf, string folder, string filename)
        {
            using (StreamWriter sw = new StreamWriter(folder + "/" + filename + ".obj"))
            {
                sw.Write("mtllib ./" + filename + ".mtl\n");

                for (int i = 0; i < mf.Length; i++)
                {
                    sw.Write(MeshToString(mf[i]));
                }
            }
        }

        private static void JustMeshesToFile(Mesh[] mf, string folder, string filename)
        {
            vertexOffset = 0;
            normalOffset = 0;
            uvOffset = 0;
            using (StreamWriter sw = new StreamWriter(folder + "/" + filename + ".obj", false))
            {
                for (int i = 0; i < mf.Length; i++)
                {
                    sw.Write(MeshToString(mf[i]));
                }
            }
        }

        private static bool CreateTargetFolder()
        {
            try
            {
                System.IO.Directory.CreateDirectory(targetFolder);
            }
            catch
            {
                EditorUtility.DisplayDialog("Error!", "Failed to create target folder!", "OK");
                return false;
            }

            return true;
        }

        [MenuItem("GameObject/Terrain to Mesh/Export all MeshFilters in selection to separate OBJs")]
        private static void ExportSelectionToSeparate()
        {
            //if (!CreateTargetFolder())
            //    return;

            UnityEngine.Object[] objects = Selection.objects;
            HashSet<string> meshnames = new HashSet<string>();
            List<Mesh> meshes = new List<Mesh>();
            foreach (UnityEngine.Object obj in objects)
            {
                string sFilePath = "";
                if (obj is GameObject)
                {
                    GameObject go = obj as GameObject;
                    if (null != go.GetComponentInChildren<MeshFilter>()
                        && null != go.GetComponentInChildren<MeshFilter>().sharedMesh)
                    {
                        sFilePath = AssetDatabase.GetAssetPath(go.GetComponentInChildren<MeshFilter>().sharedMesh);
                    }
                }
                else
                {
                    sFilePath = AssetDatabase.GetAssetPath(obj);
                }

                if (!string.IsNullOrEmpty(sFilePath))
                {
                    Object[] data = AssetDatabase.LoadAllAssetsAtPath(sFilePath);
                    foreach (Object chobj in data)
                    {
                        if (chobj is Mesh && !meshnames.Contains(chobj.name))
                        {
                            meshnames.Add(chobj.name);
                            meshes.Add((Mesh)chobj);
                        }
                    }
                }
                
            }

            if (meshes.Count == 0)
            {
                EditorUtility.DisplayDialog("No mesh selected!", "Please select one or more mesh", "OK");
                return;
            }

            for (int i = 0; i < meshes.Count; ++i)
            {
                EditorUtility.DisplayProgressBar("Writting", string.Format("{0} ({1}/{2})", meshes[i].name, i, meshes.Count), i /(float)meshes.Count);
                string sFolder = AssetDatabase.GetAssetPath(meshes[i]);
                sFolder = sFolder.Replace("\\", "/");
                int iLastSlash = sFolder.LastIndexOf('/');
                sFolder = sFolder.Substring(0, iLastSlash);
                JustMeshesToFile(new[] {meshes[i]}, sFolder, meshes[i].name);
            }
            EditorUtility.ClearProgressBar();
            Debug.Log("Done");
        }



        /*
    [MenuItem("GameObject/Terrain to Mesh/Export whole selection to single OBJ")]
    static void ExportWholeSelectionToSingle()
    {
    	if (!CreateTargetFolder())
    		return;
 
 
        Transform[] selection = Selection.GetTransforms(SelectionMode.Editable | SelectionMode.ExcludePrefab);
 
        if (selection.Length == 0)
        {
        	EditorUtility.DisplayDialog("No source object selected!", "Please select one or more target objects", "");
        	return;
        }
 
        int exportedObjects = 0;
 
        ArrayList mfList = new ArrayList();
 
       	for (int i = 0; i < selection.Length; i++)
       	{
       		Component[] meshfilter = selection[i].GetComponentsInChildren(typeof(MeshFilter));
 
       		for (int m = 0; m < meshfilter.Length; m++)
       		{
       			exportedObjects++;
       			mfList.Add(meshfilter[m]);
       		}
       	}
 
       	if (exportedObjects > 0)
       	{
       		MeshFilter[] mf = new MeshFilter[mfList.Count];
 
       		for (int i = 0; i < mfList.Count; i++)
       		{
       			mf[i] = (MeshFilter)mfList[i];
       		}
 
       		string filename = EditorApplication.currentScene + "_" + exportedObjects;
 
       		int stripIndex = filename.LastIndexOf('/');//FIXME: Should be Path.PathSeparator
 
       		if (stripIndex >= 0)
            	filename = filename.Substring(stripIndex + 1).Trim();
 
       		MeshesToFile(mf, targetFolder, filename);
 
 
       		EditorUtility.DisplayDialog("Objects exported", "Exported " + exportedObjects + " objects to " + filename, "");
       	}
       	else
       		EditorUtility.DisplayDialog("Objects not exported", "Make sure at least some of your selected objects have mesh filters!", "");
    }

    [MenuItem("GameObject/Terrain to Mesh/Export each selected to single OBJ")]
    static void ExportEachSelectionToSingle()
    {
    	if (!CreateTargetFolder())
    		return;
 
        Transform[] selection = Selection.GetTransforms(SelectionMode.Editable | SelectionMode.ExcludePrefab);
 
        if (selection.Length == 0)
        {
        	EditorUtility.DisplayDialog("No source object selected!", "Please select one or more target objects", "");
        	return;
        }
 
        int exportedObjects = 0;
 
 
       	for (int i = 0; i < selection.Length; i++)
       	{
       		Component[] meshfilter = selection[i].GetComponentsInChildren(typeof(MeshFilter));
 
       		MeshFilter[] mf = new MeshFilter[meshfilter.Length];
 
       		for (int m = 0; m < meshfilter.Length; m++)
       		{
       			exportedObjects++;
       			mf[m] = (MeshFilter)meshfilter[m];
       		}
 
       		MeshesToFile(mf, targetFolder, selection[i].name + "_" + i);
       	}
 
       	if (exportedObjects > 0)
       	{
       		EditorUtility.DisplayDialog("Objects exported", "Exported " + exportedObjects + " objects", "");
       	}
       	else
       		EditorUtility.DisplayDialog("Objects not exported", "Make sure at least some of your selected objects have mesh filters!", "");
    }
        */

        private struct SMeshAndTransform
        {
            public string m_sName;
            public Mesh m_Mesh;
            public Transform m_Transform;
        }

        [MenuItem("GameObject/Terrain to Mesh/Export whole selection in scene to single OBJ")]
        static void ExportWholeSelectionToSingle2()
        {
            List<GameObject> converted = new List<GameObject>();
            Object[] objects = Selection.objects;
            List<SMeshAndTransform> meshes = new List<SMeshAndTransform>();
            int iIndex = 0;
            foreach (Object obj in objects)
            {
                string sFilePath = "";
                if (obj is GameObject)
                {
                    GameObject go = obj as GameObject;
                    if (go.scene.name == SceneManager.GetActiveScene().name)
                    {
                        foreach (MeshFilter mf in go.GetComponentsInChildren<MeshFilter>())
                        {
                            if (null != mf.sharedMesh && !converted.Contains(mf.gameObject))
                            {
                                converted.Add(mf.gameObject);
                                sFilePath = AssetDatabase.GetAssetPath(go.GetComponentInChildren<MeshFilter>().sharedMesh);
                                if (!string.IsNullOrEmpty(sFilePath))
                                {
                                    Object[] data = AssetDatabase.LoadAllAssetsAtPath(sFilePath);
                                    foreach (Object chobj in data)
                                    {
                                        if (chobj is Mesh)
                                        {
                                            ++iIndex;
                                            meshes.Add(new SMeshAndTransform
                                            {
                                                m_Mesh = (Mesh)chobj,
                                                m_sName = chobj.name + iIndex.ToString(),
                                                m_Transform = mf.gameObject.transform,
                                            });
                                            break;
                                        }
                                    }
                                }
                            }
                        }                        
                    }
                }
            }

            if (meshes.Count > 0)
            {
                string sFile = EditorUtility.SaveFilePanel("生成的Obj保存文件夹",
                    Application.dataPath + "/TempPrefabs/TerrainToMesh/Converted", "meshes", "obj");
                if (string.IsNullOrEmpty(sFile))
                {
                    return;
                }
                MeshesToFile(meshes, sFile);
                EditorUtility.DisplayDialog("Objects exported", "Exported objects to " + sFile, "");
            }
            else
            {
                EditorUtility.DisplayDialog("Objects not exported", "Make sure at least some of your selected objects have mesh filters!", "");
            }
        }
    }
}