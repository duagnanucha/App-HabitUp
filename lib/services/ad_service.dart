import 'package:flutter/foundation.dart' show kIsWeb;

class AdService {
  int _actionCount = 0;

  static Future<void> initialize() async {
    if (kIsWeb) return;
    // AdMob initialization is mobile-only
    // google_mobile_ads package should be added for mobile builds
  }

  void loadInterstitialAd() {
    if (kIsWeb) return;
  }

  void trackAction() {
    if (kIsWeb) return;
    _actionCount++;
    if (_actionCount >= 3) {
      showInterstitialAd();
      _actionCount = 0;
    }
  }

  void showInterstitialAd() {
    if (kIsWeb) return;
  }

  void dispose() {}
}
