using System;
using System.IO;
using System.Threading;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using ICSharpCode.SharpZipLib.Zip;

namespace LPCFramework
{
    public enum ResUpdateState
    {
        NotBegin,
        StartDownload,        
        Downloading,
        DownloadSuc,
        DownloadFail,
        Releasing,
        ResUpdateSuc,
        ResUpdateFail,
        NetNotConnected,
        ConfirmAllowDownloadWithOutWifi,
    }

    public partial class DownloadMgr
    {
        internal class StartDownloadState : DownMgrState,IState
        {
            public void Enter(params object[] args)
            {
                var curTask = m_DownloadMgr.CurDownloadTask;

                if(curTask == null)
                {
                    Debug.Log("没有下载任务，开启失败");
                    ChangeState(ResUpdateState.ResUpdateFail);
                    return;
                }

                if (File.Exists(curTask.FileName))
                {
                    Debug.Log("文件已存在，不需要下载");
                    ChangeState(ResUpdateState.DownloadSuc);
                    return;
                }

                //开始下载线程
                if (m_DownloadMgr.m_nowDownloadTaskIndex < DownloadMgr.Instance.m_needDownloadTaskNameList.Count)
                {
                    Debug.LogFormat("<color=#20F856>开始下载，总计下载数量:{0}, 当前下载:{1}</color>", m_DownloadMgr.m_needDownloadTaskNameList.Count, m_DownloadMgr.m_nowDownloadTaskIndex);                    
                    curTask.Start();
                    m_DownloadMgr.m_downloadtimeouttick = 0f;                                        
                    ChangeState(ResUpdateState.Downloading);
                }
                else
                {
                    Debug.Log("<color=#20F856>ZIP包已经全部解压完毕</color>");                    
                    ChangeState(ResUpdateState.ResUpdateSuc);
                }
            }
            public void Exit(params object[] args)
            {

            }
            public void Process(params object[] args)
            {

            }
        }

        internal class DownloadingState : DownMgrState, IState
        {
            public void Enter(params object[] args)
            {

            }
            public void Exit(params object[] args)
            {

            }
            public void Process(params object[] args)
            {
                if (Application.internetReachability != NetworkReachability.NotReachable)
                {
                    //开启下载之前玩家已经选择是否允许非wifi下下载，如果玩家选择了不允许,那么之前检测是为wifi，这里相当于断网了。
                    if (!m_DownloadMgr.m_allowDownloadWithoutWifi && Application.internetReachability == NetworkReachability.ReachableViaCarrierDataNetwork)
                    {
                        ChangeState(ResUpdateState.ConfirmAllowDownloadWithOutWifi);
                    }
                    else
                    {
                        //可以下载
                        if (m_DownloadMgr.m_preState == ResUpdateState.NetNotConnected)//断线后回来
                        {
                            Thread.Sleep(1000);
                            // 直接继续下载
                            m_DownloadMgr.ReStartDownload();
                        }
                        else
                        {
                            m_DownloadMgr.m_downloadtimeouttick += Time.fixedDeltaTime;
                            if (m_DownloadMgr.m_downloadtimeouttick >= m_downwaitmaxtime)
                            {
                                Debug.Log("<color=#ff0000>下载超时！！！</color>");
                                m_DownloadMgr.PauseDownload();
                                if (UpdateMgr.Instance.ChangeDownloadUri())
                                {
                                    m_DownloadMgr.ReStartDownload();
                                }
                                else
                                {
                                    Debug.Log("<color=#ff0000>无法重新下载</color>");
                                    ChangeState(ResUpdateState.DownloadFail);
                                }
                            }
                        }

                    }
                }
                else
                {
                    ChangeState(ResUpdateState.NetNotConnected);
                }
            }
        }


