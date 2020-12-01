Shader "LPCFramework/Self Illum" {
	Properties {
		_MainTex ("Base", 2D) = "white" {}
		_Color("Add Color", Color) = (1,1,1,1)
	}
	
	SubShader {
			Tags { "RenderType"="Opaque" }

			CGPROGRAM
			#pragma surface surf Lambert noforwardadd
			
			sampler2D _MainTex;
			float4 _Color;

            struct Input {
				float2 uv_MainTex;
			};

            void surf (Input IN, inout SurfaceOutput o) {
				half4 c = tex2D (_MainTex, IN.uv_MainTex);
				o.Emission = c.rgb * _Color.rgb * 2.0 + c.rgb * (1.0 - c.a);
				o.Albedo = c.rgb;
				o.Alpha = 1.0;
			}

			ENDCG 
		//End Pass
	} //end sub shader
}
