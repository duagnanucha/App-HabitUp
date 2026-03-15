import 'dart:io';

class AdMobConfig {
  // Test Ad Unit IDs (replace with real IDs before production)
  static String get bannerAdUnitId {
    if (Platform.isAndroid) {
      return 'ca-app-pub-3940256099942544/6300978111'; // Android test
    } else if (Platform.isIOS) {
      return 'ca-app-pub-3940256099942544/2934735716'; // iOS test
    }
    throw UnsupportedError('Unsupported platform');
  }

  static String get interstitialAdUnitId {
    if (Platform.isAndroid) {
      return 'ca-app-pub-3940256099942544/1033173712'; // Android test
    } else if (Platform.isIOS) {
      return 'ca-app-pub-3940256099942544/4411468910'; // iOS test
    }
    throw UnsupportedError('Unsupported platform');
  }

  static String get rewardedAdUnitId {
    if (Platform.isAndroid) {
      return 'ca-app-pub-3940256099942544/5224354917'; // Android test
    } else if (Platform.isIOS) {
      return 'ca-app-pub-3940256099942544/1712485313'; // iOS test
    }
    throw UnsupportedError('Unsupported platform');
  }

  // Ad display frequency control
  static const int interstitialFrequency = 3; // Show every N actions
  static const int reportViewFrequency = 5;   // Show every N report views
}
