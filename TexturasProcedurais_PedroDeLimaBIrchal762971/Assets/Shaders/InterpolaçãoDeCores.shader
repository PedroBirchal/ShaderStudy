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
            // Interpola entre os valores de cor 2 e 3 de acordo com a coordenada em y
            float4 linearInterpol = lerp(_Color2, _Color3, In.uv_Texture.y);
            // Interpola entre o valor interpolado de 2 e 3 , e o valor cor 1 de acordo com a coordenada
            // em x. 
            linearInterpol = lerp(_Color1, linearInterpol, In.uv_Texture.x);
            o.Albedo = linearInterpol; 
        }
        ENDCG
    }
}
