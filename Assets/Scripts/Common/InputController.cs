using FairyGUI;
using UnityEngine;
using XLua;

namespace LPCFramework
{
    public class InputController:MonoBehaviour
    {
        static Ray m_ray;
        static RaycastHit m_hit;

        [LuaCallCSharp]
        public static RaycastHit? HitInfo(int layerMask, bool needShift=false)
        {
            if(needShift)
                layerMask = 1 << layerMask;

            m_ray = Camera.main.ScreenPointToRay(Input.mousePosition);
            if (Physics.Raycast(m_ray, out m_hit, 100, layerMask))
                return m_hit;
            
            return null;
        }

        [LuaCallCSharp]
        public static GameObject HitObj()
        {
            m_ray = Camera.main.ScreenPointToRay(Input.mousePosition);
            if (Physics.Raycast(m_ray, out m_hit, 100))
                return m_hit.collider.gameObject;

            return null;
        }

        [LuaCallCSharp]
        public static Vector3 HitObjPoint()
        {
            m_ray = Camera.main.ScreenPointToRay(Input.mousePosition);
            if (Physics.Raycast(m_ray, out m_hit, 100))
                return m_hit.point;

            return Vector3.zero;
        }

        [LuaCallCSharp]
        public static Vector3 WorldToScreenPoint(Vector3 pos)
        {
            Vector3 v = Camera.main.WorldToViewportPoint(pos);
            v = new Vector3(v.x * GRoot.inst.width, (1 - v.y) * GRoot.inst.height);
            return v;
        }

        [LuaCallCSharp]
        public static Vector3 ScreenToWorldPoint(GameObject go)
        {
            return Camera.main.ScreenToWorldPoint(go.transform.position);
        }
    }
}