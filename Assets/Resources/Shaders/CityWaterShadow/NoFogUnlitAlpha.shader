Shader "LPCFramework/Unlit/No Fog Unlit Alpha" {
	Properties {
		_MainTex ("Base", 2D) = "white" {}
		_Color ("Color", Color) = (1,1,1,1)
	}
	
	SubShader {
			Tags {"Queue"="Transparent" "IgnoreProjector"="True" "RenderType"="Transparent"}

			CGPROGRAM
			#pragma surface surf Unlit alpha:fade noforwardadd nofog
			
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
				o.Alpha = c.a;
			}

			ENDCG 
		//End Pass
	} //end sub shader
}
