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
            // Calcula a diferença entre o componente x e y da UV e da o valor absoluto 
            float dif = abs(In.uv_Texture.x - In.uv_Texture.y);
            // Componente Vermelho vai ser 1 - dif, dessa forma, vai retornar valores mais vermelhos proximos
            // à reta y = x ou f(x) = x.
            // Ja o componente azul vai ser 1 * dif, como dif é um valor absoluto (não negativo), a cor retornada sera mais
            // azulada quanto maior a discrepancia entre x e y.
            o.Albedo = float3(1 - dif, 0, 1 * dif);
        }
        ENDCG
    }
}
