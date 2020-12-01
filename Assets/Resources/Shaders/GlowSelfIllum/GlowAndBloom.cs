using System;
using UnityEngine;
using UnityStandardAssets.ImageEffects;

namespace LPCFramework
{
    [ExecuteInEditMode]
    [RequireComponent(typeof(Camera))]
    [AddComponentMenu("Image Effects/LCP/Bloom and Glow")]
    public class GlowAndBloom : PostEffectsBase
    {

        [Range(0.0f, 1.5f)]
        public float threshold = 0.25f;
        [Range(0.0f, 2.5f)]
        public float intensity = 0.75f;
        [Range(0.25f, 5.5f)]
        public float blurSize = 1.0f;
        [Range(0, 3)]
        public int blurIterations = 1;
        [Range(0.0f, 0.6f)]
        public float glowBlur = 1.0f;

        public Shader fastBloomShader = null;
        private Material fastBloomMaterial = null;


        public override bool CheckResources()
        {
            CheckSupport(false);

            fastBloomMaterial = CheckShaderAndCreateMaterial(fastBloomShader, fastBloomMaterial);

            if (!isSupported)
            {
                ReportAutoDisable();
            }

            InitialCamera();
            return isSupported;
        }

        void OnDisable()
        {
            if (fastBloomMaterial)
            {
                DestroyImmediate(fastBloomMaterial);
            }
        }

        void OnRenderImage(RenderTexture source, RenderTexture destination)
        {
            if (CheckResources() == false)
            {
                Graphics.Blit(source, destination);
                return;
            }

            fastBloomMaterial.SetVector("_Parameter", new Vector4(blurSize * 0.2f, glowBlur * 0.01f, threshold, intensity));
            source.filterMode = FilterMode.Bilinear;

            int rtW = source.width / 8;
            int rtH = source.height / 8;

            // downsample
            RenderTexture rt = RenderTexture.GetTemporary(rtW, rtH, 0, source.format);
            rt.filterMode = FilterMode.Bilinear;
            if (null != m_GlowRT)
            {
                fastBloomMaterial.SetTexture("_Glow", m_GlowRT);
            }
            Graphics.Blit(source, rt, fastBloomMaterial, 1);

            for (int i = 0; i < blurIterations; i++)
            {
                fastBloomMaterial.SetVector("_Parameter", new Vector4(blurSize * 0.2f + (i * 1.0f), glowBlur * 0.01f, threshold, intensity));

                RenderTexture rt2 = RenderTexture.GetTemporary(rtW, rtH, 0, source.format);
                rt2.filterMode = FilterMode.Bilinear;
                Graphics.Blit(rt, rt2, fastBloomMaterial, 2);
                RenderTexture.ReleaseTemporary(rt);
                rt = rt2;
            }

            fastBloomMaterial.SetTexture("_Bloom", rt);
            Graphics.Blit(source, destination, fastBloomMaterial, 0);

            RenderTexture.ReleaseTemporary(rt);
        }

        #region Second Camera

        public Camera m_GlowCamera;
        public Shader GlowReflShader;
        public RenderTexture m_GlowRT;

        private void InitialCamera()
        {
            if (null != m_GlowCamera && null != GlowReflShader)
            {
                Camera c = GetComponent<Camera>();
                m_GlowCamera.transform.parent = transform;
                m_GlowCamera.transform.localPosition = Vector3.zero;
                m_GlowCamera.transform.localRotation = Quaternion.identity;
                m_GlowCamera.fieldOfView = c.fieldOfView;
                m_GlowCamera.farClipPlane = c.farClipPlane;
                m_GlowCamera.nearClipPlane = c.nearClipPlane;
                m_GlowCamera.aspect = c.aspect;
                
                m_GlowCamera.SetReplacementShader(GlowReflShader, "");
            }
        }

        #endregion
    }
}
