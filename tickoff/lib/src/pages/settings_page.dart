import 'package:flutter/material.dart';
import 'package:tickoff/l10n/app_localizations.dart';
import 'package:tickoff/src/services/locale_controller.dart';
import 'package:tickoff/src/services/notification_controller.dart';
import 'package:tickoff/src/services/theme_controller.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.settings), backgroundColor: Colors.red),
      body: ListView(
        children: [
          // Language Section
          _buildSectionHeader(context, l10n.language),
          ListTile(
            leading: const Icon(Icons.language),
            title: Text(l10n.language),
            subtitle: Text(
              LocaleController.instance.getLanguageName(
                LocaleController.instance.locale.value.languageCode,
              ),
            ),
            onTap: () {
              _showLanguageDialog(context, l10n);
            },
          ),
          const Divider(),

          // Theme Section
          _buildSectionHeader(context, l10n.theme),
          ListTile(
            leading: const Icon(Icons.palette),
            title: Text(l10n.theme),
            subtitle: Text(_getThemeName(context, l10n)),
            onTap: () {
              _showThemeDialog(context, l10n);
            },
          ),
          const Divider(),

          // Notifications Section
          _buildSectionHeader(context, l10n.notifications),
          ValueListenableBuilder<bool>(
            valueListenable:
                NotificationController.instance.notificationsEnabled,
            builder: (context, enabled, _) {
              return SwitchListTile(
                secondary: Icon(
                  enabled
                      ? Icons.notifications_active
                      : Icons.notifications_off,
                  color: enabled ? Colors.green : Colors.grey,
                ),
                title: Text(l10n.enableNotifications),
                subtitle: Text(l10n.notificationsEnabledDesc),
                value: enabled,
                onChanged: (value) {
                  NotificationController.instance.setNotificationsEnabled(
                    value,
                  );
                },
              );
            },
          ),
          const Divider(),

          // About Section
          _buildSectionHeader(context, l10n.aboutApp),
          ListTile(
            leading: const Icon(Icons.info),
            title: Text(l10n.aboutApp),
            onTap: () {
              _showAboutDialog(context, l10n);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }

  String _getThemeName(BuildContext context, AppLocalizations l10n) {
    switch (ThemeController.instance.themeMode.value) {
      case ThemeMode.light:
        return l10n.light;
      case ThemeMode.dark:
        return l10n.dark;
      case ThemeMode.system:
        return l10n.systemTheme;
    }
  }

  void _showLanguageDialog(BuildContext context, AppLocalizations l10n) {
    showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(l10n.selectLanguage),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              RadioListTile<String>(
                value: 'de',
                groupValue: LocaleController.instance.locale.value.languageCode,
                onChanged: (v) {
                  if (v != null) LocaleController.instance.setGerman();
                  Navigator.of(context).pop();
                },
                title: Text(l10n.german),
                secondary: const Text('🇩🇪', style: TextStyle(fontSize: 24)),
              ),
              RadioListTile<String>(
                value: 'en',
                groupValue: LocaleController.instance.locale.value.languageCode,
                onChanged: (v) {
                  if (v != null) LocaleController.instance.setEnglish();
                  Navigator.of(context).pop();
                },
                title: Text(l10n.english),
                secondary: const Text('🇬🇧', style: TextStyle(fontSize: 24)),
              ),
              RadioListTile<String>(
                value: 'fr',
                groupValue: LocaleController.instance.locale.value.languageCode,
                onChanged: (v) {
                  if (v != null) LocaleController.instance.setFrench();
                  Navigator.of(context).pop();
                },
                title: Text(l10n.french),
                secondary: const Text('🇫🇷', style: TextStyle(fontSize: 24)),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showThemeDialog(BuildContext context, AppLocalizations l10n) {
    showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(l10n.selectTheme),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              RadioListTile<ThemeMode>(
                value: ThemeMode.light,
                groupValue: ThemeController.instance.themeMode.value,
                onChanged: (v) {
                  if (v != null) ThemeController.instance.setLight();
                  Navigator.of(context).pop();
                },
                title: Text(l10n.light),
                secondary: const Icon(Icons.light_mode),
              ),
              RadioListTile<ThemeMode>(
                value: ThemeMode.dark,
                groupValue: ThemeController.instance.themeMode.value,
                onChanged: (v) {
                  if (v != null) ThemeController.instance.setDark();
                  Navigator.of(context).pop();
                },
                title: Text(l10n.dark),
                secondary: const Icon(Icons.dark_mode),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showAboutDialog(BuildContext context, AppLocalizations l10n) {
    showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(l10n.aboutApp),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Icon(
                  Icons.bug_report,
                  size: 64,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              const SizedBox(height: 16),
              Center(
                child: Text(
                  l10n.appTitle,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Center(
                child: Text(
                  '${l10n.version} 1.0.0',
                  style: TextStyle(
                    color: Theme.of(context).textTheme.bodySmall?.color,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(l10n.aboutDescription, textAlign: TextAlign.center),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(l10n.close),
            ),
          ],
        );
      },
    );
  }
}
