using UnityEngine;
using System.Collections;
using System.Collections.Generic;

public class GlobalProjectorManager : MonoBehaviour {

    public static List<string> ProjectorLayers = new List<string>() { "ProjectorLayer", "ShadowLayer" };
    Dictionary<int, InternalProjector> Projectors = new Dictionary<int, InternalProjector>();


    int[] _ShadowResolutions =  new int[] { 128, 256, 512, 1024, 2048 };

    public static readonly string GlobalProjectorLayer = "GlobalProjectorLayer";    

	
	static GlobalProjectorManager _Instance;
	
	public static Vector3 GlobalProjectionDir {
		set {
			if (_Instance._GlobalProjectionDir != value) {
				_Instance._GlobalProjectionDir = value;
				_Instance.OnProjectionDirChange();
			}
		}
		
		get {
			return _Instance._GlobalProjectionDir;
		}
	}
	public Vector3 _GlobalProjectionDir = new Vector3(0.0f, -1.0f, 0.0f);
	
	
	public int GlobalShadowResolution {
		set {
			if (_Instance._GlobalShadowResolution != value) {
				_Instance._GlobalShadowResolution = value;
				_Instance.OnShadowResolutionChange();
			}
		}
		
		get {
			return _Instance._GlobalShadowResolution;
		}
	}
	int _GlobalShadowResolution = 3;
	
	public  float GlobalCutOffDistance {
		set {
			_Instance._GlobalCutOffDistance = value;
		}
		
		get {
			return _Instance._GlobalCutOffDistance;
		}
	}
	
	float _GlobalCutOffDistance = 1000.0f;

    bool _renderShadows = true;
	
	public bool RenderShadows { 
		set {
			_renderShadows = value;
		}
		get {
			return _renderShadows;
		}
	}
    internal class InternalProjector :MonoBehaviour
    {
        public void Initialize(string layername)
        {        
            ProjectorMaterialShadow = layername == "ProjectorLayer" ? new Material(Shader.Find("Shadow Projector/ProjectorReceiver")) : new Material(Shader.Find("Shadow Projector/ProjectorReceiver"));

            ProjectorCamera = gameObject.AddComponent<Camera>();
            ProjectorCamera.clearFlags = CameraClearFlags.SolidColor;
            ProjectorCamera.backgroundColor = new Color32(0, 0, 0, 0);
            ProjectorCamera.cullingMask = 1 << LayerMask.NameToLayer(layername);//;1 << LayerMask.NameToLayer(GlobalProjectorManager.GlobalProjectorLayer);
            ProjectorCamera.orthographic = true;
            ProjectorCamera.nearClipPlane = -1;
            ProjectorCamera.farClipPlane = 100000;
            ProjectorCamera.aspect = 1.0f;
            ProjectorCamera.depth = float.MinValue;
            ProjectorCamera.allowHDR = false;
            ProjectorCamera.enabled = false;


            BiasMatrix = new Matrix4x4();
            BiasMatrix.SetRow(0, new Vector4(0.5f, 0.0f, 0.0f, 0.5f));
            BiasMatrix.SetRow(1, new Vector4(0.0f, 0.5f, 0.0f, 0.5f));
            BiasMatrix.SetRow(2, new Vector4(0.0f, 0.0f, 0.5f, 0.5f));
            BiasMatrix.SetRow(3, new Vector4(0.0f, 0.0f, 0.0f, 1.0f));

            ProjectorMatrix = new Matrix4x4();
            MBP = new MaterialPropertyBlock();

            ShadowProjectors = new List<ShadowProjector>();

            CreateProjectorEyeTexture();
            projectorBounds = new Bounds();
        }
        
        ProjectorEyeTexture Tex;
        Material ProjectorMaterialShadow;

