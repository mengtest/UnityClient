// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

// - Support vertex realtime light, for now, will remove
// - Support fog
// - SUPPORTS lightmap

Shader "LPCFramework/TerrainToMesh2Layer" 
{
	Properties {

		_Alpha1 ("Alpha1", 2D) = "grey" {}
		_Alpha2 ("Alpha1", 2D) = "grey" {}

		_Splat1 ("Splat1", 2D) = "grey" {}
		_Splat2 ("Splat2", 2D) = "grey" {}
		_Splat3 ("Splat3", 2D) = "grey" {}
		_Splat4 ("Splat4", 2D) = "grey" {}

		_Splat5 ("Splat5", 2D) = "grey" {}
		_Splat6 ("Splat6", 2D) = "grey" {}
		_Splat7 ("Splat7", 2D) = "grey" {}
		_Splat8 ("Splat8", 2D) = "grey" {}

		_SplatScale ("SplatScale", Float) = 1.0
	}

	SubShader {

		Tags {"LightMode"="ForwardBase" "RenderType"="Opaque"}
		LOD 100
	
		CGINCLUDE
		#include "UnityCG.cginc"
		#include "UnityLightingCommon.cginc" // for _LightColor0, temp support for vertex light

		uniform float4 _Alpha1_ST;
		uniform sampler2D _Alpha1;
		uniform sampler2D _Alpha2;

		uniform sampler2D _Splat1;
		uniform sampler2D _Splat2;
		uniform sampler2D _Splat3;
		uniform sampler2D _Splat4;

		uniform sampler2D _Splat5;
		uniform sampler2D _Splat6;
		uniform sampler2D _Splat7;
		uniform sampler2D _Splat8;

		float _SplatScale;

		struct v2f {
			float4 pos : SV_POSITION;
			float2 uv : TEXCOORD0;
			fixed4 diff : COLOR0;
		};

		v2f vert (appdata_base v)
		{
			v2f o;
			o.pos = UnityObjectToClipPos(v.vertex);
			o.uv = TRANSFORM_TEX(v.texcoord, _Alpha1);

			half3 worldNormal = UnityObjectToWorldNormal(v.normal);
			half nl = max(0, dot(worldNormal, _WorldSpaceLightPos0.xyz));
			o.diff = nl * _LightColor0;
			o.diff.rgb += ShadeSH9(half4(worldNormal,1));

			return o;
		}

		fixed4 frag (v2f i) : SV_Target
		{
			fixed4 c;
    		float4 a1 = tex2D(_Alpha1, i.uv);
			float4 a2 = tex2D(_Alpha2, i.uv);

			float2 splatUv = i.uv * _SplatScale;
			c.rgb = (
					a1.r * tex2D(_Splat1, splatUv).rgb
				  + a1.g * tex2D(_Splat2, splatUv).rgb
				  + a1.b * tex2D(_Splat3, splatUv).rgb
				  + a1.a * tex2D(_Splat4, splatUv).rgb
				  + a2.r * tex2D(_Splat5, splatUv).rgb
				  + a2.g * tex2D(_Splat6, splatUv).rgb
				  + a2.b * tex2D(_Splat7, splatUv).rgb
				  + a2.a * tex2D(_Splat8, splatUv).rgb
				  ) * i.diff;
			c.a = 1.0;
			
			return c;
		}

		ENDCG


		Pass {
			CGPROGRAM

			#pragma vertex vert
			#pragma fragment frag
			#pragma fragmentoption ARB_precision_hint_fastest		

			ENDCG 
		}	
	}
}


