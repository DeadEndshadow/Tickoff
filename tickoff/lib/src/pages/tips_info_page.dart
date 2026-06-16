import 'package:flutter/material.dart';
import 'package:tickoff/l10n/app_localizations.dart';

class TipsInfoPage extends StatelessWidget {
  const TipsInfoPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          l10n.tipsAndInfo,
          style: theme.textTheme.titleLarge,
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              if (isDark) const Color(0xFF0D1412) else theme.scaffoldBackgroundColor,
              if (isDark)
                const Color(0xFF151D1B)
              else
                scheme.secondary.withValues(alpha: 0.08),
              if (isDark)
                const Color(0xFF1A2622)
              else
                scheme.tertiary.withValues(alpha: 0.06),
            ],
          ),
        ),
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 28),
          children: [
            _buildHeroCard(context),
            const SizedBox(height: 16),
            _buildEnhancedInfoCard(
              context,
              icon: Icons.search_rounded,
              title: l10n.recognizeTicks,
              description: l10n.recognizeTicksDesc,
              color: scheme.primary,
              illustrationIcon: Icons.visibility_rounded,
              additionalInfo: [
                _InfoPoint(Icons.straighten_rounded, l10n.tickSize),
                _InfoPoint(Icons.hive_outlined, l10n.tickLegs),
                _InfoPoint(Icons.palette_outlined, l10n.tickColor),
                _InfoPoint(Icons.place_outlined, l10n.tickPreferredSpots),
              ],
            ),
            const SizedBox(height: 16),
            _buildEnhancedInfoCard(
              context,
              icon: Icons.healing_rounded,
              title: l10n.removeTick,
              description: l10n.removeTickDesc,
              color: scheme.error,
              illustrationIcon: Icons.medical_services_rounded,
              additionalInfo: [
                _InfoPoint(Icons.priority_high_rounded, l10n.importantDontTwist),
                _InfoPoint(Icons.schedule_rounded, l10n.removeWithin24h),
                _InfoPoint(Icons.content_cut_rounded, l10n.tickToolTweezer),
                _InfoPoint(Icons.clean_hands_rounded, l10n.disinfectAfterRemoval),
              ],
            ),
            const SizedBox(height: 16),
            _buildWarningCard(
              context,
              title: l10n.whenToDoctor,
              description: l10n.whenToDoctorDesc,
              additionalWarnings: [
                l10n.erythemaMigrans,
                l10n.fluLikeSymptoms,
                l10n.jointPain,
                l10n.paralysisSymptoms,
                l10n.feverAfterBite,
              ],
            ),
            const SizedBox(height: 16),
            _buildEnhancedInfoCard(
              context,
              icon: Icons.shield_rounded,
              title: l10n.prevention,
              description: l10n.preventionDesc,
              color: Colors.green,
              illustrationIcon: Icons.security_rounded,
              additionalInfo: [
                _InfoPoint(Icons.checkroom_rounded, l10n.wearLongClothing),
                _InfoPoint(Icons.grass_rounded, l10n.avoidTallGrass),
                _InfoPoint(Icons.local_hospital_outlined, l10n.useRepellent),
                _InfoPoint(Icons.person_search_rounded, l10n.checkBody),
                _InfoPoint(Icons.vaccines_rounded, l10n.considerVaccination),
              ],
            ),
            const SizedBox(height: 16),
            _buildDiseaseCard(
              context,
              title: l10n.diseases,
              description: l10n.diseasesDesc,
            ),
            const SizedBox(height: 16),
            _buildRiskLevelCard(context),
            const SizedBox(height: 16),
            _buildSeasonalCard(context),
            const SizedBox(height: 16),
            _buildEmergencyCard(context),
          ],
        ),
      ),
    );
  }

  Widget _buildHeroCard(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final isLight = theme.brightness == Brightness.light;
    final heroChipBackground = isLight
        ? scheme.secondary.withValues(alpha: 0.08)
        : const Color(0xFF0F1A17).withValues(alpha: 0.74);
    final heroChipBorder = isLight
        ? scheme.secondary.withValues(alpha: 0.14)
        : Colors.white.withValues(alpha: 0.08);

    return _buildSectionShell(
      context,
      accent: scheme.secondary,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: heroChipBackground,
                borderRadius: BorderRadius.circular(999),
                border: Border.all(color: heroChipBorder),
              ),
              child: Text(
                l10n.appTitle,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: scheme.onSurface,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            const SizedBox(height: 18),
            Text(
              l10n.tipsAndInfo,
              style: theme.textTheme.displaySmall?.copyWith(height: 0.98),
            ),
            const SizedBox(height: 10),
            Text(
              '${l10n.recognizeTicks} • ${l10n.removeTick} • ${l10n.whenToDoctor}',
              style: theme.textTheme.bodyLarge?.copyWith(
                color: scheme.onSurface.withValues(alpha: 0.74),
              ),
            ),
            const SizedBox(height: 20),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                _buildHeroChip(context, Icons.shield_rounded, l10n.prevention),
                _buildHeroChip(context, Icons.healing_rounded, l10n.removeTick),
                _buildHeroChip(
                  context,
                  Icons.warning_amber_rounded,
                  l10n.whenToDoctor,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeroChip(BuildContext context, IconData icon, String label) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final isLight = theme.brightness == Brightness.light;
    final foreground = scheme.onSurface;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: isLight
            ? scheme.secondary.withValues(alpha: 0.08)
            : const Color(0xFF0F1A17).withValues(alpha: 0.74),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isLight
              ? scheme.secondary.withValues(alpha: 0.14)
              : Colors.white.withValues(alpha: 0.08),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: foreground, size: 16),
          const SizedBox(width: 8),
          Text(
            label,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: foreground,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEnhancedInfoCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String description,
    required Color color,
    required IconData illustrationIcon,
    required List<_InfoPoint> additionalInfo,
  }) {
    final theme = Theme.of(context);

    return _buildSectionShell(
      context,
      accent: color,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.14),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Icon(icon, color: color, size: 28),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title, style: theme.textTheme.titleLarge),
                      const SizedBox(height: 4),
                      Text(description, style: theme.textTheme.bodyMedium),
                    ],
                  ),
                ),
                Icon(
                  illustrationIcon,
                  color: color.withValues(alpha: 0.28),
                  size: 36,
                ),
              ],
            ),
            const SizedBox(height: 18),
            ...additionalInfo.map(
              (point) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: color.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(point.icon, size: 18, color: color),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        point.text,
                        style: theme.textTheme.bodyMedium?.copyWith(height: 1.45),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWarningCard(
    BuildContext context, {
    required String title,
    required String description,
    required List<String> additionalWarnings,
  }) {
    final theme = Theme.of(context);
    const tone = Colors.orange;

    return _buildSectionShell(
      context,
      accent: tone,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: tone.withValues(alpha: 0.14),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: const Icon(
                    Icons.warning_amber_rounded,
                    color: tone,
                    size: 28,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(child: Text(title, style: theme.textTheme.titleLarge)),
              ],
            ),
            const SizedBox(height: 16),
            Text(description, style: theme.textTheme.bodyMedium),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: tone.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: tone.withValues(alpha: 0.14)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: additionalWarnings
                    .map(
                      (warning) => Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Padding(
                              padding: EdgeInsets.only(top: 2),
                              child: Icon(Icons.circle, size: 10, color: tone),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                warning,
                                style: theme.textTheme.bodyMedium?.copyWith(height: 1.45),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                    .toList(growable: false),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDiseaseCard(
    BuildContext context, {
    required String title,
    required String description,
  }) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return _buildSectionShell(
      context,
      accent: Colors.purple,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: Colors.purple.withValues(alpha: 0.14),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: const Icon(
                    Icons.biotech_rounded,
                    color: Colors.purple,
                    size: 28,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(child: Text(title, style: theme.textTheme.titleLarge)),
              ],
            ),
            const SizedBox(height: 16),
            Text(description, style: theme.textTheme.bodyMedium),
            const SizedBox(height: 16),
            _buildDiseaseInfo(
              context,
              title: l10n.lymeDiseaseTitle,
              info: l10n.lymeDiseaseInfo,
              tone: const Color(0xFF1696FF),
              icon: Icons.coronavirus_rounded,
            ),
            const SizedBox(height: 12),
            _buildDiseaseInfo(
              context,
              title: l10n.tbeTitle,
              info: l10n.tbeInfo,
              tone: const Color(0xFFFF1F5A),
              icon: Icons.vaccines_rounded,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDiseaseInfo(
    BuildContext context, {
    required String title,
    required String info,
    required Color tone,
    required IconData icon,
  }) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: tone.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: tone.withValues(alpha: 0.16)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: tone.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: tone, size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: theme.textTheme.titleMedium),
                const SizedBox(height: 6),
                Text(info, style: theme.textTheme.bodyMedium?.copyWith(height: 1.45)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRiskLevelCard(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return _buildSectionShell(
      context,
      accent: Colors.amber,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: Colors.amber.withValues(alpha: 0.14),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: const Icon(
                    Icons.analytics_rounded,
                    color: Colors.amber,
                    size: 28,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Text(
                    l10n.riskAreasActivities,
                    style: theme.textTheme.titleLarge,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildRiskLevel(context, l10n.highRisk, Colors.red, [
              l10n.hikingTallGrass,
              l10n.forestEdges,
              l10n.undergrowth,
            ]),
            const SizedBox(height: 10),
            _buildRiskLevel(context, l10n.mediumRisk, Colors.orange, [
              l10n.parksGardens,
              l10n.picnicMeadows,
              l10n.joggingForest,
            ]),
            const SizedBox(height: 10),
            _buildRiskLevel(context, l10n.lowRisk, Colors.green, [
              l10n.maintainedLawns,
              l10n.pavedPaths,
              l10n.indoors,
            ]),
          ],
        ),
      ),
    );
  }

  Widget _buildRiskLevel(
    BuildContext context,
    String level,
    Color color,
    List<String> activities,
  ) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withValues(alpha: 0.16)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.circle, color: color, size: 12),
              const SizedBox(width: 8),
              Text(
                level,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: color,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ...activities.map(
            (activity) => Padding(
              padding: const EdgeInsets.only(left: 20, bottom: 4),
              child: Text(
                '• $activity',
                style: theme.textTheme.bodySmall,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSeasonalCard(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return _buildSectionShell(
      context,
      accent: Colors.teal,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: Colors.teal.withValues(alpha: 0.14),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: const Icon(
                    Icons.calendar_today_rounded,
                    color: Colors.teal,
                    size: 28,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Text(
                    l10n.tickSeason,
                    style: theme.textTheme.titleLarge,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildSeasonInfo(
              context,
              months: l10n.marchJune,
              season: l10n.mainSeason,
              activity: l10n.highestActivity,
              color: Colors.red,
            ),
            const SizedBox(height: 10),
            _buildSeasonInfo(
              context,
              months: l10n.julyAugust,
              season: l10n.highSummer,
              activity: l10n.mediumActivity,
              color: Colors.orange,
            ),
            const SizedBox(height: 10),
            _buildSeasonInfo(
              context,
              months: l10n.septemberOctober,
              season: l10n.autumn,
              activity: l10n.secondWave,
              color: Colors.amber,
            ),
            const SizedBox(height: 10),
            _buildSeasonInfo(
              context,
              months: l10n.novemberFebruary,
              season: l10n.winter,
              activity: l10n.lowActivity,
              color: Colors.green,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSeasonInfo(
    BuildContext context, {
    required String months,
    required String season,
    required String activity,
    required Color color,
  }) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Icon(Icons.wb_sunny_rounded, color: color, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(months, style: theme.textTheme.titleMedium),
                Text(
                  '$season - $activity',
                  style: theme.textTheme.bodySmall,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmergencyCard(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return _buildSectionShell(
      context,
      accent: scheme.error,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Container(
              width: 68,
              height: 68,
              decoration: BoxDecoration(
                color: scheme.error.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(22),
              ),
              child: Icon(Icons.emergency_rounded, color: scheme.error, size: 34),
            ),
            const SizedBox(height: 16),
            Text(
              l10n.inEmergencies,
              textAlign: TextAlign.center,
              style: theme.textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              l10n.medicalEmergency,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            Text(
              l10n.seekHelpImmediately,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionShell(
    BuildContext context, {
    required Color accent,
    required Widget child,
  }) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: theme.cardColor.withValues(alpha: isDark ? 0.98 : 0.9),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: accent.withValues(alpha: isDark ? 0.2 : 0.14)),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withValues(alpha: 0.22)
                : scheme.shadow.withValues(alpha: 0.05),
            blurRadius: isDark ? 28 : 24,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: child,
    );
  }
}

class _InfoPoint {
  const _InfoPoint(this.icon, this.text);

  final IconData icon;
  final String text;
}
