using System.Collections.Generic;
using UnityEngine;
using UnityEditor;
using System;
using System.IO;

[CustomEditor(typeof(MeshTexUV))]
public class MeshTexUVEditor : Editor
{ 
    public MeshTexUV MeshTex
    {
        get
        {
            return (target as MeshTexUV);
        }
    }


    public override void OnInspectorGUI()
    {
        EditorGUILayout.BeginHorizontal();
        GUILayout.Label(new GUIContent("SourceMeshFilter", "The Source MeshFilter To Gen"));
        MeshTex.OriMeshFilter = EditorGUILayout.ObjectField(new GUIContent(string.Empty, "SourceMeshFilter"), MeshTex.OriMeshFilter, typeof(MeshFilter), true) as MeshFilter;
        EditorGUILayout.EndHorizontal();


        EditorGUILayout.BeginHorizontal();
        GUILayout.Label(new GUIContent("SourceTexture", "The Source Texture To Gen"));
        MeshTex.OriTexture = EditorGUILayout.ObjectField(new GUIContent(string.Empty, "SourceTexture"), MeshTex.OriTexture, typeof(Texture), true) as Texture;
        EditorGUILayout.EndHorizontal();

        EditorGUILayout.BeginHorizontal();
        GUILayout.Label(new GUIContent("MapSize", "The Size Of The Map"));

        if (MeshTex.OriMeshFilter == null)
        {
            MeshTex.OriMeshFilter = MeshTex.gameObject.GetComponent<MeshFilter>();
        }
        if(MeshTex.OriMeshFilter != null)
        {
            Vector3 vMeshSize = MeshTex.OriMeshFilter.sharedMesh.bounds.extents;
            int GroundSize = (int)Math.Ceiling(Mathf.Min(vMeshSize.x, vMeshSize.z) * 2);
            EditorGUILayout.TextField(new GUIContent(string.Empty, "MapSize"), GroundSize.ToString());
        }
        else
            EditorGUILayout.TextField(new GUIContent(string.Empty, "MapSize"), "读取地图大小错误！");

        EditorGUILayout.EndHorizontal();

        EditorGUILayout.BeginHorizontal();
        GUILayout.Label(new GUIContent("MapTextureName", "New Blend MapTextureName "));
        MeshTex.SavedName = EditorGUILayout.TextField(new GUIContent(string.Empty, "MapTextureName"), MeshTex.SavedName);
        EditorGUILayout.EndHorizontal();

        //EditorGUILayout.BeginHorizontal();
        //GUILayout.Label(new GUIContent("SourceTemp", "The Source Temp To Gen"));
        //MeshTex.Temp = EditorGUILayout.ObjectField(new GUIContent(string.Empty, "SourceTemp"), MeshTex.Temp, typeof(GameObject), true) as GameObject;
        //EditorGUILayout.EndHorizontal();

        GUILayout.BeginVertical();
        bool newgen = GUILayout.Button(new GUIContent("New UV and Tex", "Will Generate new Mesh and new Texture"));
        if (newgen)
        {
            BeginNewTexture();
        }
        GUILayout.EndVertical();
    }

    internal struct VectexInfo
    {
        public Vector3 vertex;
        public Vector2 uv;
    }

    internal class Triangle
    {
        public Triangle()
        {
            vertices = new VectexInfo[3];            
        }
        public VectexInfo[] vertices;
    }

