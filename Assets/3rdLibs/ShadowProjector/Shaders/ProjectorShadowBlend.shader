Shader "Shadow Projector/ProjectorShadowBlend" 
{ 
	Properties
	{
		_Color ("Main Colour", Color) = (1,1,1,0)
		_ShadowTex ("Shadow Texture", 2D) = "gray" {  }
		_Multiply ("Multipy", Float) = 1.0
	}
	
	Subshader
	{
		Tags { "RenderType"="Transparent" "IgnoreProjector"="True" "Queue"="Transparent+100"}
	
		Pass
		{
			Lighting Off
			ZWrite Off
			Cull Off
			Offset -1, -1
			Fog { Mode Off }

						
			//Blend One Zero
			Blend SrcAlpha OneMinusSrcAlpha
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#include "UnityCG.cginc"
			
			struct appdata_t {
				float4 vertex : POSITION;
				float2 texcoord : TEXCOORD;
			};

			struct v2f
			{
				float4 pos : SV_POSITION;
				float2 uv_Main : TEXCOORD0;
			};
			
			float4 _ShadowTex_ST;			
			half4 _Color;			
			float _Multiply;
			
			v2f vert(appdata_t v)
			{
				v2f o;				
				o.pos = UnityObjectToClipPos (v.vertex);		
				o.uv_Main = TRANSFORM_TEX(v.texcoord,_ShadowTex);		
				return o;
			}
			
			sampler2D _ShadowTex;
			half4 frag (v2f i) : COLOR
			{
				half4 tex = tex2D(_ShadowTex,i.uv_Main) * _Color;

				return tex * _Multiply;												
			}
		
			ENDCG
		}
	}
}


