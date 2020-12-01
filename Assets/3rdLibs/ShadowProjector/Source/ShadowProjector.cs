using UnityEngine;
using System.Collections;

[AddComponentMenu("Shadow Projector/Shadow Projector")]
public class ShadowProjector : MonoBehaviour {
	
	private static class MeshGen {
		
		public static Mesh CreatePlane(Vector3 up, Vector3 right, Rect uvRect, Color color, ShadowProjector parent) {
			Mesh planeMesh = new Mesh();
			
			Vector3[] vertices = new Vector3[] {
				(up * 0.5f - right * 0.5f),
				(up * 0.5f + right * 0.5f),
				(-up * 0.5f - right * 0.5f),
				(-up * 0.5f + right * 0.5f)
			};

			Vector2[] uvs = new Vector2[] {
				new Vector2(uvRect.x, uvRect.y + uvRect.height),
				new Vector2(uvRect.x + uvRect.width, uvRect.y + uvRect.height),
				new Vector2(uvRect.x, uvRect.y),
				new Vector2(uvRect.x + uvRect.width, uvRect.y),
			};
			
			Color[] colors = new Color[] {
				color,
				color,
				color,
				color
			};
			
			int[] indices = new int[] { 0, 1, 3, 0, 3, 2 };
			
			planeMesh.vertices = vertices;
			planeMesh.uv = uvs;
			planeMesh.colors = colors;
			planeMesh.SetTriangles(indices, 0);
			
			return planeMesh;
		}
	}
		
	
	
	public bool EnableCutOff {
		set {
			if (_EnableCutOff != value) {
				_EnableCutOff = value;
			}
		}
		
		get {
			return _EnableCutOff;
		}
	}
	
	[UnityEngine.SerializeField]
	bool _EnableCutOff = false;
	
	
	
	public float ShadowSize {
		set {
			if (_ShadowSize != value) {
				_ShadowSize = value;
				if (_ShadowDummyMesh != null) {
					OnShadowSizeChanged();
				}
			}
		}
		
		get {
			return _ShadowSize;
		}
	}
	
	[UnityEngine.SerializeField]
	float _ShadowSize = 1.0f;


    [UnityEngine.SerializeField]
    private Material _material;
	public Material _Material
    {
        set
        {
            if (value != null)
            {
                _material = value;
                if (_Renderer != null)
                {
                    _Renderer.material = _material;
                }
            }           
        }
        get { return _material; }
    } 		
	
    public void FixShadowPos()
    {
        Vector3 raypos = transform.position;
        Vector3 dir = transform.up;
        raypos += dir * 50;
        RaycastHit meshhitInfo;

        Physics.Raycast(raypos, -dir, out meshhitInfo, 100, 1 << LayerMask.NameToLayer("WorldmapGround"));        
        if (_ShadowDummy != null)
        {
            _ShadowDummy.transform.position = meshhitInfo.point;
        }
    }
	
	// UV RECT ----------------------------------------------------
	
	public Rect UVRect {
		set {
			_UVRect = value;
			if (_ShadowDummy != null) {
				OnUVRectChanged();
			}
		}
		
		get {
			return _UVRect;
		}
	}
	
	[UnityEngine.SerializeField]
	Rect _UVRect = new Rect(0.0f, 0.0f, 1.0f, 1.0f);
	
	// Auto Size/Opacity ----------------------------------------------------
	
	public bool AutoSizeOpacity {
		set {
			_AutoSizeOpacity = value;
		}
		
		get {
			return _AutoSizeOpacity;
		}
	}
	
	[UnityEngine.SerializeField]
	bool _AutoSizeOpacity = false;
	
	// Auto Size/Opacity CutOff Distance -------------------------------------------------
	
	public float AutoSOCutOffDistance {
		set {
			_AutoSOCutOffDistance = value;
		}
		
		get {
			return _AutoSOCutOffDistance;
		}
	}
	
	[UnityEngine.SerializeField]
	float _AutoSOCutOffDistance = 10.0f;

	// Auto Size/Opacity Ray Origin Offset -------------------------------------------------
	
	public float AutoSORayOriginOffset {
		set {
			_AutoSORayOriginOffset = value;
		}
		
		get {
			return _AutoSORayOriginOffset;
		}
	}
	
	[UnityEngine.SerializeField]
	float _AutoSORayOriginOffset = 0.0f;
	
	
	// Auto Size/Opacity Max Scale Multiplier -------------------------------------------------
	public float AutoSOMaxScaleMultiplier {
		set {
			_AutoSOMaxScaleMultiplier = value;
		}
		
		get {
			return _AutoSOMaxScaleMultiplier;
		}
	}
	
