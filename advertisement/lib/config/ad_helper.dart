import 'package:advertisement/config/environment.dart';
import 'package:flutter/foundation.dart';
import 'package:universal_io/io.dart';

class AdHelper {
  static bool get isSupportedPlatform {
    return !kIsWeb && (Platform.isIOS || Platform.isAndroid);
  }

  static String get bannerAdUnitId {
    if (Platform.isAndroid) {
      return Environment.androidBannerAdUnitId;
    } else if (Platform.isIOS) {
      return Environment.iosBannerAdUnitId;
    } else {
      throw UnsupportedError('Unsupported platform');
    }
  }

  static String get interstitialAdUnitId {
    if (Platform.isAndroid) {
      return Environment.androidInterstitialAdUnitId;
    } else if (Platform.isIOS) {
      return Environment.iosInterstitialAdUnitId;
    } else {
      throw UnsupportedError('Unsupported platform');
    }
  }

  static String get rewardedAdUnitId {
    if (Platform.isAndroid) {
      return Environment.androidRewardedAdUnitId;
    } else if (Platform.isIOS) {
      return Environment.iosRewardedAdUnitId;
    } else {
      throw UnsupportedError('Unsupported platform');
    }
  }
}
