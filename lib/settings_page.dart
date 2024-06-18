import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'app_theme.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key, Key? key2});

  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    final theme = Provider.of<ThemeNotifier>(context).currentTheme;

    return Scaffold(
      appBar: AppBar(
        title: Text('Settings', style: theme.headlineTextStyle,
        )
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                themeNotifier.setTheme(AppTheme.lightTheme);
              },
              child: const Text('Light Theme'),
            ),
            ElevatedButton(
              onPressed: () {
                themeNotifier.setTheme(AppTheme.darkTheme);
              },
              child: const Text('Dark Theme'),
            ),
          ],
        ),
      ),
    );
  }
}


