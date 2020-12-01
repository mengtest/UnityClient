Shader "LPCFramework/Environment/TreeShake"
{
	Properties {
		_Color ("Main Color", Color) = (1,1,1,1)
		_MainTex ("Base (RGB)", 2D) = "white" {}
		_Amplitude("Amplitude",Vector) =(0.1,0,0.1,0)
		_Height("Height",float) = 0		
		_TimeScale("TimeScale",float) = 1
		_TimeDelay("TimeDelay",float) = 1
		_Cutoff ("Alpha cutoff", Range(0,1)) = 0.5
	}
	SubShader
	{
		LOD 100
		Tags
		{
			"RenderType"="TransparentCutout"
			"Queue"="AlphaTest"
			"DisableBatching"= "True"
		}

		CGPROGRAM
		#pragma surface surf Lambert vertex:vert alphatest:_Cutoff
		fixed4 _Color;
		sampler2D _MainTex;		
		fixed4 _Amplitude;
		fixed _Height;
		half _TimeScale;
		half _TimeDelay;

		struct Input
		{
			half2 uv_MainTex;
		};

		void surf (Input IN, inout SurfaceOutput o)
		{
			half4 c = tex2D (_MainTex, IN.uv_MainTex) * _Color;
			o.Albedo = c.rgb;
			o.Alpha = c.a;
		}

		void vert (inout appdata_full v)
		{  
			half dis = v.vertex.y - _Height;
			half time = (_Time.y + _TimeDelay) * _TimeScale;			
			if(dis > 0)
				v.vertex.xyz += dis * sin(time) * _Amplitude.xyz; 
		}

		ENDCG
	}	
}