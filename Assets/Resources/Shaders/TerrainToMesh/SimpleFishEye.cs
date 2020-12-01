using System;
using UnityEngine;
using UnityStandardAssets.ImageEffects;

namespace LPCFramework
{
    [ExecuteInEditMode]
    [RequireComponent(typeof(Camera))]
    [AddComponentMenu("Image Effects/LCP/Simple FishEye")]
    public class SimpleFishEye : PostEffectsBase
    {
        [Range(0.0f, 0.99f)]
        public float bend = 0.0f;

        [Range(0.0f, 2.0f)]
        public float bulge = 0.25f;

        [Range(0.0f, 0.9f)]
        public float expand = 0.5f;

        [Range(0.0f, 15.0f)]
        public float compact = 4.0f;

        public bool GridOn = true;

        public Shader m_FishEye = null;
        private Material m_FishEyeMat = null;
        
        public override bool CheckResources()
        {
            CheckSupport(false);

            m_FishEyeMat = CheckShaderAndCreateMaterial(m_FishEye, m_FishEyeMat);

            if (!isSupported)
            {
                ReportAutoDisable();
            }

            return isSupported;
        }

        void OnDisable()
        {
            if (m_FishEyeMat)
            {
                DestroyImmediate(m_FishEyeMat);
            }
        }

        void OnRenderImage(RenderTexture source, RenderTexture destination)
        {
            if (CheckResources() == false)
            {
                Graphics.Blit(source, destination);
                return;
            }
            m_FishEyeMat.SetVector("_Params", new Vector4(1.0f - bend, bulge, expand, compact));
            m_FishEyeMat.SetColor("_TestColor", GridOn ? Color.white : Color.clear);
            
            Graphics.Blit(source, destination, m_FishEyeMat);
        }
    }
}
