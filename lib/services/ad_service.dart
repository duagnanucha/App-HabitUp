import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../config/admob_config.dart';

class AdService {
  InterstitialAd? _interstitialAd;
  int _actionCount = 0;

  /// Initialize Mobile Ads SDK
  static Future<void> initialize() async {
    await MobileAds.instance.initialize();
  }

  // ── Banner Ad ────────────────────────────────────────────

  BannerAd createBannerAd({
    AdSize size = AdSize.banner,
    Function? onLoaded,
    Function? onFailed,
  }) {
    return BannerAd(
      adUnitId: AdMobConfig.bannerAdUnitId,
      size: size,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (ad) => onLoaded?.call(),
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
          onFailed?.call();
        },
      ),
    );
  }

  // ── Interstitial Ad ─────────────────────────────────────

  void loadInterstitialAd() {
    InterstitialAd.load(
      adUnitId: AdMobConfig.interstitialAdUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          _interstitialAd = ad;
          ad.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (ad) {
              ad.dispose();
              _interstitialAd = null;
              loadInterstitialAd(); // Pre-load next
            },
            onAdFailedToShowFullScreenContent: (ad, error) {
              ad.dispose();
              _interstitialAd = null;
              loadInterstitialAd();
            },
          );
        },
        onAdFailedToLoad: (_) {
          _interstitialAd = null;
        },
      ),
    );
  }

  /// Track actions and show interstitial at configured frequency
  void trackAction() {
    _actionCount++;
    if (_actionCount >= AdMobConfig.interstitialFrequency) {
      showInterstitialAd();
      _actionCount = 0;
    }
  }

  void showInterstitialAd() {
    if (_interstitialAd != null) {
      _interstitialAd!.show();
    }
  }

  // ── Rewarded Ad ─────────────────────────────────────────

  void loadAndShowRewardedAd({
    required Function(RewardItem reward) onRewarded,
    Function? onFailed,
  }) {
    RewardedAd.load(
      adUnitId: AdMobConfig.rewardedAdUnitId,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) {
          ad.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (ad) => ad.dispose(),
          );
          ad.show(
            onUserEarnedReward: (_, reward) => onRewarded(reward),
          );
        },
        onAdFailedToLoad: (_) => onFailed?.call(),
      ),
    );
  }

  void dispose() {
    _interstitialAd?.dispose();
  }
}
