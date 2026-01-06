import 'package:flutter/material.dart';
import 'package:tickoff/l10n/app_localizations.dart';
import 'package:tickoff/src/pages/history_page.dart';
import 'package:tickoff/src/pages/riskmap_page.dart';
import 'package:tickoff/src/pages/settings_page.dart';
import 'package:tickoff/src/pages/tips_info_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  static const String title = 'Tickoff';

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: Theme.of(context).brightness == Brightness.light
          ? Colors.grey[100]
          : Colors.grey[900],
      appBar: AppBar(
        title: Text(
          l10n.appTitle,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
        ),
        centerTitle: true,
        backgroundColor: Colors.red,
        elevation: 4,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.welcome,
              style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              l10n.welcomeSubtitle,
              style: TextStyle(
                color: Theme.of(
                  context,
                ).textTheme.bodyMedium?.color?.withOpacity(0.7),
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 24),

            // Grid mit Cards
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                children: [
                  _buildFeatureCard(
                    context: context,
                    icon: Icons.history,
                    color: Colors.orange,
                    title: l10n.myHistory,
                    pageType: 'history',
                  ),
                  _buildFeatureCard(
                    context: context,
                    icon: Icons.map,
                    color: Colors.blue,
                    title: l10n.riskMap,
                    pageType: 'riskmap',
                  ),
                  _buildFeatureCard(
                    context: context,
                    icon: Icons.lightbulb,
                    color: Colors.purple,
                    title: l10n.tipsAndInfo,
                    pageType: 'tips',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),

      // Navigation unten
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.green.shade700,
        unselectedItemColor: Colors.grey,

        currentIndex: 0,
        onTap: (index) {
          if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute<void>(
                builder: (context) => const SettingsPage(),
              ),
            );
          } else {
            // Stay on home page
          }
        },
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.home),
            label: l10n.home,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.settings_outlined),
            activeIcon: const Icon(Icons.settings),
            label: l10n.settings,
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureCard({
    required IconData icon,
    required Color color,
    required String title,
    required BuildContext context,
    required String pageType,
  }) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          if (pageType == 'riskmap') {
            Navigator.push(
              context,
              MaterialPageRoute<void>(
                builder: (context) => const RiskMapPage(),
              ),
            );
          } else if (pageType == 'history') {
            Navigator.push(
              context,
              MaterialPageRoute<void>(
                builder: (context) => const HistoryPage(),
              ),
            );
          } else if (pageType == 'tips') {
            Navigator.push(
              context,
              MaterialPageRoute<void>(
                builder: (context) => const TipsInfoPage(),
              ),
            );
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 28,
                backgroundColor: color.withOpacity(0.15),
                child: Icon(icon, size: 32, color: color),
              ),
              const SizedBox(height: 12),
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
