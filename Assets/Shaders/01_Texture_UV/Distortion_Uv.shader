
// 扭曲效果
Shader "Msm/Distortion_Uv"
{
	Properties
	{
		_MainTex ("主纹理", 2D) = "white" {}
        _Twist("Twist",float) = 1
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
			float4 _MainTex_TexelSize;
			float _Twist;
			v2f vert (a2v v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = TRANSFORM_TEX(v.uv, _MainTex);
				
				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				fixed2 tuv = i.uv;
                                 
				//这里将当前纹理坐标平移至中心点，表示按中心旋转，
				//如果有需要，可以算出3d坐标在屏幕上的位置，然后根据屏幕位置做平移
				//fixed2 point=fixed2(0.5f,0.5f);
                fixed2 uv = fixed2(tuv.x - 0.5, tuv.y - 0.5);
				
 				//通过距离计算出当前点的旋转弧度PI/180=0.1745
                float angle = _Twist * 0.1745 / (length(uv) + 0.1);
                float sinval, cosval;
				// sincos该函数是同时计算 x的 sin值和 cos值，其中 s=sin(x)，c=cos(x)。该函数用于“同时需要计算sin 值和cos 值的情况”，比分别运算要快很多!
                sincos(angle, sinval, cosval);
 				//构建旋转矩阵
                float2x2 mat = float2x2(cosval, -sinval, sinval, cosval);
 				//旋转完成后，平移至原位置
                uv = mul(mat, uv) + 0.5;
 
                // sample the texture
                fixed4 col = tex2D(_MainTex, uv);
                           
                return col;
				
			}
			ENDCG
		}
	}
}
