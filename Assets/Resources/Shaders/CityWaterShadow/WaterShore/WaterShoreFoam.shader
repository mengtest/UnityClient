// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "LPCFramework/WaterShoreFoam" 
{  
    Properties 
	{          
		_WaterColor("Water Color",Color) = (0,0.25,0.4,1)  
		_FarColor("Water FaceColor",Color)=(.2,1,1,.3)  
		[NoScaleOffset]_BumpMap("NormalMap", 2D) = "white" {}  
		_BumpPower("NormalStrength",Range(-1,1))=-0.4  
		_EdgeColor("EdgeColor",Color)=(0,1,1,0)  		
		_WaveSpeed("Wave Speed",Range(0,10))=2.3  
		[NoScaleOffset]_WaveTex("WaveTex",2D)="white" {}  
		_EdgeRange("Edge Range",Range(0.1,1))=0.17  
		_WaveSize("WaveSize",Range(0.01,1))=.055  
		_WaveOffset("WaveOffset",vector)=(0,0.04,0 ,0.01)  
		_LightColor("LightColor",Color)=(1,1,1,1)  
		_LightVector("LightVector",vector)=(.5,.5,.5,100)  
		

		_GAmplitude ("Wave Amplitude", Vector) = (1 ,3, -9.8, 0.5)
		_GFrequency ("Wave Frequency", Vector) = (2.0, 0, 2.0, 1.0)
		_GSteepness ("Wave Steepness", Vector) = (1.0, 0, 1.0, 1.0)
		_GSpeed ("Wave Speed", Vector) = (1.0, 0, 1.0, 1.0)
		_GDirectionAB ("Wave DirectionAB", Vector) = (0.5 ,0, 0.1, 1.0)
		_GDirectionCD ("Wave DirectionCD", Vector) = (0.1 ,0, 0.5, 1.0)

	}  
	SubShader
	{  
		Tags{"RenderType" = "Opaque" "Queue" = "Transparent"}  
		Blend SrcAlpha OneMinusSrcAlpha  
		LOD 200  
        Pass
		{  
            CGPROGRAM  
            #pragma vertex vert  
            #pragma fragment frag  
            #pragma multi_compile_fog  
            
            #pragma target 3.0  
            #include "UnityCG.cginc"  
			#include "WaterCalc.cginc"
  
			fixed4 _WaterColor;  
			fixed4 _FarColor;  
			fixed4 _LightColor;  
			sampler2D _BumpMap;  
			float _WaveSize;  
			float4 _WaveOffset;  
			float4 _LightVector;  
			float _BumpPower;  
			
			fixed4 _EdgeColor;  			 
			float _WaveSpeed;  
			sampler2D _WaveTex;  
			float _EdgeRange;  
			sampler2D_float _CameraDepthTexture;  
        		
			struct a2v 
			{  
				float4 vertex:POSITION;  
				half3 normal : NORMAL;  
			};  
			struct v2f  
			{  
			    float4 pos : POSITION;  
			    UNITY_FOG_COORDS(0)  
			    half3 normal:TEXCOORD1;  
			    float4 screenPos:TEXCOORD2;  
			    fixed3 viewDir:TEXCOORD3;  
			    fixed2 uv[2] : TEXCOORD4;  
			};  

			v2f vert(a2v v)  
			{  
			    v2f o;  
				
			    o.pos = UnityObjectToClipPos(v.vertex);  

				half3 worldSpaceVertex = mul(unity_ObjectToWorld,(v.vertex)).xyz;
				half3 vtxForAni = (worldSpaceVertex).xzz;
				half3 nrml;
				half3 offsets;
				Gerstner (
					offsets, v.vertex.xyz, vtxForAni,						
					_GAmplitude,											
					_GFrequency,											
					_GSteepness,											
					_GSpeed,												
					_GDirectionAB,											
					_GDirectionCD											
				);
		
				v.vertex.xyz += offsets;


			    float4 wPos=mul(unity_ObjectToWorld,v.vertex);  
			    o.uv[0]=wPos.xz*_WaveSize+_WaveOffset.xy*_Time.y * _WaveSpeed;  
			    o.uv[1]=wPos.xz*_WaveSize+_WaveOffset.zw*_Time.y * _WaveSpeed;  
			    o.normal=UnityObjectToWorldNormal(v.normal);  
			    o.viewDir= WorldSpaceViewDir(v.vertex);  
			    o.screenPos = ComputeScreenPos(o.pos);  
			    COMPUTE_EYEDEPTH(o.screenPos.z);  
				UNITY_TRANSFER_FOG(o, o.pos);
			    return o;  
			}  
			fixed4 frag(v2f i):COLOR 
			{  
			    fixed4 col=_WaterColor;  
			    half3 nor = UnpackNormal((tex2D(_BumpMap,i.uv[0])+tex2D(_BumpMap,i.uv[1]))*.5f);  
			    nor= normalize(i.normal + nor.xzy *half3(1,0,1)* _BumpPower);  
			    half spec =max(0,dot(nor,normalize(normalize(_LightVector.xyz)+normalize(i.viewDir))));  
			    spec = pow(spec,_LightVector.w);  
			    half fresnel=dot(nor,normalize(i.viewDir));  
			    fresnel=saturate(dot(nor*fresnel,normalize(i.viewDir)));  
			    
			    half sceneZ = LinearEyeDepth(SAMPLE_DEPTH_TEXTURE_PROJ(_CameraDepthTexture, UNITY_PROJ_COORD(i.screenPos)));  
			    half depth=saturate((sceneZ-i.screenPos.z)*_EdgeRange);  

				//float sceneZ = max(0,LinearEyeDepth (UNITY_SAMPLE_DEPTH(tex2Dproj(_CameraDepthTexture, UNITY_PROJ_COORD(i.screenPos)))) - _ProjectionParams.g);
				//float partZ = max(0,i.screenPos.z - _ProjectionParams.g);		
				//half depth=saturate((sceneZ-i.screenPos.z)*_EdgeRange); 

			    fixed4 edge = (tex2D(_WaveTex,i.uv[0])+tex2D(_WaveTex,i.uv[1]));  								

				//edge.a = saturate(1-depth);
			    col = lerp(edge*_EdgeColor,col,depth);  


				//float sceneZ2 = max(0,LinearEyeDepth (UNITY_SAMPLE_DEPTH(tex2Dproj(_CameraDepthTexture, UNITY_PROJ_COORD(i.screenPos)))) - _ProjectionParams.g);
				//float partZ2 = max(0,i.screenPos.z - _ProjectionParams.g);	
				//half depth2=saturate((sceneZ2-partZ2) / _Depth); 
				//fixed RimAllphaMultiply = (_RimColor.a*(1.0 - pow(saturate((sceneZ2-partZ2)/_RimSize),_Rimfalloff)));

				//col = lerp(lerp(col.rgba,(col.rgba*(1.0 - 0.1)),depth2),_RimColor.rgba,saturate(RimAllphaMultiply));
				
			    //float time=_Time.y*_WaveSpeed;  
			    //float wave=tex2D(_WaveTex,float2(time+depth,1)).a;  
			    col+=_EdgeColor *saturate(1-depth)*edge.a;  			    
			    col.rgb=lerp(col,_FarColor,_FarColor.a-fresnel);  
			    col.rgb+=_LightColor.rgb*spec*_LightColor.a;  			
				
				UNITY_APPLY_FOG(i.fogCoord, col);	
			    return col;  
			}  
			ENDCG  
		}  
    }  
    FallBack OFF  
}  