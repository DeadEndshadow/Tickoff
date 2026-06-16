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
    final currentLanguage = LocaleController.instance.getLanguageName(
      LocaleController.instance.locale.value.languageCode,
    );
    final accountSummary = GuestSession.isGuest
        ? l10n.createAccountSubtitle
        : _loadingUserData
            ? l10n.account
            : ((_userData?['email'] as String?)?.isNotEmpty == true
                ? _userData!['email'] as String
                : l10n.account);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.settings)),
      body: Container(
        decoration: _pageDecoration(context),
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
          children: [
            _buildSettingsHero(context, l10n, accountSummary, currentLanguage),
            const SizedBox(height: 16),
            _buildSettingsSection(
              context,
              icon: Icons.language_rounded,
              title: l10n.language,
              children: [
                _buildSettingsTile(
                  context,
                  icon: Icons.language_rounded,
                  title: l10n.language,
                  subtitle: currentLanguage,
                  collapseSubtitleIntoTitle: true,
                  showLeadingIcon: false,
                  onTap: () => _showLanguageDialog(context, l10n),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildSettingsSection(
              context,
              icon: Icons.palette_outlined,
              title: l10n.theme,
              children: [
                _buildSettingsTile(
                  context,
                  icon: Icons.palette_outlined,
                  title: l10n.theme,
                  subtitle: _getThemeName(context, l10n),
                  collapseSubtitleIntoTitle: true,
                  showLeadingIcon: false,
                  onTap: () => _showThemeDialog(context, l10n),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildSettingsSection(
              context,
              icon: Icons.notifications_active_outlined,
              title: l10n.notifications,
              subtitle: l10n.notificationsEnabledDesc,
              children: [
                ValueListenableBuilder<bool>(
                  valueListenable: NotificationController.instance.notificationsEnabled,
                  builder: (context, enabled, _) {
                    return ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 4,
                        vertical: 2,
                      ),
                      leading: _buildIconBubble(
                        context,
                        enabled
                            ? Icons.notifications_active_outlined
                            : Icons.notifications_off_outlined,
                        enabled
                            ? Theme.of(context).colorScheme.secondary
                            : Theme.of(context).colorScheme.outline,
                      ),
                      title: Text(l10n.enableNotifications),
                      subtitle: Text(l10n.notificationsEnabledDesc),
                      trailing: Switch.adaptive(
                        value: enabled,
                        onChanged: (value) => NotificationController.instance
                            .setNotificationsEnabled(value),
                      ),
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildSettingsSection(
              context,
              icon: Icons.person_outline_rounded,
              title: l10n.account,
              subtitle: accountSummary,
              children: [
                if (GuestSession.isGuest) ...[
                  _buildSettingsTile(
                    context,
                    icon: Icons.person_add_alt_1_rounded,
                    title: l10n.createAccount,
                    subtitle: l10n.createAccountSubtitle,
                    accent: Colors.green,
                    onTap: () => Navigator.of(context).pushNamed('/register'),
                  ),
                  _buildSettingsTile(
                    context,
                    icon: Icons.login_rounded,
                    title: l10n.login,
                    subtitle: l10n.loginSubtitle,
                    accent: Theme.of(context).colorScheme.secondary,
                    onTap: () =>
                        Navigator.of(context).pushReplacementNamed('/login'),
                  ),
                ] else if (_loadingUserData) ...[
                  const Padding(
                    padding: EdgeInsets.all(24),
                    child: Center(child: CircularProgressIndicator()),
                  ),
                ] else ...[
                  _buildSettingsTile(
                    context,
                    icon: Icons.email_outlined,
                    title: l10n.email,
                    subtitle: (_userData?['email'] as String?) ?? '—',
                    trailing: const Icon(Icons.edit_rounded, size: 18),
                    onTap: () => _showEditEmailDialog(context),
                  ),
                  _buildSettingsTile(
                    context,
                    icon: Icons.person_outline_rounded,
                    title: l10n.username,
                    subtitle: (_userData?['username'] as String?)?.isNotEmpty == true
                        ? _userData!['username'] as String
                        : '—',
                    trailing: const Icon(Icons.edit_rounded, size: 18),
                    onTap: () => _showEditUsernameDialog(context),
                  ),
                  _buildSettingsTile(
                    context,
                    icon: Icons.lock_outline_rounded,
                    title: l10n.changePassword,
                    onTap: () => _showChangePasswordDialog(context),
                  ),
                  _buildSettingsTile(
                    context,
                    icon: Icons.logout_rounded,
                    title: l10n.logout,
                    accent: Colors.orange,
                    titleColor: Colors.orange,
                    onTap: () => _confirmLogout(context),
                  ),
                  _buildSettingsTile(
                    context,
                    icon: Icons.delete_forever_rounded,
                    title: l10n.deleteAccount,
                    accent: Colors.red,
                    titleColor: Colors.red,
                    onTap: () => _showDeleteAccountDialog(context),
                  ),
                ],
              ],
            ),
            const SizedBox(height: 16),
            _buildSettingsSection(
              context,
              icon: Icons.info_outline_rounded,
              title: l10n.aboutApp,
              children: [
                _buildSettingsTile(
                  context,
                  icon: Icons.info_outline_rounded,
                  title: l10n.aboutApp,
                  subtitle: '${l10n.version} 1.0.0',
                  collapseSubtitleIntoTitle: true,
                  showLeadingIcon: false,
                  onTap: () => _showAboutDialog(context, l10n),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  BoxDecoration _pageDecoration(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;
    return BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          if (isDark) const Color(0xFF0D1412) else theme.scaffoldBackgroundColor,
          if (isDark)
            const Color(0xFF13201C)
          else
            scheme.tertiary.withValues(alpha: 0.12),
          if (isDark)
            const Color(0xFF1A2522)
          else
            scheme.secondary.withValues(alpha: 0.08),
        ],
      ),
    );
  }

  Widget _buildSettingsHero(
    BuildContext context,
    AppLocalizations l10n,
    String accountSummary,
    String currentLanguage,
  ) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final isLight = theme.brightness == Brightness.light;
    final isDark = theme.brightness == Brightness.dark;
    final heroTextColor = isLight ? const Color(0xFF17332C) : scheme.onSurface;
    final heroMutedColor = heroTextColor.withValues(alpha: 0.76);

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        color: theme.cardColor.withValues(alpha: isDark ? 0.98 : 0.92),
        border: Border.all(
          color: scheme.outline.withValues(alpha: isDark ? 0.14 : 0.08),
        ),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withValues(alpha: 0.18)
                : scheme.primary.withValues(alpha: 0.08),
            blurRadius: isDark ? 24 : 28,
            offset: const Offset(0, 14),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _buildIconBubble(
                context,
                Icons.tune_rounded,
                scheme.primary,
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.settings,
                      style: theme.textTheme.headlineMedium?.copyWith(
                        color: heroTextColor,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      accountSummary,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: heroMutedColor,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              _buildMetaChip(context, Icons.language_rounded, currentLanguage),
              _buildMetaChip(context, Icons.palette_outlined, _getThemeName(context, l10n)),
              _buildMetaChip(
                context,
                GuestSession.isGuest ? Icons.person_outline_rounded : Icons.verified_user_rounded,
                GuestSession.isGuest ? l10n.login : l10n.account,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsSection(
    BuildContext context, {
    required IconData icon,
    required String title,
    String? subtitle,
    required List<Widget> children,
  }) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: theme.cardColor.withValues(alpha: isDark ? 0.98 : 0.92),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: scheme.outline.withValues(alpha: isDark ? 0.14 : 0.08)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                _buildIconBubble(context, icon, scheme.primary),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title, style: theme.textTheme.titleLarge),
                      if (subtitle != null) ...[
                        const SizedBox(height: 4),
                        Text(
                          subtitle,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: scheme.onSurface.withValues(alpha: 0.68),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            for (var index = 0; index < children.length; index++) ...[
              if (index > 0)
                Divider(
                  height: 1,
                  color: scheme.outline.withValues(alpha: 0.08),
                ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 2),
                child: children[index],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    String? subtitle,
    required VoidCallback onTap,
    Color? accent,
    Color? titleColor,
    Widget? trailing,
    bool showLeadingIcon = true,
    bool collapseSubtitleIntoTitle = false,
  }) {
    final scheme = Theme.of(context).colorScheme;
    final resolvedAccent = accent ?? scheme.primary;
    final effectiveTitle = collapseSubtitleIntoTitle && subtitle != null
        ? subtitle
        : title;
    final effectiveSubtitle = collapseSubtitleIntoTitle ? null : subtitle;

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
      leading: showLeadingIcon ? _buildIconBubble(context, icon, resolvedAccent) : null,
      title: Text(
        effectiveTitle,
        style: TextStyle(
          color: titleColor,
          fontWeight: FontWeight.w600,
        ),
      ),
      subtitle: effectiveSubtitle != null ? Text(effectiveSubtitle) : null,
      trailing:
          trailing ?? Icon(Icons.chevron_right_rounded, color: scheme.outline),
      onTap: onTap,
    );
  }

  Widget _buildIconBubble(
    BuildContext context,
    IconData icon,
    Color color, {
    bool filled = false,
  }) {
    final fillColor = filled ? color : color.withValues(alpha: 0.12);

    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: fillColor,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Icon(icon, color: filled ? Colors.white : color, size: 22),
    );
  }

  Widget _buildMetaChip(BuildContext context, IconData icon, String label) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final isLight = theme.brightness == Brightness.light;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: isLight
            ? Colors.white.withValues(alpha: 0.42)
            : const Color(0xFF0F1A17).withValues(alpha: 0.74),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isLight
              ? Colors.white.withValues(alpha: 0.12)
              : Colors.white.withValues(alpha: 0.08),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: scheme.primary),
          const SizedBox(width: 8),
          Text(
            label,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: scheme.onSurface,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
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
                _buildLanguageOption(
                  context: context,
                  value: 'it',
                  label: l10n.italian,
                  flag: '🇮🇹',
                  onSelected: LocaleController.instance.setItalian,
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


