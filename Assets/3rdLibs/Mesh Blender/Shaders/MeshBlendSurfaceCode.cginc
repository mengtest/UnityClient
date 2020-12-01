#ifndef MESH_BLEND_SURFACE_CODE
#define MESH_BLEND_SURFACE_CODE
struct Input { 
	float4 color : COLOR;
	float2 uv_MainTex : TEXCOORD0;
	float2 uv_DetailTex : TEXCOORD1;
	float3 worldPos;
	float3 viewDir;
};


sampler2D _MainTex;
sampler2D _DetailTex;
float4 _DetailColor;

sampler2D _Tex0;


float4 _TerrainCoords;
float4 _TileSize;
float4 _Color;


void surf (Input IN, inout SurfaceOutput o) 
{		
	
	float2 terrain_size = _TerrainCoords.ba;
	
	
	float2 targetUV = IN.worldPos.xz ;//- _TerrainCoords.rg;
	float2 splatCoords = targetUV / terrain_size;
	splatCoords =(splatCoords + 1) / 2 ;


	half4 texColor = tex2D(_MainTex,  IN.uv_MainTex.xy) * _Color;		 		
	float3 fcolor;


	half2 uv =  half2(splatCoords.x, splatCoords.y);	
	float texBlendMod = saturate(IN.color.r);
	half3 tex = TerrainCalc(o, uv,1,_Tex0);
	half3 texblendcol = (tex * texBlendMod).rgb;			

	half4 d = tex2D (_DetailTex, IN.uv_DetailTex.xy);						 	     
	o.Albedo = (texblendcol + (texColor.rgb * (1 - texBlendMod))) * d.rgb * _DetailColor; 

}
#endif

