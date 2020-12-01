Shader "LPCFramework/No Fog Diffuse" {
	Properties {
		_MainTex ("Base", 2D) = "white" {}
	}
	
	SubShader {
			Tags { "RenderType"="Opaque" }

			CGPROGRAM
			#pragma surface surf Lambert noforwardadd nofog
			
			sampler2D _MainTex;

            struct Input {
				float2 uv_MainTex;
			};

            void surf (Input IN, inout SurfaceOutput o) {
				half4 c = tex2D (_MainTex, IN.uv_MainTex);
				o.Albedo = c.rgb;
				o.Alpha = 1.0;
			}

			ENDCG 
		//End Pass
	} //end sub shader
}
