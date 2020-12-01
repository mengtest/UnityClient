/*
* ==============================================================================
* 
* Created: 2017-4-13
* Author: Jeremy
* Company: LightPaw
* 
* ==============================================================================
*/

using System;
using UnityEngine;
using System.Collections;
using System.Collections.Generic;
using System.Threading;
using System.Net;
using System.IO;
using ICSharpCode.SharpZipLib.Zip;


namespace LPCFramework
{
    public partial class DownloadMgr : Singleton<DownloadMgr>
    {
        #region public 
        public System.Action<bool> allow_redownload = null;
        public System.Action<long> unzip_length = null;
        public System.Action<string> download_progress = null;
        public System.Action<bool> update_result = null;

        #endregion

        #region private
        private ResUpdateState m_preState;
        private ResUpdateState m_curState;
        
        private bool m_allowDownloadWithoutWifi = false;                        
        private const float m_downwaitmaxtime = 15f;
        private const string m_tempSuffix = ".temp";
        private int m_nowDownloadTaskIndex = 0;

        private List<string> m_needDownloadTaskNameList = new List<string>();
        private List<ResUpdateState> downloadEvents = new List<ResUpdateState>();
        private Dictionary<ResUpdateState, IState> m_downloadstates = new Dictionary<ResUpdateState, IState>();
        private Dictionary<string, DownloadTask> m_downloadtasks = new Dictionary<string, DownloadTask>();
        private Dictionary<ResUpdateState, IState> m_states = new Dictionary<ResUpdateState, IState>();

        private bool hasInit = false;
        private float m_downloadtimeouttick = 0f;
        
        private string m_appdatapath = "";
        #endregion

        /// <summary>
        /// 模拟慢速网络
        /// </summary>
        public bool simulation = false;

        public void Init()
        {
            System.Net.ServicePointManager.DefaultConnectionLimit = 512;
            m_allowDownloadWithoutWifi = false; //默认不允许wifi下载    
            m_appdatapath = Application.persistentDataPath + "/";
            InitStates();
        }

        private DownloadTask CurDownloadTask
        {
            get
            {
                if(m_nowDownloadTaskIndex <m_needDownloadTaskNameList.Count)
                {
                    string dfilename = m_needDownloadTaskNameList[m_nowDownloadTaskIndex];
                    if (m_downloadtasks.ContainsKey(dfilename) && m_downloadtasks[dfilename] != null)
                        return m_downloadtasks[m_needDownloadTaskNameList[m_nowDownloadTaskIndex]];                    
                }

                return null;
            }
        }

        void InitStates()
        {
            if (hasInit) return;
            m_curState = ResUpdateState.NotBegin;
            m_states.Add(ResUpdateState.StartDownload,new StartDownloadState());
            m_states.Add(ResUpdateState.Downloading, new DownloadingState());
            m_states.Add(ResUpdateState.DownloadSuc, new DownloadSucState());
            m_states.Add(ResUpdateState.DownloadFail, new DownloadFailState());
            m_states.Add(ResUpdateState.Releasing, new ReleasingState());
            m_states.Add(ResUpdateState.ResUpdateSuc, new ResUpdateSucState());
            m_states.Add(ResUpdateState.ResUpdateFail, new ResUpdateFailState());
            m_states.Add(ResUpdateState.NetNotConnected, new NetNotConnectedState());
            m_states.Add(ResUpdateState.ConfirmAllowDownloadWithOutWifi, new ConfirmAllowDownloadWithOutWifIState());

            hasInit = true;

        }

        void ChangeState(ResUpdateState state , params object[] args)
        {
            m_preState = m_curState;
            if (m_curState != state)
            {
                m_curState = state;

                if (m_states.ContainsKey(m_preState))
                    m_states[m_preState].Exit(args);
                m_states[m_curState].Enter(args);
            }
        }
        
        public bool CreateDownloadTask(string downloadURL, string downloadPath, string fileName, string fileSuffix,
            long fileWholeLength, bool allowUseCarrierData)
        {
            if (m_downloadtasks.ContainsKey(fileName))
            {
                return false;
            }

            DownloadTask dlt = new DownloadTask(downloadURL, downloadPath, fileName, fileSuffix, fileWholeLength);
            m_downloadtasks.Add(fileName, dlt);
            m_needDownloadTaskNameList.Add(fileName);
            m_allowDownloadWithoutWifi = allowUseCarrierData;
            return true;
        }

        public void BeginDownload()
        {
            ChangeState(ResUpdateState.StartDownload);
        }

