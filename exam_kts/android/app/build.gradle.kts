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
            versionName = "1.0.0"
            resValue("string", "app_name", "develop")
        }
        create("uat") {
            dimension = "default"
            applicationId = "com.examkts.uat"
            versionName = "1.0.0"
            resValue("string", "app_name", "uat")
        }
        create("production") {
            dimension = "default"
            applicationId = "com.examkts.production"
            versionName = "1.0.0"
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

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

flutter {
    source = "../.."
}
