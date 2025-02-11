# SDL_shadercross_Odin

[Odin](https://odin-lang.org) bindings for [SDL_shadercross](https://github.com/libsdl-org/SDL_shadercross).

## Example

There is a simple example inside the `src` folder, which showcases both online and offline shader compilation. Online shader compilation is done via the `SDL_shadercross` API, and offline via the `shadercross` binary file.

***Note**: Online shader compilation is only available in the debug build.*

## Clone

To clone the repository, run:

```
git clone --recurse-submodules https://github.com/theopechli/SDL_shadercross_Odin
```

If you have cloned the repository without its submodules, then run:

```
git submodule update --init --recursive
```

## Build

Execute any of the following commands from the root of the repository.

### Linux

1. Run `./setup.sh`, which will generate the libraries needed to build and run the above example.
1. Build with `./build_debug.sh` or `./build_release.sh`
1. Run `./game_debug.bin` or `./game_release.bin`
1. While running `./game_debug.bin`, press `R` to recompile the shaders.

### Windows

1. Run `.\setup.ps1`, which will generate the libraries needed to build and run the above example.
1. Build with `.\build_debug.ps1` or `.\build_release.ps1`
1. Run `.\game_debug.exe` or `.\game_release.exe`
1. While running `.\game_debug.exe`, press `R` to recompile the shaders.

## Credits

Certain parts of the example were taken from [Karl Zylinski's hot reload template](https://github.com/karl-zylinski/odin-raylib-hot-reload-game-template). For example, setting up the context's tracking allocator and logger, and checking for bad frees and leaks.
