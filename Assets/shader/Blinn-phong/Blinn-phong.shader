// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'

// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'

// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Unlit/Myshader"
{
    Properties{
        _Diffuse("Diffuse control", Color) = (1.0,1.0,1.0,1.0)
        _Gloss("float", Range(2.0,256.0)) = 2.0
    }
    SubShader
    {
        Pass
        {
            Tags{"LightMode"="ForwardBase"}
            CGPROGRAM
            #pragma vertex vert 
            #pragma fragment frag 
            #include "Lighting.cginc"
            float4 _Diffuse;
            float _Gloss;
            struct a2v{
                float4 vert : POSITION;
                float3 normal : NORMAL;
                float2 tex : TEXCOORD0;
            };
            struct v2f{
                float4 pos:SV_POSITION;
                float3 color:TEXCOORD0;
                float3 normal:TEXCOORD1;
                float4 worldPos:TEXCOORD2;
            };
            v2f vert(a2v v){ 
                v2f o;
                o.pos = UnityObjectToClipPos (v.vert);
                float3 worldNormal = normalize(mul((float3x3)unity_ObjectToWorld, v.normal));
                o.worldPos = mul(unity_ObjectToWorld, v.vert);
                o.normal = worldNormal;
                return o;
            }
            float4 frag(v2f o) : SV_Target {
                float3 worldLight = normalize(_WorldSpaceLightPos0.xyz);
                float3 viewDir = _WorldSpaceCameraPos - o.worldPos;
                float3 reflectDir = normalize(normalize(worldLight) + normalize(viewDir.xyz));
                float3 specularColor = _LightColor0.rgb * pow(saturate(dot(reflectDir, o.normal)), _Gloss);
                float3 diffuseColor = _LightColor0.rgb * _Diffuse.rgb * ((0.5 * dot(o.normal, worldLight)) + 0.5);
                float3 envirmentColor = UNITY_LIGHTMODEL_AMBIENT.xyz;
                float3 resColor = envirmentColor + diffuseColor + specularColor;
                return float4(resColor, 1.0); 
            }
            ENDCG 
        }
    }
}
