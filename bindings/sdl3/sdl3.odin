// This is a modified version of:
// https://gist.github.com/harold-b/5268cab098fe57c852c5142798a93a42

package sdl3

import "base:intrinsics"
import cffi "core:c"

import vk "vendor:vulkan"

when ODIN_OS == .Windows {
	foreign import sys_sdl3 {
		"libs/windows/SDL3.dll",
	}
} else when ODIN_OS == .Linux  {
	foreign import sys_sdl3 {
		"libs/linux/libSDL3.so",
	}
} else when ODIN_OS == .Darwin {
	foreign import sys_sdl3 {
		"libs/darwin/libSDL3.dylib",
	}
} else {
	foreign import sys_sdl3 {
		"system:libSDL3",
	}
}

K_SCANCODE_MASK     :: (1<<30)
SCANCODE_TO_KEYCODE :: #force_inline proc "contextless" ( x: Scancode ) -> Keycode { return Keycode(u32(x) | K_SCANCODE_MASK) }


KMOD_CTRL  :: Keymod{ .LCTRL,  .RCTRL }  /**< Any Ctrl key is down. */
KMOD_SHIFT :: Keymod{ .LSHIFT, .RSHIFT } /**< Any Shift key is down. */
KMOD_ALT   :: Keymod{ .LALT,   .RALT }   /**< Any Alt key is down. */
KMOD_GUI   :: Keymod{ .LGUI,   .RGUI }   /**< Any GUI key is down. */

PROP_WINDOW_SHAPE_POINTER                               :: "SDL.window.shape"
PROP_WINDOW_HDR_ENABLED_BOOLEAN                         :: "SDL.window.HDR_enabled"
PROP_WINDOW_SDR_WHITE_LEVEL_FLOAT                       :: "SDL.window.SDR_white_level"
PROP_WINDOW_HDR_HEADROOM_FLOAT                          :: "SDL.window.HDR_headroom"
PROP_WINDOW_ANDROID_WINDOW_POINTER                      :: "SDL.window.android.window"
PROP_WINDOW_ANDROID_SURFACE_POINTER                     :: "SDL.window.android.surface"
PROP_WINDOW_UIKIT_WINDOW_POINTER                        :: "SDL.window.uikit.window"
PROP_WINDOW_UIKIT_METAL_VIEW_TAG_NUMBER                 :: "SDL.window.uikit.metal_view_tag"
PROP_WINDOW_UIKIT_OPENGL_FRAMEBUFFER_NUMBER             :: "SDL.window.uikit.opengl.framebuffer"
PROP_WINDOW_UIKIT_OPENGL_RENDERBUFFER_NUMBER            :: "SDL.window.uikit.opengl.renderbuffer"
PROP_WINDOW_UIKIT_OPENGL_RESOLVE_FRAMEBUFFER_NUMBER     :: "SDL.window.uikit.opengl.resolve_framebuffer"
PROP_WINDOW_KMSDRM_DEVICE_INDEX_NUMBER                  :: "SDL.window.kmsdrm.dev_index"
PROP_WINDOW_KMSDRM_DRM_FD_NUMBER                        :: "SDL.window.kmsdrm.drm_fd"
PROP_WINDOW_KMSDRM_GBM_DEVICE_POINTER                   :: "SDL.window.kmsdrm.gbm_dev"
PROP_WINDOW_COCOA_WINDOW_POINTER                        :: "SDL.window.cocoa.window"
PROP_WINDOW_COCOA_METAL_VIEW_TAG_NUMBER                 :: "SDL.window.cocoa.metal_view_tag"
PROP_WINDOW_OPENVR_OVERLAY_ID                           :: "SDL.window.openvr.overlay_id"
PROP_WINDOW_VIVANTE_DISPLAY_POINTER                     :: "SDL.window.vivante.display"
PROP_WINDOW_VIVANTE_WINDOW_POINTER                      :: "SDL.window.vivante.window"
PROP_WINDOW_VIVANTE_SURFACE_POINTER                     :: "SDL.window.vivante.surface"
PROP_WINDOW_WIN32_HWND_POINTER                          :: "SDL.window.win32.hwnd"
PROP_WINDOW_WIN32_HDC_POINTER                           :: "SDL.window.win32.hdc"
PROP_WINDOW_WIN32_INSTANCE_POINTER                      :: "SDL.window.win32.instance"
PROP_WINDOW_WAYLAND_DISPLAY_POINTER                     :: "SDL.window.wayland.display"
PROP_WINDOW_WAYLAND_SURFACE_POINTER                     :: "SDL.window.wayland.surface"
PROP_WINDOW_WAYLAND_VIEWPORT_POINTER                    :: "SDL.window.wayland.viewport"
PROP_WINDOW_WAYLAND_EGL_WINDOW_POINTER                  :: "SDL.window.wayland.egl_window"
PROP_WINDOW_WAYLAND_XDG_SURFACE_POINTER                 :: "SDL.window.wayland.xdg_surface"
PROP_WINDOW_WAYLAND_XDG_TOPLEVEL_POINTER                :: "SDL.window.wayland.xdg_toplevel"
PROP_WINDOW_WAYLAND_XDG_TOPLEVEL_EXPORT_HANDLE_STRING   :: "SDL.window.wayland.xdg_toplevel_export_handle"
PROP_WINDOW_WAYLAND_XDG_POPUP_POINTER                   :: "SDL.window.wayland.xdg_popup"
PROP_WINDOW_WAYLAND_XDG_POSITIONER_POINTER              :: "SDL.window.wayland.xdg_positioner"
PROP_WINDOW_X11_DISPLAY_POINTER                         :: "SDL.window.x11.display"
PROP_WINDOW_X11_SCREEN_NUMBER                           :: "SDL.window.x11.screen"
PROP_WINDOW_X11_WINDOW_NUMBER                           :: "SDL.window.x11.window"


