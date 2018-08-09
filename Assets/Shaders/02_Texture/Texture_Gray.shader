
// 图片灰化
// 操作流程:为图片的RGB分别乘以权重然后加起来得到一个灰色值，并且将这个灰色值作为新的RGB值
// 人眼对绿色的敏感度最高，对红色的敏感度次之，对蓝色的敏感度最低，因此使用不同的权重将得到比较合理的灰度图像。实验和理论推导出来的结果是0.299、0.587、0.114。 
Shader "Msm/Texture/Texture_Gray"
{
	Properties
	{
		_MainTex ("主纹理", 2D) = "white" {}
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

			#include "UnityCG.cginc"
			
			// 应用到顶点数据
			struct a2v
			{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
			};
			
			// 顶点Vertex到片元Frag传递的数据，必须要要有SV_POSITION
			struct v2f
			{
				float4 vertex : SV_POSITION;
				float2 uv : TEXCOORD0;
			};

			sampler2D _MainTex;
			float4 _MainTex_ST;
			v2f vert (a2v v)
			{
				v2f o;
				// MVP转换
				o.vertex = UnityObjectToClipPos(v.vertex);
				// 采集纹理uv
				o.uv = TRANSFORM_TEX(v.uv, _MainTex);
				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				// sample the texture
				// 通过UV坐标采样颜色
				fixed4 col = tex2D(_MainTex, i.uv);
				// 灰度计算
				float gray = dot(col.rgb, float3(0.299, 0.587, 0.114));
				col.rgb = float3(gray, gray, gray);
				// 返回这个片元的像素颜色
				return col;
			}
			ENDCG
		}
	}
}
