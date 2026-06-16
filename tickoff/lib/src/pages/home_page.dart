import 'package:flutter/material.dart';
import 'package:tickoff/l10n/app_localizations.dart';
import 'package:tickoff/src/pages/history_page.dart';
import 'package:tickoff/src/pages/riskmap_page.dart';
import 'package:tickoff/src/pages/settings_page.dart';
import 'package:tickoff/src/pages/tips_info_page.dart';
import 'package:tickoff/src/services/guest_session.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;
    final features = [
      if (!GuestSession.isGuest)
        _HomeFeature(
          icon: Icons.history_rounded,
          color: Colors.orange,
          title: l10n.myHistory,
          routeBuilder: () => const HistoryPage(),
        ),
      _HomeFeature(
        icon: Icons.explore_rounded,
        color: scheme.primary,
        title: l10n.riskMap,
        routeBuilder: () => const RiskMapPage(),
      ),
      _HomeFeature(
        icon: Icons.auto_awesome_rounded,
        color: scheme.secondary,
        title: l10n.tipsAndInfo,
        routeBuilder: () => const TipsInfoPage(),
      ),
    ];

    return Scaffold(
      extendBody: true,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              if (isDark) const Color(0xFF101715) else theme.scaffoldBackgroundColor,
              if (isDark)
                const Color(0xFF101715)
              else
                scheme.tertiary.withValues(alpha: 0.12),
              if (isDark)
                const Color(0xFF111917)
              else
                scheme.secondary.withValues(alpha: 0.08),
            ],
          ),
        ),
        child: SafeArea(
          bottom: false,
          child: LayoutBuilder(
            builder: (context, constraints) {
              final crossAxisCount = constraints.maxWidth >= 920
                  ? 3
                  : constraints.maxWidth >= 620
                      ? 2
                      : 1;
              final cardExtent = crossAxisCount == 1 ? 188.0 : 176.0;
              final bottomContentPadding = MediaQuery.paddingOf(context).bottom + 104;

              return CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                            Row(
                              children: [
                                Container(
                                  width: 42,
                                  height: 42,
                                  decoration: BoxDecoration(
                                    color: scheme.primary.withValues(alpha: 0.12),
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                  child: Icon(
                                    Icons.eco_rounded,
                                    color: scheme.primary,
                                    size: 22,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    l10n.appTitle,
                                    style: theme.textTheme.titleLarge?.copyWith(
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                ),
                              ],
                          ),
                          const SizedBox(height: 14),
                          _buildHeroCard(context, l10n, features),
                        ],
                      ),
                    ),
                  ),
                  SliverPadding(
                    padding: EdgeInsets.fromLTRB(20, 0, 20, bottomContentPadding),
                    sliver: SliverGrid(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: crossAxisCount,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                        mainAxisExtent: cardExtent,
                      ),
                      delegate: SliverChildBuilderDelegate((context, index) {
                        final feature = features[index];
                        return _buildFeatureCard(context, feature);
                      }, childCount: features.length),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.fromLTRB(14, 0, 14, 10),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: NavigationBar(
            height: 68,
            selectedIndex: 0,
            onDestinationSelected: (index) {
              if (index == 1) {
                Navigator.push(
                  context,
                  MaterialPageRoute<void>(builder: (context) => const SettingsPage()),
                );
              }
            },
            destinations: [
              NavigationDestination(
                icon: const Icon(Icons.home_outlined),
                selectedIcon: const Icon(Icons.home_rounded),
                label: l10n.home,
              ),
              NavigationDestination(
                icon: const Icon(Icons.tune_outlined),
                selectedIcon: const Icon(Icons.tune_rounded),
                label: l10n.settings,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeroCard(
    BuildContext context,
    AppLocalizations l10n,
    List<_HomeFeature> features,
  ) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final isLight = theme.brightness == Brightness.light;
    final chipBackground = isLight
      ? Colors.white.withValues(alpha: 0.34)
      : const Color(0xFF0F1A17).withValues(alpha: 0.7);
    final chipBorder = isLight
      ? Colors.white.withValues(alpha: 0.22)
      : Colors.white.withValues(alpha: 0.08);
    final heroTextColor = isLight ? Colors.black : Colors.white;
    final heroMutedColor = isLight
      ? Colors.black.withValues(alpha: 0.74)
      : heroTextColor.withValues(alpha: 0.84);

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(34),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            if (isLight) const Color(0xFF86DEC9) else scheme.primary,
            if (isLight)
              const Color(0xFFB2DDB8)
            else
              const Color(0xFF24463B),
            if (isLight)
              const Color(0xFFF0B092)
            else
              const Color(0xFF4E3028),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: scheme.primary.withValues(alpha: isLight ? 0.12 : 0.2),
            blurRadius: 30,
            offset: const Offset(0, 18),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: chipBackground,
              borderRadius: BorderRadius.circular(999),
              border: Border.all(color: chipBorder),
            ),
            child: Text(
              l10n.home,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: heroTextColor,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          const SizedBox(height: 18),
          Text(
            l10n.welcome,
            style: theme.textTheme.displaySmall?.copyWith(
              color: heroTextColor,
              height: 0.98,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            l10n.welcomeSubtitle,
            style: theme.textTheme.bodyLarge?.copyWith(
              color: heroMutedColor,
            ),
          ),
          const SizedBox(height: 22),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: features
                .map(
                  (feature) => Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    decoration: BoxDecoration(
                      color: chipBackground,
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: chipBorder),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(feature.icon, size: 16, color: heroTextColor),
                        const SizedBox(width: 8),
                        Text(
                          feature.title,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: heroTextColor,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
                .toList(growable: false),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureCard(BuildContext context, _HomeFeature feature) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final isLight = theme.brightness == Brightness.light;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(28),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute<void>(builder: (context) => feature.routeBuilder()),
          );
        },
        child: Ink(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(28),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                isLight ? Colors.white : theme.cardColor,
                feature.color.withValues(alpha: isLight ? 0.14 : 0.14),
              ],
            ),
            border: Border.all(
              color: scheme.outline.withValues(alpha: isLight ? 0.12 : 0.14),
            ),
            boxShadow: [
              if (isLight)
                BoxShadow(
                  color: scheme.shadow.withValues(alpha: 0.05),
                  blurRadius: 18,
                  offset: const Offset(0, 10),
                )
              else
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.18),
                  blurRadius: 24,
                  offset: const Offset(0, 14),
                ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: feature.color.withValues(alpha: 0.14),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(feature.icon, color: feature.color, size: 24),
                ),
                const Spacer(),
                Text(
                  feature.title,
                  style: theme.textTheme.titleLarge?.copyWith(fontSize: 18),
                ),
                const SizedBox(height: 6),
                Text(
                  _featureSubtitle(context, feature.title),
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: scheme.onSurface.withValues(alpha: 0.68),
                    fontSize: 13,
                    height: 1.25,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 10),
                Align(
                  alignment: Alignment.centerRight,
                  child: Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: scheme.primary.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.arrow_outward_rounded,
                      color: scheme.primary,
                      size: 16,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _featureSubtitle(BuildContext context, String title) {
    final l10n = AppLocalizations.of(context)!;
    if (title == l10n.myHistory) {
      return l10n.yourTickBites;
    }
    if (title == l10n.riskMap) {
      return l10n.tapToMark;
    }
    return '${l10n.prevention} • ${l10n.whenToDoctor}';
  }
}

class _HomeFeature {
  const _HomeFeature({
    required this.icon,
    required this.color,
    required this.title,
    required this.routeBuilder,
  });

  final IconData icon;
  final Color color;
  final String title;
  final Widget Function() routeBuilder;
}
