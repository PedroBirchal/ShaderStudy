Shader "Custom/CirculoCentralizado"
{
    Properties
    {
        _Color ("Color", Color) = (1,1,1,1)
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        _Radius ("Radius", float) = 0.5
        _Center ("Center of the circle", Vector) = (0.5, 0.5, 0, 0)
    }
    SubShader
    {

        CGPROGRAM
        #pragma surface surf Lambert
        sampler2D _MainTex;

        struct Input{
            float2 uv_MainTex;
        };
        
        fixed4 _Color;
        float _Radius;
        float4 _Center;

        void surf (Input IN, inout SurfaceOutput o){
            // No centro da linha temos a distancia do ponto para o centro do circulo medida em
            // Coordenadas xy do ponto - coordenadas xy do centro do circulo
            // então, divimos  a distancia pelo raio, para obter a relação entre os  dois
            // neste momento, pontos dentro da area do circulo, terão um val < 1 e pontos fora da area do circulo
            // terão um val > 1.
            // então, o operador <= 1 faz com que o valor retornado seja 1 sempre que menor ou igual a um, e 0 em outros casos. 
            float val =  length(IN.uv_MainTex.xy - _Center.xy) / _Radius  >= 1;
            o.Albedo = float4(val, val, 1, 1);
        }
        ENDCG
    }
    FallBack "Diffuse"
}
