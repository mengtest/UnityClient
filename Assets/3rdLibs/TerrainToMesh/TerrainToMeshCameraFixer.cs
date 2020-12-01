using UnityEngine;

namespace LPCFramework
{

    [ExecuteInEditMode]
    public class TerrainToMeshCameraFixer : MonoBehaviour
    {

        public bool Fix = false;

        // Update is called once per frame
        private void Update()
        {
            if (Fix)
            {
                Fix = false;
                FindObjectOfType<TerrainGroundCoordinate>().SetCurrentCameraParameter(Camera.main);
            }
        }
    }
}