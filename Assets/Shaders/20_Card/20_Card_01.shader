


Shader "Msm/20_Card/01"
{
	Properties
	{
		_MainTex("Texture", 2D) = "black" {}
		_DistTex("Distortion Texture", 2D) = "grey" {}
		_DistMask("Distortion Mask", 2D) = "black" {}

		_EffectsLayer1Tex("Tex", 2D) = "black"{}
		_EffectsLayer1Color("Color", Color) = (1,1,1,1)
		_EffectsLayer1Motion("Motion", 2D) = "black"{}
		_EffectsLayer1MotionSpeed("MotionSpeed", float) = 0 
		_EffectsLayer1Rotation("Rotation", float) = 0
		_EffectsLayer1PivotScale("Pivot_Scale", Vector) = (0.5,0.5,1,1)
		_EffectsLayer1Translation("Translation", Vector) = (0,0,0,0)
		_EffectsLayer1Foreground("Foreground", float) = 0

	}
	SubShader
	{
		Tags 
		{ 	
			"Queue" = "Transparent"
			"RenderType" = "Transparent"
			"PreviewType" = "Plane" 
		}

		LOD 100
		ZWrite Off
		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag

			
			#include "UnityCG.cginc"

			struct a2v
			{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
			};

			struct v2f
			{
				float4 vertex : SV_POSITION;
				float2 uv : TEXCOORD0;

				float2 effect1uv : TEXCOORD1;
			};

			sampler2D _MainTex;
			//float4 _MainTex_ST;
			sampler2D _DistTex;
			sampler2D _DistMask;

			sampler2D _EffectsLayer1Tex;
			sampler2D _EffectsLayer1Motion;
			float _EffectsLayer1MotionSpeed;
			float _EffectsLayer1Rotation;
			float4 _EffectsLayer1PivotScale;
			half4 _EffectsLayer1Color;
			float _EffectsLayer1Foreground;
			float2 _EffectsLayer1Translation;


			v2f vert (a2v v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = v.uv;
				//o.uv = TRANSFORM_TEX(v.uv, _MainTex);
				
				// 旋转矩阵
				float2x2 rotationMatrix;
				float sinTheta;
				float cosTheta;

				o.effect1uv = o.uv - _EffectsLayer1PivotScale.xy;
				float angle=_EffectsLayer1Rotation * _Time.y;
				sincos(angle,sinTheta,cosTheta);
				// 旋转矩阵
				rotationMatrix = float2x2(
					cosTheta, -sinTheta,
				 	sinTheta, cosTheta
					 );

				float2 result_matrix=mul( rotationMatrix,(o.effect1uv - _EffectsLayer1Translation.xy) *
					(1 / _EffectsLayer1PivotScale.zw));
				o.effect1uv = (result_matrix)+ _EffectsLayer1PivotScale.xy;


				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				
				/*
				float2 distScroll = float2(_Time.x, _Time.x);
				fixed2 dist = (tex2D(_DistTex, i.uv + distScroll).rg - 0.5) * 2;
				fixed distMask = tex2D(_DistMask, i.uv)[0];

				fixed4 col = tex2D(_MainTex, i.uv + dist * distMask * 0.025);
				fixed bg = col.a;
				*/
				// Grab the motion texture, if the speed value is non-zero, we'll use the red and green channels as the UVs for the effect texture.
				// Else, we use the EffectUVs as is, but still keep the blue and alpha channels of the motion texture for later use (blending).
				fixed4 col =float4(0,0,0,0);
				fixed bg = col.a;
				fixed4 motion1 = tex2D(_EffectsLayer1Motion, i.uv);

				
				if (_EffectsLayer1MotionSpeed)
					motion1.y -= _Time.x * _EffectsLayer1MotionSpeed;
				else
					motion1 = fixed4(i.effect1uv.rg, motion1.b, motion1.a);
				
				fixed4 effect1 = tex2D(_EffectsLayer1Tex, motion1.xy) * motion1.a;
				effect1 *= _EffectsLayer1Color;

				// To the base color, we add the effect color, multiplied by it's own alpha, and then byu the back ground mask alpha (if this effect is not in the foreground).
				// TODO: Add support for alpha blending instead of additive, some cards seem to use that.

				col += effect1 * effect1.a * max(bg, _EffectsLayer1Foreground);
				return col;
			}
			ENDCG
		}
	}
}
