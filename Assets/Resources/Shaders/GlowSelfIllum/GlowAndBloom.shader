// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'


Shader "LPCFramework/Image Effect/Glow and Bloom" {
	Properties {
		_MainTex ("Base (RGB)", 2D) = "white" {}
		_Bloom ("Bloom (RGB)", 2D) = "black" {}
		_Glow ("Bloom (RGB)", 2D) = "black" {}
	}
	
	CGINCLUDE

		#include "UnityCG.cginc"

		sampler2D _MainTex;
		sampler2D _Bloom;
		sampler2D _Glow;
				
		uniform half4 _MainTex_TexelSize;
		half4 _MainTex_ST;
		
		uniform half4 _Parameter; //blur size, 0, threshold, intensity
		uniform half _GlowTextureSize;
		uniform half4 _OffsetsA;
		uniform half4 _OffsetsB;
		
		#define ONE_MINUS_THRESHHOLD_TIMES_INTENSITY _Parameter.w
		#define THRESHHOLD _Parameter.z

		// weight curves
		//static const half4 simpleCurve4[2] = { half4(0.25,0.25,0.25,0), half4(0.5,0.5,0.5,1) };
		static const half4 simpleCurve4[2] = { half4(0.15,0.15,0.15,0), half4(0.4,0.4,0.4,1) };

		static const half4 curve4[7] = { half4(0.0205,0.0205,0.0205,0), half4(0.0855,0.0855,0.0855,0), half4(0.232,0.232,0.232,0),
			half4(0.324,0.324,0.324,1), half4(0.232,0.232,0.232,0), half4(0.0855,0.0855,0.0855,0), half4(0.0205,0.0205,0.0205,0) };

		struct v2f_simple 
		{
			float4 pos : SV_POSITION; 
			half2 uv : TEXCOORD0;

#if UNITY_UV_STARTS_AT_TOP
			half2 uv2 : TEXCOORD1;
#endif
			half2 glowuv1 : TEXCOORD2;
			half2 glowuv2 : TEXCOORD3;
		};	

		struct v2f_tap
		{
			float4 pos : SV_POSITION;
			half2 uv20 : TEXCOORD0;
			half2 uv21 : TEXCOORD1;
			half2 uv22 : TEXCOORD2;
			half2 uv23 : TEXCOORD3;
		};			

		v2f_tap vert4Tap ( appdata_img v )
		{
			v2f_tap o;

			o.pos = UnityObjectToClipPos (v.vertex);
			o.uv20 = v.texcoord + _MainTex_TexelSize.xy;
			o.uv21 = v.texcoord + _MainTex_TexelSize.xy * half2(-0.5h,-0.5h);
			o.uv22 = v.texcoord + _MainTex_TexelSize.xy * half2(0.5h,-0.5h);
			o.uv23 = v.texcoord + _MainTex_TexelSize.xy * half2(-0.5h,0.5h);
        	//o.uv20 = UnityStereoScreenSpaceUVAdjust(v.texcoord + _MainTex_TexelSize.xy, _MainTex_ST);
			//o.uv21 = UnityStereoScreenSpaceUVAdjust(v.texcoord + _MainTex_TexelSize.xy * half2(-0.5h,-0.5h), _MainTex_ST);
			//o.uv22 = UnityStereoScreenSpaceUVAdjust(v.texcoord + _MainTex_TexelSize.xy * half2(0.5h,-0.5h), _MainTex_ST);
			//o.uv23 = UnityStereoScreenSpaceUVAdjust(v.texcoord + _MainTex_TexelSize.xy * half2(-0.5h,0.5h), _MainTex_ST);

			return o; 
		}		
		
		fixed4 fragDownsample ( v2f_tap i ) : SV_Target
		{				
			fixed4 color = tex2D (_MainTex, i.uv20);
			color += tex2D(_MainTex, i.uv21);
			color += tex2D(_MainTex, i.uv22);
			color += tex2D(_MainTex, i.uv23);
#if UNITY_UV_STARTS_AT_TOP
			i.uv20.y = 1.0 - i.uv20.y;
			i.uv21.y = 1.0 - i.uv21.y;
			i.uv22.y = 1.0 - i.uv22.y;
			i.uv23.y = 1.0 - i.uv23.y;
#endif
			color += tex2D(_Glow, i.uv20) * 2.0;
			color += tex2D(_Glow, i.uv21) * 2.0;
			color += tex2D(_Glow, i.uv22) * 2.0;
			color += tex2D(_Glow, i.uv23) * 2.0;
			return max(color/4 - THRESHHOLD, 0) * ONE_MINUS_THRESHHOLD_TIMES_INTENSITY;
		}					
						
		v2f_simple vertBloom ( appdata_img v )
		{
			v2f_simple o;
			
			o.pos = UnityObjectToClipPos (v.vertex);
			o.uv = v.texcoord;

			o.glowuv1 = float2(1.0, 0.0) * _Parameter.y;
			o.glowuv2 = float2(0.0, 1.0) * _Parameter.y;

			//UnityStereoScreenSpaceUVAdjust is only active when _MainTex_ST is not (0,0-1,1), which is not our case
        	//o.uv = UnityStereoScreenSpaceUVAdjust(v.texcoord, _MainTex_ST);

        	
#if UNITY_UV_STARTS_AT_TOP
			o.uv2 = o.uv;
        	if (_MainTex_TexelSize.y < 0.0)
			{
        		o.uv.y = 1.0 - o.uv.y;
			}
#endif
        	        	
			return o; 
		}

		fixed4 fragBloom ( v2f_simple i ) : SV_Target
		{	
#if UNITY_UV_STARTS_AT_TOP
			fixed4 color = tex2D(_MainTex, i.uv2);		
#else
			fixed4 color = tex2D(_MainTex, i.uv);			
#endif

			half2 guv = i.uv.xy; 
			half2 netFilterWidth = i.glowuv1;
			half2 coords = guv - netFilterWidth * 3.0;  
			
			half4 glowc = 0;
  			for( int l = 0; l < 7; l++ )  
  			{   
				half4 tap = tex2D(_Glow, coords);
				glowc += tap * curve4[l];
				coords += netFilterWidth;
  			}
			netFilterWidth = i.glowuv2;
			coords = guv - netFilterWidth * 3.0;  
			for( int x = 0; x < 7; x++ )  
  			{   
				half4 tap = tex2D(_Glow, coords);
				glowc += tap * curve4[x];
				coords += netFilterWidth;
  			}

			//return glowc;
			return color + tex2D(_Bloom, i.uv) + glowc;
		} 
		
		struct v2f_withBlurCoords8 
		{
			float4 pos : SV_POSITION;
			half4 uv : TEXCOORD0;
			half2 offs1 : TEXCOORD1;
			half2 offs2 : TEXCOORD2;
			half2 offs3 : TEXCOORD3;
			half2 offs4 : TEXCOORD4;
		};	
		
		v2f_withBlurCoords8 vertBlurHV (appdata_img v)
		{
			v2f_withBlurCoords8 o;
			o.pos = UnityObjectToClipPos (v.vertex);
			
			o.uv = half4(v.texcoord.xy,1,1);
			o.offs1 = _MainTex_TexelSize.xy * half2(-1.0, 1.0) * _Parameter.x;
			o.offs2 = _MainTex_TexelSize.xy * half2(1.0, -1.0) * _Parameter.x;
			o.offs3 = _MainTex_TexelSize.xy * half2(1.0, 1.0) * _Parameter.x;
			o.offs4 = _MainTex_TexelSize.xy * half2(-1.0, -1.0) * _Parameter.x;
			 
			return o; 
		}	

		half4 fragBlur8 ( v2f_withBlurCoords8 i ) : SV_Target
		{
			half2 uv = i.uv.xy; 
			
			//half4 tap1 = tex2D(_MainTex, UnityStereoScreenSpaceUVAdjust(uv, _MainTex_ST));
			//half4 tap2 = tex2D(_MainTex, UnityStereoScreenSpaceUVAdjust(uv + i.offs1, _MainTex_ST));
			//half4 tap3 = tex2D(_MainTex, UnityStereoScreenSpaceUVAdjust(uv + i.offs2, _MainTex_ST));
			//half4 tap4 = tex2D(_MainTex, UnityStereoScreenSpaceUVAdjust(uv + i.offs3, _MainTex_ST));
			//half4 tap5 = tex2D(_MainTex, UnityStereoScreenSpaceUVAdjust(uv + i.offs4, _MainTex_ST));
			half4 tap1 = tex2D(_MainTex, uv);
			half4 tap2 = tex2D(_MainTex, uv + i.offs1);
			half4 tap3 = tex2D(_MainTex, uv + i.offs2);
			half4 tap4 = tex2D(_MainTex, uv + i.offs3);
			half4 tap5 = tex2D(_MainTex, uv + i.offs4);

			//return tap1 * simpleCurve4[1] + tap2 * simpleCurve4[0] + tap3 * simpleCurve4[0];
			return tap1 * simpleCurve4[1] + tap2 * simpleCurve4[0] + tap3 * simpleCurve4[0] + tap4 * simpleCurve4[0] + tap5 * simpleCurve4[0];
		}	
					
	ENDCG
	
	SubShader {
	  ZTest Off Cull Off ZWrite Off Blend Off
	  
	// 0
	Pass {
	
		CGPROGRAM
		#pragma vertex vertBloom
		#pragma fragment fragBloom
		
		ENDCG
		 
		}

	// 1
	Pass { 
	
		CGPROGRAM
		
		#pragma vertex vert4Tap
		#pragma fragment fragDownsample
		
		ENDCG
		 
		}

	// 2 blur1
	Pass {
		ZTest Always
		Cull Off
		
		CGPROGRAM 
		
		#pragma vertex vertBlurHV
		#pragma fragment fragBlur8
		
		ENDCG 
		}	

	}	

	FallBack Off
}