@(default_calling_convention="c")
foreign sys_sdl3 {
	@(link_name="SDL_malloc")
	malloc :: proc(size: cffi.size_t) -> rawptr ---

	@(link_name="SDL_calloc")
	calloc :: proc(nmemb: cffi.size_t, size: cffi.size_t) -> rawptr ---

	@(link_name="SDL_realloc")
	realloc :: proc(mem: rawptr, size: cffi.size_t) -> rawptr ---

	@(link_name="SDL_free")
	free :: proc(mem: rawptr) ---

	@(link_name="SDL_GetOriginalMemoryFunctions")
	GetOriginalMemoryFunctions :: proc(_malloc_func: malloc_func, _calloc_func: calloc_func, _realloc_func: realloc_func, _free_func: free_func) ---

	@(link_name="SDL_GetMemoryFunctions")
	GetMemoryFunctions :: proc(_malloc_func: malloc_func, _calloc_func: calloc_func, _realloc_func: realloc_func, _free_func: free_func) ---

	@(link_name="SDL_SetMemoryFunctions")
	SetMemoryFunctions :: proc(_malloc_func: malloc_func, _calloc_func: calloc_func, _realloc_func: realloc_func, _free_func: free_func) -> cffi.bool ---

	@(link_name="SDL_aligned_alloc")
	aligned_alloc :: proc(alignment: cffi.size_t, size: cffi.size_t) -> rawptr ---

	@(link_name="SDL_aligned_free")
	aligned_free :: proc(mem: rawptr) ---

	@(link_name="SDL_GetNumAllocations")
	GetNumAllocations :: proc() -> cffi.int ---

	@(link_name="SDL_GetEnvironment")
	GetEnvironment :: proc() -> ^Environment ---

	@(link_name="SDL_CreateEnvironment")
	CreateEnvironment :: proc(populated: cffi.bool) -> ^Environment ---

	@(link_name="SDL_GetEnvironmentVariable")
	GetEnvironmentVariable :: proc(env: ^Environment, name: cstring) -> cstring ---

	@(link_name="SDL_GetEnvironmentVariables")
	GetEnvironmentVariables :: proc(env: ^Environment) -> ^cstring ---

	@(link_name="SDL_SetEnvironmentVariable")
	SetEnvironmentVariable :: proc(env: ^Environment, name: cstring, value: cstring, overwrite: cffi.bool) -> cffi.bool ---

	@(link_name="SDL_UnsetEnvironmentVariable")
	UnsetEnvironmentVariable :: proc(env: ^Environment, name: cstring) -> cffi.bool ---

	@(link_name="SDL_DestroyEnvironment")
	DestroyEnvironment :: proc(env: ^Environment) ---

	@(link_name="SDL_getenv")
	getenv :: proc(name: cstring) -> cstring ---

	@(link_name="SDL_getenv_unsafe")
	getenv_unsafe :: proc(name: cstring) -> cstring ---

	@(link_name="SDL_setenv_unsafe")
	setenv_unsafe :: proc(name: cstring, value: cstring, overwrite: cffi.int) -> cffi.int ---

	@(link_name="SDL_unsetenv_unsafe")
	unsetenv_unsafe :: proc(name: cstring) -> cffi.int ---

	@(link_name="SDL_qsort")
	qsort :: proc(base: rawptr, nmemb: cffi.size_t, size: cffi.size_t, compare: CompareCallback) ---

	@(link_name="SDL_bsearch")
	bsearch :: proc(key: rawptr, base: rawptr, nmemb: cffi.size_t, size: cffi.size_t, compare: CompareCallback) -> rawptr ---

	@(link_name="SDL_qsort_r")
	qsort_r :: proc(base: rawptr, nmemb: cffi.size_t, size: cffi.size_t, compare: CompareCallback_r, userdata: rawptr) ---

	@(link_name="SDL_bsearch_r")
	bsearch_r :: proc(key: rawptr, base: rawptr, nmemb: cffi.size_t, size: cffi.size_t, compare: CompareCallback_r, userdata: rawptr) -> rawptr ---

	@(link_name="SDL_abs")
	abs :: proc(x: cffi.int) -> cffi.int ---

	@(link_name="SDL_isalpha")
	isalpha :: proc(x: cffi.int) -> cffi.int ---

	@(link_name="SDL_isalnum")
	isalnum :: proc(x: cffi.int) -> cffi.int ---

	@(link_name="SDL_isblank")
	isblank :: proc(x: cffi.int) -> cffi.int ---

	@(link_name="SDL_iscntrl")
	iscntrl :: proc(x: cffi.int) -> cffi.int ---

	@(link_name="SDL_isdigit")
	isdigit :: proc(x: cffi.int) -> cffi.int ---

	@(link_name="SDL_isxdigit")
	isxdigit :: proc(x: cffi.int) -> cffi.int ---

	@(link_name="SDL_ispunct")
	ispunct :: proc(x: cffi.int) -> cffi.int ---

	@(link_name="SDL_isspace")
	isspace :: proc(x: cffi.int) -> cffi.int ---

	@(link_name="SDL_isupper")
	isupper :: proc(x: cffi.int) -> cffi.int ---

	@(link_name="SDL_islower")
	islower :: proc(x: cffi.int) -> cffi.int ---

	@(link_name="SDL_isprint")
	isprint :: proc(x: cffi.int) -> cffi.int ---

	@(link_name="SDL_isgraph")
	isgraph :: proc(x: cffi.int) -> cffi.int ---

	@(link_name="SDL_toupper")
	toupper :: proc(x: cffi.int) -> cffi.int ---

	@(link_name="SDL_tolower")
	tolower :: proc(x: cffi.int) -> cffi.int ---

	@(link_name="SDL_crc16")
	crc16 :: proc(crc: Uint16, data: rawptr, len: cffi.size_t) -> Uint16 ---

	@(link_name="SDL_crc32")
	crc32 :: proc(crc: Uint32, data: rawptr, len: cffi.size_t) -> Uint32 ---

	@(link_name="SDL_murmur3_32")
	murmur3_32 :: proc(data: rawptr, len: cffi.size_t, seed: Uint32) -> Uint32 ---

	@(link_name="SDL_memcpy")
	memcpy :: proc(dst: rawptr, src: rawptr, len: cffi.size_t) -> rawptr ---

	@(link_name="SDL_memmove")
	memmove :: proc(dst: rawptr, src: rawptr, len: cffi.size_t) -> rawptr ---

	@(link_name="SDL_memset")
	memset :: proc(dst: rawptr, c: cffi.int, len: cffi.size_t) -> rawptr ---

	@(link_name="SDL_memset4")
	memset4 :: proc(dst: rawptr, val: Uint32, dwords: cffi.size_t) -> rawptr ---

	@(link_name="SDL_memcmp")
	memcmp :: proc(s1: rawptr, s2: rawptr, len: cffi.size_t) -> cffi.int ---

	@(link_name="SDL_wcslen")
	wcslen :: proc(wstr: ^cffi.wchar_t) -> cffi.size_t ---

	@(link_name="SDL_wcsnlen")
	wcsnlen :: proc(wstr: ^cffi.wchar_t, maxlen: cffi.size_t) -> cffi.size_t ---

	@(link_name="SDL_wcslcpy")
	wcslcpy :: proc(dst: ^cffi.wchar_t, src: ^cffi.wchar_t, maxlen: cffi.size_t) -> cffi.size_t ---

	@(link_name="SDL_wcslcat")
	wcslcat :: proc(dst: ^cffi.wchar_t, src: ^cffi.wchar_t, maxlen: cffi.size_t) -> cffi.size_t ---

	@(link_name="SDL_wcsdup")
	wcsdup :: proc(wstr: ^cffi.wchar_t) -> ^cffi.wchar_t ---

	@(link_name="SDL_wcsstr")
	wcsstr :: proc(haystack: ^cffi.wchar_t, needle: ^cffi.wchar_t) -> ^cffi.wchar_t ---

	@(link_name="SDL_wcsnstr")
	wcsnstr :: proc(haystack: ^cffi.wchar_t, needle: ^cffi.wchar_t, maxlen: cffi.size_t) -> ^cffi.wchar_t ---

	@(link_name="SDL_wcscmp")
	wcscmp :: proc(str1: ^cffi.wchar_t, str2: ^cffi.wchar_t) -> cffi.int ---

	@(link_name="SDL_wcsncmp")
	wcsncmp :: proc(str1: ^cffi.wchar_t, str2: ^cffi.wchar_t, maxlen: cffi.size_t) -> cffi.int ---

	@(link_name="SDL_wcscasecmp")
	wcscasecmp :: proc(str1: ^cffi.wchar_t, str2: ^cffi.wchar_t) -> cffi.int ---

	@(link_name="SDL_wcsncasecmp")
	wcsncasecmp :: proc(str1: ^cffi.wchar_t, str2: ^cffi.wchar_t, maxlen: cffi.size_t) -> cffi.int ---

	@(link_name="SDL_wcstol")
	wcstol :: proc(str: ^cffi.wchar_t, endp: ^^cffi.wchar_t, base: cffi.int) -> cffi.long ---

	@(link_name="SDL_strlen")
	strlen :: proc(str: cstring) -> cffi.size_t ---

	@(link_name="SDL_strnlen")
	strnlen :: proc(str: cstring, maxlen: cffi.size_t) -> cffi.size_t ---

	@(link_name="SDL_strlcpy")
	strlcpy :: proc(dst: cstring, src: cstring, maxlen: cffi.size_t) -> cffi.size_t ---

	@(link_name="SDL_utf8strlcpy")
	utf8strlcpy :: proc(dst: cstring, src: cstring, dst_bytes: cffi.size_t) -> cffi.size_t ---

	@(link_name="SDL_strlcat")
	strlcat :: proc(dst: cstring, src: cstring, maxlen: cffi.size_t) -> cffi.size_t ---

	@(link_name="SDL_strdup")
	strdup :: proc(str: cstring) -> cstring ---

	@(link_name="SDL_strndup")
	strndup :: proc(str: cstring, maxlen: cffi.size_t) -> cstring ---

	@(link_name="SDL_strrev")
	strrev :: proc(str: cstring) -> cstring ---

	@(link_name="SDL_strupr")
	strupr :: proc(str: cstring) -> cstring ---

	@(link_name="SDL_strlwr")
	strlwr :: proc(str: cstring) -> cstring ---

	@(link_name="SDL_strchr")
	strchr :: proc(str: cstring, c: cffi.int) -> cstring ---

	@(link_name="SDL_strrchr")
	strrchr :: proc(str: cstring, c: cffi.int) -> cstring ---

	@(link_name="SDL_strstr")
	strstr :: proc(haystack: cstring, needle: cstring) -> cstring ---

	@(link_name="SDL_strnstr")
	strnstr :: proc(haystack: cstring, needle: cstring, maxlen: cffi.size_t) -> cstring ---

	@(link_name="SDL_strcasestr")
	strcasestr :: proc(haystack: cstring, needle: cstring) -> cstring ---

	@(link_name="SDL_strtok_r")
	strtok_r :: proc(s1: cstring, s2: cstring, saveptr: ^cstring) -> cstring ---

	@(link_name="SDL_utf8strlen")
	utf8strlen :: proc(str: cstring) -> cffi.size_t ---

	@(link_name="SDL_utf8strnlen")
	utf8strnlen :: proc(str: cstring, bytes: cffi.size_t) -> cffi.size_t ---

	@(link_name="SDL_itoa")
	itoa :: proc(value: cffi.int, str: cstring, radix: cffi.int) -> cstring ---

	@(link_name="SDL_uitoa")
	uitoa :: proc(value: cffi.uint, str: cstring, radix: cffi.int) -> cstring ---

	@(link_name="SDL_ltoa")
	ltoa :: proc(value: cffi.long, str: cstring, radix: cffi.int) -> cstring ---

	@(link_name="SDL_ultoa")
	ultoa :: proc(value: cffi.ulong, str: cstring, radix: cffi.int) -> cstring ---

	@(link_name="SDL_lltoa")
	lltoa :: proc(value: cffi.longlong, str: cstring, radix: cffi.int) -> cstring ---

	@(link_name="SDL_ulltoa")
	ulltoa :: proc(value: cffi.ulonglong, str: cstring, radix: cffi.int) -> cstring ---

	@(link_name="SDL_atoi")
	atoi :: proc(str: cstring) -> cffi.int ---

	@(link_name="SDL_atof")
	atof :: proc(str: cstring) -> cffi.double ---

	@(link_name="SDL_strtol")
	strtol :: proc(str: cstring, endp: ^cstring, base: cffi.int) -> cffi.long ---

	@(link_name="SDL_strtoul")
	strtoul :: proc(str: cstring, endp: ^cstring, base: cffi.int) -> cffi.ulong ---

	@(link_name="SDL_strtoll")
	strtoll :: proc(str: cstring, endp: ^cstring, base: cffi.int) -> cffi.longlong ---

	@(link_name="SDL_strtoull")
	strtoull :: proc(str: cstring, endp: ^cstring, base: cffi.int) -> cffi.ulonglong ---

	@(link_name="SDL_strtod")
	strtod :: proc(str: cstring, endp: ^cstring) -> cffi.double ---

	@(link_name="SDL_strcmp")
	strcmp :: proc(str1: cstring, str2: cstring) -> cffi.int ---

	@(link_name="SDL_strncmp")
	strncmp :: proc(str1: cstring, str2: cstring, maxlen: cffi.size_t) -> cffi.int ---

	@(link_name="SDL_strcasecmp")
	strcasecmp :: proc(str1: cstring, str2: cstring) -> cffi.int ---

	@(link_name="SDL_strncasecmp")
	strncasecmp :: proc(str1: cstring, str2: cstring, maxlen: cffi.size_t) -> cffi.int ---

	@(link_name="SDL_strpbrk")
	strpbrk :: proc(str: cstring, breakset: cstring) -> cstring ---

	@(link_name="SDL_StepUTF8")
	StepUTF8 :: proc(pstr: ^cstring, pslen: ^cffi.size_t) -> Uint32 ---

	@(link_name="SDL_StepBackUTF8")
	StepBackUTF8 :: proc(start: cstring, pstr: ^cstring) -> Uint32 ---

	@(link_name="SDL_UCS4ToUTF8")
	UCS4ToUTF8 :: proc(codepoint: Uint32, dst: cstring) -> cstring ---

	@(link_name="SDL_sscanf")
	sscanf :: proc(text: cstring, fmt: cstring, #c_vararg args: ..any) -> cffi.int ---

	@(link_name="SDL_vsscanf")
	vsscanf :: proc(text: cstring, fmt: cstring, ap: cffi.va_list) -> cffi.int ---

	@(link_name="SDL_snprintf")
	snprintf :: proc(text: cstring, maxlen: cffi.size_t, fmt: cstring, #c_vararg args: ..any) -> cffi.int ---

	@(link_name="SDL_swprintf")
	swprintf :: proc(text: ^cffi.wchar_t, maxlen: cffi.size_t, fmt: ^cffi.wchar_t, #c_vararg args: ..any) -> cffi.int ---

	@(link_name="SDL_vsnprintf")
	vsnprintf :: proc(text: cstring, maxlen: cffi.size_t, fmt: cstring, ap: cffi.va_list) -> cffi.int ---

	@(link_name="SDL_vswprintf")
	vswprintf :: proc(text: ^cffi.wchar_t, maxlen: cffi.size_t, fmt: ^cffi.wchar_t, ap: cffi.va_list) -> cffi.int ---

	@(link_name="SDL_asprintf")
	asprintf :: proc(strp: ^cstring, fmt: cstring, #c_vararg args: ..any) -> cffi.int ---

	@(link_name="SDL_vasprintf")
	vasprintf :: proc(strp: ^cstring, fmt: cstring, ap: cffi.va_list) -> cffi.int ---

	@(link_name="SDL_srand")
	srand :: proc(seed: Uint64) ---

	@(link_name="SDL_rand")
	rand :: proc(n: Sint32) -> Sint32 ---

	@(link_name="SDL_randf")
	randf :: proc() -> cffi.float ---

	@(link_name="SDL_rand_bits")
	rand_bits :: proc() -> Uint32 ---

	@(link_name="SDL_rand_r")
	rand_r :: proc(state: ^Uint64, n: Sint32) -> Sint32 ---

	@(link_name="SDL_randf_r")
	randf_r :: proc(state: ^Uint64) -> cffi.float ---

	@(link_name="SDL_rand_bits_r")
	rand_bits_r :: proc(state: ^Uint64) -> Uint32 ---

	@(link_name="SDL_acos")
	acos :: proc(x: cffi.double) -> cffi.double ---

	@(link_name="SDL_acosf")
	acosf :: proc(x: cffi.float) -> cffi.float ---

	@(link_name="SDL_asin")
	asin :: proc(x: cffi.double) -> cffi.double ---

	@(link_name="SDL_asinf")
	asinf :: proc(x: cffi.float) -> cffi.float ---

	@(link_name="SDL_atan")
	atan :: proc(x: cffi.double) -> cffi.double ---

	@(link_name="SDL_atanf")
	atanf :: proc(x: cffi.float) -> cffi.float ---

	@(link_name="SDL_atan2")
	atan2 :: proc(y: cffi.double, x: cffi.double) -> cffi.double ---

	@(link_name="SDL_atan2f")
	atan2f :: proc(y: cffi.float, x: cffi.float) -> cffi.float ---

	@(link_name="SDL_ceil")
	ceil :: proc(x: cffi.double) -> cffi.double ---

	@(link_name="SDL_ceilf")
	ceilf :: proc(x: cffi.float) -> cffi.float ---

	@(link_name="SDL_copysign")
	copysign :: proc(x: cffi.double, y: cffi.double) -> cffi.double ---

	@(link_name="SDL_copysignf")
	copysignf :: proc(x: cffi.float, y: cffi.float) -> cffi.float ---

	@(link_name="SDL_cos")
	cos :: proc(x: cffi.double) -> cffi.double ---

	@(link_name="SDL_cosf")
	cosf :: proc(x: cffi.float) -> cffi.float ---

	@(link_name="SDL_exp")
	exp :: proc(x: cffi.double) -> cffi.double ---

	@(link_name="SDL_expf")
	expf :: proc(x: cffi.float) -> cffi.float ---

	@(link_name="SDL_fabs")
	fabs :: proc(x: cffi.double) -> cffi.double ---

	@(link_name="SDL_fabsf")
	fabsf :: proc(x: cffi.float) -> cffi.float ---

	@(link_name="SDL_floor")
	floor :: proc(x: cffi.double) -> cffi.double ---

	@(link_name="SDL_floorf")
	floorf :: proc(x: cffi.float) -> cffi.float ---

	@(link_name="SDL_trunc")
	trunc :: proc(x: cffi.double) -> cffi.double ---

	@(link_name="SDL_truncf")
	truncf :: proc(x: cffi.float) -> cffi.float ---

	@(link_name="SDL_fmod")
	fmod :: proc(x: cffi.double, y: cffi.double) -> cffi.double ---

	@(link_name="SDL_fmodf")
	fmodf :: proc(x: cffi.float, y: cffi.float) -> cffi.float ---

	@(link_name="SDL_isinf")
	isinf :: proc(x: cffi.double) -> cffi.int ---

	@(link_name="SDL_isinff")
	isinff :: proc(x: cffi.float) -> cffi.int ---

	@(link_name="SDL_isnan")
	isnan :: proc(x: cffi.double) -> cffi.int ---

	@(link_name="SDL_isnanf")
	isnanf :: proc(x: cffi.float) -> cffi.int ---

	@(link_name="SDL_log")
	log :: proc(x: cffi.double) -> cffi.double ---

	@(link_name="SDL_logf")
	logf :: proc(x: cffi.float) -> cffi.float ---

	@(link_name="SDL_log10")
	log10 :: proc(x: cffi.double) -> cffi.double ---

	@(link_name="SDL_log10f")
	log10f :: proc(x: cffi.float) -> cffi.float ---

	@(link_name="SDL_modf")
	modf :: proc(x: cffi.double, y: ^cffi.double) -> cffi.double ---

	@(link_name="SDL_modff")
	modff :: proc(x: cffi.float, y: ^cffi.float) -> cffi.float ---

	@(link_name="SDL_pow")
	pow :: proc(x: cffi.double, y: cffi.double) -> cffi.double ---

	@(link_name="SDL_powf")
	powf :: proc(x: cffi.float, y: cffi.float) -> cffi.float ---

	@(link_name="SDL_round")
	round :: proc(x: cffi.double) -> cffi.double ---

	@(link_name="SDL_roundf")
	roundf :: proc(x: cffi.float) -> cffi.float ---

	@(link_name="SDL_lround")
	lround :: proc(x: cffi.double) -> cffi.long ---

	@(link_name="SDL_lroundf")
	lroundf :: proc(x: cffi.float) -> cffi.long ---

	@(link_name="SDL_scalbn")
	scalbn :: proc(x: cffi.double, n: cffi.int) -> cffi.double ---

	@(link_name="SDL_scalbnf")
	scalbnf :: proc(x: cffi.float, n: cffi.int) -> cffi.float ---

	@(link_name="SDL_sin")
	sin :: proc(x: cffi.double) -> cffi.double ---

	@(link_name="SDL_sinf")
	sinf :: proc(x: cffi.float) -> cffi.float ---

	@(link_name="SDL_sqrt")
	sqrt :: proc(x: cffi.double) -> cffi.double ---

	@(link_name="SDL_sqrtf")
	sqrtf :: proc(x: cffi.float) -> cffi.float ---

	@(link_name="SDL_tan")
	tan :: proc(x: cffi.double) -> cffi.double ---

	@(link_name="SDL_tanf")
	tanf :: proc(x: cffi.float) -> cffi.float ---

	@(link_name="SDL_iconv_open")
	iconv_open :: proc(tocode: cstring, fromcode: cstring) -> iconv_t ---

	@(link_name="SDL_iconv_close")
	iconv_close :: proc(cd: iconv_t) -> cffi.int ---

	@(link_name="SDL_iconv")
	iconv :: proc(cd: iconv_t, inbuf: ^cstring, inbytesleft: ^cffi.size_t, outbuf: ^cstring, outbytesleft: ^cffi.size_t) -> cffi.size_t ---

	@(link_name="SDL_iconv_string")
	iconv_string :: proc(tocode: cstring, fromcode: cstring, inbuf: cstring, inbytesleft: cffi.size_t) -> cstring ---

	@(link_name="SDL_ReportAssertion")
	ReportAssertion :: proc(data: ^AssertData, func: cstring, file: cstring, line: cffi.int) -> AssertState ---

	@(link_name="SDL_SetAssertionHandler")
	SetAssertionHandler :: proc(handler: AssertionHandler, userdata: rawptr) ---

	@(link_name="SDL_GetDefaultAssertionHandler")
	GetDefaultAssertionHandler :: proc() -> AssertionHandler ---

	@(link_name="SDL_GetAssertionHandler")
	GetAssertionHandler :: proc(puserdata: ^rawptr) -> AssertionHandler ---

	@(link_name="SDL_GetAssertionReport")
	GetAssertionReport :: proc() -> ^AssertData ---

	@(link_name="SDL_ResetAssertionReport")
	ResetAssertionReport :: proc() ---

	@(link_name="SDL_TryLockSpinlock")
	TryLockSpinlock :: proc(lock: ^SpinLock) -> cffi.bool ---

	@(link_name="SDL_LockSpinlock")
	LockSpinlock :: proc(lock: ^SpinLock) ---

	@(link_name="SDL_UnlockSpinlock")
	UnlockSpinlock :: proc(lock: ^SpinLock) ---

	@(link_name="SDL_MemoryBarrierReleaseFunction")
	MemoryBarrierReleaseFunction :: proc() ---

	@(link_name="SDL_MemoryBarrierAcquireFunction")
	MemoryBarrierAcquireFunction :: proc() ---

	@(link_name="SDL_CompareAndSwapAtomicInt")
	CompareAndSwapAtomicInt :: proc(a: ^AtomicInt, oldval: cffi.int, newval: cffi.int) -> cffi.bool ---

	@(link_name="SDL_SetAtomicInt")
	SetAtomicInt :: proc(a: ^AtomicInt, v: cffi.int) -> cffi.int ---

	@(link_name="SDL_GetAtomicInt")
	GetAtomicInt :: proc(a: ^AtomicInt) -> cffi.int ---

	@(link_name="SDL_AddAtomicInt")
	AddAtomicInt :: proc(a: ^AtomicInt, v: cffi.int) -> cffi.int ---

	@(link_name="SDL_CompareAndSwapAtomicU32")
	CompareAndSwapAtomicU32 :: proc(a: ^AtomicU32, oldval: Uint32, newval: Uint32) -> cffi.bool ---

	@(link_name="SDL_SetAtomicU32")
	SetAtomicU32 :: proc(a: ^AtomicU32, v: Uint32) -> Uint32 ---

	@(link_name="SDL_GetAtomicU32")
	GetAtomicU32 :: proc(a: ^AtomicU32) -> Uint32 ---

	@(link_name="SDL_CompareAndSwapAtomicPointer")
	CompareAndSwapAtomicPointer :: proc(a: ^rawptr, oldval: rawptr, newval: rawptr) -> cffi.bool ---

	@(link_name="SDL_SetAtomicPointer")
	SetAtomicPointer :: proc(a: ^rawptr, v: rawptr) -> rawptr ---

	@(link_name="SDL_GetAtomicPointer")
	GetAtomicPointer :: proc(a: ^rawptr) -> rawptr ---

	@(link_name="SDL_SetError")
	SetError :: proc(fmt: cstring, #c_vararg args: ..any) -> cffi.bool ---

	@(link_name="SDL_SetErrorV")
	SetErrorV :: proc(fmt: cstring, ap: cffi.va_list) -> cffi.bool ---

	@(link_name="SDL_OutOfMemory")
	OutOfMemory :: proc() -> cffi.bool ---

	@(link_name="SDL_GetError")
	GetError :: proc() -> cstring ---

	@(link_name="SDL_ClearError")
	ClearError :: proc() -> cffi.bool ---

	@(link_name="SDL_GetGlobalProperties")
	GetGlobalProperties :: proc() -> PropertiesID ---

	@(link_name="SDL_CreateProperties")
	CreateProperties :: proc() -> PropertiesID ---

	@(link_name="SDL_CopyProperties")
	CopyProperties :: proc(src: PropertiesID, dst: PropertiesID) -> cffi.bool ---

	@(link_name="SDL_LockProperties")
	LockProperties :: proc(props: PropertiesID) -> cffi.bool ---

	@(link_name="SDL_UnlockProperties")
	UnlockProperties :: proc(props: PropertiesID) ---

	@(link_name="SDL_SetPointerPropertyWithCleanup")
	SetPointerPropertyWithCleanup :: proc(props: PropertiesID, name: cstring, value: rawptr, cleanup: CleanupPropertyCallback, userdata: rawptr) -> cffi.bool ---

	@(link_name="SDL_SetPointerProperty")
	SetPointerProperty :: proc(props: PropertiesID, name: cstring, value: rawptr) -> cffi.bool ---

	@(link_name="SDL_SetStringProperty")
	SetStringProperty :: proc(props: PropertiesID, name: cstring, value: cstring) -> cffi.bool ---

	@(link_name="SDL_SetNumberProperty")
	SetNumberProperty :: proc(props: PropertiesID, name: cstring, value: Sint64) -> cffi.bool ---

	@(link_name="SDL_SetFloatProperty")
	SetFloatProperty :: proc(props: PropertiesID, name: cstring, value: cffi.float) -> cffi.bool ---

	@(link_name="SDL_SetBooleanProperty")
	SetBooleanProperty :: proc(props: PropertiesID, name: cstring, value: cffi.bool) -> cffi.bool ---

	@(link_name="SDL_HasProperty")
	HasProperty :: proc(props: PropertiesID, name: cstring) -> cffi.bool ---

	@(link_name="SDL_GetPropertyType")
	GetPropertyType :: proc(props: PropertiesID, name: cstring) -> PropertyType ---

	@(link_name="SDL_GetPointerProperty")
	GetPointerProperty :: proc(props: PropertiesID, name: cstring, default_value: rawptr) -> rawptr ---

	@(link_name="SDL_GetStringProperty")
	GetStringProperty :: proc(props: PropertiesID, name: cstring, default_value: cstring) -> cstring ---

	@(link_name="SDL_GetNumberProperty")
	GetNumberProperty :: proc(props: PropertiesID, name: cstring, default_value: Sint64) -> Sint64 ---

	@(link_name="SDL_GetFloatProperty")
	GetFloatProperty :: proc(props: PropertiesID, name: cstring, default_value: cffi.float) -> cffi.float ---

	@(link_name="SDL_GetBooleanProperty")
	GetBooleanProperty :: proc(props: PropertiesID, name: cstring, default_value: cffi.bool) -> cffi.bool ---

	@(link_name="SDL_ClearProperty")
	ClearProperty :: proc(props: PropertiesID, name: cstring) -> cffi.bool ---

	@(link_name="SDL_EnumerateProperties")
	EnumerateProperties :: proc(props: PropertiesID, callback: EnumeratePropertiesCallback, userdata: rawptr) -> cffi.bool ---

	@(link_name="SDL_DestroyProperties")
	DestroyProperties :: proc(props: PropertiesID) ---

	@(link_name="SDL_CreateThreadRuntime")
	CreateThreadRuntime :: proc(fn: ThreadFunction, name: cstring, data: rawptr, pfnBeginThread: FunctionPointer, pfnEndThread: FunctionPointer) -> ^Thread ---

	@(link_name="SDL_CreateThreadWithPropertiesRuntime")
	CreateThreadWithPropertiesRuntime :: proc(props: PropertiesID, pfnBeginThread: FunctionPointer, pfnEndThread: FunctionPointer) -> ^Thread ---

	@(link_name="SDL_GetThreadName")
	GetThreadName :: proc(thread: ^Thread) -> cstring ---

	@(link_name="SDL_GetCurrentThreadID")
	GetCurrentThreadID :: proc() -> ThreadID ---

	@(link_name="SDL_GetThreadID")
	GetThreadID :: proc(thread: ^Thread) -> ThreadID ---

	@(link_name="SDL_SetCurrentThreadPriority")
	SetCurrentThreadPriority :: proc(priority: ThreadPriority) -> cffi.bool ---

	@(link_name="SDL_WaitThread")
	WaitThread :: proc(thread: ^Thread, status: ^cffi.int) ---

	@(link_name="SDL_DetachThread")
	DetachThread :: proc(thread: ^Thread) ---

	@(link_name="SDL_GetTLS")
	GetTLS :: proc(id: ^TLSID) -> rawptr ---

	@(link_name="SDL_SetTLS")
	SetTLS :: proc(id: ^TLSID, value: rawptr, destructor: TLSDestructorCallback) -> cffi.bool ---

	@(link_name="SDL_CleanupTLS")
	CleanupTLS :: proc() ---

	@(link_name="SDL_CreateMutex")
	CreateMutex :: proc() -> ^Mutex ---

	@(link_name="SDL_LockMutex")
	LockMutex :: proc(mutex: ^Mutex) ---

	@(link_name="SDL_TryLockMutex")
	TryLockMutex :: proc(mutex: ^Mutex) -> cffi.bool ---

	@(link_name="SDL_UnlockMutex")
	UnlockMutex :: proc(mutex: ^Mutex) ---

	@(link_name="SDL_DestroyMutex")
	DestroyMutex :: proc(mutex: ^Mutex) ---

	@(link_name="SDL_CreateRWLock")
	CreateRWLock :: proc() -> ^RWLock ---

	@(link_name="SDL_LockRWLockForReading")
	LockRWLockForReading :: proc(rwlock: ^RWLock) ---

	@(link_name="SDL_LockRWLockForWriting")
	LockRWLockForWriting :: proc(rwlock: ^RWLock) ---

	@(link_name="SDL_TryLockRWLockForReading")
	TryLockRWLockForReading :: proc(rwlock: ^RWLock) -> cffi.bool ---

	@(link_name="SDL_TryLockRWLockForWriting")
	TryLockRWLockForWriting :: proc(rwlock: ^RWLock) -> cffi.bool ---

	@(link_name="SDL_UnlockRWLock")
	UnlockRWLock :: proc(rwlock: ^RWLock) ---

	@(link_name="SDL_DestroyRWLock")
	DestroyRWLock :: proc(rwlock: ^RWLock) ---

	@(link_name="SDL_CreateSemaphore")
	CreateSemaphore :: proc(initial_value: Uint32) -> ^Semaphore ---

	@(link_name="SDL_DestroySemaphore")
	DestroySemaphore :: proc(sem: ^Semaphore) ---

	@(link_name="SDL_WaitSemaphore")
	WaitSemaphore :: proc(sem: ^Semaphore) ---

	@(link_name="SDL_TryWaitSemaphore")
	TryWaitSemaphore :: proc(sem: ^Semaphore) -> cffi.bool ---

	@(link_name="SDL_WaitSemaphoreTimeout")
	WaitSemaphoreTimeout :: proc(sem: ^Semaphore, timeoutMS: Sint32) -> cffi.bool ---

	@(link_name="SDL_SignalSemaphore")
	SignalSemaphore :: proc(sem: ^Semaphore) ---

	@(link_name="SDL_GetSemaphoreValue")
	GetSemaphoreValue :: proc(sem: ^Semaphore) -> Uint32 ---

	@(link_name="SDL_CreateCondition")
	CreateCondition :: proc() -> ^Condition ---

	@(link_name="SDL_DestroyCondition")
	DestroyCondition :: proc(cond: ^Condition) ---

	@(link_name="SDL_SignalCondition")
	SignalCondition :: proc(cond: ^Condition) ---

	@(link_name="SDL_BroadcastCondition")
	BroadcastCondition :: proc(cond: ^Condition) ---

	@(link_name="SDL_WaitCondition")
	WaitCondition :: proc(cond: ^Condition, mutex: ^Mutex) ---

	@(link_name="SDL_WaitConditionTimeout")
	WaitConditionTimeout :: proc(cond: ^Condition, mutex: ^Mutex, timeoutMS: Sint32) -> cffi.bool ---

	@(link_name="SDL_ShouldInit")
	ShouldInit :: proc(state: ^InitState) -> cffi.bool ---

	@(link_name="SDL_ShouldQuit")
	ShouldQuit :: proc(state: ^InitState) -> cffi.bool ---

	@(link_name="SDL_SetInitialized")
	SetInitialized :: proc(state: ^InitState, initialized: cffi.bool) ---

	@(link_name="SDL_IOFromFile")
	IOFromFile :: proc(file: cstring, mode: cstring) -> ^IOStream ---

	@(link_name="SDL_IOFromMem")
	IOFromMem :: proc(mem: rawptr, size: cffi.size_t) -> ^IOStream ---

	@(link_name="SDL_IOFromConstMem")
	IOFromConstMem :: proc(mem: rawptr, size: cffi.size_t) -> ^IOStream ---

	@(link_name="SDL_IOFromDynamicMem")
	IOFromDynamicMem :: proc() -> ^IOStream ---

	@(link_name="SDL_OpenIO")
	OpenIO :: proc(iface: ^IOStreamInterface, userdata: rawptr) -> ^IOStream ---

	@(link_name="SDL_CloseIO")
	CloseIO :: proc(_context: ^IOStream) -> cffi.bool ---

	@(link_name="SDL_GetIOProperties")
	GetIOProperties :: proc(_context: ^IOStream) -> PropertiesID ---

	@(link_name="SDL_GetIOStatus")
	GetIOStatus :: proc(_context: ^IOStream) -> IOStatus ---

	@(link_name="SDL_GetIOSize")
	GetIOSize :: proc(_context: ^IOStream) -> Sint64 ---

	@(link_name="SDL_SeekIO")
	SeekIO :: proc(_context: ^IOStream, offset: Sint64, whence: IOWhence) -> Sint64 ---

	@(link_name="SDL_TellIO")
	TellIO :: proc(_context: ^IOStream) -> Sint64 ---

	@(link_name="SDL_ReadIO")
	ReadIO :: proc(_context: ^IOStream, ptr: rawptr, size: cffi.size_t) -> cffi.size_t ---

	@(link_name="SDL_WriteIO")
	WriteIO :: proc(_context: ^IOStream, ptr: rawptr, size: cffi.size_t) -> cffi.size_t ---

	@(link_name="SDL_IOprintf")
	IOprintf :: proc(_context: ^IOStream, fmt: cstring, #c_vararg args: ..any) -> cffi.size_t ---

	@(link_name="SDL_IOvprintf")
	IOvprintf :: proc(_context: ^IOStream, fmt: cstring, ap: cffi.va_list) -> cffi.size_t ---

	@(link_name="SDL_FlushIO")
	FlushIO :: proc(_context: ^IOStream) -> cffi.bool ---

	@(link_name="SDL_LoadFile_IO")
	LoadFile_IO :: proc(src: ^IOStream, datasize: ^cffi.size_t, closeio: cffi.bool) -> rawptr ---

	@(link_name="SDL_LoadFile")
	LoadFile :: proc(file: cstring, datasize: ^cffi.size_t) -> rawptr ---

	@(link_name="SDL_ReadU8")
	ReadU8 :: proc(src: ^IOStream, value: ^Uint8) -> cffi.bool ---

	@(link_name="SDL_ReadS8")
	ReadS8 :: proc(src: ^IOStream, value: ^Sint8) -> cffi.bool ---

	@(link_name="SDL_ReadU16LE")
	ReadU16LE :: proc(src: ^IOStream, value: ^Uint16) -> cffi.bool ---

	@(link_name="SDL_ReadS16LE")
	ReadS16LE :: proc(src: ^IOStream, value: ^Sint16) -> cffi.bool ---

	@(link_name="SDL_ReadU16BE")
	ReadU16BE :: proc(src: ^IOStream, value: ^Uint16) -> cffi.bool ---

	@(link_name="SDL_ReadS16BE")
	ReadS16BE :: proc(src: ^IOStream, value: ^Sint16) -> cffi.bool ---

	@(link_name="SDL_ReadU32LE")
	ReadU32LE :: proc(src: ^IOStream, value: ^Uint32) -> cffi.bool ---

	@(link_name="SDL_ReadS32LE")
	ReadS32LE :: proc(src: ^IOStream, value: ^Sint32) -> cffi.bool ---

	@(link_name="SDL_ReadU32BE")
	ReadU32BE :: proc(src: ^IOStream, value: ^Uint32) -> cffi.bool ---

	@(link_name="SDL_ReadS32BE")
	ReadS32BE :: proc(src: ^IOStream, value: ^Sint32) -> cffi.bool ---

	@(link_name="SDL_ReadU64LE")
	ReadU64LE :: proc(src: ^IOStream, value: ^Uint64) -> cffi.bool ---

	@(link_name="SDL_ReadS64LE")
	ReadS64LE :: proc(src: ^IOStream, value: ^Sint64) -> cffi.bool ---

	@(link_name="SDL_ReadU64BE")
	ReadU64BE :: proc(src: ^IOStream, value: ^Uint64) -> cffi.bool ---

	@(link_name="SDL_ReadS64BE")
	ReadS64BE :: proc(src: ^IOStream, value: ^Sint64) -> cffi.bool ---

	@(link_name="SDL_WriteU8")
	WriteU8 :: proc(dst: ^IOStream, value: Uint8) -> cffi.bool ---

	@(link_name="SDL_WriteS8")
	WriteS8 :: proc(dst: ^IOStream, value: Sint8) -> cffi.bool ---

	@(link_name="SDL_WriteU16LE")
	WriteU16LE :: proc(dst: ^IOStream, value: Uint16) -> cffi.bool ---

	@(link_name="SDL_WriteS16LE")
	WriteS16LE :: proc(dst: ^IOStream, value: Sint16) -> cffi.bool ---

	@(link_name="SDL_WriteU16BE")
	WriteU16BE :: proc(dst: ^IOStream, value: Uint16) -> cffi.bool ---

	@(link_name="SDL_WriteS16BE")
	WriteS16BE :: proc(dst: ^IOStream, value: Sint16) -> cffi.bool ---

	@(link_name="SDL_WriteU32LE")
	WriteU32LE :: proc(dst: ^IOStream, value: Uint32) -> cffi.bool ---

	@(link_name="SDL_WriteS32LE")
	WriteS32LE :: proc(dst: ^IOStream, value: Sint32) -> cffi.bool ---

	@(link_name="SDL_WriteU32BE")
	WriteU32BE :: proc(dst: ^IOStream, value: Uint32) -> cffi.bool ---

	@(link_name="SDL_WriteS32BE")
	WriteS32BE :: proc(dst: ^IOStream, value: Sint32) -> cffi.bool ---

	@(link_name="SDL_WriteU64LE")
	WriteU64LE :: proc(dst: ^IOStream, value: Uint64) -> cffi.bool ---

	@(link_name="SDL_WriteS64LE")
	WriteS64LE :: proc(dst: ^IOStream, value: Sint64) -> cffi.bool ---

	@(link_name="SDL_WriteU64BE")
	WriteU64BE :: proc(dst: ^IOStream, value: Uint64) -> cffi.bool ---

	@(link_name="SDL_WriteS64BE")
	WriteS64BE :: proc(dst: ^IOStream, value: Sint64) -> cffi.bool ---

	@(link_name="SDL_GetNumAudioDrivers")
	GetNumAudioDrivers :: proc() -> cffi.int ---

	@(link_name="SDL_GetAudioDriver")
	GetAudioDriver :: proc(index: cffi.int) -> cstring ---

	@(link_name="SDL_GetCurrentAudioDriver")
	GetCurrentAudioDriver :: proc() -> cstring ---

	@(link_name="SDL_GetAudioPlaybackDevices")
	GetAudioPlaybackDevices :: proc(count: ^cffi.int) -> ^AudioDeviceID ---

	@(link_name="SDL_GetAudioRecordingDevices")
	GetAudioRecordingDevices :: proc(count: ^cffi.int) -> ^AudioDeviceID ---

	@(link_name="SDL_GetAudioDeviceName")
	GetAudioDeviceName :: proc(devid: AudioDeviceID) -> cstring ---

	@(link_name="SDL_GetAudioDeviceFormat")
	GetAudioDeviceFormat :: proc(devid: AudioDeviceID, spec: ^AudioSpec, sample_frames: ^cffi.int) -> cffi.bool ---

	@(link_name="SDL_GetAudioDeviceChannelMap")
	GetAudioDeviceChannelMap :: proc(devid: AudioDeviceID, count: ^cffi.int) -> ^cffi.int ---

	@(link_name="SDL_OpenAudioDevice")
	OpenAudioDevice :: proc(devid: AudioDeviceID, spec: ^AudioSpec) -> AudioDeviceID ---

	@(link_name="SDL_PauseAudioDevice")
	PauseAudioDevice :: proc(dev: AudioDeviceID) -> cffi.bool ---

	@(link_name="SDL_ResumeAudioDevice")
	ResumeAudioDevice :: proc(dev: AudioDeviceID) -> cffi.bool ---

	@(link_name="SDL_AudioDevicePaused")
	AudioDevicePaused :: proc(dev: AudioDeviceID) -> cffi.bool ---

	@(link_name="SDL_GetAudioDeviceGain")
	GetAudioDeviceGain :: proc(devid: AudioDeviceID) -> cffi.float ---

	@(link_name="SDL_SetAudioDeviceGain")
	SetAudioDeviceGain :: proc(devid: AudioDeviceID, gain: cffi.float) -> cffi.bool ---

	@(link_name="SDL_CloseAudioDevice")
	CloseAudioDevice :: proc(devid: AudioDeviceID) ---

	@(link_name="SDL_BindAudioStreams")
	BindAudioStreams :: proc(devid: AudioDeviceID, streams: ^^AudioStream, num_streams: cffi.int) -> cffi.bool ---

	@(link_name="SDL_BindAudioStream")
	BindAudioStream :: proc(devid: AudioDeviceID, stream: ^AudioStream) -> cffi.bool ---

	@(link_name="SDL_UnbindAudioStreams")
	UnbindAudioStreams :: proc(streams: ^^AudioStream, num_streams: cffi.int) ---

	@(link_name="SDL_UnbindAudioStream")
	UnbindAudioStream :: proc(stream: ^AudioStream) ---

	@(link_name="SDL_GetAudioStreamDevice")
	GetAudioStreamDevice :: proc(stream: ^AudioStream) -> AudioDeviceID ---

	@(link_name="SDL_CreateAudioStream")
	CreateAudioStream :: proc(src_spec: ^AudioSpec, dst_spec: ^AudioSpec) -> ^AudioStream ---

	@(link_name="SDL_GetAudioStreamProperties")
	GetAudioStreamProperties :: proc(stream: ^AudioStream) -> PropertiesID ---

	@(link_name="SDL_GetAudioStreamFormat")
	GetAudioStreamFormat :: proc(stream: ^AudioStream, src_spec: ^AudioSpec, dst_spec: ^AudioSpec) -> cffi.bool ---

	@(link_name="SDL_SetAudioStreamFormat")
	SetAudioStreamFormat :: proc(stream: ^AudioStream, src_spec: ^AudioSpec, dst_spec: ^AudioSpec) -> cffi.bool ---

	@(link_name="SDL_GetAudioStreamFrequencyRatio")
	GetAudioStreamFrequencyRatio :: proc(stream: ^AudioStream) -> cffi.float ---

	@(link_name="SDL_SetAudioStreamFrequencyRatio")
	SetAudioStreamFrequencyRatio :: proc(stream: ^AudioStream, ratio: cffi.float) -> cffi.bool ---

	@(link_name="SDL_GetAudioStreamGain")
	GetAudioStreamGain :: proc(stream: ^AudioStream) -> cffi.float ---

	@(link_name="SDL_SetAudioStreamGain")
	SetAudioStreamGain :: proc(stream: ^AudioStream, gain: cffi.float) -> cffi.bool ---

	@(link_name="SDL_GetAudioStreamInputChannelMap")
	GetAudioStreamInputChannelMap :: proc(stream: ^AudioStream, count: ^cffi.int) -> ^cffi.int ---

	@(link_name="SDL_GetAudioStreamOutputChannelMap")
	GetAudioStreamOutputChannelMap :: proc(stream: ^AudioStream, count: ^cffi.int) -> ^cffi.int ---

	@(link_name="SDL_SetAudioStreamInputChannelMap")
	SetAudioStreamInputChannelMap :: proc(stream: ^AudioStream, chmap: ^cffi.int, count: cffi.int) -> cffi.bool ---

	@(link_name="SDL_SetAudioStreamOutputChannelMap")
	SetAudioStreamOutputChannelMap :: proc(stream: ^AudioStream, chmap: ^cffi.int, count: cffi.int) -> cffi.bool ---

	@(link_name="SDL_PutAudioStreamData")
	PutAudioStreamData :: proc(stream: ^AudioStream, buf: rawptr, len: cffi.int) -> cffi.bool ---

	@(link_name="SDL_GetAudioStreamData")
	GetAudioStreamData :: proc(stream: ^AudioStream, buf: rawptr, len: cffi.int) -> cffi.int ---

	@(link_name="SDL_GetAudioStreamAvailable")
	GetAudioStreamAvailable :: proc(stream: ^AudioStream) -> cffi.int ---

	@(link_name="SDL_GetAudioStreamQueued")
	GetAudioStreamQueued :: proc(stream: ^AudioStream) -> cffi.int ---

	@(link_name="SDL_FlushAudioStream")
	FlushAudioStream :: proc(stream: ^AudioStream) -> cffi.bool ---

	@(link_name="SDL_ClearAudioStream")
	ClearAudioStream :: proc(stream: ^AudioStream) -> cffi.bool ---

	@(link_name="SDL_PauseAudioStreamDevice")
	PauseAudioStreamDevice :: proc(stream: ^AudioStream) -> cffi.bool ---

	@(link_name="SDL_ResumeAudioStreamDevice")
	ResumeAudioStreamDevice :: proc(stream: ^AudioStream) -> cffi.bool ---

	@(link_name="SDL_LockAudioStream")
	LockAudioStream :: proc(stream: ^AudioStream) -> cffi.bool ---

	@(link_name="SDL_UnlockAudioStream")
	UnlockAudioStream :: proc(stream: ^AudioStream) -> cffi.bool ---

	@(link_name="SDL_SetAudioStreamGetCallback")
	SetAudioStreamGetCallback :: proc(stream: ^AudioStream, callback: AudioStreamCallback, userdata: rawptr) -> cffi.bool ---

	@(link_name="SDL_SetAudioStreamPutCallback")
	SetAudioStreamPutCallback :: proc(stream: ^AudioStream, callback: AudioStreamCallback, userdata: rawptr) -> cffi.bool ---

	@(link_name="SDL_DestroyAudioStream")
	DestroyAudioStream :: proc(stream: ^AudioStream) ---

	@(link_name="SDL_OpenAudioDeviceStream")
	OpenAudioDeviceStream :: proc(devid: AudioDeviceID, spec: ^AudioSpec, callback: AudioStreamCallback, userdata: rawptr) -> ^AudioStream ---

	@(link_name="SDL_SetAudioPostmixCallback")
	SetAudioPostmixCallback :: proc(devid: AudioDeviceID, callback: AudioPostmixCallback, userdata: rawptr) -> cffi.bool ---

	@(link_name="SDL_LoadWAV_IO")
	LoadWAV_IO :: proc(src: ^IOStream, closeio: cffi.bool, spec: ^AudioSpec, audio_buf: ^^Uint8, audio_len: ^Uint32) -> cffi.bool ---

	@(link_name="SDL_LoadWAV")
	LoadWAV :: proc(path: cstring, spec: ^AudioSpec, audio_buf: ^^Uint8, audio_len: ^Uint32) -> cffi.bool ---

	@(link_name="SDL_MixAudio")
	MixAudio :: proc(dst: ^Uint8, src: ^Uint8, format: AudioFormat, len: Uint32, volume: cffi.float) -> cffi.bool ---

	@(link_name="SDL_ConvertAudioSamples")
	ConvertAudioSamples :: proc(src_spec: ^AudioSpec, src_data: ^Uint8, src_len: cffi.int, dst_spec: ^AudioSpec, dst_data: ^^Uint8, dst_len: ^cffi.int) -> cffi.bool ---

	@(link_name="SDL_GetAudioFormatName")
	GetAudioFormatName :: proc(format: AudioFormat) -> cstring ---

	@(link_name="SDL_GetSilenceValueForFormat")
	GetSilenceValueForFormat :: proc(format: AudioFormat) -> cffi.int ---

	@(link_name="SDL_ComposeCustomBlendMode")
	ComposeCustomBlendMode :: proc(srcColorFactor: BlendFactor, dstColorFactor: BlendFactor, colorOperation: BlendOperation, srcAlphaFactor: BlendFactor, dstAlphaFactor: BlendFactor, alphaOperation: BlendOperation) -> BlendMode ---

	@(link_name="SDL_GetPixelFormatName")
	GetPixelFormatName :: proc(format: PixelFormat) -> cstring ---

	@(link_name="SDL_GetMasksForPixelFormat")
	GetMasksForPixelFormat :: proc(format: PixelFormat, bpp: ^cffi.int, Rmask: ^Uint32, Gmask: ^Uint32, Bmask: ^Uint32, Amask: ^Uint32) -> cffi.bool ---

	@(link_name="SDL_GetPixelFormatForMasks")
	GetPixelFormatForMasks :: proc(bpp: cffi.int, Rmask: Uint32, Gmask: Uint32, Bmask: Uint32, Amask: Uint32) -> PixelFormat ---

	@(link_name="SDL_GetPixelFormatDetails")
	GetPixelFormatDetails :: proc(format: PixelFormat) -> ^PixelFormatDetails ---

	@(link_name="SDL_CreatePalette")
	CreatePalette :: proc(ncolors: cffi.int) -> ^Palette ---

	@(link_name="SDL_SetPaletteColors")
	SetPaletteColors :: proc(palette: ^Palette, colors: ^Color, firstcolor: cffi.int, ncolors: cffi.int) -> cffi.bool ---

	@(link_name="SDL_DestroyPalette")
	DestroyPalette :: proc(palette: ^Palette) ---

	@(link_name="SDL_MapRGB")
	MapRGB :: proc(format: ^PixelFormatDetails, palette: ^Palette, r: Uint8, g: Uint8, b: Uint8) -> Uint32 ---

	@(link_name="SDL_MapRGBA")
	MapRGBA :: proc(format: ^PixelFormatDetails, palette: ^Palette, r: Uint8, g: Uint8, b: Uint8, a: Uint8) -> Uint32 ---

	@(link_name="SDL_GetRGB")
	GetRGB :: proc(pixel: Uint32, format: ^PixelFormatDetails, palette: ^Palette, r: ^Uint8, g: ^Uint8, b: ^Uint8) ---

	@(link_name="SDL_GetRGBA")
	GetRGBA :: proc(pixel: Uint32, format: ^PixelFormatDetails, palette: ^Palette, r: ^Uint8, g: ^Uint8, b: ^Uint8, a: ^Uint8) ---

	@(link_name="SDL_HasRectIntersection")
	HasRectIntersection :: proc(A: ^Rect, B: ^Rect) -> cffi.bool ---

	@(link_name="SDL_GetRectIntersection")
	GetRectIntersection :: proc(A: ^Rect, B: ^Rect, result: ^Rect) -> cffi.bool ---

	@(link_name="SDL_GetRectUnion")
	GetRectUnion :: proc(A: ^Rect, B: ^Rect, result: ^Rect) -> cffi.bool ---

	@(link_name="SDL_GetRectEnclosingPoints")
	GetRectEnclosingPoints :: proc(points: ^Point, count: cffi.int, clip: ^Rect, result: ^Rect) -> cffi.bool ---

	@(link_name="SDL_GetRectAndLineIntersection")
	GetRectAndLineIntersection :: proc(rect: ^Rect, X1: ^cffi.int, Y1: ^cffi.int, X2: ^cffi.int, Y2: ^cffi.int) -> cffi.bool ---

	@(link_name="SDL_HasRectIntersectionFloat")
	HasRectIntersectionFloat :: proc(A: ^FRect, B: ^FRect) -> cffi.bool ---

	@(link_name="SDL_GetRectIntersectionFloat")
	GetRectIntersectionFloat :: proc(A: ^FRect, B: ^FRect, result: ^FRect) -> cffi.bool ---

	@(link_name="SDL_GetRectUnionFloat")
	GetRectUnionFloat :: proc(A: ^FRect, B: ^FRect, result: ^FRect) -> cffi.bool ---

	@(link_name="SDL_GetRectEnclosingPointsFloat")
	GetRectEnclosingPointsFloat :: proc(points: ^FPoint, count: cffi.int, clip: ^FRect, result: ^FRect) -> cffi.bool ---

	@(link_name="SDL_GetRectAndLineIntersectionFloat")
	GetRectAndLineIntersectionFloat :: proc(rect: ^FRect, X1: ^cffi.float, Y1: ^cffi.float, X2: ^cffi.float, Y2: ^cffi.float) -> cffi.bool ---

	@(link_name="SDL_CreateSurface")
	CreateSurface :: proc(width: cffi.int, height: cffi.int, format: PixelFormat) -> ^Surface ---

	@(link_name="SDL_CreateSurfaceFrom")
	CreateSurfaceFrom :: proc(width: cffi.int, height: cffi.int, format: PixelFormat, pixels: rawptr, pitch: cffi.int) -> ^Surface ---

	@(link_name="SDL_DestroySurface")
	DestroySurface :: proc(surface: ^Surface) ---

	@(link_name="SDL_GetSurfaceProperties")
	GetSurfaceProperties :: proc(surface: ^Surface) -> PropertiesID ---

	@(link_name="SDL_SetSurfaceColorspace")
	SetSurfaceColorspace :: proc(surface: ^Surface, colorspace: Colorspace) -> cffi.bool ---

	@(link_name="SDL_GetSurfaceColorspace")
	GetSurfaceColorspace :: proc(surface: ^Surface) -> Colorspace ---

	@(link_name="SDL_CreateSurfacePalette")
	CreateSurfacePalette :: proc(surface: ^Surface) -> ^Palette ---

	@(link_name="SDL_SetSurfacePalette")
	SetSurfacePalette :: proc(surface: ^Surface, palette: ^Palette) -> cffi.bool ---

	@(link_name="SDL_GetSurfacePalette")
	GetSurfacePalette :: proc(surface: ^Surface) -> ^Palette ---

	@(link_name="SDL_AddSurfaceAlternateImage")
	AddSurfaceAlternateImage :: proc(surface: ^Surface, image: ^Surface) -> cffi.bool ---

	@(link_name="SDL_SurfaceHasAlternateImages")
	SurfaceHasAlternateImages :: proc(surface: ^Surface) -> cffi.bool ---

	@(link_name="SDL_GetSurfaceImages")
	GetSurfaceImages :: proc(surface: ^Surface, count: ^cffi.int) -> ^^Surface ---

	@(link_name="SDL_RemoveSurfaceAlternateImages")
	RemoveSurfaceAlternateImages :: proc(surface: ^Surface) ---

	@(link_name="SDL_LockSurface")
	LockSurface :: proc(surface: ^Surface) -> cffi.bool ---

	@(link_name="SDL_UnlockSurface")
	UnlockSurface :: proc(surface: ^Surface) ---

	@(link_name="SDL_LoadBMP_IO")
	LoadBMP_IO :: proc(src: ^IOStream, closeio: cffi.bool) -> ^Surface ---

	@(link_name="SDL_LoadBMP")
	LoadBMP :: proc(file: cstring) -> ^Surface ---

	@(link_name="SDL_SaveBMP_IO")
	SaveBMP_IO :: proc(surface: ^Surface, dst: ^IOStream, closeio: cffi.bool) -> cffi.bool ---

	@(link_name="SDL_SaveBMP")
	SaveBMP :: proc(surface: ^Surface, file: cstring) -> cffi.bool ---

	@(link_name="SDL_SetSurfaceRLE")
	SetSurfaceRLE :: proc(surface: ^Surface, enabled: cffi.bool) -> cffi.bool ---

	@(link_name="SDL_SurfaceHasRLE")
	SurfaceHasRLE :: proc(surface: ^Surface) -> cffi.bool ---

	@(link_name="SDL_SetSurfaceColorKey")
	SetSurfaceColorKey :: proc(surface: ^Surface, enabled: cffi.bool, key: Uint32) -> cffi.bool ---

	@(link_name="SDL_SurfaceHasColorKey")
	SurfaceHasColorKey :: proc(surface: ^Surface) -> cffi.bool ---

	@(link_name="SDL_GetSurfaceColorKey")
	GetSurfaceColorKey :: proc(surface: ^Surface, key: ^Uint32) -> cffi.bool ---

	@(link_name="SDL_SetSurfaceColorMod")
	SetSurfaceColorMod :: proc(surface: ^Surface, r: Uint8, g: Uint8, b: Uint8) -> cffi.bool ---

	@(link_name="SDL_GetSurfaceColorMod")
	GetSurfaceColorMod :: proc(surface: ^Surface, r: ^Uint8, g: ^Uint8, b: ^Uint8) -> cffi.bool ---

	@(link_name="SDL_SetSurfaceAlphaMod")
	SetSurfaceAlphaMod :: proc(surface: ^Surface, alpha: Uint8) -> cffi.bool ---

	@(link_name="SDL_GetSurfaceAlphaMod")
	GetSurfaceAlphaMod :: proc(surface: ^Surface, alpha: ^Uint8) -> cffi.bool ---

	@(link_name="SDL_SetSurfaceBlendMode")
	SetSurfaceBlendMode :: proc(surface: ^Surface, blendMode: BlendMode) -> cffi.bool ---

	@(link_name="SDL_GetSurfaceBlendMode")
	GetSurfaceBlendMode :: proc(surface: ^Surface, blendMode: ^BlendMode) -> cffi.bool ---

	@(link_name="SDL_SetSurfaceClipRect")
	SetSurfaceClipRect :: proc(surface: ^Surface, rect: ^Rect) -> cffi.bool ---

	@(link_name="SDL_GetSurfaceClipRect")
	GetSurfaceClipRect :: proc(surface: ^Surface, rect: ^Rect) -> cffi.bool ---

	@(link_name="SDL_FlipSurface")
	FlipSurface :: proc(surface: ^Surface, flip: FlipMode) -> cffi.bool ---

	@(link_name="SDL_DuplicateSurface")
	DuplicateSurface :: proc(surface: ^Surface) -> ^Surface ---

	@(link_name="SDL_ScaleSurface")
	ScaleSurface :: proc(surface: ^Surface, width: cffi.int, height: cffi.int, scaleMode: ScaleMode) -> ^Surface ---

	@(link_name="SDL_ConvertSurface")
	ConvertSurface :: proc(surface: ^Surface, format: PixelFormat) -> ^Surface ---

	@(link_name="SDL_ConvertSurfaceAndColorspace")
	ConvertSurfaceAndColorspace :: proc(surface: ^Surface, format: PixelFormat, palette: ^Palette, colorspace: Colorspace, props: PropertiesID) -> ^Surface ---

	@(link_name="SDL_ConvertPixels")
	ConvertPixels :: proc(width: cffi.int, height: cffi.int, src_format: PixelFormat, src: rawptr, src_pitch: cffi.int, dst_format: PixelFormat, dst: rawptr, dst_pitch: cffi.int) -> cffi.bool ---

	@(link_name="SDL_ConvertPixelsAndColorspace")
	ConvertPixelsAndColorspace :: proc(width: cffi.int, height: cffi.int, src_format: PixelFormat, src_colorspace: Colorspace, src_properties: PropertiesID, src: rawptr, src_pitch: cffi.int, dst_format: PixelFormat, dst_colorspace: Colorspace, dst_properties: PropertiesID, dst: rawptr, dst_pitch: cffi.int) -> cffi.bool ---

	@(link_name="SDL_PremultiplyAlpha")
	PremultiplyAlpha :: proc(width: cffi.int, height: cffi.int, src_format: PixelFormat, src: rawptr, src_pitch: cffi.int, dst_format: PixelFormat, dst: rawptr, dst_pitch: cffi.int, linear: cffi.bool) -> cffi.bool ---

	@(link_name="SDL_PremultiplySurfaceAlpha")
	PremultiplySurfaceAlpha :: proc(surface: ^Surface, linear: cffi.bool) -> cffi.bool ---

	@(link_name="SDL_ClearSurface")
	ClearSurface :: proc(surface: ^Surface, r: cffi.float, g: cffi.float, b: cffi.float, a: cffi.float) -> cffi.bool ---

	@(link_name="SDL_FillSurfaceRect")
	FillSurfaceRect :: proc(dst: ^Surface, rect: ^Rect, color: Uint32) -> cffi.bool ---

	@(link_name="SDL_FillSurfaceRects")
	FillSurfaceRects :: proc(dst: ^Surface, rects: ^Rect, count: cffi.int, color: Uint32) -> cffi.bool ---

	@(link_name="SDL_BlitSurface")
	BlitSurface :: proc(src: ^Surface, srcrect: ^Rect, dst: ^Surface, dstrect: ^Rect) -> cffi.bool ---

	@(link_name="SDL_BlitSurfaceUnchecked")
	BlitSurfaceUnchecked :: proc(src: ^Surface, srcrect: ^Rect, dst: ^Surface, dstrect: ^Rect) -> cffi.bool ---

	@(link_name="SDL_BlitSurfaceScaled")
	BlitSurfaceScaled :: proc(src: ^Surface, srcrect: ^Rect, dst: ^Surface, dstrect: ^Rect, scaleMode: ScaleMode) -> cffi.bool ---

	@(link_name="SDL_BlitSurfaceUncheckedScaled")
	BlitSurfaceUncheckedScaled :: proc(src: ^Surface, srcrect: ^Rect, dst: ^Surface, dstrect: ^Rect, scaleMode: ScaleMode) -> cffi.bool ---

	@(link_name="SDL_BlitSurfaceTiled")
	BlitSurfaceTiled :: proc(src: ^Surface, srcrect: ^Rect, dst: ^Surface, dstrect: ^Rect) -> cffi.bool ---

	@(link_name="SDL_BlitSurfaceTiledWithScale")
	BlitSurfaceTiledWithScale :: proc(src: ^Surface, srcrect: ^Rect, scale: cffi.float, scaleMode: ScaleMode, dst: ^Surface, dstrect: ^Rect) -> cffi.bool ---

	@(link_name="SDL_BlitSurface9Grid")
	BlitSurface9Grid :: proc(src: ^Surface, srcrect: ^Rect, left_width: cffi.int, right_width: cffi.int, top_height: cffi.int, bottom_height: cffi.int, scale: cffi.float, scaleMode: ScaleMode, dst: ^Surface, dstrect: ^Rect) -> cffi.bool ---

	@(link_name="SDL_MapSurfaceRGB")
	MapSurfaceRGB :: proc(surface: ^Surface, r: Uint8, g: Uint8, b: Uint8) -> Uint32 ---

	@(link_name="SDL_MapSurfaceRGBA")
	MapSurfaceRGBA :: proc(surface: ^Surface, r: Uint8, g: Uint8, b: Uint8, a: Uint8) -> Uint32 ---

	@(link_name="SDL_ReadSurfacePixel")
	ReadSurfacePixel :: proc(surface: ^Surface, x: cffi.int, y: cffi.int, r: ^Uint8, g: ^Uint8, b: ^Uint8, a: ^Uint8) -> cffi.bool ---

	@(link_name="SDL_ReadSurfacePixelFloat")
	ReadSurfacePixelFloat :: proc(surface: ^Surface, x: cffi.int, y: cffi.int, r: ^cffi.float, g: ^cffi.float, b: ^cffi.float, a: ^cffi.float) -> cffi.bool ---

	@(link_name="SDL_WriteSurfacePixel")
	WriteSurfacePixel :: proc(surface: ^Surface, x: cffi.int, y: cffi.int, r: Uint8, g: Uint8, b: Uint8, a: Uint8) -> cffi.bool ---

	@(link_name="SDL_WriteSurfacePixelFloat")
	WriteSurfacePixelFloat :: proc(surface: ^Surface, x: cffi.int, y: cffi.int, r: cffi.float, g: cffi.float, b: cffi.float, a: cffi.float) -> cffi.bool ---

	@(link_name="SDL_GetNumCameraDrivers")
	GetNumCameraDrivers :: proc() -> cffi.int ---

	@(link_name="SDL_GetCameraDriver")
	GetCameraDriver :: proc(index: cffi.int) -> cstring ---

	@(link_name="SDL_GetCurrentCameraDriver")
	GetCurrentCameraDriver :: proc() -> cstring ---

	@(link_name="SDL_GetCameras")
	GetCameras :: proc(count: ^cffi.int) -> ^CameraID ---

	@(link_name="SDL_GetCameraSupportedFormats")
	GetCameraSupportedFormats :: proc(devid: CameraID, count: ^cffi.int) -> ^^CameraSpec ---

	@(link_name="SDL_GetCameraName")
	GetCameraName :: proc(instance_id: CameraID) -> cstring ---

	@(link_name="SDL_GetCameraPosition")
	GetCameraPosition :: proc(instance_id: CameraID) -> CameraPosition ---

	@(link_name="SDL_OpenCamera")
	OpenCamera :: proc(instance_id: CameraID, spec: ^CameraSpec) -> ^Camera ---

	@(link_name="SDL_GetCameraPermissionState")
	GetCameraPermissionState :: proc(camera: ^Camera) -> cffi.int ---

	@(link_name="SDL_GetCameraID")
	GetCameraID :: proc(camera: ^Camera) -> CameraID ---

	@(link_name="SDL_GetCameraProperties")
	GetCameraProperties :: proc(camera: ^Camera) -> PropertiesID ---

	@(link_name="SDL_GetCameraFormat")
	GetCameraFormat :: proc(camera: ^Camera, spec: ^CameraSpec) -> cffi.bool ---

	@(link_name="SDL_AcquireCameraFrame")
	AcquireCameraFrame :: proc(camera: ^Camera, timestampNS: ^Uint64) -> ^Surface ---

	@(link_name="SDL_ReleaseCameraFrame")
	ReleaseCameraFrame :: proc(camera: ^Camera, frame: ^Surface) ---

	@(link_name="SDL_CloseCamera")
	CloseCamera :: proc(camera: ^Camera) ---

	@(link_name="SDL_SetClipboardText")
	SetClipboardText :: proc(text: cstring) -> cffi.bool ---

	@(link_name="SDL_GetClipboardText")
	GetClipboardText :: proc() -> cstring ---

	@(link_name="SDL_HasClipboardText")
	HasClipboardText :: proc() -> cffi.bool ---

	@(link_name="SDL_SetPrimarySelectionText")
	SetPrimarySelectionText :: proc(text: cstring) -> cffi.bool ---

	@(link_name="SDL_GetPrimarySelectionText")
	GetPrimarySelectionText :: proc() -> cstring ---

	@(link_name="SDL_HasPrimarySelectionText")
	HasPrimarySelectionText :: proc() -> cffi.bool ---

	@(link_name="SDL_SetClipboardData")
	SetClipboardData :: proc(callback: ClipboardDataCallback, cleanup: ClipboardCleanupCallback, userdata: rawptr, mime_types: ^cstring, num_mime_types: cffi.size_t) -> cffi.bool ---

	@(link_name="SDL_ClearClipboardData")
	ClearClipboardData :: proc() -> cffi.bool ---

	@(link_name="SDL_GetClipboardData")
	GetClipboardData :: proc(mime_type: cstring, size: ^cffi.size_t) -> rawptr ---

	@(link_name="SDL_HasClipboardData")
	HasClipboardData :: proc(mime_type: cstring) -> cffi.bool ---

	@(link_name="SDL_GetClipboardMimeTypes")
	GetClipboardMimeTypes :: proc(num_mime_types: ^cffi.size_t) -> ^cstring ---

	@(link_name="SDL_GetNumLogicalCPUCores")
	GetNumLogicalCPUCores :: proc() -> cffi.int ---

	@(link_name="SDL_GetCPUCacheLineSize")
	GetCPUCacheLineSize :: proc() -> cffi.int ---

	@(link_name="SDL_HasAltiVec")
	HasAltiVec :: proc() -> cffi.bool ---

	@(link_name="SDL_HasMMX")
	HasMMX :: proc() -> cffi.bool ---

	@(link_name="SDL_HasSSE")
	HasSSE :: proc() -> cffi.bool ---

	@(link_name="SDL_HasSSE2")
	HasSSE2 :: proc() -> cffi.bool ---

	@(link_name="SDL_HasSSE3")
	HasSSE3 :: proc() -> cffi.bool ---

	@(link_name="SDL_HasSSE41")
	HasSSE41 :: proc() -> cffi.bool ---

	@(link_name="SDL_HasSSE42")
	HasSSE42 :: proc() -> cffi.bool ---

	@(link_name="SDL_HasAVX")
	HasAVX :: proc() -> cffi.bool ---

	@(link_name="SDL_HasAVX2")
	HasAVX2 :: proc() -> cffi.bool ---

	@(link_name="SDL_HasAVX512F")
	HasAVX512F :: proc() -> cffi.bool ---

	@(link_name="SDL_HasARMSIMD")
	HasARMSIMD :: proc() -> cffi.bool ---

	@(link_name="SDL_HasNEON")
	HasNEON :: proc() -> cffi.bool ---

	@(link_name="SDL_HasLSX")
	HasLSX :: proc() -> cffi.bool ---

	@(link_name="SDL_HasLASX")
	HasLASX :: proc() -> cffi.bool ---

	@(link_name="SDL_GetSystemRAM")
	GetSystemRAM :: proc() -> cffi.int ---

	@(link_name="SDL_GetSIMDAlignment")
	GetSIMDAlignment :: proc() -> cffi.size_t ---

	@(link_name="SDL_GetNumVideoDrivers")
	GetNumVideoDrivers :: proc() -> cffi.int ---

	@(link_name="SDL_GetVideoDriver")
	GetVideoDriver :: proc(index: cffi.int) -> cstring ---

	@(link_name="SDL_GetCurrentVideoDriver")
	GetCurrentVideoDriver :: proc() -> cstring ---

	@(link_name="SDL_GetSystemTheme")
	GetSystemTheme :: proc() -> SystemTheme ---

	@(link_name="SDL_GetDisplays")
	GetDisplays :: proc(count: ^cffi.int) -> ^DisplayID ---

	@(link_name="SDL_GetPrimaryDisplay")
	GetPrimaryDisplay :: proc() -> DisplayID ---

	@(link_name="SDL_GetDisplayProperties")
	GetDisplayProperties :: proc(displayID: DisplayID) -> PropertiesID ---

	@(link_name="SDL_GetDisplayName")
	GetDisplayName :: proc(displayID: DisplayID) -> cstring ---

	@(link_name="SDL_GetDisplayBounds")
	GetDisplayBounds :: proc(displayID: DisplayID, rect: ^Rect) -> cffi.bool ---

	@(link_name="SDL_GetDisplayUsableBounds")
	GetDisplayUsableBounds :: proc(displayID: DisplayID, rect: ^Rect) -> cffi.bool ---

	@(link_name="SDL_GetNaturalDisplayOrientation")
	GetNaturalDisplayOrientation :: proc(displayID: DisplayID) -> DisplayOrientation ---

	@(link_name="SDL_GetCurrentDisplayOrientation")
	GetCurrentDisplayOrientation :: proc(displayID: DisplayID) -> DisplayOrientation ---

	@(link_name="SDL_GetDisplayContentScale")
	GetDisplayContentScale :: proc(displayID: DisplayID) -> cffi.float ---

	@(link_name="SDL_GetFullscreenDisplayModes")
	GetFullscreenDisplayModes :: proc(displayID: DisplayID, count: ^cffi.int) -> ^^DisplayMode ---

	@(link_name="SDL_GetClosestFullscreenDisplayMode")
	GetClosestFullscreenDisplayMode :: proc(displayID: DisplayID, w: cffi.int, h: cffi.int, refresh_rate: cffi.float, include_high_density_modes: cffi.bool, closest: ^DisplayMode) -> cffi.bool ---

	@(link_name="SDL_GetDesktopDisplayMode")
	GetDesktopDisplayMode :: proc(displayID: DisplayID) -> ^DisplayMode ---

	@(link_name="SDL_GetCurrentDisplayMode")
	GetCurrentDisplayMode :: proc(displayID: DisplayID) -> ^DisplayMode ---

	@(link_name="SDL_GetDisplayForPoint")
	GetDisplayForPoint :: proc(point: ^Point) -> DisplayID ---

	@(link_name="SDL_GetDisplayForRect")
	GetDisplayForRect :: proc(rect: ^Rect) -> DisplayID ---

	@(link_name="SDL_GetDisplayForWindow")
	GetDisplayForWindow :: proc(window: ^Window) -> DisplayID ---

	@(link_name="SDL_GetWindowPixelDensity")
	GetWindowPixelDensity :: proc(window: ^Window) -> cffi.float ---

	@(link_name="SDL_GetWindowDisplayScale")
	GetWindowDisplayScale :: proc(window: ^Window) -> cffi.float ---

	@(link_name="SDL_SetWindowFullscreenMode")
	SetWindowFullscreenMode :: proc(window: ^Window, mode: ^DisplayMode) -> cffi.bool ---

	@(link_name="SDL_GetWindowFullscreenMode")
	GetWindowFullscreenMode :: proc(window: ^Window) -> ^DisplayMode ---

	@(link_name="SDL_GetWindowICCProfile")
	GetWindowICCProfile :: proc(window: ^Window, size: ^cffi.size_t) -> rawptr ---

	@(link_name="SDL_GetWindowPixelFormat")
	GetWindowPixelFormat :: proc(window: ^Window) -> PixelFormat ---

	@(link_name="SDL_GetWindows")
	GetWindows :: proc(count: ^cffi.int) -> ^^Window ---

	@(link_name="SDL_CreateWindow")
	CreateWindow :: proc(title: cstring, w: cffi.int, h: cffi.int, flags: WindowFlags) -> ^Window ---

	@(link_name="SDL_CreatePopupWindow")
	CreatePopupWindow :: proc(parent: ^Window, offset_x: cffi.int, offset_y: cffi.int, w: cffi.int, h: cffi.int, flags: WindowFlags) -> ^Window ---

	@(link_name="SDL_CreateWindowWithProperties")
	CreateWindowWithProperties :: proc(props: PropertiesID) -> ^Window ---

	@(link_name="SDL_GetWindowID")
	GetWindowID :: proc(window: ^Window) -> WindowID ---

	@(link_name="SDL_GetWindowFromID")
	GetWindowFromID :: proc(id: WindowID) -> ^Window ---

	@(link_name="SDL_GetWindowParent")
	GetWindowParent :: proc(window: ^Window) -> ^Window ---

	@(link_name="SDL_GetWindowProperties")
	GetWindowProperties :: proc(window: ^Window) -> PropertiesID ---

	@(link_name="SDL_GetWindowFlags")
	GetWindowFlags :: proc(window: ^Window) -> WindowFlags ---

	@(link_name="SDL_SetWindowTitle")
	SetWindowTitle :: proc(window: ^Window, title: cstring) -> cffi.bool ---

	@(link_name="SDL_GetWindowTitle")
	GetWindowTitle :: proc(window: ^Window) -> cstring ---

	@(link_name="SDL_SetWindowIcon")
	SetWindowIcon :: proc(window: ^Window, icon: ^Surface) -> cffi.bool ---

	@(link_name="SDL_SetWindowPosition")
	SetWindowPosition :: proc(window: ^Window, x: cffi.int, y: cffi.int) -> cffi.bool ---

	@(link_name="SDL_GetWindowPosition")
	GetWindowPosition :: proc(window: ^Window, x: ^cffi.int, y: ^cffi.int) -> cffi.bool ---

	@(link_name="SDL_SetWindowSize")
	SetWindowSize :: proc(window: ^Window, w: cffi.int, h: cffi.int) -> cffi.bool ---

	@(link_name="SDL_GetWindowSize")
	GetWindowSize :: proc(window: ^Window, w: ^cffi.int, h: ^cffi.int) -> cffi.bool ---

	@(link_name="SDL_GetWindowSafeArea")
	GetWindowSafeArea :: proc(window: ^Window, rect: ^Rect) -> cffi.bool ---

	@(link_name="SDL_SetWindowAspectRatio")
	SetWindowAspectRatio :: proc(window: ^Window, min_aspect: cffi.float, max_aspect: cffi.float) -> cffi.bool ---

	@(link_name="SDL_GetWindowAspectRatio")
	GetWindowAspectRatio :: proc(window: ^Window, min_aspect: ^cffi.float, max_aspect: ^cffi.float) -> cffi.bool ---

	@(link_name="SDL_GetWindowBordersSize")
	GetWindowBordersSize :: proc(window: ^Window, top: ^cffi.int, left: ^cffi.int, bottom: ^cffi.int, right: ^cffi.int) -> cffi.bool ---

	@(link_name="SDL_GetWindowSizeInPixels")
	GetWindowSizeInPixels :: proc(window: ^Window, w: ^cffi.int, h: ^cffi.int) -> cffi.bool ---

	@(link_name="SDL_SetWindowMinimumSize")
	SetWindowMinimumSize :: proc(window: ^Window, min_w: cffi.int, min_h: cffi.int) -> cffi.bool ---

	@(link_name="SDL_GetWindowMinimumSize")
	GetWindowMinimumSize :: proc(window: ^Window, w: ^cffi.int, h: ^cffi.int) -> cffi.bool ---

	@(link_name="SDL_SetWindowMaximumSize")
	SetWindowMaximumSize :: proc(window: ^Window, max_w: cffi.int, max_h: cffi.int) -> cffi.bool ---

	@(link_name="SDL_GetWindowMaximumSize")
	GetWindowMaximumSize :: proc(window: ^Window, w: ^cffi.int, h: ^cffi.int) -> cffi.bool ---

	@(link_name="SDL_SetWindowBordered")
	SetWindowBordered :: proc(window: ^Window, bordered: cffi.bool) -> cffi.bool ---

	@(link_name="SDL_SetWindowResizable")
	SetWindowResizable :: proc(window: ^Window, resizable: cffi.bool) -> cffi.bool ---

	@(link_name="SDL_SetWindowAlwaysOnTop")
	SetWindowAlwaysOnTop :: proc(window: ^Window, on_top: cffi.bool) -> cffi.bool ---

	@(link_name="SDL_ShowWindow")
	ShowWindow :: proc(window: ^Window) -> cffi.bool ---

	@(link_name="SDL_HideWindow")
	HideWindow :: proc(window: ^Window) -> cffi.bool ---

	@(link_name="SDL_RaiseWindow")
	RaiseWindow :: proc(window: ^Window) -> cffi.bool ---

	@(link_name="SDL_MaximizeWindow")
	MaximizeWindow :: proc(window: ^Window) -> cffi.bool ---

	@(link_name="SDL_MinimizeWindow")
	MinimizeWindow :: proc(window: ^Window) -> cffi.bool ---

	@(link_name="SDL_RestoreWindow")
	RestoreWindow :: proc(window: ^Window) -> cffi.bool ---

	@(link_name="SDL_SetWindowFullscreen")
	SetWindowFullscreen :: proc(window: ^Window, fullscreen: cffi.bool) -> cffi.bool ---

	@(link_name="SDL_SyncWindow")
	SyncWindow :: proc(window: ^Window) -> cffi.bool ---

	@(link_name="SDL_WindowHasSurface")
	WindowHasSurface :: proc(window: ^Window) -> cffi.bool ---

	@(link_name="SDL_GetWindowSurface")
	GetWindowSurface :: proc(window: ^Window) -> ^Surface ---

	@(link_name="SDL_SetWindowSurfaceVSync")
	SetWindowSurfaceVSync :: proc(window: ^Window, vsync: cffi.int) -> cffi.bool ---

	@(link_name="SDL_GetWindowSurfaceVSync")
	GetWindowSurfaceVSync :: proc(window: ^Window, vsync: ^cffi.int) -> cffi.bool ---

	@(link_name="SDL_UpdateWindowSurface")
	UpdateWindowSurface :: proc(window: ^Window) -> cffi.bool ---

	@(link_name="SDL_UpdateWindowSurfaceRects")
	UpdateWindowSurfaceRects :: proc(window: ^Window, rects: ^Rect, numrects: cffi.int) -> cffi.bool ---

	@(link_name="SDL_DestroyWindowSurface")
	DestroyWindowSurface :: proc(window: ^Window) -> cffi.bool ---

	@(link_name="SDL_SetWindowKeyboardGrab")
	SetWindowKeyboardGrab :: proc(window: ^Window, grabbed: cffi.bool) -> cffi.bool ---

	@(link_name="SDL_SetWindowMouseGrab")
	SetWindowMouseGrab :: proc(window: ^Window, grabbed: cffi.bool) -> cffi.bool ---

	@(link_name="SDL_GetWindowKeyboardGrab")
	GetWindowKeyboardGrab :: proc(window: ^Window) -> cffi.bool ---

	@(link_name="SDL_GetWindowMouseGrab")
	GetWindowMouseGrab :: proc(window: ^Window) -> cffi.bool ---

	@(link_name="SDL_GetGrabbedWindow")
	GetGrabbedWindow :: proc() -> ^Window ---

	@(link_name="SDL_SetWindowMouseRect")
	SetWindowMouseRect :: proc(window: ^Window, rect: ^Rect) -> cffi.bool ---

	@(link_name="SDL_GetWindowMouseRect")
	GetWindowMouseRect :: proc(window: ^Window) -> ^Rect ---

	@(link_name="SDL_SetWindowOpacity")
	SetWindowOpacity :: proc(window: ^Window, opacity: cffi.float) -> cffi.bool ---

	@(link_name="SDL_GetWindowOpacity")
	GetWindowOpacity :: proc(window: ^Window) -> cffi.float ---

	@(link_name="SDL_SetWindowParent")
	SetWindowParent :: proc(window: ^Window, parent: ^Window) -> cffi.bool ---

	@(link_name="SDL_SetWindowModal")
	SetWindowModal :: proc(window: ^Window, modal: cffi.bool) -> cffi.bool ---

	@(link_name="SDL_SetWindowFocusable")
	SetWindowFocusable :: proc(window: ^Window, focusable: cffi.bool) -> cffi.bool ---

	@(link_name="SDL_ShowWindowSystemMenu")
	ShowWindowSystemMenu :: proc(window: ^Window, x: cffi.int, y: cffi.int) -> cffi.bool ---

	@(link_name="SDL_SetWindowHitTest")
	SetWindowHitTest :: proc(window: ^Window, callback: HitTest, callback_data: rawptr) -> cffi.bool ---

	@(link_name="SDL_SetWindowShape")
	SetWindowShape :: proc(window: ^Window, shape: ^Surface) -> cffi.bool ---

	@(link_name="SDL_FlashWindow")
	FlashWindow :: proc(window: ^Window, operation: FlashOperation) -> cffi.bool ---

	@(link_name="SDL_DestroyWindow")
	DestroyWindow :: proc(window: ^Window) ---

	@(link_name="SDL_ScreenSaverEnabled")
	ScreenSaverEnabled :: proc() -> cffi.bool ---

	@(link_name="SDL_EnableScreenSaver")
	EnableScreenSaver :: proc() -> cffi.bool ---

	@(link_name="SDL_DisableScreenSaver")
	DisableScreenSaver :: proc() -> cffi.bool ---

	@(link_name="SDL_GL_LoadLibrary")
	GL_LoadLibrary :: proc(path: cstring) -> cffi.bool ---

	@(link_name="SDL_GL_GetProcAddress")
	GL_GetProcAddress :: proc(_proc: cstring) -> FunctionPointer ---

	@(link_name="SDL_EGL_GetProcAddress")
	EGL_GetProcAddress :: proc(_proc: cstring) -> FunctionPointer ---

	@(link_name="SDL_GL_UnloadLibrary")
	GL_UnloadLibrary :: proc() ---

	@(link_name="SDL_GL_ExtensionSupported")
	GL_ExtensionSupported :: proc(extension: cstring) -> cffi.bool ---

	@(link_name="SDL_GL_ResetAttributes")
	GL_ResetAttributes :: proc() ---

	@(link_name="SDL_GL_SetAttribute")
	GL_SetAttribute :: proc(attr: GLAttr, value: cffi.int) -> cffi.bool ---

	@(link_name="SDL_GL_GetAttribute")
	GL_GetAttribute :: proc(attr: GLAttr, value: ^cffi.int) -> cffi.bool ---

	@(link_name="SDL_GL_CreateContext")
	GL_CreateContext :: proc(window: ^Window) -> GLContext ---

	@(link_name="SDL_GL_MakeCurrent")
	GL_MakeCurrent :: proc(window: ^Window, _context: GLContext) -> cffi.bool ---

	@(link_name="SDL_GL_GetCurrentWindow")
	GL_GetCurrentWindow :: proc() -> ^Window ---

	@(link_name="SDL_GL_GetCurrentContext")
	GL_GetCurrentContext :: proc() -> GLContext ---

	@(link_name="SDL_EGL_GetCurrentDisplay")
	EGL_GetCurrentDisplay :: proc() -> EGLDisplay ---

	@(link_name="SDL_EGL_GetCurrentConfig")
	EGL_GetCurrentConfig :: proc() -> EGLConfig ---

	@(link_name="SDL_EGL_GetWindowSurface")
	EGL_GetWindowSurface :: proc(window: ^Window) -> EGLSurface ---

	@(link_name="SDL_EGL_SetAttributeCallbacks")
	EGL_SetAttributeCallbacks :: proc(platformAttribCallback: EGLAttribArrayCallback, surfaceAttribCallback: EGLIntArrayCallback, contextAttribCallback: EGLIntArrayCallback, userdata: rawptr) ---

	@(link_name="SDL_GL_SetSwapInterval")
	GL_SetSwapInterval :: proc(interval: cffi.int) -> cffi.bool ---

	@(link_name="SDL_GL_GetSwapInterval")
	GL_GetSwapInterval :: proc(interval: ^cffi.int) -> cffi.bool ---

	@(link_name="SDL_GL_SwapWindow")
	GL_SwapWindow :: proc(window: ^Window) -> cffi.bool ---

	@(link_name="SDL_GL_DestroyContext")
	GL_DestroyContext :: proc(_context: GLContext) -> cffi.bool ---

	@(link_name="SDL_ShowOpenFileDialog")
	ShowOpenFileDialog :: proc(callback: DialogFileCallback, userdata: rawptr, window: ^Window, filters: ^DialogFileFilter, nfilters: cffi.int, default_location: cstring, allow_many: cffi.bool) ---

	@(link_name="SDL_ShowSaveFileDialog")
	ShowSaveFileDialog :: proc(callback: DialogFileCallback, userdata: rawptr, window: ^Window, filters: ^DialogFileFilter, nfilters: cffi.int, default_location: cstring) ---

	@(link_name="SDL_ShowOpenFolderDialog")
	ShowOpenFolderDialog :: proc(callback: DialogFileCallback, userdata: rawptr, window: ^Window, default_location: cstring, allow_many: cffi.bool) ---

	@(link_name="SDL_GUIDToString")
	GUIDToString :: proc(guid: GUID, pszGUID: cstring, cbGUID: cffi.int) ---

	@(link_name="SDL_StringToGUID")
	StringToGUID :: proc(pchGUID: cstring) -> GUID ---

	@(link_name="SDL_GetPowerInfo")
	GetPowerInfo :: proc(seconds: ^cffi.int, percent: ^cffi.int) -> PowerState ---

	@(link_name="SDL_GetSensors")
	GetSensors :: proc(count: ^cffi.int) -> ^SensorID ---

	@(link_name="SDL_GetSensorNameForID")
	GetSensorNameForID :: proc(instance_id: SensorID) -> cstring ---

	@(link_name="SDL_GetSensorTypeForID")
	GetSensorTypeForID :: proc(instance_id: SensorID) -> SensorType ---

	@(link_name="SDL_GetSensorNonPortableTypeForID")
	GetSensorNonPortableTypeForID :: proc(instance_id: SensorID) -> cffi.int ---

	@(link_name="SDL_OpenSensor")
	OpenSensor :: proc(instance_id: SensorID) -> ^Sensor ---

	@(link_name="SDL_GetSensorFromID")
	GetSensorFromID :: proc(instance_id: SensorID) -> ^Sensor ---

	@(link_name="SDL_GetSensorProperties")
	GetSensorProperties :: proc(sensor: ^Sensor) -> PropertiesID ---

	@(link_name="SDL_GetSensorName")
	GetSensorName :: proc(sensor: ^Sensor) -> cstring ---

	@(link_name="SDL_GetSensorType")
	GetSensorType :: proc(sensor: ^Sensor) -> SensorType ---

	@(link_name="SDL_GetSensorNonPortableType")
	GetSensorNonPortableType :: proc(sensor: ^Sensor) -> cffi.int ---

	@(link_name="SDL_GetSensorID")
	GetSensorID :: proc(sensor: ^Sensor) -> SensorID ---

	@(link_name="SDL_GetSensorData")
	GetSensorData :: proc(sensor: ^Sensor, data: ^cffi.float, num_values: cffi.int) -> cffi.bool ---

	@(link_name="SDL_CloseSensor")
	CloseSensor :: proc(sensor: ^Sensor) ---

	@(link_name="SDL_UpdateSensors")
	UpdateSensors :: proc() ---

	@(link_name="SDL_LockJoysticks")
	LockJoysticks :: proc() ---

	@(link_name="SDL_UnlockJoysticks")
	UnlockJoysticks :: proc() ---

	@(link_name="SDL_HasJoystick")
	HasJoystick :: proc() -> cffi.bool ---

	@(link_name="SDL_GetJoysticks")
	GetJoysticks :: proc(count: ^cffi.int) -> ^JoystickID ---

	@(link_name="SDL_GetJoystickNameForID")
	GetJoystickNameForID :: proc(instance_id: JoystickID) -> cstring ---

	@(link_name="SDL_GetJoystickPathForID")
	GetJoystickPathForID :: proc(instance_id: JoystickID) -> cstring ---

	@(link_name="SDL_GetJoystickPlayerIndexForID")
	GetJoystickPlayerIndexForID :: proc(instance_id: JoystickID) -> cffi.int ---

	@(link_name="SDL_GetJoystickGUIDForID")
	GetJoystickGUIDForID :: proc(instance_id: JoystickID) -> GUID ---

	@(link_name="SDL_GetJoystickVendorForID")
	GetJoystickVendorForID :: proc(instance_id: JoystickID) -> Uint16 ---

	@(link_name="SDL_GetJoystickProductForID")
	GetJoystickProductForID :: proc(instance_id: JoystickID) -> Uint16 ---

	@(link_name="SDL_GetJoystickProductVersionForID")
	GetJoystickProductVersionForID :: proc(instance_id: JoystickID) -> Uint16 ---

	@(link_name="SDL_GetJoystickTypeForID")
	GetJoystickTypeForID :: proc(instance_id: JoystickID) -> JoystickType ---

	@(link_name="SDL_OpenJoystick")
	OpenJoystick :: proc(instance_id: JoystickID) -> ^Joystick ---

	@(link_name="SDL_GetJoystickFromID")
	GetJoystickFromID :: proc(instance_id: JoystickID) -> ^Joystick ---

	@(link_name="SDL_GetJoystickFromPlayerIndex")
	GetJoystickFromPlayerIndex :: proc(player_index: cffi.int) -> ^Joystick ---

	@(link_name="SDL_AttachVirtualJoystick")
	AttachVirtualJoystick :: proc(desc: ^VirtualJoystickDesc) -> JoystickID ---

	@(link_name="SDL_DetachVirtualJoystick")
	DetachVirtualJoystick :: proc(instance_id: JoystickID) -> cffi.bool ---

	@(link_name="SDL_IsJoystickVirtual")
	IsJoystickVirtual :: proc(instance_id: JoystickID) -> cffi.bool ---

	@(link_name="SDL_SetJoystickVirtualAxis")
	SetJoystickVirtualAxis :: proc(joystick: ^Joystick, axis: cffi.int, value: Sint16) -> cffi.bool ---

	@(link_name="SDL_SetJoystickVirtualBall")
	SetJoystickVirtualBall :: proc(joystick: ^Joystick, ball: cffi.int, xrel: Sint16, yrel: Sint16) -> cffi.bool ---

	@(link_name="SDL_SetJoystickVirtualButton")
	SetJoystickVirtualButton :: proc(joystick: ^Joystick, button: cffi.int, down: cffi.bool) -> cffi.bool ---

	@(link_name="SDL_SetJoystickVirtualHat")
	SetJoystickVirtualHat :: proc(joystick: ^Joystick, hat: cffi.int, value: Uint8) -> cffi.bool ---

	@(link_name="SDL_SetJoystickVirtualTouchpad")
	SetJoystickVirtualTouchpad :: proc(joystick: ^Joystick, touchpad: cffi.int, finger: cffi.int, down: cffi.bool, x: cffi.float, y: cffi.float, pressure: cffi.float) -> cffi.bool ---

	@(link_name="SDL_SendJoystickVirtualSensorData")
	SendJoystickVirtualSensorData :: proc(joystick: ^Joystick, type: SensorType, sensor_timestamp: Uint64, data: ^cffi.float, num_values: cffi.int) -> cffi.bool ---

	@(link_name="SDL_GetJoystickProperties")
	GetJoystickProperties :: proc(joystick: ^Joystick) -> PropertiesID ---

	@(link_name="SDL_GetJoystickName")
	GetJoystickName :: proc(joystick: ^Joystick) -> cstring ---

	@(link_name="SDL_GetJoystickPath")
	GetJoystickPath :: proc(joystick: ^Joystick) -> cstring ---

	@(link_name="SDL_GetJoystickPlayerIndex")
	GetJoystickPlayerIndex :: proc(joystick: ^Joystick) -> cffi.int ---

	@(link_name="SDL_SetJoystickPlayerIndex")
	SetJoystickPlayerIndex :: proc(joystick: ^Joystick, player_index: cffi.int) -> cffi.bool ---

	@(link_name="SDL_GetJoystickGUID")
	GetJoystickGUID :: proc(joystick: ^Joystick) -> GUID ---

	@(link_name="SDL_GetJoystickVendor")
	GetJoystickVendor :: proc(joystick: ^Joystick) -> Uint16 ---

	@(link_name="SDL_GetJoystickProduct")
	GetJoystickProduct :: proc(joystick: ^Joystick) -> Uint16 ---

	@(link_name="SDL_GetJoystickProductVersion")
	GetJoystickProductVersion :: proc(joystick: ^Joystick) -> Uint16 ---

	@(link_name="SDL_GetJoystickFirmwareVersion")
	GetJoystickFirmwareVersion :: proc(joystick: ^Joystick) -> Uint16 ---

	@(link_name="SDL_GetJoystickSerial")
	GetJoystickSerial :: proc(joystick: ^Joystick) -> cstring ---

	@(link_name="SDL_GetJoystickType")
	GetJoystickType :: proc(joystick: ^Joystick) -> JoystickType ---

	@(link_name="SDL_GetJoystickGUIDInfo")
	GetJoystickGUIDInfo :: proc(guid: GUID, vendor: ^Uint16, product: ^Uint16, version: ^Uint16, crc16: ^Uint16) ---

	@(link_name="SDL_JoystickConnected")
	JoystickConnected :: proc(joystick: ^Joystick) -> cffi.bool ---

	@(link_name="SDL_GetJoystickID")
	GetJoystickID :: proc(joystick: ^Joystick) -> JoystickID ---

	@(link_name="SDL_GetNumJoystickAxes")
	GetNumJoystickAxes :: proc(joystick: ^Joystick) -> cffi.int ---

	@(link_name="SDL_GetNumJoystickBalls")
	GetNumJoystickBalls :: proc(joystick: ^Joystick) -> cffi.int ---

	@(link_name="SDL_GetNumJoystickHats")
	GetNumJoystickHats :: proc(joystick: ^Joystick) -> cffi.int ---

	@(link_name="SDL_GetNumJoystickButtons")
	GetNumJoystickButtons :: proc(joystick: ^Joystick) -> cffi.int ---

	@(link_name="SDL_SetJoystickEventsEnabled")
	SetJoystickEventsEnabled :: proc(enabled: cffi.bool) ---

	@(link_name="SDL_JoystickEventsEnabled")
	JoystickEventsEnabled :: proc() -> cffi.bool ---

	@(link_name="SDL_UpdateJoysticks")
	UpdateJoysticks :: proc() ---

	@(link_name="SDL_GetJoystickAxis")
	GetJoystickAxis :: proc(joystick: ^Joystick, axis: cffi.int) -> Sint16 ---

	@(link_name="SDL_GetJoystickAxisInitialState")
	GetJoystickAxisInitialState :: proc(joystick: ^Joystick, axis: cffi.int, state: ^Sint16) -> cffi.bool ---

	@(link_name="SDL_GetJoystickBall")
	GetJoystickBall :: proc(joystick: ^Joystick, ball: cffi.int, dx: ^cffi.int, dy: ^cffi.int) -> cffi.bool ---

	@(link_name="SDL_GetJoystickHat")
	GetJoystickHat :: proc(joystick: ^Joystick, hat: cffi.int) -> Uint8 ---

	@(link_name="SDL_GetJoystickButton")
	GetJoystickButton :: proc(joystick: ^Joystick, button: cffi.int) -> cffi.bool ---

	@(link_name="SDL_RumbleJoystick")
	RumbleJoystick :: proc(joystick: ^Joystick, low_frequency_rumble: Uint16, high_frequency_rumble: Uint16, duration_ms: Uint32) -> cffi.bool ---

	@(link_name="SDL_RumbleJoystickTriggers")
	RumbleJoystickTriggers :: proc(joystick: ^Joystick, left_rumble: Uint16, right_rumble: Uint16, duration_ms: Uint32) -> cffi.bool ---

	@(link_name="SDL_SetJoystickLED")
	SetJoystickLED :: proc(joystick: ^Joystick, red: Uint8, green: Uint8, blue: Uint8) -> cffi.bool ---

	@(link_name="SDL_SendJoystickEffect")
	SendJoystickEffect :: proc(joystick: ^Joystick, data: rawptr, size: cffi.int) -> cffi.bool ---

	@(link_name="SDL_CloseJoystick")
	CloseJoystick :: proc(joystick: ^Joystick) ---

	@(link_name="SDL_GetJoystickConnectionState")
	GetJoystickConnectionState :: proc(joystick: ^Joystick) -> JoystickConnectionState ---

	@(link_name="SDL_GetJoystickPowerInfo")
	GetJoystickPowerInfo :: proc(joystick: ^Joystick, percent: ^cffi.int) -> PowerState ---

	@(link_name="SDL_AddGamepadMapping")
	AddGamepadMapping :: proc(mapping: cstring) -> cffi.int ---

	@(link_name="SDL_AddGamepadMappingsFromIO")
	AddGamepadMappingsFromIO :: proc(src: ^IOStream, closeio: cffi.bool) -> cffi.int ---

	@(link_name="SDL_AddGamepadMappingsFromFile")
	AddGamepadMappingsFromFile :: proc(file: cstring) -> cffi.int ---

	@(link_name="SDL_ReloadGamepadMappings")
	ReloadGamepadMappings :: proc() -> cffi.bool ---

	@(link_name="SDL_GetGamepadMappings")
	GetGamepadMappings :: proc(count: ^cffi.int) -> ^cstring ---

	@(link_name="SDL_GetGamepadMappingForGUID")
	GetGamepadMappingForGUID :: proc(guid: GUID) -> cstring ---

	@(link_name="SDL_GetGamepadMapping")
	GetGamepadMapping :: proc(gamepad: ^Gamepad) -> cstring ---

	@(link_name="SDL_SetGamepadMapping")
	SetGamepadMapping :: proc(instance_id: JoystickID, mapping: cstring) -> cffi.bool ---

	@(link_name="SDL_HasGamepad")
	HasGamepad :: proc() -> cffi.bool ---

	@(link_name="SDL_GetGamepads")
	GetGamepads :: proc(count: ^cffi.int) -> ^JoystickID ---

	@(link_name="SDL_IsGamepad")
	IsGamepad :: proc(instance_id: JoystickID) -> cffi.bool ---

	@(link_name="SDL_GetGamepadNameForID")
	GetGamepadNameForID :: proc(instance_id: JoystickID) -> cstring ---

	@(link_name="SDL_GetGamepadPathForID")
	GetGamepadPathForID :: proc(instance_id: JoystickID) -> cstring ---

	@(link_name="SDL_GetGamepadPlayerIndexForID")
	GetGamepadPlayerIndexForID :: proc(instance_id: JoystickID) -> cffi.int ---

	@(link_name="SDL_GetGamepadGUIDForID")
	GetGamepadGUIDForID :: proc(instance_id: JoystickID) -> GUID ---

	@(link_name="SDL_GetGamepadVendorForID")
	GetGamepadVendorForID :: proc(instance_id: JoystickID) -> Uint16 ---

	@(link_name="SDL_GetGamepadProductForID")
	GetGamepadProductForID :: proc(instance_id: JoystickID) -> Uint16 ---

	@(link_name="SDL_GetGamepadProductVersionForID")
	GetGamepadProductVersionForID :: proc(instance_id: JoystickID) -> Uint16 ---

	@(link_name="SDL_GetGamepadTypeForID")
	GetGamepadTypeForID :: proc(instance_id: JoystickID) -> GamepadType ---

	@(link_name="SDL_GetRealGamepadTypeForID")
	GetRealGamepadTypeForID :: proc(instance_id: JoystickID) -> GamepadType ---

	@(link_name="SDL_GetGamepadMappingForID")
	GetGamepadMappingForID :: proc(instance_id: JoystickID) -> cstring ---

	@(link_name="SDL_OpenGamepad")
	OpenGamepad :: proc(instance_id: JoystickID) -> ^Gamepad ---

	@(link_name="SDL_GetGamepadFromID")
	GetGamepadFromID :: proc(instance_id: JoystickID) -> ^Gamepad ---

	@(link_name="SDL_GetGamepadFromPlayerIndex")
	GetGamepadFromPlayerIndex :: proc(player_index: cffi.int) -> ^Gamepad ---

	@(link_name="SDL_GetGamepadProperties")
	GetGamepadProperties :: proc(gamepad: ^Gamepad) -> PropertiesID ---

	@(link_name="SDL_GetGamepadID")
	GetGamepadID :: proc(gamepad: ^Gamepad) -> JoystickID ---

	@(link_name="SDL_GetGamepadName")
	GetGamepadName :: proc(gamepad: ^Gamepad) -> cstring ---

	@(link_name="SDL_GetGamepadPath")
	GetGamepadPath :: proc(gamepad: ^Gamepad) -> cstring ---

	@(link_name="SDL_GetGamepadType")
	GetGamepadType :: proc(gamepad: ^Gamepad) -> GamepadType ---

	@(link_name="SDL_GetRealGamepadType")
	GetRealGamepadType :: proc(gamepad: ^Gamepad) -> GamepadType ---

	@(link_name="SDL_GetGamepadPlayerIndex")
	GetGamepadPlayerIndex :: proc(gamepad: ^Gamepad) -> cffi.int ---

	@(link_name="SDL_SetGamepadPlayerIndex")
	SetGamepadPlayerIndex :: proc(gamepad: ^Gamepad, player_index: cffi.int) -> cffi.bool ---

	@(link_name="SDL_GetGamepadVendor")
	GetGamepadVendor :: proc(gamepad: ^Gamepad) -> Uint16 ---

	@(link_name="SDL_GetGamepadProduct")
	GetGamepadProduct :: proc(gamepad: ^Gamepad) -> Uint16 ---

	@(link_name="SDL_GetGamepadProductVersion")
	GetGamepadProductVersion :: proc(gamepad: ^Gamepad) -> Uint16 ---

	@(link_name="SDL_GetGamepadFirmwareVersion")
	GetGamepadFirmwareVersion :: proc(gamepad: ^Gamepad) -> Uint16 ---

	@(link_name="SDL_GetGamepadSerial")
	GetGamepadSerial :: proc(gamepad: ^Gamepad) -> cstring ---

	@(link_name="SDL_GetGamepadSteamHandle")
	GetGamepadSteamHandle :: proc(gamepad: ^Gamepad) -> Uint64 ---

	@(link_name="SDL_GetGamepadConnectionState")
	GetGamepadConnectionState :: proc(gamepad: ^Gamepad) -> JoystickConnectionState ---

	@(link_name="SDL_GetGamepadPowerInfo")
	GetGamepadPowerInfo :: proc(gamepad: ^Gamepad, percent: ^cffi.int) -> PowerState ---

	@(link_name="SDL_GamepadConnected")
	GamepadConnected :: proc(gamepad: ^Gamepad) -> cffi.bool ---

	@(link_name="SDL_GetGamepadJoystick")
	GetGamepadJoystick :: proc(gamepad: ^Gamepad) -> ^Joystick ---

	@(link_name="SDL_SetGamepadEventsEnabled")
	SetGamepadEventsEnabled :: proc(enabled: cffi.bool) ---

	@(link_name="SDL_GamepadEventsEnabled")
	GamepadEventsEnabled :: proc() -> cffi.bool ---

	@(link_name="SDL_GetGamepadBindings")
	GetGamepadBindings :: proc(gamepad: ^Gamepad, count: ^cffi.int) -> ^^GamepadBinding ---

	@(link_name="SDL_UpdateGamepads")
	UpdateGamepads :: proc() ---

	@(link_name="SDL_GetGamepadTypeFromString")
	GetGamepadTypeFromString :: proc(str: cstring) -> GamepadType ---

	@(link_name="SDL_GetGamepadStringForType")
	GetGamepadStringForType :: proc(type: GamepadType) -> cstring ---

	@(link_name="SDL_GetGamepadAxisFromString")
	GetGamepadAxisFromString :: proc(str: cstring) -> GamepadAxis ---

	@(link_name="SDL_GetGamepadStringForAxis")
	GetGamepadStringForAxis :: proc(axis: GamepadAxis) -> cstring ---

	@(link_name="SDL_GamepadHasAxis")
	GamepadHasAxis :: proc(gamepad: ^Gamepad, axis: GamepadAxis) -> cffi.bool ---

	@(link_name="SDL_GetGamepadAxis")
	GetGamepadAxis :: proc(gamepad: ^Gamepad, axis: GamepadAxis) -> Sint16 ---

	@(link_name="SDL_GetGamepadButtonFromString")
	GetGamepadButtonFromString :: proc(str: cstring) -> GamepadButton ---

	@(link_name="SDL_GetGamepadStringForButton")
	GetGamepadStringForButton :: proc(button: GamepadButton) -> cstring ---

	@(link_name="SDL_GamepadHasButton")
	GamepadHasButton :: proc(gamepad: ^Gamepad, button: GamepadButton) -> cffi.bool ---

	@(link_name="SDL_GetGamepadButton")
	GetGamepadButton :: proc(gamepad: ^Gamepad, button: GamepadButton) -> cffi.bool ---

	@(link_name="SDL_GetGamepadButtonLabelForType")
	GetGamepadButtonLabelForType :: proc(type: GamepadType, button: GamepadButton) -> GamepadButtonLabel ---

	@(link_name="SDL_GetGamepadButtonLabel")
	GetGamepadButtonLabel :: proc(gamepad: ^Gamepad, button: GamepadButton) -> GamepadButtonLabel ---

	@(link_name="SDL_GetNumGamepadTouchpads")
	GetNumGamepadTouchpads :: proc(gamepad: ^Gamepad) -> cffi.int ---

	@(link_name="SDL_GetNumGamepadTouchpadFingers")
	GetNumGamepadTouchpadFingers :: proc(gamepad: ^Gamepad, touchpad: cffi.int) -> cffi.int ---

	@(link_name="SDL_GetGamepadTouchpadFinger")
	GetGamepadTouchpadFinger :: proc(gamepad: ^Gamepad, touchpad: cffi.int, finger: cffi.int, down: ^cffi.bool, x: ^cffi.float, y: ^cffi.float, pressure: ^cffi.float) -> cffi.bool ---

	@(link_name="SDL_GamepadHasSensor")
	GamepadHasSensor :: proc(gamepad: ^Gamepad, type: SensorType) -> cffi.bool ---

	@(link_name="SDL_SetGamepadSensorEnabled")
	SetGamepadSensorEnabled :: proc(gamepad: ^Gamepad, type: SensorType, enabled: cffi.bool) -> cffi.bool ---

	@(link_name="SDL_GamepadSensorEnabled")
	GamepadSensorEnabled :: proc(gamepad: ^Gamepad, type: SensorType) -> cffi.bool ---

	@(link_name="SDL_GetGamepadSensorDataRate")
	GetGamepadSensorDataRate :: proc(gamepad: ^Gamepad, type: SensorType) -> cffi.float ---

	@(link_name="SDL_GetGamepadSensorData")
	GetGamepadSensorData :: proc(gamepad: ^Gamepad, type: SensorType, data: ^cffi.float, num_values: cffi.int) -> cffi.bool ---

	@(link_name="SDL_RumbleGamepad")
	RumbleGamepad :: proc(gamepad: ^Gamepad, low_frequency_rumble: Uint16, high_frequency_rumble: Uint16, duration_ms: Uint32) -> cffi.bool ---

	@(link_name="SDL_RumbleGamepadTriggers")
	RumbleGamepadTriggers :: proc(gamepad: ^Gamepad, left_rumble: Uint16, right_rumble: Uint16, duration_ms: Uint32) -> cffi.bool ---

	@(link_name="SDL_SetGamepadLED")
	SetGamepadLED :: proc(gamepad: ^Gamepad, red: Uint8, green: Uint8, blue: Uint8) -> cffi.bool ---

	@(link_name="SDL_SendGamepadEffect")
	SendGamepadEffect :: proc(gamepad: ^Gamepad, data: rawptr, size: cffi.int) -> cffi.bool ---

	@(link_name="SDL_CloseGamepad")
	CloseGamepad :: proc(gamepad: ^Gamepad) ---

	@(link_name="SDL_GetGamepadAppleSFSymbolsNameForButton")
	GetGamepadAppleSFSymbolsNameForButton :: proc(gamepad: ^Gamepad, button: GamepadButton) -> cstring ---

	@(link_name="SDL_GetGamepadAppleSFSymbolsNameForAxis")
	GetGamepadAppleSFSymbolsNameForAxis :: proc(gamepad: ^Gamepad, axis: GamepadAxis) -> cstring ---

	@(link_name="SDL_HasKeyboard")
	HasKeyboard :: proc() -> cffi.bool ---

	@(link_name="SDL_GetKeyboards")
	GetKeyboards :: proc(count: ^cffi.int) -> ^KeyboardID ---

	@(link_name="SDL_GetKeyboardNameForID")
	GetKeyboardNameForID :: proc(instance_id: KeyboardID) -> cstring ---

	@(link_name="SDL_GetKeyboardFocus")
	GetKeyboardFocus :: proc() -> ^Window ---

	@(link_name="SDL_GetKeyboardState")
	GetKeyboardState :: proc(numkeys: ^cffi.int) -> ^cffi.bool ---

	@(link_name="SDL_ResetKeyboard")
	ResetKeyboard :: proc() ---

	@(link_name="SDL_GetModState")
	GetModState :: proc() -> Keymod ---

	@(link_name="SDL_SetModState")
	SetModState :: proc(modstate: Keymod) ---

	@(link_name="SDL_GetKeyFromScancode")
	GetKeyFromScancode :: proc(scancode: Scancode, modstate: Keymod, key_event: cffi.bool) -> Keycode ---

	@(link_name="SDL_GetScancodeFromKey")
	GetScancodeFromKey :: proc(key: Keycode, modstate: ^Keymod) -> Scancode ---

	@(link_name="SDL_SetScancodeName")
	SetScancodeName :: proc(scancode: Scancode, name: cstring) -> cffi.bool ---

	@(link_name="SDL_GetScancodeName")
	GetScancodeName :: proc(scancode: Scancode) -> cstring ---

	@(link_name="SDL_GetScancodeFromName")
	GetScancodeFromName :: proc(name: cstring) -> Scancode ---

	@(link_name="SDL_GetKeyName")
	GetKeyName :: proc(key: Keycode) -> cstring ---

	@(link_name="SDL_GetKeyFromName")
	GetKeyFromName :: proc(name: cstring) -> Keycode ---

	@(link_name="SDL_StartTextInput")
	StartTextInput :: proc(window: ^Window) -> cffi.bool ---

	@(link_name="SDL_StartTextInputWithProperties")
	StartTextInputWithProperties :: proc(window: ^Window, props: PropertiesID) -> cffi.bool ---

	@(link_name="SDL_TextInputActive")
	TextInputActive :: proc(window: ^Window) -> cffi.bool ---

	@(link_name="SDL_StopTextInput")
	StopTextInput :: proc(window: ^Window) -> cffi.bool ---

	@(link_name="SDL_ClearComposition")
	ClearComposition :: proc(window: ^Window) -> cffi.bool ---

	@(link_name="SDL_SetTextInputArea")
	SetTextInputArea :: proc(window: ^Window, rect: ^Rect, cursor: cffi.int) -> cffi.bool ---

	@(link_name="SDL_GetTextInputArea")
	GetTextInputArea :: proc(window: ^Window, rect: ^Rect, cursor: ^cffi.int) -> cffi.bool ---

	@(link_name="SDL_HasScreenKeyboardSupport")
	HasScreenKeyboardSupport :: proc() -> cffi.bool ---

	@(link_name="SDL_ScreenKeyboardShown")
	ScreenKeyboardShown :: proc(window: ^Window) -> cffi.bool ---

	@(link_name="SDL_HasMouse")
	HasMouse :: proc() -> cffi.bool ---

	@(link_name="SDL_GetMice")
	GetMice :: proc(count: ^cffi.int) -> ^MouseID ---

	@(link_name="SDL_GetMouseNameForID")
	GetMouseNameForID :: proc(instance_id: MouseID) -> cstring ---

	@(link_name="SDL_GetMouseFocus")
	GetMouseFocus :: proc() -> ^Window ---

	@(link_name="SDL_GetMouseState")
	GetMouseState :: proc(x: ^cffi.float, y: ^cffi.float) -> MouseButtonFlags ---

	@(link_name="SDL_GetGlobalMouseState")
	GetGlobalMouseState :: proc(x: ^cffi.float, y: ^cffi.float) -> MouseButtonFlags ---

	@(link_name="SDL_GetRelativeMouseState")
	GetRelativeMouseState :: proc(x: ^cffi.float, y: ^cffi.float) -> MouseButtonFlags ---

	@(link_name="SDL_WarpMouseInWindow")
	WarpMouseInWindow :: proc(window: ^Window, x: cffi.float, y: cffi.float) ---

	@(link_name="SDL_WarpMouseGlobal")
	WarpMouseGlobal :: proc(x: cffi.float, y: cffi.float) -> cffi.bool ---

	@(link_name="SDL_SetWindowRelativeMouseMode")
	SetWindowRelativeMouseMode :: proc(window: ^Window, enabled: cffi.bool) -> cffi.bool ---

	@(link_name="SDL_GetWindowRelativeMouseMode")
	GetWindowRelativeMouseMode :: proc(window: ^Window) -> cffi.bool ---

	@(link_name="SDL_CaptureMouse")
	CaptureMouse :: proc(enabled: cffi.bool) -> cffi.bool ---

	@(link_name="SDL_CreateCursor")
	CreateCursor :: proc(data: ^Uint8, mask: ^Uint8, w: cffi.int, h: cffi.int, hot_x: cffi.int, hot_y: cffi.int) -> ^Cursor ---

	@(link_name="SDL_CreateColorCursor")
	CreateColorCursor :: proc(surface: ^Surface, hot_x: cffi.int, hot_y: cffi.int) -> ^Cursor ---

	@(link_name="SDL_CreateSystemCursor")
	CreateSystemCursor :: proc(id: SystemCursor) -> ^Cursor ---

	@(link_name="SDL_SetCursor")
	SetCursor :: proc(cursor: ^Cursor) -> cffi.bool ---

	@(link_name="SDL_GetCursor")
	GetCursor :: proc() -> ^Cursor ---

	@(link_name="SDL_GetDefaultCursor")
	GetDefaultCursor :: proc() -> ^Cursor ---

	@(link_name="SDL_DestroyCursor")
	DestroyCursor :: proc(cursor: ^Cursor) ---

	@(link_name="SDL_ShowCursor")
	ShowCursor :: proc() -> cffi.bool ---

	@(link_name="SDL_HideCursor")
	HideCursor :: proc() -> cffi.bool ---

	@(link_name="SDL_CursorVisible")
	CursorVisible :: proc() -> cffi.bool ---

	@(link_name="SDL_GetTouchDevices")
	GetTouchDevices :: proc(count: ^cffi.int) -> ^TouchID ---

	@(link_name="SDL_GetTouchDeviceName")
	GetTouchDeviceName :: proc(touchID: TouchID) -> cstring ---

	@(link_name="SDL_GetTouchDeviceType")
	GetTouchDeviceType :: proc(touchID: TouchID) -> TouchDeviceType ---

	@(link_name="SDL_GetTouchFingers")
	GetTouchFingers :: proc(touchID: TouchID, count: ^cffi.int) -> ^^Finger ---

	@(link_name="SDL_PumpEvents")
	PumpEvents :: proc() ---

	@(link_name="SDL_PeepEvents")
	PeepEvents :: proc(events: ^Event, numevents: cffi.int, action: EventAction, minType: Uint32, maxType: Uint32) -> cffi.int ---

	@(link_name="SDL_HasEvent")
	HasEvent :: proc(type: Uint32) -> cffi.bool ---

	@(link_name="SDL_HasEvents")
	HasEvents :: proc(minType: Uint32, maxType: Uint32) -> cffi.bool ---

	@(link_name="SDL_FlushEvent")
	FlushEvent :: proc(type: Uint32) ---

	@(link_name="SDL_FlushEvents")
	FlushEvents :: proc(minType: Uint32, maxType: Uint32) ---

	@(link_name="SDL_PollEvent")
	PollEvent :: proc(event: ^Event) -> cffi.bool ---

	@(link_name="SDL_WaitEvent")
	WaitEvent :: proc(event: ^Event) -> cffi.bool ---

	@(link_name="SDL_WaitEventTimeout")
	WaitEventTimeout :: proc(event: ^Event, timeoutMS: Sint32) -> cffi.bool ---

	@(link_name="SDL_PushEvent")
	PushEvent :: proc(event: ^Event) -> cffi.bool ---

	@(link_name="SDL_SetEventFilter")
	SetEventFilter :: proc(filter: EventFilter, userdata: rawptr) ---

	@(link_name="SDL_GetEventFilter")
	GetEventFilter :: proc(filter: EventFilter, userdata: ^rawptr) -> cffi.bool ---

	@(link_name="SDL_AddEventWatch")
	AddEventWatch :: proc(filter: EventFilter, userdata: rawptr) -> cffi.bool ---

	@(link_name="SDL_RemoveEventWatch")
	RemoveEventWatch :: proc(filter: EventFilter, userdata: rawptr) ---

	@(link_name="SDL_FilterEvents")
	FilterEvents :: proc(filter: EventFilter, userdata: rawptr) ---

	@(link_name="SDL_SetEventEnabled")
	SetEventEnabled :: proc(type: Uint32, enabled: cffi.bool) ---

	@(link_name="SDL_EventEnabled")
	EventEnabled :: proc(type: Uint32) -> cffi.bool ---

	@(link_name="SDL_RegisterEvents")
	RegisterEvents :: proc(numevents: cffi.int) -> Uint32 ---

	@(link_name="SDL_GetWindowFromEvent")
	GetWindowFromEvent :: proc(event: ^Event) -> ^Window ---

	@(link_name="SDL_GetBasePath")
	GetBasePath :: proc() -> cstring ---

	@(link_name="SDL_GetPrefPath")
	GetPrefPath :: proc(org: cstring, app: cstring) -> cstring ---

	@(link_name="SDL_GetUserFolder")
	GetUserFolder :: proc(folder: Folder) -> cstring ---

	@(link_name="SDL_CreateDirectory")
	CreateDirectory :: proc(path: cstring) -> cffi.bool ---

	@(link_name="SDL_EnumerateDirectory")
	EnumerateDirectory :: proc(path: cstring, callback: EnumerateDirectoryCallback, userdata: rawptr) -> cffi.bool ---

	@(link_name="SDL_RemovePath")
	RemovePath :: proc(path: cstring) -> cffi.bool ---

	@(link_name="SDL_RenamePath")
	RenamePath :: proc(oldpath: cstring, newpath: cstring) -> cffi.bool ---

	@(link_name="SDL_CopyFile")
	CopyFile :: proc(oldpath: cstring, newpath: cstring) -> cffi.bool ---

	@(link_name="SDL_GetPathInfo")
	GetPathInfo :: proc(path: cstring, info: ^PathInfo) -> cffi.bool ---

	@(link_name="SDL_GlobDirectory")
	GlobDirectory :: proc(path: cstring, pattern: cstring, flags: GlobFlags, count: ^cffi.int) -> ^cstring ---

	@(link_name="SDL_GPUSupportsShaderFormats")
	GPUSupportsShaderFormats :: proc(format_flags: GPUShaderFormat, name: cstring) -> cffi.bool ---

	@(link_name="SDL_GPUSupportsProperties")
	GPUSupportsProperties :: proc(props: PropertiesID) -> cffi.bool ---

	@(link_name="SDL_CreateGPUDevice")
	CreateGPUDevice :: proc(format_flags: GPUShaderFormat, debug_mode: cffi.bool, name: cstring) -> ^GPUDevice ---

	@(link_name="SDL_CreateGPUDeviceWithProperties")
	CreateGPUDeviceWithProperties :: proc(props: PropertiesID) -> ^GPUDevice ---

	@(link_name="SDL_DestroyGPUDevice")
	DestroyGPUDevice :: proc(device: ^GPUDevice) ---

	@(link_name="SDL_GetNumGPUDrivers")
	GetNumGPUDrivers :: proc() -> cffi.int ---

	@(link_name="SDL_GetGPUDriver")
	GetGPUDriver :: proc(index: cffi.int) -> cstring ---

	@(link_name="SDL_GetGPUDeviceDriver")
	GetGPUDeviceDriver :: proc(device: ^GPUDevice) -> cstring ---

	@(link_name="SDL_GetGPUShaderFormats")
	GetGPUShaderFormats :: proc(device: ^GPUDevice) -> GPUShaderFormat ---

	@(link_name="SDL_CreateGPUComputePipeline")
	CreateGPUComputePipeline :: proc(device: ^GPUDevice, createinfo: ^GPUComputePipelineCreateInfo) -> ^GPUComputePipeline ---

	@(link_name="SDL_CreateGPUGraphicsPipeline")
	CreateGPUGraphicsPipeline :: proc(device: ^GPUDevice, createinfo: ^GPUGraphicsPipelineCreateInfo) -> ^GPUGraphicsPipeline ---

	@(link_name="SDL_CreateGPUSampler")
	CreateGPUSampler :: proc(device: ^GPUDevice, createinfo: ^GPUSamplerCreateInfo) -> ^GPUSampler ---

	@(link_name="SDL_CreateGPUShader")
	CreateGPUShader :: proc(device: ^GPUDevice, createinfo: ^GPUShaderCreateInfo) -> ^GPUShader ---

	@(link_name="SDL_CreateGPUTexture")
	CreateGPUTexture :: proc(device: ^GPUDevice, createinfo: ^GPUTextureCreateInfo) -> ^GPUTexture ---

	@(link_name="SDL_CreateGPUBuffer")
	CreateGPUBuffer :: proc(device: ^GPUDevice, createinfo: ^GPUBufferCreateInfo) -> ^GPUBuffer ---

	@(link_name="SDL_CreateGPUTransferBuffer")
	CreateGPUTransferBuffer :: proc(device: ^GPUDevice, createinfo: ^GPUTransferBufferCreateInfo) -> ^GPUTransferBuffer ---

	@(link_name="SDL_SetGPUBufferName")
	SetGPUBufferName :: proc(device: ^GPUDevice, buffer: ^GPUBuffer, text: cstring) ---

	@(link_name="SDL_SetGPUTextureName")
	SetGPUTextureName :: proc(device: ^GPUDevice, texture: ^GPUTexture, text: cstring) ---

	@(link_name="SDL_InsertGPUDebugLabel")
	InsertGPUDebugLabel :: proc(command_buffer: ^GPUCommandBuffer, text: cstring) ---

	@(link_name="SDL_PushGPUDebugGroup")
	PushGPUDebugGroup :: proc(command_buffer: ^GPUCommandBuffer, name: cstring) ---

	@(link_name="SDL_PopGPUDebugGroup")
	PopGPUDebugGroup :: proc(command_buffer: ^GPUCommandBuffer) ---

	@(link_name="SDL_ReleaseGPUTexture")
	ReleaseGPUTexture :: proc(device: ^GPUDevice, texture: ^GPUTexture) ---

	@(link_name="SDL_ReleaseGPUSampler")
	ReleaseGPUSampler :: proc(device: ^GPUDevice, sampler: ^GPUSampler) ---

	@(link_name="SDL_ReleaseGPUBuffer")
	ReleaseGPUBuffer :: proc(device: ^GPUDevice, buffer: ^GPUBuffer) ---

	@(link_name="SDL_ReleaseGPUTransferBuffer")
	ReleaseGPUTransferBuffer :: proc(device: ^GPUDevice, transfer_buffer: ^GPUTransferBuffer) ---

	@(link_name="SDL_ReleaseGPUComputePipeline")
	ReleaseGPUComputePipeline :: proc(device: ^GPUDevice, compute_pipeline: ^GPUComputePipeline) ---

	@(link_name="SDL_ReleaseGPUShader")
	ReleaseGPUShader :: proc(device: ^GPUDevice, shader: ^GPUShader) ---

	@(link_name="SDL_ReleaseGPUGraphicsPipeline")
	ReleaseGPUGraphicsPipeline :: proc(device: ^GPUDevice, graphics_pipeline: ^GPUGraphicsPipeline) ---

	@(link_name="SDL_AcquireGPUCommandBuffer")
	AcquireGPUCommandBuffer :: proc(device: ^GPUDevice) -> ^GPUCommandBuffer ---

	@(link_name="SDL_PushGPUVertexUniformData")
	PushGPUVertexUniformData :: proc(command_buffer: ^GPUCommandBuffer, slot_index: Uint32, data: rawptr, length: Uint32) ---

	@(link_name="SDL_PushGPUFragmentUniformData")
	PushGPUFragmentUniformData :: proc(command_buffer: ^GPUCommandBuffer, slot_index: Uint32, data: rawptr, length: Uint32) ---

	@(link_name="SDL_PushGPUComputeUniformData")
	PushGPUComputeUniformData :: proc(command_buffer: ^GPUCommandBuffer, slot_index: Uint32, data: rawptr, length: Uint32) ---

	@(link_name="SDL_BeginGPURenderPass")
	BeginGPURenderPass :: proc(command_buffer: ^GPUCommandBuffer, color_target_infos: ^GPUColorTargetInfo, num_color_targets: Uint32, depth_stencil_target_info: ^GPUDepthStencilTargetInfo) -> ^GPURenderPass ---

	@(link_name="SDL_BindGPUGraphicsPipeline")
	BindGPUGraphicsPipeline :: proc(render_pass: ^GPURenderPass, graphics_pipeline: ^GPUGraphicsPipeline) ---

	@(link_name="SDL_SetGPUViewport")
	SetGPUViewport :: proc(render_pass: ^GPURenderPass, viewport: ^GPUViewport) ---

	@(link_name="SDL_SetGPUScissor")
	SetGPUScissor :: proc(render_pass: ^GPURenderPass, scissor: ^Rect) ---

	@(link_name="SDL_SetGPUBlendConstants")
	SetGPUBlendConstants :: proc(render_pass: ^GPURenderPass, blend_constants: FColor) ---

	@(link_name="SDL_SetGPUStencilReference")
	SetGPUStencilReference :: proc(render_pass: ^GPURenderPass, reference: Uint8) ---

	@(link_name="SDL_BindGPUVertexBuffers")
	BindGPUVertexBuffers :: proc(render_pass: ^GPURenderPass, first_slot: Uint32, bindings: ^GPUBufferBinding, num_bindings: Uint32) ---

	@(link_name="SDL_BindGPUIndexBuffer")
	BindGPUIndexBuffer :: proc(render_pass: ^GPURenderPass, binding: ^GPUBufferBinding, index_element_size: GPUIndexElementSize) ---

	@(link_name="SDL_BindGPUVertexSamplers")
	BindGPUVertexSamplers :: proc(render_pass: ^GPURenderPass, first_slot: Uint32, texture_sampler_bindings: ^GPUTextureSamplerBinding, num_bindings: Uint32) ---

	@(link_name="SDL_BindGPUVertexStorageTextures")
	BindGPUVertexStorageTextures :: proc(render_pass: ^GPURenderPass, first_slot: Uint32, storage_textures: ^^GPUTexture, num_bindings: Uint32) ---

	@(link_name="SDL_BindGPUVertexStorageBuffers")
	BindGPUVertexStorageBuffers :: proc(render_pass: ^GPURenderPass, first_slot: Uint32, storage_buffers: ^^GPUBuffer, num_bindings: Uint32) ---

	@(link_name="SDL_BindGPUFragmentSamplers")
	BindGPUFragmentSamplers :: proc(render_pass: ^GPURenderPass, first_slot: Uint32, texture_sampler_bindings: ^GPUTextureSamplerBinding, num_bindings: Uint32) ---

	@(link_name="SDL_BindGPUFragmentStorageTextures")
	BindGPUFragmentStorageTextures :: proc(render_pass: ^GPURenderPass, first_slot: Uint32, storage_textures: ^^GPUTexture, num_bindings: Uint32) ---

	@(link_name="SDL_BindGPUFragmentStorageBuffers")
	BindGPUFragmentStorageBuffers :: proc(render_pass: ^GPURenderPass, first_slot: Uint32, storage_buffers: ^^GPUBuffer, num_bindings: Uint32) ---

	@(link_name="SDL_DrawGPUIndexedPrimitives")
	DrawGPUIndexedPrimitives :: proc(render_pass: ^GPURenderPass, num_indices: Uint32, num_instances: Uint32, first_index: Uint32, vertex_offset: Sint32, first_instance: Uint32) ---

	@(link_name="SDL_DrawGPUPrimitives")
	DrawGPUPrimitives :: proc(render_pass: ^GPURenderPass, num_vertices: Uint32, num_instances: Uint32, first_vertex: Uint32, first_instance: Uint32) ---

	@(link_name="SDL_DrawGPUPrimitivesIndirect")
	DrawGPUPrimitivesIndirect :: proc(render_pass: ^GPURenderPass, buffer: ^GPUBuffer, offset: Uint32, draw_count: Uint32) ---

	@(link_name="SDL_DrawGPUIndexedPrimitivesIndirect")
	DrawGPUIndexedPrimitivesIndirect :: proc(render_pass: ^GPURenderPass, buffer: ^GPUBuffer, offset: Uint32, draw_count: Uint32) ---

	@(link_name="SDL_EndGPURenderPass")
	EndGPURenderPass :: proc(render_pass: ^GPURenderPass) ---

	@(link_name="SDL_BeginGPUComputePass")
	BeginGPUComputePass :: proc(command_buffer: ^GPUCommandBuffer, storage_texture_bindings: ^GPUStorageTextureReadWriteBinding, num_storage_texture_bindings: Uint32, storage_buffer_bindings: ^GPUStorageBufferReadWriteBinding, num_storage_buffer_bindings: Uint32) -> ^GPUComputePass ---

	@(link_name="SDL_BindGPUComputePipeline")
	BindGPUComputePipeline :: proc(compute_pass: ^GPUComputePass, compute_pipeline: ^GPUComputePipeline) ---

	@(link_name="SDL_BindGPUComputeSamplers")
	BindGPUComputeSamplers :: proc(compute_pass: ^GPUComputePass, first_slot: Uint32, texture_sampler_bindings: ^GPUTextureSamplerBinding, num_bindings: Uint32) ---

	@(link_name="SDL_BindGPUComputeStorageTextures")
	BindGPUComputeStorageTextures :: proc(compute_pass: ^GPUComputePass, first_slot: Uint32, storage_textures: ^^GPUTexture, num_bindings: Uint32) ---

	@(link_name="SDL_BindGPUComputeStorageBuffers")
	BindGPUComputeStorageBuffers :: proc(compute_pass: ^GPUComputePass, first_slot: Uint32, storage_buffers: ^^GPUBuffer, num_bindings: Uint32) ---

	@(link_name="SDL_DispatchGPUCompute")
	DispatchGPUCompute :: proc(compute_pass: ^GPUComputePass, groupcount_x: Uint32, groupcount_y: Uint32, groupcount_z: Uint32) ---

	@(link_name="SDL_DispatchGPUComputeIndirect")
	DispatchGPUComputeIndirect :: proc(compute_pass: ^GPUComputePass, buffer: ^GPUBuffer, offset: Uint32) ---

	@(link_name="SDL_EndGPUComputePass")
	EndGPUComputePass :: proc(compute_pass: ^GPUComputePass) ---

	@(link_name="SDL_MapGPUTransferBuffer")
	MapGPUTransferBuffer :: proc(device: ^GPUDevice, transfer_buffer: ^GPUTransferBuffer, cycle: cffi.bool) -> rawptr ---

	@(link_name="SDL_UnmapGPUTransferBuffer")
	UnmapGPUTransferBuffer :: proc(device: ^GPUDevice, transfer_buffer: ^GPUTransferBuffer) ---

	@(link_name="SDL_BeginGPUCopyPass")
	BeginGPUCopyPass :: proc(command_buffer: ^GPUCommandBuffer) -> ^GPUCopyPass ---

	@(link_name="SDL_UploadToGPUTexture")
	UploadToGPUTexture :: proc(copy_pass: ^GPUCopyPass, source: ^GPUTextureTransferInfo, destination: ^GPUTextureRegion, cycle: cffi.bool) ---

	@(link_name="SDL_UploadToGPUBuffer")
	UploadToGPUBuffer :: proc(copy_pass: ^GPUCopyPass, source: ^GPUTransferBufferLocation, destination: ^GPUBufferRegion, cycle: cffi.bool) ---

	@(link_name="SDL_CopyGPUTextureToTexture")
	CopyGPUTextureToTexture :: proc(copy_pass: ^GPUCopyPass, source: ^GPUTextureLocation, destination: ^GPUTextureLocation, w: Uint32, h: Uint32, d: Uint32, cycle: cffi.bool) ---

	@(link_name="SDL_CopyGPUBufferToBuffer")
	CopyGPUBufferToBuffer :: proc(copy_pass: ^GPUCopyPass, source: ^GPUBufferLocation, destination: ^GPUBufferLocation, size: Uint32, cycle: cffi.bool) ---

	@(link_name="SDL_DownloadFromGPUTexture")
	DownloadFromGPUTexture :: proc(copy_pass: ^GPUCopyPass, source: ^GPUTextureRegion, destination: ^GPUTextureTransferInfo) ---

	@(link_name="SDL_DownloadFromGPUBuffer")
	DownloadFromGPUBuffer :: proc(copy_pass: ^GPUCopyPass, source: ^GPUBufferRegion, destination: ^GPUTransferBufferLocation) ---

	@(link_name="SDL_EndGPUCopyPass")
	EndGPUCopyPass :: proc(copy_pass: ^GPUCopyPass) ---

	@(link_name="SDL_GenerateMipmapsForGPUTexture")
	GenerateMipmapsForGPUTexture :: proc(command_buffer: ^GPUCommandBuffer, texture: ^GPUTexture) ---

	@(link_name="SDL_BlitGPUTexture")
	BlitGPUTexture :: proc(command_buffer: ^GPUCommandBuffer, info: ^GPUBlitInfo) ---

	@(link_name="SDL_WindowSupportsGPUSwapchainComposition")
	WindowSupportsGPUSwapchainComposition :: proc(device: ^GPUDevice, window: ^Window, swapchain_composition: GPUSwapchainComposition) -> cffi.bool ---

	@(link_name="SDL_WindowSupportsGPUPresentMode")
	WindowSupportsGPUPresentMode :: proc(device: ^GPUDevice, window: ^Window, present_mode: GPUPresentMode) -> cffi.bool ---

	@(link_name="SDL_ClaimWindowForGPUDevice")
	ClaimWindowForGPUDevice :: proc(device: ^GPUDevice, window: ^Window) -> cffi.bool ---

	@(link_name="SDL_ReleaseWindowFromGPUDevice")
	ReleaseWindowFromGPUDevice :: proc(device: ^GPUDevice, window: ^Window) ---

	@(link_name="SDL_SetGPUSwapchainParameters")
	SetGPUSwapchainParameters :: proc(device: ^GPUDevice, window: ^Window, swapchain_composition: GPUSwapchainComposition, present_mode: GPUPresentMode) -> cffi.bool ---

	@(link_name="SDL_GetGPUSwapchainTextureFormat")
	GetGPUSwapchainTextureFormat :: proc(device: ^GPUDevice, window: ^Window) -> GPUTextureFormat ---

	@(link_name="SDL_AcquireGPUSwapchainTexture")
	AcquireGPUSwapchainTexture :: proc(command_buffer: ^GPUCommandBuffer, window: ^Window, swapchain_texture: ^^GPUTexture, swapchain_texture_width: ^Uint32, swapchain_texture_height: ^Uint32) -> cffi.bool ---

	@(link_name="SDL_SubmitGPUCommandBuffer")
	SubmitGPUCommandBuffer :: proc(command_buffer: ^GPUCommandBuffer) -> cffi.bool ---

	@(link_name="SDL_SubmitGPUCommandBufferAndAcquireFence")
	SubmitGPUCommandBufferAndAcquireFence :: proc(command_buffer: ^GPUCommandBuffer) -> ^GPUFence ---

	@(link_name="SDL_CancelGPUCommandBuffer")
	CancelGPUCommandBuffer :: proc(command_buffer: ^GPUCommandBuffer) -> cffi.bool ---

	@(link_name="SDL_WaitForGPUIdle")
	WaitForGPUIdle :: proc(device: ^GPUDevice) -> cffi.bool ---

	@(link_name="SDL_WaitForGPUFences")
	WaitForGPUFences :: proc(device: ^GPUDevice, wait_all: cffi.bool, fences: ^^GPUFence, num_fences: Uint32) -> cffi.bool ---

	@(link_name="SDL_QueryGPUFence")
	QueryGPUFence :: proc(device: ^GPUDevice, fence: ^GPUFence) -> cffi.bool ---

	@(link_name="SDL_ReleaseGPUFence")
	ReleaseGPUFence :: proc(device: ^GPUDevice, fence: ^GPUFence) ---

	@(link_name="SDL_GPUTextureFormatTexelBlockSize")
	GPUTextureFormatTexelBlockSize :: proc(format: GPUTextureFormat) -> Uint32 ---

	@(link_name="SDL_GPUTextureSupportsFormat")
	GPUTextureSupportsFormat :: proc(device: ^GPUDevice, format: GPUTextureFormat, type: GPUTextureType, usage: GPUTextureUsageFlags) -> cffi.bool ---

	@(link_name="SDL_GPUTextureSupportsSampleCount")
	GPUTextureSupportsSampleCount :: proc(device: ^GPUDevice, format: GPUTextureFormat, sample_count: GPUSampleCount) -> cffi.bool ---

	@(link_name="SDL_CalculateGPUTextureFormatSize")
	CalculateGPUTextureFormatSize :: proc(format: GPUTextureFormat, width: Uint32, height: Uint32, depth_or_layer_count: Uint32) -> Uint32 ---

	@(link_name="SDL_GetHaptics")
	GetHaptics :: proc(count: ^cffi.int) -> ^HapticID ---

	@(link_name="SDL_GetHapticNameForID")
	GetHapticNameForID :: proc(instance_id: HapticID) -> cstring ---

	@(link_name="SDL_OpenHaptic")
	OpenHaptic :: proc(instance_id: HapticID) -> ^Haptic ---

	@(link_name="SDL_GetHapticFromID")
	GetHapticFromID :: proc(instance_id: HapticID) -> ^Haptic ---

	@(link_name="SDL_GetHapticID")
	GetHapticID :: proc(haptic: ^Haptic) -> HapticID ---

	@(link_name="SDL_GetHapticName")
	GetHapticName :: proc(haptic: ^Haptic) -> cstring ---

	@(link_name="SDL_IsMouseHaptic")
	IsMouseHaptic :: proc() -> cffi.bool ---

	@(link_name="SDL_OpenHapticFromMouse")
	OpenHapticFromMouse :: proc() -> ^Haptic ---

	@(link_name="SDL_IsJoystickHaptic")
	IsJoystickHaptic :: proc(joystick: ^Joystick) -> cffi.bool ---

	@(link_name="SDL_OpenHapticFromJoystick")
	OpenHapticFromJoystick :: proc(joystick: ^Joystick) -> ^Haptic ---

	@(link_name="SDL_CloseHaptic")
	CloseHaptic :: proc(haptic: ^Haptic) ---

	@(link_name="SDL_GetMaxHapticEffects")
	GetMaxHapticEffects :: proc(haptic: ^Haptic) -> cffi.int ---

	@(link_name="SDL_GetMaxHapticEffectsPlaying")
	GetMaxHapticEffectsPlaying :: proc(haptic: ^Haptic) -> cffi.int ---

	@(link_name="SDL_GetHapticFeatures")
	GetHapticFeatures :: proc(haptic: ^Haptic) -> Uint32 ---

	@(link_name="SDL_GetNumHapticAxes")
	GetNumHapticAxes :: proc(haptic: ^Haptic) -> cffi.int ---

	@(link_name="SDL_HapticEffectSupported")
	HapticEffectSupported :: proc(haptic: ^Haptic, effect: ^HapticEffect) -> cffi.bool ---

	@(link_name="SDL_CreateHapticEffect")
	CreateHapticEffect :: proc(haptic: ^Haptic, effect: ^HapticEffect) -> cffi.int ---

	@(link_name="SDL_UpdateHapticEffect")
	UpdateHapticEffect :: proc(haptic: ^Haptic, effect: cffi.int, data: ^HapticEffect) -> cffi.bool ---

	@(link_name="SDL_RunHapticEffect")
	RunHapticEffect :: proc(haptic: ^Haptic, effect: cffi.int, iterations: Uint32) -> cffi.bool ---

	@(link_name="SDL_StopHapticEffect")
	StopHapticEffect :: proc(haptic: ^Haptic, effect: cffi.int) -> cffi.bool ---

	@(link_name="SDL_DestroyHapticEffect")
	DestroyHapticEffect :: proc(haptic: ^Haptic, effect: cffi.int) ---

	@(link_name="SDL_GetHapticEffectStatus")
	GetHapticEffectStatus :: proc(haptic: ^Haptic, effect: cffi.int) -> cffi.bool ---

	@(link_name="SDL_SetHapticGain")
	SetHapticGain :: proc(haptic: ^Haptic, gain: cffi.int) -> cffi.bool ---

	@(link_name="SDL_SetHapticAutocenter")
	SetHapticAutocenter :: proc(haptic: ^Haptic, autocenter: cffi.int) -> cffi.bool ---

	@(link_name="SDL_PauseHaptic")
	PauseHaptic :: proc(haptic: ^Haptic) -> cffi.bool ---

	@(link_name="SDL_ResumeHaptic")
	ResumeHaptic :: proc(haptic: ^Haptic) -> cffi.bool ---

	@(link_name="SDL_StopHapticEffects")
	StopHapticEffects :: proc(haptic: ^Haptic) -> cffi.bool ---

	@(link_name="SDL_HapticRumbleSupported")
	HapticRumbleSupported :: proc(haptic: ^Haptic) -> cffi.bool ---

	@(link_name="SDL_InitHapticRumble")
	InitHapticRumble :: proc(haptic: ^Haptic) -> cffi.bool ---

	@(link_name="SDL_PlayHapticRumble")
	PlayHapticRumble :: proc(haptic: ^Haptic, strength: cffi.float, length: Uint32) -> cffi.bool ---

	@(link_name="SDL_StopHapticRumble")
	StopHapticRumble :: proc(haptic: ^Haptic) -> cffi.bool ---

	@(link_name="SDL_hid_init")
	hid_init :: proc() -> cffi.int ---

	@(link_name="SDL_hid_exit")
	hid_exit :: proc() -> cffi.int ---

	@(link_name="SDL_hid_device_change_count")
	hid_device_change_count :: proc() -> Uint32 ---

	@(link_name="SDL_hid_enumerate")
	hid_enumerate :: proc(vendor_id: cffi.ushort, product_id: cffi.ushort) -> ^hid_device_info ---

	@(link_name="SDL_hid_free_enumeration")
	hid_free_enumeration :: proc(devs: ^hid_device_info) ---

	@(link_name="SDL_hid_open")
	hid_open :: proc(vendor_id: cffi.ushort, product_id: cffi.ushort, serial_number: ^cffi.wchar_t) -> ^hid_device ---

	@(link_name="SDL_hid_open_path")
	hid_open_path :: proc(path: cstring) -> ^hid_device ---

	@(link_name="SDL_hid_write")
	hid_write :: proc(dev: ^hid_device, data: ^cffi.uchar, length: cffi.size_t) -> cffi.int ---

	@(link_name="SDL_hid_read_timeout")
	hid_read_timeout :: proc(dev: ^hid_device, data: ^cffi.uchar, length: cffi.size_t, milliseconds: cffi.int) -> cffi.int ---

	@(link_name="SDL_hid_read")
	hid_read :: proc(dev: ^hid_device, data: ^cffi.uchar, length: cffi.size_t) -> cffi.int ---

	@(link_name="SDL_hid_set_nonblocking")
	hid_set_nonblocking :: proc(dev: ^hid_device, nonblock: cffi.int) -> cffi.int ---

	@(link_name="SDL_hid_send_feature_report")
	hid_send_feature_report :: proc(dev: ^hid_device, data: ^cffi.uchar, length: cffi.size_t) -> cffi.int ---

	@(link_name="SDL_hid_get_feature_report")
	hid_get_feature_report :: proc(dev: ^hid_device, data: ^cffi.uchar, length: cffi.size_t) -> cffi.int ---

	@(link_name="SDL_hid_get_input_report")
	hid_get_input_report :: proc(dev: ^hid_device, data: ^cffi.uchar, length: cffi.size_t) -> cffi.int ---

	@(link_name="SDL_hid_close")
	hid_close :: proc(dev: ^hid_device) -> cffi.int ---

	@(link_name="SDL_hid_get_manufacturer_string")
	hid_get_manufacturer_string :: proc(dev: ^hid_device, string: ^cffi.wchar_t, maxlen: cffi.size_t) -> cffi.int ---

	@(link_name="SDL_hid_get_product_string")
	hid_get_product_string :: proc(dev: ^hid_device, string: ^cffi.wchar_t, maxlen: cffi.size_t) -> cffi.int ---

	@(link_name="SDL_hid_get_serial_number_string")
	hid_get_serial_number_string :: proc(dev: ^hid_device, string: ^cffi.wchar_t, maxlen: cffi.size_t) -> cffi.int ---

	@(link_name="SDL_hid_get_indexed_string")
	hid_get_indexed_string :: proc(dev: ^hid_device, string_index: cffi.int, string: ^cffi.wchar_t, maxlen: cffi.size_t) -> cffi.int ---

	@(link_name="SDL_hid_get_device_info")
	hid_get_device_info :: proc(dev: ^hid_device) -> ^hid_device_info ---

	@(link_name="SDL_hid_get_report_descriptor")
	hid_get_report_descriptor :: proc(dev: ^hid_device, buf: ^cffi.uchar, buf_size: cffi.size_t) -> cffi.int ---

	@(link_name="SDL_hid_ble_scan")
	hid_ble_scan :: proc(active: cffi.bool) ---

	@(link_name="SDL_SetHintWithPriority")
	SetHintWithPriority :: proc(name: cstring, value: cstring, priority: HintPriority) -> cffi.bool ---

	@(link_name="SDL_SetHint")
	SetHint :: proc(name: cstring, value: cstring) -> cffi.bool ---

	@(link_name="SDL_ResetHint")
	ResetHint :: proc(name: cstring) -> cffi.bool ---

	@(link_name="SDL_ResetHints")
	ResetHints :: proc() ---

	@(link_name="SDL_GetHint")
	GetHint :: proc(name: cstring) -> cstring ---

	@(link_name="SDL_GetHintBoolean")
	GetHintBoolean :: proc(name: cstring, default_value: cffi.bool) -> cffi.bool ---

	@(link_name="SDL_AddHintCallback")
	AddHintCallback :: proc(name: cstring, callback: HintCallback, userdata: rawptr) -> cffi.bool ---

	@(link_name="SDL_RemoveHintCallback")
	RemoveHintCallback :: proc(name: cstring, callback: HintCallback, userdata: rawptr) ---

	@(link_name="SDL_Init")
	Init :: proc(flags: InitFlags) -> cffi.bool ---

	@(link_name="SDL_InitSubSystem")
	InitSubSystem :: proc(flags: InitFlags) -> cffi.bool ---

	@(link_name="SDL_QuitSubSystem")
	QuitSubSystem :: proc(flags: InitFlags) ---

	@(link_name="SDL_WasInit")
	WasInit :: proc(flags: InitFlags) -> InitFlags ---

	@(link_name="SDL_Quit")
	Quit :: proc() ---

	@(link_name="SDL_SetAppMetadata")
	SetAppMetadata :: proc(appname: cstring, appversion: cstring, appidentifier: cstring) -> cffi.bool ---

	@(link_name="SDL_SetAppMetadataProperty")
	SetAppMetadataProperty :: proc(name: cstring, value: cstring) -> cffi.bool ---

	@(link_name="SDL_GetAppMetadataProperty")
	GetAppMetadataProperty :: proc(name: cstring) -> cstring ---

	@(link_name="SDL_LoadObject")
	LoadObject :: proc(sofile: cstring) -> ^SharedObject ---

	@(link_name="SDL_LoadFunction")
	LoadFunction :: proc(handle: ^SharedObject, name: cstring) -> FunctionPointer ---

	@(link_name="SDL_UnloadObject")
	UnloadObject :: proc(handle: ^SharedObject) ---

	@(link_name="SDL_GetPreferredLocales")
	GetPreferredLocales :: proc(count: ^cffi.int) -> ^^Locale ---

	@(link_name="SDL_SetLogPriorities")
	SetLogPriorities :: proc(priority: LogPriority) ---

	@(link_name="SDL_SetLogPriority")
	SetLogPriority :: proc(category: cffi.int, priority: LogPriority) ---

	@(link_name="SDL_GetLogPriority")
	GetLogPriority :: proc(category: cffi.int) -> LogPriority ---

	@(link_name="SDL_ResetLogPriorities")
	ResetLogPriorities :: proc() ---

	@(link_name="SDL_SetLogPriorityPrefix")
	SetLogPriorityPrefix :: proc(priority: LogPriority, prefix: cstring) -> cffi.bool ---

	@(link_name="SDL_Log")
	Log :: proc(fmt: cstring, #c_vararg args: ..any) ---

	@(link_name="SDL_LogTrace")
	LogTrace :: proc(category: cffi.int, fmt: cstring, #c_vararg args: ..any) ---

	@(link_name="SDL_LogVerbose")
	LogVerbose :: proc(category: cffi.int, fmt: cstring, #c_vararg args: ..any) ---

	@(link_name="SDL_LogDebug")
	LogDebug :: proc(category: cffi.int, fmt: cstring, #c_vararg args: ..any) ---

	@(link_name="SDL_LogInfo")
	LogInfo :: proc(category: cffi.int, fmt: cstring, #c_vararg args: ..any) ---

	@(link_name="SDL_LogWarn")
	LogWarn :: proc(category: cffi.int, fmt: cstring, #c_vararg args: ..any) ---

	@(link_name="SDL_LogError")
	LogError :: proc(category: cffi.int, fmt: cstring, #c_vararg args: ..any) ---

	@(link_name="SDL_LogCritical")
	LogCritical :: proc(category: cffi.int, fmt: cstring, #c_vararg args: ..any) ---

	@(link_name="SDL_LogMessage")
	LogMessage :: proc(category: cffi.int, priority: LogPriority, fmt: cstring, #c_vararg args: ..any) ---

	@(link_name="SDL_LogMessageV")
	LogMessageV :: proc(category: cffi.int, priority: LogPriority, fmt: cstring, ap: cffi.va_list) ---

	@(link_name="SDL_GetDefaultLogOutputFunction")
	GetDefaultLogOutputFunction :: proc() -> LogOutputFunction ---

	@(link_name="SDL_GetLogOutputFunction")
	GetLogOutputFunction :: proc(callback: LogOutputFunction, userdata: ^rawptr) ---

	@(link_name="SDL_SetLogOutputFunction")
	SetLogOutputFunction :: proc(callback: LogOutputFunction, userdata: rawptr) ---

	@(link_name="SDL_ShowMessageBox")
	ShowMessageBox :: proc(messageboxdata: ^MessageBoxData, buttonid: ^cffi.int) -> cffi.bool ---

	@(link_name="SDL_ShowSimpleMessageBox")
	ShowSimpleMessageBox :: proc(flags: MessageBoxFlags, title: cstring, message: cstring, window: ^Window) -> cffi.bool ---

	@(link_name="SDL_Metal_CreateView")
	Metal_CreateView :: proc(window: ^Window) -> MetalView ---

	@(link_name="SDL_Metal_DestroyView")
	Metal_DestroyView :: proc(view: MetalView) ---

	@(link_name="SDL_Metal_GetLayer")
	Metal_GetLayer :: proc(view: MetalView) -> rawptr ---

	@(link_name="SDL_OpenURL")
	OpenURL :: proc(url: cstring) -> cffi.bool ---

	@(link_name="SDL_GetPlatform")
	GetPlatform :: proc() -> cstring ---

	@(link_name="SDL_CreateProcess")
	CreateProcess :: proc(args: ^cstring, pipe_stdio: cffi.bool) -> ^Process ---

	@(link_name="SDL_CreateProcessWithProperties")
	CreateProcessWithProperties :: proc(props: PropertiesID) -> ^Process ---

	@(link_name="SDL_GetProcessProperties")
	GetProcessProperties :: proc(process: ^Process) -> PropertiesID ---

	@(link_name="SDL_ReadProcess")
	ReadProcess :: proc(process: ^Process, datasize: ^cffi.size_t, exitcode: ^cffi.int) -> rawptr ---

	@(link_name="SDL_GetProcessInput")
	GetProcessInput :: proc(process: ^Process) -> ^IOStream ---

	@(link_name="SDL_GetProcessOutput")
	GetProcessOutput :: proc(process: ^Process) -> ^IOStream ---

	@(link_name="SDL_KillProcess")
	KillProcess :: proc(process: ^Process, force: cffi.bool) -> cffi.bool ---

	@(link_name="SDL_WaitProcess")
	WaitProcess :: proc(process: ^Process, block: cffi.bool, exitcode: ^cffi.int) -> cffi.bool ---

	@(link_name="SDL_DestroyProcess")
	DestroyProcess :: proc(process: ^Process) ---

	@(link_name="SDL_GetNumRenderDrivers")
	GetNumRenderDrivers :: proc() -> cffi.int ---

	@(link_name="SDL_GetRenderDriver")
	GetRenderDriver :: proc(index: cffi.int) -> cstring ---

	@(link_name="SDL_CreateWindowAndRenderer")
	CreateWindowAndRenderer :: proc(title: cstring, width: cffi.int, height: cffi.int, window_flags: WindowFlags, window: ^^Window, renderer: ^^Renderer) -> cffi.bool ---

	@(link_name="SDL_CreateRenderer")
	CreateRenderer :: proc(window: ^Window, name: cstring) -> ^Renderer ---

	@(link_name="SDL_CreateRendererWithProperties")
	CreateRendererWithProperties :: proc(props: PropertiesID) -> ^Renderer ---

	@(link_name="SDL_CreateSoftwareRenderer")
	CreateSoftwareRenderer :: proc(surface: ^Surface) -> ^Renderer ---

	@(link_name="SDL_GetRenderer")
	GetRenderer :: proc(window: ^Window) -> ^Renderer ---

	@(link_name="SDL_GetRenderWindow")
	GetRenderWindow :: proc(renderer: ^Renderer) -> ^Window ---

	@(link_name="SDL_GetRendererName")
	GetRendererName :: proc(renderer: ^Renderer) -> cstring ---

	@(link_name="SDL_GetRendererProperties")
	GetRendererProperties :: proc(renderer: ^Renderer) -> PropertiesID ---

	@(link_name="SDL_GetRenderOutputSize")
	GetRenderOutputSize :: proc(renderer: ^Renderer, w: ^cffi.int, h: ^cffi.int) -> cffi.bool ---

	@(link_name="SDL_GetCurrentRenderOutputSize")
	GetCurrentRenderOutputSize :: proc(renderer: ^Renderer, w: ^cffi.int, h: ^cffi.int) -> cffi.bool ---

	@(link_name="SDL_CreateTexture")
	CreateTexture :: proc(renderer: ^Renderer, format: PixelFormat, access: TextureAccess, w: cffi.int, h: cffi.int) -> ^Texture ---

	@(link_name="SDL_CreateTextureFromSurface")
	CreateTextureFromSurface :: proc(renderer: ^Renderer, surface: ^Surface) -> ^Texture ---

	@(link_name="SDL_CreateTextureWithProperties")
	CreateTextureWithProperties :: proc(renderer: ^Renderer, props: PropertiesID) -> ^Texture ---

	@(link_name="SDL_GetTextureProperties")
	GetTextureProperties :: proc(texture: ^Texture) -> PropertiesID ---

	@(link_name="SDL_GetRendererFromTexture")
	GetRendererFromTexture :: proc(texture: ^Texture) -> ^Renderer ---

	@(link_name="SDL_GetTextureSize")
	GetTextureSize :: proc(texture: ^Texture, w: ^cffi.float, h: ^cffi.float) -> cffi.bool ---

	@(link_name="SDL_SetTextureColorMod")
	SetTextureColorMod :: proc(texture: ^Texture, r: Uint8, g: Uint8, b: Uint8) -> cffi.bool ---

	@(link_name="SDL_SetTextureColorModFloat")
	SetTextureColorModFloat :: proc(texture: ^Texture, r: cffi.float, g: cffi.float, b: cffi.float) -> cffi.bool ---

	@(link_name="SDL_GetTextureColorMod")
	GetTextureColorMod :: proc(texture: ^Texture, r: ^Uint8, g: ^Uint8, b: ^Uint8) -> cffi.bool ---

	@(link_name="SDL_GetTextureColorModFloat")
	GetTextureColorModFloat :: proc(texture: ^Texture, r: ^cffi.float, g: ^cffi.float, b: ^cffi.float) -> cffi.bool ---

	@(link_name="SDL_SetTextureAlphaMod")
	SetTextureAlphaMod :: proc(texture: ^Texture, alpha: Uint8) -> cffi.bool ---

	@(link_name="SDL_SetTextureAlphaModFloat")
	SetTextureAlphaModFloat :: proc(texture: ^Texture, alpha: cffi.float) -> cffi.bool ---

	@(link_name="SDL_GetTextureAlphaMod")
	GetTextureAlphaMod :: proc(texture: ^Texture, alpha: ^Uint8) -> cffi.bool ---

	@(link_name="SDL_GetTextureAlphaModFloat")
	GetTextureAlphaModFloat :: proc(texture: ^Texture, alpha: ^cffi.float) -> cffi.bool ---

	@(link_name="SDL_SetTextureBlendMode")
	SetTextureBlendMode :: proc(texture: ^Texture, blendMode: BlendMode) -> cffi.bool ---

	@(link_name="SDL_GetTextureBlendMode")
	GetTextureBlendMode :: proc(texture: ^Texture, blendMode: ^BlendMode) -> cffi.bool ---

	@(link_name="SDL_SetTextureScaleMode")
	SetTextureScaleMode :: proc(texture: ^Texture, scaleMode: ScaleMode) -> cffi.bool ---

	@(link_name="SDL_GetTextureScaleMode")
	GetTextureScaleMode :: proc(texture: ^Texture, scaleMode: ^ScaleMode) -> cffi.bool ---

	@(link_name="SDL_UpdateTexture")
	UpdateTexture :: proc(texture: ^Texture, rect: ^Rect, pixels: rawptr, pitch: cffi.int) -> cffi.bool ---

	@(link_name="SDL_UpdateYUVTexture")
	UpdateYUVTexture :: proc(texture: ^Texture, rect: ^Rect, Yplane: ^Uint8, Ypitch: cffi.int, Uplane: ^Uint8, Upitch: cffi.int, Vplane: ^Uint8, Vpitch: cffi.int) -> cffi.bool ---

	@(link_name="SDL_UpdateNVTexture")
	UpdateNVTexture :: proc(texture: ^Texture, rect: ^Rect, Yplane: ^Uint8, Ypitch: cffi.int, UVplane: ^Uint8, UVpitch: cffi.int) -> cffi.bool ---

	@(link_name="SDL_LockTexture")
	LockTexture :: proc(texture: ^Texture, rect: ^Rect, pixels: ^rawptr, pitch: ^cffi.int) -> cffi.bool ---

	@(link_name="SDL_LockTextureToSurface")
	LockTextureToSurface :: proc(texture: ^Texture, rect: ^Rect, surface: ^^Surface) -> cffi.bool ---

	@(link_name="SDL_UnlockTexture")
	UnlockTexture :: proc(texture: ^Texture) ---

	@(link_name="SDL_SetRenderTarget")
	SetRenderTarget :: proc(renderer: ^Renderer, texture: ^Texture) -> cffi.bool ---

	@(link_name="SDL_GetRenderTarget")
	GetRenderTarget :: proc(renderer: ^Renderer) -> ^Texture ---

	@(link_name="SDL_SetRenderLogicalPresentation")
	SetRenderLogicalPresentation :: proc(renderer: ^Renderer, w: cffi.int, h: cffi.int, mode: RendererLogicalPresentation) -> cffi.bool ---

	@(link_name="SDL_GetRenderLogicalPresentation")
	GetRenderLogicalPresentation :: proc(renderer: ^Renderer, w: ^cffi.int, h: ^cffi.int, mode: ^RendererLogicalPresentation) -> cffi.bool ---

	@(link_name="SDL_GetRenderLogicalPresentationRect")
	GetRenderLogicalPresentationRect :: proc(renderer: ^Renderer, rect: ^FRect) -> cffi.bool ---

	@(link_name="SDL_RenderCoordinatesFromWindow")
	RenderCoordinatesFromWindow :: proc(renderer: ^Renderer, window_x: cffi.float, window_y: cffi.float, x: ^cffi.float, y: ^cffi.float) -> cffi.bool ---

	@(link_name="SDL_RenderCoordinatesToWindow")
	RenderCoordinatesToWindow :: proc(renderer: ^Renderer, x: cffi.float, y: cffi.float, window_x: ^cffi.float, window_y: ^cffi.float) -> cffi.bool ---

	@(link_name="SDL_ConvertEventToRenderCoordinates")
	ConvertEventToRenderCoordinates :: proc(renderer: ^Renderer, event: ^Event) -> cffi.bool ---

	@(link_name="SDL_SetRenderViewport")
	SetRenderViewport :: proc(renderer: ^Renderer, rect: ^Rect) -> cffi.bool ---

	@(link_name="SDL_GetRenderViewport")
	GetRenderViewport :: proc(renderer: ^Renderer, rect: ^Rect) -> cffi.bool ---

	@(link_name="SDL_RenderViewportSet")
	RenderViewportSet :: proc(renderer: ^Renderer) -> cffi.bool ---

	@(link_name="SDL_GetRenderSafeArea")
	GetRenderSafeArea :: proc(renderer: ^Renderer, rect: ^Rect) -> cffi.bool ---

	@(link_name="SDL_SetRenderClipRect")
	SetRenderClipRect :: proc(renderer: ^Renderer, rect: ^Rect) -> cffi.bool ---

	@(link_name="SDL_GetRenderClipRect")
	GetRenderClipRect :: proc(renderer: ^Renderer, rect: ^Rect) -> cffi.bool ---

	@(link_name="SDL_RenderClipEnabled")
	RenderClipEnabled :: proc(renderer: ^Renderer) -> cffi.bool ---

	@(link_name="SDL_SetRenderScale")
	SetRenderScale :: proc(renderer: ^Renderer, scaleX: cffi.float, scaleY: cffi.float) -> cffi.bool ---

	@(link_name="SDL_GetRenderScale")
	GetRenderScale :: proc(renderer: ^Renderer, scaleX: ^cffi.float, scaleY: ^cffi.float) -> cffi.bool ---

	@(link_name="SDL_SetRenderDrawColor")
	SetRenderDrawColor :: proc(renderer: ^Renderer, r: Uint8, g: Uint8, b: Uint8, a: Uint8) -> cffi.bool ---

	@(link_name="SDL_SetRenderDrawColorFloat")
	SetRenderDrawColorFloat :: proc(renderer: ^Renderer, r: cffi.float, g: cffi.float, b: cffi.float, a: cffi.float) -> cffi.bool ---

	@(link_name="SDL_GetRenderDrawColor")
	GetRenderDrawColor :: proc(renderer: ^Renderer, r: ^Uint8, g: ^Uint8, b: ^Uint8, a: ^Uint8) -> cffi.bool ---

	@(link_name="SDL_GetRenderDrawColorFloat")
	GetRenderDrawColorFloat :: proc(renderer: ^Renderer, r: ^cffi.float, g: ^cffi.float, b: ^cffi.float, a: ^cffi.float) -> cffi.bool ---

	@(link_name="SDL_SetRenderColorScale")
	SetRenderColorScale :: proc(renderer: ^Renderer, scale: cffi.float) -> cffi.bool ---

	@(link_name="SDL_GetRenderColorScale")
	GetRenderColorScale :: proc(renderer: ^Renderer, scale: ^cffi.float) -> cffi.bool ---

	@(link_name="SDL_SetRenderDrawBlendMode")
	SetRenderDrawBlendMode :: proc(renderer: ^Renderer, blendMode: BlendMode) -> cffi.bool ---

	@(link_name="SDL_GetRenderDrawBlendMode")
	GetRenderDrawBlendMode :: proc(renderer: ^Renderer, blendMode: ^BlendMode) -> cffi.bool ---

	@(link_name="SDL_RenderClear")
	RenderClear :: proc(renderer: ^Renderer) -> cffi.bool ---

	@(link_name="SDL_RenderPoint")
	RenderPoint :: proc(renderer: ^Renderer, x: cffi.float, y: cffi.float) -> cffi.bool ---

	@(link_name="SDL_RenderPoints")
	RenderPoints :: proc(renderer: ^Renderer, points: ^FPoint, count: cffi.int) -> cffi.bool ---

	@(link_name="SDL_RenderLine")
	RenderLine :: proc(renderer: ^Renderer, x1: cffi.float, y1: cffi.float, x2: cffi.float, y2: cffi.float) -> cffi.bool ---

	@(link_name="SDL_RenderLines")
	RenderLines :: proc(renderer: ^Renderer, points: ^FPoint, count: cffi.int) -> cffi.bool ---

	@(link_name="SDL_RenderRect")
	RenderRect :: proc(renderer: ^Renderer, rect: ^FRect) -> cffi.bool ---

	@(link_name="SDL_RenderRects")
	RenderRects :: proc(renderer: ^Renderer, rects: ^FRect, count: cffi.int) -> cffi.bool ---

	@(link_name="SDL_RenderFillRect")
	RenderFillRect :: proc(renderer: ^Renderer, rect: ^FRect) -> cffi.bool ---

	@(link_name="SDL_RenderFillRects")
	RenderFillRects :: proc(renderer: ^Renderer, rects: ^FRect, count: cffi.int) -> cffi.bool ---

	@(link_name="SDL_RenderTexture")
	RenderTexture :: proc(renderer: ^Renderer, texture: ^Texture, srcrect: ^FRect, dstrect: ^FRect) -> cffi.bool ---

	@(link_name="SDL_RenderTextureRotated")
	RenderTextureRotated :: proc(renderer: ^Renderer, texture: ^Texture, srcrect: ^FRect, dstrect: ^FRect, angle: cffi.double, center: ^FPoint, flip: FlipMode) -> cffi.bool ---

	@(link_name="SDL_RenderTextureTiled")
	RenderTextureTiled :: proc(renderer: ^Renderer, texture: ^Texture, srcrect: ^FRect, scale: cffi.float, dstrect: ^FRect) -> cffi.bool ---

	@(link_name="SDL_RenderTexture9Grid")
	RenderTexture9Grid :: proc(renderer: ^Renderer, texture: ^Texture, srcrect: ^FRect, left_width: cffi.float, right_width: cffi.float, top_height: cffi.float, bottom_height: cffi.float, scale: cffi.float, dstrect: ^FRect) -> cffi.bool ---

	@(link_name="SDL_RenderGeometry")
	RenderGeometry :: proc(renderer: ^Renderer, texture: ^Texture, vertices: ^Vertex, num_vertices: cffi.int, indices: ^cffi.int, num_indices: cffi.int) -> cffi.bool ---

	@(link_name="SDL_RenderGeometryRaw")
	RenderGeometryRaw :: proc(renderer: ^Renderer, texture: ^Texture, xy: ^cffi.float, xy_stride: cffi.int, color: ^FColor, color_stride: cffi.int, uv: ^cffi.float, uv_stride: cffi.int, num_vertices: cffi.int, indices: rawptr, num_indices: cffi.int, size_indices: cffi.int) -> cffi.bool ---

	@(link_name="SDL_RenderReadPixels")
	RenderReadPixels :: proc(renderer: ^Renderer, rect: ^Rect) -> ^Surface ---

	@(link_name="SDL_RenderPresent")
	RenderPresent :: proc(renderer: ^Renderer) -> cffi.bool ---

	@(link_name="SDL_DestroyTexture")
	DestroyTexture :: proc(texture: ^Texture) ---

	@(link_name="SDL_DestroyRenderer")
	DestroyRenderer :: proc(renderer: ^Renderer) ---

	@(link_name="SDL_FlushRenderer")
	FlushRenderer :: proc(renderer: ^Renderer) -> cffi.bool ---

	@(link_name="SDL_GetRenderMetalLayer")
	GetRenderMetalLayer :: proc(renderer: ^Renderer) -> rawptr ---

	@(link_name="SDL_GetRenderMetalCommandEncoder")
	GetRenderMetalCommandEncoder :: proc(renderer: ^Renderer) -> rawptr ---

	@(link_name="SDL_AddVulkanRenderSemaphores")
	AddVulkanRenderSemaphores :: proc(renderer: ^Renderer, wait_stage_mask: Uint32, wait_semaphore: Sint64, signal_semaphore: Sint64) -> cffi.bool ---

	@(link_name="SDL_SetRenderVSync")
	SetRenderVSync :: proc(renderer: ^Renderer, vsync: cffi.int) -> cffi.bool ---

	@(link_name="SDL_GetRenderVSync")
	GetRenderVSync :: proc(renderer: ^Renderer, vsync: ^cffi.int) -> cffi.bool ---

	@(link_name="SDL_RenderDebugText")
	RenderDebugText :: proc(renderer: ^Renderer, x: cffi.float, y: cffi.float, str: cstring) -> cffi.bool ---

	@(link_name="SDL_OpenTitleStorage")
	OpenTitleStorage :: proc(override: cstring, props: PropertiesID) -> ^Storage ---

	@(link_name="SDL_OpenUserStorage")
	OpenUserStorage :: proc(org: cstring, app: cstring, props: PropertiesID) -> ^Storage ---

	@(link_name="SDL_OpenFileStorage")
	OpenFileStorage :: proc(path: cstring) -> ^Storage ---

	@(link_name="SDL_OpenStorage")
	OpenStorage :: proc(iface: ^StorageInterface, userdata: rawptr) -> ^Storage ---

	@(link_name="SDL_CloseStorage")
	CloseStorage :: proc(storage: ^Storage) -> cffi.bool ---

	@(link_name="SDL_StorageReady")
	StorageReady :: proc(storage: ^Storage) -> cffi.bool ---

	@(link_name="SDL_GetStorageFileSize")
	GetStorageFileSize :: proc(storage: ^Storage, path: cstring, length: ^Uint64) -> cffi.bool ---

	@(link_name="SDL_ReadStorageFile")
	ReadStorageFile :: proc(storage: ^Storage, path: cstring, destination: rawptr, length: Uint64) -> cffi.bool ---

	@(link_name="SDL_WriteStorageFile")
	WriteStorageFile :: proc(storage: ^Storage, path: cstring, source: rawptr, length: Uint64) -> cffi.bool ---

	@(link_name="SDL_CreateStorageDirectory")
	CreateStorageDirectory :: proc(storage: ^Storage, path: cstring) -> cffi.bool ---

	@(link_name="SDL_EnumerateStorageDirectory")
	EnumerateStorageDirectory :: proc(storage: ^Storage, path: cstring, callback: EnumerateDirectoryCallback, userdata: rawptr) -> cffi.bool ---

	@(link_name="SDL_RemoveStoragePath")
	RemoveStoragePath :: proc(storage: ^Storage, path: cstring) -> cffi.bool ---

	@(link_name="SDL_RenameStoragePath")
	RenameStoragePath :: proc(storage: ^Storage, oldpath: cstring, newpath: cstring) -> cffi.bool ---

	@(link_name="SDL_CopyStorageFile")
	CopyStorageFile :: proc(storage: ^Storage, oldpath: cstring, newpath: cstring) -> cffi.bool ---

	@(link_name="SDL_GetStoragePathInfo")
	GetStoragePathInfo :: proc(storage: ^Storage, path: cstring, info: ^PathInfo) -> cffi.bool ---

	@(link_name="SDL_GetStorageSpaceRemaining")
	GetStorageSpaceRemaining :: proc(storage: ^Storage) -> Uint64 ---

	@(link_name="SDL_GlobStorageDirectory")
	GlobStorageDirectory :: proc(storage: ^Storage, path: cstring, pattern: cstring, flags: GlobFlags, count: ^cffi.int) -> ^cstring ---

	@(link_name="SDL_SetX11EventHook")
	SetX11EventHook :: proc(callback: X11EventHook, userdata: rawptr) ---

	@(link_name="SDL_IsTablet")
	IsTablet :: proc() -> cffi.bool ---

	@(link_name="SDL_IsTV")
	IsTV :: proc() -> cffi.bool ---

	@(link_name="SDL_GetSandbox")
	GetSandbox :: proc() -> Sandbox ---

	@(link_name="SDL_OnApplicationWillTerminate")
	OnApplicationWillTerminate :: proc() ---

	@(link_name="SDL_OnApplicationDidReceiveMemoryWarning")
	OnApplicationDidReceiveMemoryWarning :: proc() ---

	@(link_name="SDL_OnApplicationWillEnterBackground")
	OnApplicationWillEnterBackground :: proc() ---

	@(link_name="SDL_OnApplicationDidEnterBackground")
	OnApplicationDidEnterBackground :: proc() ---

	@(link_name="SDL_OnApplicationWillEnterForeground")
	OnApplicationWillEnterForeground :: proc() ---

	@(link_name="SDL_OnApplicationDidEnterForeground")
	OnApplicationDidEnterForeground :: proc() ---

	@(link_name="SDL_GetDateTimeLocalePreferences")
	GetDateTimeLocalePreferences :: proc(dateFormat: ^DateFormat, timeFormat: ^TimeFormat) -> cffi.bool ---

	@(link_name="SDL_GetCurrentTime")
	GetCurrentTime :: proc(ticks: ^Time) -> cffi.bool ---

	@(link_name="SDL_TimeToDateTime")
	TimeToDateTime :: proc(ticks: Time, dt: ^DateTime, localTime: cffi.bool) -> cffi.bool ---

	@(link_name="SDL_DateTimeToTime")
	DateTimeToTime :: proc(dt: ^DateTime, ticks: ^Time) -> cffi.bool ---

	@(link_name="SDL_TimeToWindows")
	TimeToWindows :: proc(ticks: Time, dwLowDateTime: ^Uint32, dwHighDateTime: ^Uint32) ---

	@(link_name="SDL_TimeFromWindows")
	TimeFromWindows :: proc(dwLowDateTime: Uint32, dwHighDateTime: Uint32) -> Time ---

	@(link_name="SDL_GetDaysInMonth")
	GetDaysInMonth :: proc(year: cffi.int, month: cffi.int) -> cffi.int ---

	@(link_name="SDL_GetDayOfYear")
	GetDayOfYear :: proc(year: cffi.int, month: cffi.int, day: cffi.int) -> cffi.int ---

	@(link_name="SDL_GetDayOfWeek")
	GetDayOfWeek :: proc(year: cffi.int, month: cffi.int, day: cffi.int) -> cffi.int ---

	@(link_name="SDL_GetTicks")
	GetTicks :: proc() -> Uint64 ---

	@(link_name="SDL_GetTicksNS")
	GetTicksNS :: proc() -> Uint64 ---

	@(link_name="SDL_GetPerformanceCounter")
	GetPerformanceCounter :: proc() -> Uint64 ---

	@(link_name="SDL_GetPerformanceFrequency")
	GetPerformanceFrequency :: proc() -> Uint64 ---

	@(link_name="SDL_Delay")
	Delay :: proc(ms: Uint32) ---

	@(link_name="SDL_DelayNS")
	DelayNS :: proc(ns: Uint64) ---

	@(link_name="SDL_DelayPrecise")
	DelayPrecise :: proc(ns: Uint64) ---

	@(link_name="SDL_AddTimer")
	AddTimer :: proc(interval: Uint32, callback: TimerCallback, userdata: rawptr) -> TimerID ---

	@(link_name="SDL_AddTimerNS")
	AddTimerNS :: proc(interval: Uint64, callback: NSTimerCallback, userdata: rawptr) -> TimerID ---

	@(link_name="SDL_RemoveTimer")
	RemoveTimer :: proc(id: TimerID) -> cffi.bool ---

	@(link_name="SDL_GetVersion")
	GetVersion :: proc() -> cffi.int ---

	@(link_name="SDL_GetRevision")
	GetRevision :: proc() -> cstring ---

	@(link_name="SDL_SetMainReady")
	SetMainReady :: proc() ---

	@(link_name="SDL_RunApp")
	RunApp :: proc(argc: cffi.int, argv: ^cstring, mainFunction: main_func, reserved: rawptr) -> cffi.int ---

	@(link_name="SDL_EnterAppMainCallbacks")
	EnterAppMainCallbacks :: proc(argc: cffi.int, argv: ^cstring, appinit: AppInit_func, appiter: AppIterate_func, appevent: AppEvent_func, appquit: AppQuit_func) -> cffi.int ---

	@(link_name="SDL_Vulkan_CreateSurface")
	Vulkan_CreateSurface :: proc(window: ^Window, instance: vk.Instance, allocator: ^vk.AllocationCallbacks, surface: ^vk.SurfaceKHR) -> cffi.bool ---

	@(link_name="SDL_WaitAndAcquireGPUSwapchainTexture")
	WaitAndAcquireGPUSwapchainTexture :: proc(command_buffer: ^GPUCommandBuffer, window: ^Window, swapchain_texture: ^^GPUTexture, swapchain_texture_width, swapchain_texture_height: ^cffi.uint32_t) -> cffi.bool ---
}

/// Sint8
Sint8 ::  cffi.int8_t

/// Uint8
Uint8 ::  cffi.uint8_t

/// Sint16
Sint16 ::  cffi.int16_t

/// Uint16
Uint16 ::  cffi.uint16_t

/// Sint32
Sint32 ::  cffi.int32_t

/// Uint32
Uint32 ::  cffi.uint32_t

/// Sint64
Sint64 ::  cffi.int64_t

/// Uint64
Uint64 ::  cffi.uint64_t

/// SDL_Time
Time ::  Sint64

/// SDL_malloc_func
malloc_func ::  proc "c" (size: cffi.size_t) -> rawptr

/// SDL_calloc_func
calloc_func ::  proc "c" (nmemb: cffi.size_t, size: cffi.size_t) -> rawptr

/// SDL_realloc_func
realloc_func ::  proc "c" (mem: rawptr, size: cffi.size_t) -> rawptr

/// SDL_free_func
free_func ::  proc "c" (mem: rawptr)

/// SDL_CompareCallback
CompareCallback ::  proc "c" (a: rawptr, b: rawptr) -> cffi.int

/// SDL_CompareCallback_r
CompareCallback_r ::  proc "c" (userdata: rawptr, a: rawptr, b: rawptr) -> cffi.int

/// SDL_iconv_t
iconv_t ::  ^iconv_data_t

/// SDL_FunctionPointer
FunctionPointer ::  proc "c" ()

/// SDL_AssertionHandler
AssertionHandler ::  proc "c" (data: ^AssertData, userdata: rawptr) -> AssertState

/// SDL_SpinLock
SpinLock ::  cffi.int

/// SDL_PropertiesID
PropertiesID ::  Uint32

/// SDL_CleanupPropertyCallback
CleanupPropertyCallback ::  proc "c" (userdata: rawptr, value: rawptr)

/// SDL_EnumeratePropertiesCallback
EnumeratePropertiesCallback ::  proc "c" (userdata: rawptr, props: PropertiesID, name: cstring)

/// SDL_ThreadID
ThreadID ::  Uint64

/// SDL_TLSID
TLSID ::  AtomicInt

/// SDL_ThreadFunction
ThreadFunction ::  proc "c" (data: rawptr) -> cffi.int

/// SDL_TLSDestructorCallback
TLSDestructorCallback ::  proc "c" (value: rawptr)

/// SDL_AudioDeviceID
AudioDeviceID ::  Uint32

/// SDL_AudioStreamCallback
AudioStreamCallback ::  proc "c" (userdata: rawptr, stream: ^AudioStream, additional_amount: cffi.int, total_amount: cffi.int)

/// SDL_AudioPostmixCallback
AudioPostmixCallback ::  proc "c" (userdata: rawptr, spec: ^AudioSpec, buffer: ^cffi.float, buflen: cffi.int)

/// SDL_BlendMode
BlendMode ::  Uint32

/// SDL_CameraID
CameraID ::  Uint32

/// SDL_ClipboardDataCallback
ClipboardDataCallback ::  proc "c" (userdata: rawptr, mime_type: cstring, size: ^cffi.size_t) -> rawptr

/// SDL_ClipboardCleanupCallback
ClipboardCleanupCallback ::  proc "c" (userdata: rawptr)

/// SDL_DisplayID
DisplayID ::  Uint32

/// SDL_WindowID
WindowID ::  Uint32

/// SDL_GLContext
GLContext ::  ^GLContextState

/// SDL_EGLDisplay
EGLDisplay ::  rawptr

/// SDL_EGLConfig
EGLConfig ::  rawptr

/// SDL_EGLSurface
EGLSurface ::  rawptr

/// SDL_EGLAttrib
EGLAttrib ::  cffi.intptr_t

/// SDL_EGLint
EGLint ::  cffi.int

/// SDL_EGLAttribArrayCallback
EGLAttribArrayCallback ::  proc "c" (userdata: rawptr) -> ^EGLAttrib

/// SDL_EGLIntArrayCallback
EGLIntArrayCallback ::  proc "c" (userdata: rawptr, display: EGLDisplay, config: EGLConfig) -> ^EGLint

/// SDL_GLProfile
GLProfile ::  Uint32

/// SDL_GLContextFlag
GLContextFlag ::  Uint32

/// SDL_GLContextReleaseFlag
GLContextReleaseFlag ::  Uint32

/// SDL_GLContextResetNotification
GLContextResetNotification ::  Uint32

/// SDL_HitTest
HitTest ::  proc "c" (win: ^Window, area: ^Point, data: rawptr) -> HitTestResult

/// SDL_DialogFileCallback
DialogFileCallback ::  proc "c" (userdata: rawptr, filelist: ^cstring, filter: cffi.int)

/// SDL_SensorID
SensorID ::  Uint32

/// SDL_JoystickID
JoystickID ::  Uint32

/// SDL_KeyboardID
KeyboardID ::  Uint32

/// SDL_MouseID
MouseID ::  Uint32

/// SDL_PenID
PenID ::  Uint32

/// SDL_TouchID
TouchID ::  Uint64

/// SDL_FingerID
FingerID ::  Uint64

/// SDL_EventFilter
EventFilter ::  proc "c" (userdata: rawptr, event: ^Event) -> cffi.bool

/// SDL_EnumerateDirectoryCallback
EnumerateDirectoryCallback ::  proc "c" (userdata: rawptr, dirname: cstring, fname: cstring) -> EnumerationResult

/// SDL_GPUShaderFormat
// GPUShaderFormat ::  Uint32

/// SDL_HapticID
HapticID ::  Uint32

/// SDL_HintCallback
HintCallback ::  proc "c" (userdata: rawptr, name: cstring, oldValue: cstring, newValue: cstring)

/// SDL_AppInit_func
AppInit_func ::  proc "c" (appstate: ^rawptr, argc: cffi.int, argv: ^cstring) -> AppResult

/// SDL_AppIterate_func
AppIterate_func ::  proc "c" (appstate: rawptr) -> AppResult

/// SDL_AppEvent_func
AppEvent_func ::  proc "c" (appstate: rawptr, event: ^Event) -> AppResult

/// SDL_AppQuit_func
AppQuit_func ::  proc "c" (appstate: rawptr, result: AppResult)

/// SDL_LogOutputFunction
LogOutputFunction ::  proc "c" (userdata: rawptr, category: cffi.int, priority: LogPriority, message: cstring)

/// SDL_MetalView
MetalView ::  rawptr

/// XEvent
XEvent ::  _XEvent

/// SDL_X11EventHook
X11EventHook ::  proc "c" (userdata: rawptr, xevent: ^XEvent) -> cffi.bool

/// SDL_TimerID
TimerID ::  Uint32

/// SDL_TimerCallback
TimerCallback ::  proc "c" (userdata: rawptr, timerID: TimerID, interval: Uint32) -> Uint32

/// SDL_NSTimerCallback
NSTimerCallback ::  proc "c" (userdata: rawptr, timerID: TimerID, interval: Uint64) -> Uint64

/// SDL_main_func
main_func ::  proc "c" (argc: cffi.int, argv: ^cstring) -> cffi.int

/// SDLX_WindowFlags
WindowFlag :: enum cffi.ulonglong {
	FULLSCREEN = 0,
	OPENGL = 1,
	OCCLUDED = 2,
	HIDDEN = 3,
	BORDERLESS = 4,
	RESIZABLE = 5,
	MINIMIZED = 6,
	MAXIMIZED = 7,
	MOUSE_GRABBED = 8,
	INPUT_FOCUS = 9,
	MOUSE_FOCUS = 10,
	EXTERNAL = 11,
	MODAL = 12,
	HIGH_PIXEL_DENSITY = 13,
	MOUSE_CAPTURE = 14,
	MOUSE_RELATIVE_MODE = 15,
	ALWAYS_ON_TOP = 16,
	UTILITY = 17,
	TOOLTIP = 18,
	POPUP_MENU = 19,
	KEYBOARD_GRABBED = 20,
	VULKAN = 28,
	METAL = 29,
	TRANSPARENT = 30,
	NOT_FOCUSABLE = 31,
}
WindowFlags :: bit_set[WindowFlag; cffi.ulonglong]

/// SDLX_MessageBoxFlags
MessageBoxFlag :: enum cffi.uint {
	ERROR = 4,
	WARNING = 5,
	INFORMATION = 6,
	BUTTONS_LEFT_TO_RIGHT = 7,
	BUTTONS_RIGHT_TO_LEFT = 8,
}
MessageBoxFlags :: bit_set[MessageBoxFlag; cffi.uint]

/// SDLX_MessageBoxButtonFlags
MessageBoxButtonFlag :: enum cffi.uint {
	RETURNKEY_DEFAULT = 0,
	ESCAPEKEY_DEFAULT = 1,
}
MessageBoxButtonFlags :: bit_set[MessageBoxButtonFlag; cffi.uint]

/// SDLX_SurfaceFlags
SurfaceFlag :: enum cffi.uint {
	PREALLOCATED = 0,
	LOCK_NEEDED = 1,
	LOCKED = 2,
	SIMD_ALIGNED = 3,
}
SurfaceFlags :: bit_set[SurfaceFlag; cffi.uint]

/// SDLX_MouseButtonFlags
MouseButtonFlag :: enum cffi.uint {
	LEFT = 1,
	MIDDLE = 2,
	RIGHT = 3,
	X1 = 4,
	X2 = 5,
}
MouseButtonFlags :: bit_set[MouseButtonFlag; cffi.uint]

/// SDLX_PenInputFlags
PenInputFlag :: enum cffi.uint {
	DOWN = 0,
	BUTTON_1 = 1,
	BUTTON_2 = 2,
	BUTTON_3 = 3,
	BUTTON_4 = 4,
	BUTTON_5 = 5,
	ERASER_TIP = 30,
}
PenInputFlags :: bit_set[PenInputFlag; cffi.uint]

/// SDLX_GlobFlags
GlobFlag :: enum cffi.uint {
	CASEINSENSITIVE = 0,
}
GlobFlags :: bit_set[GlobFlag; cffi.uint]

/// SDLX_GPUTextureUsageFlags
GPUTextureUsageFlag :: enum cffi.uint {
	SAMPLER = 0,
	COLOR_TARGET = 1,
	DEPTH_STENCIL_TARGET = 2,
	GRAPHICS_STORAGE_READ = 3,
	COMPUTE_STORAGE_READ = 4,
	COMPUTE_STORAGE_WRITE = 5,
	COMPUTE_STORAGE_SIMULTANEOUS_READ_WRITE = 6,
}
GPUTextureUsageFlags :: bit_set[GPUTextureUsageFlag; cffi.uint]

/// SDLX_GPUBufferUsageFlags
GPUBufferUsageFlag :: enum cffi.uint {
	VERTEX = 0,
	INDEX = 1,
	INDIRECT = 2,
	GRAPHICS_STORAGE_READ = 3,
	COMPUTE_STORAGE_READ = 4,
	COMPUTE_STORAGE_WRITE = 5,
}
GPUBufferUsageFlags :: bit_set[GPUBufferUsageFlag; cffi.uint]

/// SDLX_GPUColorComponentFlags
GPUColorComponentFlag :: enum cffi.uchar {
	R = 0,
	G = 1,
	B = 2,
	A = 3,
}
GPUColorComponentFlags :: bit_set[GPUColorComponentFlag; cffi.uchar]

/// SDLX_InitFlags
InitFlag :: enum cffi.uint {
	AUDIO = 4,
	VIDEO = 5,
	JOYSTICK = 9,
	HAPTIC = 12,
	GAMEPAD = 13,
	EVENTS = 14,
	SENSOR = 15,
	CAMERA = 16,
}
InitFlags :: bit_set[InitFlag; cffi.uint]

/// SDLX_Keycode
Keycode :: enum cffi.uint {
	UNKNOWN = 0,
	RETURN = 13,
	ESCAPE = 27,
	BACKSPACE = 8,
	TAB = 9,
	SPACE = 32,
	EXCLAIM = 33,
	DBLAPOSTROPHE = 34,
	HASH = 35,
	DOLLAR = 36,
	PERCENT = 37,
	AMPERSAND = 38,
	APOSTROPHE = 39,
	LEFTPAREN = 40,
	RIGHTPAREN = 41,
	ASTERISK = 42,
	PLUS = 43,
	COMMA = 44,
	MINUS = 45,
	PERIOD = 46,
	SLASH = 47,
	_0 = 48,
	_1 = 49,
	_2 = 50,
	_3 = 51,
	_4 = 52,
	_5 = 53,
	_6 = 54,
	_7 = 55,
	_8 = 56,
	_9 = 57,
	COLON = 58,
	SEMICOLON = 59,
	LESS = 60,
	EQUALS = 61,
	GREATER = 62,
	QUESTION = 63,
	AT = 64,
	LEFTBRACKET = 91,
	BACKSLASH = 92,
	RIGHTBRACKET = 93,
	CARET = 94,
	UNDERSCORE = 95,
	GRAVE = 96,
	A = 97,
	B = 98,
	C = 99,
	D = 100,
	E = 101,
	F = 102,
	G = 103,
	H = 104,
	I = 105,
	J = 106,
	K = 107,
	L = 108,
	M = 109,
	N = 110,
	O = 111,
	P = 112,
	Q = 113,
	R = 114,
	S = 115,
	T = 116,
	U = 117,
	V = 118,
	W = 119,
	X = 120,
	Y = 121,
	Z = 122,
	LEFTBRACE = 123,
	PIPE = 124,
	RIGHTBRACE = 125,
	TILDE = 126,
	DELETE = 127,
	PLUSMINUS = 177,
	CAPSLOCK = 1073741881,
	F1 = 1073741882,
	F2 = 1073741883,
	F3 = 1073741884,
	F4 = 1073741885,
	F5 = 1073741886,
	F6 = 1073741887,
	F7 = 1073741888,
	F8 = 1073741889,
	F9 = 1073741890,
	F10 = 1073741891,
	F11 = 1073741892,
	F12 = 1073741893,
	PRINTSCREEN = 1073741894,
	SCROLLLOCK = 1073741895,
	PAUSE = 1073741896,
	INSERT = 1073741897,
	HOME = 1073741898,
	PAGEUP = 1073741899,
	END = 1073741901,
	PAGEDOWN = 1073741902,
	RIGHT = 1073741903,
	LEFT = 1073741904,
	DOWN = 1073741905,
	UP = 1073741906,
	NUMLOCKCLEAR = 1073741907,
	KP_DIVIDE = 1073741908,
	KP_MULTIPLY = 1073741909,
	KP_MINUS = 1073741910,
	KP_PLUS = 1073741911,
	KP_ENTER = 1073741912,
	KP_1 = 1073741913,
	KP_2 = 1073741914,
	KP_3 = 1073741915,
	KP_4 = 1073741916,
	KP_5 = 1073741917,
	KP_6 = 1073741918,
	KP_7 = 1073741919,
	KP_8 = 1073741920,
	KP_9 = 1073741921,
	KP_0 = 1073741922,
	KP_PERIOD = 1073741923,
	APPLICATION = 1073741925,
	POWER = 1073741926,
	KP_EQUALS = 1073741927,
	F13 = 1073741928,
	F14 = 1073741929,
	F15 = 1073741930,
	F16 = 1073741931,
	F17 = 1073741932,
	F18 = 1073741933,
	F19 = 1073741934,
	F20 = 1073741935,
	F21 = 1073741936,
	F22 = 1073741937,
	F23 = 1073741938,
	F24 = 1073741939,
	EXECUTE = 1073741940,
	HELP = 1073741941,
	MENU = 1073741942,
	SELECT = 1073741943,
	STOP = 1073741944,
	AGAIN = 1073741945,
	UNDO = 1073741946,
	CUT = 1073741947,
	COPY = 1073741948,
	PASTE = 1073741949,
	FIND = 1073741950,
	MUTE = 1073741951,
	VOLUMEUP = 1073741952,
	VOLUMEDOWN = 1073741953,
	KP_COMMA = 1073741957,
	KP_EQUALSAS400 = 1073741958,
	ALTERASE = 1073741977,
	SYSREQ = 1073741978,
	CANCEL = 1073741979,
	CLEAR = 1073741980,
	PRIOR = 1073741981,
	RETURN2 = 1073741982,
	SEPARATOR = 1073741983,
	OUT = 1073741984,
	OPER = 1073741985,
	CLEARAGAIN = 1073741986,
	CRSEL = 1073741987,
	EXSEL = 1073741988,
	KP_00 = 1073742000,
	KP_000 = 1073742001,
	THOUSANDSSEPARATOR = 1073742002,
	DECIMALSEPARATOR = 1073742003,
	CURRENCYUNIT = 1073742004,
	CURRENCYSUBUNIT = 1073742005,
	KP_LEFTPAREN = 1073742006,
	KP_RIGHTPAREN = 1073742007,
	KP_LEFTBRACE = 1073742008,
	KP_RIGHTBRACE = 1073742009,
	KP_TAB = 1073742010,
	KP_BACKSPACE = 1073742011,
	KP_A = 1073742012,
	KP_B = 1073742013,
	KP_C = 1073742014,
	KP_D = 1073742015,
	KP_E = 1073742016,
	KP_F = 1073742017,
	KP_XOR = 1073742018,
	KP_POWER = 1073742019,
	KP_PERCENT = 1073742020,
	KP_LESS = 1073742021,
	KP_GREATER = 1073742022,
	KP_AMPERSAND = 1073742023,
	KP_DBLAMPERSAND = 1073742024,
	KP_VERTICALBAR = 1073742025,
	KP_DBLVERTICALBAR = 1073742026,
	KP_COLON = 1073742027,
	KP_HASH = 1073742028,
	KP_SPACE = 1073742029,
	KP_AT = 1073742030,
	KP_EXCLAM = 1073742031,
	KP_MEMSTORE = 1073742032,
	KP_MEMRECALL = 1073742033,
	KP_MEMCLEAR = 1073742034,
	KP_MEMADD = 1073742035,
	KP_MEMSUBTRACT = 1073742036,
	KP_MEMMULTIPLY = 1073742037,
	KP_MEMDIVIDE = 1073742038,
	KP_PLUSMINUS = 1073742039,
	KP_CLEAR = 1073742040,
	KP_CLEARENTRY = 1073742041,
	KP_BINARY = 1073742042,
	KP_OCTAL = 1073742043,
	KP_DECIMAL = 1073742044,
	KP_HEXADECIMAL = 1073742045,
	LCTRL = 1073742048,
	LSHIFT = 1073742049,
	LALT = 1073742050,
	LGUI = 1073742051,
	RCTRL = 1073742052,
	RSHIFT = 1073742053,
	RALT = 1073742054,
	RGUI = 1073742055,
	MODE = 1073742081,
	SLEEP = 1073742082,
	WAKE = 1073742083,
	CHANNEL_INCREMENT = 1073742084,
	CHANNEL_DECREMENT = 1073742085,
	MEDIA_PLAY = 1073742086,
	MEDIA_PAUSE = 1073742087,
	MEDIA_RECORD = 1073742088,
	MEDIA_FAST_FORWARD = 1073742089,
	MEDIA_REWIND = 1073742090,
	MEDIA_NEXT_TRACK = 1073742091,
	MEDIA_PREVIOUS_TRACK = 1073742092,
	MEDIA_STOP = 1073742093,
	MEDIA_EJECT = 1073742094,
	MEDIA_PLAY_PAUSE = 1073742095,
	MEDIA_SELECT = 1073742096,
	AC_NEW = 1073742097,
	AC_OPEN = 1073742098,
	AC_CLOSE = 1073742099,
	AC_EXIT = 1073742100,
	AC_SAVE = 1073742101,
	AC_PRINT = 1073742102,
	AC_PROPERTIES = 1073742103,
	AC_SEARCH = 1073742104,
	AC_HOME = 1073742105,
	AC_BACK = 1073742106,
	AC_FORWARD = 1073742107,
	AC_STOP = 1073742108,
	AC_REFRESH = 1073742109,
	AC_BOOKMARKS = 1073742110,
	SOFTLEFT = 1073742111,
	SOFTRIGHT = 1073742112,
	CALL = 1073742113,
	ENDCALL = 1073742114,
}

/// SDLX_Keymod
KeymodFlag :: enum cffi.ushort {
	LSHIFT = 0,
	RSHIFT = 1,
	LCTRL = 6,
	RCTRL = 7,
	LALT = 8,
	RALT = 9,
	LGUI = 10,
	RGUI = 11,
	NUM = 12,
	CAPS = 13,
	MODE = 14,
	SCROLL = 15,
}
Keymod :: bit_set[KeymodFlag; cffi.ushort]

/// SDL_DUMMY_ENUM
DUMMY_ENUM :: enum cffi.uint {
	VALUE = 0,
}

/// SDL_Scancode
Scancode :: enum cffi.uint {
	UNKNOWN = 0,
	A = 4,
	B = 5,
	C = 6,
	D = 7,
	E = 8,
	F = 9,
	G = 10,
	H = 11,
	I = 12,
	J = 13,
	K = 14,
	L = 15,
	M = 16,
	N = 17,
	O = 18,
	P = 19,
	Q = 20,
	R = 21,
	S = 22,
	T = 23,
	U = 24,
	V = 25,
	W = 26,
	X = 27,
	Y = 28,
	Z = 29,
	_1 = 30,
	_2 = 31,
	_3 = 32,
	_4 = 33,
	_5 = 34,
	_6 = 35,
	_7 = 36,
	_8 = 37,
	_9 = 38,
	_0 = 39,
	RETURN = 40,
	ESCAPE = 41,
	BACKSPACE = 42,
	TAB = 43,
	SPACE = 44,
	MINUS = 45,
	EQUALS = 46,
	LEFTBRACKET = 47,
	RIGHTBRACKET = 48,
	BACKSLASH = 49,
	NONUSHASH = 50,
	SEMICOLON = 51,
	APOSTROPHE = 52,
	GRAVE = 53,
	COMMA = 54,
	PERIOD = 55,
	SLASH = 56,
	CAPSLOCK = 57,
	F1 = 58,
	F2 = 59,
	F3 = 60,
	F4 = 61,
	F5 = 62,
	F6 = 63,
	F7 = 64,
	F8 = 65,
	F9 = 66,
	F10 = 67,
	F11 = 68,
	F12 = 69,
	PRINTSCREEN = 70,
	SCROLLLOCK = 71,
	PAUSE = 72,
	INSERT = 73,
	HOME = 74,
	PAGEUP = 75,
	DELETE = 76,
	END = 77,
	PAGEDOWN = 78,
	RIGHT = 79,
	LEFT = 80,
	DOWN = 81,
	UP = 82,
	NUMLOCKCLEAR = 83,
	KP_DIVIDE = 84,
	KP_MULTIPLY = 85,
	KP_MINUS = 86,
	KP_PLUS = 87,
	KP_ENTER = 88,
	KP_1 = 89,
	KP_2 = 90,
	KP_3 = 91,
	KP_4 = 92,
	KP_5 = 93,
	KP_6 = 94,
	KP_7 = 95,
	KP_8 = 96,
	KP_9 = 97,
	KP_0 = 98,
	KP_PERIOD = 99,
	NONUSBACKSLASH = 100,
	APPLICATION = 101,
	POWER = 102,
	KP_EQUALS = 103,
	F13 = 104,
	F14 = 105,
	F15 = 106,
	F16 = 107,
	F17 = 108,
	F18 = 109,
	F19 = 110,
	F20 = 111,
	F21 = 112,
	F22 = 113,
	F23 = 114,
	F24 = 115,
	EXECUTE = 116,
	HELP = 117,
	MENU = 118,
	SELECT = 119,
	STOP = 120,
	AGAIN = 121,
	UNDO = 122,
	CUT = 123,
	COPY = 124,
	PASTE = 125,
	FIND = 126,
	MUTE = 127,
	VOLUMEUP = 128,
	VOLUMEDOWN = 129,
	KP_COMMA = 133,
	KP_EQUALSAS400 = 134,
	INTERNATIONAL1 = 135,
	INTERNATIONAL2 = 136,
	INTERNATIONAL3 = 137,
	INTERNATIONAL4 = 138,
	INTERNATIONAL5 = 139,
	INTERNATIONAL6 = 140,
	INTERNATIONAL7 = 141,
	INTERNATIONAL8 = 142,
	INTERNATIONAL9 = 143,
	LANG1 = 144,
	LANG2 = 145,
	LANG3 = 146,
	LANG4 = 147,
	LANG5 = 148,
	LANG6 = 149,
	LANG7 = 150,
	LANG8 = 151,
	LANG9 = 152,
	ALTERASE = 153,
	SYSREQ = 154,
	CANCEL = 155,
	CLEAR = 156,
	PRIOR = 157,
	RETURN2 = 158,
	SEPARATOR = 159,
	OUT = 160,
	OPER = 161,
	CLEARAGAIN = 162,
	CRSEL = 163,
	EXSEL = 164,
	KP_00 = 176,
	KP_000 = 177,
	THOUSANDSSEPARATOR = 178,
	DECIMALSEPARATOR = 179,
	CURRENCYUNIT = 180,
	CURRENCYSUBUNIT = 181,
	KP_LEFTPAREN = 182,
	KP_RIGHTPAREN = 183,
	KP_LEFTBRACE = 184,
	KP_RIGHTBRACE = 185,
	KP_TAB = 186,
	KP_BACKSPACE = 187,
	KP_A = 188,
	KP_B = 189,
	KP_C = 190,
	KP_D = 191,
	KP_E = 192,
	KP_F = 193,
	KP_XOR = 194,
	KP_POWER = 195,
	KP_PERCENT = 196,
	KP_LESS = 197,
	KP_GREATER = 198,
	KP_AMPERSAND = 199,
	KP_DBLAMPERSAND = 200,
	KP_VERTICALBAR = 201,
	KP_DBLVERTICALBAR = 202,
	KP_COLON = 203,
	KP_HASH = 204,
	KP_SPACE = 205,
	KP_AT = 206,
	KP_EXCLAM = 207,
	KP_MEMSTORE = 208,
	KP_MEMRECALL = 209,
	KP_MEMCLEAR = 210,
	KP_MEMADD = 211,
	KP_MEMSUBTRACT = 212,
	KP_MEMMULTIPLY = 213,
	KP_MEMDIVIDE = 214,
	KP_PLUSMINUS = 215,
	KP_CLEAR = 216,
	KP_CLEARENTRY = 217,
	KP_BINARY = 218,
	KP_OCTAL = 219,
	KP_DECIMAL = 220,
	KP_HEXADECIMAL = 221,
	LCTRL = 224,
	LSHIFT = 225,
	LALT = 226,
	LGUI = 227,
	RCTRL = 228,
	RSHIFT = 229,
	RALT = 230,
	RGUI = 231,
	MODE = 257,
	SLEEP = 258,
	WAKE = 259,
	CHANNEL_INCREMENT = 260,
	CHANNEL_DECREMENT = 261,
	MEDIA_PLAY = 262,
	MEDIA_PAUSE = 263,
	MEDIA_RECORD = 264,
	MEDIA_FAST_FORWARD = 265,
	MEDIA_REWIND = 266,
	MEDIA_NEXT_TRACK = 267,
	MEDIA_PREVIOUS_TRACK = 268,
	MEDIA_STOP = 269,
	MEDIA_EJECT = 270,
	MEDIA_PLAY_PAUSE = 271,
	MEDIA_SELECT = 272,
	AC_NEW = 273,
	AC_OPEN = 274,
	AC_CLOSE = 275,
	AC_EXIT = 276,
	AC_SAVE = 277,
	AC_PRINT = 278,
	AC_PROPERTIES = 279,
	AC_SEARCH = 280,
	AC_HOME = 281,
	AC_BACK = 282,
	AC_FORWARD = 283,
	AC_STOP = 284,
	AC_REFRESH = 285,
	AC_BOOKMARKS = 286,
	SOFTLEFT = 287,
	SOFTRIGHT = 288,
	CALL = 289,
	ENDCALL = 290,
	RESERVED = 400,
	COUNT = 512,
}

/// SDL_AssertState
AssertState :: enum cffi.uint {
	RETRY = 0,
	BREAK = 1,
	ABORT = 2,
	IGNORE = 3,
	ALWAYS_IGNORE = 4,
}

/// SDL_PropertyType
PropertyType :: enum cffi.uint {
	INVALID = 0,
	POINTER = 1,
	STRING = 2,
	NUMBER = 3,
	FLOAT = 4,
	BOOLEAN = 5,
}

/// SDL_ThreadPriority
ThreadPriority :: enum cffi.uint {
	LOW = 0,
	NORMAL = 1,
	HIGH = 2,
	TIME_CRITICAL = 3,
}

/// SDL_InitStatus
InitStatus :: enum cffi.uint {
	UNINITIALIZED = 0,
	INITIALIZING = 1,
	INITIALIZED = 2,
	UNINITIALIZING = 3,
}

/// SDL_IOStatus
IOStatus :: enum cffi.uint {
	READY = 0,
	ERROR = 1,
	EOF = 2,
	NOT_READY = 3,
	READONLY = 4,
	WRITEONLY = 5,
}

/// SDL_IOWhence
IOWhence :: enum cffi.uint {
	SET = 0,
	CUR = 1,
	END = 2,
}

/// SDL_AudioFormat
AudioFormat :: enum cffi.uint {
	UNKNOWN = 0,
	U8 = 8,
	S8 = 32776,
	S16LE = 32784,
	S16BE = 36880,
	S32LE = 32800,
	S32BE = 36896,
	F32LE = 33056,
	F32BE = 37152,
	S16 = 32784,
	S32 = 32800,
	F32 = 33056,
}

/// SDL_BlendOperation
BlendOperation :: enum cffi.uint {
	ADD = 1,
	SUBTRACT = 2,
	REV_SUBTRACT = 3,
	MINIMUM = 4,
	MAXIMUM = 5,
}

/// SDL_BlendFactor
BlendFactor :: enum cffi.uint {
	ZERO = 1,
	ONE = 2,
	SRC_COLOR = 3,
	ONE_MINUS_SRC_COLOR = 4,
	SRC_ALPHA = 5,
	ONE_MINUS_SRC_ALPHA = 6,
	DST_COLOR = 7,
	ONE_MINUS_DST_COLOR = 8,
	DST_ALPHA = 9,
	ONE_MINUS_DST_ALPHA = 10,
}

/// SDL_PixelType
PixelType :: enum cffi.uint {
	UNKNOWN = 0,
	INDEX1 = 1,
	INDEX4 = 2,
	INDEX8 = 3,
	PACKED8 = 4,
	PACKED16 = 5,
	PACKED32 = 6,
	ARRAYU8 = 7,
	ARRAYU16 = 8,
	ARRAYU32 = 9,
	ARRAYF16 = 10,
	ARRAYF32 = 11,
	INDEX2 = 12,
}

/// SDL_BitmapOrder
BitmapOrder :: enum cffi.uint {
	NONE = 0,
	_4321 = 1,
	_1234 = 2,
}

/// SDL_PackedOrder
PackedOrder :: enum cffi.uint {
	NONE = 0,
	XRGB = 1,
	RGBX = 2,
	ARGB = 3,
	RGBA = 4,
	XBGR = 5,
	BGRX = 6,
	ABGR = 7,
	BGRA = 8,
}

/// SDL_ArrayOrder
ArrayOrder :: enum cffi.uint {
	NONE = 0,
	RGB = 1,
	RGBA = 2,
	ARGB = 3,
	BGR = 4,
	BGRA = 5,
	ABGR = 6,
}

/// SDL_PackedLayout
PackedLayout :: enum cffi.uint {
	NONE = 0,
	_332 = 1,
	_4444 = 2,
	_1555 = 3,
	_5551 = 4,
	_565 = 5,
	_8888 = 6,
	_2101010 = 7,
	_1010102 = 8,
}

/// SDL_PixelFormat
PixelFormat :: enum cffi.uint {
	UNKNOWN = 0,
	INDEX1LSB = 286261504,
	INDEX1MSB = 287310080,
	INDEX2LSB = 470811136,
	INDEX2MSB = 471859712,
	INDEX4LSB = 303039488,
	INDEX4MSB = 304088064,
	INDEX8 = 318769153,
	RGB332 = 336660481,
	XRGB4444 = 353504258,
	XBGR4444 = 357698562,
	XRGB1555 = 353570562,
	XBGR1555 = 357764866,
	ARGB4444 = 355602434,
	RGBA4444 = 356651010,
	ABGR4444 = 359796738,
	BGRA4444 = 360845314,
	ARGB1555 = 355667970,
	RGBA5551 = 356782082,
	ABGR1555 = 359862274,
	BGRA5551 = 360976386,
	RGB565 = 353701890,
	BGR565 = 357896194,
	RGB24 = 386930691,
	BGR24 = 390076419,
	XRGB8888 = 370546692,
	RGBX8888 = 371595268,
	XBGR8888 = 374740996,
	BGRX8888 = 375789572,
	ARGB8888 = 372645892,
	RGBA8888 = 373694468,
	ABGR8888 = 376840196,
	BGRA8888 = 377888772,
	XRGB2101010 = 370614276,
	XBGR2101010 = 374808580,
	ARGB2101010 = 372711428,
	ABGR2101010 = 376905732,
	RGB48 = 403714054,
	BGR48 = 406859782,
	RGBA64 = 404766728,
	ARGB64 = 405815304,
	BGRA64 = 407912456,
	ABGR64 = 408961032,
	RGB48_FLOAT = 437268486,
	BGR48_FLOAT = 440414214,
	RGBA64_FLOAT = 438321160,
	ARGB64_FLOAT = 439369736,
	BGRA64_FLOAT = 441466888,
	ABGR64_FLOAT = 442515464,
	RGB96_FLOAT = 454057996,
	BGR96_FLOAT = 457203724,
	RGBA128_FLOAT = 455114768,
	ARGB128_FLOAT = 456163344,
	BGRA128_FLOAT = 458260496,
	ABGR128_FLOAT = 459309072,
	YV12 = 842094169,
	IYUV = 1448433993,
	YUY2 = 844715353,
	UYVY = 1498831189,
	YVYU = 1431918169,
	NV12 = 842094158,
	NV21 = 825382478,
	P010 = 808530000,
	EXTERNAL_OES = 542328143,
	RGBA32 = 376840196,
	ARGB32 = 377888772,
	BGRA32 = 372645892,
	ABGR32 = 373694468,
	RGBX32 = 374740996,
	XRGB32 = 375789572,
	BGRX32 = 370546692,
	XBGR32 = 371595268,
}

/// SDL_ColorType
ColorType :: enum cffi.uint {
	UNKNOWN = 0,
	RGB = 1,
	YCBCR = 2,
}

/// SDL_ColorRange
ColorRange :: enum cffi.uint {
	UNKNOWN = 0,
	LIMITED = 1,
	FULL = 2,
}

/// SDL_ColorPrimaries
ColorPrimaries :: enum cffi.uint {
	UNKNOWN = 0,
	BT709 = 1,
	UNSPECIFIED = 2,
	BT470M = 4,
	BT470BG = 5,
	BT601 = 6,
	SMPTE240 = 7,
	GENERIC_FILM = 8,
	BT2020 = 9,
	XYZ = 10,
	SMPTE431 = 11,
	SMPTE432 = 12,
	EBU3213 = 22,
	CUSTOM = 31,
}

/// SDL_TransferCharacteristics
TransferCharacteristics :: enum cffi.uint {
	UNKNOWN = 0,
	BT709 = 1,
	UNSPECIFIED = 2,
	GAMMA22 = 4,
	GAMMA28 = 5,
	BT601 = 6,
	SMPTE240 = 7,
	LINEAR = 8,
	LOG100 = 9,
	LOG100_SQRT10 = 10,
	IEC61966 = 11,
	BT1361 = 12,
	SRGB = 13,
	BT2020_10BIT = 14,
	BT2020_12BIT = 15,
	PQ = 16,
	SMPTE428 = 17,
	HLG = 18,
	CUSTOM = 31,
}

/// SDL_MatrixCoefficients
MatrixCoefficients :: enum cffi.uint {
	IDENTITY = 0,
	BT709 = 1,
	UNSPECIFIED = 2,
	FCC = 4,
	BT470BG = 5,
	BT601 = 6,
	SMPTE240 = 7,
	YCGCO = 8,
	BT2020_NCL = 9,
	BT2020_CL = 10,
	SMPTE2085 = 11,
	CHROMA_DERIVED_NCL = 12,
	CHROMA_DERIVED_CL = 13,
	ICTCP = 14,
	CUSTOM = 31,
}

/// SDL_ChromaLocation
ChromaLocation :: enum cffi.uint {
	NONE = 0,
	LEFT = 1,
	CENTER = 2,
	TOPLEFT = 3,
}

/// SDL_Colorspace
Colorspace :: enum cffi.uint {
	UNKNOWN = 0,
	SRGB = 301991328,
	SRGB_LINEAR = 301991168,
	HDR10 = 301999616,
	JPEG = 570426566,
	BT601_LIMITED = 554703046,
	BT601_FULL = 571480262,
	BT709_LIMITED = 554697761,
	BT709_FULL = 571474977,
	BT2020_LIMITED = 554706441,
	BT2020_FULL = 571483657,
	RGB_DEFAULT = 301991328,
	YUV_DEFAULT = 570426566,
}

/// SDL_ScaleMode
ScaleMode :: enum cffi.uint {
	NEAREST = 0,
	LINEAR = 1,
}

/// SDL_FlipMode
FlipMode :: enum cffi.uint {
	NONE = 0,
	HORIZONTAL = 1,
	VERTICAL = 2,
}

/// SDL_CameraPosition
CameraPosition :: enum cffi.uint {
	UNKNOWN = 0,
	FRONT_FACING = 1,
	BACK_FACING = 2,
}

/// SDL_SystemTheme
SystemTheme :: enum cffi.uint {
	UNKNOWN = 0,
	LIGHT = 1,
	DARK = 2,
}

/// SDL_DisplayOrientation
DisplayOrientation :: enum cffi.uint {
	UNKNOWN = 0,
	LANDSCAPE = 1,
	LANDSCAPE_FLIPPED = 2,
	PORTRAIT = 3,
	PORTRAIT_FLIPPED = 4,
}

/// SDL_FlashOperation
FlashOperation :: enum cffi.uint {
	CANCEL = 0,
	BRIEFLY = 1,
	UNTIL_FOCUSED = 2,
}

/// SDL_GLAttr
GLAttr :: enum cffi.uint {
	RED_SIZE = 0,
	GREEN_SIZE = 1,
	BLUE_SIZE = 2,
	ALPHA_SIZE = 3,
	BUFFER_SIZE = 4,
	DOUBLEBUFFER = 5,
	DEPTH_SIZE = 6,
	STENCIL_SIZE = 7,
	ACCUM_RED_SIZE = 8,
	ACCUM_GREEN_SIZE = 9,
	ACCUM_BLUE_SIZE = 10,
	ACCUM_ALPHA_SIZE = 11,
	STEREO = 12,
	MULTISAMPLEBUFFERS = 13,
	MULTISAMPLESAMPLES = 14,
	ACCELERATED_VISUAL = 15,
	RETAINED_BACKING = 16,
	CONTEXT_MAJOR_VERSION = 17,
	CONTEXT_MINOR_VERSION = 18,
	CONTEXT_FLAGS = 19,
	CONTEXT_PROFILE_MASK = 20,
	SHARE_WITH_CURRENT_CONTEXT = 21,
	FRAMEBUFFER_SRGB_CAPABLE = 22,
	CONTEXT_RELEASE_BEHAVIOR = 23,
	CONTEXT_RESET_NOTIFICATION = 24,
	CONTEXT_NO_ERROR = 25,
	FLOATBUFFERS = 26,
	EGL_PLATFORM = 27,
}

/// SDL_HitTestResult
HitTestResult :: enum cffi.uint {
	NORMAL = 0,
	DRAGGABLE = 1,
	RESIZE_TOPLEFT = 2,
	RESIZE_TOP = 3,
	RESIZE_TOPRIGHT = 4,
	RESIZE_RIGHT = 5,
	RESIZE_BOTTOMRIGHT = 6,
	RESIZE_BOTTOM = 7,
	RESIZE_BOTTOMLEFT = 8,
	RESIZE_LEFT = 9,
}

/// SDL_PowerState
PowerState :: enum cffi.int {
	ERROR = -1,
	UNKNOWN = 0,
	ON_BATTERY = 1,
	NO_BATTERY = 2,
	CHARGING = 3,
	CHARGED = 4,
}

/// SDL_SensorType
SensorType :: enum cffi.int {
	INVALID = -1,
	UNKNOWN = 0,
	ACCEL = 1,
	GYRO = 2,
	ACCEL_L = 3,
	GYRO_L = 4,
	ACCEL_R = 5,
	GYRO_R = 6,
}

/// SDL_JoystickType
JoystickType :: enum cffi.uint {
	UNKNOWN = 0,
	GAMEPAD = 1,
	WHEEL = 2,
	ARCADE_STICK = 3,
	FLIGHT_STICK = 4,
	DANCE_PAD = 5,
	GUITAR = 6,
	DRUM_KIT = 7,
	ARCADE_PAD = 8,
	THROTTLE = 9,
	COUNT = 10,
}

/// SDL_JoystickConnectionState
JoystickConnectionState :: enum cffi.int {
	INVALID = -1,
	UNKNOWN = 0,
	WIRED = 1,
	WIRELESS = 2,
}

/// SDL_GamepadType
GamepadType :: enum cffi.uint {
	UNKNOWN = 0,
	STANDARD = 1,
	XBOX360 = 2,
	XBOXONE = 3,
	PS3 = 4,
	PS4 = 5,
	PS5 = 6,
	NINTENDO_SWITCH_PRO = 7,
	NINTENDO_SWITCH_JOYCON_LEFT = 8,
	NINTENDO_SWITCH_JOYCON_RIGHT = 9,
	NINTENDO_SWITCH_JOYCON_PAIR = 10,
	COUNT = 11,
}

/// SDL_GamepadButton
GamepadButton :: enum cffi.int {
	INVALID = -1,
	SOUTH = 0,
	EAST = 1,
	WEST = 2,
	NORTH = 3,
	BACK = 4,
	GUIDE = 5,
	START = 6,
	LEFT_STICK = 7,
	RIGHT_STICK = 8,
	LEFT_SHOULDER = 9,
	RIGHT_SHOULDER = 10,
	DPAD_UP = 11,
	DPAD_DOWN = 12,
	DPAD_LEFT = 13,
	DPAD_RIGHT = 14,
	MISC1 = 15,
	RIGHT_PADDLE1 = 16,
	LEFT_PADDLE1 = 17,
	RIGHT_PADDLE2 = 18,
	LEFT_PADDLE2 = 19,
	TOUCHPAD = 20,
	MISC2 = 21,
	MISC3 = 22,
	MISC4 = 23,
	MISC5 = 24,
	MISC6 = 25,
	COUNT = 26,
}

/// SDL_GamepadButtonLabel
GamepadButtonLabel :: enum cffi.uint {
	UNKNOWN = 0,
	A = 1,
	B = 2,
	X = 3,
	Y = 4,
	CROSS = 5,
	CIRCLE = 6,
	SQUARE = 7,
	TRIANGLE = 8,
}

/// SDL_GamepadAxis
GamepadAxis :: enum cffi.int {
	INVALID = -1,
	LEFTX = 0,
	LEFTY = 1,
	RIGHTX = 2,
	RIGHTY = 3,
	LEFT_TRIGGER = 4,
	RIGHT_TRIGGER = 5,
	COUNT = 6,
}

/// SDL_GamepadBindingType
GamepadBindingType :: enum cffi.uint {
	NONE = 0,
	BUTTON = 1,
	AXIS = 2,
	HAT = 3,
}

/// SDL_TextInputType
TextInputType :: enum cffi.uint {
	TEXT = 0,
	TEXT_NAME = 1,
	TEXT_EMAIL = 2,
	TEXT_USERNAME = 3,
	TEXT_PASSWORD_HIDDEN = 4,
	TEXT_PASSWORD_VISIBLE = 5,
	NUMBER = 6,
	NUMBER_PASSWORD_HIDDEN = 7,
	NUMBER_PASSWORD_VISIBLE = 8,
}

/// SDL_Capitalization
Capitalization :: enum cffi.uint {
	NONE = 0,
	SENTENCES = 1,
	WORDS = 2,
	LETTERS = 3,
}

/// SDL_SystemCursor
SystemCursor :: enum cffi.uint {
	DEFAULT = 0,
	TEXT = 1,
	WAIT = 2,
	CROSSHAIR = 3,
	PROGRESS = 4,
	NWSE_RESIZE = 5,
	NESW_RESIZE = 6,
	EW_RESIZE = 7,
	NS_RESIZE = 8,
	MOVE = 9,
	NOT_ALLOWED = 10,
	POINTER = 11,
	NW_RESIZE = 12,
	N_RESIZE = 13,
	NE_RESIZE = 14,
	E_RESIZE = 15,
	SE_RESIZE = 16,
	S_RESIZE = 17,
	SW_RESIZE = 18,
	W_RESIZE = 19,
	COUNT = 20,
}

/// SDL_MouseWheelDirection
MouseWheelDirection :: enum cffi.uint {
	NORMAL = 0,
	FLIPPED = 1,
}

/// SDL_PenAxis
PenAxis :: enum cffi.uint {
	PRESSURE = 0,
	XTILT = 1,
	YTILT = 2,
	DISTANCE = 3,
	ROTATION = 4,
	SLIDER = 5,
	TANGENTIAL_PRESSURE = 6,
	COUNT = 7,
}

/// SDL_TouchDeviceType
TouchDeviceType :: enum cffi.int {
	INVALID = -1,
	DIRECT = 0,
	INDIRECT_ABSOLUTE = 1,
	INDIRECT_RELATIVE = 2,
}

/// SDL_EventType
EventType :: enum cffi.uint {
	FIRST = 0,
	QUIT = 256,
	TERMINATING = 257,
	LOW_MEMORY = 258,
	WILL_ENTER_BACKGROUND = 259,
	DID_ENTER_BACKGROUND = 260,
	WILL_ENTER_FOREGROUND = 261,
	DID_ENTER_FOREGROUND = 262,
	LOCALE_CHANGED = 263,
	SYSTEM_THEME_CHANGED = 264,
	DISPLAY_ORIENTATION = 337,
	DISPLAY_ADDED = 338,
	DISPLAY_REMOVED = 339,
	DISPLAY_MOVED = 340,
	DISPLAY_DESKTOP_MODE_CHANGED = 341,
	DISPLAY_CURRENT_MODE_CHANGED = 342,
	DISPLAY_CONTENT_SCALE_CHANGED = 343,
	DISPLAY_FIRST = 337,
	DISPLAY_LAST = 343,
	WINDOW_SHOWN = 514,
	WINDOW_HIDDEN = 515,
	WINDOW_EXPOSED = 516,
	WINDOW_MOVED = 517,
	WINDOW_RESIZED = 518,
	WINDOW_PIXEL_SIZE_CHANGED = 519,
	WINDOW_METAL_VIEW_RESIZED = 520,
	WINDOW_MINIMIZED = 521,
	WINDOW_MAXIMIZED = 522,
	WINDOW_RESTORED = 523,
	WINDOW_MOUSE_ENTER = 524,
	WINDOW_MOUSE_LEAVE = 525,
	WINDOW_FOCUS_GAINED = 526,
	WINDOW_FOCUS_LOST = 527,
	WINDOW_CLOSE_REQUESTED = 528,
	WINDOW_HIT_TEST = 529,
	WINDOW_ICCPROF_CHANGED = 530,
	WINDOW_DISPLAY_CHANGED = 531,
	WINDOW_DISPLAY_SCALE_CHANGED = 532,
	WINDOW_SAFE_AREA_CHANGED = 533,
	WINDOW_OCCLUDED = 534,
	WINDOW_ENTER_FULLSCREEN = 535,
	WINDOW_LEAVE_FULLSCREEN = 536,
	WINDOW_DESTROYED = 537,
	WINDOW_HDR_STATE_CHANGED = 538,
	WINDOW_FIRST = 514,
	WINDOW_LAST = 538,
	KEY_DOWN = 768,
	KEY_UP = 769,
	TEXT_EDITING = 770,
	TEXT_INPUT = 771,
	KEYMAP_CHANGED = 772,
	KEYBOARD_ADDED = 773,
	KEYBOARD_REMOVED = 774,
	TEXT_EDITING_CANDIDATES = 775,
	MOUSE_MOTION = 1024,
	MOUSE_BUTTON_DOWN = 1025,
	MOUSE_BUTTON_UP = 1026,
	MOUSE_WHEEL = 1027,
	MOUSE_ADDED = 1028,
	MOUSE_REMOVED = 1029,
	JOYSTICK_AXIS_MOTION = 1536,
	JOYSTICK_BALL_MOTION = 1537,
	JOYSTICK_HAT_MOTION = 1538,
	JOYSTICK_BUTTON_DOWN = 1539,
	JOYSTICK_BUTTON_UP = 1540,
	JOYSTICK_ADDED = 1541,
	JOYSTICK_REMOVED = 1542,
	JOYSTICK_BATTERY_UPDATED = 1543,
	JOYSTICK_UPDATE_COMPLETE = 1544,
	GAMEPAD_AXIS_MOTION = 1616,
	GAMEPAD_BUTTON_DOWN = 1617,
	GAMEPAD_BUTTON_UP = 1618,
	GAMEPAD_ADDED = 1619,
	GAMEPAD_REMOVED = 1620,
	GAMEPAD_REMAPPED = 1621,
	GAMEPAD_TOUCHPAD_DOWN = 1622,
	GAMEPAD_TOUCHPAD_MOTION = 1623,
	GAMEPAD_TOUCHPAD_UP = 1624,
	GAMEPAD_SENSOR_UPDATE = 1625,
	GAMEPAD_UPDATE_COMPLETE = 1626,
	GAMEPAD_STEAM_HANDLE_UPDATED = 1627,
	FINGER_DOWN = 1792,
	FINGER_UP = 1793,
	FINGER_MOTION = 1794,
	CLIPBOARD_UPDATE = 2304,
	DROP_FILE = 4096,
	DROP_TEXT = 4097,
	DROP_BEGIN = 4098,
	DROP_COMPLETE = 4099,
	DROP_POSITION = 4100,
	AUDIO_DEVICE_ADDED = 4352,
	AUDIO_DEVICE_REMOVED = 4353,
	AUDIO_DEVICE_FORMAT_CHANGED = 4354,
	SENSOR_UPDATE = 4608,
	PEN_PROXIMITY_IN = 4864,
	PEN_PROXIMITY_OUT = 4865,
	PEN_DOWN = 4866,
	PEN_UP = 4867,
	PEN_BUTTON_DOWN = 4868,
	PEN_BUTTON_UP = 4869,
	PEN_MOTION = 4870,
	PEN_AXIS = 4871,
	CAMERA_DEVICE_ADDED = 5120,
	CAMERA_DEVICE_REMOVED = 5121,
	CAMERA_DEVICE_APPROVED = 5122,
	CAMERA_DEVICE_DENIED = 5123,
	RENDER_TARGETS_RESET = 8192,
	RENDER_DEVICE_RESET = 8193,
	RENDER_DEVICE_LOST = 8194,
	PRIVATE0 = 16384,
	PRIVATE1 = 16385,
	PRIVATE2 = 16386,
	PRIVATE3 = 16387,
	POLL_SENTINEL = 32512,
	USER = 32768,
	LAST = 65535,
	// ENUM_PADDING = 2147483647,
}

/// SDL_EventAction
EventAction :: enum cffi.uint {
	ADDEVENT = 0,
	PEEKEVENT = 1,
	GETEVENT = 2,
}

/// SDL_Folder
Folder :: enum cffi.uint {
	HOME = 0,
	DESKTOP = 1,
	DOCUMENTS = 2,
	DOWNLOADS = 3,
	MUSIC = 4,
	PICTURES = 5,
	PUBLICSHARE = 6,
	SAVEDGAMES = 7,
	SCREENSHOTS = 8,
	TEMPLATES = 9,
	VIDEOS = 10,
	COUNT = 11,
}

/// SDL_PathType
PathType :: enum cffi.uint {
	NONE = 0,
	FILE = 1,
	DIRECTORY = 2,
	OTHER = 3,
}

/// SDL_EnumerationResult
EnumerationResult :: enum cffi.uint {
	CONTINUE = 0,
	SUCCESS = 1,
	FAILURE = 2,
}

/// SDL_GPUPrimitiveType
GPUPrimitiveType :: enum cffi.uint {
	TRIANGLELIST = 0,
	TRIANGLESTRIP = 1,
	LINELIST = 2,
	LINESTRIP = 3,
	POINTLIST = 4,
}

/// SDL_GPULoadOp
GPULoadOp :: enum cffi.uint {
	LOAD = 0,
	CLEAR = 1,
	DONT_CARE = 2,
}

/// SDL_GPUStoreOp
GPUStoreOp :: enum cffi.uint {
	STORE = 0,
	DONT_CARE = 1,
	RESOLVE = 2,
	RESOLVE_AND_STORE = 3,
}

/// SDL_GPUIndexElementSize
GPUIndexElementSize :: enum cffi.uint {
	_16BIT = 0,
	_32BIT = 1,
}

/// SDL_GPUTextureFormat
GPUTextureFormat :: enum cffi.uint {
	INVALID = 0,
	A8_UNORM = 1,
	R8_UNORM = 2,
	R8G8_UNORM = 3,
	R8G8B8A8_UNORM = 4,
	R16_UNORM = 5,
	R16G16_UNORM = 6,
	R16G16B16A16_UNORM = 7,
	R10G10B10A2_UNORM = 8,
	B5G6R5_UNORM = 9,
	B5G5R5A1_UNORM = 10,
	B4G4R4A4_UNORM = 11,
	B8G8R8A8_UNORM = 12,
	BC1_RGBA_UNORM = 13,
	BC2_RGBA_UNORM = 14,
	BC3_RGBA_UNORM = 15,
	BC4_R_UNORM = 16,
	BC5_RG_UNORM = 17,
	BC7_RGBA_UNORM = 18,
	BC6H_RGB_FLOAT = 19,
	BC6H_RGB_UFLOAT = 20,
	R8_SNORM = 21,
	R8G8_SNORM = 22,
	R8G8B8A8_SNORM = 23,
	R16_SNORM = 24,
	R16G16_SNORM = 25,
	R16G16B16A16_SNORM = 26,
	R16_FLOAT = 27,
	R16G16_FLOAT = 28,
	R16G16B16A16_FLOAT = 29,
	R32_FLOAT = 30,
	R32G32_FLOAT = 31,
	R32G32B32A32_FLOAT = 32,
	R11G11B10_UFLOAT = 33,
	R8_UINT = 34,
	R8G8_UINT = 35,
	R8G8B8A8_UINT = 36,
	R16_UINT = 37,
	R16G16_UINT = 38,
	R16G16B16A16_UINT = 39,
	R32_UINT = 40,
	R32G32_UINT = 41,
	R32G32B32A32_UINT = 42,
	R8_INT = 43,
	R8G8_INT = 44,
	R8G8B8A8_INT = 45,
	R16_INT = 46,
	R16G16_INT = 47,
	R16G16B16A16_INT = 48,
	R32_INT = 49,
	R32G32_INT = 50,
	R32G32B32A32_INT = 51,
	R8G8B8A8_UNORM_SRGB = 52,
	B8G8R8A8_UNORM_SRGB = 53,
	BC1_RGBA_UNORM_SRGB = 54,
	BC2_RGBA_UNORM_SRGB = 55,
	BC3_RGBA_UNORM_SRGB = 56,
	BC7_RGBA_UNORM_SRGB = 57,
	D16_UNORM = 58,
	D24_UNORM = 59,
	D32_FLOAT = 60,
	D24_UNORM_S8_UINT = 61,
	D32_FLOAT_S8_UINT = 62,
	ASTC_4x4_UNORM = 63,
	ASTC_5x4_UNORM = 64,
	ASTC_5x5_UNORM = 65,
	ASTC_6x5_UNORM = 66,
	ASTC_6x6_UNORM = 67,
	ASTC_8x5_UNORM = 68,
	ASTC_8x6_UNORM = 69,
	ASTC_8x8_UNORM = 70,
	ASTC_10x5_UNORM = 71,
	ASTC_10x6_UNORM = 72,
	ASTC_10x8_UNORM = 73,
	ASTC_10x10_UNORM = 74,
	ASTC_12x10_UNORM = 75,
	ASTC_12x12_UNORM = 76,
	ASTC_4x4_UNORM_SRGB = 77,
	ASTC_5x4_UNORM_SRGB = 78,
	ASTC_5x5_UNORM_SRGB = 79,
	ASTC_6x5_UNORM_SRGB = 80,
	ASTC_6x6_UNORM_SRGB = 81,
	ASTC_8x5_UNORM_SRGB = 82,
	ASTC_8x6_UNORM_SRGB = 83,
	ASTC_8x8_UNORM_SRGB = 84,
	ASTC_10x5_UNORM_SRGB = 85,
	ASTC_10x6_UNORM_SRGB = 86,
	ASTC_10x8_UNORM_SRGB = 87,
	ASTC_10x10_UNORM_SRGB = 88,
	ASTC_12x10_UNORM_SRGB = 89,
	ASTC_12x12_UNORM_SRGB = 90,
	ASTC_4x4_FLOAT = 91,
	ASTC_5x4_FLOAT = 92,
	ASTC_5x5_FLOAT = 93,
	ASTC_6x5_FLOAT = 94,
	ASTC_6x6_FLOAT = 95,
	ASTC_8x5_FLOAT = 96,
	ASTC_8x6_FLOAT = 97,
	ASTC_8x8_FLOAT = 98,
	ASTC_10x5_FLOAT = 99,
	ASTC_10x6_FLOAT = 100,
	ASTC_10x8_FLOAT = 101,
	ASTC_10x10_FLOAT = 102,
	ASTC_12x10_FLOAT = 103,
	ASTC_12x12_FLOAT = 104,
}

/// SDL_GPUTextureType
GPUTextureType :: enum cffi.uint {
	_2D = 0,
	_2D_ARRAY = 1,
	_3D = 2,
	CUBE = 3,
	CUBE_ARRAY = 4,
}

/// SDL_GPUSampleCount
GPUSampleCount :: enum cffi.uint {
	_1 = 0,
	_2 = 1,
	_4 = 2,
	_8 = 3,
}

/// SDL_GPUCubeMapFace
GPUCubeMapFace :: enum cffi.uint {
	POSITIVEX = 0,
	NEGATIVEX = 1,
	POSITIVEY = 2,
	NEGATIVEY = 3,
	POSITIVEZ = 4,
	NEGATIVEZ = 5,
}

/// SDL_GPUTransferBufferUsage
GPUTransferBufferUsage :: enum cffi.uint {
	UPLOAD = 0,
	DOWNLOAD = 1,
}

/// SDL_GPUShaderStage
GPUShaderStage :: enum cffi.uint {
	VERTEX = 0,
	FRAGMENT = 1,
}

/// SDL_GPUVertexElementFormat
GPUVertexElementFormat :: enum cffi.uint {
	INVALID = 0,
	INT = 1,
	INT2 = 2,
	INT3 = 3,
	INT4 = 4,
	UINT = 5,
	UINT2 = 6,
	UINT3 = 7,
	UINT4 = 8,
	FLOAT = 9,
	FLOAT2 = 10,
	FLOAT3 = 11,
	FLOAT4 = 12,
	BYTE2 = 13,
	BYTE4 = 14,
	UBYTE2 = 15,
	UBYTE4 = 16,
	BYTE2_NORM = 17,
	BYTE4_NORM = 18,
	UBYTE2_NORM = 19,
	UBYTE4_NORM = 20,
	SHORT2 = 21,
	SHORT4 = 22,
	USHORT2 = 23,
	USHORT4 = 24,
	SHORT2_NORM = 25,
	SHORT4_NORM = 26,
	USHORT2_NORM = 27,
	USHORT4_NORM = 28,
	HALF2 = 29,
	HALF4 = 30,
}

/// SDL_GPUVertexInputRate
GPUVertexInputRate :: enum cffi.uint {
	VERTEX = 0,
	INSTANCE = 1,
}

/// SDL_GPUFillMode
GPUFillMode :: enum cffi.uint {
	FILL = 0,
	LINE = 1,
}

/// SDL_GPUCullMode
GPUCullMode :: enum cffi.uint {
	NONE = 0,
	FRONT = 1,
	BACK = 2,
}

/// SDL_GPUFrontFace
GPUFrontFace :: enum cffi.uint {
	OUNTER_CLOCKWISE = 0,
	LOCKWISE = 1,
}

/// SDL_GPUCompareOp
GPUCompareOp :: enum cffi.uint {
	INVALID = 0,
	NEVER = 1,
	LESS = 2,
	EQUAL = 3,
	LESS_OR_EQUAL = 4,
	GREATER = 5,
	NOT_EQUAL = 6,
	GREATER_OR_EQUAL = 7,
	ALWAYS = 8,
}

/// SDL_GPUStencilOp
GPUStencilOp :: enum cffi.uint {
	INVALID = 0,
	KEEP = 1,
	ZERO = 2,
	REPLACE = 3,
	INCREMENT_AND_CLAMP = 4,
	DECREMENT_AND_CLAMP = 5,
	INVERT = 6,
	INCREMENT_AND_WRAP = 7,
	DECREMENT_AND_WRAP = 8,
}

/// SDL_GPUBlendOp
GPUBlendOp :: enum cffi.uint {
	INVALID = 0,
	ADD = 1,
	SUBTRACT = 2,
	REVERSE_SUBTRACT = 3,
	MIN = 4,
	MAX = 5,
}

/// SDL_GPUBlendFactor
GPUBlendFactor :: enum cffi.uint {
	INVALID = 0,
	ZERO = 1,
	ONE = 2,
	SRC_COLOR = 3,
	ONE_MINUS_SRC_COLOR = 4,
	DST_COLOR = 5,
	ONE_MINUS_DST_COLOR = 6,
	SRC_ALPHA = 7,
	ONE_MINUS_SRC_ALPHA = 8,
	DST_ALPHA = 9,
	ONE_MINUS_DST_ALPHA = 10,
	CONSTANT_COLOR = 11,
	ONE_MINUS_CONSTANT_COLOR = 12,
	SRC_ALPHA_SATURATE = 13,
}

/// SDL_GPUFilter
GPUFilter :: enum cffi.uint {
	NEAREST = 0,
	LINEAR = 1,
}

/// SDL_GPUSamplerMipmapMode
GPUSamplerMipmapMode :: enum cffi.uint {
	NEAREST = 0,
	LINEAR = 1,
}

/// SDL_GPUSamplerAddressMode
GPUSamplerAddressMode :: enum cffi.uint {
	REPEAT = 0,
	MIRRORED_REPEAT = 1,
	CLAMP_TO_EDGE = 2,
}

/// SDL_GPUPresentMode
GPUPresentMode :: enum cffi.uint {
	VSYNC = 0,
	IMMEDIATE = 1,
	MAILBOX = 2,
}

/// SDL_GPUSwapchainComposition
GPUSwapchainComposition :: enum cffi.uint {
	SDR = 0,
	SDR_LINEAR = 1,
	HDR_EXTENDED_LINEAR = 2,
	HDR10_ST2048 = 3,
}

/// SDL_hid_bus_type
hid_bus_type :: enum cffi.uint {
	UNKNOWN = 0,
	USB = 1,
	BLUETOOTH = 2,
	I2C = 3,
	SPI = 4,
}

/// SDL_HintPriority
HintPriority :: enum cffi.uint {
	DEFAULT = 0,
	NORMAL = 1,
	OVERRIDE = 2,
}

/// SDL_AppResult
AppResult :: enum cffi.uint {
	CONTINUE = 0,
	SUCCESS = 1,
	FAILURE = 2,
}

/// SDL_LogCategory
LogCategory :: enum cffi.uint {
	APPLICATION = 0,
	ERROR = 1,
	ASSERT = 2,
	SYSTEM = 3,
	AUDIO = 4,
	VIDEO = 5,
	RENDER = 6,
	INPUT = 7,
	TEST = 8,
	GPU = 9,
	RESERVED2 = 10,
	RESERVED3 = 11,
	RESERVED4 = 12,
	RESERVED5 = 13,
	RESERVED6 = 14,
	RESERVED7 = 15,
	RESERVED8 = 16,
	RESERVED9 = 17,
	RESERVED10 = 18,
	CUSTOM = 19,
}

/// SDL_LogPriority
LogPriority :: enum cffi.uint {
	INVALID = 0,
	TRACE = 1,
	VERBOSE = 2,
	DEBUG = 3,
	INFO = 4,
	WARN = 5,
	ERROR = 6,
	CRITICAL = 7,
	COUNT = 8,
}

/// SDL_MessageBoxColorType
MessageBoxColorType :: enum cffi.uint {
	BACKGROUND = 0,
	TEXT = 1,
	BUTTON_BORDER = 2,
	BUTTON_BACKGROUND = 3,
	BUTTON_SELECTED = 4,
	COUNT = 5,
}

/// SDL_ProcessIO
ProcessIO :: enum cffi.uint {
	INHERITED = 0,
	NULL = 1,
	APP = 2,
	REDIRECT = 3,
}

/// SDL_TextureAccess
TextureAccess :: enum cffi.uint {
	STATIC = 0,
	STREAMING = 1,
	TARGET = 2,
}

/// SDL_RendererLogicalPresentation
RendererLogicalPresentation :: enum cffi.uint {
	DISABLED = 0,
	STRETCH = 1,
	LETTERBOX = 2,
	OVERSCAN = 3,
	INTEGER_SCALE = 4,
}

/// SDL_Sandbox
Sandbox :: enum cffi.uint {
	NONE = 0,
	UNKNOWN_CONTAINER = 1,
	FLATPAK = 2,
	SNAP = 3,
	MACOS = 4,
}

/// SDL_DateFormat
DateFormat :: enum cffi.uint {
	YYYYMMDD = 0,
	DDMMYYYY = 1,
	MMDDYYYY = 2,
}

/// SDL_TimeFormat
TimeFormat :: enum cffi.uint {
	_24HR = 0,
	_12HR = 1,
}

/// SDL_alignment_test
alignment_test :: struct #align (8) {
	a: Uint8,
	b: rawptr,
}
#assert(size_of(alignment_test) == 16)

/// SDL_Environment
Environment :: struct {}

/// SDL_iconv_data_t
iconv_data_t :: struct {}

/// SDL_AssertData
AssertData :: struct #align (8) {
	always_ignore: cffi.bool,
	trigger_count: cffi.uint,
	condition: cstring,
	filename: cstring,
	linenum: cffi.int,
	function: cstring,
	next: ^AssertData,
}
#assert(size_of(AssertData) == 48)

/// SDL_AtomicInt
AtomicInt :: struct #align (4) {
	value: cffi.int,
}
#assert(size_of(AtomicInt) == 4)

/// SDL_AtomicU32
AtomicU32 :: struct #align (4) {
	value: Uint32,
}
#assert(size_of(AtomicU32) == 4)

/// SDL_Thread
Thread :: struct {}

/// SDL_Mutex
Mutex :: struct {}

/// SDL_RWLock
RWLock :: struct {}

/// SDL_Semaphore
Semaphore :: struct {}

/// SDL_Condition
Condition :: struct {}

/// SDL_InitState
InitState :: struct #align (8) {
	status: AtomicInt,
	thread: ThreadID,
	reserved: rawptr,
}
#assert(size_of(InitState) == 24)

/// SDL_IOStreamInterface
IOStreamInterface :: struct #align (8) {
	version: Uint32,
	size: proc "c" (userdata: rawptr) -> Sint64,
	seek: proc "c" (userdata: rawptr, offset: Sint64, whence: IOWhence) -> Sint64,
	read: proc "c" (userdata: rawptr, ptr: rawptr, size: cffi.size_t, status: ^IOStatus) -> cffi.size_t,
	write: proc "c" (userdata: rawptr, ptr: rawptr, size: cffi.size_t, status: ^IOStatus) -> cffi.size_t,
	flush: proc "c" (userdata: rawptr, status: ^IOStatus) -> cffi.bool,
	close: proc "c" (userdata: rawptr) -> cffi.bool,
}
#assert(size_of(IOStreamInterface) == 56)

/// SDL_IOStream
IOStream :: struct {}

/// SDL_AudioSpec
AudioSpec :: struct #align (4) {
	format: AudioFormat,
	channels: cffi.int,
	freq: cffi.int,
}
#assert(size_of(AudioSpec) == 12)

/// SDL_AudioStream
AudioStream :: struct {}

/// SDL_Color
Color :: struct #align (1) {
	r: Uint8,
	g: Uint8,
	b: Uint8,
	a: Uint8,
}
#assert(size_of(Color) == 4)

/// SDL_FColor
FColor :: struct #align (4) {
	r: cffi.float,
	g: cffi.float,
	b: cffi.float,
	a: cffi.float,
}
#assert(size_of(FColor) == 16)

/// SDL_Palette
Palette :: struct #align (8) {
	ncolors: cffi.int,
	colors: ^Color,
	version: Uint32,
	refcount: cffi.int,
}
#assert(size_of(Palette) == 24)

/// SDL_PixelFormatDetails
PixelFormatDetails :: struct #align (4) {
	format: PixelFormat,
	bits_per_pixel: Uint8,
	bytes_per_pixel: Uint8,
	padding: [2]Uint8,
	Rmask: Uint32,
	Gmask: Uint32,
	Bmask: Uint32,
	Amask: Uint32,
	Rbits: Uint8,
	Gbits: Uint8,
	Bbits: Uint8,
	Abits: Uint8,
	Rshift: Uint8,
	Gshift: Uint8,
	Bshift: Uint8,
	Ashift: Uint8,
}
#assert(size_of(PixelFormatDetails) == 32)

/// SDL_Point
Point :: struct #align (4) {
	x: cffi.int,
	y: cffi.int,
}
#assert(size_of(Point) == 8)

/// SDL_FPoint
FPoint :: struct #align (4) {
	x: cffi.float,
	y: cffi.float,
}
#assert(size_of(FPoint) == 8)

/// SDL_Rect
Rect :: struct #align (4) {
	x: cffi.int,
	y: cffi.int,
	w: cffi.int,
	h: cffi.int,
}
#assert(size_of(Rect) == 16)

/// SDL_FRect
FRect :: struct #align (4) {
	x: cffi.float,
	y: cffi.float,
	w: cffi.float,
	h: cffi.float,
}
#assert(size_of(FRect) == 16)

