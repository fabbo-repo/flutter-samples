import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:firebase_signin/core/app_env_vars.dart';
import 'package:flutter/foundation.dart'
    show TargetPlatform, defaultTargetPlatform, kIsWeb;

class AppFirebaseOptions {
  static FirebaseOptions get currentPlatformOptions {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        return windows;
      case TargetPlatform.linux:
        return linux;
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static FirebaseOptions web = const FirebaseOptions(
    apiKey: AppEnvVars.firebaseWebApiKey,
    appId: AppEnvVars.firebaseWebAppId,
    messagingSenderId: AppEnvVars.firebaseMessagingSenderId,
    projectId: AppEnvVars.firebaseProjectId,
    authDomain: AppEnvVars.firebaseWebAuthDomain,
    storageBucket: AppEnvVars.firebaseStorageBucket,
    measurementId: AppEnvVars.firebaseWebMeasurementId,
  );

  static FirebaseOptions android = const FirebaseOptions(
    apiKey: AppEnvVars.firebaseAndroidApiKey,
    appId: AppEnvVars.firebaseAndroidAppId,
    messagingSenderId: AppEnvVars.firebaseMessagingSenderId,
    projectId: AppEnvVars.firebaseProjectId,
    storageBucket: AppEnvVars.firebaseStorageBucket,
  );

  static FirebaseOptions ios = const FirebaseOptions(
    apiKey: AppEnvVars.firebaseIosApiKey,
    appId: AppEnvVars.firebaseIosAppId,
    messagingSenderId: AppEnvVars.firebaseMessagingSenderId,
    projectId: AppEnvVars.firebaseProjectId,
    storageBucket: AppEnvVars.firebaseStorageBucket,
    androidClientId: AppEnvVars.firebaseIosAndroidClientId,
    iosClientId: AppEnvVars.firebaseIosClientId,
    iosBundleId: AppEnvVars.firebaseIosBundleId,
  );

  static FirebaseOptions macos = const FirebaseOptions(
    apiKey: AppEnvVars.firebaseIosApiKey,
    appId: AppEnvVars.firebaseIosAppId,
    messagingSenderId: AppEnvVars.firebaseMessagingSenderId,
    projectId: AppEnvVars.firebaseProjectId,
    storageBucket: AppEnvVars.firebaseStorageBucket,
    androidClientId: AppEnvVars.firebaseIosAndroidClientId,
    iosClientId: AppEnvVars.firebaseIosClientId,
    iosBundleId: AppEnvVars.firebaseIosBundleId,
  );

  static FirebaseOptions windows = const FirebaseOptions(
    apiKey: AppEnvVars.firebaseAndroidApiKey,
    appId: AppEnvVars.firebaseWebAppId,
    messagingSenderId: AppEnvVars.firebaseMessagingSenderId,
    projectId: AppEnvVars.firebaseProjectId,
    authDomain: AppEnvVars.firebaseWebAuthDomain,
    storageBucket: AppEnvVars.firebaseStorageBucket,
    measurementId: AppEnvVars.firebaseWebMeasurementId,
  );

  static FirebaseOptions linux = const FirebaseOptions(
    apiKey: AppEnvVars.firebaseAndroidApiKey,
    appId: AppEnvVars.firebaseWebAppId,
    messagingSenderId: AppEnvVars.firebaseMessagingSenderId,
    projectId: AppEnvVars.firebaseProjectId,
    authDomain: AppEnvVars.firebaseWebAuthDomain,
    storageBucket: AppEnvVars.firebaseStorageBucket,
    measurementId: AppEnvVars.firebaseWebMeasurementId,
  );
}
