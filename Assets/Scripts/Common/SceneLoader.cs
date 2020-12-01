using UnityEngine;
using System.Collections;
using UnityEngine.SceneManagement;
using XLua;

namespace LPCFramework
{
    [LuaCallCSharp]
    public class SceneLoader : SingletonMonobehaviour<SceneLoader>
    {
        AsyncOperation m_asyncOperation;
        System.Action<int> m_funcUpdate;
        System.Action m_funcComplete;

        public void LoadScene(string sceneName, System.Action funcStart = null, System.Action<int> funcUpdate = null, System.Action funcComplete = null, System.Action<string> error = null)
        {
            if (null != funcStart)
            {
                funcStart();
                funcStart = null;
            }
            try
            {
                m_funcUpdate = funcUpdate;
                m_funcComplete = funcComplete;
                StartCoroutine(LoadAsync(sceneName));
            }
            catch (System.Exception e)
            {
                if (null != error)
                {
                    error("loading异常：" + e.Message);
                }
            }
        }
        private IEnumerator LoadAsync(string sceneName)
        {
            ResourceMgr.TryLoadSceneAssetBundle(sceneName);
            yield return 0;

            m_asyncOperation = SceneManager.LoadSceneAsync(sceneName, LoadSceneMode.Single);
            m_asyncOperation.allowSceneActivation = false;

            yield return m_asyncOperation;
        }

        void Update()
        {
            if (null == m_asyncOperation)
                return;

            // 更新进度条
            if (null != m_funcUpdate && m_asyncOperation.progress <= 0.9f)
            {
                m_funcUpdate((int)((m_asyncOperation.progress + 0.1f) * 100));
            }

            // 更新进度条，设置场景可交互
            if (m_asyncOperation.progress == 0.9f)
            {
                m_asyncOperation.allowSceneActivation = true;

                if(null != m_funcUpdate)
                    m_funcUpdate(100);
            }

            // Loading结束
            if (m_asyncOperation.isDone)
            {                
                m_asyncOperation = null;

                if(null != m_funcComplete)
                m_funcComplete();

                m_funcUpdate = null;
                m_funcComplete = null;
            }
        }
    }
}
