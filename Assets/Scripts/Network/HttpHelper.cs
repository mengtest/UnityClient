using System.Net;
using System.Text;
using System.IO;
using System;
using System.Security.Cryptography;
using System.Security.Cryptography.X509Certificates;
using System.Net.Security;
using System.Threading;
using System.Collections.Generic;
using XLua;

namespace LPCFramework
{
    public class HttpHelper
    {
        //http方法
        private static List<Action> httpActions = new List<Action>();

        // 调用
        public static void HttpInvoke()
        {
            if (httpActions.Count > 0)
            {
                Action action = httpActions[0];
                if (null != action)
                {
                    action();
                }
                // 移除回调
                httpActions.RemoveAt(0);
                action = null;
            }
        }

        /// <summary>
        /// sha1安全签名
        /// </summary>
        /// <returns></returns>
        [LuaCallCSharp]
        public static string GetSha1(string value)
        {
            SHA1 sha = new SHA1CryptoServiceProvider();
            ASCIIEncoding enc = new ASCIIEncoding();

            byte[] dataToHash = enc.GetBytes(value);
            byte[] dataHashed = sha.ComputeHash(dataToHash);

            return BitConverter.ToString(dataHashed).Replace("-", "");
        }
        /// <summary>  
        /// 创建GET方式的HTTP请求  
        /// </summary>  
        [LuaCallCSharp]
        public static void CreateGetHttpResponse(string url, Action<byte[]> callBackSucceed, Action<string> callBackError)
        {
            // 开启线程
            Thread thread = new Thread(delegate ()
            {
                // 凭证
                ServicePointManager.ServerCertificateValidationCallback = RemoteCertificateValidationCallback;

                HttpWebRequest request = WebRequest.Create(url) as HttpWebRequest;
                request.Method = "GET";
                request.Timeout = 10000;

                ReadBytesFromResponse(request, callBackSucceed, callBackError);
            });
            thread.IsBackground = true;
            thread.Start();
        }
        /// <summary>  
        /// 创建POST方式的HTTP请求  
        /// </summary>  
        [LuaCallCSharp]
        public static void CreatePostHttpResponse(string url, string parameters, Action<byte[]> callBackSucceed, Action<string> callBackError)
        {
            // 开启线程
            Thread thread = new Thread(delegate ()
            {
                // 凭证
                ServicePointManager.ServerCertificateValidationCallback = RemoteCertificateValidationCallback;

                HttpWebRequest request = WebRequest.Create(url) as HttpWebRequest;
                byte[] data = Encoding.ASCII.GetBytes(parameters);
                request.Method = "POST";
                request.Timeout = 10000;
                request.ContentType = "application/x-www-form-urlencoded";
                request.ContentLength = data.Length;

                try
                {
                    //发送POST数据  
                    using (Stream stream = request.GetRequestStream())
                    {
                        stream.Write(data, 0, data.Length);
                    }
                    ReadBytesFromResponse(request, callBackSucceed, callBackError);
                }
                catch (Exception e)
                {
                    if (null == callBackError)
                    {
                        return;
                    }
                    httpActions.Add(() =>
                    {
                        callBackError(e.Message);
                        callBackError = null;
                    });
                    return;
                }
            });
            thread.IsBackground = true;
            thread.Start();
        }
        /// <summary>
        /// 获取请求的数据
        /// </summary>
        public static string GetResponseString(HttpWebResponse webresponse)
        {
            using (Stream s = webresponse.GetResponseStream())
            {
                StreamReader reader = new StreamReader(s, Encoding.UTF8);
                return reader.ReadToEnd();
            }
        }
        /// <summary>
        /// 获取请求的数据
        /// </summary>
        public static void ReadBytesFromResponse(HttpWebRequest request, Action<byte[]> callBackSucceed, Action<string> callBackError)
        {
            WebResponse response = null;
            Stream respStream = null;
            byte[] buffer = null;
            try
            {
                response = request.GetResponse();
                int bufferLength = (int)response.ContentLength;
                if (bufferLength <= 0)
                {
                    callBackSucceed = null;
                    httpActions.Add(() =>
                    {
                        callBackError("Not receiving any content!");
                    });
                    return;
                }

                long totalSize = bufferLength;
                buffer = new byte[totalSize];

                respStream = null;
                long readPointer = 0;
                int offset = 0;
                int receivedBytesCount = 0;
                respStream = response.GetResponseStream();
                do
                {
                    //写入
                    receivedBytesCount = respStream.Read(buffer, offset, bufferLength - offset);
                    offset += receivedBytesCount;
                    if (receivedBytesCount > 0)
                    {
                        readPointer += receivedBytesCount;
                    }
                }
                while (receivedBytesCount != 0);

                // 更新过程中网络断开，不会抛出异常，需要手动抛出异常
                if (readPointer != totalSize)
                {
                    callBackSucceed = null;
                    httpActions.Add(() =>
                    {
                        callBackError("Receive Unfinished!");
                    });
                    return;
                }
            }
            catch (Exception e)
            {
                callBackSucceed = null;
                httpActions.Add(() =>
                {
                    callBackError(e.Message);
                });
            }
            finally
            {
                if (respStream != null)
                {
                    respStream.Flush();
                    respStream.Close();
                    respStream = null;
                }
            }
            //回调
            if (null == callBackSucceed)
            {
                return;
            }
            httpActions.Add(() =>
            {
                callBackSucceed(buffer);
            });
        }
        /// <summary>
        /// 凭证确认
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="certificate"></param>
        /// <param name="chain"></param>
        /// <param name="sslPolicyErrors"></param>
        /// <returns></returns>
        public static bool RemoteCertificateValidationCallback(System.Object sender, X509Certificate certificate, X509Chain chain, SslPolicyErrors sslPolicyErrors)
        {
            bool isOk = true;
            // If there are errors in the certificate chain,
            // look at each error to determine the cause.
            if (sslPolicyErrors != SslPolicyErrors.None)
            {
                for (int i = 0; i < chain.ChainStatus.Length; i++)
                {
                    if (chain.ChainStatus[i].Status == X509ChainStatusFlags.RevocationStatusUnknown)
                    {
                        continue;
                    }
                    chain.ChainPolicy.RevocationFlag = X509RevocationFlag.EntireChain;
                    chain.ChainPolicy.RevocationMode = X509RevocationMode.Online;
                    chain.ChainPolicy.UrlRetrievalTimeout = new TimeSpan(0, 1, 0);
                    chain.ChainPolicy.VerificationFlags = X509VerificationFlags.AllFlags;
                    bool chainIsValid = chain.Build((X509Certificate2)certificate);
                    if (!chainIsValid)
                    {
                        isOk = false;
                        break;
                    }
                }
            }
            return isOk;
        }


