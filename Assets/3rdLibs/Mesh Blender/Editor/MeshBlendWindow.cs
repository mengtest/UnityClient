using UnityEngine;
using UnityEditor;
using System.Runtime.InteropServices;

public class MeshBlendWindow : EditorWindow
{
    public MeshBlendEditor BlendEditor;
    void OnGUI()
    {
        if (BlendEditor != null)
        {
            try
            {
                BlendEditor.OnInspectorGUI();
            }
            catch (System.Exception ex)
            {
                Debug.LogError("Catched Exception :" + ex.StackTrace.ToString() + "            " + ex.Message.ToString());
            }
            
        }
        else
        {
            EditorGUILayout.BeginVertical();
            GUILayout.Label("Select an object with a MeshBlend component on it to start editing");
            EditorGUILayout.EndVertical();
        }
    }

    void OnDestroy()
    {
        if (BlendEditor != null && BlendEditor.PainterWindow == this)
            BlendEditor.PainterWindow = null;
    }


    void OnSelectionChange()
    {
        Repaint();
    }
}