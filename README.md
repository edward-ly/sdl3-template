<!--
SPDX-FileCopyrightText: none

SPDX-License-Identifier: CC0-1.0
-->

# SDL3 App Template

A template project that aims to make it as easy as possible to get started
with the development of cross-platform games/apps made in [SDL3].

Based on the [SDL_helloworld] example project.

## Build

### Dependencies

- [GNU Make]
- [CMake]
- [Android SDK Command-Line Tools] (Android only)
- [OpenJDK] 17 (Android only)
- [Inkscape] (Android only)
- [Emscripten SDK] (Web only)

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
`android/app/build/outputs/apk`.

Or, to install the app directly onto a mobile device for debugging,
run `make android-dev`
(requires a USB-connected Android device).

### Desktop / Web

Run `make desktop` or `make web` accordingly,
which will generate the executable in `build/sdl-helloworld` once completed.

If you want to build the app using the system-installed version of SDL instead,
append `DOWNLOAD_DEPENDENCIES=OFF` to the appropriate command.

## Development

### Initializing your app

Customizing the template for your app just requires opening the `.env` file
and changing the template values to your liking.

You should also create your own icons for the Android app
(we recommend [Inkscape] for creating scalable vector images).
Save the finished icons in the `assets/` directory,
overwriting the template icons.

Then,
you can run `make android` to apply the changes to the Android project files
and build your custom Android app.
Commit the changes to the repository afterwards.

The `makefile` itself contains scripts for performing common operations
including building and installing the app for all supported platforms.
Run `make` to see the list of available options.

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
[Inkscape]: https://inkscape.org/
[Emscripten SDK]: https://emscripten.org/

[Cppcheck]: https://cppcheck.sourceforge.io/
[Uncrustify]: https://uncrustify.sourceforge.net/