    void BeginNewTexture()
    {
        //if (MeshTex.OriTexture == null || MeshTex.OriMeshFilter == null)
        //    return;

        if (MeshTex.OriMeshFilter == null)
        {
            MeshTex.OriMeshFilter = MeshTex.gameObject.GetComponent<MeshFilter>();
        }

        if (MeshTex.OriMeshFilter == null)
        {
            EditorUtility.DisplayDialog("错误", "没有mesh数据!", "OK");            
            return;
        }


        if (MeshTex.OriTexture == null)
        {
            EditorUtility.DisplayDialog("错误", "地图原始贴图丢失，请重新勾选，并且将原始图的 read/write 设置为enable，还有问题请找jeremy", "OK");
            return;
        }

        if (string.IsNullOrEmpty(MeshTex.SavedName))
        {
            if (EditorUtility.DisplayDialog("错误", "blend贴图名称不能为空~ ，OK自动命名，NO手动命名", "OK", "NO"))
            {
                MeshTex.SavedName = MeshTex.OriTexture.name + "_blend";
            }
            else
                return;
        }

        Vector3 vMeshSize = MeshTex.OriMeshFilter.sharedMesh.bounds.extents;
        int GroundSize = (int)Math.Ceiling(Mathf.Min(vMeshSize.x, vMeshSize.z) * 2);


        string filesavadpath = Application.dataPath + "/ArtAssets/MapBlender/";
        if (!Directory.Exists(filesavadpath))
        {
            Directory.CreateDirectory(filesavadpath);
        }
        string filename = filesavadpath + MeshTex.SavedName + ".png";
        if (File.Exists(filename))
        {
            string info = string.Format("当前存在贴图 :{0} ,是否要覆盖？ OK覆盖，NO取消", filename);
            if (!EditorUtility.DisplayDialog("错误", info, "OK", "NO"))
                return;
        }
        

        float RayHeight = 500;
        Texture2D tex = (Texture2D)MeshTex.OriTexture;

        m_AreaTriangles.Clear();

        int mapwidth = GroundSize;
        int mapheight = GroundSize;
        int piece = 24;
        AreaSize = new Vector2((float) mapwidth / piece, (float)mapheight / piece);

        //for (int x = -mapwidth / 2;x<mapwidth / 2;x++)
        //{
        //    for (int y = -mapheight / 2;y<mapheight / 2;y++)
        //    {
        //        sAreaIndex index = new sAreaIndex(x,y);
        //        AreaTriangles atringles = new AreaTriangles();
        //        m_AreaTriangles.Add(index, atringles);
        //    }
        //}

        for (int x = -piece / 2; x <= piece / 2; x++)
        {
            for (int y = -piece / 2; y <= piece / 2; y++)
            {
                sAreaIndex index = new sAreaIndex(x, y);
                AreaTriangles atringles = new AreaTriangles();
                m_AreaTriangles.Add(index, atringles);
            }
        }


        float percent = 0;
        EditorUtility.DisplayProgressBar("提示", "贴图生成中..", percent);

        try
        {                    
            Mesh orimesh = MeshTex.OriMeshFilter.sharedMesh;
            int[] triangles = orimesh.triangles;
            //Debug.Log(triangles.Length);

            Vector3[] vertices = orimesh.vertices;
            Vector2[] uvs = orimesh.uv;
            //Debug.Log(vertices.Length);

            List<Triangle> Triangles = new List<Triangle>();

            int tindex = 0;
            int[] triangle = new int[3];
            for (int i = 0; i < triangles.Length; i++)
            {
                if (tindex == 3)
                {
                    tindex = 0;
                    Triangle tri = new Triangle();

                    tri.vertices[0].vertex = MeshTex.transform.TransformPoint(vertices[triangle[0]]);
                    tri.vertices[0].uv = uvs[triangle[0]];
                    sAreaIndex index0 = getIndexFromPos(tri.vertices[0].vertex);

                    if (!m_AreaTriangles.ContainsKey(index0))
                        m_AreaTriangles.Add(index0, new AreaTriangles());
                                        
                    if (!m_AreaTriangles[index0].areaTriangles.Contains(tri))
                        m_AreaTriangles[index0].areaTriangles.Add(tri);
                   


                    tri.vertices[1].vertex = MeshTex.transform.TransformPoint(vertices[triangle[1]]);
                    tri.vertices[1].uv = uvs[triangle[1]];
                    sAreaIndex index1 = getIndexFromPos(tri.vertices[1].vertex);

                    if (!m_AreaTriangles.ContainsKey(index1))
                        m_AreaTriangles.Add(index1, new AreaTriangles());
              
                    if (!m_AreaTriangles[index1].areaTriangles.Contains(tri))
                        m_AreaTriangles[index1].areaTriangles.Add(tri);
           

                    tri.vertices[2].vertex = MeshTex.transform.TransformPoint(vertices[triangle[2]]);
                    tri.vertices[2].uv = uvs[triangle[2]];
                    sAreaIndex index2 = getIndexFromPos(tri.vertices[2].vertex);

                    if (!m_AreaTriangles.ContainsKey(index2))
                        m_AreaTriangles.Add(index2, new AreaTriangles());

                    if (!m_AreaTriangles[index2].areaTriangles.Contains(tri))
                        m_AreaTriangles[index2].areaTriangles.Add(tri);

                    Triangles.Add(tri);
                    //Debug.Log(tri.vertices[0] + "  " + tri.vertices[1] + "  " + tri.vertices[2]);
                }

                triangle[tindex] = triangles[i];
                tindex++;
            }
            
            int texwidth = tex.width;
            int texheight = tex.height;
            int calccount = texwidth * texheight;


            float wpiece = (float)mapwidth / texwidth;
            float hpiece = (float)mapheight / texheight;

            Vector2 leftbtm = new Vector2(-mapwidth / 2, -mapheight / 2);


            Texture2D newtex = new Texture2D(texwidth, texheight, TextureFormat.RGBA32, false);

            float addvalue = 0;

            for (int i = 0; i < texwidth; i++)
            {
                for (int j = 0; j < texheight; j++)
                {
                    Vector2 samplepos = leftbtm + new Vector2(wpiece * i, hpiece * j);
                    Vector3 raypos = new Vector3(samplepos.x, RayHeight, samplepos.y);
                    //Debug.LogError("ray pos :"+raypos);
                    RaycastHit meshhitInfo;

                    if (Physics.Raycast(raypos, new Vector3(0, -1, 0), out meshhitInfo, 5000, 1 << LayerMask.NameToLayer("WorldmapGround")))
                    {
                        //Debug.LogError("meshhit " + meshhitInfo.transform.name + "   " + meshhitInfo.collider.name + "   " + meshhitInfo.point + "   "+meshhitInfo.textureCoord);
                        Vector3 meshpoint = meshhitInfo.point;
                        Triangle insidetri = null;
                        //GameObject go = GameObject.Instantiate(MeshTex.Temp);
                        //go.transform.parent = MeshTex.transform;
                        //go.transform.position = meshhitInfo.point;
                        sAreaIndex index = getIndexFromPos(meshpoint);

                        Color test = tex.GetPixelBilinear(meshhitInfo.textureCoord.x, meshhitInfo.textureCoord.y);
                        newtex.SetPixel(i, j, test);
                        /*
                        if (m_AreaTriangles.ContainsKey(index))
                        {
                            findTriangle(index,meshpoint,out insidetri);
                            //foreach (var tri in m_AreaTriangles)
                            //{
                            //    foreach (var _tri in tri.Value.areaTriangles)
                            //    {
                            //        if (PointinTriangle(_tri.vertices[0].vertex, _tri.vertices[1].vertex, _tri.vertices[2].vertex, meshpoint))
                            //        {
                            //            insidetri = _tri;
                            //            break;
                            //        }
                            //    }
                            //}
                            
                            //foreach (var tri in m_AreaTriangles[index].areaTriangles)
                            //{
                            //    if (PointinTriangle(tri.vertices[0].vertex, tri.vertices[1].vertex, tri.vertices[2].vertex, meshpoint))
                            //    {
                            //        insidetri = tri;
                            //        break;
                            //    }
                            //}

                            if (insidetri != null)
                            {
                                Vector2 uv = UV3(insidetri, meshpoint);
                                //地图uv是反的。
                                //uv = Vector2.one - uv;
                                Color texcolor = tex.GetPixel((int)(uv.x * texwidth), (int)(uv.y * texheight));
                                newtex.SetPixel(i, j, texcolor);
                            }
                            else
                            {
                                //newtex.SetPixel(i, j, Color.clear);
                                //Debug.LogWarning("can not find tri ! "+meshpoint);
                                //continue;
                                //newtex.SetPixel(i, j, tex.GetPixel(i,j));
                                //开始递归四周寻找三角形
                                
                                int addfind = 0;
                                bool shouldfind = true;

                                while (true)
                                {
                                    addfind++;

                                    sAreaIndex lb = index - new sAreaIndex(addfind, addfind);
                                    sAreaIndex rt = index + new sAreaIndex(addfind, addfind);
                   
                                    bool findtri = false;
                                    for (int m = lb.x; m <= rt.x; m++)//top/bottom grids
                                    {
                                        sAreaIndex tempIndex = new sAreaIndex(m, rt.y);//top y                                        
                                        findtri = findTriangle(tempIndex, meshpoint, out insidetri);
                                        if (findtri)
                                            break;

                                        tempIndex = new sAreaIndex(m, lb.y);//btm y
                                        findtri = findTriangle(tempIndex, meshpoint, out insidetri);
                                        if (findtri)
                                            break;
                                    }

                                    for (int n = lb.y; n <= rt.y; n++)// left/right
                                    {
                                        sAreaIndex tempIndex = new sAreaIndex(rt.x, n);// top x
                                        findtri = findTriangle(tempIndex, meshpoint, out insidetri);
                                        if (findtri)
                                            break;

                                        tempIndex = new sAreaIndex(lb.x, n);//btm x
                                        findtri = findTriangle(tempIndex, meshpoint, out insidetri);
                                        if (findtri)
                                            break;
                                    }

                                    if (findtri)
                                    {
                                        Vector2 uv = UV3(insidetri, meshpoint);
                                        //地图uv是反的。
                                        //uv = Vector2.one - uv;
                                        Color texcolor = tex.GetPixel((int)(uv.x * texwidth), (int)(uv.y * texheight));
                                        newtex.SetPixel(i, j, texcolor);
                                        break;
                                    }    
                                    else
                                    {
                                        if (!m_AreaTriangles.ContainsKey(lb) && !m_AreaTriangles.ContainsKey(rt))
                                        {
                                            //Debug.LogError("Fail to find Triangle !!!!!!!!!!!  Never Happen!!!! index is :" + index + "   lb:" + lb + "   rt:" + rt);
                                            //return;
                                            Debug.LogError("Fail to find Triangle !!!!!!!!!!!  Never Happen!!!! index is :" + index + "   lb:" + lb + "   rt:" + rt);
                                            newtex.SetPixel(i, j, Color.clear);
                                            break;
                                        }
                                    }                
                                }
                            }
                        }  
                        else
                        {
                            Debug.LogError("Not Find Index :" + index);
                            newtex.SetPixel(i, j, Color.clear);
                        }*/

                    }
                    else
                    {
                        newtex.SetPixel(i, j, Color.clear);
                    }
                    addvalue++;
                    percent = addvalue / calccount;
                    EditorUtility.DisplayProgressBar("提示", "贴图生成中..", percent);
                }
            }

            newtex.Apply();

            byte[] bs = newtex.EncodeToPNG();
            //string path = Application.dataPath + "/Resources/BigMap.png";
            FileStream fs = new FileStream(filename, FileMode.Create);
            fs.Write(bs, 0, bs.Length);
            fs.Flush();
            fs.Close();
            AssetDatabase.Refresh();
        }
        catch (System.Exception ex)
        {
            Debug.LogError(ex.Message + "   " + ex.StackTrace);
        }
        finally
        {
            EditorUtility.ClearProgressBar();
        }

    }

