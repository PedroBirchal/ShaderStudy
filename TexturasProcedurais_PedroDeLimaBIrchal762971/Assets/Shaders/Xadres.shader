Shader "Custom/Xadres"
{
    Properties
    {
        _MainTex ("Main Texture" , 2D) = "white" {}
        _Scale ("Escala do xadres", float) = 2
        _TimeScale ("Escala de Tempo", float) = 1
    }
    SubShader
    {
        CGPROGRAM
        #pragma surface surf Lambert
        #define PI 3.141592

        sampler2D _MainTex;
        float _Scale;
        float _TimeScale;

        struct Input
        {
            float2 uv_MainTex;
        };

        void surf (Input IN, inout SurfaceOutput o)
        {
            // Primeiro é criado um valor que representa o valor inteiro mais proximo, arredondado pra baixo
            // para a coordenada x e um para a coordenada y multiplicados pela escalar _Scale
            float x = floor(IN.uv_MainTex.x * _Scale);
            float y = floor(IN.uv_MainTex.y * _Scale);
            // a variavel val é criada para representar o resto da soma dos valores extraidos acima  por 2, dessa forma,
            // este valor sera 0 onde os valores são 0, 1 onde apenas um valor é 1, e 0 nas intercessões, onde a soma deles seria 2
            float val = (x + y ) % 2;
            // com o valor acima ja é possivel produzir o padrão de xadres desejado, mas, para criar o efeito de mudança de cor
            // é preciso extrair um valor de alguma função f(tempo)
            // foi escolhido uma função triangular, ja que essa produz o efeito de maneira mais natural
            float variation = abs(  _Time.y * _TimeScale  -  floor(_Time.y * _TimeScale) - 0.5) * 2;
            // E por ultimo, multiplicamos o valor por variation, e 1 - valor por 1 - variation, produzindo um efeito de alternancia entre duas cores
            o.Albedo = float4(val * variation , 1 - val * 1 - variation, 0, 1);
        }
        ENDCG
    }
    FallBack "Diffuse"
}
