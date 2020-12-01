// Simplified Diffuse shader. Differences from regular Diffuse one:
// - no Main Color
// - fully supports only 1 directional light. Other lights can affect it, but it will be per-vertex/SH.

Shader "LPCFramework/Unlit/Soldier-No Ambient No fog Unlit" {
Properties {
	_MainTex ("Base (RGB)", 2D) = "white" {}
	_BodyColor("Body Color", Color) = (0.5,0.5,0.5,1)
	_Color("Color", Color) = (0,0,1,1)
	_HitColor("_HitColor", Color) = (1,1,1,1)
}
SubShader {
	Tags { "RenderType"="Opaque" }
	LOD 150

CGPROGRAM
#pragma surface surf Unlit noambient nofog noforwardadd

sampler2D _MainTex;
half4 _HitColor;
half4 _Color;
half4 _BodyColor;

struct Input {
	float2 uv_MainTex;
};

half4 LightingUnlit (SurfaceOutput s, half3 lightDir, half atten) {
	half4 c;
	c.rgb = s.Albedo;
	c.a = s.Alpha;
	return c;
}

void surf (Input IN, inout SurfaceOutput o) {
	half4 c = tex2D(_MainTex, IN.uv_MainTex) * _HitColor;
	half greyScale = (c.r + c.g + c.b) * 0.2;
	o.Albedo = c.rgb * (1.0 - c.a) * _BodyColor.rgb + greyScale * _Color.rgb * c.a * _Color.a * 5.0;
	o.Alpha = 1.0;
}
ENDCG
}

Fallback "Mobile/VertexLit"
}
