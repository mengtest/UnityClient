using UnityEngine;
using System.Collections;
using System.Collections.Generic;
using System.IO;

#if UNITY_EDITOR
[ExecuteInEditMode]
#endif
[RequireComponent(typeof(MeshFilter))]
[RequireComponent(typeof(MeshRenderer))]
[RequireComponent(typeof(MeshBlendData))]
public class MeshBlend : MonoBehaviour
{
    [SerializeField]
    private Vector3 mLastPos;
    [SerializeField]
    private Quaternion mLastRotation;
    [SerializeField]
    private Vector3 mLastScale;

    public LPCFramework.TerrainGroundCoordinate coord;

    private MeshFilter mMeshFilter;
    private MeshRenderer mMeshRenderer;
    private Transform mTransform;
    private Color[] mColors;
    private Vector3[] mVertices;
    
    private MeshBlendData meshblenddata;
        
#if UNITY_EDITOR
    [System.NonSerialized]
    public bool WasMouseDown = false;
    [System.NonSerialized]
    public bool RightMouseDown = false;
    [System.NonSerialized]
    public UnityEditor.Tool ActiveTool;

    [System.NonSerialized]
    public bool Modified;

    [System.NonSerialized]
    public bool Modifying;
    [System.NonSerialized]
    public MeshCollider TemporaryCollider;

    [System.NonSerialized]
    public Mesh OrigColliderMesh;
    [System.NonSerialized]
    public bool SuppressDisable; // used to suppress OnDisable when adding component
    [System.NonSerialized]
    public UnityEditor.PivotRotation OrigPivotRotation;
    [System.NonSerialized]
    public Shader LastShader;
#endif

    void Awake()
    {        
        GetReferences();        
        if (meshblenddata == null)
            meshblenddata = gameObject.AddComponent<MeshBlendData>();

        if (mMeshFilter != null && mMeshFilter.sharedMesh != null)
        {
            if(meshblenddata.NewMesh != null)
            {
                if (meshblenddata.NewMesh != mMeshFilter.sharedMesh)
                {
                    Debug.LogWarning("Not Same Mesh Data,some error happens");
                    mMeshFilter.sharedMesh = meshblenddata.NewMesh;
                }
            }

            if (mColors == null || mColors.Length != mMeshFilter.sharedMesh.vertexCount)
                mColors = mMeshFilter.sharedMesh.colors;

            if (mVertices == null || mVertices.Length != mMeshFilter.sharedMesh.vertexCount)
                mVertices = mMeshFilter.sharedMesh.vertices;
        }         
    }



    int GroundSize;
    public void GetReferences()
    {
        if (mMeshFilter == null)
            mMeshFilter = GetComponent<MeshFilter>();
        if (mTransform == null)
            mTransform = GetComponent<Transform>();
        if (mMeshRenderer == null)
            mMeshRenderer = GetComponent<MeshRenderer>();

        if (coord== null)
            coord = GameObject.Find("WorldMap").GetComponent<LPCFramework.TerrainGroundCoordinate>();

        Vector3 vMeshSize = coord.gameObject.GetComponent<MeshFilter>().sharedMesh.bounds.extents;
        GroundSize = (int)System.Math.Ceiling(Mathf.Min(vMeshSize.x, vMeshSize.z) * 2);


        meshblenddata = GetComponent<MeshBlendData>();
    }


#if UNITY_EDITOR
    public void GenerateNewMaterial()
    {
        if (mMeshRenderer.sharedMaterial != null && mMeshRenderer.sharedMaterial.shader != null && mMeshRenderer.sharedMaterial.shader.name.Contains("Mesh Blend Diffuse"))
        {
            mMeshRenderer.sharedMaterial.SetVector("_TerrainCoords", new Vector4(0, 0, GroundSize / 2, GroundSize / 2));
            return;
        }

        string blendname = mMeshRenderer.sharedMaterial.name + "MeshBlendDiffuse";        
        string assetpath = UnityEditor.AssetDatabase.GetAssetPath(mMeshRenderer.sharedMaterial);
        string dir = Path.GetDirectoryName(assetpath) + "/" + Path.GetFileNameWithoutExtension(assetpath);
        string filename = dir + "/" + blendname + ".mat";

        Material blend = UnityEditor.AssetDatabase.LoadAssetAtPath<Material>(filename);
        if (blend != null)
        {
            meshblenddata.oldMaterial = mMeshRenderer.sharedMaterial;
            mMeshRenderer.sharedMaterial = blend;
            return;
        }

        blend = new Material(Shader.Find("Mesh Blend/Mesh Blend Diffuse"));
        blend.name = blendname;
        blend.SetTexture("_MainTex", mMeshRenderer.sharedMaterial.GetTexture("_MainTex"));
        blend.SetTexture("_DetailTex", mMeshRenderer.sharedMaterial.GetTexture("_DetailTex"));
        blend.SetColor("_DetailColor", mMeshRenderer.sharedMaterial.GetColor("_Color"));
        blend.SetVector("_TerrainCoords", new Vector4(0,0, GroundSize/2, GroundSize/2));
        meshblenddata.oldMaterial = mMeshRenderer.sharedMaterial;
        mMeshRenderer.sharedMaterial = blend;

        SaveMaterial();
    }
    public void RollBackOldMaterial()
    {
        if (meshblenddata == null || meshblenddata.oldMaterial == null)
            return;

        mMeshRenderer.sharedMaterial = meshblenddata.oldMaterial;
        meshblenddata.oldMaterial = null;
    }


