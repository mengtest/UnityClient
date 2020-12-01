using UnityEngine;
using UnityEditor;
using System.Collections.Generic;

[CustomEditor(typeof(ShadowProjector))] 
public class ShadowProjectorEditor : Editor
{

	string[] _ShadowResOptions = new string[] { "Very Low", "Low", "Medium", "High", "Very High" };

	string[] _CullingOptions = new string[] { "None", "Caster bounds", "Projection volume" };

	Rect UVRect;
	
	public override void OnInspectorGUI()
    {
		serializedObject.Update ();

		ShadowProjector shadowProj = (ShadowProjector) target;
								        
        SerializedObject tagManager = new SerializedObject(AssetDatabase.LoadAllAssetsAtPath("ProjectSettings/TagManager.asset")[0]);
        SerializedProperty layersProp = tagManager.FindProperty("layers");
        
        List<string> layernames = new List<string>();
        for (int i = 0; i < layersProp.arraySize; i++)
        {
            if (!string.IsNullOrEmpty(layersProp.GetArrayElementAtIndex(i).stringValue))
                layernames.Add(layersProp.GetArrayElementAtIndex(i).stringValue);
        }

        shadowProj.editorlayerindex = EditorGUILayout.Popup("Projector Layer", shadowProj.editorlayerindex, layernames.ToArray());
        shadowProj.layermask = LayerMask.NameToLayer(layernames[shadowProj.editorlayerindex]);
        

        shadowProj.EnableCutOff = EditorGUILayout.BeginToggleGroup("Cutoff shadow by distance?", shadowProj.EnableCutOff);		
		EditorGUILayout.EndToggleGroup();


		shadowProj.ShadowSize = EditorGUILayout.FloatField("Shadow size", shadowProj.ShadowSize);
						
		shadowProj._Material = (Material)EditorGUILayout.ObjectField("Shadow material", (Object)shadowProj._Material, typeof(Material), false, null);

        if (GUILayout.Button("Fix Shadow Pos"))
        {
            shadowProj.FixShadowPos();
        }

        EditorGUILayout.LabelField("Shadow UV Rect");

		UVRect = shadowProj.UVRect;

		EditorGUILayout.BeginHorizontal();
		EditorGUILayout.LabelField("X:", GUILayout.MaxWidth(15));
		UVRect.x = EditorGUILayout.FloatField(UVRect.x, GUILayout.ExpandWidth(true));
		EditorGUILayout.LabelField("Y:", GUILayout.MaxWidth(15));
		UVRect.y = EditorGUILayout.FloatField(UVRect.y, GUILayout.ExpandWidth(true));
		EditorGUILayout.EndHorizontal();

		EditorGUILayout.BeginHorizontal();
		EditorGUILayout.LabelField("W:", GUILayout.MaxWidth(15));
		UVRect.width = EditorGUILayout.FloatField(UVRect.width , GUILayout.ExpandWidth(true));
		EditorGUILayout.LabelField("H:", GUILayout.MaxWidth(15));
		UVRect.height = EditorGUILayout.FloatField(UVRect.height, GUILayout.ExpandWidth(true));
		
		EditorGUILayout.EndHorizontal();
																			
		
		if (GUILayout.Button("Open UV Editor")) {
			ShadowTextureUVEditor.Open(shadowProj);
		}
		
		shadowProj.AutoSizeOpacity = EditorGUILayout.BeginToggleGroup("Auto opacity/size:", shadowProj.AutoSizeOpacity);
		shadowProj.AutoSORaycastLayer = EditorGUILayout.LayerField("Raycast layer", shadowProj.AutoSORaycastLayer);
		shadowProj.AutoSORayOriginOffset = EditorGUILayout.FloatField("Ray origin offset", shadowProj.AutoSORayOriginOffset);
		shadowProj.AutoSOCutOffDistance = EditorGUILayout.FloatField("Cutoff distance", shadowProj.AutoSOCutOffDistance);
		shadowProj.AutoSOMaxScaleMultiplier = EditorGUILayout.FloatField("Max scale multiplier", shadowProj.AutoSOMaxScaleMultiplier);

		EditorGUILayout.EndToggleGroup();

		shadowProj.UVRect = UVRect;

        if (!ProjectorLayerExists())
        {
            CheckProjectorLayer();
        }

		serializedObject.ApplyModifiedProperties();

		ApplyGlobalSettings();
		
		if (GUI.changed)
			EditorUtility.SetDirty (target);
	}

