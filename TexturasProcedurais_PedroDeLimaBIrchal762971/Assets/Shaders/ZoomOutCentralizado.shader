Shader "Unlit/ZoomOut"
{
    Properties
    {
        _Texture ("Texture", 2D) = "white" {}
        _Zoom ("Zoom", Float) = 1.0
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
        
        void surf (Input In, inout SurfaceOutput o)
        {
            o.Albedo = (1, 0, 1, 1);
        }
        ENDCG
    }
}