        Matrix4x4 ProjectorMatrix;
        Matrix4x4 ProjectorClipMatrix;
        Matrix4x4 BiasMatrix;
        Matrix4x4 ViewMatrix;
        Matrix4x4 BPV;
        Matrix4x4 BPVClip;
        Matrix4x4 ModelMatrix;
        Matrix4x4 FinalMatrix;
        Matrix4x4 FinalClipMatrix;

        MaterialPropertyBlock MBP;

        public Camera ProjectorCamera;
        public List<ShadowProjector> ShadowProjectors;
        Bounds projectorBounds;

        void CreateProjectorEyeTexture()
        {
            if (Tex != null)
            {
                Tex.CleanUp();
            }

            Tex = new ProjectorEyeTexture(ProjectorCamera, _Instance._ShadowResolutions[_Instance._GlobalShadowResolution]);
            ProjectorMaterialShadow.SetTexture("_ShadowTex", Tex.GetTexture());

        }
        void CalculateShadowBounds()
        {            
            Vector2 xRange = new Vector2(float.MaxValue, float.MinValue);
            Vector2 yRange = new Vector2(float.MaxValue, float.MinValue);

            Vector2 shadowCoords;
            float maxShadowSize = 0.0f;

            bool noVisibleProjectors = true;
            int projectorIndex = 0;


            ShadowProjector shadowProjector;
            for (int n = 0; n < ShadowProjectors.Count; n++)
            {
                shadowProjector = ShadowProjectors[n];

                if (shadowProjector.EnableCutOff)
                {
                    if ((shadowProjector.transform.position - Camera.main.transform.position).magnitude > _Instance._GlobalCutOffDistance)
                    {
                        shadowProjector.Discard(true);
                        continue;
                    }
                    else
                    {
                        shadowProjector.Discard(false);
                    }
                }

                noVisibleProjectors = false;
                shadowProjector.SetVisible(true);

                shadowCoords = ProjectorCamera.WorldToViewportPoint(shadowProjector.GetShadowPos());

                if (projectorIndex == 0)
                {
                    projectorBounds.center = shadowProjector.GetShadowPos();
                    projectorBounds.size = Vector3.zero;
                }
                else
                {
                    projectorBounds.Encapsulate(shadowProjector.GetShadowPos());
                }

                if (shadowCoords.x < xRange.x) xRange.x = shadowCoords.x;
                if (shadowCoords.x > xRange.y) xRange.y = shadowCoords.x;

                if (shadowCoords.y < yRange.x) yRange.x = shadowCoords.y;
                if (shadowCoords.y > yRange.y) yRange.y = shadowCoords.y;

                float shadowSize = shadowProjector.GetShadowWorldSize();

                if (shadowSize > maxShadowSize)
                {
                    maxShadowSize = shadowSize;
                }

                projectorIndex++;
            }

            if (noVisibleProjectors)
            {
                return;
            }

            float cameraWorldSize = ProjectorCamera.orthographicSize * 2.0f;
            float maxShadowSizeViewport = Mathf.Max(0.08f, maxShadowSize / cameraWorldSize);

            Vector3 camPos = projectorBounds.center + projectorBounds.extents.magnitude * -_Instance._GlobalProjectionDir.normalized;
            ProjectorCamera.transform.position = camPos;

            float maxRange = Mathf.Max(xRange[1] - xRange[0] + maxShadowSizeViewport * 2.0f, yRange[1] - yRange[0] + maxShadowSizeViewport * 2.0f);
            ProjectorCamera.orthographicSize = ProjectorCamera.orthographicSize * maxRange;
        }