	public void OnEnable() {
		ShadowProjector targetShadowProj = (ShadowProjector)target;
		Object[] shadowProjectors = GameObject.FindObjectsOfType(typeof(ShadowProjector));
		
		foreach (ShadowProjector shadowProj in shadowProjectors) {
			if (shadowProj.GetInstanceID() != targetShadowProj.GetInstanceID()) {
				EditorUtility.SetDirty(shadowProj);
				break;
			}
		}
	}

	public void OnDisable() {
		ApplyGlobalSettings();
	}

	void ApplyGlobalSettings() {
		ShadowProjector targetShadowProj = (ShadowProjector)target;
		Object[] shadowProjectors = GameObject.FindObjectsOfType(typeof(ShadowProjector));
		
		foreach (ShadowProjector shadowProj in shadowProjectors) {
			if (shadowProj.GetInstanceID() != targetShadowProj.GetInstanceID()) {				
				EditorUtility.SetDirty(shadowProj);
			}
		}
	}

    public static bool ProjectorLayerExists()
    {
        if (int.Parse(Application.unityVersion[0].ToString()) > 4)
        {
            SerializedObject tagManager = new SerializedObject(AssetDatabase.LoadAllAssetsAtPath("ProjectSettings/TagManager.asset")[0]);
            SerializedProperty layersProp = tagManager.FindProperty("layers");

            bool AllExist = true;
            foreach (var player in GlobalProjectorManager.ProjectorLayers)
            {
                AllExist = false;
                for (int i = 8; i < layersProp.arraySize; i++)
                {
                    string layerName = layersProp.GetArrayElementAtIndex(i).stringValue;
                    if (layerName == player)
                    {
                        AllExist = true;
                        break;
                    }
                    if (!AllExist)
                    {
                        return false;
                    }
                }        
            }
            return true;
        }
        else
        {
            return ProjectorLayerExistsObsolete();
        }
    }
    public static void CheckProjectorLayer()
    {
        if (int.Parse(Application.unityVersion[0].ToString()) > 4)
        {
            SerializedObject tagManager = new SerializedObject(AssetDatabase.LoadAllAssetsAtPath("ProjectSettings/TagManager.asset")[0]);
            SerializedProperty layersProp = tagManager.FindProperty("layers");

            foreach (var player in GlobalProjectorManager.ProjectorLayers)
            {

                for (int i = 8; i < layersProp.arraySize; i++)
                {
                    string layerName = layersProp.GetArrayElementAtIndex(i).stringValue;
                    if (layerName == player)
                    {
                        layersProp.GetArrayElementAtIndex(i).stringValue = "";
                    }
                }

                for (int i = 8; i < layersProp.arraySize; i++)
                {
                    string layerName = layersProp.GetArrayElementAtIndex(i).stringValue;
                    if (layerName == "")
                    {
                        layersProp.GetArrayElementAtIndex(i).stringValue = player;
                        break;
                    }
                }
            }
            tagManager.ApplyModifiedProperties();
        }
        else
        {
            CheckPorjectorLayerObsolete();
        }
    }
    public static void CheckPorjectorLayerObsolete()
    {
        SerializedObject tagManager = new SerializedObject(AssetDatabase.LoadAllAssetsAtPath("ProjectSettings/TagManager.asset")[0]);
        if (ProjectorLayerExists())
        {
            return;
        }

        foreach (var player in GlobalProjectorManager.ProjectorLayers)
        {
            SerializedProperty tit = tagManager.GetIterator();
            while (tit.Next(true))
            {
                if (tit.name.Contains("Layer") && tit.name.Contains("User") && tit.stringValue == "")
                {
                    tit.stringValue = player;
                    tagManager.ApplyModifiedProperties();
                    break;
                }
            }
        }
    }
    public static bool ProjectorLayerExistsObsolete()
    {
        SerializedObject tagManager = new SerializedObject(AssetDatabase.LoadAllAssetsAtPath("ProjectSettings/TagManager.asset")[0]);

        bool AllExist = true;
        foreach (var player in GlobalProjectorManager.ProjectorLayers)
        {
            SerializedProperty pit = tagManager.GetIterator();
            AllExist = false;
            while (pit.Next(true))
            {                
                if (pit.name.Contains("Layer") && pit.name.Contains("User") && pit.stringValue.Contains(player))
                {
                    AllExist = true;
                    break;
                }        
            }
            if (!AllExist)
            {
                return false;
            }
        }
        return true;
    }
}
