Shader "Custom/QuadradoCentral"
{
    Properties
    {
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        _Center ("Centro do Quadrado", Vector) = (0.5, 0.5, 0, 0)
        _Size ("Tamanho de um Lado do Quadrado", Float) = 0.5
    }
    SubShader
    {
        CGPROGRAM
        #pragma surface surf Standard fullforwardshadows

        sampler2D _MainTex;
        float4 _Center;
        float _Size;

        struct Input
        {
            float2 uv_MainTex;
        };

        void surf (Input IN, inout SurfaceOutputStandard o)
        {
            // Primeiramente, 4 varieaveis que determinam os valores minimos e maximos para o perimetro do quadrado
            // em x e y são criadas baseadas na posição do centro do quadrado e no tamnho dos lados
            // OBS: Seria possivel fazer a mesma coisa sem criar tantas variaveis,Simplesmente calculando essas posições na hora
            //  mas o codigo ficaria consideravelmente mais desorganizado.
            float lBoundX = _Center.x - _Size/2;
            float gBoundX = _Center.x + _Size/2;
            float lBoundY = _Center.y - _Size/2;
            float gBoundY = _Center.y + _Size/2;

            // Um valor criado unicamente para dizer se o fragmento se encontra dentro (1) ou fora (0) do perimetro do quadrado
            float val = 1;

            // Compara as coordenadas em x e y do fragmento com as posições minimas e maximas do quadrado
            if(IN.uv_MainTex.x > lBoundX && IN.uv_MainTex.x < gBoundX && IN.uv_MainTex.y > lBoundY && IN.uv_MainTex.y < gBoundY)
                val = 0;

            // Por fim, Determina que toda a textura será pintada de azul, ja vermelho e verde serão 0 dentro da area do
            // quadrado e 1 fora dela.
            o.Albedo = float4(val,val, 1, 1);
        }
        ENDCG
    }
    FallBack "Diffuse"
}
