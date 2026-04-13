## Android Setup for Kotlin DSL

**The following steps are required for Android projects using `build.gradle.kts`.**

This guide is the Kotlin DSL version of [ANDROID.md](./ANDROID.md).

## 1. Apply `dotenv.gradle`

In your app module file `android/app/build.gradle.kts`, add the env mapping first:

```kotlin
extra["envConfigFiles"] = mapOf(
    "developdebug" to ".env.develop",
    "uatdebug" to ".env.uat",
    "productiondebug" to ".env.production",
    "developrelease" to ".env.develop",
    "uatrelease" to ".env.uat",
    "productionrelease" to ".env.production",
)
```

Then apply the plugin script:

```kotlin
apply(from = project(":flutter_flavor_config").projectDir.path + "/dotenv.gradle")
```

Important:
- The keys in `envConfigFiles` must be lowercase.
- The plugin matches values like `developdebug`, `uatrelease`, `productiondebug`.
- Your `.env.*` files should live at the Flutter app root, for example:
  - `.env.develop`
  - `.env.uat`
  - `.env.production`

## 2. Enable `BuildConfig`

The plugin writes variables into `BuildConfig`, so with newer AGP versions you must enable it explicitly:

```kotlin
android {
    buildFeatures {
        buildConfig = true
    }
}
```

## 3. Add Product Flavors

Example:

```kotlin
android {
    flavorDimensions += "default"

    productFlavors {
        create("develop") {
            dimension = "default"
            applicationId = "com.example.app.develop"
            resValue("string", "app_name", "App Develop")
        }
        create("uat") {
            dimension = "default"
            applicationId = "com.example.app.uat"
            resValue("string", "app_name", "App UAT")
        }
        create("production") {
            dimension = "default"
            applicationId = "com.example.app"
            resValue("string", "app_name", "App")
        }
    }
}
```

## 4. Use Flavor-Based App Name

In `android/app/src/main/AndroidManifest.xml`, use:

```xml
<application
    android:label="@string/app_name"
    android:name="${applicationName}"
    android:icon="@mipmap/ic_launcher">
```

Then each flavor can override the displayed app name using:

```kotlin
resValue("string", "app_name", "App Develop")
```

## 5. Different Package Names

If your `applicationId` changes by flavor, make sure the plugin still knows which `BuildConfig` package to read:

```kotlin
android {
    defaultConfig {
        resValue("string", "build_config_package", "com.example.app")
    }
}
```

Set this to the package that owns the generated `BuildConfig` class for your app.

## 6. Usage in Kotlin/Java Code

Config variables are exposed through `BuildConfig`:

```kotlin
fun getBaseUrl(): String {
    return BuildConfig.BASE_URL
}
```

## 7. Usage in XML Files

Variables are also available as Android string resources:

```xml
<meta-data
    android:name="com.google.android.geo.API_KEY"
    android:value="@string/GOOGLE_MAPS_API_KEY" />
```

## 8. Example `build.gradle.kts`

This is a complete example based on the `exam_kts` sample:

```kotlin
plugins {
    id("com.android.application")
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
}

extra["envConfigFiles"] = mapOf(
    "developdebug" to ".env.develop",
    "uatdebug" to ".env.uat",
    "productiondebug" to ".env.production",
    "developrelease" to ".env.develop",
    "uatrelease" to ".env.uat",
    "productionrelease" to ".env.production",
)

apply(from = project(":flutter_flavor_config").projectDir.path + "/dotenv.gradle")

android {
    namespace = "com.example.exam_kts"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_17.toString()
    }

    buildFeatures {
        buildConfig = true
    }

    flavorDimensions += "default"

    productFlavors {
        create("develop") {
            dimension = "default"
            applicationId = "com.examkts.develop"
            resValue("string", "app_name", "develop")
        }
        create("uat") {
            dimension = "default"
            applicationId = "com.examkts.uat"
            resValue("string", "app_name", "uat")
        }
        create("production") {
            dimension = "default"
            applicationId = "com.examkts.production"
            resValue("string", "app_name", "production")
        }
    }

    defaultConfig {
        applicationId = "com.example.exam_kts"
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
        resValue("string", "build_config_package", "com.example.exam_kts")
    }
}
```

## 9. Build Commands

Examples:

```bash
flutter run --flavor develop --dart-define=FLUTTER_APP_FLAVOR=develop
flutter run --flavor uat --dart-define=FLUTTER_APP_FLAVOR=uat
flutter run --flavor production --dart-define=FLUTTER_APP_FLAVOR=production
```

Or with Gradle:

```bash
cd android
./gradlew assembleDevelopDebug
./gradlew assembleUatRelease
./gradlew assembleProductionRelease
```

## 10. Notes

- All values loaded from `.env` are strings.
- Do not put sensitive secrets in `.env` for mobile apps.
- If release builds return `null`, add a ProGuard keep rule for `BuildConfig`.
- For modern Android stacks, make sure your app uses a compatible JDK, AGP, Kotlin, and Gradle version.
