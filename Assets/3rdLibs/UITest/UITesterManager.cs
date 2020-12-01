using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;
using System.Text.RegularExpressions;
using UnityEngine;
using FairyGUI;
using XLua;

namespace LPCFramework
{

    public enum UITestEvent : byte
    {
        Pause, //标记一个UI流程节点，比如此时在主城界面，要开始做Check了

        //目前we test支持的获取UI的信息做检查的，只有这两个
        //这些应该就足够用于UI测试了。我们可以根据需要再加
        CheckImage, //显示的图片是否正确
        CheckText,  //显示的文字是否正确

        //目前we test支持的UI操作，有(we test支持的是uGUI/NGUI的，下面这些是FairyGUI里对应的)
        //OnClick,OnDragStart,OnDragEnd,OnChanged
        //在加上FairyGUI里特有的OnClickLink
        //应该已经能满足测试需要。
        //下面包含被注释掉的是目前FariyGUI里全部的。我们应该不需要被注释掉的那些
        OnClick, //GObject.onClick
        //OnRightClick, //GObject.onRightClick
        //OnTouchBegin, //GObject.onTouchBegin
        //OnTouchEnd, //GObject.onTouchEnd
        //OnKeyDown, //GObject.onKeyDown
        OnClickLink, //GObject.onClickLink 还没有可供测试的UI调试这个功能
        OnDragStart, //GObject.onDragStart 还没有可供测试的UI调试这个功能
        OnDragEnd, //GObject.onDragEnd 还没有可供测试的UI调试这个功能
        OnChanged, //GTextField.onChanged 还没有可供测试的UI调试这个功能
        //OnClickItem, //GList.onClickItem

        Max,
    }

    /// <summary>
    /// 记录QA的操作，并且根据操作生成一份Lua文件作为操作步骤
    /// 需要在生成的Lua中添加结果判断
    /// </summary>
    public class UITestReplay
    {
        public class UITestReplayOneFrame
        {
            public int m_iTimeInterval;
            public UITestEvent m_eEvent;
            public string m_sObjectName;

            public object m_pEventData;
        }

        private readonly List<UITestReplayOneFrame> m_pFrames = new List<UITestReplayOneFrame>();

        public void RecordKeyFrame(int iTime, string sName, UITestEvent eEvent, object data)
        {
            m_pFrames.Add(new UITestReplayOneFrame
            {
                m_iTimeInterval = iTime,
                m_sObjectName = sName,
                m_eEvent = eEvent,
                m_pEventData = data,
            });
        }

        public string ToLuaScript(string sScriptName)
        {
            string sScriptContent = "--由UITest自动生成的脚本\n\n";


            sScriptContent += string.Format("function UITestFunction_{0}()\n", sScriptName);
            sScriptContent += "    --开始测试\n";
            sScriptContent += "    CS.LPCFramework.UITesterManager.StartTestCommandQueue()\n";
            sScriptContent += string.Format("    CS.LPCFramework.UITesterManager.EnterSection(\"{0}\")\n\n", sScriptName);

            for (int i = 0; i < m_pFrames.Count; ++i)
            {
                
                switch (m_pFrames[i].m_eEvent)
                {
                    case UITestEvent.Pause:
                        sScriptContent += string.Format("    --等待{0}毫秒\n", m_pFrames[i].m_iTimeInterval / 10000);
                        sScriptContent += string.Format("    CS.LPCFramework.UITesterManager.AddInterval({0})\n\n", m_pFrames[i].m_iTimeInterval / 10000);
                        break;
                    case UITestEvent.CheckText:
                        sScriptContent += string.Format("    --检查文本框{0}的文字是否是\"{1}\"\n", m_pFrames[i].m_sObjectName, m_pFrames[i].m_pEventData);
                        sScriptContent += string.Format("    CS.LPCFramework.UITesterManager.CheckText(\"{0}\",\"{1}\")\n\n", m_pFrames[i].m_sObjectName, m_pFrames[i].m_pEventData);
                        break;
                    case UITestEvent.CheckImage:
                        sScriptContent += string.Format("    --检查图片框{0}的图片是否是\"{1}\"\n", m_pFrames[i].m_sObjectName, m_pFrames[i].m_pEventData);
                        sScriptContent += string.Format("    CS.LPCFramework.UITesterManager.CheckImage(\"{0}\",\"{1}\")\n\n", m_pFrames[i].m_sObjectName, m_pFrames[i].m_pEventData);
                        break;
                    case UITestEvent.OnClick:
                        sScriptContent += string.Format("    --等待{0}毫秒后点击{1}\n", m_pFrames[i].m_iTimeInterval / 10000, m_pFrames[i].m_sObjectName);
                        sScriptContent += string.Format("    CS.LPCFramework.UITesterManager.AddInterval({0})\n", m_pFrames[i].m_iTimeInterval / 10000);
                        sScriptContent += string.Format("    CS.LPCFramework.UITesterManager.AddClick(\"{0}\")\n\n", m_pFrames[i].m_sObjectName);
                        break;
                    case UITestEvent.OnChanged:
                        sScriptContent += string.Format("    --等待{0}毫秒后将文本输入框{1}的文字改为{2}\n", m_pFrames[i].m_iTimeInterval / 10000, m_pFrames[i].m_sObjectName, m_pFrames[i].m_pEventData);
                        sScriptContent += string.Format("    CS.LPCFramework.UITesterManager.AddInterval({0})\n", m_pFrames[i].m_iTimeInterval / 10000);
                        sScriptContent += string.Format("    CS.LPCFramework.UITesterManager.AddSetText(\"{0}\", \"{1}\")\n\n", m_pFrames[i].m_sObjectName, m_pFrames[i].m_pEventData);
                        break;
                }
            }

            sScriptContent += "    CS.LPCFramework.UITesterManager.FinishTestCommandQueue()\n\n";
            sScriptContent += "end\n";

            return sScriptContent;
        }
    }

    /// <summary>
    /// 错误代码
    /// </summary>
    public enum UITestError : byte
    {
        CannotFindGObject,
        CheckImage,
        CheckText,
        NetworkError,

        FromLuaScript,
    }

    public class UITesterManager : MonoBehaviour
    {
        #region Constants

        private static string m_LuaStorePath = "";
        private static string LuaPath
        {
            get
            {
                return string.IsNullOrEmpty(m_LuaStorePath)
                    ? Application.dataPath + "/Resources/Lua/Test/UITest/"
                    : m_LuaStorePath;
            }
        }

        private static string LuaExcuteStartFolder = "Test/UITest/";
        private const string GenerateSubFolder = "Generated/";
        private const string CombineSubFolder = "Combined/";
        private const string AutoGenerateFile = "Generate";
        private const int UITestGUIWindowIndexStart = 3000;

        #endregion

        #region 这里是需要被外界调用的接口

        /// <summary>
        /// 用于初始化UITest的struct
        /// </summary>
        public struct UITestInitializeParameters
        {
            #region Path

            /// <summary>
            /// 如果不指定，将是Application.dataPath + "/Resources/Lua/Test/UITest/"
            /// </summary>
            public string m_sLuaStorePath;

            /// <summary>
            /// 如果不指定，将是"Test/UITest/",尤其要注意，编译自动运行版本时，要把QA录制的脚本放在这个能调用到的位置
            /// </summary>
            public string m_sLuaExcutePath;

            #endregion

            #region Actions

