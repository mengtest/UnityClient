using UnityEngine;
using System.Collections;
using UnityEditor;

public class TerrainMeshBlendUtility : MonoBehaviour
{
    public static bool IsMeshSaved(Mesh mesh)
    {
        bool hasSaveLabel = false;
        string meshPath = AssetDatabase.GetAssetPath(mesh);
        if (!string.IsNullOrEmpty(meshPath))
        {
            string[] labels = AssetDatabase.GetLabels(mesh);
            for (int i = 0; i < labels.Length; i++)
            {
                if (labels[i] == "MeshBlendPainted")
                {
                    hasSaveLabel = true;
                    break;
                }
            }

        }
        return hasSaveLabel;
    }

    public static void UpdateProperties(MeshBlend comp)
    {
        GameObject activeObject;
        MeshFilter blendmesh;
        activeObject = comp.gameObject;
        blendmesh = comp.gameObject.GetComponent<MeshFilter>();
        if (blendmesh == null)
        {
            Debug.LogWarning("No MeshFilter component assigned for MeshBlend component on object " + comp.gameObject);
            return;
        }
        if (activeObject.GetComponent<Renderer>().sharedMaterial == null)
        {
            Debug.LogError("Could not find shared material for \"" + activeObject.name);
        }
        else
        {
            Mesh mesh = blendmesh.sharedMesh;
            Vector3[] vertices = mesh.vertices;
            Color[] colors = mesh.colors;

            if (colors.Length != vertices.Length)
            {
                colors = new Color[vertices.Length];
            }

            if (activeObject.GetComponent<Renderer>().sharedMaterial.GetTexture("_Tex0") == null)
            {
                for (int i = 0; i < vertices.Length; i++)
                {
                    colors[i].r = 0;
                }
            }
            //if (activeObject.GetComponent<Renderer>().sharedMaterial.GetTexture("_Tex1") == null)
            //{
            //    for (int i = 0; i < vertices.Length; i++)
            //    {
            //        colors[i].g = 0;
            //    }
            //}
            //if (activeObject.GetComponent<Renderer>().sharedMaterial.GetTexture("_Tex2") == null)
            //{
            //    for (int i = 0; i < vertices.Length; i++)
            //    {
            //        colors[i].b = 0;
            //    }
            //}
            //if (activeObject.GetComponent<Renderer>().sharedMaterial.GetTexture("_Tex3") == null)
            //{
            //    for (int i = 0; i < vertices.Length; i++)
            //    {
            //        colors[i].a = 0;
            //    }
            //}
            mesh.colors = colors;
        }
    }
}
