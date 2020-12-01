/*
* ==============================================================================
* 
* Created: 2017-3-3
* Author: Panda
* Company: LightPaw
* 
* ==============================================================================
*/
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

namespace LPCFramework
{
    /// <summary>
    /// 管理器接口
    /// </summary>
    public interface IManager
    {
        void OnInitialize();
        void OnUpdateLogic();
        void OnDestruct();
    }
}