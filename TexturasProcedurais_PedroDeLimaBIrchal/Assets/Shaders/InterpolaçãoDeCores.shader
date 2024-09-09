Shader "Unlit/InterpolaçãoDeCores"
{
    Properties
    {
        _Texture ("Texture", 2D) = "white" {}
        _Color1 ("Cor 1", color) = (1, 1, 1, 1)
        _Color2 ("Cor 2", color) = (1, 0, 1, 1)
        _Color3 ("Cor 3", color) = (0, 1, 1, 1)
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
        float4 _Color1;
        float4 _Color2;
        float4 _Color3;
        
        void surf (Input In, inout SurfaceOutput o)
        {
            // SOLUÇÃO 1:
            /*
            // Interpola entre os valores de cor 2 e 3 de acordo com a coordenada em y
            float4 linearInterpol = lerp(_Color2, _Color3, In.uv_Texture.y);
            // Interpola entre o valor interpolado de 2 e 3 , e o valor cor 1 de acordo com a coordenada
            // em x. 
            linearInterpol = lerp(_Color1, linearInterpol, In.uv_Texture.x);
            o.Albedo = linearInterpol; 
            */

            // SOLUÇÃO 2:
            // O valor de vermelho neste ponto da imagem vai ser determinado pela soma da cordenada y com a coordenada x
            // dessa forma, ao longo de toda a diagonal secundaria da matriz uv e alem, o valor de r será igual ou maior
            // do que 1. Saturate é usado para tratar dos valores de r em que x + y > 1.
            float r = saturate(In.uv_Texture.y + In.uv_Texture.x);
            // Verde precisa de possuir um valor maior ou igual a 1 em todos os pontos à direita da diagonal principal
            // da matriz UV, sendo assim, o valor de verde pode ser dado pela subtração de 1 pela diferença entre y e x
            // , dentro de uma função saturate para tratar os casos em que 1 - (y - x) > 1.
            float g = saturate(1- (In.uv_Texture.y - In.uv_Texture.x));
            // Para reproduzir o efeito exato, é necessario que o valor de azul seja 1 em todos os pontos da textura.
            o.Albedo = float4(r, g, 1, 1);
        }
        ENDCG
    }
}
