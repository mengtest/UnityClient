using UnityEngine;
using System.Collections.Generic;
using UnityEditor;
using System.IO;


[CustomEditor(typeof(MeshBlend))]
public class MeshBlendEditor : Editor
{                
    static float Radius = 1f;
    static float MaxRadius = 10f;
    static float Strength = 0.5f;

    static Dictionary<PaintTextureID, PaintTextureData> PaintData = new Dictionary<PaintTextureID, PaintTextureData>();
    static PaintTextureID curID = PaintTextureID.PaintTexture00;
    static PaintTextureID CurID
    {
        set
        {
            curID = value;

            foreach (var item in PaintData)
            {
                if (item.Key == curID)
                    item.Value.PaintTexture = true;
                else
                    item.Value.PaintTexture = false;
            }
        }
        get
        {
            return curID;
        }
    }


    [System.NonSerialized]
    public MeshBlendWindow PainterWindow;

    Vector2 _SceneTextPos;
    Vector2 _LastMousePos;
    bool _StrengthHotkeyDown;
    bool _RadiusHotkeyDown;
    bool _TexValHotkeyDown;
    bool _NormalValHotkeyDown;
    public MeshBlend Canvas
    {
        get
        {
            return (target as MeshBlend);
        }
    }

    void OnEnable()
    {        
        EditorWindow.FocusWindowIfItsOpen<MeshBlendWindow>();
        if (EditorWindow.focusedWindow is MeshBlendWindow)
        {
            PainterWindow = (EditorWindow.focusedWindow as MeshBlendWindow);
            PainterWindow.BlendEditor = this;
            PainterWindow.Repaint();
        }
    }
    void OnDisable()
    {
        if (!Canvas.SuppressDisable)
            UnlockObject();
    }


