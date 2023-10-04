import 'package:envied/envied.dart';

part 'environment.g.dart';

// This class contains all the environment variables
@Envied(path: 'app.env', requireEnvFile: true)
abstract class Environment {
  @EnviedField(
      varName: "ANDROID_BANNER_AD_UNIT_ID",
      defaultValue: "ca-app-pub-3940256099942544/6300978111")
  static const String androidBannerAdUnitId =
      _Environment.androidBannerAdUnitId;

  @EnviedField(
      varName: "ANDROID_INTERSTITIAL_AD_UNIT_ID",
      defaultValue: "ca-app-pub-3940256099942544/1033173712")
  static const String androidInterstitialAdUnitId =
      _Environment.androidInterstitialAdUnitId;

  @EnviedField(
      varName: "ANDROID_REWARDED_AD_UNIT_ID",
      defaultValue: "ca-app-pub-3940256099942544/5224354917")
  static const String androidRewardedAdUnitId =
      _Environment.androidRewardedAdUnitId;

  @EnviedField(
      varName: "IOS_BANNER_AD_UNIT_ID",
      defaultValue: "ca-app-pub-3940256099942544/2934735716")
  static const String iosBannerAdUnitId = _Environment.iosBannerAdUnitId;

  @EnviedField(
      varName: "IOS_INTERSTITIAL_AD_UNIT_ID",
      defaultValue: "ca-app-pub-3940256099942544/4411468910")
  static const String iosInterstitialAdUnitId =
      _Environment.iosInterstitialAdUnitId;

  @EnviedField(
      varName: "IOS_REWARDED_AD_UNIT_ID",
      defaultValue: "ca-app-pub-3940256099942544/1712485313")
  static const String iosRewardedAdUnitId = _Environment.iosRewardedAdUnitId;
}
