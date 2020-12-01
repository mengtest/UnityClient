using UnityEngine;
using UnityEditor;
namespace LPCFramework
{
    [CustomEditor(typeof(SoldierHit), true)]

    public class SoldierHitEditor : Editor
    {
        public override void OnInspectorGUI()
        {
            SoldierHit tar = target as SoldierHit;

            GUILayout.BeginHorizontal();
            tar.duration = EditorGUILayout.FloatField("Duration", tar.duration, GUILayout.Width(170f));
            GUILayout.Label("seconds");
            GUILayout.EndHorizontal();


            GUILayout.BeginHorizontal();
            tar.HitColor = EditorGUILayout.ColorField("Color", tar.HitColor);
            GUILayout.EndHorizontal();

            if (GUILayout.Button(new GUIContent("Play", "Play Eff")))
            {
                tar.Play();
            }
        }
    }
}
