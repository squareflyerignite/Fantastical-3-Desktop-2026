Shader "Custom/AnimatedGlow"
{
    Properties
    {
        _MainColor ("Main Color", Color) = (0.2, 0.6, 1, 1)
        _GlowColor ("Glow Color", Color) = (0.1, 0.8, 1, 1)
        _GlowStrength ("Glow Strength", Range(0, 5)) = 2
        _Speed ("Animation Speed", Range(0, 10)) = 2
    }

    SubShader
    {
        Tags
        {
            "RenderType" = "Opaque"
            "Queue" = "Geometry"
        }

        Pass
        {
            CGPROGRAM

            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
            };

            struct v2f
            {
                float4 vertex : SV_POSITION;
                float3 normal : TEXCOORD0;
            };

            fixed4 _MainColor;
            fixed4 _GlowColor;
            float _GlowStrength;
            float _Speed;

            v2f vert(appdata input)
            {
                v2f output;

                output.vertex = UnityObjectToClipPos(input.vertex);
                output.normal = UnityObjectToWorldNormal(input.normal);

                return output;
            }

            fixed4 frag(v2f input) : SV_Target
            {
                float3 normal = normalize(input.normal);
                float3 viewDirection = normalize(_WorldSpaceCameraPos.xyz);

                float lighting = saturate(dot(normal, viewDirection));
                float pulse = 0.5 + 0.5 * sin(_Time.y * _Speed);

                float glow = pow(1.0 - lighting, 2.0);
                glow *= _GlowStrength;
                glow *= 0.5 + pulse * 0.5;

                fixed3 baseColor = _MainColor.rgb;
                fixed3 finalColor = baseColor + _GlowColor.rgb * glow;

                return fixed4(finalColor, 1.0);
            }

            ENDCG
        }
    }
}