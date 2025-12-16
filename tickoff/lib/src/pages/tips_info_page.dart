import 'package:flutter/material.dart';
import 'package:tickoff/l10n/app_localizations.dart';

class TipsInfoPage extends StatelessWidget {
  const TipsInfoPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple,
        title: Text(
          l10n.tipsAndInfo,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Header section with important note
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.red.shade50, Colors.orange.shade50],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.red.shade200, width: 2),
            ),
            child: Row(
              children: [
                Icon(Icons.priority_high, color: Colors.red.shade700, size: 32),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    l10n.recognizeTicks,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.red.shade900,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Recognizing ticks section with enhanced visuals
          _buildEnhancedInfoCard(
            context,
            icon: Icons.search,
            title: l10n.recognizeTicks,
            description: l10n.recognizeTicksDesc,
            color: Colors.blue,
            illustrationIcon: Icons.visibility,
            additionalInfo: [
              _InfoPoint(Icons.fiber_manual_record, l10n.tickSize),
              _InfoPoint(Icons.fiber_manual_record, l10n.tickLegs),
              _InfoPoint(Icons.fiber_manual_record, l10n.tickColor),
              _InfoPoint(Icons.fiber_manual_record, l10n.tickPreferredSpots),
            ],
          ),
          const SizedBox(height: 16),

          // Tick removal section with step-by-step images
          _buildEnhancedInfoCard(
            context,
            icon: Icons.medical_services,
            title: l10n.removeTick,
            description: l10n.removeTickDesc,
            color: Colors.red,
            illustrationIcon: Icons.healing,
            additionalInfo: [
              _InfoPoint(Icons.check_circle, l10n.importantDontTwist),
              _InfoPoint(Icons.check_circle, l10n.removeWithin24h),
              _InfoPoint(Icons.check_circle, l10n.tickToolTweezer),
              _InfoPoint(Icons.check_circle, l10n.disinfectAfterRemoval),
            ],
          ),
          const SizedBox(height: 16),

          // When to see a doctor - enhanced warning section
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

          // Prevention section with protective measures
          _buildEnhancedInfoCard(
            context,
            icon: Icons.shield,
            title: l10n.prevention,
            description: l10n.preventionDesc,
            color: Colors.green,
            illustrationIcon: Icons.security,
            additionalInfo: [
              _InfoPoint(Icons.checkroom, l10n.wearLongClothing),
              _InfoPoint(Icons.grass, l10n.avoidTallGrass),
              _InfoPoint(Icons.medical_information, l10n.useRepellent),
              _InfoPoint(Icons.person_search, l10n.checkBody),
              _InfoPoint(Icons.vaccines, l10n.considerVaccination),
            ],
          ),
          const SizedBox(height: 16),

          // Diseases section with detailed information
          _buildDiseaseCard(
            context,
            title: l10n.diseases,
            description: l10n.diseasesDesc,
          ),
          const SizedBox(height: 16),

          // Activity risk levels
          _buildRiskLevelCard(context),
          const SizedBox(height: 16),

          // Seasonal information
          _buildSeasonalCard(context),
          const SizedBox(height: 24),

          // Emergency contact info
          _buildEmergencyCard(context),
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
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with gradient background
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [color.withOpacity(0.1), color.withOpacity(0.05)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, color: color, size: 28),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
                  ),
                ),
                Icon(illustrationIcon, color: color.withOpacity(0.3), size: 48),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  description,
                  style: const TextStyle(fontSize: 15, height: 1.6),
                ),
                const SizedBox(height: 16),
                const Divider(),
                const SizedBox(height: 12),
                ...additionalInfo.map(
                  (point) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(point.icon, size: 20, color: color),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            point.text,
                            style: const TextStyle(fontSize: 14, height: 1.4),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWarningCard(
    BuildContext context, {
    required String title,
    required String description,
    required List<String> additionalWarnings,
  }) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [const Color.fromARGB(255, 34, 34, 34), const Color.fromARGB(255, 34, 34, 34)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.orange.shade100,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.warning_amber,
                      color: Colors.orange.shade800,
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      title,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.orange.shade900,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                description,
                style: const TextStyle(fontSize: 15, height: 1.6),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.black87,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.orange.shade200),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: additionalWarnings
                      .map(
                        (warning) => Padding(
                          padding: const EdgeInsets.only(bottom: 6),
                          child: Text(
                            warning,
                            style: const TextStyle(fontSize: 14, height: 1.4),
                          ),
                        ),
                      )
                      .toList(),
                ),
              ),
            ],
          ),
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
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.purple.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.bug_report,
                    color: Colors.purple,
                    size: 28,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.purple,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              description,
              style: const TextStyle(fontSize: 15, height: 1.6),
            ),
            const SizedBox(height: 16),
            _buildDiseaseInfo(
              l10n.lymeDiseaseTitle,
              l10n.lymeDiseaseInfo,
              const Color.fromARGB(255, 22, 150, 255),
              Icons.coronavirus,
            ),
            const SizedBox(height: 12),
            _buildDiseaseInfo(
              l10n.tbeTitle,
              l10n.tbeInfo,
              const Color.fromARGB(255, 255, 31, 90),
              Icons.vaccines,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDiseaseInfo(
    String title,
    String info,
    Color bgColor,
    IconData icon,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.black87, size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 6),
                Text(info, style: const TextStyle(fontSize: 13, height: 1.4)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRiskLevelCard(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.amber.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.analytics,
                    color: Colors.amber,
                    size: 28,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    l10n.riskAreasActivities,
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildRiskLevel(l10n.highRisk, Colors.red, [
              l10n.hikingTallGrass,
              l10n.forestEdges,
              l10n.undergrowth,
            ]),
            const SizedBox(height: 8),
            _buildRiskLevel(l10n.mediumRisk, Colors.orange, [
              l10n.parksGardens,
              l10n.picnicMeadows,
              l10n.joggingForest,
            ]),
            const SizedBox(height: 8),
            _buildRiskLevel(l10n.lowRisk, Colors.green, [
              l10n.maintainedLawns,
              l10n.pavedPaths,
              l10n.indoors,
            ]),
          ],
        ),
      ),
    );
  }

  Widget _buildRiskLevel(String level, Color color, List<String> activities) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
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
                style: TextStyle(fontWeight: FontWeight.bold, color: color),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ...activities.map(
            (activity) => Padding(
              padding: const EdgeInsets.only(left: 20, bottom: 4),
              child: Text('• $activity', style: const TextStyle(fontSize: 13)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSeasonalCard(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.teal.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.calendar_today,
                    color: Colors.teal,
                    size: 28,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    l10n.tickSeason,
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildSeasonInfo(
              l10n.marchJune,
              l10n.mainSeason,
              l10n.highestActivity,
              Colors.red,
            ),
            const SizedBox(height: 8),
            _buildSeasonInfo(
              l10n.julyAugust,
              l10n.highSummer,
              l10n.mediumActivity,
              Colors.orange,
            ),
            const SizedBox(height: 8),
            _buildSeasonInfo(
              l10n.septemberOctober,
              l10n.autumn,
              l10n.secondWave,
              Colors.amber,
            ),
            const SizedBox(height: 8),
            _buildSeasonInfo(
              l10n.novemberFebruary,
              l10n.winter,
              l10n.lowActivity,
              Colors.green,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSeasonInfo(
    String months,
    String season,
    String activity,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(Icons.wb_sunny, color: color, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  months,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                Text(
                  '$season - $activity',
                  style: const TextStyle(fontSize: 12),
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
    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: const Color.fromARGB(255, 251, 80, 80),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(Icons.emergency, color: Colors.red.shade700, size: 48),
            const SizedBox(height: 12),
            Text(
              l10n.inEmergencies,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.red.shade900,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              l10n.medicalEmergency,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 8),
            Text(
              l10n.seekHelpImmediately,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 13, color: Colors.grey.shade700),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoPoint {
  final IconData icon;
  final String text;

  _InfoPoint(this.icon, this.text);
}
