using UnityEngine;
using System.Collections;
using System.Collections.Generic;
using XLua;

/// <summary>
/// 玩家身上的槽位信息
/// </summary>
namespace LPCFramework
{
    public class ActorBodySlots: MonoBehaviour
    {
        public List<Transform> SlotInfoList = new List<Transform>();

        // 槽位名称
        protected string[] m_slotNameArray = new string[] { "slot_base", "slot_center", "slot_head", "slot_lefthand", "slot_righthand", "slot_weapon1", "slot_weapon2" };

        protected Transform m_transSelf = null;

        /****************************************************************************************/

        void Awake()
        {
            m_transSelf = transform;

            if (SlotInfoList == null || SlotInfoList.Count <= 0)
                PreInitialize();
        }

        /// <summary>
        /// 预先初始化
        /// </summary>
        public virtual void PreInitialize()
        {
            SearchSlots();
        }

        /// <summary>
        /// 根据槽位类型获取槽位Transform
        /// </summary>
        /// <param name="slotType"></param>
        /// <returns></returns>
        [LuaCallCSharp]
        public Transform GetTransformBySlotType(int slotType)
        {
            if (slotType < 0 || SlotInfoList == null)
                return null;

            if (slotType < SlotInfoList.Count)
            {
                return SlotInfoList[slotType];
            }

            return null;
        }
        /// <summary>
        /// 将物体加入某个槽位下
        /// </summary>
        /// <param name="slotType"></param>
        /// <param name="target"></param>
        [LuaCallCSharp]
        public void AddGameObjectToSlot(int slotType, GameObject target)
        {
            if (slotType < 1 || target == null || SlotInfoList == null)
                return;

            if (slotType < SlotInfoList.Count && SlotInfoList[slotType] != null)
            {
                target.transform.parent = SlotInfoList[slotType];
                target.transform.localPosition = Vector3.zero;
                target.transform.localRotation = Quaternion.identity;
            }
        }

        /****************************************************************************************/
        

        /// <summary>
        /// 查找槽位
        /// </summary>
        private void SearchSlots()
        {
            SlotInfoList.Clear();
            
            Transform[] transSlotArray = null;
            m_transSelf.GetTransformArrayRecursively(m_slotNameArray, ref transSlotArray);

            SlotInfoList.AddRange(transSlotArray);
        }
    }
}
