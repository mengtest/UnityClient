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
using XLua;
using System;
using System.Globalization;

namespace LPCFramework
{
    /// <summary>
    /// 网络消息管理器
    /// 负责与服务器之间的socket通信
    /// </summary>
    public class NetworkManager : IManager
    {
        public static NetworkManager Instance = new NetworkManager();

        /// <summary>
        /// 网络句柄
        /// </summary>
        private Connection m_client;
        private DisruptorUnity3d.RingBuffer<byte[]> queue = new DisruptorUnity3d.RingBuffer<byte[]>(64);

        /// <summary>
        /// 初始化
        /// </summary>
        public void OnInitialize()
        {
            m_client = new Connection();
        }
        /// 更新逻辑
        /// </summary>
        public void OnUpdateLogic()
        {
            //http
            HttpHelper.HttpInvoke();

            byte[] func;
            for (;;)
            {
                bool success = queue.TryDequeue(out func);
                if (!success)
                {
                    return;
                }
                try
                {
                    CSharpCallLuaDelegates.Instance.LuaNetworkEntry.onReceiveMsg(func);
                }
                catch (Exception ex)
                {
#if UNITY_EDITOR
                    UnityEngine.Debug.LogErrorFormat("处理消息出错 {0}", ex.ToString());
#endif
                }
            }
        }

        public void queueMsg(byte[] func)
        {
            queue.Enqueue(func);
        }
        /// <summary>
        /// 析构
        /// </summary>
        public void OnDestruct()
        {
            OnDisconnect();
            m_client = null;
            Debug.Log("~NetworkManager was destroyed!");
        }   
        /// <summary>
        /// 请求认证登陆
        /// </summary>
        /// <param name="remoteAddress">IP</param>
        /// <param name="remotePort">Port</param>
        /// <param name="token">token</param>
        /// <param name="key">key</param>
        [LuaCallCSharp]
        public void Connect(string remoteAddress, int remotePort, string token, string key)
        {
            //转byte[]
            byte[] bToken = ConvertHexStringToByteArray(token);  
            byte[] bKey = ConvertHexStringToByteArray(key);

            if(m_client != null)
                m_client.Connect(remoteAddress, remotePort, bToken, bKey);
        }

        /// <summary>
        /// 发送消息
        /// </summary>
        /// <param name="msg"></param>
        [LuaCallCSharp]
        public void SendMessage(byte[] msg)
        {
            if (m_client != null)
                m_client.SendMessage(msg);
        }
        /// <summary>
        /// 请求断线
        /// </summary>
        [LuaCallCSharp]
        public void OnDisconnect()
        {
            if (m_client != null)
                m_client.Close();
        }
        /// <summary>
        /// 转byte[]
        /// </summary>
        /// <param name="hexString"></param>
        /// <returns></returns>
        private byte[] ConvertHexStringToByteArray(string hexString)
        {
            if (hexString.Length % 2 != 0)
            {
                throw new ArgumentException(String.Format(CultureInfo.InvariantCulture, "The binary key cannot have an odd number of digits: {0}", hexString));
            }

            byte[] HexAsBytes = new byte[hexString.Length / 2];
            for (int index = 0; index < HexAsBytes.Length; index++)
            {
                string byteValue = hexString.Substring(index * 2, 2);
                HexAsBytes[index] = byte.Parse(byteValue, NumberStyles.HexNumber, CultureInfo.InvariantCulture);
            }

            return HexAsBytes;
        }
    }
}