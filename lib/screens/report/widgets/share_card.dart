import 'package:flutter/material.dart';
import '../../../config/theme.dart';

class ShareReportCard extends StatelessWidget {
  final Widget child;

  const ShareReportCard({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Share button
        Align(
          alignment: Alignment.topRight,
          child: TextButton.icon(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Share feature available on mobile app')),
              );
            },
            icon: const Icon(Icons.share, size: 18),
            label: const Text('Share'),
            style: TextButton.styleFrom(
              foregroundColor: AppColors.accentRed,
              backgroundColor: AppColors.primaryPinkLight,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),

        // Content
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.cardWhite,
            borderRadius: BorderRadius.circular(16),
          ),
          child: child,
        ),
      ],
    );
  }
}
