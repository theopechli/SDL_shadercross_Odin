$OS = "windows"
$PROJECT_DIR = Get-Location
$BINS_DIR = Join-Path (Join-Path $PROJECT_DIR "bins") $OS

New-Item -ItemType Directory -Path $BINS_DIR -Force


#### SDL ####

$SDL_DIR = Join-Path $PROJECT_DIR "third_party/SDL"
$SDL_BUILD_DIR = Join-Path $SDL_DIR "build"
$SDL_LIBS_DIR = Join-Path (Join-Path $PROJECT_DIR "bindings/sdl3/libs") $OS

New-Item -ItemType Directory -Path $SDL_LIBS_DIR -Force

Set-Location $SDL_DIR

cmake -S . -B $SDL_BUILD_DIR -GNinja `
      -DCMAKE_BUILD_TYPE=Release
cmake --build build

Copy-Item -Path (Join-Path $SDL_BUILD_DIR "SDL3.lib") -Destination $SDL_LIBS_DIR -Force

Copy-Item -Path (Join-Path $SDL_BUILD_DIR "SDL3.dll") -Destination $PROJECT_DIR -Force

Set-Location $PROJECT_DIR


#### SDL_shadercross ####

$SDL_SHADERCROSS_DIR = Join-Path $PROJECT_DIR "third_party/SDL_shadercross"
$SDL_SHADERCROSS_LIBS_DIR = Join-Path (Join-Path $PROJECT_DIR "bindings/sdl_shadercross/libs") $OS
$DIRECTX_SHADER_COMPILER_DIR = Join-Path $SDL_SHADERCROSS_DIR "external/DirectXShaderCompiler"
$SDL_SHADERCROSS_BUILD_DIR = Join-Path $SDL_SHADERCROSS_DIR "build"
$SPIRV_CROSS_BUILD_DIR = Join-Path $SDL_SHADERCROSS_DIR "spirv_cross_build"
$DIRECTX_SHADER_COMPILER_BUILD_DIR = Join-Path $SDL_SHADERCROSS_DIR "external/DirectXShaderCompiler-binaries/windows"

New-Item -ItemType Directory -Path $SDL_SHADERCROSS_LIBS_DIR -Force

Set-Location $SDL_SHADERCROSS_DIR

cmake -S external/SPIRV-Cross -B spirv_cross_build -GNinja `
      -DCMAKE_BUILD_TYPE=Release `
      -DSPIRV_CROSS_SHARED=ON `
      -DSPIRV_CROSS_STATIC=ON
cmake --build spirv_cross_build

cmake -P build-scripts/download-prebuilt-DirectXShaderCompiler.cmake

cmake -S . -B build -GNinja `
      -DCMAKE_BUILD_TYPE=Release `
      -DDirectXShaderCompiler_ROOT="$SDL_SHADERCROSS_DIR/external/DirectXShaderCompiler-binaries" `
      -DSDLSHADERCROSS_SHARED=ON `
      -DSDLSHADERCROSS_STATIC=OFF `
      -DSDLSHADERCROSS_VENDORED=OFF `
      -DSDLSHADERCROSS_CLI=ON `
      -DSDLSHADERCROSS_WERROR=OFF `
      -DSDLSHADERCROSS_INSTALL=ON `
      -DSDLSHADERCROSS_INSTALL_RUNTIME=ON `
      -DSDLSHADERCROSS_INSTALL_CPACK=ON `
      -DCMAKE_PREFIX_PATH="$SPIRV_CROSS_BUILD_DIR" `
      -DSDL3_DIR="$SDL_BUILD_DIR" `
      -DCMAKE_INSTALL_PREFIX="$SDL_SHADERCROSS_DIR/sdl_shadercross_install_build"
cmake --build build

Copy-Item -Path (Join-Path $SDL_SHADERCROSS_BUILD_DIR "shadercross.exe") -Destination $BINS_DIR -Force
Copy-Item -Path (Join-Path $DIRECTX_SHADER_COMPILER_BUILD_DIR "bin/x64/dxc.exe") -Destination $BINS_DIR -Force

Copy-Item -Path (Join-Path $SDL_SHADERCROSS_BUILD_DIR "SDL3_shadercross.lib") -Destination $SDL_SHADERCROSS_LIBS_DIR -Force
Copy-Item -Path (Join-Path $SPIRV_CROSS_BUILD_DIR "spirv-cross-c-shared.lib") -Destination $SDL_SHADERCROSS_LIBS_DIR -Force

Copy-Item -Path (Join-Path $SDL_SHADERCROSS_BUILD_DIR "SDL3_shadercross.dll") -Destination $PROJECT_DIR -Force
Copy-Item -Path (Join-Path $SPIRV_CROSS_BUILD_DIR "spirv-cross-c-shared.dll") -Destination $PROJECT_DIR -Force
Copy-Item -Path (Join-Path $DIRECTX_SHADER_COMPILER_BUILD_DIR "bin/x64/dxcompiler.dll") -Destination $PROJECT_DIR -Force
Copy-Item -Path (Join-Path $DIRECTX_SHADER_COMPILER_BUILD_DIR "bin/x64/dxil.dll") -Destination $PROJECT_DIR -Force

Set-Location $PROJECT_DIR
