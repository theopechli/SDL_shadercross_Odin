package sdl3

when ODIN_OS == .Windows {
	@(export) foreign import lib { "libs/windows/SDL3.lib" }
} else when ODIN_OS == .Linux  {
	@(export) foreign import lib { "libs/linux/libSDL3.so" }
} else when ODIN_OS == .Darwin {
	@(export) foreign import lib { "libs/darwin/libSDL3.dylib" }
} else {
	@(export) foreign import lib { "system:libSDL3" }
}
