#ifndef WATER_CALC_INCLUDED
#define WATER_CALC_INCLUDED


float4 _GAmplitude;
float4 _GFrequency;
float4 _GSteepness;
float4 _GSpeed;
float4 _GDirectionAB;
float4 _GDirectionCD;


half3 GerstnerOffset (half2 xzVtx, half4 steepness, half4 amp, half4 freq, half4 speed, half4 dirAB, half4 dirCD) 
{
	half3 offsets;
		
	half4 AB = steepness.xxyy * amp.xxyy * dirAB.xyzw;
	half4 CD = steepness.zzww * amp.zzww * dirCD.xyzw;
		
	half4 dotABCD = freq.xyzw * half4(dot(dirAB.xy, xzVtx), dot(dirAB.zw, xzVtx), dot(dirCD.xy, xzVtx), dot(dirCD.zw, xzVtx));
	half4 TIME = _Time.yyyy * speed;
		
	half4 COS = cos (dotABCD + TIME);
	half4 SIN = sin (dotABCD + TIME);
		
	offsets.x = dot(COS, half4(AB.xz, CD.xz));
	offsets.z = dot(COS, half4(AB.yw, CD.yw));
	offsets.y = 0;//dot(SIN, amp);

	return offsets;			
}
	
void Gerstner (	out half3 offs,
				half3 vtx, half3 tileableVtx, 
				half4 amplitude, half4 frequency, half4 steepness, 
				half4 speed, half4 directionAB, half4 directionCD ) 
{
			
	offs = GerstnerOffset(tileableVtx.xz, steepness, amplitude, frequency, speed, directionAB, directionCD);									
}

#endif