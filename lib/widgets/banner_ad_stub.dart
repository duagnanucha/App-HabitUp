import 'package:flutter/material.dart';
import '../services/ad_service.dart';

/// Stub widget for web - no ads
class BannerAdPlatformWidget extends StatelessWidget {
  final AdService adService;

  const BannerAdPlatformWidget({super.key, required this.adService});

  @override
  Widget build(BuildContext context) => const SizedBox.shrink();
}