            /// <summary>
            /// 执行Lua脚本，必须指定
            /// </summary>
            public Action<string> m_DoFile;
            /// <summary>
            /// 执行Lua函数，必须指定
            /// </summary>
            public Action<string> m_CallFunction;

            /// <summary>
            /// 热重启
            /// </summary>
            public Action m_Reboot;

            /// <summary>
            /// 打印Log，如果不指定，将使用Debug.Log
            /// </summary>
            public Action<string> m_LogFunction;

            #endregion

            #region Auto Running

            //TODO 尚未实现（需要热重启）

            /// <summary>
            /// 0 - 执行特定脚本， 1 - 执行所有的合并脚本（需要热重启支持）
            /// </summary>
            public int m_iAutoRunningMode;

            /// <summary>
            /// 脚本名
            /// </summary>
            public string m_sAutoRunningScript;

            #endregion
        }

        private static UITesterManager Instance = null;
        private static Action<string> m_LuaDoFile;
        private static Action<string> m_LuaCallFunction;
        private static Action m_HotReboot;
        private static Action<string> m_Log;

        /// <summary>
        /// 在最开始的时候调用初始化
        /// </summary>
        /// <param name="gameObject">将MonoBehavour加入的gameObject(建议DonotDestoryOnLoad)，如果Destoy要重新调用</param>
        /// <param name="parameter">初始化用到的参数</param>
        /// <returns></returns>
        public static bool Initialize(GameObject gameObject, UITestInitializeParameters parameter)
        {
            if (!IsSupported())
            {
                Debug.LogWarning("只能在PC用");
                return false;
            }

            if (null != Instance)
            {
                Debug.LogWarning("初始化UITestManager失败：已经初始化过，不需要再次初始化");
                return false;
            }
            if (null == parameter.m_DoFile || null == parameter.m_CallFunction)
            {
                Debug.LogWarning("初始化UITestManager失败：调用Lua的函数缺一不可。");
                return false;                
            }

            Instance = gameObject.AddComponent<UITesterManager>();

            if (!string.IsNullOrEmpty(parameter.m_sLuaStorePath))
            {
                m_LuaStorePath = parameter.m_sLuaStorePath;
            }
            if (!string.IsNullOrEmpty(parameter.m_sLuaExcutePath))
            {
                LuaExcuteStartFolder = parameter.m_sLuaExcutePath;
            }

            m_LuaDoFile = parameter.m_DoFile;
            m_LuaCallFunction = parameter.m_CallFunction;
            m_HotReboot = parameter.m_Reboot;
            m_Log = parameter.m_LogFunction;
            
            return true;
        }

        /// <summary>
        /// 是否支持
        /// </summary>
        /// <returns></returns>
        public static bool IsSupported()
        {
#if UNITY_EDITOR || UNITY_STANDALONE_WIN
            return true;
#else
            return false;
#endif
        }

        /// <summary>
        /// 提供给Lua调用的（方便不用重新编译版本仅更新Lua来切换是否自动运行）
        /// 必须在Initialize之后调用（否则将被Initialize中的parameter的值覆盖掉）
        /// 尚未实现
        /// TODO:需要热重启支持
        /// 用于编译一个什么都不用管自动运行的版本（比如发给We Test）
        /// </summary>
        /// <param name="iMode">0 - 执行特定脚本， 1 - 执行所有的合并脚本（需要热重启支持）</param>
        /// <param name="sScriptName">脚本名</param>
        [LuaCallCSharp]
        public void SetAutoRunning(int iMode, string sScriptName)
        {

        }

        /// <summary>
        /// TODO: 尚未实现
        /// 可能在Replay运行中，发生了网络错误等，导致了热重启。
        /// 如果UITestManager没有参与（比如挂着UITestManager的脚本在热重启中被Destory了，就不需要管了）
        /// 需要告诉UITestManager重新开始跑脚本
        /// </summary>
        public void OnRebooted()
        {
            
        }

        #endregion

        #region Unity调用的

#if UNITY_EDITOR || UNITY_STANDALONE_WIN
        /// <summary>
        /// 初始化
        /// Initialize based on ConstDefine.Debug
        /// </summary>
        void Start()
        {
            InitialRecording();
        }

        /// <summary>
        /// 更新逻辑
        /// </summary>
        void Update()
        {
            //测试暂且用比较恶心的办法！
            //要改的话，需要统一从GObjectPool里创建UI，或者修改FairyGUI的代码
            //暂时这么搞。。反正不是给玩家用的。
            if (null != m_CreatedGObject)
            {
                foreach (GObject obj in GRoot.inst.GetChildren())
                {
                    AddListenerToChilder(obj, "");
                }
            }

            switch (m_eState)
            {
                case EUITestState.NotStarted:
                    if (Input.GetKeyDown(KeyCode.F9))
                    {
                        StartRecord();
                    }
                    if (Input.GetKeyDown(KeyCode.F7))
                    {
                        EnterReplay();
                    }
                    if (Input.GetKeyDown(KeyCode.F8))
                    {
                        EnterCombine();
                    }
                    break;
                case EUITestState.Recording:
                    if (Input.GetKeyDown(KeyCode.F10))
                    {
                        PauseRecord();
                    }
                    if (Input.GetKeyDown(KeyCode.F9))
                    {
                        StopRecord();
                    }
                    break;
                case EUITestState.RecordingPause:
                    if (Input.GetKeyDown(KeyCode.F10))
                    {
                        ResumeRecord();
                    }
                    BlockScreen();
                    break;
                case EUITestState.RecordingSaving:
                    BlockScreen();
                    break;
                case EUITestState.ReplayNotStart:
                    BlockScreen();
                    if (Input.GetKeyDown(KeyCode.F7))
                    {
                        m_eState = EUITestState.NotStarted;
                    }
                    break;
                case EUITestState.ReplayReplaying:
                    if (null != m_ReplayFrames)
                    {
                        PerformKeyFrame();
                    }
                    break;
                case EUITestState.Combining:
                    BlockScreen();
                    if (Input.GetKeyDown(KeyCode.F8))
                    {
                        m_eState = EUITestState.NotStarted;
                    }
                    break;
            }
        }

        /// <summary>
        /// 析构
        /// </summary>
        void OnDestory()
        {
            Instance = null;
        }
#endif

        #endregion