    void OnSceneGUI()
    {
        if (Event.current.type == EventType.ValidateCommand && Event.current.commandName == "UndoRedoPerformed")
        {
            Mesh mesh = Canvas.GetComponent<MeshFilter>().sharedMesh;
            Color[] colors = mesh.colors;
            mesh.colors = colors; // force the mesh to repaint by setting colors            
        }
        if (Canvas.Modifying)
        {
            if (Tools.current != Tool.None)
            {
                Canvas.ActiveTool = Tools.current;
                Tools.current = Tool.None;
            }
            bool newMouseDown = false;
            bool repaint = false;

            bool showSlideArrow = false;
            Event e = Event.current;
            if (e.type == EventType.MouseDown && e.button == 0)
            {

                if (!Canvas.WasMouseDown)
                {
                    newMouseDown = true;
                }
                Canvas.WasMouseDown = true;
                repaint = true;
            }
            else if (e.type == EventType.MouseDown && e.button == 1)
            {
                Canvas.RightMouseDown = true;
                repaint = true;
            }
            else if (e.type == EventType.MouseUp && e.button == 0)
            {
                Canvas.WasMouseDown = false;
                repaint = true;
            }
            else if (e.type == EventType.MouseUp && e.button == 1)
            {
                Canvas.RightMouseDown = false;
                repaint = true;
            }

            if (e.isKey && e.type == EventType.KeyDown)
            {
                bool consume = false;
                bool hotkeyDown = true;
                if (e.keyCode == KeyCode.Escape)
                    UnlockObject();
                else if (e.keyCode == KeyCode.B)
                    _RadiusHotkeyDown = true;
                else if (e.keyCode == KeyCode.A)
                    _StrengthHotkeyDown = true;
                else if (e.keyCode == KeyCode.S)
                    _TexValHotkeyDown = true;
                else if (e.keyCode == KeyCode.D)
                    _NormalValHotkeyDown = true;
                else
                    hotkeyDown = false;
                if (hotkeyDown)
                    repaint = true;
                if (consume)
                    Event.current.Use();
            }
            else if (e.isKey && e.type == EventType.KeyUp)
            {
                bool hotkeyUp = true;
                if (e.keyCode == KeyCode.B)
                    _RadiusHotkeyDown = false;
                else if (e.keyCode == KeyCode.A)
                    _StrengthHotkeyDown = false;
                else if (e.keyCode == KeyCode.S)
                    _TexValHotkeyDown = false;
                else if (e.keyCode == KeyCode.D)
                    _NormalValHotkeyDown = false;
                else if (e.keyCode == KeyCode.X)
                    Event.current.Use();
                else
                    hotkeyUp = false;

                if (hotkeyUp)
                    repaint = true;
            }
            if (e.isMouse)
            {
                _LastMousePos = e.mousePosition;
            }
            if (newMouseDown)
            {
                this._SceneTextPos = e.mousePosition;
            }
            if (!Canvas.RightMouseDown)
            {
                if (_StrengthHotkeyDown)
                {
                    showSlideArrow = true;
                    HotkeyHUD(newMouseDown, e, "Strength: " + Strength.ToString("N2"),
                        (evt, sceneTextPos) =>
                        {
                            if (Canvas.WasMouseDown)
                                Strength = Mathf.Clamp01(Strength + (e.delta.x / 350));
                        });
                }
                else if (_RadiusHotkeyDown)
                {
                    showSlideArrow = true;
                    if (e.type == EventType.Repaint)
                    {
                        Ray ray;
                        RaycastHit hitInfo;
                        DrawBrush(Canvas.WasMouseDown ? this._SceneTextPos : e.mousePosition, out ray, out hitInfo);
                    }
                    HotkeyHUD(newMouseDown, e, "Radius: " + Radius.ToString("N2"),
                        (evt, sceneTextPos) =>
                        {
                            if (Canvas.WasMouseDown)
                                Radius = Mathf.Clamp(Radius + (e.delta.x * MaxRadius / 350), 0, MaxRadius);
                        });

                }
                else
                {
                    Ray ray;
                    RaycastHit hitInfo;

                    if (DrawBrush(e.mousePosition, out ray, out hitInfo))
                    {
                        if (Canvas.WasMouseDown && !e.shift && !e.alt && !e.control)
                        {
                            if (Tools.current != Tool.None)
                            {
                                Tools.current = Tool.None;
                            }
                            Paint(Canvas, ray, hitInfo);                                           
                        }
                    }
                    repaint = true;
                }
                if (showSlideArrow)
                {
                    Vector2 pos = EditorGUIUtility.ScreenToGUIPoint(new Vector2(SceneView.currentDrawingSceneView.position.xMin, SceneView.currentDrawingSceneView.position.yMin));
                    Vector2 maxPos = EditorGUIUtility.ScreenToGUIPoint(new Vector2(SceneView.currentDrawingSceneView.position.xMax, SceneView.currentDrawingSceneView.position.yMax));
                    EditorGUIUtility.AddCursorRect(new Rect(pos.x, pos.y, maxPos.x - pos.x, maxPos.y - pos.y), MouseCursor.SlideArrow);
                    repaint = true;
                }
                if (e.type == EventType.MouseMove)
                {
                    repaint = true;
                }
                if (repaint)
                {
                    HandleUtility.Repaint();
                    Repaint();
                }
            }
            HandleUtility.AddDefaultControl(GUIUtility.GetControlID(FocusType.Passive));
        }
    }

    private void HotkeyHUD(bool newMouseDown, Event e, string text, System.Action<Event, Vector2> valueModAction)
    {
        if (newMouseDown)
        {
            _SceneTextPos = _LastMousePos;
        }
        Vector2 pos = _LastMousePos + new Vector2(15, 10);
        if (Canvas.WasMouseDown)
            pos = _SceneTextPos + new Vector2(15, 10);
        Ray guiRay = HandleUtility.GUIPointToWorldRay(pos);
        var labelStyle = EditorStyles.label;
        Color oldColor = labelStyle.normal.textColor;
        labelStyle.normal.textColor = Color.white;
        int oldSize = labelStyle.fontSize;
        labelStyle.fontSize = 25;
        Handles.Label(guiRay.origin + guiRay.direction * 1f, new GUIContent(text), labelStyle);
        labelStyle.fontSize = oldSize;
        labelStyle.normal.textColor = oldColor;
        valueModAction(e, _SceneTextPos);
    }