/// SDL_Surface
Surface :: struct #align (8) {
	flags: SurfaceFlags,
	format: PixelFormat,
	w: cffi.int,
	h: cffi.int,
	pitch: cffi.int,
	pixels: rawptr,
	refcount: cffi.int,
	reserved: rawptr,
}
#assert(size_of(Surface) == 48)

/// SDL_Camera
Camera :: struct {}

/// SDL_CameraSpec
CameraSpec :: struct #align (4) {
	format: PixelFormat,
	colorspace: Colorspace,
	width: cffi.int,
	height: cffi.int,
	framerate_numerator: cffi.int,
	framerate_denominator: cffi.int,
}
#assert(size_of(CameraSpec) == 24)

/// SDL_DisplayModeData
DisplayModeData :: struct {}

/// SDL_DisplayMode
DisplayMode :: struct #align (8) {
	displayID: DisplayID,
	format: PixelFormat,
	w: cffi.int,
	h: cffi.int,
	pixel_density: cffi.float,
	refresh_rate: cffi.float,
	refresh_rate_numerator: cffi.int,
	refresh_rate_denominator: cffi.int,
	internal: ^DisplayModeData,
}
#assert(size_of(DisplayMode) == 40)

/// SDL_Window
Window :: struct {}

/// SDL_GLContextState
GLContextState :: struct {}

