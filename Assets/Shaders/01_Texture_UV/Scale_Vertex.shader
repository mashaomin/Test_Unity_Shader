Shader "Msm/Scale_Vertex"
{
	Properties
	{
		_MainTex ("主纹理", 2D) = "white" {}
		_Scale("缩放",Range(0,3))=1
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
			float _Scale;
			v2f vert (a2v v)
			{
				v2f o;


				float4x4 scale_matrix=float4x4(
					_Scale,0,0,0,
					0,_Scale,0,0,
					0,0,0,0,
					0,0,0,1
				);		
				float4 vertex=mul(scale_matrix,v.vertex);
				o.vertex = UnityObjectToClipPos(vertex);
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
