import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppTheme {
  final Color appBarColor;
  final Color buttonColor;
  final Color buttonTextColor;
  final Color buttonShadowColor;
  final Color chessBoardLightColor;
  final Color chessBoardDarkColor;
  final String backgroundImage;
  final TextStyle headlineTextStyle;
  final TextStyle bodyTextStyle;
  final TextStyle gameTextStyle;

  AppTheme({
    required this.appBarColor,
    required this.buttonColor,
    required this.buttonTextColor,
    required this.buttonShadowColor,
    required this.chessBoardLightColor,
    required this.chessBoardDarkColor,
    required this.backgroundImage,
    required this.headlineTextStyle,
    required this.bodyTextStyle,
    required this.gameTextStyle,
  });

  static final AppTheme lightTheme = AppTheme(
    appBarColor: Colors.white,
    buttonColor: Colors.green,
    buttonTextColor: Colors.white,
    buttonShadowColor: Colors.blueGrey,
    chessBoardLightColor: const Color(0xFFEEEED2),
    chessBoardDarkColor: const Color(0xFF769656),
    backgroundImage: 'assets/backgrounds/lightmarble.jpg',
    headlineTextStyle: TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.bold,
      color: Colors.black,
      fontFamily: 'Montserrat',
      shadows: [
        Shadow(
          color: Colors.grey.withOpacity(0.5),
          offset: const Offset(2, 2),
          blurRadius: 2,
        ),
      ],
    ),
    bodyTextStyle: TextStyle(
      fontSize: 16,
      color: Colors.black,
      fontFamily: 'Roboto',
      shadows: [
        Shadow(
          color: Colors.grey.withOpacity(0.5),
          offset: const Offset(1, 1),
          blurRadius: 1,
        ),
      ],
    ),
    gameTextStyle: TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.bold,
      color: Colors.black,
      fontFamily: 'Montserrat',
      shadows: [
        Shadow(
          color: Colors.grey.withOpacity(0.5),
          offset: const Offset(2, 2),
          blurRadius: 2,
        ),
      ],
    ),

  );

  static final AppTheme darkTheme = AppTheme(
    appBarColor: const Color(0xFF333333),
    buttonColor: const Color(0xFFC0C0C0),
    buttonTextColor: Colors.white,
    buttonShadowColor: Colors.black.withOpacity(0.9),
    chessBoardLightColor: const Color(0xFFF8F8FF),
    chessBoardDarkColor: const Color(0xFF505050),
    backgroundImage: 'assets/backgrounds/blackmarble.jpg',
    headlineTextStyle: TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.bold,
      color: Colors.white,
      fontFamily: 'Montserrat',
      shadows: [
        Shadow(
          color: Colors.black.withOpacity(0.8),
          offset: const Offset(2, 2),
          blurRadius: 2,
        ),
      ],
    ),
    bodyTextStyle: TextStyle(
      fontSize: 16,
      color: Colors.white,
      fontFamily: 'Roboto',
      shadows: [
        Shadow(
          color: Colors.black.withOpacity(0.8),
          offset: const Offset(1, 1),
          blurRadius: 1,
        ),
      ],
    ),
    gameTextStyle: TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.bold,
      color: Colors.white,
      fontFamily: 'Roboto',
      shadows: [
        Shadow(
          color: Colors.black.withOpacity(0.8),
          offset: const Offset(1, 1),
          blurRadius: 1,
        ),
      ],
    ),
  );
}

class ThemeNotifier with ChangeNotifier {
  static const String _themePreferenceKey = 'themePreference';

  AppTheme _currentTheme;
  AppTheme get currentTheme => _currentTheme;

  ThemeNotifier(this._currentTheme);

  Future<void> setTheme(AppTheme theme) async {
    _currentTheme = theme;
    notifyListeners();

    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(_themePreferenceKey, theme == AppTheme.lightTheme ? 'light' : 'dark');
  }

  Future<void> loadTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? themePreference = prefs.getString(_themePreferenceKey);
    if (themePreference != null) {
      _currentTheme = themePreference == 'light' ? AppTheme.lightTheme : AppTheme.darkTheme;
      notifyListeners();
    }
  }
}
