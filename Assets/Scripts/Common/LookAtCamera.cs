using System.Collections;
using System.Collections.Generic;
using UnityEngine;

namespace LPCFramework
{
    public class LookAtCamera : MonoBehaviour
    {
        public enum LookAtType
        {
            None = -1,
            Z = 0,
            Point = 1,
        }

        public LookAtType lookAtType;
		public Vector3 lookAtOffset;
        private Transform targetCamera;
        private Vector3 targetDir;

        void Start()
        {
            targetCamera = Camera.main.transform;
        }

        void Update()
        {
            if (null == targetCamera)
            {
                return;
            }
            if (lookAtType == LookAtType.Z)
            {
				targetDir = -targetCamera.forward + lookAtOffset.normalized;
                transform.LookAt(transform.position + targetDir);
            }
            else if (lookAtType == LookAtType.Point)
            {
                transform.LookAt(targetCamera);
            }
        }
    }
}
