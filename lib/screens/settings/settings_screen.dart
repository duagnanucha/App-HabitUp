import 'package:flutter/material.dart';
import '../../config/theme.dart';
import '../../services/notification_service.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        children: [
          const SizedBox(height: 8),

          // General section
          _buildSectionHeader('General'),
          _buildSettingTile(
            icon: Icons.notifications_outlined,
            title: 'Notifications',
            subtitle: 'Manage habit reminders',
            onTap: () => NotificationService.requestPermissions(),
          ),
          _buildSettingTile(
            icon: Icons.language,
            title: 'Language',
            subtitle: 'English',
            onTap: () {},
          ),
          _buildSettingTile(
            icon: Icons.dark_mode_outlined,
            title: 'Dark Mode',
            subtitle: 'Coming soon',
            onTap: () {},
          ),

          const SizedBox(height: 16),

          // Data section
          _buildSectionHeader('Data'),
          _buildSettingTile(
            icon: Icons.backup_outlined,
            title: 'Backup Data',
            subtitle: 'Export your habits and records',
            onTap: () {},
          ),
          _buildSettingTile(
            icon: Icons.restore,
            title: 'Restore Data',
            subtitle: 'Import from backup file',
            onTap: () {},
          ),

          const SizedBox(height: 16),

          // About section
          _buildSectionHeader('About'),
          _buildSettingTile(
            icon: Icons.star_outline,
            title: 'Rate HabitUp',
            subtitle: 'If you enjoy HabitUp, please rate us!',
            onTap: () {},
          ),
          _buildSettingTile(
            icon: Icons.privacy_tip_outlined,
            title: 'Privacy Policy',
            onTap: () {},
          ),
          _buildSettingTile(
            icon: Icons.info_outline,
            title: 'Version',
            subtitle: '1.0.0',
            onTap: () {},
          ),

          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: AppColors.textSecondary,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildSettingTile({
    required IconData icon,
    required String title,
    String? subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: AppColors.primaryPinkDark, size: 22),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w500,
          color: AppColors.textPrimary,
        ),
      ),
      subtitle: subtitle != null
          ? Text(
              subtitle,
              style: const TextStyle(
                fontSize: 12,
                color: AppColors.textSecondary,
              ),
            )
          : null,
      trailing: const Icon(
        Icons.chevron_right,
        color: AppColors.textLight,
      ),
      onTap: onTap,
    );
  }
}
