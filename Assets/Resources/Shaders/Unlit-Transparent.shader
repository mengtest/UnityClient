Shader "LPCFramework/Unlit/Unlit-Transparent"
{
	Properties {
		_MainTex ("Base (RGB)", 2D) = "white" {}
		_Color ("Color", Color) = (0.5,0.5,0.5,0.5)				
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
			half4 c = tex2D(_MainTex, IN.uv_MainTex) * _Color;
			o.Albedo = c.rgb;
			o.Alpha = c.a;
		}
		ENDCG
	}
}
