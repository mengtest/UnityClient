// Simplified Diffuse shader. Differences from regular Diffuse one:
// - no Main Color
// - fully supports only 1 directional light. Other lights can affect it, but it will be per-vertex/SH.

Shader "LPCFramework/Transparent/TransparentCity" {
	Properties {
		_MainTex ("Base (RGB)", 2D) = "white" {}
		_Color ("Color", Color) = (0.5,0.5,0.5,0.5)
		_Shake ("Shake", Vector) = (0.5,0.5,0.5,0.5)
		_Cutoff ("Cutoff", float) = 0.05
	}
	SubShader {
		Tags {"Queue"="Transparent" "IgnoreProjector"="True" "RenderType"="Transparent"}

		CGPROGRAM

		#pragma surface surf Lambert alpha:fade noforwardadd

		sampler2D _MainTex;
		half4 _Color;
		half4 _Shake;

		struct Input {
			float2 uv_MainTex;
		};

		void surf (Input IN, inout SurfaceOutput o) {
			half sh = sin(_Time.x * _Shake.x) * _Shake.y + 1.0;
			half4 c = tex2D(_MainTex, IN.uv_MainTex) * _Color * sh;
			o.Albedo = c.rgb;
			o.Alpha = c.a;
		}
		ENDCG
	}
}
