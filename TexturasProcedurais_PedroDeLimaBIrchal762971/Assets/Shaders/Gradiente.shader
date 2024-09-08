Shader "TexturasProcedurais/Gradiente"
{
    Properties
    {
        _Texture ("Texture", 2D) = "white" {}
    }
    SubShader
    {
        CGPROGRAM
        
        #pragma surface surf Lambert
        
        struct Input
        {
            float2 uv_Texture;
        };

        sampler2D _Texture;
        
        void surf (Input In, inout SurfaceOutput o)
        {
            // retorna 1 * o valor de x da uv, como o valor de x é 0 na esquerda e 1 na extremidade da direita, isso forma um gradiente de preto até branco.
            o.Albedo =  In.uv_Texture.x;
        }
        ENDCG
    }
}
