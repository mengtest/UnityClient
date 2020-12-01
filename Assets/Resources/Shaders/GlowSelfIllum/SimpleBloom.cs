using System;
using UnityEngine;
using UnityStandardAssets.ImageEffects;

namespace LPCFramework
{
    [ExecuteInEditMode]
    [RequireComponent(typeof(Camera))]
    [AddComponentMenu("Image Effects/LCP/Simple Bloom")]
    public class SimpleBloom : PostEffectsBase
    {

        [Range(0.0f, 1.5f)]
        public float threshold = 0.25f;
        [Range(0.0f, 2.5f)]
        public float intensity = 0.75f;
        [Range(0.25f, 5.5f)]
        public float blurSize = 1.0f;
        [Range(0, 3)]
        public int blurIterations = 1;

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

            fastBloomMaterial.SetVector("_Parameter", new Vector4(blurSize * 0.2f, 0.0f, threshold, intensity));
            source.filterMode = FilterMode.Bilinear;

            int rtW = source.width / 8;
            int rtH = source.height / 8;

            // downsample
            RenderTexture rt = RenderTexture.GetTemporary(rtW, rtH, 0, source.format);
            rt.filterMode = FilterMode.Bilinear;
            Graphics.Blit(source, rt, fastBloomMaterial, 1);

            for (int i = 0; i < blurIterations; i++)
            {
                fastBloomMaterial.SetVector("_Parameter", new Vector4(blurSize * 0.2f + (i * 1.0f), 0.0f, threshold, intensity));

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
    }
}
