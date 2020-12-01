// Simplified Diffuse shader. Differences from regular Diffuse one:
// - no Main Color
// - fully supports only 1 directional light. Other lights can affect it, but it will be per-vertex/SH.

Shader "LPCFramework/TerrainToMeshInteract" {
Properties {
	_MainTex ("Base (RGB)", 2D) = "white" {}
}
SubShader {
	Tags { "RenderType"="Opaque" }
	LOD 150

CGPROGRAM
#pragma surface surf Lambert noforwardadd nolightmap

sampler2D _MainTex;

struct Input {
	float2 uv_MainTex;
	float4 vertColor : Color;
	float3 worldNormal;
	float3 viewDir;
};

void surf (Input IN, inout SurfaceOutput o) {
	half4 c = tex2D(_MainTex, IN.uv_MainTex);
	half bg = IN.vertColor.a;
	half greyScale = (c.r + c.g + c.b) * 0.5;
	half edge = saturate(dot(IN.worldNormal, IN.viewDir) * 1.5);
	o.Albedo = c.rgb * (1.0 - bg) + greyScale * IN.vertColor.rgb * bg * edge;
	o.Alpha = 1.0;
}
ENDCG
}

Fallback "Mobile/VertexLit"
}
