/*
* ==============================================================================
* 
* Created: 2017-3-3
* Author: Panda
* Company: LightPaw
* 
* ==============================================================================
*/
using UnityEngine;

namespace LPCFramework
{
    /// <summary>
    /// Animator的状态机行为
    /// </summary>
    public class AnimatorStateBehaviour : StateMachineBehaviour
    {
        // 退出状态时期望切换到的动作类型
        public int OnStateExitSetMotionType = 0;

        /// <summary>
        /// 退出状态时，引擎自动调用
        /// </summary>
        /// <param name="animator"></param>
        /// <param name="stateInfo"></param>
        /// <param name="layerIndex"></param>
        override public void OnStateExit(Animator animator, AnimatorStateInfo stateInfo, int layerIndex)
        {
            // 设置动作为你所期望的
            animator.SetInteger("MotionType", OnStateExitSetMotionType);
        }
    }
}