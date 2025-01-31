#!/usr/bin/env bash

OS="linux"
PROJECT_DIR=$(pwd)
BINS_DIR="${PROJECT_DIR}/bins"
LIBS_DIR="${PROJECT_DIR}/libs/${OS}"

mkdir -p "${BINS_DIR}" "${LIBS_DIR}"


#### SDL_shadercross ####

SDL_SHADERCROSS_DIR="${PROJECT_DIR}/third_party/SDL_shadercross"
SDL_SHADERCROSS_LIBS_DIR="${PROJECT_DIR}/bindings/sdl_shadercross/libs/${OS}"
DIRECTX_SHADER_COMPILER_DIR="${SDL_SHADERCROSS_DIR}/external/DirectXShaderCompiler"
SDL_SHADERCROSS_BUILD_DIR="${SDL_SHADERCROSS_DIR}/build"
SPIRV_CROSS_BUILD_DIR="${SDL_SHADERCROSS_DIR}/spirv_cross_build"
DIRECTX_SHADER_COMPILER_BUILD_DIR="${SDL_SHADERCROSS_DIR}/external/DirectXShaderCompiler-binaries/linux"

mkdir -p "${SDL_SHADERCROSS_LIBS_DIR}"

cd "${SDL_SHADERCROSS_DIR}"

cmake -S external/SPIRV-Cross -B spirv_cross_build -GNinja \
      -DCMAKE_BUILD_TYPE=Release \
      -DSPIRV_CROSS_SHARED=ON \
      -DSPIRV_CROSS_STATIC=ON
cmake --build spirv_cross_build

cmake -P build-scripts/download-prebuilt-DirectXShaderCompiler.cmake

cmake -S . -B build -GNinja \
      -DCMAKE_BUILD_TYPE=Release \
      -DDirectXShaderCompiler_ROOT="${SDL_SHADERCROSS_DIR}/external/DirectXShaderCompiler-binaries" \
      -DSDLSHADERCROSS_SHARED=ON \
      -DSDLSHADERCROSS_STATIC=OFF \
      -DSDLSHADERCROSS_VENDORED=OFF \
      -DSDLSHADERCROSS_CLI=ON \
      -DSDLSHADERCROSS_WERROR=OFF \
      -DSDLSHADERCROSS_INSTALL=ON \
      -DSDLSHADERCROSS_INSTALL_RUNTIME=ON \
      -DSDLSHADERCROSS_INSTALL_CPACK=ON \
      -DCMAKE_PREFIX_PATH="${SPIRV_CROSS_BUILD_DIR}" \
      -DCMAKE_INSTALL_PREFIX="${SDL_SHADERCROSS_DIR}/sdl_shadercross_install_build"
cmake --build build

cp -f \
   "${SDL_SHADERCROSS_BUILD_DIR}/libSDL3_shadercross.so" \
   "${SDL_SHADERCROSS_BUILD_DIR}/libSDL3_shadercross.so.0" \
   "${SDL_SHADERCROSS_BUILD_DIR}/libSDL3_shadercross.so.0.0.0" \
   "${SDL_SHADERCROSS_BUILD_DIR}/vkd3d-prefix/lib/libvkd3d-shader.so" \
   "${SDL_SHADERCROSS_BUILD_DIR}/vkd3d-prefix/lib/libvkd3d-shader.so.1" \
   "${SDL_SHADERCROSS_BUILD_DIR}/vkd3d-prefix/lib/libvkd3d-shader.so.1.12.0" \
   "${SDL_SHADERCROSS_BUILD_DIR}/vkd3d-prefix/lib/libvkd3d.so" \
   "${SDL_SHADERCROSS_BUILD_DIR}/vkd3d-prefix/lib/libvkd3d.so.1" \
   "${SDL_SHADERCROSS_BUILD_DIR}/vkd3d-prefix/lib/libvkd3d.so.1.14.0" \
   "${SDL_SHADERCROSS_BUILD_DIR}/vkd3d-prefix/lib/libvkd3d-utils.so" \
   "${SDL_SHADERCROSS_BUILD_DIR}/vkd3d-prefix/lib/libvkd3d-utils.so.1" \
   "${SDL_SHADERCROSS_BUILD_DIR}/vkd3d-prefix/lib/libvkd3d-utils.so.1.6.0" \
   "${SPIRV_CROSS_BUILD_DIR}/libspirv-cross-c-shared.so" \
   "${SPIRV_CROSS_BUILD_DIR}/libspirv-cross-c-shared.so.0" \
   "${SPIRV_CROSS_BUILD_DIR}/libspirv-cross-c-shared.so.0.64.0" \
   "${DIRECTX_SHADER_COMPILER_BUILD_DIR}/lib/libdxcompiler.so" \
   "${DIRECTX_SHADER_COMPILER_BUILD_DIR}/lib/libdxil.so" \
   "${SDL_SHADERCROSS_LIBS_DIR}"

