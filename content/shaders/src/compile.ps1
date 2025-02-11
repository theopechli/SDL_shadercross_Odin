$SHADERCROSS = "./bins/windows/shadercross.exe"

Remove-Item -Recurse -Force "../compiled" -ErrorAction SilentlyContinue
New-Item -ItemType Directory -Path "../compiled/SPIRV", "../compiled/MSL", "../compiled/DXIL" -Force

Get-ChildItem -Path . -Filter "*.hlsl" -Recurse | ForEach-Object {
    $OUTPUT_SPIRV = (Join-Path (Resolve-Path "../compiled/SPIRV") $_.Name) -replace '\.hlsl$', '.spv'
    $OUTPUT_MSL = (Join-Path (Resolve-Path "../compiled/SPIRV") $_.Name) -replace '\.hlsl$', '.msl'
    $OUTPUT_DXIL = (Join-Path (Resolve-Path "../compiled/SPIRV") $_.Name) -replace '\.hlsl$', '.dxil'

    Push-Location "../../../"
    & $SHADERCROSS $_.FullName -o $OUTPUT_SPIRV
    & $SHADERCROSS $_.FullName -o $OUTPUT_MSL
    & $SHADERCROSS $_.FullName -o $OUTPUT_DXIL
    Pop-Location
}
