/*
* ==============================================================================
* 
* Created: 2017-4-11
* Author: Jeremy
* Company: LightPaw
* 
* ==============================================================================
*/
using UnityEngine;
using System.Collections.Generic;
using XLua;
using FairyGUI;
namespace LPCFramework
{
    public class AudioManager : SingletonMonobehaviour<AudioManager>,IManager
    {        
        /// <summary>
        /// 背景音乐频道
        /// </summary>
        AudioPool mMusic;
        /// <summary>
        /// 音效频道
        /// </summary>
        AudioPool mAudio;

        /// <summary>
        /// 3DObject声音
        /// </summary>        
        private int AudioIndex = 1;
        private float m_globalAudioVolume = 1.0f;
        private float m_globalMusicVolume = 1.0f;

        public void OnInitialize()
        {
            if (mMusic == null)
                mMusic = new AudioPool("MusicSourcePool",gameObject.transform);
            if (mAudio == null)
                mAudio = new AudioPool("AudioSourcePool", gameObject.transform);
            

            for (int i = 0; i < 10; i++)//cache
            {
                mMusic.AddAudioSource();
            }

            
            SetGolbalMusicVolume(LocalDataStorage.Instance.GetFloat("Music"));
            SetGlobalAudioVolume(LocalDataStorage.Instance.GetFloat("Effect"));
        }
        public void OnUpdateLogic()
        {
            
        }
        public void OnDestruct()
        {

        }
        [LuaCallCSharp]
        public void SetGlobalAudioVolume(float volume)
        {
            m_globalAudioVolume = volume;

            FairyGUI.Stage.inst.soundVolume = volume;
 
            foreach(var asource in mAudio.Pool)
            {
                if (asource.audiosource.clip != null)
                {
                    asource.audiosource.volume = asource.defaultvolume * volume;
                }
            }
        }

        [LuaCallCSharp]
        public void SetGolbalMusicVolume(float volume)
        {
            m_globalMusicVolume = volume;
            foreach (var asource in mMusic.Pool)
            {
                if (asource.audiosource.clip != null)
                {
                    asource.audiosource.volume = asource.defaultvolume * volume;
                }
            }
        }

         
        [LuaCallCSharp]
        public void PlayAudio(string audioname, int musictype ,float volume,int channel,int option)
        {
            Debug.Log("play music" + audioname + " " + volume + " " + channel);
            
            if (string.IsNullOrEmpty(audioname)) return;

            AudioSourceData asdata = null;
            bool isMusic = musictype == 1;
            if(isMusic)// looped
            {                
                if(channel >= mMusic.Pool.Count)
                {
                    Debug.LogError("Error ,Do you realy need 10 more loop music ?");
                    return;
                }
                asdata = mMusic.Pool[channel];
                asdata.audiosource.loop = true;
                asdata.audiosource.volume = volume * m_globalMusicVolume;
            }
            else// not looped group
            {                
                for (int i = 0;i< mAudio.Pool.Count;i++)
                {
                    if(mAudio.Pool[i].audiosource.isPlaying == false)
                    {
                        asdata = mAudio.Pool[i];
                        break;
                    }
                }
                if(asdata == null)
                {
                    mAudio.AddAudioSource();
                    asdata = mAudio.Pool[mAudio.Pool.Count - 1];
                    asdata.audiosource.loop = false;
                }
                asdata.audiosource.volume = volume * m_globalAudioVolume;
            }

            string path = string.Format("Audio/{0}", audioname);
            asdata.audiosource.playOnAwake = false;                        
            asdata.defaultvolume = volume;
            
            if (asdata.audiosource.clip)// && isMusic && asdata.audiosource.clip.name == audioname)
            {
                bool needreload = false;
                if (isMusic)
                {
                    if (asdata.audiosource.clip.name == audioname)
                        return;
                    else
                    {
                        needreload = true;                         
                    }
                }
                else
                {
                    if (asdata.audiosource.clip.name == audioname)
                    {
                        DoAudioState(asdata, (ControlMusic)option);
                    }
                    else
                    {
                        needreload = true;
                    }
                }
                                   
                if(needreload)
                {
                    if (!string.IsNullOrEmpty(asdata.respath))
                        ResourceMgr.Unload(asdata.respath);

                    ResourceMgr.Load(path, audioname, typeof(AudioClip), (obj) =>
                    {
                        AudioOption(asdata, (AudioClip)obj, (ControlMusic)option, path);
                    });
                }
            }
            else
            {
                ResourceMgr.Load(path, audioname, typeof(AudioClip), (obj) =>
                {
                    AudioOption(asdata, (AudioClip)obj, (ControlMusic)option, path);
                });
            }                        
        }
        void AudioOption(AudioSourceData asdata,AudioClip clip,ControlMusic option,string respath)
        {
            if (clip == null) return;

            asdata.respath = respath;
            asdata.audiosource.clip = clip;
            DoAudioState(asdata,option);
        }

        void DoAudioState(AudioSourceData asdata,ControlMusic option)
        {
            switch ((ControlMusic)option)
            {
                case ControlMusic.Play:
                    asdata.audiosource.Play();
                    break;
                case ControlMusic.Pause:
                    asdata.audiosource.Pause();
                    break;
                case ControlMusic.UnPause:
                    asdata.audiosource.UnPause();
                    break;
                case ControlMusic.Stop:
                    asdata.audiosource.Stop();
                    break;
            }
        }

        public enum ControlMusic
        {
            Play = 1,
            Pause,
            UnPause,
            Stop,
        }

        internal class AudioSourceData
        {
            public string respath;
            public AudioSource audiosource;
            public float defaultvolume;
        }


        internal class AudioPool
        {          
            public List<AudioSourceData> Pool { private set; get; }
            GameObject mRoot;
            public AudioPool(string poolname, Transform parent)
            {
                mRoot = new GameObject(poolname);
                mRoot.transform.parent = parent;
                mRoot.transform.localPosition = Vector3.zero;
                Pool = new List<AudioSourceData>();
            }

            public void AddAudioSource()
            {
                AudioSourceData asdata = new AudioSourceData();
                asdata.defaultvolume = 1.0f;
                asdata.audiosource = mRoot.AddComponent<AudioSource>();
                Pool.Add(asdata);
            }

        }
    }
}

