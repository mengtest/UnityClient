using UnityEngine;

namespace LPCFramework
{
    public class TerrainGroundStaticItem : MonoBehaviour
    {
        public bool m_bCannotHide = false;
        public bool m_bHideByCityOrResources = false;
        public Vector3 m_vLocalScale;

        public void PutToGround(TerrainGroundCoordinate coord, bool bZUp = false)
        {
            Vector2 vUv = coord.PosToUV(transform.position);
            Debug.Log("put " + gameObject.name + " to UV:" + vUv);
            vUv.x = Mathf.Clamp01(vUv.x);
            vUv.y = Mathf.Clamp01(vUv.y);
            Vector3 vPos, vNor;
            coord.GetPosNormal(vUv, 0.0f, out vPos, out vNor);

            Vector3 vForward = Vector3.Cross(vNor, -transform.right);
            transform.position = vPos;
            if (bZUp)
            {
                transform.LookAt(vPos + vNor, vForward);
            }
            else
            {
                transform.LookAt(vPos + vForward, vNor);
            }
        }

        void Start()
        {
            //TODO 在运行前，编辑器模式下，就可以预先计算好自己的UV，节省启动时间.
            TerrainGroundCoordinate.m_Intantance.AddStaticItem(this);
            m_vLocalScale = gameObject.transform.localScale;
        }
        /// <summary>
        /// 设置材质为透明，为地图编辑器而生
        /// 运行时生效，退出后材质自动变回原来的样子
        /// </summary>
        public void SetTransparentMaterial()
        {
            MeshRenderer[] renderers = gameObject.GetComponentsInChildren<MeshRenderer>();
            if (renderers != null)
            {
                for (int i = 0; i < renderers.Length; ++i)
                {
                    Material[] materials = renderers[i].materials;
                    if (materials != null)
                    {
                        for (int j = 0; j < materials.Length; ++j)
                        {
                            materials[j].shader = Shader.Find("Particles/Additive");
                        }
                    }
                }
            }
        }
    }
}
