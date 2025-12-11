import 'package:flutter/material.dart';
import 'package:tickoff/src/pages/riskmap_page.dart';
import 'package:tickoff/src/pages/settings_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  static const String title = 'Tickoff';
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).brightness == Brightness.light
          ? Colors.grey[100]
          : Colors.grey[900],
      appBar: AppBar(

        title: const Text(
          "Tickoff",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
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
            const Text(
              "Willkommen 👋",
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "Behalte Zeckenstiche im Blick und bleib gesund.",
              style: TextStyle(
                color: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.7),
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
                    icon: Icons.add_circle,
                    color: Colors.green,
                    title: "Neuen Stich erfassen",
                  ),
                  _buildFeatureCard(
                    context: context,
                    icon: Icons.history,
                    color: Colors.orange,
                    title: "Meine Historie",
                  ),
                  _buildFeatureCard(
                    context: context,
                    icon: Icons.map,
                    color: Colors.blue,
                    title: "Risikokarte",
                  ),
                  _buildFeatureCard(
                    context: context,
                    icon: Icons.lightbulb,
                    color: Colors.purple,
                    title: "Tipps & Infos",
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

          } else if (index == 2) {
            Navigator.push(
              context,
              MaterialPageRoute<void>(builder: (context) => const SettingsPage()),
            );
          } else {
            // Stay on home page
          }
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: "Erinnerungen",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings_outlined),
            activeIcon: Icon(Icons.settings),
            label: "Einstellungen",
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
  }) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          if (title == "Risikokarte") {
            Navigator.push(
              context,
              MaterialPageRoute<void>(builder: (context) => const RiskMapPage()),
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