        internal class DownloadSucState : DownMgrState, IState
        {
            public void Enter(params object[] args)
            {
                //var curTask = DownloadMgr.Instance.m_downloadtasks[DownloadMgr.Instance.m_needDownloadTaskNameList[DownloadMgr.Instance.m_nowDownloadTaskIndex]];
                //DownloadMgr.Instance.OnResDownloadOK(curTask.FileName, curTask.FileSuffix);                
                ChangeState(ResUpdateState.Releasing);
            }
            public void Exit(params object[] args)
            {

            }
            public void Process(params object[] args)
            {

            }
        }

        internal class DownloadFailState : DownMgrState, IState
        {
            public void Enter(params object[] args)
            {
                ChangeState(ResUpdateState.ResUpdateFail);
            }
            public void Exit(params object[] args)
            {

            }
            public void Process(params object[] args)
            {

            }
        }

        internal class ReleasingState : DownMgrState, IState
        {
            private long m_zipfilesize = 0;
            private long m_unzipTotal = 0;            
            private string m_zipName;                        
            private int m_syncsize = 2 * 1024 * 1024;
            private int m_tempsize = 0;       
            private string m_tempFolder;

            public void Enter(params object[] args)
            {
                var curTask = m_DownloadMgr.CurDownloadTask;

                if (curTask == null)
                {
                    Debug.LogError("没有下载任务，开启失败");
                    ChangeState(ResUpdateState.ResUpdateFail);
                    return;
                }

                m_tempFolder = m_DownloadMgr.m_appdatapath + "Temp/";
                m_zipName = m_DownloadMgr.m_appdatapath + curTask.FileName + curTask.FileSuffix;                            

                if(!m_zipName.EndsWith (".zip"))
                {
                    Debug.LogError("目前只支持下载zip文件,解压失败");
                    ChangeState(ResUpdateState.ResUpdateFail);
                    return;
                }
                                                
                UpdateMgr.Instance.StartCoroutine(DoReleasingFile());                           
            }

            private IEnumerator DoReleasingFile()
            {
                yield return 0;
                ZipInputStream _zipInputStream;

                if (!Directory.Exists(m_DownloadMgr.m_appdatapath))                
                    Directory.CreateDirectory(m_DownloadMgr.m_appdatapath);                

                if (Directory.Exists(m_tempFolder))
                    Directory.Delete(m_tempFolder,true);

                FileStream fs = File.OpenRead(m_zipName);
                _zipInputStream = new ZipInputStream(fs);

                m_tempsize = 0;
                m_unzipTotal = 0;                
                m_zipfilesize = fs.Length;
                Debug.Log("<color=#20F856>" + "begin release zip: " + m_zipName + " ---- zipfie size:" + m_zipfilesize + "</color>");

                bool unzipsuc = true;
                ZipEntry theEntry = null;
                List<string> decompressfiles = new List<string>();
                while (true)
                {
                    try
                    {
                        theEntry = _zipInputStream.GetNextEntry();
                    }
                    catch(Exception e)
                    {                        
                        Debug.LogError(m_zipName + "解压失败 ："+e.Message);
                        unzipsuc = false;
                        break;
                    }

                    if (theEntry == null) break;

                    if (theEntry.Name.EndsWith("/"))
                    {
                        continue;
                    }

                    string fileName = m_tempFolder + theEntry.Name;
                    //string fileName = m_DownloadMgr.m_appdatapath + theEntry.Name;
                    decompressfiles.Add(fileName);
                    string directoryName = FileUtils.GetFilePath(fileName);

                    if (!Directory.Exists(directoryName))
                    {
                        Directory.CreateDirectory(directoryName);
                    }

                    if (File.Exists(fileName))
                    {
                        File.Delete(fileName);
                    }

                    FileStream streamWriter = File.Create(fileName);
                    
                    int size = 0;
                    byte[] data = new byte[2048];                            
                    while (true)
                    {
                        size = _zipInputStream.Read(data, 0, data.Length);
                        m_unzipTotal += size;
                        m_tempsize += size;
                        if(m_tempsize >= m_syncsize)
                        {
                            m_tempsize = 0;
                            if (m_DownloadMgr.unzip_length != null)
                                m_DownloadMgr.unzip_length(m_unzipTotal);

                            yield return 0;
                        }
                        if (size > 0)
                            streamWriter.Write(data, 0, size);
                        else
                            break;
                    }
                    streamWriter.Close();
                    streamWriter.Dispose();                                         
        
                }

                fs.Close();
                fs.Dispose();
                if (File.Exists(m_zipName))
                    File.Delete(m_zipName);
                
                if (unzipsuc)
                {
                    foreach(var upfile in decompressfiles)
                    {
                        string newfile = upfile.Replace(m_tempFolder,m_DownloadMgr.m_appdatapath);
                        Debug.LogError(newfile);
                        if (File.Exists(newfile)) File.Delete(newfile);

                        string dir = Path.GetDirectoryName(newfile);
                        if (!Directory.Exists(dir)) Directory.CreateDirectory(dir);

                        File.Move(upfile,newfile);
                    }

                    ChangeState(ResUpdateState.ResUpdateSuc, m_zipName);
                }
                else
                {
                    ChangeState(ResUpdateState.ResUpdateFail);
                }

                if (Directory.Exists(m_tempFolder))
                    Directory.Delete(m_tempFolder, true);
            }