    void SaveMaterial()
    {
        string filename = "";
        string assetpath = UnityEditor.AssetDatabase.GetAssetPath(meshblenddata.oldMaterial);
        if (string.IsNullOrEmpty(assetpath))// should never happen
        {
            string dir  = Application.dataPath + "/BlendMaterials" ;
            if (!Directory.Exists(dir))
                Directory.CreateDirectory(dir);

            Debug.LogError(dir);

            filename = dir + "/" + meshblenddata.oldMaterial.name + ".mat";
            Debug.LogError(filename);
        }
        else
        {            
            string dir = Path.GetDirectoryName(assetpath) + "/" +Path.GetFileNameWithoutExtension(assetpath);            
            if (!Directory.Exists(dir))
                Directory.CreateDirectory(dir);
            filename = dir + "/" + mMeshRenderer.sharedMaterial.name + ".mat";            
        }

        UnityEditor.AssetDatabase.CreateAsset(mMeshRenderer.sharedMaterial, filename);
        UnityEditor.AssetDatabase.Refresh();
    }


    public void SaveMesh(Mesh mesh, string meshPath, string[] labels)
    {
        string meshDir = Path.GetDirectoryName(meshPath);
        if (!Directory.Exists(meshDir)) { Directory.CreateDirectory(meshDir); }

        if (Directory.Exists(meshDir))
        {
            Mesh clonedMesh = new Mesh();

            clonedMesh.vertices = mesh.vertices;
            clonedMesh.colors = mesh.colors;
            clonedMesh.uv = mesh.uv;
            clonedMesh.uv2 = mesh.uv2;
            clonedMesh.normals = mesh.normals;
            clonedMesh.tangents = mesh.tangents;
            clonedMesh.triangles = mesh.triangles;

            if (mesh.boneWeights.Length > 1)
            {

                clonedMesh.boneWeights = mesh.boneWeights;

            }

            if (mesh.bindposes.Length > 1)
            {

                clonedMesh.bindposes = mesh.bindposes;

            }

            UnityEditor.AssetDatabase.DeleteAsset(meshPath);

            UnityEditor.AssetDatabase.CreateAsset(clonedMesh, meshPath);

            List<string> meshLabels = new List<string>();
            if (labels != null)
                meshLabels.AddRange(labels);
            if (!meshLabels.Contains("MeshBlendPainted"))
                meshLabels.Add("MeshBlendPainted");
            UnityEditor.AssetDatabase.SetLabels(clonedMesh, meshLabels.ToArray());
            if (mMeshFilter)
            {

                mMeshFilter.sharedMesh = clonedMesh;
                MeshCollider collider = mMeshFilter.GetComponent<MeshCollider>();
                if (collider != null)
                    collider.sharedMesh = clonedMesh;

                if (meshblenddata!= null)
                {
                    meshblenddata.NewMesh = clonedMesh;
                }
            }
            UnityEditor.AssetDatabase.ImportAsset(meshPath);
        }
    }
#endif

    public bool HasMoved()
    {
        return mTransform != null && (mLastPos != mTransform.position || mLastRotation != mTransform.rotation || mLastScale != mTransform.localScale);
    }
}
