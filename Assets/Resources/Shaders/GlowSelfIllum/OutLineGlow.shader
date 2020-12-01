Shader "LPCFramework/OutLine Glow" {
	Properties {
		_MainTex ("Base", 2D) = "black" {}
		_Color("Color", Color) = (0,0,1,1)
		_Rate ("Rate", Float) = 0.6
	}
	
	/*
	SubShader {
		//Diffuse Pass
			Tags { "RenderType"="Opaque" }
			ColorMask RGB
			//Cull Front

			CGPROGRAM
			#pragma surface surf Lambert noforwardadd

			sampler2D _MainTex;

			struct Input {
				float2 uv_MainTex;
			};

			void surf (Input IN, inout SurfaceOutput o) {
				half4 c = tex2D(_MainTex, IN.uv_MainTex);
				o.Albedo = c.rgb;
				o.Alpha = 1.0;
			}
			ENDCG
		//end pass
	}
	*/

	SubShader {
		//Glow Pass
			//Tags { "Queue"="Transparent" "IgnoreProjector"="True" "RenderType"="Transparent" }
			Tags { "RenderType"="Opaque" }
	
			//Blend One One
			Lighting Off 
			//ZWrite Off
			//Cull Back

			CGPROGRAM
			//#pragma surface surf Unlit alpha:fade vertex:vert
			#pragma surface surf Unlit

			half4 LightingUnlit (SurfaceOutput s, half3 lightDir, half atten) {
				half4 c;
				c.rgb = s.Albedo;
				c.a = s.Alpha;
				return c;
			}

            struct Input {
				float2 uv_MainTex;
				float3 worldNormal;
				float3 viewDir;
			};

			sampler2D _MainTex;
			float _Rate;
			float4 _Color;

			/*
			void vert (inout appdata_full v) {
				v.vertex.xyz += v.normal * _Rate;
			}
			*/
            void surf (Input IN, inout SurfaceOutput o) {
				half4 c = tex2D (_MainTex, IN.uv_MainTex);
				float factor = saturate(dot(IN.viewDir, IN.worldNormal));
				o.Albedo = c.rgb * (1.0 - c.a) * factor;
				o.Alpha = 1.0;
			}

			ENDCG 
		//End Pass
	} //end sub shader
}