    bool findTriangle(sAreaIndex index,Vector3 meshpoint,out Triangle insidetri)
    {
        insidetri = null;
        if (!m_AreaTriangles.ContainsKey(index)) return false;

        foreach (var tri in m_AreaTriangles[index].areaTriangles)
        {
            if (PointinTriangle(tri.vertices[0].vertex, tri.vertices[1].vertex, tri.vertices[2].vertex, meshpoint))
            {
                insidetri = tri;
                return true;
            }
        }
        return false;
    }


    Vector2 UV(Triangle triangle,Vector3 point)
    {
        Vector2 uv = Vector2.zero;

        Vector2 uv0 = triangle.vertices[0].uv;
        Vector3 pos0 = triangle.vertices[0].vertex;

        Vector2 uv1 = triangle.vertices[1].uv;
        Vector3 pos1 = triangle.vertices[1].vertex;

        Vector2 uv2 = triangle.vertices[2].uv;
        Vector3 pos2 = triangle.vertices[2].vertex;


        Vector3 v01 = (pos1 - pos0).normalized;
        Vector3 v02 = (pos2 - pos0).normalized;
        Vector3 v0new = (point - pos0).normalized;

        float d0n00 = Vector3.Distance(point, pos0);
        float d0100 = Vector3.Distance(pos1,pos0);
        float d0200 = Vector3.Distance(pos2, pos0);
        
        float dot010n = Vector3.Dot(v01, v0new);
        float dot020n = Vector3.Dot(v02, v0new);

        float m0n01 = d0n00 * dot010n;
        float m0n02 = d0n00 * dot020n;


        uv = uv0 + m0n01/ d0100 * (uv1 - uv0) + m0n02/ d0200 * (uv2 - uv0);

        return uv; 
    }

