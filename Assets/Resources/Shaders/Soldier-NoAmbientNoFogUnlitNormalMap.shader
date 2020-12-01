Shader "LPCFramework/Unlit/Soldier-No Ambient No Fog Unlit NormalMap" {
	Properties {
		_BodyColor ("BodyColor", Color) = (1,1,1,1)
		_Color("Color", Color) = (0,0,1,1)
		_LightDir("LightDir", Vector) = (1.0, 1.0, -0.2,-0.2)
		_LightColor("LightColor", Color) = (0,0,1,1)
		_MainTex ("Albedo (RGB)", 2D) = "white" {}
		_BumpMap ("Bumpmap", 2D) = "bump" {}	
		_HitColor("_HitColor", Color) = (1,1,1,1)	
	}
	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 150
		
		CGPROGRAM
		
		#pragma surface surf Unlit noambient nofog noforwardadd

		sampler2D _MainTex;
		half4 _HitColor;
		sampler2D _BumpMap;
		half4 _BodyColor;
		half4 _Color;
		half4 _LightDir;
		half4 _LightColor;

		struct Input {
			float2 uv_MainTex;
			float2 uv_BumpMap;
		};
		
		void surf (Input IN, inout SurfaceOutput o) 
		{			
			half4 c = tex2D(_MainTex, IN.uv_MainTex) * _HitColor;
			half greyScale = (c.r + c.g + c.b) * 0.2;
			o.Albedo = c.rgb * (1.0 - c.a) * _BodyColor.rgb + greyScale * _Color.rgb * c.a * _Color.a * 5.0;
			o.Alpha = 1.0;
			o.Normal = UnpackNormal (tex2D (_BumpMap, IN.uv_BumpMap));
		}


		half4 LightingUnlit (SurfaceOutput s, half3 lightDir, half atten) {

			fixed diff = max (0, dot (s.Normal, _LightDir));
			half4 c;
			c.rgb = s.Albedo * diff * _LightColor;			
			c.a = s.Alpha;
			return c;
		}
		ENDCG
	}
	FallBack "Mobile/VertexLit"	
}