/// SDL_DialogFileFilter
DialogFileFilter :: struct #align (8) {
	name: cstring,
	pattern: cstring,
}
#assert(size_of(DialogFileFilter) == 16)

/// SDL_GUID
GUID :: struct #align (1) {
	data: [16]Uint8,
}
#assert(size_of(GUID) == 16)

/// SDL_Sensor
Sensor :: struct {}

/// SDL_Joystick
Joystick :: struct {}

/// SDL_VirtualJoystickTouchpadDesc
VirtualJoystickTouchpadDesc :: struct #align (2) {
	nfingers: Uint16,
	padding: [3]Uint16,
}
#assert(size_of(VirtualJoystickTouchpadDesc) == 8)

/// SDL_VirtualJoystickSensorDesc
VirtualJoystickSensorDesc :: struct #align (4) {
	type: SensorType,
	rate: cffi.float,
}
#assert(size_of(VirtualJoystickSensorDesc) == 8)

/// SDL_VirtualJoystickDesc
VirtualJoystickDesc :: struct #align (8) {
	version: Uint32,
	type: Uint16,
	padding: Uint16,
	vendor_id: Uint16,
	product_id: Uint16,
	naxes: Uint16,
	nbuttons: Uint16,
	nballs: Uint16,
	nhats: Uint16,
	ntouchpads: Uint16,
	nsensors: Uint16,
	padding2: [2]Uint16,
	button_mask: Uint32,
	axis_mask: Uint32,
	name: cstring,
	touchpads: ^VirtualJoystickTouchpadDesc,
	sensors: ^VirtualJoystickSensorDesc,
	userdata: rawptr,
	Update: proc "c" (userdata: rawptr),
	SetPlayerIndex: proc "c" (userdata: rawptr, player_index: cffi.int),
	Rumble: proc "c" (userdata: rawptr, low_frequency_rumble: Uint16, high_frequency_rumble: Uint16) -> cffi.bool,
	RumbleTriggers: proc "c" (userdata: rawptr, left_rumble: Uint16, right_rumble: Uint16) -> cffi.bool,
	SetLED: proc "c" (userdata: rawptr, red: Uint8, green: Uint8, blue: Uint8) -> cffi.bool,
	SendEffect: proc "c" (userdata: rawptr, data: rawptr, size: cffi.int) -> cffi.bool,
	SetSensorsEnabled: proc "c" (userdata: rawptr, enabled: cffi.bool) -> cffi.bool,
	Cleanup: proc "c" (userdata: rawptr),
}
#assert(size_of(VirtualJoystickDesc) == 136)

