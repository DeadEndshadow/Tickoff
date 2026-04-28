import 'package:flutter/material.dart';
import 'package:tickoff/l10n/app_localizations.dart';
import 'package:tickoff/src/services/auth_service.dart';
import 'package:tickoff/src/services/guest_session.dart';
import 'package:tickoff/src/services/locale_controller.dart';
import 'package:tickoff/src/services/notification_controller.dart';
import 'package:tickoff/src/services/theme_controller.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  Map<String, dynamic>? _userData;
  bool _loadingUserData = true;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final data = await AuthService.instance.getUserData();
    if (mounted) setState(() { _userData = data; _loadingUserData = false; });
  }

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
            onTap: () => _showLanguageDialog(context, l10n),
          ),
          const Divider(),

          // Theme Section
          _buildSectionHeader(context, l10n.theme),
          ListTile(
            leading: const Icon(Icons.palette),
            title: Text(l10n.theme),
            subtitle: Text(_getThemeName(context, l10n)),
            onTap: () => _showThemeDialog(context, l10n),
          ),
          const Divider(),

          // Notifications Section
          _buildSectionHeader(context, l10n.notifications),
          ValueListenableBuilder<bool>(
            valueListenable: NotificationController.instance.notificationsEnabled,
            builder: (context, enabled, _) {
              return SwitchListTile(
                secondary: Icon(
                  enabled ? Icons.notifications_active : Icons.notifications_off,
                  color: enabled ? Colors.green : Colors.grey,
                ),
                title: Text(l10n.enableNotifications),
                subtitle: Text(l10n.notificationsEnabledDesc),
                value: enabled,
                onChanged: (value) =>
                    NotificationController.instance.setNotificationsEnabled(value),
              );
            },
          ),
          const Divider(),



          // Account Section
          _buildSectionHeader(context, 'Konto'),
          if (GuestSession.isGuest) ...[
            ListTile(
              leading: const Icon(Icons.person_add, color: Colors.green),
              title: const Text('Konto erstellen'),
              subtitle: const Text('Jetzt registrieren und alle Funktionen nutzen'),
              onTap: () => Navigator.of(context).pushNamed('/register'),
            ),
            ListTile(
              leading: const Icon(Icons.login, color: Colors.blue),
              title: const Text('Anmelden'),
              subtitle: const Text('Bereits ein Konto? Hier einloggen'),
              onTap: () => Navigator.of(context).pushReplacementNamed('/login'),
            ),
          ] else ...[
            if (_loadingUserData)
              const Padding(
                padding: EdgeInsets.all(16),
                child: Center(child: CircularProgressIndicator()),
              )
            else ...[
              ListTile(
                leading: const Icon(Icons.email_outlined),
                title: const Text('E-Mail'),
                subtitle: Text((_userData?['email'] as String?) ?? '—'),
                trailing: const Icon(Icons.edit, size: 18),
                onTap: () => _showEditEmailDialog(context),
              ),
              ListTile(
                leading: const Icon(Icons.person_outlined),
                title: const Text('Benutzername'),
                subtitle: Text(
                  (_userData?['username'] as String?)?.isNotEmpty == true
                      ? _userData!['username'] as String
                      : '—',
                ),
                trailing: const Icon(Icons.edit, size: 18),
                onTap: () => _showEditUsernameDialog(context),
              ),
              ListTile(
                leading: const Icon(Icons.lock_outlined),
                title: const Text('Passwort ändern'),
                onTap: () => _showChangePasswordDialog(context),
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.logout, color: Colors.orange),
                title: const Text('Abmelden', style: TextStyle(color: Colors.orange)),
                onTap: () => _confirmLogout(context),
              ),
              ListTile(
                leading: const Icon(Icons.delete_forever, color: Colors.red),
                title: const Text('Konto löschen', style: TextStyle(color: Colors.red)),
                onTap: () => _showDeleteAccountDialog(context),
              ),
            ],
          ],

          // About Section
          _buildSectionHeader(context, l10n.aboutApp),
          ListTile(
            leading: const Icon(Icons.info),
            title: Text(l10n.aboutApp),
            onTap: () => _showAboutDialog(context, l10n),
          ),
          const Divider(),
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

  // ─── Account dialogs ──────────────────────────────────────────────────────

  void _confirmLogout(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Abmelden'),
        content: const Text('Möchtest du dich wirklich abmelden?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Abbrechen'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: Colors.orange),
            onPressed: () async {
              Navigator.of(ctx).pop();
              await AuthService.instance.logout();
              GuestSession.endGuestSession();
              if (mounted) Navigator.of(context).pushReplacementNamed('/');
            },
            child: const Text('Abmelden'),
          ),
        ],
      ),
    );
  }

  void _showEditEmailDialog(BuildContext context) {
    final controller = TextEditingController(text: _userData?['email'] as String? ?? '');
    String? error;
    showDialog<void>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          title: const Text('E-Mail ändern'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: controller,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: 'Neue E-Mail',
                  border: OutlineInputBorder(),
                ),
              ),
              if (error != null) ...[
                const SizedBox(height: 8),
                Text(error!, style: const TextStyle(color: Colors.red, fontSize: 13)),
              ],
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.of(ctx).pop(), child: const Text('Abbrechen')),
            FilledButton(
              onPressed: () async {
                final err = await AuthService.instance.updateEmail(controller.text.trim());
                if (err != null) {
                  setDialogState(() => error = err);
                } else {
                  Navigator.of(ctx).pop();
                  _loadUserData();
                }
              },
              child: const Text('Speichern'),
            ),
          ],
        ),
      ),
    );
  }

  void _showEditUsernameDialog(BuildContext context) {
    final controller = TextEditingController(text: _userData?['username'] as String? ?? '');
    String? error;
    showDialog<void>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          title: const Text('Benutzername ändern'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: controller,
                decoration: const InputDecoration(
                  labelText: 'Neuer Benutzername',
                  border: OutlineInputBorder(),
                ),
              ),
              if (error != null) ...[
                const SizedBox(height: 8),
                Text(error!, style: const TextStyle(color: Colors.red, fontSize: 13)),
              ],
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.of(ctx).pop(), child: const Text('Abbrechen')),
            FilledButton(
              onPressed: () async {
                final err = await AuthService.instance.updateUsername(controller.text.trim());
                if (err != null) {
                  setDialogState(() => error = err);
                } else {
                  Navigator.of(ctx).pop();
                  _loadUserData();
                }
              },
              child: const Text('Speichern'),
            ),
          ],
        ),
      ),
    );
  }

  void _showChangePasswordDialog(BuildContext context) {
    final currentCtrl = TextEditingController();
    final newCtrl = TextEditingController();
    final confirmCtrl = TextEditingController();
    String? error;
    showDialog<void>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          title: const Text('Passwort ändern'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: currentCtrl,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Aktuelles Passwort',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: newCtrl,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Neues Passwort',
                  helperText: 'Mindestens 8 Zeichen',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: confirmCtrl,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Passwort bestätigen',
                  border: OutlineInputBorder(),
                ),
              ),
              if (error != null) ...[
                const SizedBox(height: 8),
                Text(error!, style: const TextStyle(color: Colors.red, fontSize: 13)),
              ],
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.of(ctx).pop(), child: const Text('Abbrechen')),
            FilledButton(
              onPressed: () async {
                if (newCtrl.text != confirmCtrl.text) {
                  setDialogState(() => error = 'Passwörter stimmen nicht überein');
                  return;
                }
                final err = await AuthService.instance.changePassword(
                  currentPassword: currentCtrl.text,
                  newPassword: newCtrl.text,
                );
                if (err != null) {
                  setDialogState(() => error = err);
                } else {
                  Navigator.of(ctx).pop();
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Passwort erfolgreich geändert')),
                    );
                  }
                }
              },
              child: const Text('Speichern'),
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteAccountDialog(BuildContext context) {
    final passwordCtrl = TextEditingController();
    String? error;
    showDialog<void>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          title: const Text('Konto löschen'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Diese Aktion kann nicht rückgängig gemacht werden. Bitte gib dein Passwort zur Bestätigung ein.',
                style: TextStyle(fontSize: 13),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: passwordCtrl,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Passwort',
                  border: OutlineInputBorder(),
                ),
              ),
              if (error != null) ...[
                const SizedBox(height: 8),
                Text(error!, style: const TextStyle(color: Colors.red, fontSize: 13)),
              ],
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.of(ctx).pop(), child: const Text('Abbrechen')),
            FilledButton(
              style: FilledButton.styleFrom(backgroundColor: Colors.red),
              onPressed: () async {
                final err = await AuthService.instance.deleteAccount(passwordCtrl.text);
                if (err != null) {
                  setDialogState(() => error = err);
                } else {
                  Navigator.of(ctx).pop();
                  GuestSession.endGuestSession();
                  if (mounted) Navigator.of(context).pushReplacementNamed('/');
                }
              },
              child: const Text('Konto löschen'),
            ),
          ],
        ),
      ),
    );
  }

  // ─── Other dialogs ────────────────────────────────────────────────────────

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


