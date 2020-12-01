/*
* ==============================================================================
* 
* Created: 2017-3-3
* Author: Panda
* Company: LightPaw
* 
* ==============================================================================
*/

using System;
using System.IO;
using System.Threading;
using Rnet;
using UnityEngine;

namespace LPCFramework
{
    public class ProtoPackageLength
    {
        public const Int32 MAX_PACKAGE_LENGTH = 1024 * 1024 * 5;

        // 客户端消息的最大长度
        public const Int32 MAX_CLIENT_PACKET_LENGTH = 2048;
    }

    public enum EConnectionState
    {
        NONE = 0,

        //连接中
        CONNECTING = 1,

        //已连接
        CONNECTED = 2,

        // 必须重新走登录流程
        MUST_RELOGIN = 3,

        // 必须重新发起连接, 成功之后显示主城界面
        MUST_RECONNECT = 4,

        //客户端强制退出连接
        FROCE_CLOSED = 5,
    }

    public class Connection
    {
        //private byte[] loginToken = new byte[]
        //{
        //    97, 219, 141, 187, 52, 110, 222, 178, 181, 66, 41, 20, 228, 214, 172, 70, 60, 87, 145, 95, 92, 227, 129,
        //    222, 121, 144, 87, 18, 58, 151, 186, 27, 184, 79, 70, 203, 91, 215, 55, 78, 98, 220, 132, 86, 175, 100, 224,
        //    30, 249, 220, 165, 52, 100, 209, 2, 242, 59, 131, 194, 139, 13, 117, 177, 29
        //};

        //private byte[] key = new byte[] {100, 186, 220, 224, 99, 0, 0, 0};

        public Connection()
        {
            this.State = EConnectionState.NONE;
            this.header = new byte[3];
        }

        private byte index;

        private readonly byte[] header;

        private RnetStream _workSocket;

        private EConnectionState _state;

        public EConnectionState State
        {
            get { return _state; }
            set
            {
                _state = value;
                if (value == EConnectionState.NONE) return;
#if UNITY_EDITOR
                Debug.LogFormat("切换连接状态到: {0}", value);
#endif
                if (value == EConnectionState.FROCE_CLOSED) return;

                NetworkManager.Instance.queueMsg(new byte[] {(byte) value});
            }
        }

        public void Connect(string remoteAddress, int remotePort, byte[] loginToken, byte[] key)
        {
            if (this._workSocket != null)
            {
#if UNITY_EDITOR
                Debug.LogError("重复调用Connection.Connect");
                return;
#endif
            }

            Debug.Log("-------------------Connecting-----------------");
            this.State = EConnectionState.CONNECTING;

            var socket = new RnetStream(32768, loginToken, key);

            if (Interlocked.CompareExchange(ref _workSocket, socket, null) == null)
            {
                socket.BeginConnect(remoteAddress, remotePort, ConnectCallBack, null);
            }
        }

        public void Close()
        {
            var socket = _workSocket;

            if (socket == null)
            {
                return;
            }

            if (Interlocked.CompareExchange(ref _workSocket, null, socket) == socket)
            {
                socket.Close();
                socket = null;
                this.State = EConnectionState.FROCE_CLOSED;
                Debug.Log("Client close");
            }
        }

        private void closeOnError(Exception ex, RnetStream socket)
        {
            socket.Close();

            if (Interlocked.CompareExchange(ref _workSocket, null, socket) != socket)
            {
                return;
            }

            if (ex is MustReconnectException)
            {
                trace("必须重连: {0}", ex);
                this.State = EConnectionState.MUST_RECONNECT;
            }
            else if (ex is MustReloginException)
            {
                trace("必须重新登录: {0}", ex);
                this.State = EConnectionState.MUST_RELOGIN;
            }
            else
            {
                // 啥情况
                trace("未知错误: {0}", ex);
                this.State = EConnectionState.MUST_RELOGIN;
            }
        }

        private void ConnectCallBack(IAsyncResult result)
        {
            var socket = (result as RnetStream.AsyncResult).Socket;
            try
            {
                socket.EndConnect(result);
            }
            catch (Exception ex)
            {
                closeOnError(ex, socket);
                return;
            }

            this.State = EConnectionState.CONNECTED;
            readHeader(socket);
        }

        private void readHeader(RnetStream socket)
        {
            socket.BeginRead(header, 0, 3, HeaderCallback, null);
        }

        private void HeaderCallback(IAsyncResult result)
        {
            var socket = (result as RnetStream.AsyncResult).Socket;
            try
            {
                socket.EndRead(result);
            }
            catch (Exception ex)
            {
                closeOnError(ex, socket);
                return;
            }

            if (header[0] <= 127)
            {
                readContent(header[0], 2, socket);
            }
            else if (header[1] <= 127)
            {
                int size = ((int) (header[1]) << 7) | ((int) (header[0]) & 0x7f);
                readContent(size, 1, socket);
            }
            else
            {
                int size = ((int) (header[2]) << 14) | (((int) (header[1]) & 0x7f) << 7) | ((int) (header[0]) & 0x7f);
                readContent(size, 0, socket);
            }
        }

        private void readContent(int contentLength, int dataSize, RnetStream socket)
        {
            if (contentLength > ProtoPackageLength.MAX_PACKAGE_LENGTH)
            {
#if UNITY_EDITOR
                Debug.LogErrorFormat("消息包太大: {0}", contentLength.ToString());
#endif
                Close();
                return;
            }

            var buf = new byte[contentLength];
            switch (dataSize)
            {
                case 1:
                    buf[0] = header[2];
                    break;
                case 2:
                    buf[0] = header[1];
                    buf[1] = header[2];
                    break;
            }

            socket.BeginRead(buf, dataSize, contentLength - dataSize, RecvCallback, buf);
        }

        private void RecvCallback(IAsyncResult result)
        {
            var socket = (result as RnetStream.AsyncResult).Socket;

            if (socket != this._workSocket) return;

            try
            {
                socket.EndRead(result);
            }
            catch (Exception ex)
            {
                closeOnError(ex, socket);
                return;
            }

            var msg = result.AsyncState as byte[];

            NetworkManager.Instance.queueMsg(msg);

            readHeader(socket);
        }

        public void SendMessage(byte[] msg)
        {
            Stream socket = this._workSocket;
            if (socket == null)
            {
                return;
            }

            var size = msg.Length - 2;
            if (size >= ProtoPackageLength.MAX_CLIENT_PACKET_LENGTH)
            {
#if UNITY_EDITOR
                Debug.LogErrorFormat("要发送的消息包太大, 最大长度: {0}, 现在要发送的长度: {1}", ProtoPackageLength.MAX_CLIENT_PACKET_LENGTH,
                    size);
#endif
                Close();
                return;
            }

            msg[2] = index++;

            if (size <= 127)
            {
                msg[1] = (byte) size;

                socket.BeginWrite(msg, 1, size + 1, SendCallBack, null);
            }
            else
            {
                msg[0] = (byte) (0x80 | (size & 0x7f));
                msg[1] = (byte) (size >> 7);

                socket.BeginWrite(msg, 0, size + 2, SendCallBack, null);
            }
        }

        private void SendCallBack(IAsyncResult result)
        {
            var socket = (result as RnetStream.AsyncResult).Socket;
            try
            {
                socket.EndWrite(result);
            }
            catch (Exception ex)
            {
                closeOnError(ex, socket);
                return;
            }
        }

        private void trace(String msg, Exception ex)
        {
#if UNITY_EDITOR
            //Debug.LogErrorFormat(msg, ex);
#endif
        }
    }
}

