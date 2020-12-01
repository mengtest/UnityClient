Shader "LPCFramework/Unlit/Soldier-No Ambient No Fog HalfLambert NormalMap" {
	Properties {
		_BodyColor ("BodyColor", Color) = (1,1,1,1)
		_Color("Color", Color) = (0,0,1,1)
		_MainTex ("Albedo (RGB)", 2D) = "white" {}
		_BumpMap ("Bumpmap", 2D) = "bump" {}		
		_HitColor("_HitColor", Color) = (1,1,1,1)
	}
	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 150
		
		CGPROGRAM
		
		#pragma surface surf GIHalfLambert noambient nofog noforwardadd nolightmap
		

		sampler2D _MainTex;
		half4 _HitColor;
		sampler2D _BumpMap;
		half4 _BodyColor;
		half4 _Color;

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


		void LightingGIHalfLambert_GI (
			SurfaceOutput s,
			UnityGIInput data,
			inout UnityGI gi)
		{
			gi = UnityGlobalIllumination (data, 1.0, s.Normal);
		}

		half4 LightingGIHalfLambert(SurfaceOutput s,UnityGI gi)
		{
			half difLight = max(0, dot (s.Normal, gi.light.dir));  
			half hLambert = difLight * 0.5 + 0.5;  
          
			half4 col;              
			col.rgb = s.Albedo * gi.light.color * hLambert;
			col.a = s.Alpha;  
			return col; 
		}

		ENDCG
	}
	FallBack "LPCFramework/Unlit/Soldier-No Ambient No Fog Unlit NormalMap"
}
