package game

import "core:log"
import "core:c"
import "core:os"
import "core:strings"
import "core:fmt"
import fp "core:path/filepath"
@require import "core:mem"

import sdl "bindings:sdl3"
import sdl_shadercross "bindings:sdl_shadercross"

USE_TRACKING_ALLOCATOR :: #config(USE_TRACKING_ALLOCATOR, true)

WINDOW_TITLE :: "SDL_shadercross_Odin"

when ODIN_DEBUG {
	SHADERS_DIR :: "content/shaders/src/"
} else {
	SHADERS_DIR :: "content/shaders/compiled/"
}

RAW_TRIANGLE_VERTEX_SHADER_FILENAME  :: "raw_triangle.vert.hlsl"
SOLID_COLOR_FRAGMENT_SHADER_FILENAME :: "solid_color.frag.hlsl"

Game_State :: struct {
	window:                      ^sdl.Window,
	renderer:                    ^sdl.Renderer,
	gpu_device:                  ^sdl.GPUDevice,
	triangle_vertex_shader:      ^sdl.GPUShader,
	solid_color_fragment_shader: ^sdl.GPUShader,
	fill_pipeline:               ^sdl.GPUGraphicsPipeline,
	window_width:                c.int,
	window_height:               c.int,
	base_path:                   cstring,
	running:                     bool,
}

game_state: ^Game_State

main :: proc() {
	exe_path := os.args[0]
	exe_dir := fp.dir(string(exe_path), context.temp_allocator)
	os.set_current_directory(exe_dir)

	when USE_TRACKING_ALLOCATOR {
		default_allocator := context.allocator
		tracking_allocator: mem.Tracking_Allocator
		mem.tracking_allocator_init(&tracking_allocator, default_allocator)
		context.allocator = mem.tracking_allocator(&tracking_allocator)
	}

	logger := log.create_console_logger()
	context.logger = logger

	init()
	init_window()

	for game_state.running {
		update()
		draw()

		when USE_TRACKING_ALLOCATOR {
			for b in tracking_allocator.bad_free_array {
				log.error("Bad free at: %v", b.location)
			}

			clear(&tracking_allocator.bad_free_array)
		}

		free_all(context.temp_allocator)
	}

	shutdown_window()
	shutdown()

	free_all(context.temp_allocator)

	log.destroy_console_logger(logger)

	when USE_TRACKING_ALLOCATOR {
		for _, value in tracking_allocator.allocation_map {
			log.error("%v: Leaked %v bytes\n", value.location, value.size)
		}

		mem.tracking_allocator_destroy(&tracking_allocator)
	}
}

init :: proc() {
	game_state = new(Game_State)

	game_state^ = Game_State {
		window_width  = 800,
		window_height = 600,
		base_path     = sdl.GetBasePath(),
		running       = true,
	}
}

init_window :: proc() {
	if !sdl.InitSubSystem({.VIDEO, .EVENTS}) {
		log.errorf("Failed to initialize video and events subsystems: [%v]", sdl.GetError())
		shutdown()
		return
	}

	game_state.gpu_device = sdl.CreateGPUDevice(
		{ .SPIRV, .DXIL, .MSL },
		false,
		nil,
	)
	if game_state.gpu_device == nil {
		log.errorf("Failed to create GPU device: [%v]", sdl.GetError())
		shutdown()
		return
	}

	game_state.window = sdl.CreateWindow(
		WINDOW_TITLE,
		game_state.window_width,
		game_state.window_height,
		{.RESIZABLE},
	)
	if game_state.window == nil {
		log.errorf("Failed to create window: [%v]", sdl.GetError())
		shutdown()
		return
	}

	if !sdl.ClaimWindowForGPUDevice(game_state.gpu_device, game_state.window) {
		log.errorf("Failed to claim window for GPU device: [%v]", sdl.GetError())
		shutdown()
		return
	}

	init_shaders()
}

update :: proc() {
	event: sdl.Event

	when ODIN_DEBUG {
		for sdl.PollEvent(&event) {
			#partial switch(event.type) {
				case .KEY_DOWN:
				#partial switch(event.key.scancode) {
					case .ESCAPE:
					game_state.running = false
					case .R:
					init_shaders()
				}
			}
		}
	} else {
		for sdl.PollEvent(&event) {
			#partial switch(event.type) {
				case .KEY_DOWN:
				#partial switch(event.key.scancode) {
					case .ESCAPE:
					game_state.running = false
				}
			}
		}
	}
}