/// SDL_Gamepad
Gamepad :: struct {}

/// SDL_GamepadBinding
GamepadBinding :: struct #align (4) {
	input_type: GamepadBindingType,
	input : struct #raw_union  {
		button: cffi.int,
		axis : struct  {
			axis: cffi.int,
			axis_min: cffi.int,
			axis_max: cffi.int,
		},
		hat : struct  {
			hat: cffi.int,
			hat_mask: cffi.int,
		},
	},
	output_type: GamepadBindingType,
	output : struct #raw_union  {
		button: GamepadButton,
		axis : struct  {
			axis: GamepadAxis,
			axis_min: cffi.int,
			axis_max: cffi.int,
		},
	},
}
#assert(size_of(GamepadBinding) == 32)

/// SDL_Cursor
Cursor :: struct {}

/// SDL_Finger
Finger :: struct #align (8) {
	id: FingerID,
	x: cffi.float,
	y: cffi.float,
	pressure: cffi.float,
}
#assert(size_of(Finger) == 24)

/// SDL_CommonEvent
CommonEvent :: struct #align (8) {
	type: Uint32,
	reserved: Uint32,
	timestamp: Uint64,
}
#assert(size_of(CommonEvent) == 16)

/// SDL_DisplayEvent
DisplayEvent :: struct #align (8) {
	type: EventType,
	reserved: Uint32,
	timestamp: Uint64,
	displayID: DisplayID,
	data1: Sint32,
	data2: Sint32,
}
#assert(size_of(DisplayEvent) == 32)

