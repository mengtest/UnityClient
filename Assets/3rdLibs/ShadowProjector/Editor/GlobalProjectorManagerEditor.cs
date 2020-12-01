using UnityEngine;
using UnityEditor;
using System.Collections;

[CustomEditor(typeof(GlobalProjectorManager))] 
public class GlobalProjectorManagerEditor : Editor
{
    string[] _ShadowResOptions = new string[] { "Very Low", "Low", "Medium", "High", "Very High" };
    public override void OnInspectorGUI()
    {
        GlobalProjectorManager glmgr = (GlobalProjectorManager)target;

        glmgr.GlobalShadowResolution = EditorGUILayout.Popup("Global shadow resolution", glmgr.GlobalShadowResolution, _ShadowResOptions);

        glmgr.GlobalCutOffDistance = EditorGUILayout.Slider("Global cutoff distance", glmgr.GlobalCutOffDistance, 1.0f, 10000.0f);
    }
}