        public long GetCurDownloadSize()
        {
            long totalSize = 0;
            for (int i = 0; i < m_needDownloadTaskNameList.Count; i++)
            {
                totalSize +=
                    m_downloadtasks[m_needDownloadTaskNameList[i]]
                        .FileWholeLength;
            }
            return totalSize;
        }


        public void FixedUpdate()
        {            
            if (m_states.ContainsKey(m_curState))
                m_states[m_curState].Process();    
            
            foreach(var sevent in downloadEvents)
            {
                ChangeState(sevent);
            }
            downloadEvents.Clear();
        }

        public void ClearAllTask()
        {
            m_nowDownloadTaskIndex = 0;
            foreach (var task in m_downloadtasks)
            {
                task.Value.ClearRequest();
            }
            m_downloadtasks.Clear();
            m_needDownloadTaskNameList.Clear();
            m_states.Clear();
        }

        public void PauseDownload()
        {
            if (m_nowDownloadTaskIndex < m_needDownloadTaskNameList.Count)
            {
                m_downloadtasks[m_needDownloadTaskNameList[m_nowDownloadTaskIndex]].ClearRequest();                
            }
        }

        public void PauseCurDownload()
        {
            if (m_nowDownloadTaskIndex < m_needDownloadTaskNameList.Count)
            {
                m_downloadtasks[m_needDownloadTaskNameList[m_nowDownloadTaskIndex]].ClearRequest();
            }
        }

        public void ReStartDownload()
        {
            if (m_nowDownloadTaskIndex < m_needDownloadTaskNameList.Count)
            {
                BeginDownload();
            }
        }

        public int totalTask
        {
            get { return m_needDownloadTaskNameList.Count; }
        }

        public bool IsDownloading()
        {
            return m_nowDownloadTaskIndex < m_needDownloadTaskNameList.Count;
        }

        void OnDestroy()
        {
            ClearAllTask();
        }

        internal class DownloadTask
        {
            public DownloadTask(string downloadURL, string downloadFolder, string fileName, string fileSuffix,
                long fileWholeLength)
            {
                _downloadURL = downloadURL;
                _downloadFolder = downloadFolder;
                _fileName = fileName;
                _fileSuffix = fileSuffix;
                _fileWholeLength = fileWholeLength;
            }

            private string _downloadURL;
            private string _downloadFolder;
            private string _fileName;
            private string _fileLongName;
            private string _fileSuffix;
            private Thread _downloadThread;
            private long _fileWholeLength;
            private long _fileDownloadLength;
            private string _downSpeed;
            HttpWebRequest httpRequest;
            public long FileWholeLength
            {
                get { return _fileWholeLength; }
            }

            public long FileDownloadLength
            {
                get { return _fileDownloadLength; }
            }
          
            public string FileName
            {
                get { return _fileName; }
            }

            public string FileSuffix
            {
                get { return _fileSuffix; }
            }

            public void Start()
            {
                if (!Directory.Exists(_downloadFolder))
                {
                    Directory.CreateDirectory(_downloadFolder);
                }

                _fileLongName = _downloadFolder + "/" + _fileName + DownloadMgr.m_tempSuffix;                
                _downloadThread = new Thread(new ThreadStart(DoDownloadFile));
                _downloadThread.Start();
            }

            public float Progess
            {
                get { return _fileDownloadLength * 1.0f / _fileWholeLength; }
            }

            public string DownSpeed
            {
                get { return _downSpeed; }
            }

