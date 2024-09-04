Shader "Unlit/ZoomOut"
{
    Properties
    {
        _Texture ("Texture", 2D) = "white" {}
        _Zoom ("Zoom", Float) = 1.0
        _Radius ("Radius", Float) = 0.5
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
        float _Zoom;
        float _Radius;
        
        void surf (Input In, inout SurfaceOutput o)
        {
            // Para que uma textura se "repita" é preciso que o mapa de UV repita.
            // Como o mapa de UV é um espaço discretizado com coordenadas X e Y , em que X e Y > 0 & X e Y < 1
            // se multiplicarmos ambos os valores por um valor _Zoom, e extrairmos do resultado a parte fracional,
            // vamos obter novas coordenadas para o mapa de UV que comportam _Zoom ao quadrado vezes a imagem, numa dimensão proporcionalmente menor.
            // Para que a imagem permaneça centralizada, é preciso que o pivo da função seja deslocado para o centro do mapa de UV
            // então, é necessario deslocar a coordenada da uv em -uv/2 * _Zoom, dessa forma, conforme a função for verticalizada pelo aumento do _Zoom,
            // as cordenadas serão deslocadas na direção oposta do eixo de deformação, e a mesma imagem permanecera no centro da uv.
            // Entretanto, no caso em que _Zoom = 1
            In.uv_Texture.xy = frac(_Zoom * (In.uv_Texture.xy * _Zoom - 0.5 * _Zoom)  + 0.5);
            float val = length(In.uv_Texture - float2(0.5, 0.5)) / _Radius;
            o.Albedo = float4(1, 1, 1, 1) *  1 - val;
        }
        ENDCG
    }
}
