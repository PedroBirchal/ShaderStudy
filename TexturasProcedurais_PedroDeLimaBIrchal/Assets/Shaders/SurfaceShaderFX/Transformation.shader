Shader "Custom/Transformation"
{
    Properties
    {
        _Color ("Color", Color) = (1,1,1,1)
        [HDR] _EmissionColor ("Color of Emission", Color) = (1, 1, 1, 1)
        _RustTex ("Rust Texture", 2D) = "white" {}
        _Noise ("Noise Texture", 2D) = "white" {}
        _Glossiness ("Smoothness", Range(0,1)) = 0.5
        _Metallic ("Metallic", Range(0,1)) = 0.0
        _Threshold ("Threshold", Range(-0.6, 0.6)) = 0
        _Offset ("Offset Edge", Range(0, 0.5)) = 0
        _Scale ("Scale Noise Effect", Range(0, 1)) = 0.5
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }

        CGPROGRAM
        #pragma surface surf Standard vertex:vert
        
        sampler2D _RustTex;
        sampler2D _Noise;

        struct Input
        {
            float2 uv_RustTex;
            float3 localPos;
        };


        // Adicionado um metodo de Vertex para obter a posição em Object space do objeto
        void vert (inout appdata_full v, out Input o)
        {
            UNITY_INITIALIZE_OUTPUT(Input,o);
            o.localPos = v.vertex.xyz;
        }
        
        half _Metallic;
        fixed4 _Color;
        float4 _EmissionColor;
        fixed _Threshold;
        float _Offset;
        float _Scale;
        
        void surf (Input IN, inout SurfaceOutputStandard o)
        {
            // Faz o sampling da textura de ferrugem e da textura de noise baseado no mapa de UV do objeto
            float4 c = tex2D(_RustTex, IN.uv_RustTex);
            float noise = tex2D(_Noise, IN.uv_RustTex);

            // Cria um valor que vai ser 1 quando a posição do fragmento em object space for maior que o _Threshold (substituido por timer para produzir animação)
            // estabelecido, e 0 quando for menor
            float timer = sin(_Time.y );
            fixed val = IN.localPos.y > timer;
            // Compara a posição y do fragmento com o _Threshold (substituido por timer para produzir animação)
            // reduzido por um offset, dessa forma, produz um efeito de "borda"
            // o valor é modifivado por uma textura de noise com uma escalar para fins esteticos e depois subtraido de val,
            // dessa forma, ele vai ser 0 aonde val for 1, 1 no espaço entre val e o offset, e 0 para valores abaixo
            fixed edge = (IN.localPos.y > timer - _Offset - (noise * _Scale)) - val;

            // Metalico acima do _Threshold (timer) é igual a 1
            o.Metallic = val;
            // Smoothness acima do Threshold (timer) é igual a 1
            o.Smoothness = val;
             // Valor emissivo é presente na borda, multiplicado por uma cor que determina a cor a ser emitida
            o.Emission = edge * _EmissionColor;
            // Valor final da cor vai ser determinado pela multiplicação do val pela cor primaria, adicionado pela cor
            // da textura de ferrugem multiplicada pelo inverso de val, criando assim um objeto que se parece com ferrugem
            // abaixo de _Threshold (substituido por timer para produzir animação)
            // e como metal liso acima do memso, divididas por uma faixa de transição brilhante.
            o.Albedo = val * _Color + c * (1 - val);
        }
        ENDCG
    }
    FallBack "Diffuse"
}
