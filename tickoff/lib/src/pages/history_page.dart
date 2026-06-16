import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tickoff/l10n/app_localizations.dart';
import 'package:tickoff/src/services/tick_bite_service.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  final TickBiteService _tickBiteService = TickBiteService();

  Future<void> _deleteTickBite(TickBite tickBite) async {
    final l10n = AppLocalizations.of(context)!;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.deleteEntryTitle),
        content: Text(l10n.deleteEntryMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(l10n.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: Text(l10n.delete),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        await _tickBiteService.deleteTickBite(tickBite);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(l10n.entryDeleted),
              backgroundColor: Colors.green,
            ),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                e is StateError ? l10n.deleteNotAllowed : '${l10n.errorDeleting}: $e',
              ),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.myHistory)),
      body: Container(
        decoration: BoxDecoration(
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
                const Color(0xFF1A2622)
              else
                scheme.secondary.withValues(alpha: 0.08),
            ],
          ),
        ),
        child: StreamBuilder<List<TickBite>>(
          stream: _tickBiteService.getUserTickBitesStream(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            final tickBites = snapshot.data ?? [];

            if (snapshot.hasError) {
              return ListView(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
                children: [
                  _buildHistoryHero(context, l10n, tickBites.length),
                  const SizedBox(height: 16),
                  _buildStateCard(
                    context,
                    icon: Icons.error_outline_rounded,
                    title: l10n.errorLoading,
                    description: '${snapshot.error}',
                    accent: scheme.error,
                  ),
                ],
              );
            }

            return ListView(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
              children: [
                _buildHistoryHero(context, l10n, tickBites.length),
                const SizedBox(height: 16),
                if (tickBites.isEmpty)
                  _buildStateCard(
                    context,
                    icon: Icons.history_toggle_off_rounded,
                    title: l10n.noEntries,
                    description: l10n.noEntriesDescription,
                    accent: Colors.orange,
                  )
                else ...[
                  Text(
                    '${l10n.yourTickBites} (${tickBites.length})',
                    style: theme.textTheme.titleLarge,
                  ),
                  const SizedBox(height: 12),
                  ...tickBites.map(
                    (tickBite) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: _buildTickBiteCard(context, tickBite),
                    ),
                  ),
                ],
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildHistoryHero(
    BuildContext context,
    AppLocalizations l10n,
    int count,
  ) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final isLight = theme.brightness == Brightness.light;
    final heroTextColor = isLight ? const Color(0xFF17332C) : scheme.onSurface;
    final heroMutedColor = heroTextColor.withValues(alpha: 0.72);
    final counterBackground = isLight
      ? Colors.white.withValues(alpha: 0.6)
      : const Color(0xFF0F1A17).withValues(alpha: 0.78);

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            if (isLight) const Color(0xFF8DDCC8) else scheme.primaryContainer,
            if (isLight)
              const Color(0xFF75B8A5)
            else
              const Color(0xFF244239),
          ],
        ),
        border: Border.all(color: scheme.primary.withValues(alpha: 0.08)),
        boxShadow: isLight
            ? [
                BoxShadow(
                  color: scheme.primary.withValues(alpha: 0.08),
                  blurRadius: 22,
                  offset: const Offset(0, 12),
                ),
              ]
            : null,
      ),
      child: Row(
        children: [
          Container(
            width: 54,
            height: 54,
            decoration: BoxDecoration(
              color: scheme.primary,
              borderRadius: BorderRadius.circular(18),
            ),
            child: const Icon(Icons.history_rounded, color: Colors.white),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(l10n.myHistory, style: theme.textTheme.headlineSmall),
                const SizedBox(height: 4),
                Text(
                  count == 0 ? l10n.noEntriesDescription : l10n.yourTickBites,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: heroMutedColor,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: counterBackground,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: isLight
                    ? Colors.white.withValues(alpha: 0.16)
                    : Colors.white.withValues(alpha: 0.08),
              ),
            ),
            child: Text(
              '$count',
              style: theme.textTheme.titleMedium?.copyWith(
                color: heroTextColor,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStateCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String description,
    required Color accent,
  }) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: theme.cardColor.withValues(alpha: 0.94),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: accent.withValues(alpha: 0.14)),
      ),
      child: Column(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: accent.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Icon(icon, size: 32, color: accent),
          ),
          const SizedBox(height: 16),
          Text(title, style: theme.textTheme.titleLarge),
          const SizedBox(height: 8),
          Text(
            description,
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }

  Widget _buildTickBiteCard(BuildContext context, TickBite tickBite) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final locale = Localizations.localeOf(context).toLanguageTag();
    final dateFormat = DateFormat.yMMMd(locale);
    final timeFormat = DateFormat.Hm(locale);

    return Container(
      decoration: BoxDecoration(
        color: theme.cardColor.withValues(alpha: 0.94),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: scheme.outline.withValues(alpha: 0.08)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: scheme.error.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(18),
              ),
              child: Icon(
                Icons.bug_report_rounded,
                color: scheme.error,
                size: 28,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    dateFormat.format(tickBite.timestamp),
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(
                        Icons.schedule_rounded,
                        size: 16,
                        color: scheme.onSurface.withValues(alpha: 0.6),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          l10n.timeAt(timeFormat.format(tickBite.timestamp)),
                          style: theme.textTheme.bodyMedium,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Icon(
                        Icons.place_outlined,
                        size: 16,
                        color: scheme.onSurface.withValues(alpha: 0.6),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          l10n.coordinatesAt(
                            '${tickBite.location.latitude.toStringAsFixed(4)}, ${tickBite.location.longitude.toStringAsFixed(4)}',
                          ),
                          style: theme.textTheme.bodySmall,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: () => _deleteTickBite(tickBite),
              child: Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: scheme.error.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(
                  Icons.delete_outline_rounded,
                  color: scheme.error,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
