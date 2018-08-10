Shader "Modules/Rot_Offset"
{
	Properties
	{
		//Pivot
		_MainTex ("主纹理", 2D) = "white" {}
		_RotSpeed("旋转速度",float)=1
		_OffsetXY_ScaleZW("偏移量xy,缩放ZW",Vector)=(0,0,0.5,0.5)

		_MotionTex("Motion", 2D) = "black"{}
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
		//ZWrite Off

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
				float2 eff_uv:TEXCOORD1;
			};

			struct v2f
			{
				float4 vertex : SV_POSITION;
				float2 uv : TEXCOORD0;
				float2 eff_uv:TEXCOORD1;
			};

			sampler2D _MainTex;
			float4 _MainTex_ST;
			sampler2D _MotionTex;
			float _RotSpeed;
			float4 _OffsetXY_ScaleZW;

			//RotMatrix(float2 uv,float rotspeed,float2 pivot);
			v2f vert (a2v v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.eff_uv=v.eff_uv;
				float2 uv= TRANSFORM_TEX(v.uv, _MainTex);
				
				float2 pivot=float2(0.5,0.5);
				uv=uv-pivot;	
				float angle=_RotSpeed*_Time.y;

				float2x2 rotationMatrix;float sinTheta,cosTheta;
				sincos(angle,sinTheta,cosTheta);

				uv=uv-_OffsetXY_ScaleZW.xy;
				uv= uv/_OffsetXY_ScaleZW.zw;

				// 旋转矩阵,进行旋转
				rotationMatrix = float2x2(
					cosTheta, -sinTheta,
				 	sinTheta, cosTheta  );
				uv=mul(rotationMatrix,uv);
				
				uv+=(pivot);
				
				o.uv=uv;
				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				fixed4 eff_col = tex2D(_MotionTex, i.eff_uv);
				fixed4 col = tex2D(_MainTex, i.uv);
				col=col*col.a*eff_col.a;
				return col;
			}

			float2 RotMatrix(float2 uv,float rotspeed,float2 pivot)
			{
				uv=uv-pivot;	
				float angle=rotspeed*_Time.y;

				float2x2 rotationMatrix;
				float sinTheta;
				float cosTheta;

				sincos(angle,sinTheta,cosTheta);
				// 旋转矩阵
				rotationMatrix = float2x2(
					cosTheta, -sinTheta,
				 	sinTheta, cosTheta
					 );
				uv=mul(rotationMatrix,uv);
				return uv;
			}

			ENDCG
		}
	}
}
