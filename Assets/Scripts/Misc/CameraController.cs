using FairyGUI;
using UnityEngine;
#if !Arts
using XLua;
#endif

namespace LPCFramework
{
    public class CameraController : MonoBehaviour
    {
        [Header("是否反向")]
        public bool m_isReverse = false;
        [Header("坡度"), Range(0, 90)]
        public float m_gradient = 0;
        [Header("缩放因子")]
        public float m_zoomFactor = 0.01f;
        [Header("放大极限")]
        public float m_zoomInLimit = 20;
        [Header("缩小极限")]
        public float m_zoomOutLimit = 85;
        [Header("特写摄像机移动速度")]
        public float m_featureCamMoveSpeed = 2;
        [Header("平移速度(前后)")]
        public float m_moveSpeed = 5;
        [Header("向前最大距离")]
        public float m_frontMaxDis = 1;
        [Header("向后最大距离")]
        public float m_backMaxDis = 3;
        [Header("平移回弹距离-前")]
        public float m_frontSpringDis = 1;
        [Header("平移回弹距离-后")]
        public float m_backSpringDis = 2;
        [Header("回弹速度-前(向后)")]
        public float m_frontSpringSpeed = 2;
        [Header("回弹速度-后(向前)")]
        public float m_backSpringSpeed = 4;
        [Header("旋转速度(左右)")]
        public float m_rotateSpeed = 80;
        [Header("最大旋转角度-左")]
        public float m_leftMaxAngle = 60;
        [Header("最大旋转角度-右")]
        public float m_rightMaxAngle = 30;
        [Header("旋转回弹角度-左")]
        public float m_leftSpringAngle = 20;
        [Header("旋转回弹角度-右")]
        public float m_rightSpringAngle = 10;
        [Header("回弹速度-左(向右)")]
        public float m_leftSpringSpeed = 4;
        [Header("回弹速度-右(向左)")]
        public float m_rightSpringSpeed = 2;
        [Header("惯性"), Range(0, 1)]
        public float m_inertia = 0.8f;

        public Transform m_allBuildingCamerasTrans = null; // 所有相机的父节点
        private static Camera m_tavernCam = null;           // 酒馆摄像机
        private static Camera m_barrackCam = null;          // 军营摄像机
        private static Camera m_academyCam = null;          // 书院摄像机
        private static Camera m_practiceHallCam = null;     // 修炼馆摄像机
        private static Camera m_recruitmentCam = null;      // 外使院摄像机
        private static Camera m_smithyCam = null;           // 铁匠铺摄像机
        private static Camera m_warehouseCam = null;        // 仓库摄像机
        private static Camera m_feudalOfficialCam = null;   // 官府摄像机
        private static Camera m_rampartCam = null;          // 城墙摄像机
        private static Camera m_campsiteCam = null;         // 行营摄像机
        private static Camera m_mainCam = null;     // 主摄像机
        private static Transform m_center = null;   // 旋转中心点
        private bool canZoomIn = false;             // 可以放大
        private bool canZoomOut = false;            // 可以缩小
        private Transform m_originalTrans;
        private static Vector3 m_centerOriginalPos; // 中心初始坐标
        private static Vector3 m_centerOriginalEul; // 中心初始欧拉角
        private static Vector3 m_cameraOriginalPos; // 摄像机初始坐标
        private static Vector3 m_cameraOriginalEul; // 摄像机始欧拉角
        private static float m_cameraOriginalFOV;   // 摄像机始field of view
        private bool m_lock = false;                // zoom锁
        private static bool isBuildingCamState = false;    //是否是建筑摄像机
        private Touch m_oldTouch1;                  // 上次触摸点1
        private Touch m_oldTouch2;                  // 上次触摸点2
        private Touch m_newTouch1;                  // 本次触摸点1
        private Touch m_newTouch2;                  // 本次触摸点2
        private float m_oldDis;                     // 上次触摸2点距离
        private float m_newDis;                     // 本次触摸2点距离
        private float m_offset;                     // 2次触摸的差距
        private float m_zoomDelta;                  // 缩放增量
        private float m_deltaY;                     // Y轴方向增量(移动)
        private Vector3 m_newPos;                   // 新位置
        private float m_ExpectDis;                  // 预期距离
        private float m_ActualDis;                  // 实际距离
        private float m_deltaX;                     // X轴方向增量(旋转)
        private float m_mainCameraMoveTime;         // 摄像机移动的插值时间
        private static string m_buildingCamera;     // 建筑摄像机名称

