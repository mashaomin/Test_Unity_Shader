Shader "Modules/Rot_Offset"
{
	Properties
	{
		_MainTex ("主纹理", 2D) = "white" {}
		_RotSpeed("旋转速度",float)=1
		_OffsetXY_PivotZW("偏移量xy,锚点ZW",Vector)=(0,0,0.5,0.5)
	}
	SubShader
	{
		/*
		Tags 
		{ 
			"Queue" = "Transparent"
			"RenderType" = "Transparent"
			"PreviewType" = "Plane"
		 }*/
		 Tags {"Queue"="AlphaTest" "IgnoreProjector"="True" "RenderType"="TransparentCutout"}
		LOD 100

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
			};

			sampler2D _MainTex;
			float4 _MainTex_ST;
			float _RotSpeed;
			float4 _OffsetXY_PivotZW;
			//RotMatrix(float2 uv,float rotspeed,float2 pivot);
			v2f vert (a2v v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				
				float2 uv=o.uv = TRANSFORM_TEX(v.uv, _MainTex);;
				float2 pivot=_OffsetXY_PivotZW.zw;
				float rotspeed=_RotSpeed;
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
				uv+=pivot+_OffsetXY_PivotZW.xy;
				o.uv= uv;
				//o.uv = RotMatrix(v.uv,_RotSpeed,_OffsetXY_PivotZW.xy)//TRANSFORM_TEX(v.uv, _MainTex);
				
				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				fixed4 col = tex2D(_MainTex, i.uv);
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
