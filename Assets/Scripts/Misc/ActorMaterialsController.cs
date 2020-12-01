using UnityEngine;
using XLua;

namespace LPCFramework
{
    [LuaCallCSharp]
    public class ActorMaterialsController
    {
        /// <summary>
        /// 设置模型颜色
        /// </summary>
        /// <param name="campType">1 进攻方, 2 防守方</param>
        public static void SetActorMaterials(GameObject go, int campType)
        {
            if (!go)
                return;

            foreach (var com in go.GetComponentsInChildren<Renderer>())
            {
                foreach (var item in com.materials)
                {
                    if (campType == 1)
                        item.SetColor("_Color", new Color(28.0f / 255, 35.0f / 255, 98.0f / 255));
                    else
                        item.SetColor("_Color", new Color(88.0f / 255, 14.0f / 255, 5.0f / 255));
                }
            }
        }
    }
}