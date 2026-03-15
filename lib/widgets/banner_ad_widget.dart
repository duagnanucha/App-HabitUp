import 'package:flutter/material.dart';

/// Banner ad widget - shows ads on mobile, empty on web.
/// Add google_mobile_ads package for mobile builds.
class BannerAdWidget extends StatelessWidget {
  const BannerAdWidget({super.key});

  @override
  Widget build(BuildContext context) {
    // Ads only on mobile - return empty on web
    return const SizedBox.shrink();
  }
}
