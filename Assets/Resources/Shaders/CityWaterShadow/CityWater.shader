// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

// Upgrade NOTE: commented out 'sampler2D unity_Lightmap', a built-in variable
// Upgrade NOTE: replaced tex2D unity_Lightmap with UNITY_SAMPLE_TEX2D

Shader "LPCFramework/City Water" {
	Properties {
		_MainTex ("Normal", 2D) = "bump" {}
		_Fresnel ("Fresnel (RGB)", 2D) = "black" {}
		_ScreenReflection ("ScreenReflection (RGB)", 2D) = "black" {}
		_DirectionUv("Scroll Directions", Vector) = (1.0, 1.0, -0.2,-0.2)
		_TexAtlasTiling("Tiling", Vector) = (15.0, 15.0, -15.0, 15.0)

		_Color("Color1", Color) = (0,0,1,1)
		_MColor("Color2", Color) = (0,0,1,1)
		_RColor("Reflect Color", Color) = (0,0,1,1)
		_MMultiplier ("Wave Multiplier", Float) = 0.2
		_RMultiplier ("Reflect Multiplier", Float) = 0.2
	}

	
	SubShader {
		Tags { "Queue"="Transparent" "RenderType"="Transparent" }
	
		Blend SrcAlpha OneMinusSrcAlpha
		ColorMask RGB
		Lighting Off ZWrite Off
	
		LOD 100

		CGINCLUDE
	
		#include "UnityCG.cginc"
	
		sampler2D _MainTex;
		sampler2D _ScreenReflection;
		sampler2D _Fresnel;
    
		float4 _DirectionUv;
		float4 _TexAtlasTiling;
	
		float4 _Color;
		float4 _MColor;
		float4 _RColor;

		float _MMultiplier;
		float _RMultiplier;

#ifdef LIGHTMAP_ON
		// fixed4 unity_LightmapST;
		// sampler2D unity_Lightmap;
#endif

		struct v2f {
			float4 pos : SV_POSITION;
			half4 uv : TEXCOORD0;
			UNITY_FOG_COORDS(1)
			half4 screen : TEXCOORD2;
#ifdef LIGHTMAP_ON
			half2 lm_uv : TEXCOORD3;
#endif
		};

		struct appdata_t
		{
			float4 vertex : POSITION;
			float2 texcoord : TEXCOORD0;
#ifdef LIGHTMAP_ON
			float2 texcoord1 : TEXCOORD1;
#endif
		};

		v2f vert (appdata_t v)
		{
			v2f o;
			o.pos = UnityObjectToClipPos(v.vertex);
			o.screen = ComputeScreenPos(o.pos);
			o.uv.xyzw = v.texcoord.xyxy * _TexAtlasTiling + _Time.xxxx * _DirectionUv;

#ifdef LIGHTMAP_ON
			o.lm_uv = v.texcoord1.xy * unity_LightmapST.xy + unity_LightmapST.zw;
#endif

			UNITY_TRANSFER_FOG(o, o.pos);
			return o;
		}

		fixed4 frag (v2f i) : SV_Target
		{
			half4 o;
			half3 tex = UnpackNormal(tex2D (_MainTex, i.uv.xy));
			half3 tex2 = UnpackNormal(tex2D (_MainTex, i.uv.zw));
			half3 nrml = ((tex - 0.5) + (tex2 - 0.5)) * _MMultiplier;

			float fresnelFactor = tex2D (_Fresnel, float2(0.5, 0.5) + nrml.yy).a;
			fresnelFactor *= fresnelFactor;
			o = fresnelFactor * _Color + (1.0 - fresnelFactor) * _MColor;

			half3 reflectcolor = tex2D (_ScreenReflection, (i.screen.xy / i.screen.w) + nrml.xy);
			reflectcolor = reflectcolor * reflectcolor * _RMultiplier;
			o.rgb += reflectcolor * _RColor;
#ifdef LIGHTMAP_ON
			o.rgb *= DecodeLightmap(UNITY_SAMPLE_TEX2D(unity_Lightmap, i.lm_uv));
#endif
			//o.a = saturate(max(reflectcolor.r, i.waterdepth / _Alpha));
						
			UNITY_APPLY_FOG(i.fogCoord, o);
			return o;
		}

		ENDCG

		Pass {
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma multi_compile_fog
			#pragma multi_compile LIGHTMAP_ON LIGHTMAP_OFF

			ENDCG 
		}	
	}
}
