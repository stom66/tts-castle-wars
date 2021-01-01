// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'
// Upgrade NOTE: replaced '_World2Object' with 'unity_WorldToObject'
// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

// Shader created with Shader Forge Beta 0.35 
// Shader Forge (c) Joachim Holmer - http://www.acegikmo.com/shaderforge/
// Note: Manually altering this data may prevent you from opening it in Shader Forge
/*SF_DATA;ver:0.35;sub:START;pass:START;ps:flbk:Particles/Additive (Soft),lico:0,lgpr:1,nrmq:1,limd:0,uamb:True,mssp:True,lmpd:False,lprd:False,enco:False,frtr:True,vitr:True,dbil:False,rmgx:True,rpth:0,hqsc:True,hqlp:False,tesm:0,blpr:2,bsrc:0,bdst:0,culm:2,dpts:2,wrdp:False,ufog:True,aust:True,igpj:True,qofs:0,qpre:3,rntp:2,fgom:False,fgoc:False,fgod:False,fgor:False,fgmd:0,fgcr:0.5,fgcg:0.5,fgcb:0.5,fgca:1,fgde:0.01,fgrn:0,fgrf:300,ofsf:0,ofsu:0,f2p0:True;n:type:ShaderForge.SFN_Final,id:1,x:32567,y:32622|emission-423-OUT,custl-295-OUT;n:type:ShaderForge.SFN_Tex2d,id:10,x:33764,y:32478,ptlb:MainTex,ptin:_MainTex,tex:da515c58fa081714f9681eb76128ef72,ntxv:0,isnm:False;n:type:ShaderForge.SFN_OneMinus,id:294,x:32974,y:33101|IN-304-OUT;n:type:ShaderForge.SFN_Multiply,id:295,x:32999,y:32743|A-504-OUT,B-362-OUT;n:type:ShaderForge.SFN_Power,id:304,x:33122,y:33101|EXP-305-OUT;n:type:ShaderForge.SFN_ValueProperty,id:305,x:33567,y:32798,ptlb:Rim Exponent,ptin:_RimExponent,glob:False,v1:1;n:type:ShaderForge.SFN_Multiply,id:362,x:33210,y:32813|A-439-OUT,B-364-OUT;n:type:ShaderForge.SFN_ValueProperty,id:364,x:33489,y:32912,ptlb:Rim Multiplier,ptin:_RimMultiplier,glob:False,v1:1;n:type:ShaderForge.SFN_Color,id:405,x:33753,y:32235,ptlb:Rim Color,ptin:_RimColor,glob:False,c1:1,c2:1,c3:1,c4:1;n:type:ShaderForge.SFN_Multiply,id:406,x:33383,y:32402|A-491-OUT,B-484-OUT;n:type:ShaderForge.SFN_Multiply,id:423,x:32804,y:32575|A-504-OUT,B-424-OUT;n:type:ShaderForge.SFN_ValueProperty,id:424,x:32967,y:32670,ptlb:Emission Multiplier,ptin:_EmissionMultiplier,glob:False,v1:0;n:type:ShaderForge.SFN_Fresnel,id:439,x:33376,y:32720|EXP-305-OUT;n:type:ShaderForge.SFN_Lerp,id:469,x:33192,y:32381|A-405-RGB,B-406-OUT,T-474-OUT;n:type:ShaderForge.SFN_Slider,id:474,x:33376,y:32578,ptlb:Rim Texture Amount,ptin:_RimTextureAmount,min:0,cur:1,max:1;n:type:ShaderForge.SFN_Multiply,id:484,x:33567,y:32512|A-10-RGB,B-10-A;n:type:ShaderForge.SFN_Multiply,id:491,x:33565,y:32284|A-405-RGB,B-405-A;n:type:ShaderForge.SFN_VertexColor,id:502,x:33192,y:32254;n:type:ShaderForge.SFN_Multiply,id:503,x:33000,y:32282|A-502-RGB,B-469-OUT;n:type:ShaderForge.SFN_Multiply,id:504,x:32850,y:32356|A-503-OUT,B-502-A;proporder:405-10-474-305-364-424;pass:END;sub:END;*/

Shader "NeatWolf/NW_Particle Rim AddSmooth 2S" {
    Properties {
        _RimColor ("Rim Color", Color) = (1,1,1,1)
        _MainTex ("MainTex", 2D) = "white" {}
        _RimTextureAmount ("Rim Texture Amount", Range(0, 1)) = 1
        _RimExponent ("Rim Exponent", Float ) = 1
        _RimMultiplier ("Rim Multiplier", Float ) = 1
        _EmissionMultiplier ("Emission Multiplier", Float ) = 0
    }
    SubShader {
        Tags {
            "IgnoreProjector"="True"
            "Queue"="Transparent"
            "RenderType"="Transparent"
        }
        Pass {
            Name "ForwardBase"
            Tags {
                "LightMode"="ForwardBase"
            }
            Blend One One
            Cull Off
            ZWrite Off
            
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #define UNITY_PASS_FORWARDBASE
            #include "UnityCG.cginc"
            #pragma multi_compile_fwdbase
            #pragma exclude_renderers xbox360 ps3 flash d3d11_9x 
            #pragma target 2.0
            uniform sampler2D _MainTex; uniform float4 _MainTex_ST;
            uniform float _RimExponent;
            uniform float _RimMultiplier;
            uniform float4 _RimColor;
            uniform float _EmissionMultiplier;
            uniform float _RimTextureAmount;
            struct VertexInput {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
                float2 texcoord0 : TEXCOORD0;
                float4 vertexColor : COLOR;
            };
            struct VertexOutput {
                float4 pos : SV_POSITION;
                float2 uv0 : TEXCOORD0;
                float4 posWorld : TEXCOORD1;
                float3 normalDir : TEXCOORD2;
                float4 vertexColor : COLOR;
            };
            VertexOutput vert (VertexInput v) {
                VertexOutput o;
                o.uv0 = v.texcoord0;
                o.vertexColor = v.vertexColor;
                o.normalDir = mul(float4(v.normal,0), unity_WorldToObject).xyz;
                o.posWorld = mul(unity_ObjectToWorld, v.vertex);
                o.pos = UnityObjectToClipPos(v.vertex);
                return o;
            }
            fixed4 frag(VertexOutput i) : COLOR {
                i.normalDir = normalize(i.normalDir);
                float3 viewDirection = normalize(_WorldSpaceCameraPos.xyz - i.posWorld.xyz);
/////// Normals:
                float3 normalDirection =  i.normalDir;
                
                float nSign = sign( dot( viewDirection, i.normalDir ) ); // Reverse normal if this is a backface
                i.normalDir *= nSign;
                normalDirection *= nSign;
                
////// Lighting:
////// Emissive:
                float4 node_502 = i.vertexColor;
                float2 node_509 = i.uv0;
                float4 node_10 = tex2D(_MainTex,TRANSFORM_TEX(node_509.rg, _MainTex));
                float3 node_504 = ((node_502.rgb*lerp(_RimColor.rgb,((_RimColor.rgb*_RimColor.a)*(node_10.rgb*node_10.a)),_RimTextureAmount))*node_502.a);
                float3 emissive = (node_504*_EmissionMultiplier);
                float3 finalColor = emissive + (node_504*(pow(1.0-max(0,dot(normalDirection, viewDirection)),_RimExponent)*_RimMultiplier));
/// Final Color:
                return fixed4(finalColor,1);
            }
            ENDCG
        }
    }
    FallBack "Particles/Additive (Soft)"
    CustomEditor "ShaderForgeMaterialInspector"
}
