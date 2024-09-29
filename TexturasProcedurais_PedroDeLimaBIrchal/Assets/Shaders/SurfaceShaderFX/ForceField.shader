Shader "SurfaceFX/ForceField"
{
    Properties
    {
        _Color ("Color", Color) = (1,1,1,1)
        _Thickness ("Thickness", Range(-1, 1)) = 0
        _FresnelIntensity ("Fresnel Intensity", Range (-1, 1)) =  0
        _NormalMap ("Normal Map", 2D) = "white" {}
    }
    SubShader
    {
        Tags { "Queue" = "Transparent" "RenderType"="Transparent" "IgnoreProjector" = "True"}
        Cull Off
        ZWrite Off
        
        CGPROGRAM
        
        #pragma surface surf Lambert blend: alpha
        #include "UnityCG.cginc"

        sampler2D _NormalMap;

        struct Input
        {
            float2 uv_MainTex;
            float4 screenPos;
            float3 viewDir;
            float2 uv_NormalMap;
        };

        float _Thickness;
        float _FresnelIntensity;
        fixed4 _Color;
        sampler2D _CameraDepthTexture;

        void surf (Input IN, inout SurfaceOutput o)
        {
            // EFEITO DE BORDA DE CONTATO:
            
            // Calcula a posição uv do pixel na tela divindo as cordenadas "Raw" pelo valor de distorção da cordenada w,
            // isso nos dá  a posição "Real" do objeto na tela, consertando a distorção da coordenada homogenea feita para
            // projeção em perspectiva do objeto
            // OBS: isso tambem quer dizer que para que o shader funcione com uma camera ortografica, em que a projeção em perspectiva
            // não ocorre, o calculo deveria levar em conta somente a posição em z, sem necessidade da divisão.
            float2 clipPos = IN.screenPos.xy / IN.screenPos.w;
            
            // Sampling da textura de profundidade fornecida pela camera em escala linear, seguindo "Eye space" (continuo sem entender essa medida, mas da certo)
            float depth = LinearEyeDepth(SAMPLE_DEPTH_TEXTURE(_CameraDepthTexture, clipPos));

            // Calcula a diferença entre as superficies pela subtração da coordenada w da screenPos, que representa a projeção daquele pixel em perspectiva,
            // e do mapa de profundidade. Isso resulta num valor 0 onde o objeto com o shader coincide com qualquer superficie opaca sendo rendelizada no
            // na depth texture, e que gradualmente aumenta conforme o objeto se distancia da superficie em contato.
            // OBS: um valor Thickness foi adicionado posteriormente para permitir alteração do valor resultante e maior controle do efeito produzido
            float dif = depth - (IN.screenPos.w + _Thickness);

            // Inverte o valor da diferença entre superficies, dessa forma, conseguimos valores proximos de 1 na intersseção, o que
            // é mais desejavel para produzir o efeito
            dif = 1 - dif;

            // Smoothstep suavisa a transição entre valores, criando um visual mais agradavel, mas a função primaria é de "clampar" os valores dentro de um range de 0 e 1,
            // para evitar efeitos estranhos devido a extrapolação de valores.
            float val = smoothstep(0, 1, dif);

            // EFEITO FRESNEL + NORMAL MAP:

            // Desloca a uv do mapa de normal em x e em y por tempo / 20
            IN.uv_NormalMap.x += _Time.x;
            IN.uv_NormalMap.y += _Time.x;

            // Transfere a informação do mapa de normal para o output
            o.Normal = UnpackNormal(tex2D(_NormalMap, IN.uv_NormalMap));

            // Calcula a diferencça entre o angulo de visão da camera e a normal do objeto, depois retira o sinal do resultado
            float orientation = abs(dot(normalize(IN.viewDir), o.Normal));
            // Com base no valor calculado acima, inverte o resultado e modifica ele por _FresnelIntensity, dessa forma,
            // quando a normal estiver perpendicular ao angulo de visão, o valor do efeito será 1, e quando for paralela 0
            float fresnel = 1 - orientation - _FresnelIntensity;

            
            o.Alpha = saturate(val + fresnel);
            o.Emission =  _Color;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