/// SDL_WindowEvent
WindowEvent :: struct #align (8) {
	type: EventType,
	reserved: Uint32,
	timestamp: Uint64,
	windowID: WindowID,
	data1: Sint32,
	data2: Sint32,
}
#assert(size_of(WindowEvent) == 32)

/// SDL_KeyboardDeviceEvent
KeyboardDeviceEvent :: struct #align (8) {
	type: EventType,
	reserved: Uint32,
	timestamp: Uint64,
	which: KeyboardID,
}
#assert(size_of(KeyboardDeviceEvent) == 24)

/// SDL_KeyboardEvent
KeyboardEvent :: struct #align (8) {
	type: EventType,
	reserved: Uint32,
	timestamp: Uint64,
	windowID: WindowID,
	which: KeyboardID,
	scancode: Scancode,
	key: Keycode,
	mod: Keymod,
	raw: Uint16,
	down: cffi.bool,
	repeat: cffi.bool,
}
#assert(size_of(KeyboardEvent) == 40)

/// SDL_TextEditingEvent
TextEditingEvent :: struct #align (8) {
	type: EventType,
	reserved: Uint32,
	timestamp: Uint64,
	windowID: WindowID,
	text: cstring,
	start: Sint32,
	length: Sint32,
}
#assert(size_of(TextEditingEvent) == 40)

