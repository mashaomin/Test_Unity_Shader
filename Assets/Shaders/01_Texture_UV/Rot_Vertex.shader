
// 顶点旋转
Shader "Msm/Rot_Vertex"
{
	Properties
	{
		_MainTex ("主纹理", 2D) = "white" {}
        _Speed("旋转速度",Range(0,4))=1
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
			float _Speed;
			v2f vert (a2v v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = TRANSFORM_TEX(v.uv, _MainTex);
				
				float angle=_Time.y*_Speed;
				float sin_angle, cos_angle;
				sincos(angle,sin_angle,cos_angle);

				//构造2维旋转矩阵
				float2x2 rot = float2x2(
					cos_angle,-sin_angle,
					sin_angle,cos_angle
					);
				float2 pivot=float2(0.5,0.5);
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
