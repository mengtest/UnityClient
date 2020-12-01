Shader "Mesh Blend/Mesh Blend Diffuse" 
{
	Properties 
	{
		_Color ("Main Color", Color) = (1,1,1,1)
		_MainTex ("BaseMap (RGBA)", 2D) = "white" {}
		_DetailTex ("Detail", 2D) = "white" {}
		_DetailColor ("Detail Color", Color) = (1,1,1,1)
		_Tex0 ("BlendTex0", 2D) = "black" {}
		_TileSize ("Tile UV Size", Vector) = (1,1,1,1)
		_TerrainCoords ("Terrain Coords", Vector) = (0,0,129,129)		
	}
	SubShader 
	{
		Tags { "RenderType"="Opaque" }
		LOD 200
		
		CGPROGRAM
		#pragma surface surf Unlit		
		#pragma target 3.0
		#define NO_TERRAIN_BUMP
		#define SINGLE_TERRAIN_TEXTURE
		#include "GeneralTerrainCode.cginc"
		#include "MeshBlendSurfaceCode.cginc"

		half4 LightingUnlit (SurfaceOutput s, half3 lightDir, half atten) 
		{
			half4 c;
			c.rgb = s.Albedo;
			c.a = s.Alpha;
			return c;
		}		
		ENDCG
	} 
	FallBack "Diffuse"
}
