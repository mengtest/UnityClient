
// - Unlit
// - Per-vertex (virtual) camera space specular light
// - SUPPORTS lightmap

Shader "LPCFramework/Phase Anim Flag" {
	Properties {
		_TintColor ("Color", Color) = (1.0, 1.0, 1.0, 1.0)
		_MainTex ("Base (RGB) Gloss (A)", 2D) = "white" {}
		_Wind("Wind params",Vector) = (1,1,1,1)
		_WindEdgeFlutter("Wind edge fultter factor", float) = 0.5
		_Add("Wind Add",Vector) = (0.2,0.2,1,1)

		_WindTimer("Wind Phase",float) = 0.5
	}

	SubShader {

		Tags {"RenderType"="Opaque"}
		LOD 100
		//Cull Off
	
		CGPROGRAM

		#pragma surface surf Lambert noforwardadd vertex:vert

		#include "UnityCG.cginc"

		sampler2D _MainTex;
	
		float _WindEdgeFlutter;
		float _WindTimer;
		float4 _TintColor;
		float4 _Add;
		float4 _Wind;

		struct v2f {
			float4 pos : SV_POSITION;
			float2 uv : TEXCOORD0;
			fixed3 spec : TEXCOORD2;
		};

		struct Input {
			float2 uv_MainTex;
		};

		inline float4 PAF_SmoothCurve( float4 x ) {   
			return x * x *( 3.0 - 2.0 * x );   
		}
		inline float4 PAF_TriangleWave( float4 x ) {   
			return abs( frac( x + 0.5 ) * 2.0 - 1.0 );   
		}

		//simple sin function, (sin(x / 2pi) * + 1) * 0.5
		inline float4 PAF_SmoothTriangleWave( float4 x ) {   
			return PAF_SmoothCurve( PAF_TriangleWave( x ) );   
		}

		inline float4 AnimateVertex2(float4 pos, float3 normal, float4 animParams, float4 wind, float2 time)
		{	
			// animParams stored in color
			// animParams.x = branch phase
			// animParams.y = edge flutter factor
			// animParams.z = primary factor
			// animParams.w = secondary factor

			float fDetailAmp = 10.0f;
			float fBranchAmp = 0.3f;
	
			// Phases (object, vertex, branch)
			float fObjPhase = dot(unity_ObjectToWorld[3].xyz, 1);
			float fBranchPhase = fObjPhase + animParams.x;
	
			float fVtxPhase = dot(pos.xyz, animParams.y + fBranchPhase);
	
			// x is used for edges; y is used for branches
			float2 vWavesIn = time + float2(fVtxPhase, fBranchPhase );
	
			// 1.975, 0.793, 0.375, 0.193 are good frequencies
			float4 vWaves = (frac( vWavesIn.xxyy * float4(1.975, 0.793, 0.375, 0.193) ) * 2.0 - 1.0);
	
			vWaves = PAF_SmoothTriangleWave( vWaves );
			float2 vWavesSum = vWaves.xz + vWaves.yw;//(what is this)

			// Edge (xz) and branch bending (y)
			float3 bend = animParams.y * fDetailAmp * normal.xyz;
			bend.y = animParams.w * fBranchAmp;
			pos.xyz += ((vWavesSum.xyx * bend) + (wind.xyz * vWavesSum.y * animParams.w)) * wind.w; 

			// Primary bending
			// Displace position
			pos.xyz += animParams.z * wind.xyz;
	
			return pos;
		}
	
		v2f vert (inout appdata_full v)
		{
			v2f o;
		
			float4	wind;
		
			wind.xyz = mul((float3x3)unity_WorldToObject,float3(0,0,0));
			wind.w = _Wind.w * v.vertex.y;
			
			float fwph = unity_ObjectToWorld[3].x + unity_ObjectToWorld[3].y + unity_ObjectToWorld[3].z;
			float2 fAmplitude = _WindTimer * _Time.x + fwph;
			float4 fAmplitudeFinal = (frac( fAmplitude.xxyy * float4(1.975 * unity_ObjectToWorld[3].x, 0.793 * unity_ObjectToWorld[3].y, 0.375 * unity_ObjectToWorld[3].z, 0.193 * fwph) ) * 2.0 - 1.0);
			float4 vWaveres = PAF_SmoothTriangleWave(fAmplitudeFinal);
		
			float4 windParams = float4(0,_WindEdgeFlutter, 1.0, 1.0);
			float windTime = _WindTimer * _Time.x;
			float4 mdlPos = AnimateVertex2(v.vertex, v.normal, windParams, wind, windTime);
			float4 blendfactor;
			blendfactor.xyz = saturate(-v.vertex.y) * _Wind.xyz;
			blendfactor.w = 1.0;
			mdlPos.xyz += _Add.xyz;
			mdlPos = v.vertex * (1.0 - blendfactor) + mdlPos * blendfactor;
			v.vertex = mdlPos;
			v.vertex += vWaveres * blendfactor;
		
			return o;
		}

		void surf (Input IN, inout SurfaceOutput o) {
			o.Albedo = tex2D(_MainTex, IN.uv_MainTex);
			o.Emission = _TintColor * o.Albedo;
			o.Alpha = 1.0;
		}	
		ENDCG

	}//end subshader
}


