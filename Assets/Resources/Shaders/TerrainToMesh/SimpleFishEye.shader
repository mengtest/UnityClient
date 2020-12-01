// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'


Shader "LPCFramework/Image Effect/Simple Fish Eye" {
	Properties {
		_MainTex ("Base (RGB)", 2D) = "white" {}
		_Bend ("Bend", float) = 0.0
		_Intensity ("Intensity", float) = 0.0
		_StartFrom ("StartFrom", float) = 0.5
		_Expand ("Expand", float) = 0.1
	}
	
	CGINCLUDE

		#include "UnityCG.cginc"

		sampler2D _MainTex;
		uniform half _Intensity;
		uniform half _Bend;
		uniform half _StartFrom;
		uniform half _Expand;
		half4 _MainTex_ST;
		uniform half4 _MainTex_TexelSize;

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
			uvy = uvy * uvy;
			uvy = saturate(uvy - _StartFrom);
			half bend = -(i.uv.x - 0.5) * (i.uv.x - 0.5) * _Intensity * ((1.0 - _Bend) + _Bend * uvy);
#if UNITY_UV_STARTS_AT_TOP
			bend = -bend;
#endif
			half min = 0.25 * _Intensity * _Bend;
			half expand = (1.0 + _Expand * uvy) * (i.uv.x - 0.5) / (1.0 + _Expand) + 0.5;
			//when uv.y=0, it should be min-bend
			//when uv.y=1, it should be 1-bend
			half2 finaluv = half2(expand, i.uv.y * (1.0 - min) + min - bend);

			return tex2D (_MainTex, finaluv);
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
