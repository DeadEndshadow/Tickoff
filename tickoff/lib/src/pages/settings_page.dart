import 'package:flutter/material.dart';
import 'package:tickoff/src/services/theme_controller.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Einstellungen'),
      ),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.notifications),
            title: const Text('Sparateinstellungen'),
            onTap: () {
              // Navigate to notification settings
            },
          ),
          ListTile(
            leading: const Icon(Icons.palette),
            title: const Text('Theme'),
            onTap: () {
              showDialog<void>(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: const Text('Theme auswählen'),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        RadioListTile<ThemeMode>(
                          value: ThemeMode.light,
                          groupValue: ThemeController.instance.themeMode.value,
                          onChanged: (v) {
                            if (v != null) ThemeController.instance.setLight();
                            Navigator.of(context).pop();
                          },
                          title: const Text('Hell'),
                          secondary: const Icon(Icons.light_mode),
                        ),
                        RadioListTile<ThemeMode>(
                          value: ThemeMode.dark,
                          groupValue: ThemeController.instance.themeMode.value,
                          onChanged: (v) {
                            if (v != null) ThemeController.instance.setDark();
                            Navigator.of(context).pop();
                          },
                          title: const Text('Dunkel'),
                          secondary: const Icon(Icons.dark_mode),
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.info),
            title: const Text('Über die App'),
            onTap: () {
              // Navigate to about page
            },
          ),
        ],
      ),
    );
  }
}