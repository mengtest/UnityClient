Shader "LPCFramework/Transparent/Transparent Diffuse Cutout" {
	Properties {
		_MainTex ("Base (RGB) Trans (A)", 2D) = "white" {}
		_CutOff ("Alpha cutoff", Range(0,1)) = 0.5
	}

    SubShader
    {
		Tags {"Queue"="Transparent" "RenderType"="TransparentCutout"}

		CGPROGRAM

		#pragma surface surf Lambert alphatest:_CutOff noforwardadd
		sampler2D _MainTex;

		struct Input {
			float2 uv_MainTex;
		};

		void surf (Input IN, inout SurfaceOutput o) {
			fixed4 c = tex2D(_MainTex, IN.uv_MainTex);
			o.Albedo = c.rgb;
			o.Alpha = c.a;
		}
		ENDCG
    }
}