    public void Paint(MeshBlend canvas, Ray ray, RaycastHit hitInfo)
    {
        if (Canvas.Modifying)
        {           
            Mesh mesh = Canvas.GetComponent<MeshFilter>().sharedMesh;
            MeshCollider meshCollider = canvas.GetComponent<MeshCollider>();
            if (meshCollider != null)
            {
                if (meshCollider.sharedMesh != mesh)
                {
                    canvas.OrigColliderMesh = meshCollider.sharedMesh;
                    meshCollider.sharedMesh = mesh;
                }
            }

            Vector3[] vertices = mesh.vertices;
            Vector3[] normals = mesh.normals;
            if (normals == null || normals.Length == 0)
            {
                mesh.RecalculateNormals();
                normals = mesh.normals;
            }

            Color[] colors = mesh.colors;
            if (colors == null || colors.Length == 0)
                colors = new Color[vertices.Length];
            float radius = Radius; 
            float strength = Strength;

            bool modified = false;

            for (int i = 0; i < vertices.Length; i++)
            {
                Vector3 vWorldPos = canvas.transform.TransformPoint(vertices[i]);
                float distance = Vector3.Distance(vWorldPos, hitInfo.point);
                if (distance <= radius && Vector3.Dot(canvas.transform.TransformDirection(normals[i]), ray.direction) <= 0)
                {
                    float falloff = 1; Mathf.Clamp01(Mathf.Pow(360.0f, -Mathf.Pow(distance / radius, 2.5f) - 0.1f));
                    
                    float colorAdd = Mathf.Clamp01(falloff * Mathf.Pow(strength, 2));

                    
                    //Vector3 hitpos = vWorldPos;
                    //RaycastHit meshhitInfo;

                    //if (Physics.Raycast(hitpos, new Vector3(0, -1, 0), out meshhitInfo, 100, 1 << LayerMask.NameToLayer("WorldmapGround")))
                    //{
                    //    Debug.LogError("meshhit " + meshhitInfo.transform.name + "   " + meshhitInfo.collider.name + "   " + meshhitInfo.point);
                    //}



                    foreach (var pdata in PaintData)
                    {
                        if (pdata.Key == CurID && pdata.Value.PaintTexture)
                        {
                            switch (pdata.Key)
                            {
                                case PaintTextureID.PaintTexture00:                                    
                                        colors[i].r = Mathf.Lerp(colors[i].r, pdata.Value.TextureValue, colorAdd);                     
                                    break;
                                case PaintTextureID.PaintTexture01:                                    
                                        colors[i].g = Mathf.Lerp(colors[i].g, pdata.Value.TextureValue, colorAdd);         
                                    break;
                                case PaintTextureID.PaintTexture02:                                    
                                        colors[i].b = Mathf.Lerp(colors[i].b, pdata.Value.TextureValue, colorAdd);        
                                    break;
                                case PaintTextureID.PaintTexture03:                                    
                                        colors[i].a = Mathf.Lerp(colors[i].a, pdata.Value.TextureValue, colorAdd);              
                                    break;
                            }
                        }

                    }
                    modified = true;
                }
            }
            canvas.Modified = modified;
            if (modified)
            {
                mesh.colors = colors;                
            }            
        }
    }


