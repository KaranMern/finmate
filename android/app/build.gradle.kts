import java.util.Properties
import java.io.FileInputStream

plugins {
    id("com.android.application")
    // START: FlutterFire Configuration
    id("com.google.gms.google-services")
    // END: FlutterFire Configuration
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}
val keystoreProperties = new Properties()
val androidKeyFile = rootProject.file("android/local.properties")
val rootKeyFile = rootProject.file("local.properties")
if (androidKeyFile.exists()) {
    keystoreProperties.load(new FileInputStream(androidKeyFile))
    println "✅ Keystore file loaded successfully from android directory."
} else if (rootKeyFile.exists()) {
    keystoreProperties.load(new FileInputStream(rootKeyFile))
    println "✅ Keystore file loaded successfully from root directory."
}

android {
    namespace = "com.example.finmate"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
        isCoreLibraryDesugaringEnabled = true
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
        applicationId = "com.example.finmate"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }
    signingConfigs {
        create("release") {
            storeFile = file(keystoreProperties["signIn.file"].toString())
            storePassword = keystoreProperties["signIn.storePassword"].toString()
            keyAlias = keystoreProperties["signIn.keyAliase"].toString()
            keyPassword = keystoreProperties["signIn.keyPassword"].toString()
        }
    }

    buildTypes {
        release {
            // TODO: Add your own signing config for the release build.
            // Signing with the debug keys for now, so `flutter run --release` works.
            signingConfig = signingConfigs.getByName("debug")
            signingConfig = signingConfigs.getByName("release")
            isMinifyEnabled = false
        }
    }
}

flutter {
    source = "../.."
}
dependencies{
    implementation(platform("com.google.firebase:firebase-bom:34.2.0"))
    implementation("com.google.firebase:firebase-auth")
    coreLibraryDesugaring ("com.android.tools:desugar_jdk_libs:2.1.5")
}