    Vector2 UV2(Triangle triangle, Vector3 point)
    {
        Vector2 uv = Vector2.zero;

        Vector2 uv0 = triangle.vertices[0].uv;
        Vector3 pos0 = triangle.vertices[0].vertex;

        Vector2 uv1 = triangle.vertices[1].uv;
        Vector3 pos1 = triangle.vertices[1].vertex;

        Vector2 uv2 = triangle.vertices[2].uv;
        Vector3 pos2 = triangle.vertices[2].vertex;

        Vector3 ab = (pos1 - pos0).normalized;
        Vector3 ac = (pos2 - pos0).normalized;
        Vector3 ap = (point - pos0).normalized;

        Vector3 axb = Vector3.Cross(ab, ac).normalized;

        Vector3 ab_x_axb = Vector3.Cross(ab, axb);
        Vector3 axb_x_ac = Vector3.Cross(axb, ac);
        Vector3 x2 = ab_x_axb / (Vector3.Dot(ac, ab_x_axb));
        Vector3 x3 = axb_x_ac / (Vector3.Dot(ab, axb_x_ac));

        float x = Vector3.Dot(x2, ap);
        float y = Vector3.Dot(x3, ap);

        uv = uv0 + x * uv2 + y * uv1;

        return uv;
    }

    Vector2 UV3(Triangle triangle, Vector3 point)
    {
        /*
             var f1 = p1-f;
             var f2 = p2-f;
             var f3 = p3-f;
             // calculate the areas and factors (order of parameters doesn't matter):
             var a: float = Vector3.Cross(p1-p2, p1-p3).magnitude; // main triangle area a
             var a1: float = Vector3.Cross(f2, f3).magnitude / a; // p1's triangle area / a
             var a2: float = Vector3.Cross(f3, f1).magnitude / a; // p2's triangle area / a 
             var a3: float = Vector3.Cross(f1, f2).magnitude / a; // p3's triangle area / a
             // find the uv corresponding to point f (uv1/uv2/uv3 are associated to p1/p2/p3):
             var uv: Vector2 = uv1 * a1 + uv2 * a2 + uv3 * a3; 
         */


        Vector2 uv = Vector2.zero;

        Vector2 uv0 = triangle.vertices[0].uv;
        Vector3 pos0 = triangle.vertices[0].vertex;

        Vector2 uv1 = triangle.vertices[1].uv;
        Vector3 pos1 = triangle.vertices[1].vertex;

        Vector2 uv2 = triangle.vertices[2].uv;
        Vector3 pos2 = triangle.vertices[2].vertex;

        Vector3 f1 = (pos0 - point).normalized;
        Vector3 f2 = (pos1 - point).normalized;
        Vector3 f3 = (pos2 - point).normalized;
        Vector3 v01 = (pos0 - pos1).normalized;
        Vector3 v02 = (pos0 - pos2).normalized;


        float a  = Vector3.Cross(v01, v02).magnitude; // main triangle area a
        float a1  = Vector3.Cross(f2, f3).magnitude / a; 
        float a2  = Vector3.Cross(f3, f1).magnitude / a;  
        float a3  = Vector3.Cross(f1, f2).magnitude / a; 
                                                          
        uv = uv0 * a1 + uv1 * a2 + uv2 * a3;
        Debug.LogError(uv);
        return uv;
    }
    Vector2 UV4(Triangle triangle, Vector3 point)
    {
        Vector2 uv = Vector2.zero;

        Vector2 uv0 = triangle.vertices[0].uv;
        Vector3 pos0 = triangle.vertices[0].vertex;

        Vector2 uv1 = triangle.vertices[1].uv;
        Vector3 pos1 = triangle.vertices[1].vertex;

        Vector2 uv2 = triangle.vertices[2].uv;
        Vector3 pos2 = triangle.vertices[2].vertex;

        uv = (uv0 + uv1 + uv2) / 3;
        return uv;
    }

