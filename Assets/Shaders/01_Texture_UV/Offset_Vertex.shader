Shader "Msm/Offset_Vertex"
{
	Properties
	{
		_MainTex ("主纹理", 2D) = "white" {}
        _SpeedX("旋转速度X",Float)=1
		_SpeedY("旋转速度Y",Float)=1
		_SpeedZ("旋转速度Z",Float)=1
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
			float _SpeedZ;
			v2f vert (a2v v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.vertex += float4(_SpeedX, _SpeedY, 0, _SpeedZ)*_Time.y;
				o.uv = TRANSFORM_TEX(v.uv, _MainTex);			
				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				// sample the texture
				fixed4 col = tex2D(_MainTex, i.uv);
				return col;
			}
			ENDCG
		}
	}
}
