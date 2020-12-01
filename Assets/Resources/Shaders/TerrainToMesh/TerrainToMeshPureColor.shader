// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "LPCFramework/TerrainToMeshPureColor" {

	Properties {
		_MainTex ("Base (RGB)", 2D) = "white" {}
		_SpecturalRate ("_SpecturalRate (RGB)", 2D) = "black" {}
		_Spectural ("_Spectural (RGB)", 2D) = "black" {}
		_SpecturalDetail ("_SpecturalDetail (RGB)", 2D) = "white" {}

		_RColor("Color", Color) = (0,0,1,1)
	}

	SubShader {
		Tags { "RenderType"="Opaque" }

		CGINCLUDE
		#include "UnityCG.cginc"
		#include "UnityLightingCommon.cginc" // for _LightColor0, temp support for vertex light
		//#include "Lighting.cginc"
		//#include "AutoLight.cginc"

		uniform float4 _MainTex_ST;
		uniform sampler2D _MainTex;
		uniform sampler2D _SpecturalRate;
		uniform sampler2D _Spectural;

		uniform sampler2D _SpecturalDetail;
		uniform float4 _SpecturalDetail_ST;

		float4 _RColor;

		struct v2f 
		{
			float4 pos : SV_POSITION;
			float4 uv : TEXCOORD0;
			float4 screen : TEXCOORD1;
			UNITY_FOG_COORDS(2)
			//SHADOW_COORDS(3)
			fixed4 diff : COLOR0;
		};

		v2f vert_realtimelight (appdata_base v)
		{
			v2f o;
			o.pos = UnityObjectToClipPos(v.vertex);
			o.uv.xy = TRANSFORM_TEX(v.texcoord, _MainTex);
			o.uv.zw = TRANSFORM_TEX(v.texcoord, _SpecturalDetail);
			half3 worldNormal = UnityObjectToWorldNormal(v.normal);
			half nl = max(0, dot(worldNormal, _WorldSpaceLightPos0.xyz));
			o.diff = nl * _LightColor0;
			o.diff.rgb += ShadeSH9(half4(worldNormal,1));
			o.screen = ComputeScreenPos(o.pos);
			UNITY_TRANSFER_FOG(o, o.pos);
			//TRANSFER_SHADOW(o);
			return o;
		}

		fixed4 frag_realtimelight (v2f i) : SV_Target
		{
			half3 reflectcolor = tex2D (_Spectural, (i.screen.xy / i.screen.w)) * _RColor;
			reflectcolor = reflectcolor * tex2D(_SpecturalRate, i.uv.xy).r;
			reflectcolor = reflectcolor * tex2D(_SpecturalDetail, i.uv.zw);
			half4 ret = tex2D(_MainTex, i.uv.xy) * i.diff;
			ret.rgb = saturate(ret.rgb + reflectcolor);
			ret.a = 1.0;	
			UNITY_APPLY_FOG(i.fogCoord, ret);
			return ret;
		}

		struct appdata_t
		{
			float4 vertex : POSITION;
			float2 texcoord : TEXCOORD0;
			float2 texcoord_lm : TEXCOORD1;
		};

		struct v2f_lm
		{
			float4 pos : SV_POSITION;
			float4 uv : TEXCOORD0;
			float4 screen : TEXCOORD1;
			UNITY_FOG_COORDS(2)
			float2 lmuv : TEXCOORD3;
			//SHADOW_COORDS(4)
		};

		v2f_lm vert_lm (appdata_t v)
		{
			v2f_lm o;
			o.pos = UnityObjectToClipPos(v.vertex);
			o.uv.xy = TRANSFORM_TEX(v.texcoord, _MainTex);
			o.uv.zw = TRANSFORM_TEX(v.texcoord, _SpecturalDetail);
			o.lmuv = v.texcoord_lm * unity_LightmapST.xy + unity_LightmapST.zw;
			o.screen = ComputeScreenPos(o.pos);
			UNITY_TRANSFER_FOG(o, o.pos);
			//TRANSFER_SHADOW(o);
			return o;
		}

		fixed4 frag_ldr(v2f_lm i) : SV_Target
		{
			fixed4 lm = UNITY_SAMPLE_TEX2D(unity_Lightmap, i.lmuv);

			half3 reflectcolor = tex2D (_Spectural, (i.screen.xy / i.screen.w)) * _RColor;
			reflectcolor = reflectcolor * tex2D(_SpecturalRate, i.uv.xy).r;
			reflectcolor = reflectcolor * tex2D(_SpecturalDetail, i.uv.zw);
			//fixed shadow = SHADOW_ATTENUATION(i);
			half4 ret = tex2D(_MainTex, i.uv.xy) * lm * 2.0;// * shadow;
			ret.rgb = saturate(ret.rgb + reflectcolor);
			ret.a = 1.0;	
			UNITY_APPLY_FOG(i.fogCoord, ret);

			return ret;
		}

		fixed4 frag_rgbm(v2f_lm i) : SV_Target
		{
			half4 lm = UNITY_SAMPLE_TEX2D(unity_Lightmap, i.lmuv);

			half3 reflectcolor = tex2D (_Spectural, (i.screen.xy / i.screen.w)) * _RColor;
			reflectcolor = reflectcolor * tex2D(_SpecturalRate, i.uv.xy).r;
			reflectcolor = reflectcolor * tex2D(_SpecturalDetail, i.uv.zw);
			//fixed shadow = SHADOW_ATTENUATION(i);
			half4 ret = tex2D(_MainTex, i.uv.xy) * lm * lm.a * 5;// * shadow;
			ret.rgb = saturate(ret.rgb + reflectcolor * reflectcolor);
			ret.a = 1.0;	
			UNITY_APPLY_FOG(i.fogCoord, ret);

			return ret;
		}
	
		ENDCG

		// Non-lightmapped
		Pass {
			Tags { "LightMode" = "Vertex" }

			CGPROGRAM
			#pragma vertex vert_realtimelight
			#pragma fragment frag_realtimelight
			#pragma multi_compile_fog
			ENDCG 
		}
	
		// Lightmapped, encoded as dLDR
		Pass {
			Tags { "LightMode" = "VertexLM" }
			Lighting Off

			CGPROGRAM
			#pragma vertex vert_lm
			#pragma fragment frag_ldr
			#pragma multi_compile_fog
			ENDCG 
					
		}
	
		// Lightmapped, encoded as RGBM
		Pass {
			Tags { "LightMode" = "VertexLMRGBM" }
			Lighting Off

			CGPROGRAM
			#pragma vertex vert_lm
			#pragma fragment frag_rgbm
			#pragma multi_compile_fog
			ENDCG 
		}	
	}
}



