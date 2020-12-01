// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

// Upgrade NOTE: replaced '_Projector' with 'unity_Projector'

Shader "LPCFramework/Projector/Moving Shadow" 
{ 
	Properties
	{
		_ShadowTex ("Cookie", 2D) = "gray" {  }
		_SpeedX ("speedx", float) = 0
		_SpeedY ("speedy", float) = 0
		_Color ("Color", Color) = (0,0,0,1)
	}
	
	Subshader
	{
		Tags { "RenderType"="Transparent"  "Queue"="Transparent-1"}
	
		Pass
		{
			ZWrite Off
			ColorMask RGB
			Blend SrcAlpha OneMinusSrcAlpha
			Offset -1, -1
			
			CGPROGRAM
			
			#pragma vertex vert
			#pragma fragment frag
			#pragma fragmentoption ARB_precision_hint_fastest
			#pragma multi_compile_fog
			#include "UnityCG.cginc"
			
			struct v2f
			{
				float4 pos : SV_POSITION;
				float4 uv_Main : TEXCOORD0;
				UNITY_FOG_COORDS(1)
			};
			
			sampler2D _ShadowTex;
			float4x4 unity_Projector;
			float _SpeedX;
			float _SpeedY;
			float4 _Color;
			
			v2f vert(appdata_tan v)
			{
				v2f o;
				o.pos = UnityObjectToClipPos (v.vertex);
				o.uv_Main = mul (unity_Projector, v.vertex);
				UNITY_TRANSFER_FOG(o, o.pos);
				return o;
			}
			
			half4 frag (v2f i) : COLOR
			{
				float factor = tex2Dproj(_ShadowTex, UNITY_PROJ_COORD(i.uv_Main + half4(_SpeedX, _SpeedY, 0, 0) * _Time.xxxx)).a;
				half4 tex = factor * _Color * 1.5;
				UNITY_APPLY_FOG(i.fogCoord, tex);
				return tex;
			}
		
			ENDCG
		}
	}
}


