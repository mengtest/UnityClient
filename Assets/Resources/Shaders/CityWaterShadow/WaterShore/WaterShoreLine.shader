// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

// Upgrade NOTE: commented out 'sampler2D unity_Lightmap', a built-in variable
// Upgrade NOTE: replaced tex2D unity_Lightmap with UNITY_SAMPLE_TEX2D

Shader "LPCFramework/WaterShoreLine" {
	Properties 
	{
		_MainTex ("Normal", 2D) = "bump" {}
		_ShadowTex ("Lightmap", 2D) = "white" {}
		_Fresnel ("Fresnel (RGB)", 2D) = "black" {}
		_ScreenReflection ("ScreenReflection (RGB)", 2D) = "black" {}
		_DirectionUv("Scroll Directions", Vector) = (1.0, 1.0, -0.2,-0.2)
		_TexAtlasTiling("Tiling", Vector) = (15.0, 15.0, -15.0, 15.0)

		_Color("Color1", Color) = (0,0,1,1)
		_MColor("Color2", Color) = (0,0,1,1)
		_RColor("Reflect Color", Color) = (0,0,1,1)
		_MMultiplier ("Wave Multiplier", Float) = 0.2
		_RMultiplier ("Reflect Multiplier", Float) = 0.2
						
		_GAmplitude ("Wave Amplitude", Vector) = (0.5 ,0, 0.5, 0.5)
		_GFrequency ("Wave Frequency", Vector) = (2.0, 0, 2.0, 1.0)
		_GSteepness ("Wave Steepness", Vector) = (1.0, 0, 1.0, 1.0)
		_GSpeed ("Wave Speed", Vector) = (1.0, 0, 1.0, 1.0)
		_GDirectionAB ("Wave DirectionAB", Vector) = (0.5 ,0, 0.1, 1.0)
		_GDirectionCD ("Wave DirectionCD", Vector) = (0.1 ,0, 0.5, 1.0)

		_Transparency ("Transparency", Range(0, 1)) = 0.75
		_Depth ("Depth", Range(0,30)) = 30
		_Depthdarkness ("Depth darkness", Range(0, 1)) = 0.5		
		_RimColor ("Rim Color", Color) = (1,1,1,1)
		_RimSize ("Rim Size", Range(0, 4)) = 2
		_Rimfalloff ("Rim falloff", Range(0, 5)) = 0.25
		_Rimtiling ("Rim tiling", Float ) = 2
	}

	
	SubShader {
		Tags { "Queue"="Transparent" "RenderType"="Transparent" }
	
		Blend SrcAlpha OneMinusSrcAlpha
		ColorMask RGB
		Lighting Off ZWrite Off	
		LOD 100

		CGINCLUDE

	
		#include "UnityCG.cginc"
		#include "WaterCalc.cginc"


		sampler2D _MainTex;
		sampler2D _ShadowTex;
		sampler2D _ScreenReflection;
		sampler2D _Fresnel;
		sampler2D _CameraDepthTexture;

		float4 _DirectionUv;
		float4 _TexAtlasTiling;
					
		float4 _Color;
		float4 _MColor;
		float4 _RColor;

		float _MMultiplier;
		float _RMultiplier;
					
		fixed _Transparency;
		fixed _Depth;
		fixed _Depthdarkness;
		
		fixed4 _RimColor;
		fixed _RimSize;
		fixed _Rimfalloff;
		fixed _Rimtiling;

		struct v2f {
			float4 pos : SV_POSITION;
			half4 uv : TEXCOORD0;
			half2 shadowuv : TEXCOORD1;
			UNITY_FOG_COORDS(2)
			half4 screen : TEXCOORD3;
		};

		struct appdata_t
		{
			float4 vertex : POSITION;
			float2 texcoord : TEXCOORD0;			
		};

		v2f vert (appdata_t v)
		{
			v2f o;

			//half3 worldSpaceVertex = mul(unity_ObjectToWorld,(v.vertex)).xyz;
			//half3 vtxForAni = (worldSpaceVertex).xzz;
			//half3 nrml;
			//half3 offsets;
			//Gerstner (
			//	offsets, v.vertex.xyz, vtxForAni,						
			//	_GAmplitude,												
			//	_GFrequency,												
			//	_GSteepness,												
			//	_GSpeed,													
			//	_GDirectionAB,												
			//	_GDirectionCD												
			//);
		
			//v.vertex.xyz += offsets;


			o.pos = UnityObjectToClipPos(v.vertex);
			o.screen = ComputeScreenPos(o.pos);
			COMPUTE_EYEDEPTH(o.screen.z);
			o.shadowuv = v.texcoord;
			o.uv.xyzw = v.texcoord.xyxy * _TexAtlasTiling + _Time.xxxx * _DirectionUv;
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

			half2 uv = i.screen.xy / i.screen.w;
			#if UNITY_UV_STARTS_AT_TOP
			uv.y = 1 - uv.y;
			#endif


			half3 reflectcolor = tex2D (_ScreenReflection, uv + nrml.xy);
			reflectcolor = reflectcolor * reflectcolor * _RMultiplier;
			o.rgb += reflectcolor * _RColor;
			half3 shadowc = tex2D (_ShadowTex, i.shadowuv).rgb;
			o.rgb *= shadowc;
						
																				
			float sceneZ = max(0,LinearEyeDepth (UNITY_SAMPLE_DEPTH(tex2Dproj(_CameraDepthTexture, UNITY_PROJ_COORD(i.screen)))) - _ProjectionParams.g);
			float partZ = max(0,i.screen.z - _ProjectionParams.g);											
			
			float depth = saturate((sceneZ-partZ)/_Depth);			 

			//fixed RimAllphaMultiply = (_RimColor.a*(1.0 - pow(saturate((sceneZ-partZ)/_RimSize),_Rimfalloff)));									
			//float3 diffuseColor = lerp(lerp(o.rgb,(o.rgb*(1.0 - _Depthdarkness)),depth),_RimColor.rgb,saturate(RimAllphaMultiply));
			//fixed4 finalRGBA = fixed4(diffuseColor,(saturate(( lerp(_Transparency,1.0,RimAllphaMultiply) > 0.5 ? (1.0-(1.0-2.0*(lerp(_Transparency,1.0,RimAllphaMultiply)-0.5))*(1.0-depth)) : (2.0*lerp(_Transparency,1.0,RimAllphaMultiply)*depth) ))));
			fixed4 finalRGBA = fixed4(o.rgb,2.0 * depth * _Transparency);
			UNITY_APPLY_FOG(i.fogCoord, finalRGBA);
            return finalRGBA;
		}

		ENDCG

		Pass {
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma multi_compile_fog
			#pragma multi_compile LIGHTMAP_ON LIGHTMAP_OFF
			#pragma target 3.0
			ENDCG 
		}	
	}
}
