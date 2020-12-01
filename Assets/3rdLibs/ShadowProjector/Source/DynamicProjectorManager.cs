using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class DynamicProjectorManager : MonoBehaviour
{
    private static DynamicProjectorManager Ins_ = null;
    public static DynamicProjectorManager Instance
    {
        get { return Ins_; }
    }
    private Projector _projector;    
    private Camera _lightCamera = null;
    private RenderTexture _shadowTex;    
    private List<Renderer> _shadowCasterList = new List<Renderer>();
    private BoxCollider _boundsCollider;
    public float boundsOffset = 1;

    void Awake()
    {
        Ins_ = this;
    }
    
    void Start()
    {
        _projector = GetComponent<Projector>();
        _projector.transform.localEulerAngles = new Vector3(90,0,0);
        _projector.orthographic = true;
        _projector.enabled = false;
        if (_lightCamera == null)
        {
            _lightCamera = gameObject.GetComponent<Camera>();
            _lightCamera.orthographic = true;            
            _lightCamera.clearFlags = CameraClearFlags.SolidColor;
            _lightCamera.backgroundColor = new Color(255, 255, 255, 0);

        }
#if UNITY_EDITOR
        _boundsCollider = new GameObject("Test use to show bounds").AddComponent<BoxCollider>();
#endif
    }
    public void AddProjector(DynamicProjector projector)
    {        
        if (projector.GetRenderer() != null && !_shadowCasterList.Contains(projector.GetRenderer()))
        {
            _projector.enabled = true;
            Renderer[] renders = projector.gameObject.GetComponentsInChildren<Renderer>();
            for(int i = 0;i< renders.Length; i++)
            {
                renders[i].gameObject.layer = LayerMask.NameToLayer("Troops");
            }            
            _shadowCasterList.Add(projector.GetRenderer());            
        }
    }
    public void RemProjector(DynamicProjector projector)
    {
        if (projector.GetRenderer() != null && _shadowCasterList.Contains(projector.GetRenderer()))
        {
            _shadowCasterList.Remove(projector.GetRenderer());
            Renderer[] renders = projector.gameObject.GetComponentsInChildren<Renderer>();
            for (int i = 0; i < renders.Length; i++)
            {
                renders[i].gameObject.layer = LayerMask.NameToLayer("Default");
            }            
            if (_shadowCasterList.Count == 0)
            {
                _projector.enabled = false;
            }
        }
    }

    void LateUpdate()
    {                
        Bounds b = new Bounds();
        for (int i = 0; i < _shadowCasterList.Count; i++)
        {
            if (_shadowCasterList[i] != null)
            {
                b.Encapsulate(_shadowCasterList[i].bounds);
            }
        }
        b.extents += Vector3.one * boundsOffset;
#if UNITY_EDITOR
        if (_boundsCollider != null)
        {
            _boundsCollider.center = b.center;
            _boundsCollider.size = b.size;
        }        
#endif        
        SetLightCamera(b, _lightCamera);
        _projector.aspectRatio = _lightCamera.aspect;
        _projector.orthographicSize = _lightCamera.orthographicSize;
        _projector.nearClipPlane = _lightCamera.nearClipPlane;
        _projector.farClipPlane = _lightCamera.farClipPlane;
    }

    List<Vector4> _vList = new List<Vector4>();
    void SetLightCamera(Bounds b, Camera lightCamera)
    {        
        lightCamera.transform.position = b.center;
        
        Matrix4x4 lgihtw2v = lightCamera.transform.worldToLocalMatrix;
        Vector4 vnLeftUp = lgihtw2v * new Vector3(b.max.x, b.max.y, b.max.z);
        Vector4 vnRightUp = lgihtw2v * new Vector3(b.max.x, b.min.y, b.max.z);
        Vector4 vnLeftDonw = lgihtw2v * new Vector3(b.max.x, b.max.y, b.min.z);
        Vector4 vnRightDonw = lgihtw2v * new Vector3(b.min.x, b.max.y, b.max.z);
        //
        Vector4 vfLeftUp = lgihtw2v * new Vector3(b.min.x, b.min.y, b.min.z);
        Vector4 vfRightUp = lgihtw2v * new Vector3(b.min.x, b.max.y, b.min.z);
        Vector4 vfLeftDonw = lgihtw2v * new Vector3(b.min.x, b.min.y, b.max.z);
        Vector4 vfRightDonw = lgihtw2v * new Vector3(b.max.x, b.min.y, b.min.z);

        _vList.Clear();
        _vList.Add(vnLeftUp);
        _vList.Add(vnRightUp);
        _vList.Add(vnLeftDonw);
        _vList.Add(vnRightDonw);

        _vList.Add(vfLeftUp);
        _vList.Add(vfRightUp);
        _vList.Add(vfLeftDonw);
        _vList.Add(vfRightDonw);
        
        float maxX = -float.MaxValue;
        float maxY = -float.MaxValue;
        float maxZ = -float.MaxValue;
        float minZ = float.MaxValue;
        for (int i = 0; i < _vList.Count; i++)
        {
            Vector4 v = _vList[i];
            if (Mathf.Abs(v.x) > maxX)
            {
                maxX = Mathf.Abs(v.x);
            }
            if (Mathf.Abs(v.y) > maxY)
            {
                maxY = Mathf.Abs(v.y);
            }
            if (v.z > maxZ)
            {
                maxZ = v.z;
            }
            else if (v.z < minZ)
            {
                minZ = v.z;
            }
        }

        if (minZ < 0)
        {
            lightCamera.transform.position += -lightCamera.transform.forward.normalized * Mathf.Abs(minZ);
            maxZ = maxZ - minZ;
        }
        
        lightCamera.orthographic = true;
        lightCamera.aspect = maxX / maxY;
        lightCamera.orthographicSize = maxY+2.5f;
        lightCamera.nearClipPlane = 0.0f;
        lightCamera.farClipPlane = 100;
    }
}