	[UnityEngine.SerializeField]
	float _AutoSOMaxScaleMultiplier = 2.0f;
	
	// Auto Size/Opacity Layer -------------------------------------------------
	public int AutoSORaycastLayer {
		set {
			_AutoSORaycastLayer = value;
		}
		
		get {
			return _AutoSORaycastLayer;
		}
	}
	
	[UnityEngine.SerializeField]
	int _AutoSORaycastLayer = 0;
	
	MeshRenderer _Renderer;
	MeshFilter _MeshFilter;
	Mesh _ShadowDummyMesh;

    GameObject _ShadowDummy;
	
	float _initialSize;
	

	bool _discarded;

    [UnityEngine.SerializeField]
    public int editorlayerindex = 0;
    public int layermask;

	void Awake() {
		_ShadowDummyMesh = MeshGen.CreatePlane(new Vector3(0.0f, 0.0f, 1.0f), new Vector3(1.0f, 0.0f, 0.0f), _UVRect, 
		                                       new Color(0, 0,0,0), this);
		
		Transform parent = transform;
		
		_ShadowDummy = new GameObject("shadowDummy");
		_ShadowDummy.transform.parent = parent;
		_ShadowDummy.transform.localPosition = new Vector3(0.0f, 0.0f, 0.0f);
        _ShadowDummy.transform.localRotation = Quaternion.identity;

        _ShadowDummy.gameObject.layer = layermask;
				
		OnShadowSizeChanged();
		
		_Renderer = _ShadowDummy.gameObject.AddComponent<MeshRenderer>();
		_Renderer.receiveShadows = false;

		_Renderer.shadowCastingMode = UnityEngine.Rendering.ShadowCastingMode.Off;

		_Renderer.material = _Material;
		_Renderer.enabled = false;
		
		_MeshFilter = _ShadowDummy.gameObject.AddComponent<MeshFilter>();
		_MeshFilter.mesh = _ShadowDummyMesh;
		
		_initialSize = _ShadowSize;		

		_discarded = false;
	}
	
	void Start () {	
		GlobalProjectorManager.Get().AddProjector(this);
		_Renderer.enabled = true;
	}
	
	void OnEnable() {
		GlobalProjectorManager.Get().AddProjector(this);
		_Renderer.enabled = true;
	}
	
	void OnDisable() {
		if (GlobalProjectorManager.Exists()) {
			GlobalProjectorManager.Get().RemoveProjector(this);
			if (_ShadowDummy != null) {
				_Renderer.enabled = false;
			}
		}
	}
	
	void OnDestroy() {
		if (GlobalProjectorManager.Exists()) {
			GlobalProjectorManager.Get().RemoveProjector(this);
		}
	}
	
	public Bounds GetBounds() {
		return _Renderer.bounds;
	}
	
	public bool IsVisible() {
		return _Renderer.isVisible;
	}
	
	public void SetVisible(bool visible) {
		_Renderer.enabled = visible;
	}

	public void Discard(bool discard) {
		_discarded = discard;
		SetVisible(!discard);
	}

	public bool IsDiscarded() {
		return _discarded;
	}
			
	public Matrix4x4 ShadowDummyLocalToWorldMatrix() {
		return _ShadowDummy.transform.localToWorldMatrix;
	}

	public float GetShadowWorldSize() {
		Matrix4x4 dummyMatrix = ShadowDummyLocalToWorldMatrix();
		return Mathf.Max ((dummyMatrix * new Vector3(1.0f, 0.0f, 0.0f)).magnitude, (dummyMatrix * new Vector3(0.0f, 1.0f, 0.0f)).magnitude);
	}

	public Vector3 GetShadowPos() {
		return _ShadowDummy.transform.position;
	}
	
	void OnShadowSizeChanged() {
		_ShadowDummy.transform.localScale = new Vector3(_ShadowSize, _ShadowSize, _ShadowSize);
	}
	
	public void OnUVRectChanged() {
		RebuildMesh();
	}
		
	void RebuildMesh() {
		_ShadowDummyMesh = MeshGen.CreatePlane(new Vector3(0.0f, 0.0f, 1.0f), new Vector3(1.0f, 0.0f, 0.0f), _UVRect,
		                                       new Color(0, 0,0, 0), this);
		_MeshFilter.mesh = _ShadowDummyMesh;
	}
}