        #region 和录制脚本有关的UI。应该只需要支持Editor和PC 注意：Editor内性能测试时，务必注掉OnGUI函数

#if UNITY_EDITOR || UNITY_STANDALONE_WIN
        void OnGUI()
        {
            Color oldc = GUI.color;
            int iOldBSize = GUI.skin.button.fontSize;
            int iOldLSize = GUI.skin.label.fontSize;
            int iOldTFSize = GUI.skin.textField.fontSize;
            GUI.skin.button.fontSize = Mathf.RoundToInt(Screen.height * 0.02f);
            GUI.skin.label.fontSize = Mathf.RoundToInt(Screen.height * 0.02f);
            GUI.skin.textField.fontSize = Mathf.RoundToInt(Screen.height * 0.02f);

            if (null == m_EdgeTexture)
            {
                m_EdgeTexture = new Texture2D(1, 1, TextureFormat.RGB565, false);
                m_EdgeTexture.SetPixel(0, 0, Color.white);
                m_EdgeTexture.Apply();
            }

            if (EUITestState.NotStarted != m_eState)
            {
                //draw edge
                GUI.color = m_cEdgeColors[(int) m_eState];
                GUI.DrawTexture(new Rect(0.0f, 0.0f, 4.0f, Screen.height*0.3f), m_EdgeTexture);
                GUI.DrawTexture(new Rect(0.0f, Screen.height*0.7f, 4.0f, Screen.height*0.3f), m_EdgeTexture);
                GUI.DrawTexture(new Rect(Screen.width - 4.0f, 0.0f, 4.0f, Screen.height*0.3f), m_EdgeTexture);
                GUI.DrawTexture(new Rect(Screen.width - 4.0f, Screen.height*0.7f, 4.0f, Screen.height*0.3f),
                    m_EdgeTexture);

                GUI.DrawTexture(new Rect(0.0f, 0.0f, Screen.width*0.3f, 4.0f), m_EdgeTexture);
                GUI.DrawTexture(new Rect(Screen.width*0.7f, 0.0f, Screen.width*0.3f, 4.0f), m_EdgeTexture);
                GUI.DrawTexture(new Rect(0.0f, Screen.height - 4.0f, Screen.width*0.3f, 4.0f), m_EdgeTexture);
                GUI.DrawTexture(new Rect(Screen.width*0.7f, Screen.height - 4.0f, Screen.width*0.3f, 4.0f),
                    m_EdgeTexture);
                GUI.color = Color.white;
            }
            else
            {
                GUI.Label(new Rect(0.0f, 0.0f, Screen.width * 0.1f, Screen.height * 0.05f), "<color=#FF0000>UITest</color>");
            }

            switch (m_eState)
            {

                case EUITestState.RecordingPause:
                    {
                        GUIPause();  
                    }
                    break;
                case EUITestState.RecordingSaving:
                    {
                        GUISaving();
                    }
                    break;
                case EUITestState.ReplayNotStart:
                    {
                        GUIReplayingNotStart();
                    }
                    break;
                case EUITestState.Combining:
                    {
                        GUICombine();
                    }
                    break;
            }

            GUI.color = oldc;
            GUI.skin.button.fontSize = iOldBSize;
            GUI.skin.label.fontSize = iOldLSize;
            GUI.skin.textField.fontSize = iOldTFSize;
        }
#endif

        #region Common UI

        private static readonly Color[] m_cEdgeColors =
        {
            new Color(1.0f, 1.0f, 1.0f), 
            new Color(1.0f, 0.0f, 0.0f), 
            new Color(1.0f, 1.0f, 0.0f), 
            new Color(1.0f, 1.0f, 0.0f), 
            new Color(0.0f, 1.0f, 0.0f), 
            new Color(0.0f, 1.0f, 1.0f), 
            new Color(0.0f, 0.0f, 1.0f), 

            new Color(0.0f, 0.0f, 0.0f), 
        };

        private bool m_bDropListExpanded = false;
        private int ShowDropBox(Rect rect, string[] items, int iCurrentIndex)
        {
            if (items.Length < 1)
            {
                return 0;
            }
            iCurrentIndex = Mathf.Clamp(iCurrentIndex, 0, items.Length - 1);

            if (m_bDropListExpanded)
            {
                GUI.color = Color.gray;
            }
            if (GUI.Button(rect, items[iCurrentIndex]))
            {
                m_bDropListExpanded = !m_bDropListExpanded;
            }
            GUI.color = Color.white;
            if (m_bDropListExpanded)
            {
                for (int i = 0; i < items.Length; ++i)
                {
                    string sName = (i == iCurrentIndex) ? ("<color=#00FFFF>" + items[i] + "</color>") : items[i];
                    Rect newRect = new Rect(rect.x, rect.y + (i + 1) * rect.height, rect.width, rect.height);
                    if (GUI.Button(newRect, sName))
                    {
                        iCurrentIndex = i;
                        m_bDropListExpanded = false;
                    }
                }
            }
            return iCurrentIndex;
        }

        private void BackGround(float fAlpha = 0.7f)
        {
            Color oldC = GUI.color;
            GUI.color = new Color(0.1f, 0.1f, 0.1f, fAlpha);
            GUI.DrawTexture(new Rect(0.0f, 0.0f, Screen.width, Screen.height), m_EdgeTexture);
            GUI.color = oldC;            
        }

        #endregion

        #region Recording UI

        private string m_sUITestStoreScriptName = "";

        /// <summary>
        /// 获取一个默认的可用的脚本文件名
        /// </summary>
        /// <returns>脚本文件名</returns>
        private static string GetPossibleFileName()
        {
            bool bHasFile = true;
            int iIndexStart = 1;
            string sFile = LuaPath + GenerateSubFolder + AutoGenerateFile + "_" + iIndexStart + ".lua";
            while (bHasFile)
            {

                bHasFile = File.Exists(sFile);
                if (bHasFile)
                {
                    ++iIndexStart;
                    sFile = LuaPath + GenerateSubFolder + AutoGenerateFile + "_" + iIndexStart + ".lua";
                }
            }
            return AutoGenerateFile + "_" + iIndexStart;
        }

        /// <summary>
        /// 保存录制脚本的UI
        /// </summary>
        /// <param name="windowID">肯定是3001</param>
        private void InputScriptNameWindow(int windowID)
        {
            Color oldc = GUI.color;

            float fWidth = Mathf.Max(0.3f * Screen.width, 300.0f);
            float fbWidth = Mathf.Max(0.1f * Screen.width, 100.0f);
            float fHeght = Mathf.Max(0.05f * Screen.height, 50.0f);
            float fEdge = (0.025f / 0.3f) * fWidth;
            GUI.Label(
                new Rect(
                    fEdge,
                    0.2f * fHeght,
                    fWidth,
                    0.9f * fHeght),
                "保存脚本名(不为空，且输入名字只有字母和数字和下划线):");

            m_sUITestStoreScriptName =
                GUI.TextField(
                new Rect(
                    fEdge,
                    1.2f * fHeght,
                    fWidth,
                    0.9f * fHeght),
                    m_sUITestStoreScriptName);
            m_sUITestStoreScriptName = Regex.Replace(m_sUITestStoreScriptName, "[^\\w\\d_]", "");

            if (GUI.Button(new Rect(
                    fEdge + (fWidth - fbWidth) * 0.5f,
                    2.2f * fHeght,
                    fbWidth,
                    0.9f * fHeght),
                    "保存"))
            {
                if (!string.IsNullOrEmpty(m_sUITestStoreScriptName))
                {
                    string sFileName = LuaPath + GenerateSubFolder + m_sUITestStoreScriptName + ".lua";
                    string sLuaContent = m_Record.ToLuaScript(m_sUITestStoreScriptName);
                    File.WriteAllText(sFileName, sLuaContent, Encoding.UTF8);

                    m_Record = null;
                    m_eState = EUITestState.NotStarted;
                }
            }

            GUI.DragWindow(new Rect(0, 0, Screen.width, Screen.height));

            GUI.color = oldc;
        }

        private Texture2D m_EdgeTexture = null;

        private Vector2 GetOffsetPos(List<Vector2> allPoses, Vector2 pos)
        {
            for (int i = 0; i < allPoses.Count; ++i)
            {
                if ((pos - allPoses[i]).sqrMagnitude < 400.0f)
                {
                    pos += new Vector2(0.0f, Screen.height * 0.015f);
                    return GetOffsetPos(allPoses, pos);
                }
            }
            return pos;
        }

