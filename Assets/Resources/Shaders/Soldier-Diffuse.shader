// Simplified Diffuse shader. Differences from regular Diffuse one:
// - no Main Color
// - fully supports only 1 directional light. Other lights can affect it, but it will be per-vertex/SH.

Shader "LPCFramework/Soldier-Diffuse 1 Layer" {
Properties {
	_MainTex ("Base (RGB)", 2D) = "white" {}
	_Color("Color", Color) = (0,0,1,1)
	_HitColor("_HitColor", Color) = (1,1,1,1)
}
SubShader {
	Tags { "RenderType"="Opaque" }
	LOD 150

CGPROGRAM
#pragma surface surf Lambert noforwardadd

sampler2D _MainTex;
half4 _HitColor;
half4 _Color;

struct Input {
	float2 uv_MainTex;
};

void surf (Input IN, inout SurfaceOutput o) {
	half4 c = tex2D(_MainTex, IN.uv_MainTex) * _HitColor;
	half greyScale = (c.r + c.g + c.b) * 0.2;
	o.Albedo = c.rgb * (1.0 - c.a) + greyScale * _Color.rgb * c.a * _Color.a * 5.0;
	o.Alpha = 1.0;
}
ENDCG
}

Fallback "Mobile/VertexLit"
}
