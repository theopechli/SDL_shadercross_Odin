$PROJECT_DIR = Get-Location
$OUT_DIR = $PROJECT_DIR
$OUT_EXE = "game_release.exe"

Push-Location "./content/shaders/src"
.\compile.ps1
Pop-Location

odin build ./src `
     -o:speed `
     -vet `
     -strict-style `
     -no-bounds-check `
     -max-error-count:1 `
     -subsystem:windows `
     -define:USE_TRACKING_ALLOCATOR=true `
     -collection:bindings=bindings `
     -out:"$OUT_DIR/$OUT_EXE"
