using System;
using System.Collections;
using System.Collections.Generic;
using System.IO;
using UnityEngine;
using UnityEditor;

namespace LPCFramework
{
    public class TerrainToMeshConverter : EditorWindow
    {
        [MenuItem("GameObject/Terrain to Mesh/Terrain to Mesh")]
        public static void ShowWindow()
        {
            GetWindow(typeof (TerrainToMeshConverter));
        }

        private Terrain m_pTerrain = null;
        private int m_iVertexCount = -1;
        private bool m_bCurveFace = false;
        private float m_fCurveRadius = 5.0f;
        private float m_fCurveDegree = 40.0f;
        private float m_fWaterHeight = 0.0f;
        private float m_fMinHeight = 0.0f;
        private float m_fMaxHeight = 0.0f;
        private Color m_cSpecturalChannel1 = new Color(0.0f, 0.0f, 0.0f, 0.0f);
        private Color m_cSpecturalChannel2 = new Color(0.0f, 0.0f, 0.0f, 0.0f);

        private string[] m_sSplatTexturePath = null;
        private string[] m_sAlphaTexturePath = null;

        /// <summary>
        /// 写无压缩的bmp文件
        /// </summary>
        /// <param name="vPlaneVertex"></param>
        /// <param name="fMin"></param>
        /// <param name="fMax"></param>
        /// <param name="iVertexCount"></param>
        /// <returns></returns>
        public static byte[] EncodeToBMPFile(Vector3[] vPlaneVertex, float fMin, float fMax, int iVertexCount)
        {

            int iRowSize = iVertexCount * 3;
            if (0 != iVertexCount % 4)
            {
                iRowSize = ((iVertexCount * 24 + 31) / 32) * 4;
            }
            int iFileSize = 54 + iVertexCount * iRowSize;
            using (BinaryWriter brw =
                new BinaryWriter(new MemoryStream()))
            {
                //tagBITMAPFILEHEADER(14bit)
                brw.Write((ushort)0x4D42); //bfType
                brw.Write((uint)iFileSize); //bfSize
                brw.Write((ushort)0); //bfReserved1
                brw.Write((ushort)0); //bfReserved2
                brw.Write((uint)54); //bfOffBits, no color table

                //tagBITMAPINFOHEADER(40bit)
                brw.Write((uint)40); //biSize, no color table
                brw.Write((uint)iVertexCount); //biWidth
                brw.Write((uint)iVertexCount); //biHeight
                brw.Write((ushort)1); //biPlanes
                brw.Write((ushort)24); //biBitCount
                brw.Write((uint)0); //biCompression
                brw.Write((uint)(iVertexCount * iRowSize)); //biSizeImage (including padding!)
                brw.Write((uint)0); //biXPelsPerMeter
                brw.Write((uint)0); //biYPelsPerMeter
                brw.Write((uint)0); //biClrUsed
                brw.Write((uint)0); //biClrImportant

                for (int i = 0; i < iVertexCount; ++i)
                {
                    for (int j = 0; j < iVertexCount; ++j)
                    {
                        float fHeight = Mathf.Clamp01((vPlaneVertex[i * iVertexCount + j].y - fMin) / (fMax - fMin));
                        int iHeight = Mathf.RoundToInt(fHeight * (1 << 24));
                        iHeight = Mathf.Clamp(iHeight, 0, (1 << 24) - 1);
                        byte iR = (byte)Mathf.Clamp(iHeight / (1 << 16), 0, 255);
                        byte iG = (byte)Mathf.Clamp( (iHeight % (1 << 16)) / 8, 0, 255);
                        byte iB = (byte)Mathf.Clamp(iHeight % 8, 0, 255);
                        brw.Write(iB);
                        brw.Write(iG);
                        brw.Write(iR);
                    }
                    for (int j = 0; j < iRowSize - iVertexCount*3; ++j)
                    {
                        brw.Write((byte)0);
                    }
                    //Debug.Log(ii);
                }
                brw.Flush();

                int iLength = (int)brw.BaseStream.Length;
                Debug.Assert(iLength == iFileSize);
                using (BinaryReader binReader = new BinaryReader(brw.BaseStream))
                {
                    binReader.BaseStream.Position = 0;
                    byte[] bytes = binReader.ReadBytes(iLength);
                    brw.BaseStream.Read(bytes, 0, iLength);
                    return bytes;
                }
            }
        }

