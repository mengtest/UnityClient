using UnityEngine;

namespace LPCFramework
{
    /// <summary>
    /// Animator的状态机行为
    /// </summary>
    public class AnimatorStateBehaviour_onEnter : StateMachineBehaviour
    {
        // 进入状态后期望切换到的动作类型
        public int OnStateEnterSetMotionType = -99;

        public override void OnStateEnter(Animator animator, AnimatorStateInfo stateInfo, int layerIndex)
        {
            animator.SetInteger("MotionType", OnStateEnterSetMotionType);
        }
    }
}