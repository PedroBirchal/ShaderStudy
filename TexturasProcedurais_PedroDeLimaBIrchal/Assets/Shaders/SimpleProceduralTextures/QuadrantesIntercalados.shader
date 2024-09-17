Shader "Custom/QuadrantesIntercalados"
{
    Properties
    {
        _Color ("Color", Color) = (1,1,1,1)
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
    }
    SubShader
    {

        CGPROGRAM
        #pragma surface surf Standard fullforwardshadows
        
        sampler2D _MainTex;

        struct Input
        {
            float2 uv_MainTex;
        };
        fixed4 _Color;

        void surf (Input IN, inout SurfaceOutputStandard o)
        {
            // Primeiramente, criamos valores que representam se o ponto é menor ou maior que 0.5,
            // tanto no eixo x quanto no eixo y.
            float x = step(IN.uv_MainTex.x, 0.5);
            float y = step(IN.uv_MainTex.y, 0.5);

            // Depois, subtraimos um pelo outro e retiramos o modulo do resultado. Isso quer dizer que em qualquer area em que
            // x e Y coincidem, o valor será
            // Se imaginarmos a UV como uma matriz 2x2, e representarmos X como os valores de x, Y como valores de y e
            // |X -Y| como os valores resultantes do modulo da diferença entre x e y,
            // será possivel representar a operação da seguinte forma:
            // X = [0, 1]  Y = [1, 1]      |X-Y| = [1, 0]
            //     [0, 1]      [0, 1]              [0, 1]
            
            float val = 1 - abs(x - y);

            // Por fim, os valores de r e g seram dados pela diferença entre 1 e o modulo de val,
            // e o valor b será 1 em toda a imagem
            o.Albedo = float4(val, val, 1, 1);
        }
        ENDCG
    }
    FallBack "Diffuse"
}
