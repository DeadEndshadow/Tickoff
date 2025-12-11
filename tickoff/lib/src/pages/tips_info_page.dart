import 'package:flutter/material.dart';

class TipsInfoPage extends StatelessWidget {
  const TipsInfoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple,
        title: const Text(
          'Tipps & Infos',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildInfoCard(
            icon: Icons.search,
            title: 'Zecken erkennen',
            description:
                'Zecken sind kleine, spinnenartige Tiere (1-5mm). Sie bevorzugen warme, feuchte Körperstellen wie Achseln, Kniekehlen und Haaransatz.',
            color: Colors.blue,
          ),
          const SizedBox(height: 12),
          _buildInfoCard(
            icon: Icons.medical_services,
            title: 'Zecke entfernen',
            description:
                '1. Zeckenzange oder Pinzette verwenden\n2. Zecke nah an der Haut greifen\n3. Langsam und gerade herausziehen\n4. Nicht drehen oder quetschen\n5. Stelle desinfizieren',
            color: Colors.red,
          ),
          const SizedBox(height: 12),
          _buildInfoCard(
            icon: Icons.warning_amber,
            title: 'Wann zum Arzt?',
            description:
                '• Rötung breitet sich kreisförmig aus (Wanderröte)\n• Grippeähnliche Symptome nach Stich\n• Fieber, Kopf- oder Gliederschmerzen\n• Zecke lässt sich nicht entfernen',
            color: Colors.orange,
          ),
          const SizedBox(height: 12),
          _buildInfoCard(
            icon: Icons.shield,
            title: 'Vorbeugung',
            description:
                '• Lange Kleidung in Wald und Wiesen\n• Helle Kleidung (Zecken besser sichtbar)\n• Zeckenschutzmittel verwenden\n• Nach dem Aufenthalt Körper absuchen\n• FSME-Impfung in Risikogebieten',
            color: Colors.green,
          ),
          const SizedBox(height: 12),
          _buildInfoCard(
            icon: Icons.bug_report,
            title: 'Krankheiten',
            description:
                '• Borreliose: Durch Bakterien, behandelbar mit Antibiotika\n• FSME: Durch Viren, nur Impfschutz möglich\n• Nicht jeder Zeckenstich führt zu einer Erkrankung',
            color: Colors.purple,
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard({
    required IconData icon,
    required String title,
    required String description,
    required Color color,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: color.withValues(alpha: 0.15),
                  child: Icon(icon, color: color),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              description,
              style: const TextStyle(
                fontSize: 14,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
