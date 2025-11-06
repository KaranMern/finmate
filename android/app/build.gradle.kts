import java.util.Properties
import java.io.FileInputStream

plugins {
    id("com.android.application")
    id("com.google.gms.google-services") // Firebase
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
}

val keystoreProperties = Properties()
val androidKeyFile = rootProject.file("android/local.properties")
val rootKeyFile = rootProject.file("local.properties")

if (androidKeyFile.exists()) {
    keystoreProperties.load(FileInputStream(androidKeyFile))
} else if (rootKeyFile.exists()) {
    keystoreProperties.load(FileInputStream(rootKeyFile))
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
        applicationId = "com.example.finmate"
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    signingConfigs {
        create("release") {
            storeFile = file(keystoreProperties["signIn.file"]?.toString() ?: "")
            storePassword = keystoreProperties["signIn.storePassword"]?.toString() ?: ""
            keyAlias = keystoreProperties["signIn.keyAlias"]?.toString() ?: ""
            keyPassword = keystoreProperties["signIn.keyPassword"]?.toString() ?: ""
        }
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("release")
            isMinifyEnabled = true
            isShrinkResources = true
        }
    }
}

flutter {
    source = "../.."
}

dependencies {
    implementation(platform("com.google.firebase:firebase-bom:34.2.0"))
    implementation("com.google.firebase:firebase-auth")
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.5")
}
