Shader "Unlit/GrabPass"
{
    Properties
    {
    }
    SubShader
    {
        Tags
        {
            "Queue" = "Transparent" // Check
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
                float4 uv     : TEXCOORD0; // Check
            };

            sampler2D _GrabPassTex;

            v2f vert (appdata_base v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv     = ComputeGrabScreenPos(o.vertex); // Check
                return o;
            }

            float4 frag (v2f i) : SV_Target
            {
                float4 color = tex2Dproj(_GrabPassTex, i.uv); // Check
                       color += float4(0.5, 0, 0, 1);
                return color;
            }

            ENDCG
        }
    }
}