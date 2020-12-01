// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "LPCFramework/SimpleWaterCurved" {
	Properties {
		_MainTex ("Normal", 2D) = "bump" {}
		_ScreenReflection ("ScreenReflection (RGB)", 2D) = "black" {}
		_DirectionUv("Scroll Directions", Vector) = (1.0, 1.0, -0.2,-0.2)
		_TexAtlasTiling("Tiling", Vector) = (15.0, 15.0, -15.0, 15.0)
		_CurveParameter("Curve Parameter", Vector) = (15.0, 15.0, 0.0, 0.0)

		_Color("Color", Color) = (0,0,1,1)
		_RColor("Color", Color) = (0,0,1,1)
		_MMultiplier ("Wave Multiplier", Float) = 0.2
		_RMultiplier ("Reflect Multiplier", Float) = 0.2
		_Alpha ("Alpha Height", Float) = 0.6

		_WaterHeight ("WaterHeight", Float) = 0.0
	}

	
	SubShader {
		Tags { "Queue"="Transparent" "IgnoreProjector"="True" "RenderType"="Transparent - 10" }
	
		Blend SrcAlpha OneMinusSrcAlpha
		ColorMask RGB
		Lighting Off ZWrite Off
	
		LOD 100

		CGINCLUDE
	
		#include "UnityCG.cginc"
	
		sampler2D _MainTex;
		sampler2D _ScreenReflection;
    
		float4 _DirectionUv;
		float4 _TexAtlasTiling;
		float4 _CurveParameter;
	
		float4 _Color;
		float4 _RColor;
		float _Alpha;
		float _WaterHeight;

		float _MMultiplier;
		float _RMultiplier;

		struct v2f {
			float4 pos : SV_POSITION;
			half4 uv : TEXCOORD0;
			UNITY_FOG_COORDS(1)
			half4 screen : TEXCOORD2;
			half waterdepth : TEXCOORD3;
		};

		v2f vert (appdata_base v)
		{
			v2f o;
			o.waterdepth = _WaterHeight - v.vertex.y;
			float4 modifiedPos = float4(0, -_CurveParameter.x, 0, v.vertex.w);
			modifiedPos.xyz = (_WaterHeight + _CurveParameter.x) * v.normal + modifiedPos.xyz;
			o.pos = UnityObjectToClipPos(modifiedPos);
			o.screen = ComputeScreenPos(o.pos);
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
			half3 reflectcolor = tex2D (_ScreenReflection, (i.screen.xy / i.screen.w) + nrml.xy);
			reflectcolor = reflectcolor * reflectcolor * _RMultiplier;
			o.rgb = reflectcolor * _RColor + _Color.rgb;
			o.a = saturate(max(reflectcolor.r, i.waterdepth / _Alpha));
			//o.a = saturate(max(reflectcolor.r, sqrt(i.waterdepth / _Alpha)));
			//o.a = saturate(max(reflectcolor.r, i.waterdepth * i.waterdepth / _Alpha / _Alpha));
			//half al = 1.0 - saturate(i.waterdepth / _Alpha);
			//o.a = saturate(max(reflectcolor.r, 1.0 - al * al * al));
						
			UNITY_APPLY_FOG(i.fogCoord, o);
			return o;
		}

		ENDCG

		Pass {
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma multi_compile_particles
			#pragma multi_compile_fog

			ENDCG 
		}	
	}
}
