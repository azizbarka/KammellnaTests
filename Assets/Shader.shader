Shader "Unlit/Shader"
    {
        Properties
        {
            [NoScaleOffset]_MainTex("MainTex", 2D) = "white" {}
            _Color("Color", Color) = (1, 1, 1, 1)
            _Waves("Waves", Float) = 2
            _Spread("Spread", Float) = 0
            _Speed("Speed", Float) = 0
            [HideInInspector]_BUILTIN_QueueOffset("Float", Float) = 0
            [HideInInspector]_BUILTIN_QueueControl("Float", Float) = -1
        }
        SubShader
        {
            Tags
            {
                // RenderPipeline: <None>
                "RenderType"="Transparent"
                "BuiltInMaterialType" = "Unlit"
                "Queue"="Transparent"
                // DisableBatching: <None>
                "ShaderGraphShader"="true"
                "ShaderGraphTargetId"="BuiltInUnlitSubTarget"
            }
            Pass
            {
                Name "Pass"
            
            // Render State
            Cull Back
                Blend SrcAlpha OneMinusSrcAlpha, One OneMinusSrcAlpha
                ZTest LEqual
                ZWrite Off
                ColorMask RGB
            
            // Debug
            // <None>
            
            // --------------------------------------------------
            // Pass
            
            HLSLPROGRAM
            
            // Pragmas
            #pragma target 3.0
                #pragma multi_compile_instancing
                #pragma multi_compile_fog
                #pragma multi_compile_fwdbase
                #pragma vertex vert
                #pragma fragment frag
            
            // Keywords
            // PassKeywords: <None>
            // GraphKeywords: <None>
            
            // Defines
            #define ATTRIBUTES_NEED_NORMAL
            #define ATTRIBUTES_NEED_TANGENT
            #define ATTRIBUTES_NEED_TEXCOORD0
            #define VARYINGS_NEED_TEXCOORD0
            #define FEATURES_GRAPH_VERTEX
            /* WARNING: $splice Could not find named fragment 'PassInstancing' */
            #define SHADERPASS SHADERPASS_UNLIT
                #define BUILTIN_TARGET_API 1
                #define _BUILTIN_SURFACE_TYPE_TRANSPARENT 1
            #ifdef _BUILTIN_SURFACE_TYPE_TRANSPARENT
            #define _SURFACE_TYPE_TRANSPARENT _BUILTIN_SURFACE_TYPE_TRANSPARENT
            #endif
            #ifdef _BUILTIN_ALPHATEST_ON
            #define _ALPHATEST_ON _BUILTIN_ALPHATEST_ON
            #endif
            #ifdef _BUILTIN_AlphaClip
            #define _AlphaClip _BUILTIN_AlphaClip
            #endif
            #ifdef _BUILTIN_ALPHAPREMULTIPLY_ON
            #define _ALPHAPREMULTIPLY_ON _BUILTIN_ALPHAPREMULTIPLY_ON
            #endif
            
            
            // custom interpolator pre-include
            /* WARNING: $splice Could not find named fragment 'sgci_CustomInterpolatorPreInclude' */
            
            // Includes
            #include "Packages/com.unity.shadergraph/Editor/Generation/Targets/BuiltIn/ShaderLibrary/Shim/Shims.hlsl"
            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
            #include "Packages/com.unity.shadergraph/Editor/Generation/Targets/BuiltIn/ShaderLibrary/Core.hlsl"
            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
            #include "Packages/com.unity.shadergraph/Editor/Generation/Targets/BuiltIn/ShaderLibrary/Lighting.hlsl"
            #include "Packages/com.unity.shadergraph/Editor/Generation/Targets/BuiltIn/Editor/ShaderGraph/Includes/LegacySurfaceVertex.hlsl"
            #include "Packages/com.unity.shadergraph/Editor/Generation/Targets/BuiltIn/ShaderLibrary/ShaderGraphFunctions.hlsl"
            
            // --------------------------------------------------
            // Structs and Packing
            
            // custom interpolators pre packing
            /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPrePacking' */
            
            struct Attributes
                {
                     float3 positionOS : POSITION;
                     float3 normalOS : NORMAL;
                     float4 tangentOS : TANGENT;
                     float4 uv0 : TEXCOORD0;
                    #if UNITY_ANY_INSTANCING_ENABLED
                     uint instanceID : INSTANCEID_SEMANTIC;
                    #endif
                };
                struct Varyings
                {
                     float4 positionCS : SV_POSITION;
                     float4 texCoord0;
                    #if UNITY_ANY_INSTANCING_ENABLED
                     uint instanceID : CUSTOM_INSTANCE_ID;
                    #endif
                    #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
                     uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
                    #endif
                    #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
                     uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
                    #endif
                    #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                     FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
                    #endif
                };
                struct SurfaceDescriptionInputs
                {
                     float4 uv0;
                     float3 TimeParameters;
                };
                struct VertexDescriptionInputs
                {
                     float3 ObjectSpaceNormal;
                     float3 ObjectSpaceTangent;
                     float3 ObjectSpacePosition;
                };
                struct PackedVaryings
                {
                     float4 positionCS : SV_POSITION;
                     float4 texCoord0 : INTERP0;
                    #if UNITY_ANY_INSTANCING_ENABLED
                     uint instanceID : CUSTOM_INSTANCE_ID;
                    #endif
                    #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
                     uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
                    #endif
                    #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
                     uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
                    #endif
                    #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                     FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
                    #endif
                };
            
            PackedVaryings PackVaryings (Varyings input)
                {
                    PackedVaryings output;
                    ZERO_INITIALIZE(PackedVaryings, output);
                    output.positionCS = input.positionCS;
                    output.texCoord0.xyzw = input.texCoord0;
                    #if UNITY_ANY_INSTANCING_ENABLED
                    output.instanceID = input.instanceID;
                    #endif
                    #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
                    output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
                    #endif
                    #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
                    output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
                    #endif
                    #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                    output.cullFace = input.cullFace;
                    #endif
                    return output;
                }
                
                Varyings UnpackVaryings (PackedVaryings input)
                {
                    Varyings output;
                    output.positionCS = input.positionCS;
                    output.texCoord0 = input.texCoord0.xyzw;
                    #if UNITY_ANY_INSTANCING_ENABLED
                    output.instanceID = input.instanceID;
                    #endif
                    #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
                    output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
                    #endif
                    #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
                    output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
                    #endif
                    #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                    output.cullFace = input.cullFace;
                    #endif
                    return output;
                }
                
            
            // --------------------------------------------------
            // Graph
            
            // Graph Properties
            CBUFFER_START(UnityPerMaterial)
                float4 _MainTex_TexelSize;
                float4 _Color;
                float _Waves;
                float _Spread;
                float _Speed;
                CBUFFER_END
                
                
                // Object and Global properties
                SAMPLER(SamplerState_Linear_Repeat);
                TEXTURE2D(_MainTex);
                SAMPLER(sampler_MainTex);
            
            // -- Property used by ScenePickingPass
            #ifdef SCENEPICKINGPASS
            float4 _SelectionID;
            #endif
            
            // -- Properties used by SceneSelectionPass
            #ifdef SCENESELECTIONPASS
            int _ObjectId;
            int _PassValue;
            #endif
            
            // Graph Includes
            // GraphIncludes: <None>
            
            // Graph Functions
            
                void Unity_Multiply_float_float(float A, float B, out float Out)
                {
                    Out = A * B;
                }
                
                void Unity_Add_float(float A, float B, out float Out)
                {
                    Out = A + B;
                }
                
                void Unity_Sine_float(float In, out float Out)
                {
                    Out = sin(In);
                }
                
                void Unity_Remap_float(float In, float2 InMinMax, float2 OutMinMax, out float Out)
                {
                    Out = OutMinMax.x + (In - InMinMax.x) * (OutMinMax.y - OutMinMax.x) / (InMinMax.y - InMinMax.x);
                }
                
                void Unity_Multiply_float4_float4(float4 A, float4 B, out float4 Out)
                {
                    Out = A * B;
                }
            
            // Custom interpolators pre vertex
            /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPreVertex' */
            
            // Graph Vertex
            struct VertexDescription
                {
                    float3 Position;
                    float3 Normal;
                    float3 Tangent;
                };
                
                VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
                {
                    VertexDescription description = (VertexDescription)0;
                    description.Position = IN.ObjectSpacePosition;
                    description.Normal = IN.ObjectSpaceNormal;
                    description.Tangent = IN.ObjectSpaceTangent;
                    return description;
                }
            
            // Custom interpolators, pre surface
            #ifdef FEATURES_GRAPH_VERTEX
            Varyings CustomInterpolatorPassThroughFunc(inout Varyings output, VertexDescription input)
            {
            return output;
            }
            #define CUSTOMINTERPOLATOR_VARYPASSTHROUGH_FUNC
            #endif
            
            // Graph Pixel
            struct SurfaceDescription
                {
                    float3 BaseColor;
                    float Alpha;
                };
                
                SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
                {
                    SurfaceDescription surface = (SurfaceDescription)0;
                    UnityTexture2D _Property_2304c92b1f7c41ee9e65ae6e8f67d4c3_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_MainTex);
                    float4 _UV_51189049a2e3429e92482df5570af3b9_Out_0_Vector4 = IN.uv0;
                    float _Split_1d843a8484e3461bbdd3e9483a34e393_R_1_Float = _UV_51189049a2e3429e92482df5570af3b9_Out_0_Vector4[0];
                    float _Split_1d843a8484e3461bbdd3e9483a34e393_G_2_Float = _UV_51189049a2e3429e92482df5570af3b9_Out_0_Vector4[1];
                    float _Split_1d843a8484e3461bbdd3e9483a34e393_B_3_Float = _UV_51189049a2e3429e92482df5570af3b9_Out_0_Vector4[2];
                    float _Split_1d843a8484e3461bbdd3e9483a34e393_A_4_Float = _UV_51189049a2e3429e92482df5570af3b9_Out_0_Vector4[3];
                    float _Property_07f627eccef84d108a908361dc49780d_Out_0_Float = _Waves;
                    float _Multiply_8dada4fc97d4416f92ed5d411ffef554_Out_2_Float;
                    Unity_Multiply_float_float(_Split_1d843a8484e3461bbdd3e9483a34e393_R_1_Float, _Property_07f627eccef84d108a908361dc49780d_Out_0_Float, _Multiply_8dada4fc97d4416f92ed5d411ffef554_Out_2_Float);
                    float _Property_18f17ae48d9a4e7e819480411d20b5bf_Out_0_Float = _Speed;
                    float _Multiply_26e374be373d408483008820cc4fd11c_Out_2_Float;
                    Unity_Multiply_float_float(IN.TimeParameters.x, _Property_18f17ae48d9a4e7e819480411d20b5bf_Out_0_Float, _Multiply_26e374be373d408483008820cc4fd11c_Out_2_Float);
                    float _Add_04f7a22f83a54343beff4db2cfb9c17e_Out_2_Float;
                    Unity_Add_float(_Multiply_8dada4fc97d4416f92ed5d411ffef554_Out_2_Float, _Multiply_26e374be373d408483008820cc4fd11c_Out_2_Float, _Add_04f7a22f83a54343beff4db2cfb9c17e_Out_2_Float);
                    float _Sine_5e20c0c4d23340ab9c3f8f44a0744d86_Out_1_Float;
                    Unity_Sine_float(_Add_04f7a22f83a54343beff4db2cfb9c17e_Out_2_Float, _Sine_5e20c0c4d23340ab9c3f8f44a0744d86_Out_1_Float);
                    float _Remap_17380ff107dc4bd29c0838e01499138d_Out_3_Float;
                    Unity_Remap_float(_Sine_5e20c0c4d23340ab9c3f8f44a0744d86_Out_1_Float, float2 (-1, 1), float2 (0, 1), _Remap_17380ff107dc4bd29c0838e01499138d_Out_3_Float);
                    float _Property_b91ca62d5a874ce2a4f9b9ae1ba27db6_Out_0_Float = _Spread;
                    float _Multiply_8b7992d2db864f47ae95e5aa2000e7dc_Out_2_Float;
                    Unity_Multiply_float_float(_Remap_17380ff107dc4bd29c0838e01499138d_Out_3_Float, _Property_b91ca62d5a874ce2a4f9b9ae1ba27db6_Out_0_Float, _Multiply_8b7992d2db864f47ae95e5aa2000e7dc_Out_2_Float);
                    float _Add_a6f6342e7dd0440fadb366fa970df52d_Out_2_Float;
                    Unity_Add_float(_Split_1d843a8484e3461bbdd3e9483a34e393_R_1_Float, _Multiply_8b7992d2db864f47ae95e5aa2000e7dc_Out_2_Float, _Add_a6f6342e7dd0440fadb366fa970df52d_Out_2_Float);
                    float2 _Vector2_d52dd686e9f442348d8dff4789349eef_Out_0_Vector2 = float2(_Add_a6f6342e7dd0440fadb366fa970df52d_Out_2_Float, _Split_1d843a8484e3461bbdd3e9483a34e393_G_2_Float);
                    float4 _SampleTexture2D_c3361bdef1f54ee78d5caa018b16249e_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_2304c92b1f7c41ee9e65ae6e8f67d4c3_Out_0_Texture2D.tex, _Property_2304c92b1f7c41ee9e65ae6e8f67d4c3_Out_0_Texture2D.samplerstate, _Property_2304c92b1f7c41ee9e65ae6e8f67d4c3_Out_0_Texture2D.GetTransformedUV(_Vector2_d52dd686e9f442348d8dff4789349eef_Out_0_Vector2) );
                    float _SampleTexture2D_c3361bdef1f54ee78d5caa018b16249e_R_4_Float = _SampleTexture2D_c3361bdef1f54ee78d5caa018b16249e_RGBA_0_Vector4.r;
                    float _SampleTexture2D_c3361bdef1f54ee78d5caa018b16249e_G_5_Float = _SampleTexture2D_c3361bdef1f54ee78d5caa018b16249e_RGBA_0_Vector4.g;
                    float _SampleTexture2D_c3361bdef1f54ee78d5caa018b16249e_B_6_Float = _SampleTexture2D_c3361bdef1f54ee78d5caa018b16249e_RGBA_0_Vector4.b;
                    float _SampleTexture2D_c3361bdef1f54ee78d5caa018b16249e_A_7_Float = _SampleTexture2D_c3361bdef1f54ee78d5caa018b16249e_RGBA_0_Vector4.a;
                    float4 _Property_82c85c8679de46c282f9b14e66495745_Out_0_Vector4 = _Color;
                    float4 _Multiply_52092d3ee5e7465493e04991daeefec4_Out_2_Vector4;
                    Unity_Multiply_float4_float4(_SampleTexture2D_c3361bdef1f54ee78d5caa018b16249e_RGBA_0_Vector4, _Property_82c85c8679de46c282f9b14e66495745_Out_0_Vector4, _Multiply_52092d3ee5e7465493e04991daeefec4_Out_2_Vector4);
                    surface.BaseColor = (_Multiply_52092d3ee5e7465493e04991daeefec4_Out_2_Vector4.xyz);
                    surface.Alpha = _SampleTexture2D_c3361bdef1f54ee78d5caa018b16249e_A_7_Float;
                    return surface;
                }
            
            // --------------------------------------------------
            // Build Graph Inputs
            
            VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
                {
                    VertexDescriptionInputs output;
                    ZERO_INITIALIZE(VertexDescriptionInputs, output);
                
                    output.ObjectSpaceNormal =                          input.normalOS;
                    output.ObjectSpaceTangent =                         input.tangentOS.xyz;
                    output.ObjectSpacePosition =                        input.positionOS;
                
                    return output;
                }
                
            SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
                {
                    SurfaceDescriptionInputs output;
                    ZERO_INITIALIZE(SurfaceDescriptionInputs, output);
                
                    
                
                
                
                
                
                
                    #if UNITY_UV_STARTS_AT_TOP
                    #else
                    #endif
                
                
                    output.uv0 = input.texCoord0;
                    output.TimeParameters = _TimeParameters.xyz; // This is mainly for LW as HD overwrite this value
                #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
                #else
                #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
                #endif
                #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
                
                        return output;
                }
                
                void BuildAppDataFull(Attributes attributes, VertexDescription vertexDescription, inout appdata_full result)
                {
                    result.vertex     = float4(attributes.positionOS, 1);
                    result.tangent    = attributes.tangentOS;
                    result.normal     = attributes.normalOS;
                    result.texcoord   = attributes.uv0;
                    result.vertex     = float4(vertexDescription.Position, 1);
                    result.normal     = vertexDescription.Normal;
                    result.tangent    = float4(vertexDescription.Tangent, 0);
                    #if UNITY_ANY_INSTANCING_ENABLED
                    #endif
                }
                
                void VaryingsToSurfaceVertex(Varyings varyings, inout v2f_surf result)
                {
                    result.pos = varyings.positionCS;
                    // World Tangent isn't an available input on v2f_surf
                
                
                    #if UNITY_ANY_INSTANCING_ENABLED
                    #endif
                    #if UNITY_SHOULD_SAMPLE_SH
                    #if !defined(LIGHTMAP_ON)
                    #endif
                    #endif
                    #if defined(LIGHTMAP_ON)
                    #endif
                    #ifdef VARYINGS_NEED_FOG_AND_VERTEX_LIGHT
                        result.fogCoord = varyings.fogFactorAndVertexLight.x;
                        COPY_TO_LIGHT_COORDS(result, varyings.fogFactorAndVertexLight.yzw);
                    #endif
                
                    DEFAULT_UNITY_TRANSFER_VERTEX_OUTPUT_STEREO(varyings, result);
                }
                
                void SurfaceVertexToVaryings(v2f_surf surfVertex, inout Varyings result)
                {
                    result.positionCS = surfVertex.pos;
                    // viewDirectionWS is never filled out in the legacy pass' function. Always use the value computed by SRP
                    // World Tangent isn't an available input on v2f_surf
                
                    #if UNITY_ANY_INSTANCING_ENABLED
                    #endif
                    #if UNITY_SHOULD_SAMPLE_SH
                    #if !defined(LIGHTMAP_ON)
                    #endif
                    #endif
                    #if defined(LIGHTMAP_ON)
                    #endif
                    #ifdef VARYINGS_NEED_FOG_AND_VERTEX_LIGHT
                        result.fogFactorAndVertexLight.x = surfVertex.fogCoord;
                        COPY_FROM_LIGHT_COORDS(result.fogFactorAndVertexLight.yzw, surfVertex);
                    #endif
                
                    DEFAULT_UNITY_TRANSFER_VERTEX_OUTPUT_STEREO(surfVertex, result);
                }
                
            
            // --------------------------------------------------
            // Main
            
            #include "Packages/com.unity.shadergraph/Editor/Generation/Targets/BuiltIn/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
            #include "Packages/com.unity.shadergraph/Editor/Generation/Targets/BuiltIn/Editor/ShaderGraph/Includes/Varyings.hlsl"
            #include "Packages/com.unity.shadergraph/Editor/Generation/Targets/BuiltIn/Editor/ShaderGraph/Includes/UnlitPass.hlsl"
            
            ENDHLSL
            }
            Pass
            {
                Name "ShadowCaster"
                Tags
                {
                    "LightMode" = "ShadowCaster"
                }
            
            // Render State
            Cull Back
                Blend SrcAlpha OneMinusSrcAlpha, One OneMinusSrcAlpha
                ZTest LEqual
                ZWrite On
                ColorMask 0
            
            // Debug
            // <None>
            
            // --------------------------------------------------
            // Pass
            
            HLSLPROGRAM
            
            // Pragmas
            #pragma target 3.0
                #pragma multi_compile_shadowcaster
                #pragma vertex vert
                #pragma fragment frag
            
            // Keywords
            #pragma multi_compile _ _CASTING_PUNCTUAL_LIGHT_SHADOW
            // GraphKeywords: <None>
            
            // Defines
            #define ATTRIBUTES_NEED_NORMAL
            #define ATTRIBUTES_NEED_TANGENT
            #define ATTRIBUTES_NEED_TEXCOORD0
            #define VARYINGS_NEED_TEXCOORD0
            #define FEATURES_GRAPH_VERTEX
            /* WARNING: $splice Could not find named fragment 'PassInstancing' */
            #define SHADERPASS SHADERPASS_SHADOWCASTER
                #define BUILTIN_TARGET_API 1
                #define _BUILTIN_SURFACE_TYPE_TRANSPARENT 1
            #ifdef _BUILTIN_SURFACE_TYPE_TRANSPARENT
            #define _SURFACE_TYPE_TRANSPARENT _BUILTIN_SURFACE_TYPE_TRANSPARENT
            #endif
            #ifdef _BUILTIN_ALPHATEST_ON
            #define _ALPHATEST_ON _BUILTIN_ALPHATEST_ON
            #endif
            #ifdef _BUILTIN_AlphaClip
            #define _AlphaClip _BUILTIN_AlphaClip
            #endif
            #ifdef _BUILTIN_ALPHAPREMULTIPLY_ON
            #define _ALPHAPREMULTIPLY_ON _BUILTIN_ALPHAPREMULTIPLY_ON
            #endif
            
            
            // custom interpolator pre-include
            /* WARNING: $splice Could not find named fragment 'sgci_CustomInterpolatorPreInclude' */
            
            // Includes
            #include "Packages/com.unity.shadergraph/Editor/Generation/Targets/BuiltIn/ShaderLibrary/Shim/Shims.hlsl"
            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
            #include "Packages/com.unity.shadergraph/Editor/Generation/Targets/BuiltIn/ShaderLibrary/Core.hlsl"
            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
            #include "Packages/com.unity.shadergraph/Editor/Generation/Targets/BuiltIn/ShaderLibrary/Lighting.hlsl"
            #include "Packages/com.unity.shadergraph/Editor/Generation/Targets/BuiltIn/Editor/ShaderGraph/Includes/LegacySurfaceVertex.hlsl"
            #include "Packages/com.unity.shadergraph/Editor/Generation/Targets/BuiltIn/ShaderLibrary/ShaderGraphFunctions.hlsl"
            
            // --------------------------------------------------
            // Structs and Packing
            
            // custom interpolators pre packing
            /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPrePacking' */
            
            struct Attributes
                {
                     float3 positionOS : POSITION;
                     float3 normalOS : NORMAL;
                     float4 tangentOS : TANGENT;
                     float4 uv0 : TEXCOORD0;
                    #if UNITY_ANY_INSTANCING_ENABLED
                     uint instanceID : INSTANCEID_SEMANTIC;
                    #endif
                };
                struct Varyings
                {
                     float4 positionCS : SV_POSITION;
                     float4 texCoord0;
                    #if UNITY_ANY_INSTANCING_ENABLED
                     uint instanceID : CUSTOM_INSTANCE_ID;
                    #endif
                    #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
                     uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
                    #endif
                    #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
                     uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
                    #endif
                    #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                     FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
                    #endif
                };
                struct SurfaceDescriptionInputs
                {
                     float4 uv0;
                     float3 TimeParameters;
                };
                struct VertexDescriptionInputs
                {
                     float3 ObjectSpaceNormal;
                     float3 ObjectSpaceTangent;
                     float3 ObjectSpacePosition;
                };
                struct PackedVaryings
                {
                     float4 positionCS : SV_POSITION;
                     float4 texCoord0 : INTERP0;
                    #if UNITY_ANY_INSTANCING_ENABLED
                     uint instanceID : CUSTOM_INSTANCE_ID;
                    #endif
                    #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
                     uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
                    #endif
                    #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
                     uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
                    #endif
                    #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                     FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
                    #endif
                };
            
            PackedVaryings PackVaryings (Varyings input)
                {
                    PackedVaryings output;
                    ZERO_INITIALIZE(PackedVaryings, output);
                    output.positionCS = input.positionCS;
                    output.texCoord0.xyzw = input.texCoord0;
                    #if UNITY_ANY_INSTANCING_ENABLED
                    output.instanceID = input.instanceID;
                    #endif
                    #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
                    output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
                    #endif
                    #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
                    output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
                    #endif
                    #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                    output.cullFace = input.cullFace;
                    #endif
                    return output;
                }
                
                Varyings UnpackVaryings (PackedVaryings input)
                {
                    Varyings output;
                    output.positionCS = input.positionCS;
                    output.texCoord0 = input.texCoord0.xyzw;
                    #if UNITY_ANY_INSTANCING_ENABLED
                    output.instanceID = input.instanceID;
                    #endif
                    #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
                    output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
                    #endif
                    #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
                    output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
                    #endif
                    #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                    output.cullFace = input.cullFace;
                    #endif
                    return output;
                }
                
            
            // --------------------------------------------------
            // Graph
            
            // Graph Properties
            CBUFFER_START(UnityPerMaterial)
                float4 _MainTex_TexelSize;
                float4 _Color;
                float _Waves;
                float _Spread;
                float _Speed;
                CBUFFER_END
                
                
                // Object and Global properties
                SAMPLER(SamplerState_Linear_Repeat);
                TEXTURE2D(_MainTex);
                SAMPLER(sampler_MainTex);
            
            // -- Property used by ScenePickingPass
            #ifdef SCENEPICKINGPASS
            float4 _SelectionID;
            #endif
            
            // -- Properties used by SceneSelectionPass
            #ifdef SCENESELECTIONPASS
            int _ObjectId;
            int _PassValue;
            #endif
            
            // Graph Includes
            // GraphIncludes: <None>
            
            // Graph Functions
            
                void Unity_Multiply_float_float(float A, float B, out float Out)
                {
                    Out = A * B;
                }
                
                void Unity_Add_float(float A, float B, out float Out)
                {
                    Out = A + B;
                }
                
                void Unity_Sine_float(float In, out float Out)
                {
                    Out = sin(In);
                }
                
                void Unity_Remap_float(float In, float2 InMinMax, float2 OutMinMax, out float Out)
                {
                    Out = OutMinMax.x + (In - InMinMax.x) * (OutMinMax.y - OutMinMax.x) / (InMinMax.y - InMinMax.x);
                }
            
            // Custom interpolators pre vertex
            /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPreVertex' */
            
            // Graph Vertex
            struct VertexDescription
                {
                    float3 Position;
                    float3 Normal;
                    float3 Tangent;
                };
                
                VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
                {
                    VertexDescription description = (VertexDescription)0;
                    description.Position = IN.ObjectSpacePosition;
                    description.Normal = IN.ObjectSpaceNormal;
                    description.Tangent = IN.ObjectSpaceTangent;
                    return description;
                }
            
            // Custom interpolators, pre surface
            #ifdef FEATURES_GRAPH_VERTEX
            Varyings CustomInterpolatorPassThroughFunc(inout Varyings output, VertexDescription input)
            {
            return output;
            }
            #define CUSTOMINTERPOLATOR_VARYPASSTHROUGH_FUNC
            #endif
            
            // Graph Pixel
            struct SurfaceDescription
                {
                    float Alpha;
                };
                
                SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
                {
                    SurfaceDescription surface = (SurfaceDescription)0;
                    UnityTexture2D _Property_2304c92b1f7c41ee9e65ae6e8f67d4c3_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_MainTex);
                    float4 _UV_51189049a2e3429e92482df5570af3b9_Out_0_Vector4 = IN.uv0;
                    float _Split_1d843a8484e3461bbdd3e9483a34e393_R_1_Float = _UV_51189049a2e3429e92482df5570af3b9_Out_0_Vector4[0];
                    float _Split_1d843a8484e3461bbdd3e9483a34e393_G_2_Float = _UV_51189049a2e3429e92482df5570af3b9_Out_0_Vector4[1];
                    float _Split_1d843a8484e3461bbdd3e9483a34e393_B_3_Float = _UV_51189049a2e3429e92482df5570af3b9_Out_0_Vector4[2];
                    float _Split_1d843a8484e3461bbdd3e9483a34e393_A_4_Float = _UV_51189049a2e3429e92482df5570af3b9_Out_0_Vector4[3];
                    float _Property_07f627eccef84d108a908361dc49780d_Out_0_Float = _Waves;
                    float _Multiply_8dada4fc97d4416f92ed5d411ffef554_Out_2_Float;
                    Unity_Multiply_float_float(_Split_1d843a8484e3461bbdd3e9483a34e393_R_1_Float, _Property_07f627eccef84d108a908361dc49780d_Out_0_Float, _Multiply_8dada4fc97d4416f92ed5d411ffef554_Out_2_Float);
                    float _Property_18f17ae48d9a4e7e819480411d20b5bf_Out_0_Float = _Speed;
                    float _Multiply_26e374be373d408483008820cc4fd11c_Out_2_Float;
                    Unity_Multiply_float_float(IN.TimeParameters.x, _Property_18f17ae48d9a4e7e819480411d20b5bf_Out_0_Float, _Multiply_26e374be373d408483008820cc4fd11c_Out_2_Float);
                    float _Add_04f7a22f83a54343beff4db2cfb9c17e_Out_2_Float;
                    Unity_Add_float(_Multiply_8dada4fc97d4416f92ed5d411ffef554_Out_2_Float, _Multiply_26e374be373d408483008820cc4fd11c_Out_2_Float, _Add_04f7a22f83a54343beff4db2cfb9c17e_Out_2_Float);
                    float _Sine_5e20c0c4d23340ab9c3f8f44a0744d86_Out_1_Float;
                    Unity_Sine_float(_Add_04f7a22f83a54343beff4db2cfb9c17e_Out_2_Float, _Sine_5e20c0c4d23340ab9c3f8f44a0744d86_Out_1_Float);
                    float _Remap_17380ff107dc4bd29c0838e01499138d_Out_3_Float;
                    Unity_Remap_float(_Sine_5e20c0c4d23340ab9c3f8f44a0744d86_Out_1_Float, float2 (-1, 1), float2 (0, 1), _Remap_17380ff107dc4bd29c0838e01499138d_Out_3_Float);
                    float _Property_b91ca62d5a874ce2a4f9b9ae1ba27db6_Out_0_Float = _Spread;
                    float _Multiply_8b7992d2db864f47ae95e5aa2000e7dc_Out_2_Float;
                    Unity_Multiply_float_float(_Remap_17380ff107dc4bd29c0838e01499138d_Out_3_Float, _Property_b91ca62d5a874ce2a4f9b9ae1ba27db6_Out_0_Float, _Multiply_8b7992d2db864f47ae95e5aa2000e7dc_Out_2_Float);
                    float _Add_a6f6342e7dd0440fadb366fa970df52d_Out_2_Float;
                    Unity_Add_float(_Split_1d843a8484e3461bbdd3e9483a34e393_R_1_Float, _Multiply_8b7992d2db864f47ae95e5aa2000e7dc_Out_2_Float, _Add_a6f6342e7dd0440fadb366fa970df52d_Out_2_Float);
                    float2 _Vector2_d52dd686e9f442348d8dff4789349eef_Out_0_Vector2 = float2(_Add_a6f6342e7dd0440fadb366fa970df52d_Out_2_Float, _Split_1d843a8484e3461bbdd3e9483a34e393_G_2_Float);
                    float4 _SampleTexture2D_c3361bdef1f54ee78d5caa018b16249e_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_2304c92b1f7c41ee9e65ae6e8f67d4c3_Out_0_Texture2D.tex, _Property_2304c92b1f7c41ee9e65ae6e8f67d4c3_Out_0_Texture2D.samplerstate, _Property_2304c92b1f7c41ee9e65ae6e8f67d4c3_Out_0_Texture2D.GetTransformedUV(_Vector2_d52dd686e9f442348d8dff4789349eef_Out_0_Vector2) );
                    float _SampleTexture2D_c3361bdef1f54ee78d5caa018b16249e_R_4_Float = _SampleTexture2D_c3361bdef1f54ee78d5caa018b16249e_RGBA_0_Vector4.r;
                    float _SampleTexture2D_c3361bdef1f54ee78d5caa018b16249e_G_5_Float = _SampleTexture2D_c3361bdef1f54ee78d5caa018b16249e_RGBA_0_Vector4.g;
                    float _SampleTexture2D_c3361bdef1f54ee78d5caa018b16249e_B_6_Float = _SampleTexture2D_c3361bdef1f54ee78d5caa018b16249e_RGBA_0_Vector4.b;
                    float _SampleTexture2D_c3361bdef1f54ee78d5caa018b16249e_A_7_Float = _SampleTexture2D_c3361bdef1f54ee78d5caa018b16249e_RGBA_0_Vector4.a;
                    surface.Alpha = _SampleTexture2D_c3361bdef1f54ee78d5caa018b16249e_A_7_Float;
                    return surface;
                }
            
            // --------------------------------------------------
            // Build Graph Inputs
            
            VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
                {
                    VertexDescriptionInputs output;
                    ZERO_INITIALIZE(VertexDescriptionInputs, output);
                
                    output.ObjectSpaceNormal =                          input.normalOS;
                    output.ObjectSpaceTangent =                         input.tangentOS.xyz;
                    output.ObjectSpacePosition =                        input.positionOS;
                
                    return output;
                }
                
            SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
                {
                    SurfaceDescriptionInputs output;
                    ZERO_INITIALIZE(SurfaceDescriptionInputs, output);
                
                    
                
                
                
                
                
                
                    #if UNITY_UV_STARTS_AT_TOP
                    #else
                    #endif
                
                
                    output.uv0 = input.texCoord0;
                    output.TimeParameters = _TimeParameters.xyz; // This is mainly for LW as HD overwrite this value
                #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
                #else
                #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
                #endif
                #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
                
                        return output;
                }
                
                void BuildAppDataFull(Attributes attributes, VertexDescription vertexDescription, inout appdata_full result)
                {
                    result.vertex     = float4(attributes.positionOS, 1);
                    result.tangent    = attributes.tangentOS;
                    result.normal     = attributes.normalOS;
                    result.texcoord   = attributes.uv0;
                    result.vertex     = float4(vertexDescription.Position, 1);
                    result.normal     = vertexDescription.Normal;
                    result.tangent    = float4(vertexDescription.Tangent, 0);
                    #if UNITY_ANY_INSTANCING_ENABLED
                    #endif
                }
                
                void VaryingsToSurfaceVertex(Varyings varyings, inout v2f_surf result)
                {
                    result.pos = varyings.positionCS;
                    // World Tangent isn't an available input on v2f_surf
                
                
                    #if UNITY_ANY_INSTANCING_ENABLED
                    #endif
                    #if UNITY_SHOULD_SAMPLE_SH
                    #if !defined(LIGHTMAP_ON)
                    #endif
                    #endif
                    #if defined(LIGHTMAP_ON)
                    #endif
                    #ifdef VARYINGS_NEED_FOG_AND_VERTEX_LIGHT
                        result.fogCoord = varyings.fogFactorAndVertexLight.x;
                        COPY_TO_LIGHT_COORDS(result, varyings.fogFactorAndVertexLight.yzw);
                    #endif
                
                    DEFAULT_UNITY_TRANSFER_VERTEX_OUTPUT_STEREO(varyings, result);
                }
                
                void SurfaceVertexToVaryings(v2f_surf surfVertex, inout Varyings result)
                {
                    result.positionCS = surfVertex.pos;
                    // viewDirectionWS is never filled out in the legacy pass' function. Always use the value computed by SRP
                    // World Tangent isn't an available input on v2f_surf
                
                    #if UNITY_ANY_INSTANCING_ENABLED
                    #endif
                    #if UNITY_SHOULD_SAMPLE_SH
                    #if !defined(LIGHTMAP_ON)
                    #endif
                    #endif
                    #if defined(LIGHTMAP_ON)
                    #endif
                    #ifdef VARYINGS_NEED_FOG_AND_VERTEX_LIGHT
                        result.fogFactorAndVertexLight.x = surfVertex.fogCoord;
                        COPY_FROM_LIGHT_COORDS(result.fogFactorAndVertexLight.yzw, surfVertex);
                    #endif
                
                    DEFAULT_UNITY_TRANSFER_VERTEX_OUTPUT_STEREO(surfVertex, result);
                }
                
            
            // --------------------------------------------------
            // Main
            
            #include "Packages/com.unity.shadergraph/Editor/Generation/Targets/BuiltIn/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
            #include "Packages/com.unity.shadergraph/Editor/Generation/Targets/BuiltIn/Editor/ShaderGraph/Includes/Varyings.hlsl"
            #include "Packages/com.unity.shadergraph/Editor/Generation/Targets/BuiltIn/Editor/ShaderGraph/Includes/ShadowCasterPass.hlsl"
            
            ENDHLSL
            }
         
        }
        CustomEditor "UnityEditor.ShaderGraph.GenericShaderGraphMaterialGUI"
        CustomEditorForRenderPipeline "UnityEditor.Rendering.BuiltIn.ShaderGraph.BuiltInUnlitGUI" ""
        FallBack "Hidden/Shader Graph/FallbackError"
    }