        private void GUIPause()
        {
            if (null == m_CreatedGObject)
            {
                return;
            }
            BackGround();
            GUI.color = Color.white;
            int iOldBSize = GUI.skin.button.fontSize;
            int iOldLSize = GUI.skin.label.fontSize;
            int iOldTFSize = GUI.skin.textField.fontSize;
            GUI.skin.button.fontSize = Mathf.RoundToInt(Screen.height * 0.015f);
            GUI.skin.label.fontSize = Mathf.RoundToInt(Screen.height * 0.015f);
            GUI.skin.textField.fontSize = Mathf.RoundToInt(Screen.height * 0.015f);
            List<Vector2> allPos = new List<Vector2>();
            foreach (KeyValuePair<string, GObject> kvp in m_CreatedGObject)
            {
                GImage image = kvp.Value as GImage;
                if (image != null && image.onStage && image.visible && null != image.resourceURL)
                {
                    string sName = GetFullName(image);
                    bool bHasMe = m_CheckList.ContainsKey(sName);
                    string sControllerName = "I:" +
                                             (image.resourceURL.Length > 4
                                                 ? image.resourceURL.Substring(image.resourceURL.Length - 4)
                                                 : image.resourceURL);
                    string sTx = bHasMe ? "<color=#00FFFF>" + sControllerName + "</color>" : sControllerName;
                    Vector2 v2Point = image.LocalToGlobal(Vector2.zero);
                    v2Point = GetOffsetPos(allPos, v2Point);
                    allPos.Add(v2Point);
                    if (GUI.Button(new Rect(v2Point.x, v2Point.y, Screen.height * 0.08f, Screen.height * 0.02f), sTx))
                    {
                        if (bHasMe)
                        {
                            RemoveCheck(sName);
                        }
                        else
                        {
                            AddImageCheck(sName, image.resourceURL);
                        }
                    }
                }

                GTextField textf = kvp.Value as GTextField;
                if (null != textf && textf.onStage && textf.visible && null != textf.text)
                {
                    string sName = GetFullName(textf);
                    bool bHasMe = m_CheckList.ContainsKey(sName);
                    string sControllerName = "T:" +
                                             (textf.text.Length > 4
                                                 ? textf.text.Substring(0, 4)
                                                 : textf.text);
                    string sTx = bHasMe ? "<color=#00FFFF>" + sControllerName + "</color>" : sControllerName;
                    Vector2 v2Point = textf.LocalToGlobal(Vector2.zero);
                    v2Point = GetOffsetPos(allPos, v2Point);
                    allPos.Add(v2Point);
                    if (GUI.Button(new Rect(v2Point.x, v2Point.y, Screen.height * 0.08f, Screen.height * 0.02f), sTx))
                    {
                        if (bHasMe)
                        {
                            RemoveCheck(sName);
                        }
                        else
                        {
                            AddTextCheck(sName, textf.text);
                        }
                    }
                }
            }
            GUI.skin.button.fontSize = iOldBSize;
            GUI.skin.label.fontSize = iOldLSize;
            GUI.skin.textField.fontSize = iOldTFSize;
        }

        private void GUISaving()
        {
            BackGround();
            float fWidth = Mathf.Max(0.35f * Screen.width, 350.0f);
            float fHeight = Mathf.Max(0.17f * Screen.height, 170.0f);
            GUI.ModalWindow(UITestGUIWindowIndexStart + 1,
                new Rect(
                    (Screen.width - fWidth) * 0.5f,
                    (Screen.height - fHeight) * 0.5f,
                    fWidth,
                    fHeight), InputScriptNameWindow, "保存刚才录制的操作");
        }

        #endregion

        #region Replaying UI

        private enum EUITestChooseFrom
        {
            Generate,
            Combine,
        }

        private EUITestChooseFrom m_eChooseFrom = EUITestChooseFrom.Generate;
        private static readonly string[] m_sChooseFrom = { "录制的脚本", "合并的脚本" };
        private string m_sToReplay = "";
        private void GUIReplayingNotStart()
        {
            BackGround();
            float fYStart = Screen.height*0.45f;
            float fWidth = Screen.width*0.18f;
            float fHeight = Mathf.Max(Screen.height*0.05f, 40.0f);

            m_eChooseFrom = (EUITestChooseFrom) ShowDropBox(
                new Rect(Screen.width * 0.2f, fYStart, fWidth, fHeight),
                m_sChooseFrom,
                (int) m_eChooseFrom);

            m_sToReplay =
                GUI.TextField(new Rect(Screen.width * 0.4f, fYStart, fWidth, fHeight),
                    m_sToReplay);
            m_sToReplay = Regex.Replace(m_sToReplay, "[^\\w\\d_]", "");

            if (!string.IsNullOrEmpty(m_sToReplay))
            {
                string[] guess = GuessScript(
                    m_sToReplay, 
                    EUITestChooseFrom.Generate == m_eChooseFrom ? m_sAllGeneratedScripts : m_sAllCombinedScripts
                    );
                for (int i = 0; i < guess.Length; ++i)
                {
                    Rect newRect = new Rect(Screen.width * 0.4f,
                        fYStart + (i + 1) * fHeight,
                        fWidth,
                        fHeight);
                    if (GUI.Button(newRect, guess[i]))
                    {
                        m_sToReplay = guess[i];
                    }
                }
            }

            string sFullName = "";
            if (!string.IsNullOrEmpty(m_sToReplay))
            {
                if (EUITestChooseFrom.Generate == m_eChooseFrom)
                {
                    sFullName = LuaPath + GenerateSubFolder + m_sToReplay + ".lua";
                }
                else
                {
                    sFullName = LuaPath + CombineSubFolder + m_sToReplay + ".lua";
                }
            }
            bool bCanRun = !string.IsNullOrEmpty(sFullName) && File.Exists(sFullName);
            string sButtonName = bCanRun ? "运行" : "<color=#FF0000>运行</color>";
            if (GUI.Button(new Rect(Screen.width * 0.6f, fYStart, fWidth, fHeight),
                sButtonName))
            {
                if (bCanRun)
                {
                    StartReplay(m_eChooseFrom, m_sToReplay);
                }
            }
        }

        #endregion

        #region Combining UI

