import 'package:flutter/material.dart';
import 'package:tickoff/l10n/app_localizations.dart';
import 'package:tickoff/src/services/auth_error_localizer.dart';
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
          _buildSectionHeader(context, l10n.account),
          if (GuestSession.isGuest) ...[
            ListTile(
              leading: const Icon(Icons.person_add, color: Colors.green),
              title: Text(l10n.createAccount),
              subtitle: Text(l10n.createAccountSubtitle),
              onTap: () => Navigator.of(context).pushNamed('/register'),
            ),
            ListTile(
              leading: const Icon(Icons.login, color: Colors.blue),
              title: Text(l10n.login),
              subtitle: Text(l10n.loginSubtitle),
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
                title: Text(l10n.email),
                subtitle: Text((_userData?['email'] as String?) ?? '—'),
                trailing: const Icon(Icons.edit, size: 18),
                onTap: () => _showEditEmailDialog(context),
              ),
              ListTile(
                leading: const Icon(Icons.person_outlined),
                title: Text(l10n.username),
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
                title: Text(l10n.changePassword),
                onTap: () => _showChangePasswordDialog(context),
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.logout, color: Colors.orange),
                title: Text(l10n.logout, style: const TextStyle(color: Colors.orange)),
                onTap: () => _confirmLogout(context),
              ),
              ListTile(
                leading: const Icon(Icons.delete_forever, color: Colors.red),
                title: Text(l10n.deleteAccount, style: const TextStyle(color: Colors.red)),
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
    final l10n = AppLocalizations.of(context)!;
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.logout),
        content: Text(l10n.logoutConfirmMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: Colors.orange),
            onPressed: () async {
              Navigator.of(ctx).pop();
              await AuthService.instance.logout();
              GuestSession.endGuestSession();
              if (mounted) Navigator.of(context).pushReplacementNamed('/');
            },
            child: Text(l10n.logout),
          ),
        ],
      ),
    );
  }

  void _showEditEmailDialog(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final controller = TextEditingController(text: _userData?['email'] as String? ?? '');
    String? error;
    showDialog<void>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          title: Text(l10n.editEmail),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: controller,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: l10n.newEmail,
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
            TextButton(onPressed: () => Navigator.of(ctx).pop(), child: Text(l10n.cancel)),
            FilledButton(
              onPressed: () async {
                final err = await AuthService.instance.updateEmail(controller.text.trim());
                if (err != null) {
                  setDialogState(() => error = localizeAuthError(l10n, err));
                } else {
                  Navigator.of(ctx).pop();
                  _loadUserData();
                }
              },
              child: Text(l10n.save),
            ),
          ],
        ),
      ),
    );
  }

  void _showEditUsernameDialog(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final controller = TextEditingController(text: _userData?['username'] as String? ?? '');
    String? error;
    showDialog<void>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          title: Text(l10n.editUsername),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: controller,
                decoration: InputDecoration(
                  labelText: l10n.newUsername,
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
            TextButton(onPressed: () => Navigator.of(ctx).pop(), child: Text(l10n.cancel)),
            FilledButton(
              onPressed: () async {
                final err = await AuthService.instance.updateUsername(controller.text.trim());
                if (err != null) {
                  setDialogState(() => error = localizeAuthError(l10n, err));
                } else {
                  Navigator.of(ctx).pop();
                  _loadUserData();
                }
              },
              child: Text(l10n.save),
            ),
          ],
        ),
      ),
    );
  }

  void _showChangePasswordDialog(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final currentCtrl = TextEditingController();
    final newCtrl = TextEditingController();
    final confirmCtrl = TextEditingController();
    String? error;
    showDialog<void>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          title: Text(l10n.changePassword),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: currentCtrl,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: l10n.currentPassword,
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: newCtrl,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: l10n.newPassword,
                  helperText: l10n.minEightCharacters,
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: confirmCtrl,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: l10n.confirmPassword,
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
            TextButton(onPressed: () => Navigator.of(ctx).pop(), child: Text(l10n.cancel)),
            FilledButton(
              onPressed: () async {
                if (newCtrl.text != confirmCtrl.text) {
                  setDialogState(() => error = l10n.passwordsDoNotMatch);
                  return;
                }
                final err = await AuthService.instance.changePassword(
                  currentPassword: currentCtrl.text,
                  newPassword: newCtrl.text,
                );
                if (err != null) {
                  setDialogState(() => error = localizeAuthError(l10n, err));
                } else {
                  Navigator.of(ctx).pop();
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(l10n.passwordChangedSuccessfully)),
                    );
                  }
                }
              },
              child: Text(l10n.save),
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteAccountDialog(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final passwordCtrl = TextEditingController();
    String? error;
    showDialog<void>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          title: Text(l10n.deleteAccount),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                l10n.deleteAccountWarning,
                style: const TextStyle(fontSize: 13),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: passwordCtrl,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: l10n.password,
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
            TextButton(onPressed: () => Navigator.of(ctx).pop(), child: Text(l10n.cancel)),
            FilledButton(
              style: FilledButton.styleFrom(backgroundColor: Colors.red),
              onPressed: () async {
                final err = await AuthService.instance.deleteAccount(passwordCtrl.text);
                if (err != null) {
                  setDialogState(() => error = localizeAuthError(l10n, err));
                } else {
                  Navigator.of(ctx).pop();
                  GuestSession.endGuestSession();
                  if (mounted) Navigator.of(context).pushReplacementNamed('/');
                }
              },
              child: Text(l10n.deleteAccount),
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
          content: SizedBox(
            width: double.maxFinite,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildLanguageOption(
                  context: context,
                  value: 'de',
                  label: l10n.german,
                  flag: '🇩🇪',
                  onSelected: LocaleController.instance.setGerman,
                ),
                _buildLanguageOption(
                  context: context,
                  value: 'en',
                  label: l10n.english,
                  flag: '🇬🇧',
                  onSelected: LocaleController.instance.setEnglish,
                ),
                _buildLanguageOption(
                  context: context,
                  value: 'fr',
                  label: l10n.french,
                  flag: '🇫🇷',
                  onSelected: LocaleController.instance.setFrench,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildLanguageOption({
    required BuildContext context,
    required String value,
    required String label,
    required String flag,
    required VoidCallback onSelected,
  }) {
    return RadioListTile<String>(
      value: value,
      groupValue: LocaleController.instance.locale.value.languageCode,
      onChanged: (selected) {
        if (selected == null) return;
        onSelected();
        Navigator.of(context).pop();
      },
      contentPadding: EdgeInsets.zero,
      title: Row(
        children: [
          Expanded(
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              softWrap: false,
            ),
          ),
          const SizedBox(width: 12),
          Text(flag, style: const TextStyle(fontSize: 24)),
        ],
      ),
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


