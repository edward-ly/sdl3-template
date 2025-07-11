include .env

ANDROID_DIR = android-project
ANDROID_BUILD_DIR = $(ANDROID_DIR)/app/build/outputs/apk
AAR_DIR = $(ANDROID_DIR)/app/libs
ANDROID_SRC_DIR = $(ANDROID_DIR)/app/src/main
ANDROID_JAVA_DIR = $(ANDROID_SRC_DIR)/java/$(subst .,/,$(APP_ID_ANDROID))
ANDROID_ACTIVITY_FILE = $(ANDROID_JAVA_DIR)/$(APP_ACTIVITY_CLASS_NAME).java
ANDROID_ICON_DIR = $(ANDROID_SRC_DIR)/res

SDL_AAR = SDL3-$(SDL_VERSION).aar
SDL_ZIP = SDL3-devel-$(SDL_VERSION)-android.zip
SDL_ZIP_URL = https://github.com/libsdl-org/SDL/releases/download/release-$(SDL_VERSION)/$(SDL_ZIP)

APP_ICON = assets/ic_launcher.svg
APP_ICON_ROUND = assets/ic_launcher_round.svg

BUILD_DIR = build
BUILD_EXE = $(BUILD_DIR)/$(APP_ID)

DOWNLOAD_DEPENDENCIES ?= ON
CMAKE_FLAGS = -DDOWNLOAD_DEPENDENCIES=$(DOWNLOAD_DEPENDENCIES) \
	-DAPP_VERSION="$(APP_VERSION)" -DAPP_NAME="$(APP_NAME)" -DAPP_ID="$(APP_ID)"
ifeq ($(DOWNLOAD_DEPENDENCIES),ON)
CMAKE_FLAGS += -DSDL_VERSION="$(SDL_VERSION)"
endif

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
	echo "  lint                run static analysis and beautifier on source code"
	echo "  lint-fix            same as lint, but also fix any errors found"
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
	cmake -B $(BUILD_DIR) $(CMAKE_FLAGS)
	cmake --build $(BUILD_DIR)

.PHONY: web
web:
	emcmake cmake -B $(BUILD_DIR) $(CMAKE_FLAGS)
	cmake --build $(BUILD_DIR)

.PHONY: android
android: $(AAR_DIR)/$(SDL_AAR) android-setup
	cd $(ANDROID_DIR) && ./gradlew assembleRelease

.PHONY: android-setup
android-setup:
	sed -i "s/\(rootProject.name = \).*/\1\"$(APP_NAME)\"/" $(ANDROID_DIR)/settings.gradle

	sed -i "/<activity/{ n; s/\(android:name=\"\)[^\"]*/\1$(APP_ID_ANDROID).$(APP_ACTIVITY_CLASS_NAME)/ }" $(ANDROID_SRC_DIR)/AndroidManifest.xml

	sed -i "s/\(namespace \).*/\1'$(APP_ID_ANDROID)'/" $(ANDROID_DIR)/app/build.gradle
	sed -i "s/\(applicationId \).*/\1'$(APP_ID_ANDROID)'/" $(ANDROID_DIR)/app/build.gradle
	sed -i "s/\(versionCode \).*/\1$(APP_VERSION_CODE_ANDROID)/" $(ANDROID_DIR)/app/build.gradle
	sed -i "s/\(versionName \).*/\1'$(APP_VERSION)'/" $(ANDROID_DIR)/app/build.gradle
	sed -i "s/\(-DAPP_VERSION=\)[^']*/\1$(APP_VERSION)/" $(ANDROID_DIR)/app/build.gradle
	sed -i "s/\(-DAPP_NAME=\)[^']*/\1$(APP_NAME)/" $(ANDROID_DIR)/app/build.gradle
	sed -i "s/\(-DAPP_ID=\)[^']*/\1$(APP_ID)/" $(ANDROID_DIR)/app/build.gradle
	sed -i "s/\(SDL3-\).*\(\.aar\)/\1$(SDL_VERSION)\2/" $(ANDROID_DIR)/app/build.gradle

	sed -i "s/[^>]*\(<\/string>\)/$(APP_NAME)\1/" $(ANDROID_ICON_DIR)/values/strings.xml

	inkscape --export-background-opacity=0 -w 48 -h 48 $(APP_ICON) -o $(ANDROID_ICON_DIR)/mipmap-mdpi/ic_launcher.png
	inkscape --export-background-opacity=0 -w 72 -h 72 $(APP_ICON) -o $(ANDROID_ICON_DIR)/mipmap-hdpi/ic_launcher.png
	inkscape --export-background-opacity=0 -w 96 -h 96 $(APP_ICON) -o $(ANDROID_ICON_DIR)/mipmap-xhdpi/ic_launcher.png
	inkscape --export-background-opacity=0 -w 144 -h 144 $(APP_ICON) -o $(ANDROID_ICON_DIR)/mipmap-xxhdpi/ic_launcher.png
	inkscape --export-background-opacity=0 -w 192 -h 192 $(APP_ICON) -o $(ANDROID_ICON_DIR)/mipmap-xxxhdpi/ic_launcher.png
	inkscape --export-background-opacity=0 -w 48 -h 48 $(APP_ICON_ROUND) -o $(ANDROID_ICON_DIR)/mipmap-mdpi/ic_launcher_round.png
	inkscape --export-background-opacity=0 -w 72 -h 72 $(APP_ICON_ROUND) -o $(ANDROID_ICON_DIR)/mipmap-hdpi/ic_launcher_round.png
	inkscape --export-background-opacity=0 -w 96 -h 96 $(APP_ICON_ROUND) -o $(ANDROID_ICON_DIR)/mipmap-xhdpi/ic_launcher_round.png
	inkscape --export-background-opacity=0 -w 144 -h 144 $(APP_ICON_ROUND) -o $(ANDROID_ICON_DIR)/mipmap-xxhdpi/ic_launcher_round.png
	inkscape --export-background-opacity=0 -w 192 -h 192 $(APP_ICON_ROUND) -o $(ANDROID_ICON_DIR)/mipmap-xxxhdpi/ic_launcher_round.png

	rm -rf $(ANDROID_SRC_DIR)/java
	mkdir -p $(ANDROID_JAVA_DIR)
	echo "package $(APP_ID_ANDROID);" > $(ANDROID_ACTIVITY_FILE)
	echo "" >> $(ANDROID_ACTIVITY_FILE)
	echo "import org.libsdl.app.SDLActivity;" >> $(ANDROID_ACTIVITY_FILE)
	echo "" >> $(ANDROID_ACTIVITY_FILE)
	echo "public class $(APP_ACTIVITY_CLASS_NAME) extends SDLActivity {" >> $(ANDROID_ACTIVITY_FILE)
	echo "	protected String[] getLibraries() {" >> $(ANDROID_ACTIVITY_FILE)
	echo "		return new String[] { \"SDL3\", \"$(APP_ID)\" };" >> $(ANDROID_ACTIVITY_FILE)
	echo "	}" >> $(ANDROID_ACTIVITY_FILE)
	echo "}" >> $(ANDROID_ACTIVITY_FILE)

.PHONY: android-dev
android-dev: $(AAR_DIR)/$(SDL_AAR) android-setup
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