        private string m_sLoadCombineScriptName = "";
        private void GUICombine()
        {
            BackGround();

            float fLeftStart = Screen.width*0.04f;
            float fWidth = Screen.width * 0.12f;
            float fXSep = Screen.width * 0.16f;
            float fHeight = Screen.height*0.055f;

            float fRow1 = Screen.height * 0.03f;
            float fRow2 = Screen.height * 0.25f;
            float fRowSep = Screen.height * 0.25f;

            //第一排显示最基本的操作。
            m_sLoadCombineScriptName = GUI.TextField(new Rect(fLeftStart, fRow1, fWidth, fHeight), m_sLoadCombineScriptName);
            m_sLoadCombineScriptName = Regex.Replace(m_sLoadCombineScriptName, "[^\\w\\d_]", "");
            bool bToLoadExist = m_sAllCombinedScripts.Contains(m_sLoadCombineScriptName);
            if (!bToLoadExist && !string.IsNullOrEmpty(m_sLoadCombineScriptName))
            {
                string[] guessCombine = GuessScript(m_sLoadCombineScriptName, m_sAllCombinedScripts);
                for (int i = 0; i < guessCombine.Length; ++i)
                {
                    if (GUI.Button(new Rect(fLeftStart, fRow1 + (i + 1) * fHeight, fWidth, fHeight), guessCombine[i]))
                    {
                        m_sLoadCombineScriptName = guessCombine[i];
                    }  
                }
            }
            if (GUI.Button(new Rect(fLeftStart + fXSep, fRow1, fWidth, fHeight), bToLoadExist ? "加载(当前未保存的将丢失)" : "<color=#FF0000>加载</color>"))
            {
                if (bToLoadExist)
                {
                    LoadCombine(m_sLoadCombineScriptName);
                    m_sCurrentCombineScriptName = m_sLoadCombineScriptName;
                }
            }
            m_sCurrentCombineScriptName = GUI.TextField(new Rect(fLeftStart + fXSep * 2.0f, fRow1, fWidth, fHeight), m_sCurrentCombineScriptName);
            m_sCurrentCombineScriptName = Regex.Replace(m_sCurrentCombineScriptName, "[^\\w\\d_]", "");
            bool bToSaveExist = File.Exists(LuaPath + CombineSubFolder + m_sCurrentCombineScriptName + ".txt");
            bool bCanSave = CanSaveCombine();
            if (GUI.Button(new Rect(fLeftStart + fXSep * 3.0f, fRow1, fWidth, fHeight), bToSaveExist ?
                (!bCanSave ? "<color=#FF0000>覆盖</color>" : "覆盖") :
                (!bCanSave ? "<color=#FF0000>保存</color>" : "保存")
                ))
            {
                if (bCanSave)
                {
                    CombineAndSave(m_sCurrentCombineScriptName, m_sCombineList.ToArray());    
                }
            }

            if (GUI.Button(new Rect(fLeftStart + fXSep * 5.0f, fRow1, fWidth, fHeight),"重新合并" + m_sAllCombinedScripts.Length))
            {
                ReCombineAll();
            }
            
            //从第二排开始，可以添加脚本
            for (int i = 0; i < 3; ++i)
            {
                for (int j = 0; j < 6; ++j)
                {
                    int iScriptIndex = i*6 + j;
                    ShowCombineList(new Rect(fLeftStart + j * fXSep, fRow2 + fRowSep * i, fWidth, fHeight), iScriptIndex);
                }
            }
        }

        private void ShowCombineList(Rect rect, int iIndex)
        {
            if (iIndex < m_sCombineList.Count)
            {
                Rect rectInner = new Rect(rect.x + rect.width * 0.15f, rect.y, rect.width * 0.7f, rect.height);
                GUI.Label(new Rect(rect.x, rect.y, rect.width * 0.15f, rect.height), (iIndex + 1) + ":");
                m_sCombineList[iIndex] = GUI.TextField(rectInner, m_sCombineList[iIndex]);
                if (!string.IsNullOrEmpty(m_sCombineList[iIndex]))
                {
                    string[] guess = GuessScript(m_sCombineList[iIndex], m_sAllGeneratedScripts);
                    if (guess.Length > 0 && !m_sCombineList[iIndex].Equals(guess[0]))
                    {
                        for (int i = 0; i < guess.Length; ++i)
                        {
                            if (GUI.Button(new Rect(rectInner.x, rectInner.y + rectInner.height*(i + 1), rectInner.width, rectInner.height), guess[i]))
                            {
                                m_sCombineList[iIndex] = guess[i];
                            }
                        }
                    }
                }
                if (GUI.Button(new Rect(rect.x + rect.width * 0.85f, rect.y, rect.width * 0.15f, rect.height), "<color=#FF0000>X</color>"))
                {
                    m_sCombineList.RemoveAt(iIndex);
                }
            }
            else if (iIndex == m_sCombineList.Count)
            {
                if (GUI.Button(rect, "<color=#00FFFF>+</color>"))
                {
                    m_sCombineList.Add("");
                }
            }
        }

        #endregion

        #endregion

        #region Common

        /// <summary>
        /// 自己用于区别状态的，如果后面会变得比较复杂可以换成状态鸡
        /// </summary>
        private enum EUITestState : byte
        {
            NotStarted,
            Recording,
            RecordingPause,
            RecordingSaving,
            ReplayNotStart,
            ReplayReplaying,
            Combining,
        }

        private EUITestState m_eState = EUITestState.NotStarted;

        /// <summary>
        /// 用于猜测脚本名称
        /// </summary>
        /// <param name="str1">输入字符串</param>
        /// <param name="str2">脚本名</param>
        /// <returns></returns>
        private static float Levenshtein_Distance(string str1, string str2)
        {
            str1 = str1.ToLower();
            str2 = str2.ToLower();
            int n = str1.Length;
            int m = str2.Length;

            int i, j;
            if (n == 0)
            {
                return m;
            }
            if (m == 0)
            {

                return n;
            }
            int[,] theMatrix = new int[n + 1, m + 1];

            for (i = 0; i <= n; i++)
            {
                theMatrix[i, 0] = i;
            }

            for (j = 0; j <= m; j++)
            {
                theMatrix[0, j] = j;
            }

            for (i = 1; i <= n; i++)
            {
                char ch1 = str1[i - 1];
                for (j = 1; j <= m; j++)
                {
                    char ch2 = str2[j - 1];
                    int temp = ch1.Equals(ch2) ? 0 : 1;
                    theMatrix[i, j] = Mathf.Min(theMatrix[i - 1, j] + 1, theMatrix[i, j - 1] + 1, theMatrix[i - 1, j - 1] + temp);
                }
            }

            return 1.0f - Mathf.Clamp01((float)theMatrix[n, m] / Mathf.Max(n, m));
        }

        /// <summary>
        /// 用于猜测脚本名称
        /// </summary>
        /// <param name="sInputName">输入的脚本名称</param>
        /// <param name="scriptNames">从这个列表中猜测</param>
        /// <param name="fDistMax">最大距离</param>
        /// <param name="iNumber">返回数量</param>
        /// <returns></returns>
        private static string[] GuessScript(string sInputName, string[] scriptNames, float fDistMax = 0.0f, int iNumber = 3)
        {
            if (string.IsNullOrEmpty(sInputName) || sInputName.Length < 3)
            {
                return new string[0];
            }

            string[] retReady = new string[iNumber];
            float[] retDist = new float[iNumber];
            for (int i = 0; i < iNumber; ++i)
            {
                retDist[i] = -1.0f;
            }

            foreach (string sScript in scriptNames)
            {
                if (!string.IsNullOrEmpty(sScript))
                {
                    float fDist = Levenshtein_Distance(sInputName, sScript);
                    if (fDist > fDistMax)
                    {
                        for (int i = 0; i < iNumber; ++i)
                        {
                            if (fDist > retDist[i])
                            {
                                retDist[i] = fDist;
                                retReady[i] = sScript;
                                break;
                            }
                        }
                    }
                }
            }

            List<string> ret = new List<string>();
            for (int i = 0; i < iNumber; ++i)
            {
                if (retDist[i] > 0.0f && !string.IsNullOrEmpty(retReady[i]))
                {
                    ret.Add(retReady[i]);
                }
            }

            return ret.ToArray();
        }

        #endregion

        #region 录制
       
        private Dictionary<string, GObject> m_CreatedGObject;
        private UITestReplay m_Record;
        private long m_lRecordingTime;

