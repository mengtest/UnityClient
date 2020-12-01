using System;

namespace LPCFramework
{
    public interface IState
    { 
        // 进入该状态
        void Enter(params object [] args);

        // 离开状态
        void Exit(params object[] args);

        // 状态处理
        void Process(params object[] args);        
    }
}
