Shader "Custom/LinhasRadiais"
{
    Properties
    {
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        _Scale ("Escala", float) = 0.5
    }
    SubShader
    {
        CGPROGRAM
        #pragma surface surf Standard fullforwardshadows
        
        sampler2D _MainTex;
        float _Scale;

        struct Input
        {
            float2 uv_MainTex;
        };
        

        void surf (Input IN, inout SurfaceOutputStandard o){
            // Val se da pelo Cosceno da distancia da coordenada do ponto para o centro da uv(0.5, 0.5)
            // multiplicada por um valor escalar _Scale. Desta forma, o valor tera um efeito "ease in ease out"
            // devido ao comportamento do cosceno, e conforme a distancia aumenta, o valor vai oscilar entre 1 e -1
            float val = cos(length(IN.uv_MainTex - float2(0.5, 0.5)) * _Scale);
            o.Albedo = val;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
