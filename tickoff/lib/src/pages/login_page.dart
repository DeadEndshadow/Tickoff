import 'package:flutter/material.dart';
import 'package:tickoff/l10n/app_localizations.dart';
import 'package:tickoff/src/services/auth_error_localizer.dart';
import 'package:tickoff/src/services/auth_service.dart';
import 'package:tickoff/src/services/guest_session.dart';
import 'package:tickoff/src/widgets/auth_shell.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _identifierController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _obscurePassword = true;
  String? _errorMessage;

  @override
  void dispose() {
    _identifierController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final error = await AuthService.instance.login(
      identifier: _identifierController.text.trim(),
      password: _passwordController.text,
    );

    if (!mounted) return;

    if (error != null) {
      setState(() {
        _errorMessage = error;
        _isLoading = false;
      });
      return;
    }

    GuestSession.endGuestSession();
    Navigator.of(context).pushReplacementNamed('/home');
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final scheme = Theme.of(context).colorScheme;

    return AuthShell(
      badgeText: l10n.appTitle,
      title: l10n.login,
      subtitle: l10n.welcomeSubtitle,
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              controller: _identifierController,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              decoration: InputDecoration(
                labelText: l10n.emailOrUsername,
                prefixIcon: const Icon(Icons.person_outlined),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return l10n.enterEmailOrUsername;
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _passwordController,
              obscureText: _obscurePassword,
              textInputAction: TextInputAction.done,
              onFieldSubmitted: (_) => _login(),
              decoration: InputDecoration(
                labelText: l10n.password,
                prefixIcon: const Icon(Icons.lock_outlined),
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscurePassword
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined,
                  ),
                  onPressed: () =>
                      setState(() => _obscurePassword = !_obscurePassword),
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return l10n.enterPassword;
                }
                return null;
              },
            ),
            if (_errorMessage != null) ...[
              const SizedBox(height: 14),
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: scheme.error.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Text(
                  localizeAuthError(l10n, _errorMessage!),
                  style: TextStyle(
                    color: scheme.error,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
            const SizedBox(height: 22),
            FilledButton(
              onPressed: _isLoading ? null : _login,
              child: _isLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Text(l10n.login),
            ),
            const SizedBox(height: 18),
            TextButton(
              onPressed: () =>
                  Navigator.of(context).pushReplacementNamed('/register'),
              child: Text(l10n.noAccountRegisterNow),
            ),
            TextButton(
              onPressed: () {
                GuestSession.startGuestSession();
                Navigator.of(context).pushReplacementNamed('/home');
              },
              child: Text(
                l10n.continueWithoutLogin,
                style: TextStyle(
                  color: scheme.onSurface.withValues(alpha: 0.64),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