    bool PointinTriangle(Vector3 A, Vector3 B, Vector3 C, Vector3 P)
    {
        //(P'-A).(B-A)


        Vector3 v0 = (C - A).normalized;
        Vector3 v1 = (B - A).normalized;
        Vector3 v2 = (P - A).normalized;

        float dot00 = Vector3.Dot(v0, v0);
        float dot01 = Vector3.Dot(v0, v1);
        float dot02 = Vector3.Dot(v0, v2);
        float dot11 = Vector3.Dot(v1, v1);
        float dot12 = Vector3.Dot(v1, v2);


        //float fDot = Vector3.Dot((P - A), Vector3.Cross(B - A, C - A));
        //if (fDot > 0.01f || fDot < -0.01f)
        //{
        //    //不在这个平面内
        //    return false;
        //}


        float inverDeno = 1 / (dot00 * dot11 - dot01 * dot01);

        float u = (dot11 * dot02 - dot01 * dot12) * inverDeno;
        if (u < 0 || u > 1) 
        {
            return false;
        }

        float v = (dot00 * dot12 - dot01 * dot02) * inverDeno;
        if (v < 0 || v > 1) 
        {
            return false;
        }

        return u + v <= 1;


        /*Vector3 pos0 = A;

        Vector3 pos1 = B;

        Vector3 pos2 = C;

        Vector3 ab = (pos1 - pos0).normalized;
        Vector3 ac = (pos2 - pos0).normalized;
        Vector3 ap = (P - pos0).normalized;

        Vector3 axb = Vector3.Cross(ab, ac).normalized;

        Vector3 ab_x_axb = Vector3.Cross(ab, axb);
        Vector3 axb_x_ac = Vector3.Cross(axb, ac);
        Vector3 x2 = ab_x_axb / (Vector3.Dot(ac, ab_x_axb));
        Vector3 x3 = axb_x_ac / (Vector3.Dot(ab, axb_x_ac));

        float x = Vector3.Dot(x2, ap);
        float y = Vector3.Dot(x3, ap);
        return x >= 0 && y >= 0 && (x + y) <= 1;*/

    }