draw :: proc() {
	cmdbuf := sdl.AcquireGPUCommandBuffer(game_state.gpu_device)
	swapchain_texture: ^sdl.GPUTexture

	if !sdl.WaitAndAcquireGPUSwapchainTexture(
		cmdbuf,
		game_state.window,
		&swapchain_texture,
		nil,
		nil,
	) {
		log.errorf("Failed to acquire swapchain texture: [%v]", sdl.GetError())
		shutdown()
		return
	}

	if swapchain_texture == nil {
		if !sdl.CancelGPUCommandBuffer(cmdbuf) {
			log.errorf("Failed to cancel command buffer: [%v]", sdl.GetError())
		}
		return
	}

	color_target_info: sdl.GPUColorTargetInfo
	color_target_info.texture = swapchain_texture
	color_target_info.clear_color = { 0.82, 0.74, 0.68, 1.0 }
	color_target_info.load_op = .CLEAR
	color_target_info.store_op = .STORE

	render_pass := sdl.BeginGPURenderPass(cmdbuf, &color_target_info, 1, nil)
	sdl.BindGPUGraphicsPipeline(render_pass, game_state.fill_pipeline)
	sdl.DrawGPUPrimitives(render_pass, 3, 1, 0, 0)
	sdl.EndGPURenderPass(render_pass)

	if !sdl.SubmitGPUCommandBuffer(cmdbuf) {
		log.errorf("Failed to submit command buffer: [%v]", sdl.GetError())
	}
}

init_shaders :: proc() {
	tmp_vert_shader: ^sdl.GPUShader
	tmp_frag_shader: ^sdl.GPUShader

	when ODIN_DEBUG {
		tmp_vert_shader = compile_shader(
			game_state.gpu_device,
			RAW_TRIANGLE_VERTEX_SHADER_FILENAME,
		)
		if tmp_vert_shader == nil {
			log.errorf("Failed to compile shader: [%s]", RAW_TRIANGLE_VERTEX_SHADER_FILENAME)
			return
		}

		tmp_frag_shader = compile_shader(
			game_state.gpu_device,
			SOLID_COLOR_FRAGMENT_SHADER_FILENAME,
		)
		if tmp_frag_shader == nil {
			log.errorf("Failed to compile shader: [%s]", SOLID_COLOR_FRAGMENT_SHADER_FILENAME)
			return
		}
	} else {
		tmp_vert_shader = load_shader(
			game_state.gpu_device,
			RAW_TRIANGLE_VERTEX_SHADER_FILENAME,
			0,
			0,
			0,
			0,
		)
		if tmp_vert_shader == nil {
			log.errorf("Failed to load shader: [%s]", RAW_TRIANGLE_VERTEX_SHADER_FILENAME)
			return
		}

		tmp_frag_shader = load_shader(
			game_state.gpu_device,
			SOLID_COLOR_FRAGMENT_SHADER_FILENAME,
			0,
			0,
			0,
			0,
		)
		if tmp_frag_shader == nil {
			log.errorf("Failed to load shader: [%s]", SOLID_COLOR_FRAGMENT_SHADER_FILENAME)
			return
		}
	}

	game_state.triangle_vertex_shader = tmp_vert_shader
	game_state.solid_color_fragment_shader = tmp_frag_shader

	cdt := sdl.GPUColorTargetDescription {
		format = sdl.GetGPUSwapchainTextureFormat(game_state.gpu_device, game_state.window),
	}

	pipeline_create_info := sdl.GPUGraphicsPipelineCreateInfo {
		target_info = {
			num_color_targets = 1,
			color_target_descriptions = &cdt,
		},
		primitive_type = .TRIANGLELIST,
		vertex_shader = game_state.triangle_vertex_shader,
		fragment_shader = game_state.solid_color_fragment_shader,
	}

	pipeline_create_info.rasterizer_state.fill_mode = .FILL
	tmp_fill_pipeline := sdl.CreateGPUGraphicsPipeline(
		game_state.gpu_device,
		pipeline_create_info,
	)
	if tmp_fill_pipeline == nil {
		log.errorf("Failed to create GPU graphics pipeline: [%v]", sdl.GetError())
		return
	}

	game_state.fill_pipeline = tmp_fill_pipeline

	sdl.ReleaseGPUShader(game_state.gpu_device, game_state.triangle_vertex_shader)
	sdl.ReleaseGPUShader(game_state.gpu_device, game_state.solid_color_fragment_shader)
}