        //#region Http请求
        ///// <summary>
        ///// httpGet
        ///// </summary>
        ///// <param name="msg"></param>
        //[LuaCallCSharp]
        //public void HttpGet(string url, Action<byte[]> succeedCallBack, Action<string> errorCallBack)
        //{
        //    StartCoroutine(Get(url, (www) => { succeedCallBack(www.bytes); }, errorCallBack));
        //}
        ///// <summary>
        ///// httpPost
        ///// </summary>
        //[LuaCallCSharp]
        //public void HttpPost(string url, string from, Action<byte[]> succeedCallBack, Action<string> errorCallBack)
        //{
        //    byte[] form = System.Text.Encoding.ASCII.GetBytes(from);
        //    StartCoroutine(Post(url, form, (www) => { succeedCallBack(www.bytes); }, errorCallBack));
        //}
        ///// <summary>
        ///// httpGet
        ///// </summary>
        ///// <param name="_url"></param>
        ///// <returns></returns>
        //private IEnumerator Get(string _url, Action<WWW> succeedCallBack = null, Action<string> errorCallBack = null)
        //{
        //    WWW getData = new WWW(_url);
        //    yield return getData;
        //    if (getData.error != null)
        //    {
        //        Debug.Log(getData.error);
        //        if (null != errorCallBack)
        //        {
        //            errorCallBack(getData.error);
        //        }
        //    }
        //    else
        //    {
        //        Debug.Log(getData.text);
        //        if (null != succeedCallBack)
        //        {
        //            succeedCallBack(getData);
        //        }
        //    }
        //}
        ///// <summary>
        ///// httpPost
        ///// </summary>
        ///// <param name="_url"></param>
        ///// <param name="_wForm"></param>
        ///// <returns></returns>
        //private IEnumerator Post(string _url, byte[] _wForm, Action<WWW> succeedCallBack = null, Action<string> errorCallBack = null)
        //{
        //    WWW postData = new WWW(_url, _wForm);
        //    yield return postData;
        //    if (postData.error != null)
        //    {
        //        Debug.Log(postData.error);
        //        if (null != errorCallBack)
        //        {
        //            errorCallBack(postData.error);
        //        }
        //    }
        //    else
        //    {
        //        Debug.Log(postData.text);
        //        if (null != succeedCallBack)
        //        {
        //            succeedCallBack(postData);
        //        }
        //    }
        //}
        //#endregion
    }
}
