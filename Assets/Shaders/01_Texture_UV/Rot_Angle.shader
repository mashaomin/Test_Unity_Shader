
// 角度旋转
Shader "Msm/Rot_Angle"
{
	Properties
	{
		_MainTex ("主纹理", 2D) = "white" {}
		_Angle("角度",Range(0,360))=0
	}
	SubShader
	{
		Tags { "RenderType"="Opaque" }
		LOD 100

		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			// make fog work
			#pragma multi_compile_fog
			
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
			float _Angle;
			v2f vert (a2v v)
			{
				
				v2f o;
				// mvp转换，并且采集uv坐标
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = TRANSFORM_TEX(v.uv, _MainTex);
				// 旋转需求确定锚点
				float2 pivot=float2(0.5,0.5);
				// 角度转弧度，cos输入的参数是弧度
				float angle=radians(_Angle);
				float sinAngle, cosAngle;
				sincos(angle,sinAngle,cosAngle);
				// 构造2维旋转矩阵
				float2x2 rot = float2x2(cosAngle,-sinAngle,sinAngle,cosAngle);

				// 先移到中心旋转
				float2 uv = o.uv - pivot;
				// 旋转
				o.uv = mul(rot,uv);
				//再移回来
                o.uv += pivot;
			
				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				return tex2D(_MainTex, i.uv);
			}
			ENDCG
		}
	}
}
