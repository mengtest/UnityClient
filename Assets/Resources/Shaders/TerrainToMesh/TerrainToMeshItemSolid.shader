
Shader "LPCFramework/TerrainToMeshItem Solid" {
	Properties {
		_MainTex ("Particle Texture", 2D) = "white" {}
		_Penentrate ("Penentrate", float) = 0
		_PenentrateColor ("Color", Color) = (0.5,0.3,0.3,1)
	}

	SubShader {
		Tags { "RenderType"="Opaque" }

		CGPROGRAM

		#pragma surface surf Lambert noforwardadd
		sampler2D _MainTex;
		half _Penentrate;
		half4 _PenentrateColor;

		struct Input {
			float2 uv_MainTex;
			float3 worldNormal;
			float3 viewDir;			
		};

		void surf (Input IN, inout SurfaceOutput o) {
			fixed4 c = tex2D(_MainTex, IN.uv_MainTex);
			half greyScale = (c.r + c.g + c.b) * 0.5;
			half edge = saturate(dot(IN.worldNormal, IN.viewDir) * 1.5);
			o.Albedo = c.rgb * (1.0 - _Penentrate) + greyScale * _PenentrateColor.rgb * _Penentrate * edge;
			o.Alpha = 1.0;
		}
		ENDCG
	}
}