    Vector2 AreaSize = Vector2.zero;
    Dictionary<sAreaIndex, AreaTriangles> m_AreaTriangles = new Dictionary<sAreaIndex, AreaTriangles>();

    sAreaIndex getIndexFromPos(Vector3 pos)
    {        
        int i = Mathf.FloorToInt(pos.x / AreaSize.x);
        int j = Mathf.FloorToInt(pos.z / AreaSize.y);
        return new sAreaIndex(i, j);        
    }

    Vector3 getPosFromIndex(sAreaIndex index)
    {
        return Vector3.zero;
    }

    internal class AreaTriangles
    {
        public List<Triangle> areaTriangles = new List<Triangle>();
    }

    public struct sAreaIndex
    {
        public int x;
        public int y;
        
        public sAreaIndex(int _x,int _y)
        {
            x = _x;
            y = _y;
        }        

        public static sAreaIndex Zero()
        {
            return new sAreaIndex(0,0);
        }

        public static sAreaIndex operator +(sAreaIndex a, sAreaIndex b)
        {
            return new sAreaIndex(a.x + b.x, a.y + b.y);
        }

        public static sAreaIndex operator -(sAreaIndex a, sAreaIndex b)
        {
            return new sAreaIndex(a.x - b.x, a.y - b.y);
        }

        public static bool operator == (sAreaIndex s1,sAreaIndex s2)
        {
            return s1.x == s2.x && s1.y == s2.y;
        }
        public static bool operator !=(sAreaIndex s1, sAreaIndex s2)
        {
            return s1.x != s2.x || s1.y != s2.y;
        }

        public override bool Equals(object obj)
        {
            sAreaIndex s = (sAreaIndex)obj;
            if (s == null)
                return false;
            return this.x == s.x && this.y == s.y;
        }

        public override string ToString()
        {
            return string.Format("{0}:{1}",x,y);
        }
    }
}

