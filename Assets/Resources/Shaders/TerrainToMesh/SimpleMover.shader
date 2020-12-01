
Shader "LPCFramework/Simple Mover" {
	Properties {
		_MainTex ("Particle Texture", 2D) = "white" {}
		_SpeedX ("_SpeedX", float) = 0
		_SpeedY ("_SpeedY", float) = 0
	}

	SubShader {
		Tags { "Queue"="Transparent" "IgnoreProjector"="True" "RenderType"="Transparent" "PreviewType"="Plane" }
		Blend SrcAlpha OneMinusSrcAlpha
		Cull Off Lighting Off ZWrite Off Fog { Color (0,0,0,0) }

		CGPROGRAM

		#pragma surface surf Unlit alpha:fade
		sampler2D _MainTex;
		half _SpeedX;
		half _SpeedY;

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
			fixed4 c = tex2D(_MainTex, IN.uv_MainTex + half2(_SpeedX, _SpeedY) * _Time.xx);
			o.Albedo = c.rgb;
			o.Alpha = c.a;
		}
		ENDCG
	}
}