compile_shader :: proc(
	gpu_device: ^sdl.GPUDevice,
	shader_filename: string,
) -> (shader: ^sdl.GPUShader) {
	filename := shader_filename
	stage: sdl_shadercross.Shader_Stage

	if strings.contains(filename, ".vert") {
		stage = .VERTEX
	} else if strings.contains(filename, ".frag") {
		stage = .FRAGMENT
	} else {
		log.errorf("Invalid shader stage: [%s]", stage)
		return nil
	}

	full_path: string
	entrypoint: cstring

	shader_formats := sdl.GetGPUShaderFormats(gpu_device)
	if .SPIRV in shader_formats {
		full_path = fmt.tprintf("{0}{1}{2}", game_state.base_path, SHADERS_DIR, filename)
		entrypoint = "main"
	} else if .DXIL in shader_formats {
		full_path = fmt.tprintf("{0}{1}{2}", game_state.base_path, SHADERS_DIR, filename)
		entrypoint = "main"
	} else if .MSL in shader_formats {
		full_path = fmt.tprintf("{0}{1}{2}", game_state.base_path, SHADERS_DIR, filename)
		entrypoint = "main0"
	} else {
		log.error("Invalid GPU shader format")
		return nil
	}

	shader_bytes, _ := os.read_entire_file_or_err(full_path)
	defer delete(shader_bytes)
	shader_source, _ := strings.clone_to_cstring(string(shader_bytes))
	defer delete(shader_source)

	info := sdl_shadercross.HLSL_Info {
		source = shader_source,
		entrypoint = entrypoint,
		shader_stage = stage,
	}
	metadata: sdl_shadercross.Graphics_Shader_Metadata
	shader = sdl_shadercross.CompileGraphicsShaderFromHLSL(
		gpu_device,
		&info,
		&metadata,
	)
	if shader == nil {
		log.errorf("Failed to compile graphics shader from HLSL [%s]: [%v]", filename, sdl.GetError())
		return nil
	}

	return shader
}

load_shader :: proc(
	gpu_device: ^sdl.GPUDevice,
	shader_filename: string,
	sampler_count: u32,
	uniform_buffer_count: u32,
	storage_buffer_count: u32,
	storage_texture_count: u32,
) -> (shader: ^sdl.GPUShader) {
	filename := shader_filename
	stage: sdl.GPUShaderStage

	if strings.contains(filename, ".vert") {
		stage = .VERTEX
	} else if strings.contains(filename, ".frag") {
		stage = .FRAGMENT
	} else {
		log.errorf("Invalid GPU shader stage: [%s]", stage)
		return nil
	}

	full_path: string
	entrypoint: cstring
	format: sdl.GPUShaderFormat

	shader_formats := sdl.GetGPUShaderFormats(gpu_device)
	if .SPIRV in shader_formats {
		filename, _ = strings.replace(filename, ".hlsl", ".spv", 1)
		full_path = fmt.tprintf("{0}{1}SPIRV/{2}", game_state.base_path, SHADERS_DIR, filename)
		format = { .SPIRV }
		entrypoint = "main"
	} else if .DXIL in shader_formats {
		filename, _ = strings.replace(filename, ".hlsl", ".dxil", 1)
		full_path = fmt.tprintf("{0}{1}DXIL/{2}", game_state.base_path, SHADERS_DIR, filename)
		format = { .DXIL }
		entrypoint = "main"
	} else if .MSL in shader_formats {
		filename, _ = strings.replace(filename, ".hlsl", ".msl", 1)
		full_path = fmt.tprintf("{0}{1}MSL/{2}", game_state.base_path, SHADERS_DIR, filename)
		format = { .MSL }
		entrypoint = "main0"
	} else {
		log.error("Invalid GPU shader format")
		return nil
	}

	shader_bytes, _ := os.read_entire_file_or_err(full_path)
	defer delete(shader_bytes)

	shader_info := sdl.GPUShaderCreateInfo {
		code = raw_data(shader_bytes),
		code_size = len(shader_bytes),
		entrypoint = entrypoint,
		format = format,
		stage = stage,
		num_samplers = sampler_count,
		num_uniform_buffers = uniform_buffer_count,
		num_storage_buffers = storage_buffer_count,
		num_storage_textures = storage_texture_count,
	}

	shader = sdl.CreateGPUShader(gpu_device, shader_info)
	if shader == nil {
		log.errorf("Failed to create GPU shader [%s]: [%v]", filename, sdl.GetError())
		return nil
	}

	return shader
}

shutdown :: proc () {
	free(game_state)
}

shutdown_window :: proc() {
	sdl.ReleaseGPUGraphicsPipeline(game_state.gpu_device, game_state.fill_pipeline)
	sdl.ReleaseWindowFromGPUDevice(game_state.gpu_device, game_state.window)
	sdl.DestroyWindow(game_state.window)
	sdl.DestroyGPUDevice(game_state.gpu_device)
	sdl.Quit()
}
