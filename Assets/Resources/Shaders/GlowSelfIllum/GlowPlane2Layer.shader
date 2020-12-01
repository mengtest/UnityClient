// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'

Shader "LPCFramework/Glow Plane/Glow Plane 2 Layer" {
	Properties {
		_MainTex ("Glow", 2D) = "white" {}
		_FadeOut ("min, near, far", vector) = (0.4, 5, 50, 0)
		_Blink ("Freq, Noise<0.5, Bias, Multipler", vector) = (0.5, 0.5, 0, 1)
		_SizeGrowStartDist("Size grow start dist",float) = 5
		_SizeGrowEndDist("Size grow end dist",float) = 50
		_GrowSize("grow size", vector) = (2.5, 2.5, 2.5, 2.5)
		_Color("Color", Color) = (1,1,1,1)
	}
	
	SubShader {
			Tags { "Queue"="Transparent" "IgnoreProjector"="True" "RenderType"="Transparent" }
			Blend One One
			Cull Off 
			Lighting Off 
			ZWrite Off

			CGINCLUDE	
			#include "UnityCG.cginc"

			sampler2D _MainTex;
			float4 _FadeOut;
			float4 _Blink;
			float _SizeGrowStartDist;
			float _SizeGrowEndDist;
			float4 _GrowSize;
			float4 _Color;

			struct v2f {
				float4	pos		: SV_POSITION;
				float2	uv		: TEXCOORD0;
				fixed4	color	: TEXCOORD1;
				UNITY_FOG_COORDS(2)
			};

	
			v2f vert_h (appdata_full v)
			{
				v2f o;
				float3 viewPos = mul(UNITY_MATRIX_MV,v.vertex);
				float dist = length(viewPos);

				float noiseTime = _Time.y * _Blink.x;
				float noise = sin(noiseTime) * (0.5f * cos(noiseTime * 0.6366f + 56.7272f) + 0.5f);
				float noiseWave	= _Blink.y * noise + (1.0 - _Blink.y);
				noiseWave = (noiseWave + _Blink.z) * _Blink.w;

				float nfadeout = saturate(max(0.0, dist - _FadeOut.y) / max(_FadeOut.y, 0.1));
				float ffadeout = saturate(min(dist, _FadeOut.z * 0.5) / dist);	
				nfadeout = max(_FadeOut.x, ffadeout * nfadeout);
		
				o.uv = v.texcoord.xy;

				//http://math.stackexchange.com/questions/237369/given-this-transformation-matrix-how-do-i-decompose-it-into-translation-rotati
				//need sqrt(), but we simplify this
				float lengthx = unity_ObjectToWorld[0][0] * unity_ObjectToWorld[0][0] + unity_ObjectToWorld[0][1] * unity_ObjectToWorld[0][1] + unity_ObjectToWorld[0][2] * unity_ObjectToWorld[0][2];
				float lengthy = unity_ObjectToWorld[1][0] * unity_ObjectToWorld[1][0] + unity_ObjectToWorld[1][1] * unity_ObjectToWorld[1][1] + unity_ObjectToWorld[1][2] * unity_ObjectToWorld[1][2];

				float distScale	= min(max(dist - _SizeGrowStartDist,0) / _SizeGrowEndDist,1);
				float distScalex = 1.0 + distScale * distScale * _GrowSize.x;
				float distScaley = 1.0 + distScale * distScale * _GrowSize.y;

				//face to camera
				o.pos = mul(UNITY_MATRIX_P, 
						  mul(UNITY_MATRIX_MV, float4(0.0, 0.0, 0.0, 1.0)) //position (0,0,0) in camera coordinate
						  - float4(v.vertex.x, v.vertex.y, 0.0, 0.0)
						  * float4(lengthx * distScalex, lengthy * distScaley, 1.0, 1.0));

				o.color	= nfadeout * _Color * noiseWave;
						
				UNITY_TRANSFER_FOG(o, o.pos);
				return o;
			}

			v2f vert_v (appdata_full v)
			{
				v2f o;
				float3 viewPos = mul(UNITY_MATRIX_MV,v.vertex);
				float dist = length(viewPos);

				float noiseTime = _Time.y * _Blink.x;
				float noise = sin(noiseTime) * (0.5f * cos(noiseTime * 0.6366f + 56.7272f) + 0.5f);
				float noiseWave	= _Blink.y * noise + (1.0 - _Blink.y);
				noiseWave = (noiseWave + _Blink.z) * _Blink.w;
		
				float nfadeout = saturate(max(0.0, dist - _FadeOut.y) / max(_FadeOut.y, 0.1));
				float ffadeout = saturate(min(dist, _FadeOut.z * 0.5) / dist);
				nfadeout = max(_FadeOut.x, ffadeout * nfadeout);
		
				o.uv = v.texcoord.xy;

				//http://math.stackexchange.com/questions/237369/given-this-transformation-matrix-how-do-i-decompose-it-into-translation-rotati
				//need sqrt(), but we simplify this
				float lengthx = unity_ObjectToWorld[0][0] * unity_ObjectToWorld[0][0] + unity_ObjectToWorld[0][1] * unity_ObjectToWorld[0][1] + unity_ObjectToWorld[0][2] * unity_ObjectToWorld[0][2];
				float lengthy = unity_ObjectToWorld[1][0] * unity_ObjectToWorld[1][0] + unity_ObjectToWorld[1][1] * unity_ObjectToWorld[1][1] + unity_ObjectToWorld[1][2] * unity_ObjectToWorld[1][2];

				float distScale	= min(max(dist - _SizeGrowStartDist,0) / _SizeGrowEndDist,1);
				float distScalex = 1.0 + distScale * distScale * _GrowSize.z;
				float distScaley = 1.0 + distScale * distScale * _GrowSize.w;

				//face to camera
				o.pos = mul(UNITY_MATRIX_P, 
						  mul(UNITY_MATRIX_MV, float4(0.0, 0.0, 0.0, 1.0)) //position (0,0,0) in camera coordinate
						  - float4(v.vertex.x, v.vertex.y, 0.0, 0.0)
						  * float4(lengthx * distScalex, lengthy * distScaley, 1.0, 1.0));

				o.color	= nfadeout * _Color * noiseWave;
						
				UNITY_TRANSFER_FOG(o, o.pos);
				return o;
			}

			float4 frag (v2f i) : COLOR
			{		
				float4 col1 = tex2D (_MainTex, i.uv.xy).a * i.color;
				UNITY_APPLY_FOG_COLOR(i.fogCoord, col1, fixed4(0,0,0,0));
				//col1.rgb = saturate(col1.rgb - unity_FogColor.rgb);

				return col1;
			}

			ENDCG

		Pass {
			CGPROGRAM
			#pragma vertex vert_h
			#pragma fragment frag
			#pragma fragmentoption ARB_precision_hint_fastest		
			#pragma multi_compile_fog

			ENDCG 
		}	

		Pass {
			CGPROGRAM
			#pragma vertex vert_v
			#pragma fragment frag
			#pragma fragmentoption ARB_precision_hint_fastest		
			#pragma multi_compile_fog

			ENDCG 
		}	
	} //end sub shader
}