        public void RenderProjectors()
        {
            if (ShadowProjectors.Count > 0)
            {
                CalculateShadowBounds();

                float n = ProjectorCamera.nearClipPlane;
                float f = ProjectorCamera.farClipPlane;
                float r = ProjectorCamera.orthographicSize;
                float t = ProjectorCamera.orthographicSize;
                float clipN = 0.1f;
                float clipF = 100.0f;


                ProjectorMatrix.SetRow(0, new Vector4(1 / r, 0.0f, 0.0f, 0));
                ProjectorMatrix.SetRow(1, new Vector4(0.0f, 1 / t, 0.0f, 0));
                ProjectorMatrix.SetRow(2, new Vector4(0.0f, 0.0f, -2 / (f - n), 0));
                ProjectorMatrix.SetRow(3, new Vector4(0.0f, 0.0f, 0.0f, 1.0f));

                //_ProjectorMatrix.SetRow(0, new Vector4(2 / r, 0.0f, 0.0f, 0));//fuck .....
                //_ProjectorMatrix.SetRow(1, new Vector4(0.0f, 2 / t, 0.0f, 0));
                //_ProjectorMatrix.SetRow(2, new Vector4(0.0f, 0.0f,1 / (f - n), 0));
                //_ProjectorMatrix.SetRow(3, new Vector4(0.0f, 0.0f, 0.0f, 1.0f));

                //_ProjectorClipMatrix.SetRow(0, new Vector4(clipN / r, 0.0f, 0.0f, 0));
                //_ProjectorClipMatrix.SetRow(1, new Vector4(0.0f, clipN / t, 0.0f, 0));
                //_ProjectorClipMatrix.SetRow(2, new Vector4(0.0f, 0.0f, -(clipF + clipN) / (clipF - clipN), -2 * clipF * clipN / (clipF - clipN)));
                //_ProjectorClipMatrix.SetRow(3, new Vector4(0.0f, 0.0f, -1.0f, 0.0f));

                //_ProjectorClipMatrix.SetRow(0, new Vector4(2 * clipN / r, 0.0f, 0.0f, 0));
                //_ProjectorClipMatrix.SetRow(1, new Vector4(0.0f,2* clipN / t, 0.0f, 0));
                //_ProjectorClipMatrix.SetRow(2, new Vector4(0.0f, 0.0f, (clipF) / (clipF - clipN), -1 * clipF * clipN / (clipF - clipN)));
                //_ProjectorClipMatrix.SetRow(3, new Vector4(0.0f, 0.0f, -1.0f, 0.0f));

                ViewMatrix = ProjectorCamera.transform.localToWorldMatrix.inverse;

                BPV = BiasMatrix * ProjectorMatrix * ViewMatrix;
                

                Render();
            }
        }
        void Render()
        {
            bool useMBP = true; 

#if UNITY_WP8
		useMBP = false;
#endif

            ShadowReceiver receiver;

            for (int i = 0; i < _Instance._ShadowReceivers.Count; i++)
            {
                receiver = _Instance._ShadowReceivers[i];
                ModelMatrix = receiver.transform.localToWorldMatrix;
                FinalMatrix = BPV * ModelMatrix;                
                if (useMBP)
                {
                    MBP.Clear();
                    MBP.SetMatrix("_GlobalProjector", FinalMatrix);                    

                    for (int n = 0; n < _Instance._ShadowReceivers[i].GetMesh().subMeshCount; n++)
                    {
                        Graphics.DrawMesh(_Instance._ShadowReceivers[i].GetMesh(), ModelMatrix, ProjectorMaterialShadow, LayerMask.NameToLayer("Default"), null, n, MBP);
                    }
                }
                else
                {
                    ProjectorMaterialShadow.SetMatrix("_GlobalProjector", FinalMatrix);                    
                    Graphics.DrawMesh(_Instance._ShadowReceivers[i].GetMesh(), ModelMatrix, ProjectorMaterialShadow, LayerMask.NameToLayer("Default"));
                }
            }

        }
        public void OnShadowResolutionChange()
        {
            CreateProjectorEyeTexture();
        }
        public void OnProjectionDirChange()
        {     
            if (ProjectorCamera != null)
            {
                ProjectorCamera.transform.rotation = Quaternion.LookRotation(_Instance._GlobalProjectionDir);
            }
        }

