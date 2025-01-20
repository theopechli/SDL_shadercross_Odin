#!/usr/bin/env bash

OS="linux"
PROJECT_DIR=$(pwd)
OUT_DIR="${PROJECT_DIR}"
OUT_EXE="game_release.bin"
LIBS_DIR_NAME="libs"

(cd "./content/shaders/src" && ./compile.sh)

EXTRA_LINKER_FLAGS="'-Wl,-rpath=\$ORIGIN/${LIBS_DIR_NAME}/${OS}'"

odin build ./src \
     -o:speed \
     -vet \
     -strict-style \
     -no-bounds-check \
     -max-error-count:1 \
     -define:USE_TRACKING_ALLOCATOR=false \
     -collection:bindings=bindings \
     -extra-linker-flags:"${EXTRA_LINKER_FLAGS}" \
     -out:"${OUT_DIR}/${OUT_EXE}"