        /// <summary>
        /// 获取GObject的完整ID
        /// </summary>
        /// <param name="obj">GObject</param>
        /// <returns>完整ID</returns>
        private static string GetFullName(GObject obj)
        {
            if (null == obj || obj == obj.root)
            {
                return "";
            }

            string sName = obj.id;
            GComponent parent = obj.parent;
            while (null != parent && parent != parent.root)
            {
                sName = parent.id + "." + sName;
                parent = parent.parent;
            }
            return sName;
        }

        private void InitialRecording()
        {
            Directory.CreateDirectory(LuaPath + GenerateSubFolder);
            Directory.CreateDirectory(LuaPath + CombineSubFolder);
            m_CreatedGObject = new Dictionary<string, GObject>();
        }

        private void AddListenerToChilder(GObject obj, string sParentName)
        {
            if (null == obj)
            {
                return;
            }

            string sName = string.IsNullOrEmpty(sParentName) ? obj.id : (sParentName + "." + obj.id);
            if (m_CreatedGObject.ContainsKey(sName))
            {
                return;
            }
            m_CreatedGObject.Add(sName, obj);

            AddListnerToSingleGObject(obj);

            GComponent gComponent = obj as GComponent;
            if (gComponent != null)
            {
                foreach (GObject child in gComponent.GetChildren())
                {
                    AddListenerToChilder(child, sName);
                }
            }
        }

        private void AddListnerToSingleGObject(GObject obj)
        {
            if (null == obj)
            {
                return;
            }

            if (obj is GButton)
            {
                //Debug.Log("<color=#00FFFF>UITester</color>Add Listner for GButton ID:" + obj.id + " Name:" + obj.name);
                //Add Capture，因为如果执行的时候遇到Error，会忽略掉这个
                obj.onClick.AddCapture(OnClick);
            }
            else
            {
                GTextInput input = obj as GTextInput;
                if (input != null)
                {
                    //Debug.Log("<color=#00FFFF>UITester</color>Add Listner for GTextInput ID:" + obj.id + " Name:" + obj.name);
                    //Add Capture，因为如果执行的时候遇到Error，会忽略掉这个
                    input.onChanged.AddCapture(OnChanged);
                }
            }
        }

        private void StartRecord()
        {
            m_Record = new UITestReplay();
            m_lRecordingTime = DateTime.Now.ToFileTimeUtc();
            m_eState = EUITestState.Recording;
        }

        private void StopRecord()
        {
            m_sUITestStoreScriptName = GetPossibleFileName();
            m_eState = EUITestState.RecordingSaving;
        }

        private void PauseRecord()
        {
            m_Record.RecordKeyFrame((int)(DateTime.Now.ToFileTimeUtc() - m_lRecordingTime), "", UITestEvent.Pause, null);
            m_CheckList.Clear();
            m_eState = EUITestState.RecordingPause;
        }

        private void ResumeRecord()
        {
            ApplyCheckers();
            m_lRecordingTime = DateTime.Now.ToFileTimeUtc();
            m_eState = EUITestState.Recording;
        }

        /// <summary>
        /// 为了在Pause以及Save的时候，避免误点击到真正的UI组件。此时应当挡住后面的UI
        /// </summary>
        private void BlockScreen()
        {
            Stage.inst.SetCustomInput(Vector2.zero, false);
        }

        #region Listners 记录UI事件,用于重放UI操作

        private void OnClick(EventContext context)
        {
            if (null == m_Record)
            {
                //not even start record
                return;
            }

            GButton button = context.sender as GButton;
            if (button != null)
            {
                string sGObjectName = GetFullName(button);
                long lNow = DateTime.Now.ToFileTimeUtc();
                m_Record.RecordKeyFrame((int)(lNow - m_lRecordingTime), sGObjectName, UITestEvent.OnClick, null);
                m_lRecordingTime = lNow;

                Debug.Log("<color=#00FFFF>UITester</color>Click ID:" + GetFullName(button));
            }
        }

        private void OnClickLink(EventContext context)
        {

        }

        private void OnDrageStart(EventContext context)
        {
            if (context.sender is GList)
            {
                Debug.Log("<color=#00FFFF>UITester</color>ID:" + (context.sender as GObject).id);
            }
        }

        private void OnDrageEnd(EventContext context)
        {
            if (context.sender is GList)
            {
                Debug.Log("<color=#00FFFF>UITester</color>ID:" + ((GObject) context.sender).id);
            }
        }

        private void OnChanged(EventContext context)
        {
            if (null == m_Record)
            {
                //not even start record
                return;
            }

            GTextInput gTextInput = context.sender as GTextInput;
            if (gTextInput != null)
            {
                string sGObjectName = GetFullName(gTextInput);
                long lNow = DateTime.Now.ToFileTimeUtc();
                m_Record.RecordKeyFrame((int)(lNow - m_lRecordingTime), sGObjectName, UITestEvent.OnChanged, context.data);
                m_lRecordingTime = lNow;

                Debug.Log("<color=#00FFFF>UITester</color>OnChanged ID:" + gTextInput.id + " Content:" + context.data);
            }
        }

        #endregion

        #region Checkers 记录需要检查的UI元素

        private readonly Dictionary<string, UITestReplay.UITestReplayOneFrame> m_CheckList = new Dictionary<string, UITestReplay.UITestReplayOneFrame>();

        private void AddImageCheck(string sName, string sValue)
        {
            if (m_CheckList.ContainsKey(sName))
            {
                m_CheckList[sName] = new UITestReplay.UITestReplayOneFrame
                {
                    m_iTimeInterval = 0,
                    m_sObjectName = sName,
                    m_eEvent = UITestEvent.CheckImage,
                    m_pEventData = sValue,
                };
            }
            else
            {
                m_CheckList.Add(sName, new UITestReplay.UITestReplayOneFrame
                {
                    m_iTimeInterval = 0,
                    m_sObjectName = sName,
                    m_eEvent = UITestEvent.CheckImage,
                    m_pEventData = sValue,
                });
            }
        }

        private void AddTextCheck(string sName, string sValue)
        {
            if (m_CheckList.ContainsKey(sName))
            {
                m_CheckList[sName] = new UITestReplay.UITestReplayOneFrame
                {
                    m_iTimeInterval = 0,
                    m_sObjectName = sName,
                    m_eEvent = UITestEvent.CheckText,
                    m_pEventData = sValue,
                };
            }
            else
            {
                m_CheckList.Add(sName, new UITestReplay.UITestReplayOneFrame
                {
                    m_iTimeInterval = 0,
                    m_sObjectName = sName,
                    m_eEvent = UITestEvent.CheckText,
                    m_pEventData = sValue,
                });
            }
        }

        private void RemoveCheck(string sName)
        {
            if (null != m_CheckList && m_CheckList.ContainsKey(sName))
            {
                m_CheckList.Remove(sName);
            }
        }

        private void ApplyCheckers()
        {
            if (null != m_Record)
            {
                foreach (KeyValuePair<string, UITestReplay.UITestReplayOneFrame> kvp in m_CheckList)
                {
                    m_Record.RecordKeyFrame(0, kvp.Value.m_sObjectName, kvp.Value.m_eEvent, kvp.Value.m_pEventData);
                }
            }

            m_CheckList.Clear();
        }

        #endregion

        #endregion

        #region Replaying 重播

        private List<UITestReplay.UITestReplayOneFrame> m_ReplayFrames;
        private long m_lReplayTime;
        private static string m_sScriptSection = "";

