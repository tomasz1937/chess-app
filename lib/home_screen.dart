import 'package:chess_app/chess_board.dart';
import 'package:flutter/material.dart';
import 'famous_game.dart';
import 'opening_list.dart';
import 'coordinate_practice.dart';
import 'package:provider/provider.dart';
import 'app_theme.dart';

class ChessHomeScreen extends StatefulWidget {
  const ChessHomeScreen({Key? key}) : super(key: key);

  @override
  _ChessHomeScreenState createState() => _ChessHomeScreenState();
}

class _ChessHomeScreenState extends State<ChessHomeScreen> {
  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeNotifier>(context).currentTheme;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.appBarColor,
        leading: IconButton(
          icon: Image.asset('assets/chess_pieces/whitep.jpg'),
          onPressed: () {},
        ),
        title: Text(
          'Chess Training Hub',
          style: theme.headlineTextStyle,
        ),
        centerTitle: true,
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(theme.backgroundImage),
            opacity: .95,
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const FamousGames(), // Animate a famous game on the home board
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const CoordinatePracticePage(),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.buttonColor,
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                minimumSize: const Size(double.infinity, 50),
              ),
              child: Text(
                'Coordinate Practice',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Roboto',
                  color: theme.buttonTextColor,
                  shadows: [
                    Shadow(
                      color: theme.buttonShadowColor,
                      offset: const Offset(2, 2),
                      blurRadius: 2,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => OpeningListPage(),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.buttonColor,
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                minimumSize: const Size(double.infinity, 50),
              ),
              child: Text(
                'Opening Study',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Roboto',
                  color: theme.buttonTextColor,
                  shadows: [
                    Shadow(
                      color: theme.buttonShadowColor,
                      offset: const Offset(2, 2),
                      blurRadius: 2,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ChessBoard(),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.buttonColor,
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                minimumSize: const Size(double.infinity, 50),
              ),
              child: Text(
                'Analysis Board',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Roboto',
                  color: theme.buttonTextColor,
                  shadows: [
                    Shadow(
                      color: theme.buttonShadowColor,
                      offset: const Offset(2, 2),
                      blurRadius: 2,
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
}




