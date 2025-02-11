package sdl_shadercross

import c "core:c"

import sdl "bindings:sdl3"

when ODIN_OS == .Windows {
	foreign import sdl_shadercross {
		"libs/windows/SDL3_shadercross.lib",
		"libs/windows/spirv-cross-c-shared.lib",
	}
} else when ODIN_OS == .Linux  {
	foreign import sdl_shadercross {
		"libs/linux/libSDL3_shadercross.so",
		"libs/linux/libdxcompiler.so",
		"libs/linux/libdxil.so",
		"libs/linux/libspirv-cross-c-shared.so",
		"libs/linux/libvkd3d-shader.so",
		"libs/linux/libvkd3d-utils.so",
		"libs/linux/libvkd3d.so",
	}
} else when ODIN_OS == .Darwin {
	foreign import sdl_shadercross {
		"libs/darwin/libSDL3_shadercross.dylib",
		"libs/darwin/libdxcompiler.dylib",
		"libs/darwin/libdxil.dylib",
		"libs/darwin/libspirv-cross-c-shared.dylib",
		"libs/darwin/libvkd3d-shader.dylib",
		"libs/darwin/libvkd3d-utils.dylib",
		"libs/darwin/libvkd3d.dylib",
	}
} else {
	foreign import sdl_shadercross {
		"system:libSDL3_shadercross",
		"system:libdxcompiler",
		"system:libdxil",
		"system:libspirv-cross-c-shared",
		"system:libvkd3d-shader",
		"system:libvkd3d-utils",
		"system:libvkd3d",
	}
}

MAJOR_VERSION :: 3
MINOR_VERSION :: 0
MICRO_VERSION :: 0

Shader_Stage :: enum {
	VERTEX,
	FRAGMENT,
	COMPUTE,
}

Graphics_Shader_Metadata :: struct {
	num_samplers:         sdl.Uint32,
	num_storage_textures: sdl.Uint32,
	num_storage_buffers:  sdl.Uint32,
	num_uniform_buffers:  sdl.Uint32,
}

Compute_Pipeline_Metadata :: struct {
	num_samplers:                   sdl.Uint32,
	num_readonly_storage_textures:  sdl.Uint32,
	num_readonly_storage_buffers:   sdl.Uint32,
	num_readwrite_storage_textures: sdl.Uint32,
	num_readwrite_storage_buffers:  sdl.Uint32,
	num_uniform_buffers:            sdl.Uint32,
	threadcount_x:                  sdl.Uint32,
	threadcount_y:                  sdl.Uint32,
	threadcount_z:                  sdl.Uint32,
}

SPIRV_Info :: struct {
	bytecode: cstring,
	bytecode_size: c.size_t,
	entrypoint: cstring,
	shader_stage: Shader_Stage,
	enable_debug: c.bool,
	name: cstring,
	props: sdl.PropertiesID,
}

HLSL_Define :: struct {
	name:  cstring,
	value: cstring,
}

HLSL_Info :: struct {
	source:       cstring,
	entrypoint:   cstring,
	include_dir:  cstring,
	defines:      ^HLSL_Define,
	shader_stage: Shader_Stage,
	enable_debug: c.bool,
	name:         cstring,
	props:        sdl.PropertiesID,
}

@(default_calling_convention="c", link_prefix="SDL_ShaderCross_")
foreign sdl_shadercross {
	Init :: proc() -> c.bool ---

	Quit :: proc() ---

	GetSPIRVShaderFormats :: proc() -> sdl.GPUShaderFormat ---

	TranspileMSLFromSPIRV :: proc(info: ^SPIRV_Info) -> rawptr ---

	TranspileHLSLFromSPIRV :: proc(info: ^SPIRV_Info) -> rawptr ---

	CompileDXBCFromSPIRV :: proc(info: ^SPIRV_Info, size: ^c.size_t) -> rawptr ---

	CompileDXILFromSPIRV :: proc(info: ^SPIRV_Info, size: ^c.size_t) -> rawptr ---

	CompileGraphicsShaderFromSPIRV :: proc(device: ^sdl.GPUDevice, info: ^SPIRV_Info, metadata: ^Graphics_Shader_Metadata) -> ^sdl.GPUShader ---

	CompileComputePipelineFromSPIRV :: proc(device: ^sdl.GPUDevice, info: ^SPIRV_Info, metadata: ^Compute_Pipeline_Metadata) -> ^sdl.GPUComputePipeline ---

	ReflectGraphicsSPIRV :: proc(bytecode: cstring, bytecode_size: c.size_t, metadata: ^Graphics_Shader_Metadata) -> c.bool ---

	ReflectComputeSPIRV :: proc(bytecode: cstring, bytecode_size: c.size_t, metadata: ^Compute_Pipeline_Metadata) -> c.bool ---

	GetHLSLShaderFormats :: proc() -> sdl.GPUShaderFormat ---

	CompileDXBCFromHLSL :: proc(info: ^HLSL_Info, size: ^c.size_t) -> rawptr ---

	CompileDXILFromHLSL :: proc(info: ^HLSL_Info, size: ^c.size_t) -> rawptr ---

	CompileSPIRVFromHLSL :: proc(info: ^HLSL_Info, size: ^c.size_t) -> rawptr ---

	CompileGraphicsShaderFromHLSL :: proc(device: ^sdl.GPUDevice, info: ^HLSL_Info, metadata: ^Graphics_Shader_Metadata) -> ^sdl.GPUShader ---

	CompileComputePipelineFromHLSL :: proc(device: ^sdl.GPUDevice, info: ^HLSL_Info, metadata: ^Compute_Pipeline_Metadata) -> ^sdl.GPUComputePipeline ---
}
