﻿// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

// Upgrade NOTE: replaced '_Projector' with 'unity_Projector'

Shader "LPCFramework/Projector/AddProjector" 
{ 
	Properties
	{
		_Color ("Main Colour", Color) = (1,1,1,0)
		_ShadowTex ("Cookie", 2D) = "gray" {  }
		_Multiply ("Multipy", Float) = 1.0
	}
	
	Subshader
	{
		Tags { "RenderType"="Transparent"  "Queue"="Transparent+100"}
	
		Pass
		{
			ZWrite Off
			Offset -1, -1
			Fog { Mode Off }
			AlphaTest Less 1
			
			ColorMask RGB
			
			Blend OneMinusDstColor One
			
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma fragmentoption ARB_fog_exp2
			#pragma fragmentoption ARB_precision_hint_fastest
			#include "UnityCG.cginc"
			
			struct v2f
			{
				float4 pos : SV_POSITION;
				float4 uv_Main     : TEXCOORD0;
			};
			
			sampler2D _ShadowTex;
			float4 _Color;
			float4x4 unity_Projector;
			float _Multiply;
			
			v2f vert(appdata_tan v)
			{
				v2f o;
				
				o.pos = UnityObjectToClipPos (v.vertex);
				o.uv_Main = mul (unity_Projector, v.vertex);
				return o;
			}
			
			half4 frag (v2f i) : COLOR
			{
				half4 tex = tex2Dproj(_ShadowTex, UNITY_PROJ_COORD(i.uv_Main)) * _Color;
				//return tex.a;
				//tex.a = 1-tex.a;
				return tex * _Multiply;
			}
		
			ENDCG
		}
	}
}


