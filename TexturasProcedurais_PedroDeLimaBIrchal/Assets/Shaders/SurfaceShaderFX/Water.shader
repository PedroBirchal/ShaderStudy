Shader "SurfaceFX/Water"
{
    Properties
    {
        _ShallowColor ("Shallow Color", Color) = (1,1,1,1)
        _DeepColor ("Deep Color", Color) = (0, 0, 0, 1)
        _DeepnessScale ("Scale Deepness", Range(0, 5)) = 1
        _InitialAlpha ("Alpha at Shallow point", Range(0, 1)) = 0.5
        _FoamTex ("Foam Texture", 2D) = "white" {}
        _FoamTex2 ("Foam Texture 2", 2D) = "white" {}
        _FoamColor ("Foam Color", Color) = (1, 1, 1, 1)
    }
    SubShader
    {
        Tags{"Queue" = "Transparent" "RenderType" = "Transparent" "IgnoreProjector" = "True"}

        CGPROGRAM
        #pragma surface surf Standard alpha : blend 

        #include "UnityCG.cginc"

        sampler2D _FoamTex;
        sampler2D _FoamTex2;

        struct Input
        {
            float2 uv_FoamTex;
            float4 screenPos;
        };
        
        fixed4 _ShallowColor;
        fixed4 _DeepColor;
        float _DeepnessScale;
        float _InitialAlpha;
        
        fixed4 _FoamColor;
        
        sampler2D _CameraDepthTexture;

        void surf (Input IN, inout SurfaceOutputStandard o)
        {
            // Fator que desloca a pocição da textura em x de acordo com a parte fracional do seno do tempo 
            float x = frac(IN.uv_FoamTex + sin(_Time.y * 0.5) * 0.1);
            // Fator que desloca a pocição da textura em y de acordo com a parte fracional do seno do tempo
            float y = frac(IN.uv_FoamTex.y * (sin(_Time.y  * 0.2)- 6 * 0.6));
            // Aplica a textura de espuma de acordo com as coordenadas calculadas acima 
            float4 foamCol =  tex2D(_FoamTex,float2(x, y));
            // Aplica uma segunda textura que anima linearmente em xy de acordo com o tempo
            float4 foam2 =  1 - tex2D(_FoamTex2, abs(frac(IN.uv_FoamTex + _Time.y * 0.02)));

            // Calcula a posição do objeto em relação a tela, assumindo uma cordenada normalizada em que o ponto de origem é
            // o canto inferior esquerdo da tela.
            float2 clipPos = IN.screenPos.xy / IN.screenPos.w;
            // Transforma a textura de profundidade em um valor normalizado, escalado linearmente ao inves de logaritmicamente
            // e extrai desta o valor de profundidade do pixel, utilizando a coordenada em espaço de tela calculada acima
            float depth = Linear01Depth(SAMPLE_DEPTH_TEXTURE(_CameraDepthTexture, clipPos));
            
            // Aplica uma escalar ao valor de profundidade 
            depth = saturate(depth * _DeepnessScale);

            // Interpola entre duas cores, uma para objetos proximos da superficie e outra para objetos distantes
            fixed4 col = lerp(_ShallowColor, _DeepColor, depth);
            
            o.Albedo = saturate(col + (saturate(foamCol + foam2) * _FoamColor));
            // O quão opaco a superficie de um corpo de agua é depende de uma serie de fatores,
            // como outros materiais encontrados na agua (terra, iodo, etc),
            // mas, é possivel simplificar isso dizendo que, quanto mais fundo está um objeto, menos luz é capaz de alcançar
            // o objeto e, portanto, a cor da propia agua se torna mais aparente
            o.Alpha =  _InitialAlpha + depth * (1 - _InitialAlpha);
        }
        ENDCG
    }
    FallBack "Diffuse"
}
