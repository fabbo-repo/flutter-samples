import 'package:envied/envied.dart';

part 'app_env_vars.g.dart';

// This class contains all the environment variables
@Envied(path: 'app.env', requireEnvFile: true)
abstract class AppEnvVars {
  @EnviedField(varName: "FIREBASE_PROJECT_ID")
  static const String firebaseProjectId = _AppEnvVars.firebaseProjectId;

  @EnviedField(varName: "FIREBASE_STORAGE_BUCKET")
  static const String firebaseStorageBucket = _AppEnvVars.firebaseStorageBucket;

  @EnviedField(varName: "FIREBASE_MESSAGING_SENDER_ID")
  static const String firebaseMessagingSenderId =
      _AppEnvVars.firebaseMessagingSenderId;

  @EnviedField(varName: "FIREBASE_WEB_API_KEY")
  static const String firebaseWebApiKey = _AppEnvVars.firebaseWebApiKey;

  @EnviedField(varName: "FIREBASE_WEB_APP_ID")
  static const String firebaseWebAppId = _AppEnvVars.firebaseWebAppId;

  @EnviedField(varName: "FIREBASE_WEB_AUTH_DOMAIN")
  static const String firebaseWebAuthDomain = _AppEnvVars.firebaseWebAuthDomain;

  @EnviedField(varName: "FIREBASE_WEB_MEASUREMENT_ID")
  static const String firebaseWebMeasurementId =
      _AppEnvVars.firebaseWebMeasurementId;

  @EnviedField(varName: "FIREBASE_ANDROID_API_KEY")
  static const String firebaseAndroidApiKey = _AppEnvVars.firebaseAndroidApiKey;

  @EnviedField(varName: "FIREBASE_ANDROID_APP_ID")
  static const String firebaseAndroidAppId = _AppEnvVars.firebaseAndroidAppId;

  @EnviedField(varName: "FIREBASE_IOS_API_KEY")
  static const String firebaseIosApiKey = _AppEnvVars.firebaseIosApiKey;

  @EnviedField(varName: "FIREBASE_IOS_APP_ID")
  static const String firebaseIosAppId = _AppEnvVars.firebaseIosAppId;

  @EnviedField(varName: "FIREBASE_IOS_ANDROID_CLIENT_ID")
  static const String firebaseIosAndroidClientId =
      _AppEnvVars.firebaseIosAndroidClientId;

  @EnviedField(varName: "FIREBASE_IOS_CLIENT_ID")
  static const String firebaseIosClientId = _AppEnvVars.firebaseIosClientId;

  @EnviedField(varName: "FIREBASE_IOS_BUNDLE_ID")
  static const String firebaseIosBundleId = _AppEnvVars.firebaseIosBundleId;
}