        /// <summary>
        /// Terrain转换器的UI
        /// </summary>
        private void OnGUI()
        {
            m_pTerrain = (Terrain) EditorGUILayout.ObjectField("选择Terrain", m_pTerrain, typeof (Terrain), true);

            if (null != m_pTerrain && null != m_pTerrain.terrainData)
            {
                if (m_iVertexCount < 0)
                {
                    m_iVertexCount = Mathf.Clamp(m_pTerrain.terrainData.heightmapResolution, 4, 253);
                }
                m_iVertexCount = EditorGUILayout.IntSlider("精细程度", m_iVertexCount, 4, 253);
                m_fWaterHeight = EditorGUILayout.FloatField("水面高度", m_fWaterHeight);

                //暂时去掉高光
                //m_cSpecturalChannel1 = EditorGUILayout.ColorField("高光通道1", m_cSpecturalChannel1);
                //m_cSpecturalChannel2 = EditorGUILayout.ColorField("高光通道2", m_cSpecturalChannel2);

                m_bCurveFace = true; //EditorGUILayout.Toggle("曲面", m_bCurveFace); 去掉对平面的支持
                if (m_bCurveFace)
                {
                    m_fCurveDegree = EditorGUILayout.Slider("弯曲程度", m_fCurveDegree, 0.001f, 60.0f);
                }

                if (GUILayout.Button("转换"))
                {
                    string sFolder = EditorUtility.SaveFolderPanel("生成的Mesh保存文件夹",
                        Application.dataPath + "/TempPrefabs/TerrainToMesh/Converted", "");
                    if (Directory.Exists(sFolder))
                    {
                        ConvertMesh(sFolder);
                    }
                }
            }
        }

