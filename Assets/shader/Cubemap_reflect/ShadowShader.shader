// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'
// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Myshader" {
	Properties {
		_Color ("Color Tint", Color) = (1, 1, 1, 1)
		_ReflectColor("Reflection Color", Color)=(1,1,1,1)
		_ReflectMount("Reflect Mount", Range(0,1)) = 0.5
		_CubeMap("Reflection Cube", Cube) = "_skybox"{}
	}
	SubShader {
		Pass {
			Tags { "LightMode"="ForwardBase" }
			CGPROGRAM

			#pragma vertex vert
			#pragma fragment frag
			
			#include "Lighting.cginc"
			
            float4 _Color;
			float4 _ReflectColor;
			float _ReflectMount;
			samplerCUBE _CubeMap;
			
			struct a2v {
				float4 vertex : POSITION;
				float3 normal : NORMAL;
			};
			
			struct v2f {
				float4 pos : SV_POSITION;
				float3 worldNormal : TEXCOORD0;
				float3 worldPos : TEXCOORD1;
				float3 worldViewDir : TEXCOORD2;
				float3 worldReflect: TEXCOORD3;
			};
			
			v2f vert(a2v v) {
			 	v2f o;
			 	o.pos = UnityObjectToClipPos(v.vertex);
			 	
			 	o.worldNormal = UnityObjectToWorldNormal(v.normal);
			 	
			 	o.worldPos = mul(unity_ObjectToWorld, v.vertex).xyz;

				o.worldViewDir = UnityWorldSpaceLightDir(o.worldPos);
				o.worldReflect = reflect(-o.worldViewDir, o.worldNormal);

			 	return o;
			}
			
			fixed4 frag(v2f i) : SV_Target {
				float3 worldNormal = normalize(i.worldNormal);
				float3 worldLightDir = normalize(UnityWorldSpaceLightDir(i.worldPos));		
				float3 worldViewDir = normalize(i.worldViewDir);
				float3 diffuse = _LightColor0.rgb * _Color.rgb * max(0, dot(worldNormal, worldLightDir));
				float3 reflection = texCUBE(_CubeMap, i.worldReflect).rgb;
				float3 color = lerp(diffuse, reflection, _ReflectMount);
				
				return fixed4(color, 1.0);
			}
			
			ENDCG
		}
	} 
}
