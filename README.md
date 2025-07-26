## Telegram messenger for Android

[![Build Status](https://github.com/wolfsilver/iTelegram/workflows/Build%20Status/badge.svg)](https://github.com/wolfsilver/iTelegram/actions)
[![Development Build](https://github.com/wolfsilver/iTelegram/workflows/Build%20APK%20(Development)/badge.svg)](https://github.com/wolfsilver/iTelegram/actions)
[![Release Build](https://github.com/wolfsilver/iTelegram/workflows/Build%20and%20Release%20APK/badge.svg)](https://github.com/wolfsilver/iTelegram/releases)

[Telegram](https://telegram.org) is a messaging app with a focus on speed and security. It's superfast, simple and free.
This repo contains the official source code for [Telegram App for Android](https://play.google.com/store/apps/details?id=org.telegram.messenger).elegram messenger for Android

[Telegram](https://telegram.org) is a messaging app with a focus on speed and security. It’s superfast, simple and free.
This repo contains the official source code for [Telegram App for Android](https://play.google.com/store/apps/details?id=org.telegram.messenger).

## Creating your Telegram Application

We welcome all developers to use our API and source code to create applications on our platform.
There are several things we require from **all developers** for the moment.

1. [**Obtain your own api_id**](https://core.telegram.org/api/obtaining_api_id) for your application.
2. Please **do not** use the name Telegram for your app — or make sure your users understand that it is unofficial.
3. Kindly **do not** use our standard logo (white paper plane in a blue circle) as your app's logo.
3. Please study our [**security guidelines**](https://core.telegram.org/mtproto/security_guidelines) and take good care of your users' data and privacy.
4. Please remember to publish **your** code too in order to comply with the licences.

### API, Protocol documentation

Telegram API manuals: https://core.telegram.org/api

MTproto protocol manuals: https://core.telegram.org/mtproto

### Compilation Guide

**Note**: In order to support [reproducible builds](https://core.telegram.org/reproducible-builds), this repo contains dummy release.keystore,  google-services.json and filled variables inside BuildVars.java. Before publishing your own APKs please make sure to replace all these files with your own.

You will require Android Studio 3.4, Android NDK rev. 20 and Android SDK 8.1

1. Download the Telegram source code from https://github.com/DrKLO/Telegram ( git clone https://github.com/DrKLO/Telegram.git )
2. Copy your release.keystore into TMessagesProj/config
3. Fill out RELEASE_KEY_PASSWORD, RELEASE_KEY_ALIAS, RELEASE_STORE_PASSWORD in gradle.properties to access your  release.keystore
4.  Go to https://console.firebase.google.com/, create two android apps with application IDs org.telegram.messenger and org.telegram.messenger.beta, turn on firebase messaging and download google-services.json, which should be copied to the same folder as TMessagesProj.
5. Open the project in the Studio (note that it should be opened, NOT imported).
6. Fill out values in TMessagesProj/src/main/java/org/telegram/messenger/BuildVars.java – there’s a link for each of the variables showing where and which data to obtain.
7. You are ready to compile Telegram.

## Automated Builds with GitHub Actions

This repository includes GitHub Actions workflows for automated building and releasing:

### 🚀 Release Builds
- **Trigger**: Push tags with `release-*` prefix or manual dispatch
- **Output**: Creates pre-release on GitHub with APKs and Bundles
- **Files**: Standalone, Play Store, and Huawei versions + bundles
- **Verification**: Includes SHA256 checksums for build verification

### 🔧 Development Builds  
- **Trigger**: Push to main branches or pull requests
- **Output**: Artifacts uploaded for 7 days
- **Purpose**: Quick validation during development

### Usage
```bash
# Create a release build
git tag release-9.3.3_3026
git push origin release-9.3.3_3026

# Or manually trigger from GitHub Actions page
```

For detailed instructions, see [GitHub Actions README](.github/README.md).

### Build Verification
Use the included verification script to check reproducible builds:
```bash
./verify-build.sh release-9.3.3_3026 downloaded-apk-file.apk
```

## Reproducible Builds

This project supports [reproducible builds](https://core.telegram.org/reproducible-builds). The GitHub Actions workflows generate the same APKs as the official Telegram builds when using the same source code version.

### Localization

We moved all translations to https://translations.telegram.org/en/android/. Please use it.
