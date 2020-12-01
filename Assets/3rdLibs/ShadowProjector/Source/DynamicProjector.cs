using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class DynamicProjector : MonoBehaviour {

    Renderer renderer;
        
    public Renderer GetRenderer()
    {        
        return renderer;        
    }
    void Start()
    {
        renderer = GetComponentInChildren<Renderer>();        
        if (DynamicProjectorManager.Instance != null)
        {
            DynamicProjectorManager.Instance.AddProjector(this);
        }
    }

    void OnEnable()
    {
        if (DynamicProjectorManager.Instance != null)
        {
            DynamicProjectorManager.Instance.AddProjector(this);
        }
    }

    void OnDisable()
    {
        if (DynamicProjectorManager.Instance != null)
        {
            DynamicProjectorManager.Instance.RemProjector(this);
        }
    }

    void OnDestroy()
    {
        if (DynamicProjectorManager.Instance != null)
        {
            DynamicProjectorManager.Instance.RemProjector(this);
        }
    }
}
