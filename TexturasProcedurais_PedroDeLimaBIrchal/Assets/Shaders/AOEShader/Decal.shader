Shader "AOE/Decal"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _AoeColor ("AOE Color", color)  = (1, 0, 0, 1)
        _AoeRad ("AOE radius", float) = 0.5
        _AoeCenter ("AOE Center Position", Vector) = (0.5, 0.5, 0.0, 1.0)
        _Duration ("Duration", Float) = 1
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }

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

            sampler2D _MainTex;
            float4 _MainTex_ST;
            float4 _AoeColor;
            float _AoeRad;
            float4 _AoeCenter;
            float _Duration;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                float4 TextureCol = tex2D(_MainTex, i.uv);
                float4 col;

                // Calculate distance between fragment and center of aoe in relation to aoe radius
                float distance = length(i.uv - _AoeCenter);
                float outDist = distance / _AoeRad;
                float inDist = distance / (_AoeRad * frac(_Time.y/_Duration));

                // Sets distance to 0 if it's bigger than 1, so that points outside the aoe don't get painted.
                if(outDist > 1) outDist = 0;
                if(inDist > 1) inDist = 0;

                // Cubic function to make gradient more natural
                outDist = pow(outDist, 3);
                inDist = pow(inDist, 3);
                
                float4 aoeCol, aoeCol2;
                
                // Color output of aoe should be 1 in the center, to output the color of the underlying texture
                // times the inverse of the desired color, so when we multiply the final color by the color of the aoe
                // we get the original color.
                aoeCol = 1 - outDist * (1 -  _AoeColor);
                aoeCol2 = 1 - inDist * (1 - _AoeColor);
                
                col = (TextureCol  * aoeCol ) * aoeCol2;
                return col;
            }
            ENDCG
        }
    }
}
