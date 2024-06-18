import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'app_theme.dart';
import 'home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  ThemeNotifier themeNotifier = ThemeNotifier(AppTheme.lightTheme);
  await themeNotifier.loadTheme();

  runApp(
    ChangeNotifierProvider<ThemeNotifier>(
      create: (_) => themeNotifier,
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeNotifier>(context).currentTheme;

    return MaterialApp(
      home: const ChessHomeScreen(),
      theme: ThemeData(
        appBarTheme: AppBarTheme(color: theme.appBarColor),
        scaffoldBackgroundColor: Colors.transparent,
        buttonTheme: ButtonThemeData(buttonColor: theme.buttonColor),
        textTheme: TextTheme(labelLarge: TextStyle(color: theme.buttonTextColor)),
      ),
    );
  }
}