        private void Start()
        {
            m_center = transform;
            m_mainCam = Camera.main;
            InitAllCameras();

            if (m_mainCam == null)
                return;

            m_originalTrans = transform;
            m_centerOriginalPos = transform.position;
            m_centerOriginalEul = transform.eulerAngles;
            m_cameraOriginalPos = m_mainCam.transform.position;
            m_cameraOriginalEul = m_mainCam.transform.eulerAngles;
            m_cameraOriginalFOV = m_mainCam.fieldOfView;
            // 初始化摄像机
            ResetCamera();
        }
        private void InitAllCameras()
        {
            if (m_allBuildingCamerasTrans == null)
                return;

            m_tavernCam = m_allBuildingCamerasTrans.Find("CameraTavern").GetComponent<Camera>();
            m_barrackCam = m_allBuildingCamerasTrans.Find("CameraBarrack").GetComponent<Camera>();
            m_academyCam = m_allBuildingCamerasTrans.Find("CameraAcademy").GetComponent<Camera>();
            m_practiceHallCam = m_allBuildingCamerasTrans.Find("CameraPracticeHall").GetComponent<Camera>();
            m_recruitmentCam = m_allBuildingCamerasTrans.Find("CameraRecruitment").GetComponent<Camera>();
            m_smithyCam = m_allBuildingCamerasTrans.Find("CameraSmithy").GetComponent<Camera>();
            m_warehouseCam = m_allBuildingCamerasTrans.Find("CameraWarehouse").GetComponent<Camera>();
            m_feudalOfficialCam = m_allBuildingCamerasTrans.Find("CameraFeudalOfficial").GetComponent<Camera>();
            m_rampartCam = m_allBuildingCamerasTrans.Find("CameraRampart").GetComponent<Camera>();
            m_campsiteCam = m_allBuildingCamerasTrans.Find("CameraCampsite").GetComponent<Camera>();
        }
        /// <summary>
        /// 重置摄像机
        /// </summary>
#if !Arts
        [LuaCallCSharp]
#endif
        public static void ResetCamera()
        {
            m_center.position = m_centerOriginalPos;
            m_center.eulerAngles = m_centerOriginalEul;
            m_mainCam.transform.position = m_cameraOriginalPos;
            m_mainCam.transform.eulerAngles = m_cameraOriginalEul;
            m_mainCam.fieldOfView = m_cameraOriginalFOV;
            m_buildingCamera = null;
            isBuildingCamState = false;
        }
        /// <summary>
        /// 缩放
        /// </summary>
        private void ZoomByTouch()
        {
            if (Input.touchCount != 2)
                return;

            m_newTouch1 = Input.GetTouch(0);
            m_newTouch2 = Input.GetTouch(1);

            // 第二个手指刚接触屏幕,只记录不处理
            if (m_newTouch2.phase == TouchPhase.Began)
            {
                m_oldTouch1 = m_newTouch1;
                m_oldTouch2 = m_newTouch2;
                return;
            }

            m_oldDis = Vector2.Distance(m_oldTouch1.position, m_oldTouch2.position);
            m_newDis = Vector2.Distance(m_newTouch1.position, m_newTouch2.position);

            // >0 放大, 反之缩小
            m_offset = m_newDis - m_oldDis;
            // 缩放增量/减量
            m_zoomDelta = m_offset * m_zoomFactor;
            // 限制
            if (m_mainCam.fieldOfView - m_zoomDelta > m_zoomInLimit && m_mainCam.fieldOfView - m_zoomDelta < m_zoomOutLimit)
                m_mainCam.fieldOfView -= m_zoomDelta;

            m_oldTouch1 = m_newTouch1;
            m_oldTouch2 = m_newTouch2;
        }
        /// <summary>
        /// 平移
        /// </summary>
        private void Transition()
        {
            // 移动
#if UNITY_STANDALONE || UNITY_EDITOR || UNITY_WEBGL
            if (Input.GetMouseButton(0))
            {
                int factor = 1;
#elif UNITY_IPHONE || UNITY_ANDROID
            if (Input.GetMouseButton(0) && Input.touchCount > 0 && Input.GetTouch(0).phase == TouchPhase.Moved)
            {
                float factor = 0.333333f;
#endif
                if (m_isReverse)
                {
                    m_deltaY = Input.GetAxis("Mouse Y") * m_moveSpeed * -1 * factor * Time.deltaTime;
                    m_newPos = new Vector3(m_center.position.x, m_center.position.y - Mathf.Tan(m_gradient * -1 * Mathf.PI / 180) * m_deltaY, m_center.position.z + m_deltaY);
                }
                else
                {
                    m_deltaY = Input.GetAxis("Mouse Y") * m_moveSpeed * factor * Time.deltaTime;
                    m_newPos = new Vector3(m_center.position.x, m_center.position.y - Mathf.Tan(m_gradient * Mathf.PI / 180) * m_deltaY, m_center.position.z + m_deltaY);
                }

                m_ExpectDis = m_newPos.z - m_centerOriginalPos.z;

                if (m_ExpectDis > -(m_frontMaxDis + m_frontSpringDis) && m_ExpectDis < m_backMaxDis + m_backSpringDis)
                    m_center.position = m_newPos;
            }
            else
            {
                m_ActualDis = m_center.position.z - m_centerOriginalPos.z;
                // 向后回弹
                if (m_ActualDis < -m_frontMaxDis)
                {
                    if (m_isReverse)
                    {
                        m_center.position = Vector3.Lerp(m_center.position,
                            new Vector3(m_center.position.x,
                            m_center.position.y - Mathf.Tan(m_gradient * -1 * Mathf.PI / 180) * m_frontMaxDis,
                            m_center.position.z + m_frontMaxDis), Time.deltaTime * m_frontSpringSpeed);
                    }
                    else
                    {
                        m_center.position = Vector3.Lerp(m_center.position,
                            new Vector3(m_center.position.x,
                            m_center.position.y - Mathf.Tan(m_gradient * Mathf.PI / 180) * m_frontMaxDis,
                            m_center.position.z + m_frontMaxDis), Time.deltaTime * m_frontSpringSpeed);
                    }
                }
                // 向前回弹
                else if (m_ActualDis > m_backMaxDis)
                {
                    if (m_isReverse)
                    {
                        m_center.position = Vector3.Lerp(m_center.position,
                        new Vector3(m_center.position.x,
                        m_center.position.y + Mathf.Tan(m_gradient * -1 * Mathf.PI / 180) * m_backMaxDis,
                        m_center.position.z - m_backMaxDis), Time.deltaTime * m_backSpringSpeed);
                    }
                    else
                    {
                        m_center.position = Vector3.Lerp(m_center.position,
                        new Vector3(m_center.position.x,
                        m_center.position.y + Mathf.Tan(m_gradient * Mathf.PI / 180) * m_backMaxDis,
                        m_center.position.z - m_backMaxDis), Time.deltaTime * m_backSpringSpeed);
                    }
                }
            }
        }
        /// <summary>
        /// 旋转
        /// </summary>
        private void Rotate()
        {
#if UNITY_STANDALONE || UNITY_EDITOR || UNITY_WEBGL
            if (Input.GetMouseButton(0))
            {
                int factor = 1;
#elif UNITY_IPHONE || UNITY_ANDROID
            if (Input.GetMouseButton(0) && Input.touchCount > 0 && Input.GetTouch(0).phase == TouchPhase.Moved)
            {
                float factor = 0.2f;
#endif
                m_deltaX = Input.GetAxis("Mouse X") * m_rotateSpeed * factor * Time.deltaTime;

                if (m_center.eulerAngles.y + m_deltaX < m_leftMaxAngle + m_leftSpringAngle || m_center.eulerAngles.y + m_deltaX > 360 - (m_rightMaxAngle + m_rightSpringAngle))
                    m_center.transform.Rotate(m_center.up, m_deltaX);
            }
            else
            {
                // 向右回弹
                if (m_leftSpringAngle > 0 && m_center.eulerAngles.y > m_leftMaxAngle && m_center.eulerAngles.y < 90)
                    m_center.eulerAngles = Vector3.Lerp(m_center.eulerAngles, new Vector3(m_center.eulerAngles.x, m_leftMaxAngle, m_center.eulerAngles.z), Time.deltaTime * m_leftSpringSpeed);
                // 向左回弹
                else if (m_rightSpringAngle > 0 && m_center.eulerAngles.y < 360 - m_rightMaxAngle && m_center.eulerAngles.y > 270)
                    m_center.eulerAngles = Vector3.Lerp(m_center.eulerAngles, new Vector3(m_center.eulerAngles.x, 360 - m_rightMaxAngle, m_center.eulerAngles.z), Time.deltaTime * m_rightSpringSpeed);

                // 惯性
                if (m_center.eulerAngles.y < m_leftMaxAngle || m_center.eulerAngles.y > 360 - m_rightMaxAngle)
                    m_center.eulerAngles += new Vector3(0, m_deltaX *= m_inertia, 0);
            }
        }
        /// <summary>
        /// 主摄像机移动到目标摄像机位置
        /// </summary>
        /// <param name="targetCamera">目标摄像机</param>
        private void MainCameraTransition(Camera targetCamera)
        {
            if (m_mainCam.transform.position == targetCamera.transform.position)
            {
                m_lock = false;
                return;
            }

            m_lock = true;
            m_mainCameraMoveTime = Time.deltaTime * m_featureCamMoveSpeed / (m_mainCam.transform.position - targetCamera.transform.position).magnitude;

            // position
            m_mainCam.transform.position = Vector3.Lerp(
                m_mainCam.transform.position,
               targetCamera.transform.position,
                m_mainCameraMoveTime);

            // rotation
            m_mainCam.transform.rotation = Quaternion.Lerp(
                m_mainCam.transform.rotation,
                targetCamera.transform.rotation,
                m_mainCameraMoveTime);

            // fov
            m_mainCam.fieldOfView = Mathf.Lerp(
                m_mainCam.fieldOfView,
                targetCamera.fieldOfView,
                m_mainCameraMoveTime);
        }
#if !Arts
        [LuaCallCSharp]
#endif
        public static void SetTargetCamera(string name)
        {
            isBuildingCamState = true;
            m_buildingCamera = name;
        }

        /// <summary>
        /// 直接切换到目标摄像机
        /// </summary>
        /// <param name="name"></param>
#if !Arts
        [LuaCallCSharp]
#endif
        public static void SwitchToTargetCamera(string name)
        {
            isBuildingCamState = false;
            Camera targetCam = null;

            switch (name)
            {
                case "Barrack":
                    targetCam = m_barrackCam; break;
                case "Tavern":
                    targetCam = m_tavernCam; break;
                case "Academy":
                    targetCam = m_academyCam; break;
                case "Warehouse":
                    targetCam = m_warehouseCam; break;
                case "FeudalOfficial":
                    targetCam = m_feudalOfficialCam; break;
                case "Rampart":
                    targetCam = m_rampartCam; break;
                case "Recruitment":
                    targetCam = m_recruitmentCam; break;
                case "Smithy":
                    targetCam = m_smithyCam; break;
                case "PracticeHall":
                    targetCam = m_practiceHallCam; break;
                case "Campsite":
                    targetCam = m_campsiteCam; break;
                default:
                    break;
            }

            m_mainCam.transform.position = targetCam.transform.position;
            m_mainCam.transform.rotation = targetCam.transform.rotation;
            m_mainCam.fieldOfView = targetCam.fieldOfView;
        }

        void Update()
        {
            if (!isBuildingCamState)
            {
                ZoomByTouch();

                if (!Stage.isTouchOnUI)
                {
#if UNITY_STANDALONE || UNITY_EDITOR || UNITY_WEBGL
                    Rotate();
                    Transition();
#elif UNITY_IPHONE || UNITY_ANDROID
                    if (Input.touchCount == 1)
	                {
                        Rotate();
                        Transition();
	                }
#endif
                }
            }
            else
            {
                switch (m_buildingCamera)
                {
                    case "Barrack":
                        MainCameraTransition(m_barrackCam); break;
                    case "Tavern":
                        MainCameraTransition(m_tavernCam); break;
                    case "Academy":
                        MainCameraTransition(m_academyCam); break;
                    case "Warehouse":
                        MainCameraTransition(m_warehouseCam); break;
                    case "FeudalOfficial":
                        MainCameraTransition(m_feudalOfficialCam); break;
                    case "Rampart":
                        MainCameraTransition(m_rampartCam); break;
                    case "Recruitment":
                        MainCameraTransition(m_recruitmentCam); break;
                    case "Smithy":
                        MainCameraTransition(m_smithyCam); break;
                    case "PracticeHall":
                        MainCameraTransition(m_practiceHallCam); break;
                    case "Campsite":
                        MainCameraTransition(m_campsiteCam); break;
                    default:
                        break;
                }
            }
        }
    }
}