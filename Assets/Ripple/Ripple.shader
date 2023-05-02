Shader "Unlit/Ripple"
{
    Properties
    {
        _Frequency ("Frequency", Float) = 20
        _Speed     ("Speed",     Float) = 10
        _Power     ("Power",     Float) = 1
    }
    SubShader
    {
        Cull Off

        Tags
        {
            "Queue" = "Transparent"
        }
        GrabPass
        {
             "_GrabPassTex"
        }
        Pass
        {
            CGPROGRAM

            #pragma vertex   vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            struct v2f
            {
                float4 vertex : SV_POSITION;
                float4 uvGrab : TEXCOORD0;
                float2 uv     : TEXCOORD1;
            };

            sampler2D _GrabPassTex;

            float _Frequency;
            float _Speed;
            float _Power;

            v2f vert (appdata_base v)
            {
                v2f o;

                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uvGrab = ComputeGrabScreenPos(o.vertex);
                o.uv     = v.texcoord;

                return o;
            }

            float4 frag (v2f i) : SV_Target
            {
                float2 vFromCenter = i.uv - float2(0.5, 0.5);
                float  lengthOfV   = length(vFromCenter);
                // return lengthOfV;

                float wave = sin(lengthOfV * _Frequency + _Time.y * -_Speed) * _Power;
                // return wave;

                float2 uvGrab          = i.uvGrab.xy / i.uvGrab.w;
                float4 distortedColor  = tex2D(_GrabPassTex, uvGrab + vFromCenter * wave);
                // return distortedColor;

                float4 color        = tex2D(_GrabPassTex, uvGrab);
                float  lengthToEdge = saturate((lengthOfV - 0.35) / (0.5 - 0.35));
                // return lengthToEdge;

                return lerp(distortedColor, color, lengthToEdge);
            }

            ENDCG
        }
    }
}