        /// <summary>
        /// 这是一个不好描述的函数。总之就是把Terrain变成Mesh
        /// </summary>
        /// <param name="sOutputFolder"></param>
        private void ConvertMesh(string sOutputFolder)
        {
            string sOutFolder = sOutputFolder.Replace("\\", "/");
            string sDataFolder = Application.dataPath.Replace("\\", "/");            

            EditorUtility.DisplayProgressBar("Working", string.Format("{0}: ({1} / {2})", "Create Textures", 1, 5), 0.2f);

            #region Create Textures

            Color[] cTable =
            {
                Color.black, Color.black, Color.black, Color.black, Color.black, Color.black, Color.black,
                Color.black,
            };

            //=============================================
            //Create Textures
            int iSplatMapCount = m_pTerrain.terrainData.splatPrototypes.Length;
            if (iSplatMapCount > 8 || iSplatMapCount < 5)
            {
                Debug.LogError("暂时仅支持贴图数量5-8的Terrain");
                return;
            }
            m_sSplatTexturePath = new string[iSplatMapCount];

            for (int i = 0; i < iSplatMapCount; ++i)
            {
                SplatPrototype splat = m_pTerrain.terrainData.splatPrototypes[i];
                string sTexturePath = AssetDatabase.GetAssetPath(splat.texture);
                sTexturePath = Application.dataPath.Substring(0, Application.dataPath.Length - 6) + sTexturePath;
                string sOutFilePath = sTexturePath.Replace("\\", "/");
                int iLastSlash = sTexturePath.LastIndexOf('/');
                sOutFilePath = sOutputFolder + sOutFilePath.Substring(iLastSlash, sTexturePath.Length - iLastSlash);
                File.Copy(sTexturePath, sOutFilePath, true);
                m_sSplatTexturePath[i] = sOutFilePath;

                Texture2D purecolor = new Texture2D(2, 2);
                purecolor.LoadImage(File.ReadAllBytes(sTexturePath));
                cTable[i] = purecolor.GetPixel(0, 0);
            }

            m_sAlphaTexturePath = new string[m_pTerrain.terrainData.alphamapTextures.Length];
            for (int i = 0; i < m_pTerrain.terrainData.alphamapTextures.Length; ++i)
            {
                byte[] txData = m_pTerrain.terrainData.alphamapTextures[i].EncodeToPNG();
                File.WriteAllBytes(sOutputFolder + "/Alpha_" + i + ".png", txData);
                m_sAlphaTexturePath[i] = sOutputFolder + "/Alpha_" + i + ".png";
            }

            int iControlWidth = m_pTerrain.terrainData.alphamapTextures[0].width;
            Texture2D pureColorTex = new Texture2D(iControlWidth, iControlWidth, TextureFormat.RGB24, false);
            //Texture2D specturalText = new Texture2D(iControlWidth, iControlWidth, TextureFormat.RGB24, false);
            Color[] c1 = m_pTerrain.terrainData.alphamapTextures[0].GetPixels();
            Color[] c2 = m_pTerrain.terrainData.alphamapTextures[1].GetPixels();
            Color[] c3 = new Color[iControlWidth*iControlWidth]; //纯色贴图
            //Color[] c4 = new Color[iControlWidth*iControlWidth];
            for (int i = 0; i < iControlWidth; ++i)
            {
                for (int j = 0; j < iControlWidth; ++j)
                {
                    Color cc1 = c1[i*iControlWidth + j];
                    Color cc2 = c2[i*iControlWidth + j];
                    c3[i*iControlWidth + j] =
                        cc1.r*cTable[0]
                        + cc1.g*cTable[1]
                        + cc1.b*cTable[2]
                        + cc1.a*cTable[3]
                        + cc2.r*cTable[4]
                        + cc2.g*cTable[5]
                        + cc2.b*cTable[6]
                        + cc2.a*cTable[7];

                    //去掉了高光的支持
                    //float fSpect = Mathf.Clamp01(
                    //    cc1.r*m_cSpecturalChannel1.r
                    //    + cc1.g*m_cSpecturalChannel1.g
                    //    + cc1.b*m_cSpecturalChannel1.b
                    //    + cc1.a*m_cSpecturalChannel1.a
                    //    + cc2.r*m_cSpecturalChannel2.r
                    //    + cc2.g*m_cSpecturalChannel2.g
                    //    + cc2.b*m_cSpecturalChannel2.b
                    //    + cc2.a*m_cSpecturalChannel2.a);
                    //c4[i*iControlWidth + j] = new Color(fSpect, fSpect, fSpect);
                }
            }
            pureColorTex.SetPixels(c3);
            pureColorTex.Apply();
            byte[] pureColor = pureColorTex.EncodeToPNG();
            File.WriteAllBytes(sOutputFolder + "/PureColor.PNG", pureColor);

            //specturalText.SetPixels(c4);
            //specturalText.Apply();
            //byte[] specColor = specturalText.EncodeToPNG();
            //File.WriteAllBytes(sOutputFolder + "/SpecturalChannel.PNG", specColor);

            #endregion

            EditorUtility.DisplayProgressBar("Working",
                string.Format("{0}: ({1} / {2})", "Create Material for Ground", 2, 5), 0.4f);

            #region Create Material for Ground

            if (2 != m_sAlphaTexturePath.Length)
            {
                Debug.LogWarning("我以为不会有4个贴图的Terrain了呢! 告诉我下");
            }
            else
            {
                AssetDatabase.Refresh(); //覆盖Mesh会报红字。放在保存Mesh前做这个事情。

                Material mat = new Material(Shader.Find("LPCFramework/TerrainToMesh2Layer"));
                mat.SetTexture("_Alpha1", AssetDatabase.LoadAssetAtPath<Texture2D>(GetAssetPath(m_sAlphaTexturePath[0])));
                mat.SetTexture("_Alpha2", AssetDatabase.LoadAssetAtPath<Texture2D>(GetAssetPath(m_sAlphaTexturePath[1])));

                string[] sKeys =
                {
                    "_Splat1", "_Splat2", "_Splat3", "_Splat4", "_Splat5", "_Splat6", "_Splat7", "_Splat8"
                };
                for (int i = 0; i < m_sSplatTexturePath.Length && i < 8; ++i)
                {
                    mat.SetTexture(sKeys[i],
                        AssetDatabase.LoadAssetAtPath<Texture2D>(GetAssetPath(m_sSplatTexturePath[i])));

                    mat.SetTextureScale(sKeys[i], m_pTerrain.terrainData.splatPrototypes[i].tileSize);
                    mat.SetTextureOffset(sKeys[i], m_pTerrain.terrainData.splatPrototypes[i].tileOffset);                    
                }                
                AssetDatabase.CreateAsset(mat, "Assets" + sOutFolder.Replace(sDataFolder, "") + "/GroundMaterial.mat");
            }

            string sPurcPath = sOutputFolder + "/PureColor.PNG";
            string sPurcSpecPath = sOutputFolder + "/SpecturalChannel.PNG";
            Material purC1 = new Material(Shader.Find("LPCFramework/TerrainToMeshPureColor"));
            purC1.SetTexture("_MainTex", AssetDatabase.LoadAssetAtPath<Texture2D>(GetAssetPath(sPurcPath)));
            purC1.SetTexture("_SpecturalRate", AssetDatabase.LoadAssetAtPath<Texture2D>(GetAssetPath(sPurcSpecPath)));
            AssetDatabase.CreateAsset(purC1, "Assets" + sOutFolder.Replace(sDataFolder, "") + "/PureColorSpec.mat");

            Material purC2 = new Material(Shader.Find("Mobile/Diffuse"));
            purC2.SetTexture("_MainTex", AssetDatabase.LoadAssetAtPath<Texture2D>(GetAssetPath(sPurcPath)));
            AssetDatabase.CreateAsset(purC2, "Assets" + sOutFolder.Replace(sDataFolder, "") + "/PureColor.mat");

            #endregion

            EditorUtility.DisplayProgressBar("Working",
                string.Format("{0}: ({1} / {2})", "Create Vertexes for ground", 3, 5), 0.6f);

            #region Create Vertexes for ground

            float fStep = 1.0f/(float) m_iVertexCount;
            Vector3[] vVertex = new Vector3[m_iVertexCount*m_iVertexCount];
            Vector2[] vUvs = new Vector2[m_iVertexCount*m_iVertexCount];

            //Traingle strip not supported
            //A line is iVertCount * 2, iVertCount - 1 lines, With (iVertCount - 1) * 2 degenerate trangles
            //int[] indexBuffer = new int[(m_iVertexCount - 1) * m_iVertexCount * 2 + (m_iVertexCount - 1) * 2];

            int[] indexBuffer = new int[(m_iVertexCount - 1) * (m_iVertexCount - 1) * 6];
            Vector3 vSize = Vector3.Scale(m_pTerrain.terrainData.heightmapScale,
                new Vector3(m_pTerrain.terrainData.heightmapWidth, 1.0f, m_pTerrain.terrainData.heightmapHeight));

            //=============================================
            //Create Vertexes
            Vector3[] vPlaneVertex = new Vector3[m_iVertexCount * m_iVertexCount];
            int iHalfCount = (m_iVertexCount - 1)/2;
            for (int i = 0; i < m_iVertexCount; ++i)
            {
                for (int j = 0; j < m_iVertexCount; ++j)
                {
                    float fX = i*fStep, fY = j*fStep;
                    
                    vVertex[i*m_iVertexCount + j] = new Vector3(
                        vSize.x*0.5f*(i - iHalfCount)/(float) iHalfCount,
                        m_pTerrain.terrainData.GetInterpolatedHeight(fX, fY),
                        vSize.z*0.5f*(j - iHalfCount)/(float) iHalfCount
                        );

                    vPlaneVertex[i * m_iVertexCount + j] = vVertex[i * m_iVertexCount + j];

                    vUvs[i*m_iVertexCount + j] = new Vector2(
                        Mathf.Clamp01(i/(float) (m_iVertexCount - 1)),
                        Mathf.Clamp01(j/(float) (m_iVertexCount - 1))
                        );

                    if (i < m_iVertexCount - 1 && j < m_iVertexCount - 1)
                    {
                        int iStart = (i*(m_iVertexCount - 1) + j)*6;
                        indexBuffer[iStart + 0] = (i + 0)*m_iVertexCount + (j + 0);
                        indexBuffer[iStart + 1] = (i + 0)*m_iVertexCount + (j + 1);
                        indexBuffer[iStart + 2] = (i + 1)*m_iVertexCount + (j + 0);

                        indexBuffer[iStart + 3] = (i + 1)*m_iVertexCount + (j + 0);
                        indexBuffer[iStart + 4] = (i + 0)*m_iVertexCount + (j + 1);
                        indexBuffer[iStart + 5] = (i + 1)*m_iVertexCount + (j + 1);
                    }

                    if (0 == i && 0 == j)
                    {
                        m_fMaxHeight = vVertex[i*m_iVertexCount + j].y;
                        m_fMinHeight = vVertex[i*m_iVertexCount + j].y;
                    }
                    else
                    {
                        m_fMaxHeight = vVertex[i*m_iVertexCount + j].y > m_fMaxHeight
                            ? vVertex[i*m_iVertexCount + j].y
                            : m_fMaxHeight;
                        m_fMinHeight = vVertex[i*m_iVertexCount + j].y < m_fMinHeight
                            ? vVertex[i*m_iVertexCount + j].y
                            : m_fMinHeight;
                    }
                }
            }

            Vector3[] vNormals = null;
            if (m_bCurveFace)
            {
                m_fCurveRadius = vSize.x * 0.5f / (Mathf.Sin(0.5f * m_fCurveDegree * Mathf.PI / 180.0f));
                vNormals = new Vector3[m_iVertexCount * m_iVertexCount];
                for (int i = 0; i < m_iVertexCount; ++i)
                {
                    for (int j = 0; j < m_iVertexCount; ++j)
                    {
                        float fDegreeX = m_fCurveDegree * 0.5f * (i - iHalfCount) / (float)iHalfCount;
                        float fDegreeY = m_fCurveDegree * 0.5f * (j - iHalfCount) / (float)iHalfCount;
                        vNormals[i*m_iVertexCount + j] =
                            (Quaternion.AngleAxis(fDegreeX, new Vector3(0.0f, 0.0f, -1.0f))
                            *Quaternion.AngleAxis(fDegreeY, new Vector3(1.0f, 0.0f, 0.0f))
                            )*Vector3.up;
                        vNormals[i*m_iVertexCount + j].Normalize();

                        vVertex[i*m_iVertexCount + j] =
                            vNormals[i * m_iVertexCount + j] * (m_fCurveRadius + vVertex[i * m_iVertexCount + j].y) 
                            - Vector3.up * m_fCurveRadius;
                    }
                }
            }

            string sVertexInfo = string.Format("VertexCount={0},\nWidth={1},\nMinHeight={2},\nMaxHeight={3},\nWaterHeight={4},\nIsCurve={5},\nCurveRadius={6},\nCurveDegree={7},",
                m_iVertexCount,
                vSize.x,
                m_fMinHeight,
                m_fMaxHeight,
                m_fWaterHeight,
                m_bCurveFace,
                m_fCurveRadius,
                m_fCurveDegree
                );

            File.WriteAllText(sOutputFolder + "/TerrainInfo.txt", sVertexInfo);

            // Traingle strip not supported in Unity5 anymore...
            //https://forum.unity3d.com/threads/draw-mesh-as-triangle-strip.149469/
            //让我回想起似乎以前看到过这个提示 "Use SetTriangles instead. Internally this function will convert the triangle strip to a list of triangles anyway."
            //现在直接没了？？What the fuck??!
            //http://www.learnopengles.com/android-lesson-eight-an-introduction-to-index-buffer-objects-ibos/
            /*
            for (int i = 0; i < m_iVertexCount - 1; ++i)
            {
                for (int j = 0; j < m_iVertexCount; ++j)
                {
                    indexBuffer[i * (m_iVertexCount + 1) * 2 + j + 0] = i * m_iVertexCount + j;
                    indexBuffer[i * (m_iVertexCount + 1) * 2 + j + 1] = (i + 1) * m_iVertexCount + j;
                }
                indexBuffer[i * (m_iVertexCount + 1) * 2 + m_iVertexCount + 0] = (i + 1) * m_iVertexCount + (m_iVertexCount - 1); //repeat last
                indexBuffer[i * (m_iVertexCount + 1) * 2 + m_iVertexCount + 1] = (i + 1) * m_iVertexCount + 0; //repeat start
            }
            */

            /*
            //Height map is also stored for decode height data, which is used for gameplay
            Texture2D heightMap = new Texture2D(m_iVertexCount, m_iVertexCount, TextureFormat.RGB24, false);
            for (int i = 0; i < m_iVertexCount; ++i)
            {
                for (int j = 0; j < m_iVertexCount; ++j)
                {
                    float fHeight = Mathf.Clamp01((vPlaneVertex[i * m_iVertexCount + j].y - m_fMinHeight) / (m_fMaxHeight - m_fMinHeight));
                    int iHeight = Mathf.FloorToInt(fHeight * (3 * 255));
                    iHeight = Mathf.Clamp(iHeight, 0, (1 << 24) - 1);
                    int iR = Mathf.Clamp(iHeight - (2 * 255), 0, 255);
                    int iG = Mathf.Clamp(iHeight - 255, 0 , 255);
                    int iB = Mathf.Clamp(iHeight, 0, 255);
                    Color color24 = new Color(
                        Mathf.Clamp01(iR/255.0f), 
                        Mathf.Clamp01(iG/255.0f),
                        Mathf.Clamp01(iB/255.0f));
                    heightMap.SetPixel(i, j, color24);
                }
            }
            byte[] htmapata = heightMap.EncodeToJPG();
                //Store as jpg file, when load, make it Alpha8 and alpha from greyscale
            File.WriteAllBytes(sOutputFolder + "/HeightMap.jpg", htmapata);
            */
            byte[] bmp = EncodeToBMPFile(vPlaneVertex, m_fMinHeight, m_fMaxHeight, m_iVertexCount);
            File.WriteAllBytes(sOutputFolder + "/UnCompressHeightMap.bmp", bmp);

            Mesh createdMesh = new Mesh {vertices = vVertex, uv = vUvs};
            //Line Strip is NOT a traingle strip! 那这货是干什么用的？
            //createdMesh.SetIndices(indexBuffer, MeshTopology.LineStrip, 0, true);
            createdMesh.SetIndices(indexBuffer, MeshTopology.Triangles, 0, true);
            createdMesh.RecalculateBounds();
            //TODO may change this: Calculated Normals seems not good enough.
            createdMesh.RecalculateNormals();
            createdMesh.UploadMeshData(true);

            AssetDatabase.CreateAsset(createdMesh, "Assets" + sOutFolder.Replace(sDataFolder, "") + "/GroundMesh.asset");

            #endregion

            EditorUtility.DisplayProgressBar("Working", string.Format("{0}: ({1} / {2})", "Create Water mesh", 4, 5),
                0.8f);

            #region Create Water mesh

            //=============================================
            //Create Water Mesh
            Dictionary<int, int> vertexTable = new Dictionary<int, int>();
            List<Vector3> newVertexBuffer = new List<Vector3>();
            List<Vector3> newNormalBuffer = new List<Vector3>();
            List<Vector2> newVertexBufferUV = new List<Vector2>();
            List<int> newIndexBuffer = new List<int>();

            for (int i = 0; i < indexBuffer.Length/3; ++i)
            {
                if (vPlaneVertex[indexBuffer[3 * i + 0]].y < m_fWaterHeight
                 || vPlaneVertex[indexBuffer[3 * i + 1]].y < m_fWaterHeight
                 || vPlaneVertex[indexBuffer[3 * i + 2]].y < m_fWaterHeight)
                {
                    for (int j = 0; j < 3; ++j)
                    {
                        int iIndex1;
                        if (vertexTable.ContainsKey(indexBuffer[3*i + j]))
                        {
                            iIndex1 = vertexTable[indexBuffer[3*i + j]];
                        }
                        else
                        {
                            vertexTable.Add(indexBuffer[3*i + j], newVertexBuffer.Count);
                            iIndex1 = newVertexBuffer.Count;
                            newVertexBuffer.Add(vPlaneVertex[indexBuffer[3 * i + j]]);
                            newVertexBufferUV.Add(vUvs[indexBuffer[3*i + j]]);
                            if (m_bCurveFace)
                            {
                                newNormalBuffer.Add(vNormals[indexBuffer[3 * i + j]]);    
                            }
                        }

                        newIndexBuffer.Add(iIndex1);
                    }
                }
            }

            if (newVertexBuffer.Count > 0)
            {
                Mesh createdWaterMesh = new Mesh
                {
                    vertices = newVertexBuffer.ToArray(),
                    uv = newVertexBufferUV.ToArray(),
                };
                if (m_bCurveFace)
                {
                    createdWaterMesh.SetNormals(newNormalBuffer);
                }
                createdWaterMesh.SetIndices(newIndexBuffer.ToArray(), MeshTopology.Triangles, 0, true);
                createdWaterMesh.RecalculateBounds();
                createdWaterMesh.UploadMeshData(true);

                AssetDatabase.CreateAsset(createdWaterMesh,
                    "Assets" + sOutFolder.Replace(sDataFolder, "") + "/WaterMesh.asset");
            }

            #endregion

            EditorUtility.ClearProgressBar();

            Debug.Log("Done!");
        }

        private static string GetAssetPath(string sFullPath, bool bHasSuffix = true)
        {
            string sDataFolder = Application.dataPath.Replace("\\", "/");
            string sRet = "Assets" + sFullPath.Replace("\\", "/").Replace(sDataFolder, "");
            if (!bHasSuffix)
            {
                int iLastDot = sRet.LastIndexOf('.');
                int iLastSlash = sRet.LastIndexOf('/');
                if (iLastDot > iLastSlash && iLastDot > 0)
                {
                    sRet = sRet.Substring(0, iLastDot);
                }
            }
            return sRet;
        }
    }
}
