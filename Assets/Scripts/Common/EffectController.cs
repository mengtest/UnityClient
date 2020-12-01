using UnityEngine;
using System.Collections.Generic;
using XLua;

/// <summary>
/// effect管理
/// </summary>
namespace LPCFramework
{
    public class EffectInfo
    {
        // 特效
        public ParticleSystem MyParticle { get; private set; }
        // 动画
        public Animation MyAnimation { get; private set; }
        // 动画
        public Animator MyAnimator { get; private set; }

        public EffectInfo(Transform m)
        {
            MyParticle = m.GetComponent<ParticleSystem>();
            MyAnimation = m.GetComponent<Animation>();
            MyAnimator = m.GetComponent<Animator>();
        }
        public void SetPlaySpeed(float speed)
        {
            if(null != MyParticle)
            {
                var main = MyParticle.main;
                main.simulationSpeed = speed;
            }
            if(null != MyAnimation)
            {
                foreach(AnimationState state in MyAnimation)
                {
                    state.speed = speed;
                }
            }
            if (null != MyAnimator)
            {
                MyAnimator.speed = speed;
            }

        }
    }
    public class EffectController : MonoBehaviour
    {
        private List<EffectInfo> m_effectChild = new List<EffectInfo>();

        private GameObject m_selfObj;

        public float m_speed = 1;

        void Awake()
        {
            m_selfObj = gameObject;
            GetEffectInitInfo();
        }
        /// <summary>
        /// 設置播放速率
        /// </summary>
        /// <returns></returns>
        [LuaCallCSharp]
        public void SetPlaySpeed(float speed)
        {
            m_speed = speed;
            foreach (EffectInfo m in m_effectChild)
            {
                m.SetPlaySpeed(speed);
            }
        }
        /// <summary>
        /// 获取初始化信息
        /// </summary>
        private void GetEffectInitInfo()
        {
            Transform[] child = m_selfObj.GetComponentsInChildren<Transform>();
            foreach (Transform m in child)
            {
                EffectInfo info = new EffectInfo(m);

                m_effectChild.Add(info);
            }
        }
    }
}