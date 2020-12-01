using UnityEngine;
using UnityEditor;
using System.Collections;

[CustomEditor(typeof(ShadowReceiver))] 
public class ShadowReceiverEditor : Editor {

	public override void OnInspectorGUI() {

		if (!Application.isPlaying) {
			serializedObject.Update ();
			serializedObject.ApplyModifiedProperties();
		}
	}
}