        private string[] m_sAllGeneratedScripts;
        private string[] m_sAllCombinedScripts;

        private static string StripFileName(string sFile)
        {
            string sRet = sFile.Replace("\\", "/");
            int iStart = sRet.LastIndexOf('/');
            return sRet.Substring(iStart + 1, sRet.Length - (iStart + 1) - 4);
        }

        private void FindAllTestFiles()
        {
            DirectoryInfo dic = new DirectoryInfo(LuaPath + GenerateSubFolder);
            List<string> generatedScripts = new List<string>();
            if (dic.Exists)
            {
                foreach (FileInfo files in dic.GetFiles("*.lua"))
                {
                    generatedScripts.Add(StripFileName(files.FullName));
                }
                m_sAllGeneratedScripts = generatedScripts.ToArray();
            }
            DirectoryInfo dic2 = new DirectoryInfo(LuaPath + CombineSubFolder);
            List<string> combineScripts = new List<string>();
            if (dic2.Exists)
            {
                foreach (FileInfo files in dic2.GetFiles("*.txt"))
                {
                    combineScripts.Add(StripFileName(files.FullName));
                }
                m_sAllCombinedScripts = combineScripts.ToArray();
            }
        }

        private void EnterReplay()
        {
            FindAllTestFiles();
            m_eState = EUITestState.ReplayNotStart;
        }

        private void StartReplay(EUITestChooseFrom eChoose, string sScriptName)
        {
            m_ReplayFrames = null;
            string sExcuteName = LuaExcuteStartFolder + (eChoose == EUITestChooseFrom.Generate ? GenerateSubFolder : CombineSubFolder) + sScriptName;
            string sFunctionName = string.Format("UITestFunction{0}_{1}", eChoose == EUITestChooseFrom.Generate ? "" : "Comb", sScriptName);
            Debug.Log("<color=#00FFFF>UITest</color> Start Replay:" + sExcuteName + ":" + sFunctionName);
            if (null != m_LuaDoFile && null != m_LuaCallFunction)
            {
                m_LuaDoFile(sExcuteName);
                m_LuaCallFunction(sFunctionName);
            }
            else
            {
                Debug.LogWarning("No Lua Do File and Call Function!");
            }
        }

        private T GetGObject<T>(string sId) where T : GObject
        {
            string[] ids = sId.Split('.');
            GComponent next = GRoot.inst;
            for (int i = 0; i < ids.Length - 1; ++i)
            {
                bool bFound = false;
                foreach (GObject child in next.GetChildren())
                {
                    if (child.id.Equals(ids[i]) && child is GComponent)
                    {
                        next = child as GComponent;
                        bFound = true;
                        break;
                    }
                }
                if (!bFound)
                {
                    return null;
                }
            }

            foreach (GObject child in next.GetChildren())
            {
                if (child.id.Equals(ids[ids.Length - 1]) && child is T)
                {
                    return child as T;
                }
            }

            return null;
        }

        private void PerformKeyFrame()
        {
            if (0 == m_ReplayFrames.Count)
            {
                StopReplay();
                return;
            }

            switch (m_ReplayFrames[0].m_eEvent)
            {
                case UITestEvent.Pause:
                    long lNow = DateTime.Now.ToFileTimeUtc();
                    m_ReplayFrames[0].m_iTimeInterval -= (int) (lNow - m_lReplayTime);
                    m_lReplayTime = lNow;
                    if (m_ReplayFrames[0].m_iTimeInterval < 0)
                    {
                        m_ReplayFrames.RemoveAt(0);
                    }
                    break;
                case UITestEvent.OnClick:
                    Debug.Log("<color=#00FFFF>UITest</color> Script Click:" + m_ReplayFrames[0].m_sObjectName);
                    GButton bt = GetGObject<GButton>(m_ReplayFrames[0].m_sObjectName);
                    if (null == bt)
                    {
                        RecordUITestLog(UITestError.CannotFindGObject, m_ReplayFrames[0].m_sObjectName);
                        OnFailToDoNextUICommand();
                        StopReplay();
                    }
                    else
                    {
                        bt.onClick.BubbleCall();    
                        m_ReplayFrames.RemoveAt(0);
                    }
                    break;
                case UITestEvent.OnChanged:
                    GTextInput input = GetGObject<GTextInput>(m_ReplayFrames[0].m_sObjectName);
                    if (null == input)
                    {
                        RecordUITestLog(UITestError.CannotFindGObject, m_ReplayFrames[0].m_sObjectName);
                        OnFailToDoNextUICommand();
                        StopReplay();
                    }
                    else
                    {
                        input.onChanged.BubbleCall(m_ReplayFrames[0].m_pEventData);
                        m_ReplayFrames.RemoveAt(0);
                    }
                    break;
                case UITestEvent.CheckText:
                    GTextField txf = GetGObject<GTextField>(m_ReplayFrames[0].m_sObjectName);
                    if (null == txf)
                    {
                        RecordUITestLog(UITestError.CannotFindGObject, m_ReplayFrames[0].m_sObjectName);
                        OnFailToDoNextUICommand();
                        StopReplay();
                    }
                    else
                    {
                        if (!txf.text.Equals(m_ReplayFrames[0].m_pEventData))
                        {
                            RecordUITestLog(UITestError.CheckText, m_ReplayFrames[0].m_sObjectName);
                        }
                        m_ReplayFrames.RemoveAt(0);
                    }
                    break;
                case UITestEvent.CheckImage:
                    GImage img = GetGObject<GImage>(m_ReplayFrames[0].m_sObjectName);
                    if (null == img)
                    {
                        RecordUITestLog(UITestError.CannotFindGObject, m_ReplayFrames[0].m_sObjectName);
                        OnFailToDoNextUICommand();
                        StopReplay();
                    }
                    else
                    {
                        if (!img.resourceURL.Equals(m_ReplayFrames[0].m_pEventData))
                        {
                            RecordUITestLog(UITestError.CheckImage, m_ReplayFrames[0].m_sObjectName);
                        }
                        m_ReplayFrames.RemoveAt(0);
                    }
                    break;
            }
        }

        private void ClearReplay()
        {
            Debug.Log("<color=#00FFFF>UITest</color> Clear Replay");
            if (null == m_ReplayFrames)
            {
                m_ReplayFrames = new List<UITestReplay.UITestReplayOneFrame>();
            }
            else
            {
                m_ReplayFrames.Clear();
            }
        }

        private void AddReplayFrame(UITestReplay.UITestReplayOneFrame frame)
        {
            if (null == m_ReplayFrames || EUITestState.ReplayNotStart != m_eState)
            {
                Debug.Log("<color=#00FFFFF>UITest</color> Add Replay Fail");
                return;
            }
            m_ReplayFrames.Add(frame);
        }

        private void StopReplay()
        {
            Debug.Log("<color=#00FFFF>UITest</color> Stop Replay");
            m_eState = EUITestState.ReplayNotStart;
            m_ReplayFrames = null;
        }

        private void FinishQueue()
        {
            m_eState = EUITestState.ReplayReplaying;
            m_lReplayTime = DateTime.Now.ToFileTimeUtc();            
        }

        #region UI Commands

        [LuaCallCSharp]
        public static void EnterSection(string sSectionName)
        {
            if (!IsSupported())
            {
                return;
            }
            m_sScriptSection = sSectionName;
        }

