# SDL3 Android Template

A template project that aims to make it as easy as possible to get started
with the development of mobile games/apps made in [SDL3].

Based on the [SDL_helloworld] example project.

## Build

### Dependencies

- [GNU Make]
- [CMake]
- [Android SDK Command-Line Tools] (Android only)
- [OpenJDK] 17 (Android only)
- [Emscripten SDK] (Web only)
<!-- - [Inkscape] (Android only) -->

SDL itself is not required to be installed on your system.
It will be automatically downloaded as needed when building the app.

### Android

Building the Android app requires installing the command-line tools
and accepting the relevant license terms.

On Arch Linux, this can be achieved with:

```sh
sudo pacman -S --needed android-tools jdk17-openjdk
yay -S --needed android-sdk-cmdline-tools-latest
sudo sdkmanager --licenses
```

Afterwards, run `make android`,
which will generate the `.apk` binaries in
`android-project/app/build/outputs/apk`.

Or, to install the app directly onto a mobile device for debugging,
run `make android-dev`
(requires a USB-connected Android device).

### Desktop / Web

Run `make desktop` or `make web` accordingly,
which will generate the executable in `build/sdl-helloworld` once completed.

If you want to build the app using the system-installed version of SDL instead,
append `DOWNLOAD_DEPENDENCIES=OFF` to the appropriate command.

## Development

### (Optional) Set up linting tools

This project uses [Cppcheck] and [Uncrustify]
for static code analysis and formatting, respectively.

The `uncrustify.cfg` file documents the currently enforced code style,
but feel free to change the style however you like.

A `make lint` command is provided to check that the code conforms to both tools,
as well as a `make lint-fix` command to fix any errors found.

You can also add the `make lint` command as a pre-commit hook:

```sh
echo 'make -s lint' >> .git/hooks/pre-commit
```

<!-- Links -->

[SDL3]: http://libsdl.org/
[SDL_helloworld]: https://github.com/libsdl-org/SDL_helloworld
[GNU Make]: http://www.gnu.org/software/make/
[CMake]: https://cmake.org/
[Android SDK Command-Line Tools]:
	https://developer.android.com/tools/releases/cmdline-tools
[OpenJDK]: https://openjdk.org/
<!-- [Inkscape]: https://inkscape.org/ -->
[Emscripten SDK]: https://emscripten.org/

[Cppcheck]: https://cppcheck.sourceforge.io/
[Uncrustify]: https://uncrustify.sourceforge.net/
