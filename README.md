# SDL_shadercross_Odin

[Odin](https://odin-lang.org) bindings for [SDL_shadercross](https://github.com/libsdl-org/SDL_shadercross).

## Example

There is a simple example inside the `src` folder, which showcases both online and offline shader compilation. Online shader compilation is done via the `SDL_shadercross` API, and offline via the `shadercross` binary file.

*Note: Online shader compilation is only available in the debug build.*

## Build

Execute any of the following commands from the root of the repository.

### Linux

- Run `setup.sh`, which will generate the necessary files to build and run the above example.
- Build with `./build_debug.sh` or `./build_release.sh`
- Run `./game_debug.bin` or `./game_release.bin`