        public void AddProjector(ShadowProjector projector)
        {
            if (Tex == null)
            {
                CreateProjectorEyeTexture();
            }
            
            if (!ShadowProjectors.Contains(projector))
            {
                ShadowProjectors.Add(projector);                

                if (ProjectorCamera.enabled == false)
                {
                    ProjectorCamera.enabled = true;
                }
            }

        }

        public void RemoveProjector(ShadowProjector projector)
        {
            if (ShadowProjectors.Contains(projector))
            {
                ShadowProjectors.Remove(projector);

                if (ShadowProjectors.Count == 0)
                {
                    ProjectorCamera.enabled = false;
                }
            }
        }

        void OnPreCull()
        {
            foreach (ShadowProjector shadowProjector in ShadowProjectors)
            {
                if (!shadowProjector.IsDiscarded())
                {
                    shadowProjector.SetVisible(true);
                }
            }
        }

        void OnPostRender()
        {
            foreach (ShadowProjector shadowProjector in ShadowProjectors)
            {
                shadowProjector.SetVisible(false);
            }
        }
    }
    		
	List<ShadowReceiver> _ShadowReceivers;
							
	public static GlobalProjectorManager Get() {
        if (_Instance == null)
        {
            GameObject pm = GameObject.Find("GlobalProjectorManager");
            if (pm != null)
                _Instance = pm.GetComponent<GlobalProjectorManager>();
            if (_Instance == null)
                _Instance = new GameObject("GlobalProjectorManager").AddComponent<GlobalProjectorManager>();
            _Instance.Initialize();
        }		        
        return _Instance;
	}

    bool initialized = false;
	
	
	void Initialize() {
        if (initialized)
            return;

        initialized = true;

        foreach (var player in ProjectorLayers)
        {
            int ilayer = LayerMask.NameToLayer(player);
            if (!Projectors.ContainsKey(ilayer))
            {
                GameObject gameobject = new GameObject(player);
                gameobject.transform.parent = transform;
                gameobject.transform.localPosition = Vector3.zero;
                gameobject.transform.localScale = Vector3.one;
                gameobject.transform.localRotation = Quaternion.identity;
                InternalProjector ip = gameobject.AddComponent<InternalProjector>();
                Projectors.Add(ilayer, ip);
                ip.Initialize(player);
            }
        }						
		_ShadowReceivers = new List<ShadowReceiver>();

	}
		
	void Awake() {
		OnProjectionDirChange();
	}
	
	void Start() {
		OnProjectionDirChange();       
	}
	
	void OnDestroy() {
		_Instance = null;
	}
	
	public static bool Exists() {
		return (_Instance != null);
	}
		
	public void AddProjector(ShadowProjector projector) {
		
        int ilayer = projector.layermask;
        if (Projectors.ContainsKey(ilayer))
        {
            Projectors[ilayer].AddProjector(projector);
        }		
	}
	
	public void RemoveProjector(ShadowProjector projector)
    {
        int ilayer = projector.layermask;
        if (Projectors.ContainsKey(ilayer))
        {
            Projectors[ilayer].RemoveProjector(projector);
        }

    }
	
	public void AddReceiver(ShadowReceiver receiver) {
		if (!_ShadowReceivers.Contains(receiver))
        {			
			_ShadowReceivers.Add(receiver);
		}
	}
			
	public void RemoveReceiver(ShadowReceiver receiver) {
		if (_ShadowReceivers.Contains(receiver)) {
			_ShadowReceivers.Remove(receiver);
		}
	}
	
	void OnProjectionDirChange()
    {
        foreach (var proj in Projectors)
        {
            proj.Value.OnProjectionDirChange();
        }

	}
	
	void OnShadowResolutionChange()
    {        
        foreach (var proj in Projectors)
        {
            proj.Value.OnShadowResolutionChange();
        }
    }
				
	void LateUpdate() {
		if (!_renderShadows) {
			return;
		}						
        foreach (var proj in Projectors)
        {
            proj.Value.RenderProjectors();
        }
        	
	}				
}