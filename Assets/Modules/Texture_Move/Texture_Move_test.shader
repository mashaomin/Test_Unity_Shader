Shader "Modules/Texture_Move/01"
{
	Properties
	{
		//Pivot
		_MainTex ("主纹理", 2D) = "white" {}
		_MotionTex("Motion", 2D) = "black"{}
		_MotionSpeed("MotionSpeed",float)=5
		_Color("颜色",Color)=(1,1,1,1)
		
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
			sampler2D _MotionTex;
			
			float4 _Color;
			float _MotionSpeed;

			//RotMatrix(float2 uv,float rotspeed,float2 pivot);
			v2f vert (a2v v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.eff_uv=v.eff_uv;
				o.uv= v.uv;

				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				/*fixed4 col =fixed4(0,0,0,0);
				fixed4 motion1 = tex2D(_MotionTex, i.uv);

				//motion1.y -= _Time.x * _MotionSpeed;

				col=tex2D(_MainTex,motion1.xy);
				col=col*_Color;
				col=col*col.a;*/
				float4 mot_col=tex2D(_MotionTex, i.eff_uv);
				//mot_col.y -= _Time.x * _MotionSpeed;
				i.eff_uv.x=1-i.eff_uv.x;
				float4 main_col=tex2D(_MainTex, i.eff_uv);
				return _Color/**_Color.a*/*main_col*main_col.a/**mot_col.a*/;
			}

			ENDCG
		}
	}
}
