Shader "Unlit/DuasFAixas"
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
            // Utiliza a função step para calcular um valor que vai ser
            // 1 quando x > 0.5 e 0 quando x < 0.5
            float val = step(In.uv_Texture.x, 0.5);
            // Coloca o valor de azul em qualquer ponto da imagem como 1, mas os valores de vermelho e verde,
            // devido a operação (1- val) serão semrpe 1 na metade esquerda da imagem e 0 na metade da direita.
            o.Albedo = float4(1 - val, 1- val, 1, 1);
        }
        ENDCG
    }
}