        [LuaCallCSharp]
        public static void StartTestCommandQueue()
        {
            if (null == Instance || !IsSupported())
            {
                return;
            }
            Instance.ClearReplay();
        }

        [LuaCallCSharp]
        public static void AddInterval(int iMilliseconds)
        {
            if (null == Instance || !IsSupported())
            {
                return;
            }
            Instance.AddReplayFrame(new UITestReplay.UITestReplayOneFrame
            {
                m_eEvent = UITestEvent.Pause,
                m_iTimeInterval = iMilliseconds * 10000,
            });
        }

        [LuaCallCSharp]
        public static void AddClick(string sName)
        {
            if (null == Instance || !IsSupported())
            {
                return;
            }
            Instance.AddReplayFrame(new UITestReplay.UITestReplayOneFrame
            {
                m_eEvent = UITestEvent.OnClick,
                m_sObjectName = sName,
            });
        }

        [LuaCallCSharp]
        public static void AddSetText(string sName, string sContent)
        {
            if (null == Instance || !IsSupported())
            {
                return;
            }
            Instance.AddReplayFrame(new UITestReplay.UITestReplayOneFrame
            {
                m_eEvent = UITestEvent.OnChanged,
                m_pEventData = sContent,
                m_sObjectName = sName,
            });
        }

        [LuaCallCSharp]
        public static void FinishTestCommandQueue()
        {
            if (null == Instance || !IsSupported())
            {
                return;
            }
            Instance.FinishQueue();
        }

        #endregion

        #region UICheckers

        [LuaCallCSharp]
        public static void CheckText(string sName, string sContent)
        {
            if (null == Instance || !IsSupported())
            {
                return;
            }
            Instance.AddReplayFrame(new UITestReplay.UITestReplayOneFrame
            {
                m_eEvent = UITestEvent.CheckText,
                m_pEventData = sContent,
                m_sObjectName = sName,
            });
        }

        [LuaCallCSharp]
        public static void CheckImage(string sName, string sContent)
        {
            if (null == Instance || !IsSupported())
            {
                return;
            }
            Instance.AddReplayFrame(new UITestReplay.UITestReplayOneFrame
            {
                m_eEvent = UITestEvent.CheckImage,
                m_pEventData = sContent,
                m_sObjectName = sName,
            });
        }

        #endregion

        #endregion

        #region 脚本合并

        private List<string> m_sCombineList = new List<string>();
        private string m_sCurrentCombineScriptName = "";

        private void EnterCombine()
        {
            FindAllTestFiles();
            m_sCombineList.Clear();
            m_eState = EUITestState.Combining;
        }

        /// <summary>
        /// 读取一个被合并的脚本（比如用来修改或者另存为）
        /// </summary>
        /// <param name="sCombineName">合并脚本名</param>
        private void LoadCombine(string sCombineName)
        {
            string sToLoadTxt = LuaPath + CombineSubFolder + sCombineName + ".txt";
            string sContent = File.ReadAllText(sToLoadTxt);
            string[] sub = sContent.Split(',');
            m_sCombineList = sub.ToList();
        }

        /// <summary>
        /// 重新合并所有脚本
        /// </summary>
        private void ReCombineAll()
        {
            for (int i = 0; i < m_sAllCombinedScripts.Length; ++i)
            {
                string sFileName = m_sAllCombinedScripts[i];
                string sToLoadTxt = LuaPath + CombineSubFolder + sFileName + ".txt";
                string sContent = File.ReadAllText(sToLoadTxt);
                string[] sub = sContent.Split(',');
                CombineAndSave(sFileName, sub);
            }
        }

        /// <summary>
        /// 合并脚本
        /// </summary>
        /// <param name="sScirptName">合并后的脚本名</param>
        /// <param name="sSubScript">被合并的脚本列表</param>
        private static void CombineAndSave(string sScirptName, string[] sSubScript)
        {
            //Save .txt
            string sToSaveTxt = LuaPath + CombineSubFolder + sScirptName + ".txt";
            string sSaveContent = "";
            for (int i = 0; i < sSubScript.Length; ++i)
            {
                sSaveContent += (0 == i) ? (sSubScript[i]) : ("," + sSubScript[i]);
            }
            File.WriteAllText(sToSaveTxt, sSaveContent);

            //Save .lua
            string sToSaveLua = LuaPath + CombineSubFolder + sScirptName + ".lua";
            sSaveContent = "";
            for (int i = 0; i < sSubScript.Length; ++i)
            {
                string sSubFile = LuaPath + GenerateSubFolder + sSubScript[i] + ".lua";
                string sScriptContent = File.ReadAllText(sSubFile);
                Match m = Regex.Match(sScriptContent,
                    @"CS\.LPCFramework\.UITesterManager\.StartTestCommandQueue\(\)[\s\S]*CS\.LPCFramework\.UITesterManager\.FinishTestCommandQueue\(\)");
                sScriptContent = m.Value;
                sScriptContent = sScriptContent.Replace("CS.LPCFramework.UITesterManager.StartTestCommandQueue()", "");
                sScriptContent = sScriptContent.Replace("CS.LPCFramework.UITesterManager.FinishTestCommandQueue()", "");

                sSaveContent += sScriptContent;
            }

            sSaveContent = 
                "--由UITest自动生成的脚本\n\n"
                + string.Format("function UITestFunctionComb_{0}()\n", sScirptName)
                + "    --开始测试\n"
                + "    CS.LPCFramework.UITesterManager.StartTestCommandQueue()\n\n"
                + sSaveContent
                + "CS.LPCFramework.UITesterManager.FinishTestCommandQueue()\n\n"
                + "end\n";

            File.WriteAllText(sToSaveLua, sSaveContent, Encoding.UTF8);
        }

        /// <summary>
        /// 需要被合并的脚本全部存在
        /// </summary>
        /// <returns></returns>
        private bool CanSaveCombine()
        {
            if (m_sCombineList.Count < 1)
            {
                return false;
            }
            for (int i = 0; i < m_sCombineList.Count; ++i)
            {
                if (string.IsNullOrEmpty(m_sCombineList[i]) || !m_sAllGeneratedScripts.Contains(m_sCombineList[i]))
                {
                    return false;
                }
            }
            return true;
        }

        #endregion

        #region Error Handling 目前直接发到Log里

        /// <summary>
        /// UI操作无法进行（比如，需要点击的按钮不存在）
        /// 等待有热重启后，再实现配套的逻辑
        /// </summary>
        private void OnFailToDoNextUICommand()
        {
            if (null != m_HotReboot)
            {
                m_HotReboot();
            }
        }

        /// <summary>
        /// 记录发生错误
        /// </summary>
        /// <param name="error">错误代码</param>
        /// <param name="sMsg">详细消息</param>
        public static void RecordUITestLog(UITestError error, string sMsg)
        {
            if (null != m_Log)
            {
                m_Log(string.Format("ScriptSession:{2} ErrorCode {0} : {1}", error, sMsg, m_sScriptSection));
            }
            else
            {
                Debug.Log(string.Format("ScriptSession:{2} ErrorCode {0} : {1}", error, sMsg, m_sScriptSection));
            }
        }

        /// <summary>
        /// 记录发生错误
        /// </summary>
        /// <param name="sMsg">详细消息</param>
        [LuaCallCSharp]
        public static void RecordUITestLog(string sMsg)
        {
            RecordUITestLog(UITestError.FromLuaScript, sMsg);
        }

        #endregion
    }
}