    public override void OnInspectorGUI()
    {
        Canvas.SuppressDisable = false;
        MeshFilter meshFilter = Canvas.GetComponent<MeshFilter>();
        MeshRenderer renderer = Canvas.GetComponent<MeshRenderer>();

        GUILayout.BeginHorizontal();
        GUILayout.Label(new GUIContent("MapSize", "The Size Of The Map"));
        if (Canvas.coord.gameObject.GetComponent<MeshFilter>() != null)
        {
            Vector3 vMeshSize = Canvas.coord.gameObject.GetComponent<MeshFilter>().sharedMesh.bounds.extents;
            int GroundSize = (int)System.Math.Ceiling(Mathf.Min(vMeshSize.x, vMeshSize.z) * 2);
            EditorGUILayout.TextField(new GUIContent(string.Empty, "MapSize"), GroundSize.ToString());
        }
        else
            EditorGUILayout.TextField(new GUIContent(string.Empty, "MapSize"), "读取地图大小错误!");
        GUILayout.EndHorizontal();

        bool canModify = meshFilter.sharedMesh != null && renderer.sharedMaterial != null;
        if (!Canvas.Modifying)
        {

            bool meshIsSaved = false;
            if (canModify)
            {
                meshIsSaved = TerrainMeshBlendUtility.IsMeshSaved(meshFilter.sharedMesh);
            }
            else
            {
                if (meshFilter.sharedMesh == null)
                    GUILayout.Label(MeshBlendText.MeshRequired);
                if (renderer.sharedMaterial == null)
                    GUILayout.Label(MeshBlendText.MaterialRequired);
            }
            Color col = GUI.backgroundColor;
            Color contentCol = GUI.contentColor;
            GUI.backgroundColor = new Color(0.3f, 0.8f, 0.3f);
            GUI.contentColor = Color.white;
            GUILayout.BeginVertical();
            GUI.enabled = canModify && meshIsSaved;
            bool startModify = GUILayout.Button(new GUIContent(MeshBlendText.Modify, GUI.enabled ? MeshBlendText.ModifyTooltip : MeshBlendText.ModifyUnavailableTooltip));
            GUI.enabled = canModify;
            bool modifyAndSave = GUILayout.Button(new GUIContent(MeshBlendText.ModifyExisting, MeshBlendText.ModifyExistingTooltip));
            GUI.enabled = canModify && meshIsSaved;
            bool reset = GUILayout.Button(new GUIContent(MeshBlendText.ResetMat, MeshBlendText.ResetMatTooltip));

            GUI.contentColor = contentCol;
            GUI.backgroundColor = col;
            bool showWindow = GUILayout.Button(new GUIContent(MeshBlendText.ShowWindow, MeshBlendText.ShowWindowTooltip));
            if (showWindow)
            {
                PainterWindow = EditorWindow.GetWindow<MeshBlendWindow>();
                if (PainterWindow != null)
                {

                    PainterWindow.BlendEditor = this;
                }
            }
            GUI.enabled = true;
            GUILayout.EndVertical();
            if (modifyAndSave)
            {
                string[] labels = null;
                string assetPath = AssetDatabase.GetAssetPath(meshFilter.sharedMesh);
                if (string.IsNullOrEmpty(assetPath))
                {
                    string baseNameDefault = "terrainblendmesh";
                    int i = 1;
                    assetPath = Path.Combine(Application.dataPath, baseNameDefault + i++);
                    while (File.Exists(assetPath + ".asset"))
                    {
                        assetPath = Path.Combine(Application.dataPath, baseNameDefault + i++);
                    }
                }
                else
                {
                    labels = AssetDatabase.GetLabels(meshFilter.sharedMesh);
                    string fileName = Path.GetFileNameWithoutExtension(assetPath);                    
                    if (!fileName.Contains(".mb"))
                    {
                        fileName += ".mb";
                    }
                    else
                    {
                        int numIndex = fileName.IndexOf(".mb") + ".mb".Length;
                        fileName = fileName.Remove(numIndex, fileName.Length - numIndex);
                    }
                    int i = 1;
                    string directory = Path.GetDirectoryName(assetPath);
                    assetPath = Path.Combine(directory, fileName + i++);


                    while (File.Exists(assetPath + ".asset"))
                    {
                        assetPath = Path.Combine(directory, fileName + i++);
                    }
                    assetPath = assetPath.Replace("\\", "/");
                }
                string path = EditorUtility.SaveFilePanel("Save Mesh Instance", Path.GetDirectoryName(assetPath), Path.GetFileName(assetPath), "asset");
                if (!string.IsNullOrEmpty(path))
                {
                    System.Uri pathURI = new System.Uri(path);
                    System.Uri relativeURI = new System.Uri(Application.dataPath).MakeRelativeUri(pathURI);
             
                    Canvas.SaveMesh(meshFilter.sharedMesh, relativeURI.ToString(), labels);
                    StartModifyingObject(Canvas);
                }
            }
            if (startModify)
            {                
                StartModifyingObject(Canvas);
            }
            if (reset)
            {
                Canvas.RollBackOldMaterial();
            }
        }
        else
        {
            GUILayout.BeginHorizontal();
            Color col = GUI.backgroundColor;
            Color contentCol = GUI.contentColor;
            GUI.backgroundColor = Color.red;
            GUI.contentColor = Color.white;
            bool stopModify = GUILayout.Button(new GUIContent(MeshBlendText.StopModifying, MeshBlendText.StopModifyingTooltip));
            GUI.backgroundColor = col;
            GUI.contentColor = contentCol;
            if (stopModify)
            {
                UnlockObject();
            }
            bool showWindow = GUILayout.Button(new GUIContent(MeshBlendText.ShowWindow, MeshBlendText.ShowWindowTooltip));
            if (showWindow)
            {
                PainterWindow = EditorWindow.GetWindow<MeshBlendWindow>();
                if (PainterWindow != null)
                    PainterWindow.BlendEditor = this;
            }
            GUILayout.EndHorizontal();

            GUILayout.Label(new GUIContent(MeshBlendText.Radius, MeshBlendText.RadiusTooltip));
            EditorGUILayout.BeginHorizontal();
            Radius = EditorGUILayout.Slider(Radius, 0f, MaxRadius);
            GUILayout.Label(new GUIContent(MeshBlendText.MaxRadius, MeshBlendText.MaxRadiusTooltip));
            MaxRadius = EditorGUILayout.FloatField(MaxRadius);
            EditorGUILayout.EndHorizontal();

            GUILayout.Label(new GUIContent(MeshBlendText.Strength, MeshBlendText.StrengthTooltip));
            Strength = EditorGUILayout.Slider(Strength, 0f, 1f);

            GUILayout.BeginVertical();
            RefreshBlendTexture(PaintTextureID.PaintTexture00,renderer);
            //RefreshBlendTexture(PaintTextureID.PaintTexture01,renderer);// jeremy use only one blend tex
            //RefreshBlendTexture(PaintTextureID.PaintTexture02,renderer);
            //RefreshBlendTexture(PaintTextureID.PaintTexture03,renderer);
            GUILayout.EndVertical();

        }

        if (renderer != null && Canvas.LastShader != renderer.sharedMaterial.shader && renderer.sharedMaterial.shader.name.Contains("Mesh Blend"))
        {
            TerrainMeshBlendUtility.UpdateProperties(Canvas);
            
            Canvas.LastShader = renderer.sharedMaterial.shader;
        }
        if (PainterWindow != null)
            PainterWindow.Repaint();
    }
    
