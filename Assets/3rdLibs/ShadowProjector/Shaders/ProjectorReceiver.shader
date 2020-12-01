 Shader "Shadow Projector/ProjectorReceiver"
 {
     Properties
     {
         _ShadowTex ("Cookie", 2D) = "gray"
     }
      
     Subshader
     {
         Tags { "RenderType"="Transparent" "Queue"="Transparent+2" }
         Pass
         {
             ZWrite Off
             ColorMask RGB			 
			 Blend SrcAlpha OneMinusSrcAlpha			 
			 Offset -1, -1
			 Fog { Mode Off}
			 Cull Off
			 Lighting Off


             CGPROGRAM
             #pragma vertex vert
             #pragma fragment frag
   
             #include "UnityCG.cginc"
              
             struct v2f
             {
                 float4 pos : SV_POSITION;
                 float4 uv_Main : TEXCOORD0;                 
             };
             
              
             sampler2D _ShadowTex;
             float4x4 _GlobalProjector;             
              
             v2f vert(appdata_tan v)
             {
                 v2f o;
                 o.pos = UnityObjectToClipPos (v.vertex);
                 o.uv_Main = mul (_GlobalProjector, v.vertex);                 
                 return o;
             }
              
             half4 frag (v2f i) : COLOR
             {
                 half4 tex = tex2D(_ShadowTex, i.uv_Main.xy);   
					   		
                 return tex;
             }
             ENDCG
      
         }
     }
 }