            private void DoDownloadFile()
            {
                FileStream fs;
                if (File.Exists(_fileLongName))
                {
                    fs = File.OpenWrite(_fileLongName);
                    _fileDownloadLength = fs.Length;
                    if(_fileDownloadLength == FileWholeLength)
                    {                        
                        fs.Close();
                        DownLoadZipSuc();
                        return;
                    }
                    fs.Seek(_fileDownloadLength, SeekOrigin.Current);
                    
                }
                else
                {
                    fs = new FileStream(_fileLongName, FileMode.Create);
                    _fileDownloadLength = 0;
                }


                string downloadUrl = UpdateMgr.Instance.GetNowUseUri() + _downloadURL;
                Debug.LogFormat("<color=#33FFFF>[{0}] 请求下载，服务器地址:{1}, 已下载:{2}</color>", DateTime.Now, downloadUrl, _fileDownloadLength);

                httpRequest = (HttpWebRequest)HttpWebRequest.Create(downloadUrl);
                
                try
                {
                    if (_fileDownloadLength > 0)
                    {
                        httpRequest.AddRange((int)_fileDownloadLength);
                    }
                

                    HttpWebResponse responese = (HttpWebResponse)httpRequest.GetResponse();
                
                    Stream responseio = responese.GetResponseStream();

                    
                    Debug.LogFormat("<color=#33FFFF>[{0}] 开始下载，服务器地址:{1}, 已下载:{2}</color>", DateTime.Now, downloadUrl, _fileDownloadLength);                
                    if (DownloadMgr.Instance.simulation)
                    {
                        Thread.Sleep(2000);
                    }                
                    byte[] nbytes = new byte[4096];
                    int nReadSize = 0;
                    

                    DateTime begin = DateTime.Now;
                    TimeSpan ts = new TimeSpan();
                    long readcount = 0;
                    nReadSize = responseio.Read(nbytes, 0, 4096);                    

                    while (nReadSize > 0)
                    {
                        DownloadMgr.Instance.m_downloadtimeouttick = 0f;
                        if (DownloadMgr.Instance.simulation)
                        {
                            Thread.Sleep(2000);
                        }

                        fs.Write(nbytes, 0, nReadSize);
                        _fileDownloadLength += nReadSize;
                        readcount += nReadSize;
                        ts = DateTime.Now - begin;
                        if (ts.TotalSeconds >= 1.0f)
                        {
                            begin = DateTime.Now;
                            _downSpeed = formatdownspeed(readcount);
                            string downloadinfo = string.Format("已下载:{0} ,下载速度为：{1}", _fileDownloadLength, _downSpeed);
                            Debug.LogFormat("<color=#33FFFF>[{0}] 正在下载，服务器地址:{1},{2}  </color>", DateTime.Now, downloadUrl, downloadinfo);
                            if (DownloadMgr.Instance.download_progress != null) DownloadMgr.Instance.download_progress(downloadinfo);

                           readcount = 0;

                        }

                        nReadSize = responseio.Read(nbytes, 0, 4096);
                    }
                    
                    responese.Close();
                    responseio.Close();
                    fs.Close();
                    Debug.LogFormat("<color=#33FFFF>[{0}] 下载结束，服务器地址:{1}, 已下载:{2}</color>", DateTime.Now, downloadUrl, _fileDownloadLength);

                    if (_fileDownloadLength != _fileWholeLength)
                    {
                        DownloadMgr.Instance.m_downloadtimeouttick = Mathf.Max(0f, DownloadMgr.m_downwaitmaxtime - 5f);
                        Debug.LogWarning("文件长度不一致，更新失败");
                        if (File.Exists(_fileLongName))
                            File.Delete(_fileLongName);
                                                                                     
                        lock(DownloadMgr.Instance.downloadEvents)
                        {
                            DownloadMgr.Instance.downloadEvents.Add(ResUpdateState.DownloadFail);
                        }

                        return;
                    }
                    DownLoadZipSuc();
                }
                catch (System.Exception e)
                {
                    httpRequest = null;
                    fs.Close();
                    ClearRequest();
                    lock (DownloadMgr.Instance.downloadEvents)
                    {
                        DownloadMgr.Instance.downloadEvents.Add(ResUpdateState.DownloadFail);
                    }                    
                    Debug.LogError(e.Message);
                }
            }

            void DownLoadZipSuc()
            {
                string changeName = _downloadFolder + "/" + _fileName + _fileSuffix;

                if (File.Exists(_fileLongName))
                {
                    try
                    {
                        if (File.Exists(changeName)) File.Delete(changeName);
                        File.Move(_fileLongName, changeName);
                    }
                    catch (System.Exception e)
                    {
                        Debug.Log(e.ToString());
                        throw;
                    }
                }                
                lock (DownloadMgr.Instance.downloadEvents)
                {
                    DownloadMgr.Instance.downloadEvents.Add(ResUpdateState.DownloadSuc);
                }
            }

            string formatdownspeed(long datalength)
            {
                long g = datalength / (1024 * 1024 * 1024);
                if (g > 0) return string.Format("{0}G/s", g);    //每秒下1G，天朝没戏

                long m = datalength / (1024 * 1024);
                if (m > 0) return string.Format("{0}M/s", m);

                long k = datalength / 1024;
                if (k > 0) return string.Format("{0}K/s", k);

                return string.Format("{0}B/s", datalength);
            }

            public void ClearRequest()
            {
                if (httpRequest != null)
                    httpRequest.Abort();
                httpRequest = null;

                if (_downloadThread != null)                    
                    _downloadThread = null;
            }
        }

    }
}