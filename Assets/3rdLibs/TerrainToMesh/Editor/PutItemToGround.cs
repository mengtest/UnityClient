using System.Collections.Generic;
using UnityEditor;
using UnityEngine;
using UnityEngine.SceneManagement;

namespace LPCFramework
{
    public class PutItemToGround 
    {
        [MenuItem("GameObject/Terrain to Mesh/Put to ground")]
        private static void PutSelectedToGround()
        {
            GameObject bigMap = GameObject.Find("BigMap");
            if (null == bigMap)
            {
                Debug.LogError("场景中没有找到BigMap");
                return;
            }
            TerrainGroundCoordinate coord = bigMap.GetComponent<TerrainGroundCoordinate>();
            if (null == coord)
            {
                Debug.LogError("BigMap上没有脚本");
                return;
            }

            Object[] objects = Selection.objects;
            List<GameObject> toPut = new List<GameObject>();
            foreach (Object obj in objects)
            {
                if (obj is GameObject)
                {
                    GameObject go = obj as GameObject;
                    if (!string.IsNullOrEmpty(go.scene.name) && SceneManager.GetActiveScene().name.Equals(go.scene.name))
                    {
                        toPut.Add(go);
                    }
                }
            }

            if (0 == toPut.Count)
            {
                Debug.LogError("需要选中场景中的物件");
                return;
            }

            foreach (GameObject go in toPut)
            {
                TerrainGroundStaticItem item = go.GetComponent<TerrainGroundStaticItem>();
                if (null == item)
                {
                    item = go.AddComponent<TerrainGroundStaticItem>();
                }

                item.PutToGround(coord);
                //item.transform.parent = bigMap.transform;
            }
        }

        [MenuItem("GameObject/Terrain to Mesh/Put to ground Z up")]
        private static void PutSelectedToGroundZUp()
        {
            GameObject bigMap = GameObject.Find("BigMap");
            if (null == bigMap)
            {
                Debug.LogError("场景中没有找到BigMap");
                return;
            }
            TerrainGroundCoordinate coord = bigMap.GetComponent<TerrainGroundCoordinate>();
            if (null == coord)
            {
                Debug.LogError("BigMap上没有脚本");
                return;
            }

            Object[] objects = Selection.objects;
            List<GameObject> toPut = new List<GameObject>();
            foreach (Object obj in objects)
            {
                if (obj is GameObject)
                {
                    GameObject go = obj as GameObject;
                    if (!string.IsNullOrEmpty(go.scene.name) && SceneManager.GetActiveScene().name.Equals(go.scene.name))
                    {
                        toPut.Add(go);
                    }
                }
            }

            if (0 == toPut.Count)
            {
                Debug.LogError("需要选中场景中的物件");
                return;
            }

            foreach (GameObject go in toPut)
            {
                TerrainGroundStaticItem item = go.GetComponent<TerrainGroundStaticItem>();
                if (null == item)
                {
                    item = go.AddComponent<TerrainGroundStaticItem>();
                }

                item.PutToGround(coord, true);
                //item.transform.parent = bigMap.transform;
            }
        }
    }
}