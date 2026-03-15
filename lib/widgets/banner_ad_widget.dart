import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/ad_provider.dart';

// Conditional import for mobile ads widget
import 'banner_ad_mobile.dart' if (dart.library.html) 'banner_ad_stub.dart'
    as platform;

class BannerAdWidget extends ConsumerWidget {
  const BannerAdWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // No ads on web
    if (kIsWeb) return const SizedBox.shrink();
    return platform.BannerAdPlatformWidget(
      adService: ref.read(adServiceProvider),
    );
  }
}
