# SDL3 Android Template

A template project to assist with getting started in the development
of mobile games/apps made in [SDL3].

Based on the [SDL_helloworld] example project.

## Build

### Make Dependencies

- Android
	- [Android SDK Command-Line Tools]
	- [OpenJDK] 17
	<!-- - [Inkscape] -->
- Desktop
	- [CMake]
- Web
	- [CMake]
	- [Emscripten SDK]

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

<!--
## Contributing

This project uses [Cppcheck] and [Uncrustify]
for static code analysis and formatting, respectively.
After cloning the repository,
add the following pre-commit hooks:

```sh
git clone --recurse-submodules https://github.com/edward-ly/sdl3-android-template
cd sdl3-android-template
cp .git/hooks/pre-commit{.sample,}
echo '
cppcheck --error-exitcode=1
uncrustify -c uncrustify.cfg' >> .git/hooks/pre-commit
```
-->

<!-- Links -->

[SDL3]: http://libsdl.org/
[SDL_helloworld]: https://github.com/libsdl-org/SDL_helloworld
[Android SDK Command-Line Tools]:
	https://developer.android.com/tools/releases/cmdline-tools
[OpenJDK]: https://openjdk.org/
<!-- [Inkscape]: https://inkscape.org/ -->
[CMake]: https://cmake.org/
[Emscripten SDK]: https://emscripten.org/

<!-- [Cppcheck]: https://cppcheck.sourceforge.io/ -->
<!-- [Uncrustify]: https://uncrustify.sourceforge.net/ -->
