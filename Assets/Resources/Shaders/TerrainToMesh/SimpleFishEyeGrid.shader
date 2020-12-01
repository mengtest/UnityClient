// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'


Shader "LPCFramework/Image Effect/Simple Fish Eye Grid" {
	Properties {
		_MainTex ("Base (RGB)", 2D) = "white" {}
		_Params ("Params", vector) = (0.0, 0.2, 0.5, 0.5)

		_TestColor ("Test Color", color) = (1.0, 1.0, 1.0, 1.0)
	}
	
	CGINCLUDE

		#include "UnityCG.cginc"

		sampler2D _MainTex;
		uniform half4 _Params; //x:bend, y:intensity, z:expand, w:compact
		half4 _MainTex_ST;
		uniform half4 _MainTex_TexelSize;
		uniform half4 _TestColor;

		struct v2f_simple 
		{
			float4 pos : SV_POSITION; 
			half2 uv : TEXCOORD0;
		};	
	

		v2f_simple vert ( appdata_img v )
		{
			v2f_simple o;
			o.pos = UnityObjectToClipPos (v.vertex);
			o.uv = v.texcoord;
			return o;
		}		
		
		fixed4 frag ( v2f_simple i ) : SV_Target
		{				
			half uvy = i.uv.y;
#if UNITY_UV_STARTS_AT_TOP
			uvy = 1.0 - uvy;
#endif
			half uvysq = uvy * uvy;
			half bend = -(i.uv.x - 0.5) * (i.uv.x - 0.5) * _Params.y * ((1.0 - _Params.x) + _Params.x * uvysq);
#if UNITY_UV_STARTS_AT_TOP
			bend = -bend;
#endif
			half compactUvy = 1.0 - i.uv.y;
#if UNITY_UV_STARTS_AT_TOP
			compactUvy = 1.0 - compactUvy;
#endif
			//when compactUvy=0-0.1, need 0-0.2
			//when compactUvy=0.9-1.0, need 0.95-1
			compactUvy = (compactUvy + _Params.w * sqrt(compactUvy)) / (1.0 + _Params.w);
			compactUvy = 1.0 - compactUvy;
#if UNITY_UV_STARTS_AT_TOP
			compactUvy = 1.0 - compactUvy;
#endif
			
			half min = 0.25 * _Params.y * _Params.x;
			half expand = (1.0 + _Params.z * (1.0 - sqrt(1.0 - uvy))) * (i.uv.x - 0.5) / (1.0 + _Params.z) + 0.5;
			//when uv.y=0, it should be min-bend
			//when uv.y=1, it should be 1-bend
			half2 finaluv = half2(expand, compactUvy * (1.0 - min) + min - bend);

			//draw test grids
			half4 textColor = _TestColor * (saturate(frac(finaluv.x * 20) - 0.9) + saturate(frac(finaluv.y * 20) - 0.9));
			fixed4 color = tex2D (_MainTex, finaluv) + textColor;
			return color;
		}					

					
	ENDCG
	
	SubShader {
	  ZTest Off Cull Off ZWrite Off Blend Off
	  
	Pass {
	
		CGPROGRAM
		#pragma vertex vert
		#pragma fragment frag
		
		ENDCG
		 
		}
	}

	FallBack Off
}
