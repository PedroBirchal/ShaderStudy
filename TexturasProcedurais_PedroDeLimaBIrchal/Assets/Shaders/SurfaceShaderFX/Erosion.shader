Shader "SurfaceFX/Erosion"
{
    Properties
    {
        _MainTex ("Main Texture", 2D) = "white" {}
        _FxTex ("Effect Texture", 2D) = "white" {}
        [HDR]_EmissionCol ("Emission Color", Color) = (1, 1, 1, 1)
        _Slider ("Fade", Range(0, 1)) = 0
        _Thickness ("Border Thickness", Range(0, 1)) = 0.1
        _TimeScaler ("Scale duration of oscilation", Float) = 1
    }
    SubShader
    {
        Tags{"Queue" = "Transparent"}
        
        CGPROGRAM
        #pragma surface surf Standard alpha:blend

        sampler2D _MainTex;
        sampler2D _FxTex;

        struct Input
        {
            float2 uv_MainTex;
        };

        float _Slider;
        float _Thickness;
        float _TimeScaler;
        fixed4 _EmissionCol;

        void surf (Input IN, inout SurfaceOutputStandard o)
        {
            //Texture Sampling
            fixed4 col = tex2D (_MainTex, IN.uv_MainTex);
            fixed4 FxCol = tex2D (_FxTex, IN.uv_MainTex);

            float scaler;

            //calculate mask based on slider value
            //scaler = _Slider;

            //calculate mask based on time value
            scaler = sin(_Time.y * UNITY_PI * _TimeScaler) + 0.5;
            
            float mask = step(FxCol, scaler);
            o.Albedo = col * mask;
            o.Emission = ((1 - mask) * _EmissionCol);
            o.Alpha = step(FxCol - _Thickness, scaler);
        }
        ENDCG
    }
    FallBack "Diffuse"
}
