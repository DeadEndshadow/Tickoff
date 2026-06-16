import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tickoff/l10n/app_localizations.dart';
import 'package:tickoff/src/pages/home_page.dart';
import 'package:tickoff/src/pages/login_page.dart';
import 'package:tickoff/src/pages/register_page.dart';
import 'package:tickoff/src/services/auth_service.dart';
import 'package:tickoff/src/services/guest_session.dart';
import 'package:tickoff/src/services/locale_controller.dart';
import 'package:tickoff/src/services/theme_controller.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  ThemeData _buildTheme(Brightness brightness) {
    final isLight = brightness == Brightness.light;
    final baseScheme = ColorScheme.fromSeed(
      seedColor: isLight ? const Color(0xFF2A6B58) : const Color(0xFF78C4A7),
      brightness: brightness,
      dynamicSchemeVariant: DynamicSchemeVariant.fidelity,
    );
    final scheme = baseScheme.copyWith(
      primary: isLight ? const Color(0xFF245F4E) : const Color(0xFF8FD3B9),
      secondary: isLight ? const Color(0xFFE77755) : const Color(0xFFFFA687),
      tertiary: isLight ? const Color(0xFF8EBCA9) : const Color(0xFFA4D2BF),
      surface: isLight ? const Color(0xFFFFFBF5) : const Color(0xFF111917),
      onSurface: isLight ? const Color(0xFF1D2A25) : const Color(0xFFF1F5F2),
      outline: isLight ? const Color(0xFFC4B9A8) : const Color(0xFF4A5B54),
      error: const Color(0xFFD64545),
    );

    final baseTheme = ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      brightness: brightness,
    );

    final textTheme = GoogleFonts.manropeTextTheme(baseTheme.textTheme).copyWith(
      displaySmall: GoogleFonts.manrope(
        fontSize: 36,
        fontWeight: FontWeight.w800,
        letterSpacing: -1.2,
        color: scheme.onSurface,
      ),
      headlineMedium: GoogleFonts.manrope(
        fontSize: 30,
        fontWeight: FontWeight.w800,
        letterSpacing: -0.8,
        color: scheme.onSurface,
      ),
      titleLarge: GoogleFonts.manrope(
        fontSize: 22,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.3,
        color: scheme.onSurface,
      ),
      bodyLarge: GoogleFonts.manrope(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: scheme.onSurface,
      ),
      bodyMedium: GoogleFonts.manrope(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: scheme.onSurface.withValues(alpha: 0.78),
      ),
      labelLarge: GoogleFonts.manrope(
        fontSize: 15,
        fontWeight: FontWeight.w700,
        color: scheme.onPrimary,
      ),
    );

    return baseTheme.copyWith(
      scaffoldBackgroundColor:
          isLight ? const Color(0xFFF7F3EB) : const Color(0xFF0D1412),
      textTheme: textTheme,
      appBarTheme: AppBarTheme(
        backgroundColor: scheme.surface.withValues(alpha: isLight ? 0.88 : 0.94),
        foregroundColor: scheme.onSurface,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        surfaceTintColor: Colors.transparent,
        titleTextStyle: textTheme.titleLarge,
      ),
      cardTheme: CardThemeData(
        color: isLight ? Colors.white.withValues(alpha: 0.82) : const Color(0xFF17211E),
        elevation: 0,
        margin: EdgeInsets.zero,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(28),
          side: BorderSide(
            color: isLight
                ? Colors.white.withValues(alpha: 0.7)
                : Colors.white.withValues(alpha: 0.05),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: isLight ? Colors.white.withValues(alpha: 0.92) : const Color(0xFF1A2522),
        contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(22),
          borderSide: BorderSide(color: scheme.outline.withValues(alpha: 0.2)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(22),
          borderSide: BorderSide(color: scheme.outline.withValues(alpha: 0.18)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(22),
          borderSide: BorderSide(color: scheme.primary, width: 1.4),
        ),
        labelStyle: textTheme.bodyMedium,
        helperStyle: textTheme.bodySmall,
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          elevation: 0,
          minimumSize: const Size.fromHeight(56),
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 18),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
          backgroundColor: scheme.primary,
          foregroundColor: scheme.onPrimary,
          textStyle: textTheme.labelLarge,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: scheme.primary,
          textStyle: GoogleFonts.manrope(fontWeight: FontWeight.w700, fontSize: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: isLight ? Colors.white.withValues(alpha: 0.9) : const Color(0xFF151F1C),
        indicatorColor: scheme.primary.withValues(alpha: 0.14),
        labelTextStyle: WidgetStatePropertyAll(
          GoogleFonts.manrope(fontSize: 12, fontWeight: FontWeight.w700),
        ),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return IconThemeData(color: scheme.primary);
          }
          return IconThemeData(color: scheme.onSurface.withValues(alpha: 0.6));
        }),
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: isLight ? const Color(0xFF22302A) : const Color(0xFFE9F3EE),
        contentTextStyle: GoogleFonts.manrope(
          color: isLight ? Colors.white : const Color(0xFF0D1412),
          fontWeight: FontWeight.w600,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      ),
      dividerTheme: DividerThemeData(
        color: scheme.outline.withValues(alpha: 0.12),
        thickness: 1,
        space: 1,
      ),
    );
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: ThemeController.instance.themeMode,
      builder: (context, mode, _) {
        return ValueListenableBuilder<Locale>(
          valueListenable: LocaleController.instance.locale,
          builder: (context, locale, _) {
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              themeMode: mode,
              theme: _buildTheme(Brightness.light),
              darkTheme: _buildTheme(Brightness.dark),
              locale: locale,
              supportedLocales: LocaleController.supportedLocales,
              localizationsDelegates: const [
                AppLocalizations.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              // Named routes
              routes: {
                '/': (context) => const _AuthGate(),
                '/home': (context) => const HomePage(),
                '/login': (context) => const LoginPage(),
                '/register': (context) => const RegisterPage(),
              },
            );
          },
        );
      },
    );
  }
}

class _AuthGate extends StatelessWidget {
  const _AuthGate();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: AuthService.instance.isLoggedIn,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        if (snapshot.data == true) {
          GuestSession.endGuestSession();
          return const HomePage();
        }
        return const LoginPage();
      },
    );
  }
}
