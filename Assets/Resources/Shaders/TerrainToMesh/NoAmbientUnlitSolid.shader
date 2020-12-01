Shader "LPCFramework/Unlit/No Ambient Unlit Solid" {
	Properties {
		_MainTex ("Base", 2D) = "white" {}
		_Color ("Color", Color) = (1,1,1,1)
	}
	
	SubShader {
			Tags { "RenderType"="Opaque" }

			CGPROGRAM
			#pragma surface surf Unlit noambient noforwardadd nofog
			
			sampler2D _MainTex;
			float4 _Color;

			half4 LightingUnlit (SurfaceOutput s, half3 lightDir, half atten) {
				half4 c;
				c.rgb = s.Albedo;
				c.a = s.Alpha;
				return c;
			}

            struct Input {
				float2 uv_MainTex;
			};

            void surf (Input IN, inout SurfaceOutput o) {
				half4 c = tex2D (_MainTex, IN.uv_MainTex);
				o.Albedo = c.rgb * _Color;
				o.Alpha = 1.0;
			}

			ENDCG 
		//End Pass
	} //end sub shader
}