cp -f \
   "${SDL_SHADERCROSS_BUILD_DIR}/libSDL3_shadercross.so" \
   "${SDL_SHADERCROSS_BUILD_DIR}/libSDL3_shadercross.so.0" \
   "${SDL_SHADERCROSS_BUILD_DIR}/libSDL3_shadercross.so.0.0.0" \
   "${SDL_SHADERCROSS_BUILD_DIR}/vkd3d-prefix/lib/libvkd3d-shader.so" \
   "${SDL_SHADERCROSS_BUILD_DIR}/vkd3d-prefix/lib/libvkd3d-shader.so.1" \
   "${SDL_SHADERCROSS_BUILD_DIR}/vkd3d-prefix/lib/libvkd3d-shader.so.1.12.0" \
   "${SDL_SHADERCROSS_BUILD_DIR}/vkd3d-prefix/lib/libvkd3d.so" \
   "${SDL_SHADERCROSS_BUILD_DIR}/vkd3d-prefix/lib/libvkd3d.so.1" \
   "${SDL_SHADERCROSS_BUILD_DIR}/vkd3d-prefix/lib/libvkd3d.so.1.14.0" \
   "${SDL_SHADERCROSS_BUILD_DIR}/vkd3d-prefix/lib/libvkd3d-utils.so" \
   "${SDL_SHADERCROSS_BUILD_DIR}/vkd3d-prefix/lib/libvkd3d-utils.so.1" \
   "${SDL_SHADERCROSS_BUILD_DIR}/vkd3d-prefix/lib/libvkd3d-utils.so.1.6.0" \
   "${SPIRV_CROSS_BUILD_DIR}/libspirv-cross-c-shared.so" \
   "${SPIRV_CROSS_BUILD_DIR}/libspirv-cross-c-shared.so.0" \
   "${SPIRV_CROSS_BUILD_DIR}/libspirv-cross-c-shared.so.0.64.0" \
   "${DIRECTX_SHADER_COMPILER_BUILD_DIR}/lib/libdxcompiler.so" \
   "${DIRECTX_SHADER_COMPILER_BUILD_DIR}/lib/libdxil.so" \
   "${LIBS_DIR}"

cp -f \
   "${SDL_SHADERCROSS_BUILD_DIR}/shadercross" \
   "${DIRECTX_SHADER_COMPILER_BUILD_DIR}/bin/dxc" \
   "${BINS_DIR}"

cd "${PROJECT_DIR}"


#### SDL ####

SDL_DIR="${PROJECT_DIR}/third_party/SDL"
SDL_BUILD_DIR="${SDL_DIR}/build"
SDL_LIBS_DIR="${PROJECT_DIR}/bindings/sdl3/libs/${OS}"

mkdir -p "${SDL_LIBS_DIR}"

cd "${SDL_DIR}"

cmake -S . -B "${SDL_BUILD_DIR}" -GNinja \
      -DCMAKE_BUILD_TYPE=Release
cmake --build build

cp -f \
   "${SDL_BUILD_DIR}/libSDL3.so" \
   "${SDL_BUILD_DIR}/libSDL3.so.0" \
   "${SDL_BUILD_DIR}/libSDL3.so.0.1.11" \
   "${SDL_LIBS_DIR}"

cp -f \
   "${SDL_BUILD_DIR}/libSDL3.so" \
   "${SDL_BUILD_DIR}/libSDL3.so.0" \
   "${SDL_BUILD_DIR}/libSDL3.so.0.1.11" \
   "${LIBS_DIR}"

cd "${PROJECT_DIR}"
