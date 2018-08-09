
// 片元的偏移
Shader "Msm/Offset_Frag"
{
	Properties
	{
		_MainTex ("主纹理", 2D) = "white" {}
        _SpeedX("旋转速度X",Float)=1
		_SpeedY("旋转速度Y",Float)=1
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
			float _SpeedX;
			float _SpeedY;
			v2f vert (a2v v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = TRANSFORM_TEX(v.uv, _MainTex);			
				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				fixed4 col = tex2D(_MainTex, i.uv+_Time.y*fixed2(_SpeedX,_SpeedY));
				return col;
			}
			ENDCG
		}
	}
}
