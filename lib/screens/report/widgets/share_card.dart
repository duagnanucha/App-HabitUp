import 'package:flutter/material.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import '../../../config/theme.dart';

class ShareReportCard extends StatelessWidget {
  final ScreenshotController screenshotController;
  final Widget child;

  const ShareReportCard({
    super.key,
    required this.screenshotController,
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
            onPressed: () => _shareReport(context),
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

        // Screenshot-able content
        Screenshot(
          controller: screenshotController,
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.cardWhite,
              borderRadius: BorderRadius.circular(16),
            ),
            child: child,
          ),
        ),
      ],
    );
  }

  Future<void> _shareReport(BuildContext context) async {
    try {
      final image = await screenshotController.capture();
      if (image == null) return;

      final directory = await getTemporaryDirectory();
      final file = File('${directory.path}/habit_report.png');
      await file.writeAsBytes(image);

      await Share.shareXFiles(
        [XFile(file.path)],
        text: 'My Habit Tracker Report - HabitUp',
      );
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to share report')),
        );
      }
    }
  }
}
