import 'package:flutter/material.dart';
import 'package:tickoff/l10n/app_localizations.dart';
import 'package:tickoff/src/services/auth_error_localizer.dart';
import 'package:tickoff/src/services/auth_service.dart';
import 'package:tickoff/src/widgets/auth_shell.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _obscureConfirm = true;
  String? _errorMessage;

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final username = _usernameController.text.trim();
    final error = await AuthService.instance.register(
      email: _emailController.text.trim(),
      password: _passwordController.text,
      username: username.isEmpty ? null : username,
    );

    if (!mounted) return;

    if (error != null) {
      setState(() {
        _errorMessage = error;
        _isLoading = false;
      });
      return;
    }

    Navigator.of(context).pushReplacementNamed('/home');
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final scheme = Theme.of(context).colorScheme;

    return AuthShell(
      badgeText: l10n.appTitle,
      title: l10n.createAccount,
      subtitle: l10n.createAccountSubtitle,
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              controller: _usernameController,
              textInputAction: TextInputAction.next,
              decoration: InputDecoration(
                labelText: l10n.usernameOptional,
                prefixIcon: const Icon(Icons.person_outlined),
              ),
              validator: (value) {
                if (value != null && value.isNotEmpty && value.length < 3) {
                  return l10n.usernameMinThree;
                }
                if (value != null &&
                    value.isNotEmpty &&
                    !RegExp(r'^[a-zA-Z0-9_]+$').hasMatch(value)) {
                  return l10n.usernameAllowedChars;
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              decoration: InputDecoration(
                labelText: l10n.email,
                prefixIcon: const Icon(Icons.email_outlined),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return l10n.enterEmail;
                }
                if (!RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$').hasMatch(value)) {
                  return l10n.invalidEmail;
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _passwordController,
              obscureText: _obscurePassword,
              textInputAction: TextInputAction.next,
              decoration: InputDecoration(
                labelText: l10n.password,
                prefixIcon: const Icon(Icons.lock_outlined),
                helperText: l10n.minEightCharacters,
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
                if (value.length < 8) {
                  return l10n.passwordMinEight;
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _confirmPasswordController,
              obscureText: _obscureConfirm,
              textInputAction: TextInputAction.done,
              onFieldSubmitted: (_) => _register(),
              decoration: InputDecoration(
                labelText: l10n.confirmPassword,
                prefixIcon: const Icon(Icons.lock_outlined),
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscureConfirm
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined,
                  ),
                  onPressed: () =>
                      setState(() => _obscureConfirm = !_obscureConfirm),
                ),
              ),
              validator: (value) {
                if (value != _passwordController.text) {
                  return l10n.passwordsDoNotMatch;
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
              onPressed: _isLoading ? null : _register,
              child: _isLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Text(l10n.register),
            ),
            const SizedBox(height: 18),
            TextButton(
              onPressed: () =>
                  Navigator.of(context).pushReplacementNamed('/login'),
              child: Text(l10n.alreadyRegisteredLogin),
            ),
          ],
        ),
      ),
    );
  }
}
