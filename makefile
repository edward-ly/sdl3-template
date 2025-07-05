SDL_VERSION = 3.2.16

APP_NAME = sdl-helloworld
APP_VERSION = 0.1.0

ANDROID_DIR = android-project
ANDROID_BUILD_DIR = $(ANDROID_DIR)/app/build/outputs/apk
AAR_DIR = $(ANDROID_DIR)/app/libs

SDL_AAR = SDL3-$(SDL_VERSION).aar
SDL_ZIP = SDL3-devel-$(SDL_VERSION)-android.zip
SDL_ZIP_URL = https://github.com/libsdl-org/SDL/releases/download/release-$(SDL_VERSION)/$(SDL_ZIP)

BUILD_DIR = build
BUILD_EXE = $(BUILD_DIR)/$(APP_NAME)

CPPCHECK_FLAGS = --enable=warning,style,performance,portability \
	--std=c99 --inline-suppr --check-level=exhaustive --addon=y2038.py
CPPCHECK_LINT_FLAGS = $(CPPCHECK_FLAGS) -q --error-exitcode=1
CPPCHECK_FIX_FLAGS = $(CPPCHECK_FLAGS)
UNCRUSTIFY_FLAGS = -c uncrustify.cfg
UNCRUSTIFY_CHECK_FLAGS = $(UNCRUSTIFY_FLAGS) -q --check
UNCRUSTIFY_FIX_FLAGS = $(UNCRUSTIFY_FLAGS) --no-backup

SRC := $(shell git ls-files | grep \.[ch]$$)

.PHONY: help
.SILENT: help
help:
	echo "  Usage: make <target>"
	echo " "
	echo "  Possible <target> values:"
	echo " "
	echo "  help                show this help message (default)"
	echo " "
	echo "  > Build targets:"
	echo " "
	echo "  android             build the Android APK binary"
	echo "  desktop             build the desktop executable"
	echo "  web                 build the web executable"
	echo " "
	echo "  > Development targets:"
	echo " "
	echo "  android-dev         install the Android app onto a USB-connected device"
	echo "  android-devclean    uninstall the Android app from a USB-connected device"
	echo " "
	echo "  > Cleanup targets:"
	echo " "
	echo "  clean               delete all build artifacts and build cache"
	echo "  clean-android       delete all Android build artifacts and build cache"
	echo "  clean-desktop       delete all desktop build artifacts"
	echo "  distclean           same as clean, but also delete all intermediate build files"
	echo "  distclean-android   same as clean-android, but also delete all downloaded SDL Android archives"
	echo "  distclean-desktop   same as clean-desktop, but also delete desktop build cache"

.PHONY: desktop
desktop:
	cmake -B $(BUILD_DIR)
	cmake --build $(BUILD_DIR)

.PHONY: web
web:
	emcmake cmake -B $(BUILD_DIR)
	cmake --build $(BUILD_DIR)

.PHONY: android
android: $(AAR_DIR)/$(SDL_AAR)
	cd $(ANDROID_DIR) && ./gradlew assembleRelease

.PHONY: android-dev
android-dev: $(AAR_DIR)/$(SDL_AAR)
	cd $(ANDROID_DIR) && ./gradlew installDebug

.PHONY: android-devclean
android-devclean:
	cd $(ANDROID_DIR) && ./gradlew uninstallDebug

$(AAR_DIR)/$(SDL_AAR): $(AAR_DIR)/$(SDL_ZIP)
	unzip -nq $< $(SDL_AAR) -d $(AAR_DIR)

$(AAR_DIR)/$(SDL_ZIP):
	curl -SsLO --output-dir $(AAR_DIR) $(SDL_ZIP_URL)

.PHONY: lint
lint:
	cppcheck $(CPPCHECK_LINT_FLAGS) $(SRC)
	uncrustify $(UNCRUSTIFY_CHECK_FLAGS) $(SRC)

.PHONY: lint-fix
lint-fix:
	cppcheck $(CPPCHECK_FIX_FLAGS) $(SRC)
	uncrustify $(UNCRUSTIFY_FIX_FLAGS) $(SRC)

.PHONY: clean
clean: clean-android clean-desktop

.PHONY: clean-android
clean-android:
	rm -rf $(ANDROID_DIR)/build $(ANDROID_DIR)/app/build

.PHONY: clean-desktop
clean-desktop:
	rm -f $(BUILD_EXE)

.PHONY: distclean
distclean: distclean-android distclean-desktop

.PHONY: distclean-android
distclean-android: clean-android
	rm -rf $(AAR_DIR)/*.aar $(AAR_DIR)/*.zip

.PHONY: distclean-desktop
distclean-desktop:
	rm -rf $(BUILD_DIR)
