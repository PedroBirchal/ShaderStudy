Shader "Custom/BarrasVerticais"
{
    Properties
    {
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        _Scale ("Escala", float) = 1.0
        _Offset ("Offset", float) = 1.0
    }
    SubShader
    {
        CGPROGRAM
        #pragma surface surf Lambert
        
        sampler2D _MainTex;
        float _Scale;
        float _Offset;

        struct Input
        {
            float2 uv_MainTex;
        };

        void surf (Input IN, inout SurfaceOutput o){
            // O valor do fragmento será determinado pelo valor decimal da coordenada x no mapa de uv
            // escalada por _Scale determinando o numedo de faixas na tela
            // adicionada a offset para deslocar a imagem no eixo x
            // e comparada a 0.5, para retornar 1  em valores maiores que 0.5 e 0 em valores menores. 
            float val = frac(IN.uv_MainTex.x * _Scale + _Offset) > 0.5;
            o.Albedo = float4(val, val, 1, 1);
        }
        ENDCG
    }
    FallBack "Diffuse"
}
