
// 顶点旋转
Shader "Msm/Rot_Vertex_02"
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

			float4 CalRot(float4 pos)
			{
				float rot=_Time.y*_Speed;
				float s,c;
				//sincos(radians(rot), s, c);
				sincos(rot, s,c);
			    //float2x2 rot_matrix=float2x2(c,-s,s,c);
				// 绕y轴旋转
				/*float3x3 rot_matrix=float3x3(
					c,0,-s,
					0,1,0,
					s,0,c
				);*/

				// 绕z轴旋转
				float3x3 rot_matrix=float3x3(
					c,s,0,
					-s,c,0,
					0,0,1
				);

				pos.xyz=mul(rot_matrix,pos.xyz);
			    //pos.xyz=mul(pos.xyz,rot_matrix);
				return pos;

			}

			v2f vert (a2v v)
			{
				v2f o;
				//float4 k=float4(v.vertex.x,v.vertex.y,1.0,1.0);
				float4 k=CalRot(v.vertex);
				o.vertex = UnityObjectToClipPos(k);
				o.uv = TRANSFORM_TEX(v.uv, _MainTex);
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
