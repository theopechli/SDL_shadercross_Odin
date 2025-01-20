#!/usr/bin/env bash

shadercross="../../../bins/shadercross"

rm -rf "../compiled"
mkdir -p "../compiled/SPIRV" "../compiled/MSL" "../compiled/DXIL"

find ./ -type f \( -name "*.hlsl" \) -print0 |
    while IFS= read -r -d "" filename; do
        "${shadercross}" "$filename" -o "../compiled/SPIRV/${filename/.hlsl/.spv}"
        "${shadercross}" "$filename" -o "../compiled/MSL/${filename/.hlsl/.msl}"
        "${shadercross}" "$filename" -o "../compiled/DXIL/${filename/.hlsl/.dxil}"
    done