            public void Exit(params object[] args)
            {                
                
            }
            public void Process(params object[] args)
            {         

            }
        }
        internal class ResUpdateSucState : DownMgrState, IState
        {            
            public void Enter(params object[] args)
            {

                string zipname = (string)args[0];
                Debug.Log("<color=#20F856>" + zipname + "已经解压完毕   " + "更新完成  </color> ");
                m_DownloadMgr.m_nowDownloadTaskIndex++;                                
                m_DownloadMgr.ClearAllTask();

                if (m_DownloadMgr.update_result != null)
                    m_DownloadMgr.update_result(true);
            }
            public void Exit(params object[] args)
            {

            }
            public void Process(params object[] args)
            {

            }
        }

        internal class ResUpdateFailState : DownMgrState, IState
        {
            public void Enter(params object[] args)
            {
                m_DownloadMgr.ClearAllTask();                
                if (m_DownloadMgr.update_result != null)
                    m_DownloadMgr.update_result(false);
            }
            public void Exit(params object[] args)
            {

            }
            public void Process(params object[] args)
            {

            }

        }

        internal class NetNotConnectedState : DownMgrState,IState
        {
            float notconnecttick;
            float timeout = 15f;
            public void Enter(params object[] args)
            {
                Debug.Log("网络断开，暂停下载");                
                m_DownloadMgr.PauseCurDownload();
                notconnecttick = 0;
            }
            public void Exit(params object[] args)
            {

            }
            public void Process(params object[] args)
            {
                if (Application.internetReachability != NetworkReachability.NotReachable)
                {
                    ChangeState(ResUpdateState.StartDownload);
                }
                else
                {
                    notconnecttick += Time.fixedDeltaTime;
                    if(notconnecttick >= timeout)
                    {
                        // todo show msg box 
                        
                    }
                }
            }
        }


        internal class ConfirmAllowDownloadWithOutWifIState : DownMgrState, IState
        {
            float notconnecttick;
            float timeout = 15f;
            public void Enter(params object[] args)
            {
                Debug.Log("等待用户确认是否继续下载");
                bool allow = false;

                if (allow)
                    ChangeState(ResUpdateState.StartDownload);
                else
                    ChangeState(ResUpdateState.DownloadFail);
            }
            public void Exit(params object[] args)
            {

            }
            public void Process(params object[] args)
            {

            }
        }

        internal class DownMgrState
        {
            protected DownloadMgr m_DownloadMgr
            {
                get
                {
                    return DownloadMgr.Instance;
                }
            }
            protected void ChangeState(ResUpdateState state,params object[] args)
            {
                DownloadMgr.Instance.ChangeState(state,args);
            }
        }
    }
}
