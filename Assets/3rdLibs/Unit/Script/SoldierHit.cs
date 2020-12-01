using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using XLua;

namespace LPCFramework
{
    public class SoldierHit : MonoBehaviour
    {
        public float duration = 1.0f;
        float mid;
        public Color HitColor = Color.red;

        internal class BaseData
        {
            public Material material;
            public Color BaseColor;
        }

        List<BaseData> materials = new List<BaseData>();
        float tick = 0;
        // Use this for initialization
        void Awake()
        {
            Renderer[] rens = gameObject.GetComponentsInChildren<Renderer>();
            for (int i = 0; i < rens.Length; i++)
            {
                Material[] mts = rens[i].materials;
                for (int j = 0; j < mts.Length; j++)
                {
                    if (mts[j].HasProperty("_HitColor"))
                    {
                        BaseData bs = new BaseData();
                        bs.material = mts[j];
                        bs.BaseColor = mts[j].GetColor("_HitColor");
                        materials.Add(bs);
                    }
                }
            }
            tick = 0;
            mid = duration / 2;
            isPlay = false;
        }
        bool isPlay = false;
        [LuaCallCSharp]
        public void Play()
        {
            if (isPlay) return;


            isPlay = true;
            tick = 0;
            StartCoroutine(Hit());
        }

        [LuaCallCSharp]
        public void ForcePlay()
        {
            StopAllCoroutines();
            isPlay = true;
            tick = 0;
            StartCoroutine(Hit());
        }

        [LuaCallCSharp]
        public void Reset()
        {
            StopAllCoroutines();
            foreach (var mt in materials)
            {
                mt.material.SetColor("_HitColor", mt.BaseColor);
            }
            isPlay = false;
            tick = 0;
        }

        IEnumerator Hit()
        {
            while (tick < duration)
            {
                foreach (var mt in materials)
                {
                    tick += Time.deltaTime;

                    float t = 0;
                    if (tick < mid)
                    {
                        t = tick / mid;
                        Color color = Color.Lerp(mt.BaseColor, HitColor, t);
                        mt.material.SetColor("_HitColor", color);
                    }
                    else
                    {
                        t = (tick - mid) / mid;
                        Color color = Color.Lerp(HitColor, mt.BaseColor, t);
                        mt.material.SetColor("_HitColor", color);
                    }
                }
                yield return 0;
            }

            foreach (var mt in materials)
            {
                mt.material.SetColor("_HitColor", mt.BaseColor);
            }
            isPlay = false;
        }
    }
}
