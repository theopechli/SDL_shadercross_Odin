#!/usr/bin/env bash

OS="linux"
PROJECT_DIR=$(pwd)
OUT_DIR="${PROJECT_DIR}"
OUT_EXE="game_debug.bin"
LIBS_DIR_NAME="libs"

EXTRA_LINKER_FLAGS="'-Wl,-rpath=\$ORIGIN/${LIBS_DIR_NAME}/${OS}'"

odin build ./src \
     -debug \
     -o:none \
     -vet \
     -strict-style \
     -max-error-count:1 \
     -define:USE_TRACKING_ALLOCATOR=true \
     -collection:bindings=bindings \
     -extra-linker-flags:"${EXTRA_LINKER_FLAGS}" \
     -out:"${OUT_DIR}/${OUT_EXE}"
