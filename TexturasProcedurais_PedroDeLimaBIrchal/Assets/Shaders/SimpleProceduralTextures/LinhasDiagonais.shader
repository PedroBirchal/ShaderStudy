Shader "Unlit/LinhasDiagonais"
{
    Properties
    {
        _Texture ("Texture", 2D) = "white" {}
        _Scale ("Escala", int) = 1.0
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
        float _Scale;
        
        void surf (Input In, inout SurfaceOutput o)
        {
            // Checa se a soma do valor x e y da uv, escalada por _Scale, é divisivel por 2 e pinta de acordo
            // Dessa forma, as listras serão pintadas na diagonal.
            if(int(( 1 - In.uv_Texture.x  +  In.uv_Texture.y) * _Scale) % 2 != 0) o.Albedo = 1;
            else o.Albedo = 0;
        }
        ENDCG
    }
}