/// SDL_TextEditingCandidatesEvent
TextEditingCandidatesEvent :: struct #align (8) {
	type: EventType,
	reserved: Uint32,
	timestamp: Uint64,
	windowID: WindowID,
	candidates: ^cstring,
	num_candidates: Sint32,
	selected_candidate: Sint32,
	horizontal: cffi.bool,
	padding1: Uint8,
	padding2: Uint8,
	padding3: Uint8,
}
#assert(size_of(TextEditingCandidatesEvent) == 48)

/// SDL_TextInputEvent
TextInputEvent :: struct #align (8) {
	type: EventType,
	reserved: Uint32,
	timestamp: Uint64,
	windowID: WindowID,
	text: cstring,
}
#assert(size_of(TextInputEvent) == 32)

/// SDL_MouseDeviceEvent
MouseDeviceEvent :: struct #align (8) {
	type: EventType,
	reserved: Uint32,
	timestamp: Uint64,
	which: MouseID,
}
#assert(size_of(MouseDeviceEvent) == 24)

/// SDL_MouseMotionEvent
MouseMotionEvent :: struct #align (8) {
	type: EventType,
	reserved: Uint32,
	timestamp: Uint64,
	windowID: WindowID,
	which: MouseID,
	state: MouseButtonFlags,
	x: cffi.float,
	y: cffi.float,
	xrel: cffi.float,
	yrel: cffi.float,
}
#assert(size_of(MouseMotionEvent) == 48)

