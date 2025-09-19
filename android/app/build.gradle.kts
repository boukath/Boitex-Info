plugins {
    id("com.android.application")
    id("org.jetbrains.kotlin.android")
    // Flutter's Gradle plugin
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.example.boitex_info"          // <-- change to your package
    compileSdk = 36                                 // required by flutter_local_notifications

    defaultConfig {
        applicationId = "com.example.boitex_info"   // <-- change to your app id
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName

        // not strictly required for desugaring, but helps if your method count gets high
        multiDexEnabled = true
    }

    // Java/Kotlin toolchains + desugaring
    compileOptions {
        // enable Java 8+ API desugaring
        isCoreLibraryDesugaringEnabled = true

        // keep source/target at 11 as recommended by the plugin docs
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }
    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    buildTypes {
        release {
            // debug signing so `flutter run --release` works out of the box
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

// point Flutter to your project root
flutter {
    source = "../.."
}

dependencies {
    // required for core library desugaring
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.4")
    // If you already have other dependencies here, keep them.
}
