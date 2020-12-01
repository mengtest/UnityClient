// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

// Upgrade NOTE: replaced '_Projector' with 'unity_Projector'

Shader "Unlit/ProjectorShader"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
	}
	SubShader
	{
		Tags { "Queue"="Transparent" }

		Pass
		{
			Zwrite Off
			 ColorMask RGB
			 Blend SrcAlpha OneMinusSrcAlpha 

			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"

			struct appdata
			{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
			};

			struct v2f
			{
				float4 sproj : TEXCOORD0;
				float4 vertex : SV_POSITION;
			};

			float4x4 unity_Projector;
			sampler2D _MainTex;
			float4 _MainTex_ST;
			
			v2f vert (appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.sproj = mul(unity_Projector, v.vertex);
				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				half4 coord = UNITY_PROJ_COORD(i.sproj);
				float4 c = tex2Dproj(_MainTex,coord);	
				if(c.r<1)
				{
					fixed4	color2 = fixed4(0.1,0.1,0.1,0.5);			
					return color2;
				}
				else
				{
					fixed4	color2 = fixed4(1,1,1,0);
					return color2;
				}													
			}
			ENDCG
		}
	}
}
