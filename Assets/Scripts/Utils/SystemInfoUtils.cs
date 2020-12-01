using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using XLua;

namespace LPCFramework
{
    public class SystemInfoUtils : Singleton<SystemInfoUtils>
    {
        private string m_systemInfo = string.Empty;

        [LuaCallCSharp]
        public string Info
        {
            get
            {
#if !UNITY_EDITOR
                if(string.Empty == m_systemInfo)
                {
                    RecordSystemInfo();
                }
#endif

                return m_systemInfo;
            }
        }

        /// <summary>
        /// 检测系统信息
        /// </summary>
        public void RecordSystemInfo()
        {
#if !UNITY_EDITOR
            m_systemInfo = string.Empty;
            m_systemInfo += string.Format("#batteryLevel#: {0}\t", SystemInfo.batteryLevel);
            m_systemInfo += string.Format("#batteryStatus#: {0}\t", SystemInfo.batteryStatus);
            m_systemInfo += string.Format("#copyTextureSupport#: {0}\t", SystemInfo.copyTextureSupport);
            m_systemInfo += string.Format("#deviceModel#: {0}\t", SystemInfo.deviceModel);
            m_systemInfo += string.Format("#deviceName#: {0}\t", SystemInfo.deviceName);
            m_systemInfo += string.Format("#deviceType#: {0}\t", SystemInfo.deviceType);
            m_systemInfo += string.Format("#deviceUniqueIdentifier#: {0}\t", SystemInfo.deviceUniqueIdentifier);
            m_systemInfo += string.Format("#graphicsDeviceID#: {0}\t", SystemInfo.graphicsDeviceID);
            m_systemInfo += string.Format("#graphicsDeviceName#: {0}\t", SystemInfo.graphicsDeviceName);
            m_systemInfo += string.Format("#graphicsDeviceType#: {0}\t", SystemInfo.graphicsDeviceType);
            m_systemInfo += string.Format("#graphicsDeviceVendor#: {0}\t", SystemInfo.graphicsDeviceVendor);
            m_systemInfo += string.Format("#graphicsDeviceVendorID#: {0}\t", SystemInfo.graphicsDeviceVendorID);
            m_systemInfo += string.Format("#graphicsDeviceVersion#: {0}\t", SystemInfo.graphicsDeviceVersion);
            m_systemInfo += string.Format("#graphicsMemorySize#: {0}\t", SystemInfo.graphicsMemorySize);
            m_systemInfo += string.Format("#graphicsMultiThreaded#: {0}\t", SystemInfo.graphicsMultiThreaded);
            m_systemInfo += string.Format("#graphicsShaderLevel#: {0}\t", SystemInfo.graphicsShaderLevel);
            m_systemInfo += string.Format("#graphicsUVStartsAtTop#: {0}\t", SystemInfo.graphicsUVStartsAtTop);
            m_systemInfo += string.Format("#maxCubemapSize#: {0}\t", SystemInfo.maxCubemapSize);
            m_systemInfo += string.Format("#maxTextureSize#: {0}\t", SystemInfo.maxTextureSize);
            m_systemInfo += string.Format("#npotSupport#: {0}\t", SystemInfo.npotSupport);
            m_systemInfo += string.Format("#operatingSystem#: {0}\t", SystemInfo.operatingSystem);
            m_systemInfo += string.Format("#operatingSystemFamily#: {0}\t", SystemInfo.operatingSystemFamily);
            m_systemInfo += string.Format("#processorCount#: {0}\t", SystemInfo.processorCount);
            m_systemInfo += string.Format("#processorFrequency#: {0}\t", SystemInfo.processorFrequency);
            m_systemInfo += string.Format("#processorType#: {0}\t", SystemInfo.processorType);
            m_systemInfo += string.Format("#supportedRenderTargetCount#: {0}\t", SystemInfo.supportedRenderTargetCount);
            m_systemInfo += string.Format("#supports2DArrayTextures#: {0}\t", SystemInfo.supports2DArrayTextures);
            m_systemInfo += string.Format("#supports3DRenderTextures#: {0}\t", SystemInfo.supports3DRenderTextures);
            m_systemInfo += string.Format("#supports3DTextures#: {0}\t", SystemInfo.supports3DTextures);
            m_systemInfo += string.Format("#supportsAccelerometer#: {0}\t", SystemInfo.supportsAccelerometer);
            m_systemInfo += string.Format("#supportsAudio#: {0}\t", SystemInfo.supportsAudio);
            m_systemInfo += string.Format("#supportsComputeShaders#: {0}\t", SystemInfo.supportsComputeShaders);
            m_systemInfo += string.Format("#supportsCubemapArrayTextures#: {0}\t", SystemInfo.supportsCubemapArrayTextures);
            m_systemInfo += string.Format("#supportsGyroscope#: {0}\t", SystemInfo.supportsGyroscope);
            m_systemInfo += string.Format("#supportsImageEffects#: {0}\t", SystemInfo.supportsImageEffects);
            m_systemInfo += string.Format("#supportsInstancing#: {0}\t", SystemInfo.supportsInstancing);
            m_systemInfo += string.Format("#supportsLocationService#: {0}\t", SystemInfo.supportsLocationService);
            m_systemInfo += string.Format("#supportsMotionVectors#: {0}\t", SystemInfo.supportsMotionVectors);
            m_systemInfo += string.Format("#supportsRawShadowDepthSampling#: {0}\t", SystemInfo.supportsRawShadowDepthSampling);
            m_systemInfo += string.Format("#supportsRenderToCubemap#: {0}\t", SystemInfo.supportsRenderToCubemap);
            m_systemInfo += string.Format("#supportsShadows#: {0}\t", SystemInfo.supportsShadows);
            m_systemInfo += string.Format("#supportsSparseTextures#: {0}\t", SystemInfo.supportsSparseTextures);
            m_systemInfo += string.Format("#supportsVibration#: {0}\t", SystemInfo.supportsVibration);
            m_systemInfo += string.Format("#systemMemorySize#: {0}\t", SystemInfo.systemMemorySize);
            m_systemInfo += string.Format("#unsupportedIdentifier#: {0}\t", SystemInfo.unsupportedIdentifier);
            m_systemInfo += string.Format("#usesReversedZBuffer#: {0}\t", SystemInfo.usesReversedZBuffer);

            Debug.Log(m_systemInfo);
#endif
        }
    }
}