// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'

Shader "Unlit/NewUnlitShader"
{
    Properties
    {
        _RampTex ("Texture", 2D) = "white" {}
        _Specular("SpecularColor", Color) = (1,1,1,1)
        _Gloss("Gloss", Range(4.0, 256.0)) = 4.0
        _AlphaScale("AlphaScale", range(0.0, 1.0)) = 0.5
    }
    SubShader
    {
        Tags{"Queue" = "Transparent" "IgnoreProjector"="True" "RenderType" = "Transparent"}
        Pass{
            Tags {"RenderType"="ForwardBase"}
            ZWrite Off
            Cull Front
            Blend srcAlpha OneMinusSrcAlpha

            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"
            #include "Lighting.cginc"

            sampler2D _RampTex;
            float4 _RampTex_ST;
            float4 _Specular;
            float _Gloss;
            float _AlphaScale;

            struct appdata
            {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
                float2 texcoord : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float3 worldNormal : TEXCOORD1;
                float3 worldPos : TEXCOORD2;
                float4 vertex : SV_POSITION;
            };

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.worldPos = mul(unity_ObjectToWorld, v.vertex);
                o.worldNormal = UnityObjectToWorldNormal(v.normal);
                o.uv = TRANSFORM_TEX(v.texcoord, _RampTex);
                return o;
            }

            float4 frag (v2f i) : SV_Target
            {
                float3 worldNormal = normalize(i.worldNormal);
                float3 worldLightDir = normalize(UnityWorldSpaceLightDir(i.worldPos));
                float3 viewDir = normalize(UnityWorldSpaceViewDir(i.worldPos));
                float4 texColor = tex2D(_RampTex, i.uv.xy);
  
                float3 halfNormal = normalize(viewDir + worldLightDir);
                float3 specularColor = _LightColor0.rgb * pow(max(0, dot(worldNormal,halfNormal)),_Gloss);

                float3 diffuseColor = _LightColor0.rgb * texColor.rgb;
                
                float3 col = 0.5 * specularColor + diffuseColor;

                return float4(col,texColor.w *_AlphaScale);
            }
            ENDCG
        }
        Pass
        {
            Tags {"RenderType"="ForwardBase"}
            ZWrite Off
            Cull Back
            Blend srcAlpha OneMinusSrcAlpha

            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"
            #include "Lighting.cginc"

            sampler2D _RampTex;
            float4 _RampTex_ST;
            float4 _Specular;
            float _Gloss;
            float _AlphaScale;

            struct appdata
            {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
                float2 texcoord : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float3 worldNormal : TEXCOORD1;
                float3 worldPos : TEXCOORD2;
                float4 vertex : SV_POSITION;
            };

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.worldPos = mul(unity_ObjectToWorld, v.vertex);
                o.worldNormal = UnityObjectToWorldNormal(v.normal);
                o.uv = TRANSFORM_TEX(v.texcoord, _RampTex);
                return o;
            }

            float4 frag (v2f i) : SV_Target
            {
                float3 worldNormal = normalize(i.worldNormal);
                float3 worldLightDir = normalize(UnityWorldSpaceLightDir(i.worldPos));
                float3 viewDir = normalize(UnityWorldSpaceViewDir(i.worldPos));
                float4 texColor = tex2D(_RampTex, i.uv.xy);
  
                float3 halfNormal = normalize(viewDir + worldLightDir);
                float3 specularColor = _LightColor0.rgb * pow(max(0, dot(worldNormal,halfNormal)),_Gloss);

                float3 diffuseColor = _LightColor0.rgb * texColor.rgb;
                
                float3 col = 0.5 * specularColor + diffuseColor;

                return float4(col,texColor.w *_AlphaScale);
            }
            ENDCG
        }
    }
    FallBack "Transparent/Cutout/VertexLit"
}
