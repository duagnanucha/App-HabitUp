import 'package:flutter/foundation.dart' show kIsWeb;
import '../config/admob_config.dart';

// Conditional imports: google_mobile_ads only on mobile
import 'ad_service_mobile.dart' if (dart.library.html) 'ad_service_stub.dart'
    as platform;

class AdService {
  final platform.AdServicePlatform _platform;
  int _actionCount = 0;

  AdService() : _platform = platform.AdServicePlatform();

  static Future<void> initialize() async {
    if (kIsWeb) return;
    await platform.AdServicePlatform.initialize();
  }

  void loadInterstitialAd() {
    if (kIsWeb) return;
    _platform.loadInterstitialAd();
  }

  void trackAction() {
    if (kIsWeb) return;
    _actionCount++;
    if (_actionCount >= AdMobConfig.interstitialFrequency) {
      _platform.showInterstitialAd();
      _actionCount = 0;
    }
  }

  void showInterstitialAd() {
    if (kIsWeb) return;
    _platform.showInterstitialAd();
  }

  void dispose() {
    _platform.dispose();
  }
}
