using UnityEngine;
using System.Collections;

[System.Serializable]
public class ProjectorEyeTexture {

	RenderTexture _RenderTexture;	

	Camera _Camera;

	public ProjectorEyeTexture(Camera camera, int size)
    {
		_Camera = camera;

        if (_RenderTexture != null)
        {
            _RenderTexture.Release();
            _RenderTexture = null;
        }

        _RenderTexture = new RenderTexture(size, size, 0, RenderTextureFormat.ARGB32, RenderTextureReadWrite.Default);
        _RenderTexture.useMipMap = false;

        _RenderTexture.Create();

        _RenderTexture.anisoLevel = 0;
        _RenderTexture.filterMode = FilterMode.Bilinear;


        camera.targetTexture = _RenderTexture;    
	}

	public void CleanUp() {
		if (_RenderTexture != null) {
			_RenderTexture.Release();
			_RenderTexture = null;
		}
	}

	public Texture GetTexture() {		
        return _RenderTexture;		
	}

	public RenderTexture GetRenderTexture() {
		return _RenderTexture;
	}
}