/// SDL_MouseButtonEvent
MouseButtonEvent :: struct #align (8) {
	type: EventType,
	reserved: Uint32,
	timestamp: Uint64,
	windowID: WindowID,
	which: MouseID,
	button: Uint8,
	down: cffi.bool,
	clicks: Uint8,
	padding: Uint8,
	x: cffi.float,
	y: cffi.float,
}
#assert(size_of(MouseButtonEvent) == 40)

/// SDL_MouseWheelEvent
MouseWheelEvent :: struct #align (8) {
	type: EventType,
	reserved: Uint32,
	timestamp: Uint64,
	windowID: WindowID,
	which: MouseID,
	x: cffi.float,
	y: cffi.float,
	direction: MouseWheelDirection,
	mouse_x: cffi.float,
	mouse_y: cffi.float,
}
#assert(size_of(MouseWheelEvent) == 48)

/// SDL_JoyAxisEvent
JoyAxisEvent :: struct #align (8) {
	type: EventType,
	reserved: Uint32,
	timestamp: Uint64,
	which: JoystickID,
	axis: Uint8,
	padding1: Uint8,
	padding2: Uint8,
	padding3: Uint8,
	value: Sint16,
	padding4: Uint16,
}
#assert(size_of(JoyAxisEvent) == 32)

/// SDL_JoyBallEvent
JoyBallEvent :: struct #align (8) {
	type: EventType,
	reserved: Uint32,
	timestamp: Uint64,
	which: JoystickID,
	ball: Uint8,
	padding1: Uint8,
	padding2: Uint8,
	padding3: Uint8,
	xrel: Sint16,
	yrel: Sint16,
}
#assert(size_of(JoyBallEvent) == 32)

/// SDL_JoyHatEvent
JoyHatEvent :: struct #align (8) {
	type: EventType,
	reserved: Uint32,
	timestamp: Uint64,
	which: JoystickID,
	hat: Uint8,
	value: Uint8,
	padding1: Uint8,
	padding2: Uint8,
}
#assert(size_of(JoyHatEvent) == 24)

/// SDL_JoyButtonEvent
JoyButtonEvent :: struct #align (8) {
	type: EventType,
	reserved: Uint32,
	timestamp: Uint64,
	which: JoystickID,
	button: Uint8,
	down: cffi.bool,
	padding1: Uint8,
	padding2: Uint8,
}
#assert(size_of(JoyButtonEvent) == 24)

/// SDL_JoyDeviceEvent
JoyDeviceEvent :: struct #align (8) {
	type: EventType,
	reserved: Uint32,
	timestamp: Uint64,
	which: JoystickID,
}
#assert(size_of(JoyDeviceEvent) == 24)

/// SDL_JoyBatteryEvent
JoyBatteryEvent :: struct #align (8) {
	type: EventType,
	reserved: Uint32,
	timestamp: Uint64,
	which: JoystickID,
	state: PowerState,
	percent: cffi.int,
}
#assert(size_of(JoyBatteryEvent) == 32)

/// SDL_GamepadAxisEvent
GamepadAxisEvent :: struct #align (8) {
	type: EventType,
	reserved: Uint32,
	timestamp: Uint64,
	which: JoystickID,
	axis: Uint8,
	padding1: Uint8,
	padding2: Uint8,
	padding3: Uint8,
	value: Sint16,
	padding4: Uint16,
}
#assert(size_of(GamepadAxisEvent) == 32)

/// SDL_GamepadButtonEvent
GamepadButtonEvent :: struct #align (8) {
	type: EventType,
	reserved: Uint32,
	timestamp: Uint64,
	which: JoystickID,
	button: Uint8,
	down: cffi.bool,
	padding1: Uint8,
	padding2: Uint8,
}
#assert(size_of(GamepadButtonEvent) == 24)

/// SDL_GamepadDeviceEvent
GamepadDeviceEvent :: struct #align (8) {
	type: EventType,
	reserved: Uint32,
	timestamp: Uint64,
	which: JoystickID,
}
#assert(size_of(GamepadDeviceEvent) == 24)

/// SDL_GamepadTouchpadEvent
GamepadTouchpadEvent :: struct #align (8) {
	type: EventType,
	reserved: Uint32,
	timestamp: Uint64,
	which: JoystickID,
	touchpad: Sint32,
	finger: Sint32,
	x: cffi.float,
	y: cffi.float,
	pressure: cffi.float,
}
#assert(size_of(GamepadTouchpadEvent) == 40)

/// SDL_GamepadSensorEvent
GamepadSensorEvent :: struct #align (8) {
	type: EventType,
	reserved: Uint32,
	timestamp: Uint64,
	which: JoystickID,
	sensor: Sint32,
	data: [3]cffi.float,
	sensor_timestamp: Uint64,
}
#assert(size_of(GamepadSensorEvent) == 48)

/// SDL_AudioDeviceEvent
AudioDeviceEvent :: struct #align (8) {
	type: EventType,
	reserved: Uint32,
	timestamp: Uint64,
	which: AudioDeviceID,
	recording: cffi.bool,
	padding1: Uint8,
	padding2: Uint8,
	padding3: Uint8,
}
#assert(size_of(AudioDeviceEvent) == 24)

/// SDL_CameraDeviceEvent
CameraDeviceEvent :: struct #align (8) {
	type: EventType,
	reserved: Uint32,
	timestamp: Uint64,
	which: CameraID,
}
#assert(size_of(CameraDeviceEvent) == 24)

/// SDL_TouchFingerEvent
TouchFingerEvent :: struct #align (8) {
	type: EventType,
	reserved: Uint32,
	timestamp: Uint64,
	touchID: TouchID,
	fingerID: FingerID,
	x: cffi.float,
	y: cffi.float,
	dx: cffi.float,
	dy: cffi.float,
	pressure: cffi.float,
	windowID: WindowID,
}
#assert(size_of(TouchFingerEvent) == 56)

/// SDL_PenProximityEvent
PenProximityEvent :: struct #align (8) {
	type: EventType,
	reserved: Uint32,
	timestamp: Uint64,
	windowID: WindowID,
	which: PenID,
}
#assert(size_of(PenProximityEvent) == 24)

/// SDL_PenMotionEvent
PenMotionEvent :: struct #align (8) {
	type: EventType,
	reserved: Uint32,
	timestamp: Uint64,
	windowID: WindowID,
	which: PenID,
	pen_state: PenInputFlags,
	x: cffi.float,
	y: cffi.float,
}
#assert(size_of(PenMotionEvent) == 40)

/// SDL_PenTouchEvent
PenTouchEvent :: struct #align (8) {
	type: EventType,
	reserved: Uint32,
	timestamp: Uint64,
	windowID: WindowID,
	which: PenID,
	pen_state: PenInputFlags,
	x: cffi.float,
	y: cffi.float,
	eraser: cffi.bool,
	down: cffi.bool,
}
#assert(size_of(PenTouchEvent) == 40)

/// SDL_PenButtonEvent
PenButtonEvent :: struct #align (8) {
	type: EventType,
	reserved: Uint32,
	timestamp: Uint64,
	windowID: WindowID,
	which: PenID,
	pen_state: PenInputFlags,
	x: cffi.float,
	y: cffi.float,
	button: Uint8,
	down: cffi.bool,
}
#assert(size_of(PenButtonEvent) == 40)

/// SDL_PenAxisEvent
PenAxisEvent :: struct #align (8) {
	type: EventType,
	reserved: Uint32,
	timestamp: Uint64,
	windowID: WindowID,
	which: PenID,
	pen_state: PenInputFlags,
	x: cffi.float,
	y: cffi.float,
	axis: PenAxis,
	value: cffi.float,
}
#assert(size_of(PenAxisEvent) == 48)

/// SDL_DropEvent
DropEvent :: struct #align (8) {
	type: EventType,
	reserved: Uint32,
	timestamp: Uint64,
	windowID: WindowID,
	x: cffi.float,
	y: cffi.float,
	source: cstring,
	data: cstring,
}
#assert(size_of(DropEvent) == 48)

/// SDL_ClipboardEvent
ClipboardEvent :: struct #align (8) {
	type: EventType,
	reserved: Uint32,
	timestamp: Uint64,
	owner: cffi.bool,
	n_mime_types: Sint32,
	mime_types: ^cstring,
}
#assert(size_of(ClipboardEvent) == 32)

/// SDL_SensorEvent
SensorEvent :: struct #align (8) {
	type: EventType,
	reserved: Uint32,
	timestamp: Uint64,
	which: SensorID,
	data: [6]cffi.float,
	sensor_timestamp: Uint64,
}
#assert(size_of(SensorEvent) == 56)

/// SDL_QuitEvent
QuitEvent :: struct #align (8) {
	type: EventType,
	reserved: Uint32,
	timestamp: Uint64,
}
#assert(size_of(QuitEvent) == 16)

/// SDL_UserEvent
UserEvent :: struct #align (8) {
	type: Uint32,
	reserved: Uint32,
	timestamp: Uint64,
	windowID: WindowID,
	code: Sint32,
	data1: rawptr,
	data2: rawptr,
}
#assert(size_of(UserEvent) == 40)

/// SDL_PathInfo
PathInfo :: struct #align (8) {
	type: PathType,
	size: Uint64,
	create_time: Time,
	modify_time: Time,
	access_time: Time,
}
#assert(size_of(PathInfo) == 40)

/// SDL_GPUDevice
GPUDevice :: struct {}

/// SDL_GPUBuffer
GPUBuffer :: struct {}

/// SDL_GPUTransferBuffer
GPUTransferBuffer :: struct {}

/// SDL_GPUTexture
GPUTexture :: struct {}

/// SDL_GPUSampler
GPUSampler :: struct {}

/// SDL_GPUShader
GPUShader :: struct {}

/// SDL_GPUComputePipeline
GPUComputePipeline :: struct {}

/// SDL_GPUGraphicsPipeline
GPUGraphicsPipeline :: struct {}

/// SDL_GPUCommandBuffer
GPUCommandBuffer :: struct {}

/// SDL_GPURenderPass
GPURenderPass :: struct {}

/// SDL_GPUComputePass
GPUComputePass :: struct {}

/// SDL_GPUCopyPass
GPUCopyPass :: struct {}

/// SDL_GPUFence
GPUFence :: struct {}

/// SDL_GPUViewport
GPUViewport :: struct #align (4) {
	x: cffi.float,
	y: cffi.float,
	w: cffi.float,
	h: cffi.float,
	min_depth: cffi.float,
	max_depth: cffi.float,
}
#assert(size_of(GPUViewport) == 24)

/// SDL_GPUTextureTransferInfo
GPUTextureTransferInfo :: struct #align (8) {
	transfer_buffer: ^GPUTransferBuffer,
	offset: Uint32,
	pixels_per_row: Uint32,
	rows_per_layer: Uint32,
}
#assert(size_of(GPUTextureTransferInfo) == 24)

/// SDL_GPUTransferBufferLocation
GPUTransferBufferLocation :: struct #align (8) {
	transfer_buffer: ^GPUTransferBuffer,
	offset: Uint32,
}
#assert(size_of(GPUTransferBufferLocation) == 16)

/// SDL_GPUTextureLocation
GPUTextureLocation :: struct #align (8) {
	texture: ^GPUTexture,
	mip_level: Uint32,
	layer: Uint32,
	x: Uint32,
	y: Uint32,
	z: Uint32,
}
#assert(size_of(GPUTextureLocation) == 32)

/// SDL_GPUTextureRegion
GPUTextureRegion :: struct #align (8) {
	texture: ^GPUTexture,
	mip_level: Uint32,
	layer: Uint32,
	x: Uint32,
	y: Uint32,
	z: Uint32,
	w: Uint32,
	h: Uint32,
	d: Uint32,
}
#assert(size_of(GPUTextureRegion) == 40)

/// SDL_GPUBlitRegion
GPUBlitRegion :: struct #align (8) {
	texture: ^GPUTexture,
	mip_level: Uint32,
	layer_or_depth_plane: Uint32,
	x: Uint32,
	y: Uint32,
	w: Uint32,
	h: Uint32,
}
#assert(size_of(GPUBlitRegion) == 32)

/// SDL_GPUBufferLocation
GPUBufferLocation :: struct #align (8) {
	buffer: ^GPUBuffer,
	offset: Uint32,
}
#assert(size_of(GPUBufferLocation) == 16)

/// SDL_GPUBufferRegion
GPUBufferRegion :: struct #align (8) {
	buffer: ^GPUBuffer,
	offset: Uint32,
	size: Uint32,
}
#assert(size_of(GPUBufferRegion) == 16)

/// SDL_GPUIndirectDrawCommand
GPUIndirectDrawCommand :: struct #align (4) {
	num_vertices: Uint32,
	num_instances: Uint32,
	first_vertex: Uint32,
	first_instance: Uint32,
}
#assert(size_of(GPUIndirectDrawCommand) == 16)

/// SDL_GPUIndexedIndirectDrawCommand
GPUIndexedIndirectDrawCommand :: struct #align (4) {
	num_indices: Uint32,
	num_instances: Uint32,
	first_index: Uint32,
	vertex_offset: Sint32,
	first_instance: Uint32,
}
#assert(size_of(GPUIndexedIndirectDrawCommand) == 20)

/// SDL_GPUIndirectDispatchCommand
GPUIndirectDispatchCommand :: struct #align (4) {
	groupcount_x: Uint32,
	groupcount_y: Uint32,
	groupcount_z: Uint32,
}
#assert(size_of(GPUIndirectDispatchCommand) == 12)

/// SDL_GPUSamplerCreateInfo
GPUSamplerCreateInfo :: struct #align (4) {
	min_filter: GPUFilter,
	mag_filter: GPUFilter,
	mipmap_mode: GPUSamplerMipmapMode,
	address_mode_u: GPUSamplerAddressMode,
	address_mode_v: GPUSamplerAddressMode,
	address_mode_w: GPUSamplerAddressMode,
	mip_lod_bias: cffi.float,
	max_anisotropy: cffi.float,
	compare_op: GPUCompareOp,
	min_lod: cffi.float,
	max_lod: cffi.float,
	enable_anisotropy: cffi.bool,
	enable_compare: cffi.bool,
	padding1: Uint8,
	padding2: Uint8,
	props: PropertiesID,
}
#assert(size_of(GPUSamplerCreateInfo) == 52)

/// SDL_GPUVertexBufferDescription
GPUVertexBufferDescription :: struct #align (4) {
	slot: Uint32,
	pitch: Uint32,
	input_rate: GPUVertexInputRate,
	instance_step_rate: Uint32,
}
#assert(size_of(GPUVertexBufferDescription) == 16)

/// SDL_GPUVertexAttribute
GPUVertexAttribute :: struct #align (4) {
	location: Uint32,
	buffer_slot: Uint32,
	format: GPUVertexElementFormat,
	offset: Uint32,
}
#assert(size_of(GPUVertexAttribute) == 16)

/// SDL_GPUVertexInputState
GPUVertexInputState :: struct #align (8) {
	vertex_buffer_descriptions: ^GPUVertexBufferDescription,
	num_vertex_buffers: Uint32,
	vertex_attributes: ^GPUVertexAttribute,
	num_vertex_attributes: Uint32,
}
#assert(size_of(GPUVertexInputState) == 32)

/// SDL_GPUStencilOpState
GPUStencilOpState :: struct #align (4) {
	fail_op: GPUStencilOp,
	pass_op: GPUStencilOp,
	depth_fail_op: GPUStencilOp,
	compare_op: GPUCompareOp,
}
#assert(size_of(GPUStencilOpState) == 16)

/// SDL_GPUColorTargetBlendState
GPUColorTargetBlendState :: struct #align (4) {
	src_color_blendfactor: GPUBlendFactor,
	dst_color_blendfactor: GPUBlendFactor,
	color_blend_op: GPUBlendOp,
	src_alpha_blendfactor: GPUBlendFactor,
	dst_alpha_blendfactor: GPUBlendFactor,
	alpha_blend_op: GPUBlendOp,
	color_write_mask: GPUColorComponentFlags,
	enable_blend: cffi.bool,
	enable_color_write_mask: cffi.bool,
	padding1: Uint8,
	padding2: Uint8,
}
#assert(size_of(GPUColorTargetBlendState) == 32)

/// SDL_GPUShaderCreateInfo
GPUShaderCreateInfo :: struct #align (8) {
	code_size: cffi.size_t,
	code: ^Uint8,
	entrypoint: cstring,
	format: GPUShaderFormat,
	stage: GPUShaderStage,
	num_samplers: Uint32,
	num_storage_textures: Uint32,
	num_storage_buffers: Uint32,
	num_uniform_buffers: Uint32,
	props: PropertiesID,
}
#assert(size_of(GPUShaderCreateInfo) == 56)

/// SDL_GPUTextureCreateInfo
GPUTextureCreateInfo :: struct #align (4) {
	type: GPUTextureType,
	format: GPUTextureFormat,
	usage: GPUTextureUsageFlags,
	width: Uint32,
	height: Uint32,
	layer_count_or_depth: Uint32,
	num_levels: Uint32,
	sample_count: GPUSampleCount,
	props: PropertiesID,
}
#assert(size_of(GPUTextureCreateInfo) == 36)

/// SDL_GPUBufferCreateInfo
GPUBufferCreateInfo :: struct #align (4) {
	usage: GPUBufferUsageFlags,
	size: Uint32,
	props: PropertiesID,
}
#assert(size_of(GPUBufferCreateInfo) == 12)

/// SDL_GPUTransferBufferCreateInfo
GPUTransferBufferCreateInfo :: struct #align (4) {
	usage: GPUTransferBufferUsage,
	size: Uint32,
	props: PropertiesID,
}
#assert(size_of(GPUTransferBufferCreateInfo) == 12)

/// SDL_GPURasterizerState
GPURasterizerState :: struct #align (4) {
	fill_mode: GPUFillMode,
	cull_mode: GPUCullMode,
	front_face: GPUFrontFace,
	depth_bias_constant_factor: cffi.float,
	depth_bias_clamp: cffi.float,
	depth_bias_slope_factor: cffi.float,
	enable_depth_bias: cffi.bool,
	enable_depth_clip: cffi.bool,
	padding1: Uint8,
	padding2: Uint8,
}
#assert(size_of(GPURasterizerState) == 28)

/// SDL_GPUMultisampleState
GPUMultisampleState :: struct #align (4) {
	sample_count: GPUSampleCount,
	sample_mask: Uint32,
	enable_mask: cffi.bool,
	padding1: Uint8,
	padding2: Uint8,
	padding3: Uint8,
}
#assert(size_of(GPUMultisampleState) == 12)

/// SDL_GPUDepthStencilState
GPUDepthStencilState :: struct #align (4) {
	compare_op: GPUCompareOp,
	back_stencil_state: GPUStencilOpState,
	front_stencil_state: GPUStencilOpState,
	compare_mask: Uint8,
	write_mask: Uint8,
	enable_depth_test: cffi.bool,
	enable_depth_write: cffi.bool,
	enable_stencil_test: cffi.bool,
	padding1: Uint8,
	padding2: Uint8,
	padding3: Uint8,
}
#assert(size_of(GPUDepthStencilState) == 44)

/// SDL_GPUColorTargetDescription
GPUColorTargetDescription :: struct #align (4) {
	format: GPUTextureFormat,
	blend_state: GPUColorTargetBlendState,
}
#assert(size_of(GPUColorTargetDescription) == 36)

/// SDL_GPUGraphicsPipelineTargetInfo
GPUGraphicsPipelineTargetInfo :: struct #align (8) {
	color_target_descriptions: ^GPUColorTargetDescription,
	num_color_targets: Uint32,
	depth_stencil_format: GPUTextureFormat,
	has_depth_stencil_target: cffi.bool,
	padding1: Uint8,
	padding2: Uint8,
	padding3: Uint8,
}
#assert(size_of(GPUGraphicsPipelineTargetInfo) == 24)

/// SDL_GPUGraphicsPipelineCreateInfo
GPUGraphicsPipelineCreateInfo :: struct #align (8) {
	vertex_shader: ^GPUShader,
	fragment_shader: ^GPUShader,
	vertex_input_state: GPUVertexInputState,
	primitive_type: GPUPrimitiveType,
	rasterizer_state: GPURasterizerState,
	multisample_state: GPUMultisampleState,
	depth_stencil_state: GPUDepthStencilState,
	target_info: GPUGraphicsPipelineTargetInfo,
	props: PropertiesID,
}
#assert(size_of(GPUGraphicsPipelineCreateInfo) == 168)

/// SDL_GPUComputePipelineCreateInfo
GPUComputePipelineCreateInfo :: struct #align (8) {
	code_size: cffi.size_t,
	code: ^Uint8,
	entrypoint: cstring,
	format: GPUShaderFormat,
	num_samplers: Uint32,
	num_readonly_storage_textures: Uint32,
	num_readonly_storage_buffers: Uint32,
	num_readwrite_storage_textures: Uint32,
	num_readwrite_storage_buffers: Uint32,
	num_uniform_buffers: Uint32,
	threadcount_x: Uint32,
	threadcount_y: Uint32,
	threadcount_z: Uint32,
	props: PropertiesID,
}
#assert(size_of(GPUComputePipelineCreateInfo) == 72)

/// SDL_GPUColorTargetInfo
GPUColorTargetInfo :: struct #align (8) {
	texture: ^GPUTexture,
	mip_level: Uint32,
	layer_or_depth_plane: Uint32,
	clear_color: FColor,
	load_op: GPULoadOp,
	store_op: GPUStoreOp,
	resolve_texture: ^GPUTexture,
	resolve_mip_level: Uint32,
	resolve_layer: Uint32,
	cycle: cffi.bool,
	cycle_resolve_texture: cffi.bool,
	padding1: Uint8,
	padding2: Uint8,
}
#assert(size_of(GPUColorTargetInfo) == 64)

/// SDL_GPUDepthStencilTargetInfo
GPUDepthStencilTargetInfo :: struct #align (8) {
	texture: ^GPUTexture,
	clear_depth: cffi.float,
	load_op: GPULoadOp,
	store_op: GPUStoreOp,
	stencil_load_op: GPULoadOp,
	stencil_store_op: GPUStoreOp,
	cycle: cffi.bool,
	clear_stencil: Uint8,
	padding1: Uint8,
	padding2: Uint8,
}
#assert(size_of(GPUDepthStencilTargetInfo) == 32)

/// SDL_GPUBlitInfo
GPUBlitInfo :: struct #align (8) {
	source: GPUBlitRegion,
	destination: GPUBlitRegion,
	load_op: GPULoadOp,
	clear_color: FColor,
	flip_mode: FlipMode,
	filter: GPUFilter,
	cycle: cffi.bool,
	padding1: Uint8,
	padding2: Uint8,
	padding3: Uint8,
}
#assert(size_of(GPUBlitInfo) == 96)

/// SDL_GPUBufferBinding
GPUBufferBinding :: struct #align (8) {
	buffer: ^GPUBuffer,
	offset: Uint32,
}
#assert(size_of(GPUBufferBinding) == 16)

/// SDL_GPUTextureSamplerBinding
GPUTextureSamplerBinding :: struct #align (8) {
	texture: ^GPUTexture,
	sampler: ^GPUSampler,
}
#assert(size_of(GPUTextureSamplerBinding) == 16)

/// SDL_GPUStorageBufferReadWriteBinding
GPUStorageBufferReadWriteBinding :: struct #align (8) {
	buffer: ^GPUBuffer,
	cycle: cffi.bool,
	padding1: Uint8,
	padding2: Uint8,
	padding3: Uint8,
}
#assert(size_of(GPUStorageBufferReadWriteBinding) == 16)

/// SDL_GPUStorageTextureReadWriteBinding
GPUStorageTextureReadWriteBinding :: struct #align (8) {
	texture: ^GPUTexture,
	mip_level: Uint32,
	layer: Uint32,
	cycle: cffi.bool,
	padding1: Uint8,
	padding2: Uint8,
	padding3: Uint8,
}
#assert(size_of(GPUStorageTextureReadWriteBinding) == 24)

/// SDL_Haptic
Haptic :: struct {}

/// SDL_HapticDirection
HapticDirection :: struct #align (4) {
	type: Uint8,
	dir: [3]Sint32,
}
#assert(size_of(HapticDirection) == 16)

/// SDL_HapticConstant
HapticConstant :: struct #align (4) {
	type: Uint16,
	direction: HapticDirection,
	length: Uint32,
	delay: Uint16,
	button: Uint16,
	interval: Uint16,
	level: Sint16,
	attack_length: Uint16,
	attack_level: Uint16,
	fade_length: Uint16,
	fade_level: Uint16,
}
#assert(size_of(HapticConstant) == 40)

/// SDL_HapticPeriodic
HapticPeriodic :: struct #align (4) {
	type: Uint16,
	direction: HapticDirection,
	length: Uint32,
	delay: Uint16,
	button: Uint16,
	interval: Uint16,
	period: Uint16,
	magnitude: Sint16,
	offset: Sint16,
	phase: Uint16,
	attack_length: Uint16,
	attack_level: Uint16,
	fade_length: Uint16,
	fade_level: Uint16,
}
#assert(size_of(HapticPeriodic) == 48)

/// SDL_HapticCondition
HapticCondition :: struct #align (4) {
	type: Uint16,
	direction: HapticDirection,
	length: Uint32,
	delay: Uint16,
	button: Uint16,
	interval: Uint16,
	right_sat: [3]Uint16,
	left_sat: [3]Uint16,
	right_coeff: [3]Sint16,
	left_coeff: [3]Sint16,
	deadband: [3]Uint16,
	center: [3]Sint16,
}
#assert(size_of(HapticCondition) == 68)

/// SDL_HapticRamp
HapticRamp :: struct #align (4) {
	type: Uint16,
	direction: HapticDirection,
	length: Uint32,
	delay: Uint16,
	button: Uint16,
	interval: Uint16,
	start: Sint16,
	end: Sint16,
	attack_length: Uint16,
	attack_level: Uint16,
	fade_length: Uint16,
	fade_level: Uint16,
}
#assert(size_of(HapticRamp) == 44)

/// SDL_HapticLeftRight
HapticLeftRight :: struct #align (4) {
	type: Uint16,
	length: Uint32,
	large_magnitude: Uint16,
	small_magnitude: Uint16,
}
#assert(size_of(HapticLeftRight) == 12)

/// SDL_HapticCustom
HapticCustom :: struct #align (8) {
	type: Uint16,
	direction: HapticDirection,
	length: Uint32,
	delay: Uint16,
	button: Uint16,
	interval: Uint16,
	channels: Uint8,
	period: Uint16,
	samples: Uint16,
	data: ^Uint16,
	attack_length: Uint16,
	attack_level: Uint16,
	fade_length: Uint16,
	fade_level: Uint16,
}
#assert(size_of(HapticCustom) == 56)

/// SDL_hid_device
hid_device :: struct {}

/// SDL_hid_device_info
hid_device_info :: struct #align (8) {
	path: cstring,
	vendor_id: cffi.ushort,
	product_id: cffi.ushort,
	serial_number: ^cffi.wchar_t,
	release_number: cffi.ushort,
	manufacturer_string: ^cffi.wchar_t,
	product_string: ^cffi.wchar_t,
	usage_page: cffi.ushort,
	usage: cffi.ushort,
	interface_number: cffi.int,
	interface_class: cffi.int,
	interface_subclass: cffi.int,
	interface_protocol: cffi.int,
	bus_type: hid_bus_type,
	next: ^hid_device_info,
}
#assert(size_of(hid_device_info) == 80)

/// SDL_SharedObject
SharedObject :: struct {}

/// SDL_Locale
Locale :: struct #align (8) {
	language: cstring,
	country: cstring,
}
#assert(size_of(Locale) == 16)

/// SDL_MessageBoxButtonData
MessageBoxButtonData :: struct #align (8) {
	flags: MessageBoxButtonFlags,
	buttonID: cffi.int,
	text: cstring,
}
#assert(size_of(MessageBoxButtonData) == 16)

/// SDL_MessageBoxColor
MessageBoxColor :: struct #align (1) {
	r: Uint8,
	g: Uint8,
	b: Uint8,
}
#assert(size_of(MessageBoxColor) == 3)

/// SDL_MessageBoxColorScheme
MessageBoxColorScheme :: struct #align (1) {
	colors: [5]MessageBoxColor,
}
#assert(size_of(MessageBoxColorScheme) == 15)

/// SDL_MessageBoxData
MessageBoxData :: struct #align (8) {
	flags: MessageBoxFlags,
	window: ^Window,
	title: cstring,
	message: cstring,
	numbuttons: cffi.int,
	buttons: ^MessageBoxButtonData,
	colorScheme: ^MessageBoxColorScheme,
}
#assert(size_of(MessageBoxData) == 56)

/// SDL_Process
Process :: struct {}

/// SDL_Vertex
Vertex :: struct #align (4) {
	position: FPoint,
	color: FColor,
	tex_coord: FPoint,
}
#assert(size_of(Vertex) == 32)

/// SDL_Renderer
Renderer :: struct {}

/// SDL_Texture
Texture :: struct #align (4) {
	format: PixelFormat,
	w: cffi.int,
	h: cffi.int,
	refcount: cffi.int,
}
#assert(size_of(Texture) == 16)

/// SDL_StorageInterface
StorageInterface :: struct #align (8) {
	version: Uint32,
	close: proc "c" (userdata: rawptr) -> cffi.bool,
	ready: proc "c" (userdata: rawptr) -> cffi.bool,
	enumerate: proc "c" (userdata: rawptr, path: cstring, callback: EnumerateDirectoryCallback, callback_userdata: rawptr) -> cffi.bool,
	info: proc "c" (userdata: rawptr, path: cstring, info: ^PathInfo) -> cffi.bool,
	read_file: proc "c" (userdata: rawptr, path: cstring, destination: rawptr, length: Uint64) -> cffi.bool,
	write_file: proc "c" (userdata: rawptr, path: cstring, source: rawptr, length: Uint64) -> cffi.bool,
	mkdir: proc "c" (userdata: rawptr, path: cstring) -> cffi.bool,
	remove: proc "c" (userdata: rawptr, path: cstring) -> cffi.bool,
	rename: proc "c" (userdata: rawptr, oldpath: cstring, newpath: cstring) -> cffi.bool,
	copy: proc "c" (userdata: rawptr, oldpath: cstring, newpath: cstring) -> cffi.bool,
	space_remaining: proc "c" (userdata: rawptr) -> Uint64,
}
#assert(size_of(StorageInterface) == 96)

/// SDL_Storage
Storage :: struct {}

/// SDL_DateTime
DateTime :: struct #align (4) {
	year: cffi.int,
	month: cffi.int,
	day: cffi.int,
	hour: cffi.int,
	minute: cffi.int,
	second: cffi.int,
	nanosecond: cffi.int,
	day_of_week: cffi.int,
	utc_offset: cffi.int,
}
#assert(size_of(DateTime) == 36)

/// SDL_Event
Event :: struct #raw_union #align (8) {
	type: EventType,
	common: CommonEvent,
	display: DisplayEvent,
	window: WindowEvent,
	kdevice: KeyboardDeviceEvent,
	key: KeyboardEvent,
	edit: TextEditingEvent,
	edit_candidates: TextEditingCandidatesEvent,
	text: TextInputEvent,
	mdevice: MouseDeviceEvent,
	motion: MouseMotionEvent,
	button: MouseButtonEvent,
	wheel: MouseWheelEvent,
	jdevice: JoyDeviceEvent,
	jaxis: JoyAxisEvent,
	jball: JoyBallEvent,
	jhat: JoyHatEvent,
	jbutton: JoyButtonEvent,
	jbattery: JoyBatteryEvent,
	gdevice: GamepadDeviceEvent,
	gaxis: GamepadAxisEvent,
	gbutton: GamepadButtonEvent,
	gtouchpad: GamepadTouchpadEvent,
	gsensor: GamepadSensorEvent,
	adevice: AudioDeviceEvent,
	cdevice: CameraDeviceEvent,
	sensor: SensorEvent,
	quit: QuitEvent,
	user: UserEvent,
	tfinger: TouchFingerEvent,
	pproximity: PenProximityEvent,
	ptouch: PenTouchEvent,
	pmotion: PenMotionEvent,
	pbutton: PenButtonEvent,
	paxis: PenAxisEvent,
	drop: DropEvent,
	clipboard: ClipboardEvent,
	padding: [128]Uint8,
}
#assert(size_of(Event) == 128)

/// SDL_HapticEffect
HapticEffect :: struct #raw_union #align (8) {
	type: Uint16,
	constant: HapticConstant,
	periodic: HapticPeriodic,
	condition: HapticCondition,
	ramp: HapticRamp,
	leftright: HapticLeftRight,
	custom: HapticCustom,
}
#assert(size_of(HapticEffect) == 72)

/// _XEvent
_XEvent :: struct {}

GPUShaderFormat :: enum cffi.uint32_t {
	INVALID  = 0,
	PRIVATE  = 1,
	SPIRV    = 2,
	DXBC     = 3,
	DXIL     = 4,
	MSL      = 5,
	METALLIB = 6,
}
GPUShaderFormats :: bit_set[GPUShaderFormat; cffi.uint32_t]