    void RefreshBlendTexture(PaintTextureID blendID,MeshRenderer renderer)
    {
        if (PaintData == null || PaintData.Count == 0)
            return;

        string blendvar = string.Format("BlendTexture ({0})", (int)blendID);
        bool blend = EditorGUILayout.Toggle(new GUIContent(blendvar, "BlendTexture 0-1"), PaintData[blendID].PaintTexture);
        PaintData[blendID].TextureValue = EditorGUILayout.Slider(PaintData[blendID].TextureValue, 0f, 1f);
        if (blend)
        {
            CurID = blendID;
        }

        EditorGUILayout.BeginHorizontal();        
        string texname = string.Format("_Tex{0}", (int)blendID);
        Texture2D blendtexture = renderer.sharedMaterial.GetTexture(texname) as Texture2D;

        PaintData[blendID].curTexture = (Texture2D)EditorGUILayout.ObjectField(new GUIContent(blendvar, "Choose a Texture to Blend"), PaintData[blendID].curTexture, typeof(Texture2D), false);
        
        if (PaintData[blendID].curTexture != blendtexture)
        {
            renderer.sharedMaterial.SetTexture(texname, PaintData[blendID].curTexture);
            TerrainMeshBlendUtility.UpdateProperties(Canvas);
        }
        GUILayout.FlexibleSpace();
        EditorGUILayout.EndHorizontal();

        EditorGUILayout.BeginVertical();
        GUILayout.Space(50);
        EditorGUILayout.EndVertical();

    }

    private void Fill()
    {
        Mesh mesh = Canvas.GetComponent<MeshFilter>().sharedMesh;

        Vector3[] vertices = mesh.vertices;
        Color[] colors = mesh.colors;

        for (int i = 0; i < vertices.Length; i++)
        {
            foreach (var pdata in PaintData)
            {
                if (pdata.Value.PaintTexture)
                {
                    switch(pdata.Key)
                    {
                        case PaintTextureID.PaintTexture00:
                            colors[i].r = pdata.Value.TextureValue;
                            break;
                        case PaintTextureID.PaintTexture01:
                            colors[i].g = pdata.Value.TextureValue;
                            break;
                        case PaintTextureID.PaintTexture02:
                            colors[i].b = pdata.Value.TextureValue;
                            break;
                        case PaintTextureID.PaintTexture03:
                            colors[i].a = pdata.Value.TextureValue;
                            break;
                    }
                }
            }
        }
        Canvas.Modified = true;

        mesh.colors = colors;        
    }

