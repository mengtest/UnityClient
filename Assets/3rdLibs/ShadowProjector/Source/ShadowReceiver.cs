using UnityEngine;
using System.Collections;

[AddComponentMenu("Shadow Projector/Shadow Receiver")]
public class ShadowReceiver : MonoBehaviour {
	
	MeshFilter _meshFilter;
	Mesh _mesh;
	Mesh _meshCopy;
	MeshRenderer _meshRenderer;


	public int _id;
	
	void Awake() {

		_meshFilter = GetComponent<MeshFilter>();
		_meshRenderer = GetComponent<MeshRenderer>();
			
		if (!_meshRenderer.isPartOfStaticBatch && _meshFilter != null) {
			_mesh = _meshFilter.sharedMesh;
		}
		
		_meshCopy = null;
	}
	
	void Start () {	
		AddReceiver();

		if (_meshRenderer.isPartOfStaticBatch && _meshRenderer != null) {
			_meshCopy = FSPStaticMeshHolder.Get().GetMesh(_id);


		}
	}
	
	public Mesh GetMesh() {
		if (_meshCopy != null) {
			return _meshCopy;
		} else {
			return _mesh;
		}
	}
	
	void OnEnable() {
		AddReceiver();
	}
	
	void OnDisable() {
		RemoveReceiver();
	}

	void OnBecameVisible() {
		AddReceiver();
	}

	void OnBecameInvisible() {
		RemoveReceiver();
	}
	
	void OnDestroy() {
		RemoveReceiver();
	}

	void AddReceiver() {
		if (_meshFilter != null)
        {	
			GlobalProjectorManager.Get().AddReceiver(this);
		}
	}

	void RemoveReceiver() {
		if (GlobalProjectorManager.Exists())
        {
			if (_meshFilter != null)
            {		
				GlobalProjectorManager.Get().RemoveReceiver(this);
			}
		}
	}
}