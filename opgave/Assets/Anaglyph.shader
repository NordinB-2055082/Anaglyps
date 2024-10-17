Shader "Custom/Anaglyph"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _MainTex2("2nd Texture", 2D) = "black" {}
    }
    SubShader
    {
        // No culling or depth
        Cull Off ZWrite Off ZTest Always

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
            };

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                return o;
            }

            sampler2D _MainTex;
            sampler2D _MainTex2;

            fixed4 frag (v2f i) : SV_Target
            {
                // Fetch the colors from both cameras
                fixed4 leftColor = tex2D(_MainTex, i.uv);   // Left camera (red channel)
                fixed4 rightColor = tex2D(_MainTex2, i.uv); // Right camera (green and blue channels)

                // Combine to create an anaglyph effect
                return fixed4(leftColor.r, rightColor.g, rightColor.b, 1.0);
 
            }
            ENDCG
        }
    }
}