    private void StartModifyingObject(MeshBlend canvas)
    {
        canvas.GenerateNewMaterial();// jeremy ,now version need new mt
        MeshBlendInit();
        GameObject gameObject = canvas.gameObject;        
        MeshFilter meshFilter = gameObject.GetComponent<MeshFilter>();
        MeshCollider meshCollider = gameObject.GetComponent<MeshCollider>();
        if (meshCollider == null)
        {
            meshCollider = gameObject.AddComponent<MeshCollider>();            
            meshCollider.sharedMesh = meshFilter.sharedMesh;
            Canvas.SuppressDisable = true;            
        }
        else if (meshCollider.sharedMesh != meshFilter.sharedMesh)
        {
            Canvas.OrigColliderMesh = meshCollider.sharedMesh;
            meshCollider.sharedMesh = meshFilter.sharedMesh;
        }
        canvas.TemporaryCollider = meshCollider;

        bool moveup = true;
        while (moveup)
        {
            moveup = UnityEditorInternal.ComponentUtility.MoveComponentUp(meshCollider);
        }
                
        TerrainMeshBlendUtility.UpdateProperties(Canvas);        
        Canvas.Modifying = true;
        Canvas.OrigPivotRotation = Tools.pivotRotation;

    }

    void MeshBlendInit()
    {
        MeshFilter blendmesh = Canvas.gameObject.GetComponent<MeshFilter>();
        Renderer renderer = Canvas.gameObject.GetComponent<Renderer>();

        //for (int i = (int)PaintTextureID.PaintTexture00; i <= (int)PaintTextureID.PaintTexture03; i++)
        for (int i = (int)PaintTextureID.PaintTexture00; i <= (int)PaintTextureID.PaintTexture00; i++)
        {
            string texname = string.Format("_Tex{0}", i);
            Texture tex = renderer.sharedMaterial.GetTexture(texname);
            if (!PaintData.ContainsKey((PaintTextureID)i))
                PaintData.Add((PaintTextureID)i, new PaintTextureData(false, 0, tex));
            else
                PaintData[(PaintTextureID)i].curTexture = tex;
        }
        CurID = PaintTextureID.PaintTexture00;
    }

    private void UnlockObject()
    {        
        if (Canvas.Modifying)
        {
            if (Tools.current == Tool.None)
            {
                Tools.current = Canvas.ActiveTool;
            }
            if (Canvas.OrigColliderMesh != null)
            {
                MeshCollider collider = Canvas.GetComponent<MeshCollider>();
                if(collider != null)
                    collider.sharedMesh = Canvas.OrigColliderMesh;
                Canvas.OrigColliderMesh = null;
            }
            Tools.pivotRotation = Canvas.OrigPivotRotation;
        }
        if (Canvas.TemporaryCollider != null)
        {
            Object.DestroyImmediate(Canvas.TemporaryCollider);
            Canvas.TemporaryCollider = null;
        }
        Canvas.Modifying = false;     
    }



    public bool DrawBrush(Vector2 mousePos, out Ray ray, out RaycastHit hitInfo)
    {
        ray = default(Ray);
        hitInfo = default(RaycastHit);

        if (Canvas.Modifying)
        {
            ray = HandleUtility.GUIPointToWorldRay(mousePos);
            MeshCollider collider = Canvas.GetComponent<MeshCollider>();
            if (collider != null)
            {
                if (collider.Raycast(ray, out hitInfo, float.MaxValue))
                {
                    Handles.DrawWireDisc(hitInfo.point, hitInfo.normal, Radius);
                    return true;
                }
            }
        }
        return false;
    }


    public enum PaintTextureID
    {
        PaintTexture00,
        PaintTexture01,
        PaintTexture02,
        PaintTexture03,
    }
    public class PaintTextureData
    {
        public PaintTextureData(bool ptex, float tf, Texture tex)
        {
            PaintTexture = ptex;
            TextureValue = tf;
            curTexture = tex;
        }

        public bool PaintTexture = false;
        public float TextureValue = 0f;
        public Texture curTexture = null;
    }
}
