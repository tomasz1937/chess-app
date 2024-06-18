import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'app_theme.dart';

class CoordinatePracticePage extends StatefulWidget {
  const CoordinatePracticePage({super.key});

  @override
  _CoordinatePracticePageState createState() => _CoordinatePracticePageState();
}

class _CoordinatePracticePageState extends State<CoordinatePracticePage> {
  int score = 0;
  int incorrectGuesses = 0;
  String? targetSquare;
  Timer? _timer;
  int _timeLeft = 0;
  bool _isGameActive = false;
  final Random _random = Random();
  int levelTime = 10;
  List<String> tappedSquares = [];
  bool correctTapped = false;

  void _increaseScore() {
    setState(() {
      score++;
    });
    _selectRandomSquare();
  }

  void _incrementIncorrectGuesses() {
    setState(() {
      incorrectGuesses++;
    });
    _selectRandomSquare();
  }

  void _startGame(int level) {
    setState(() {
      _isGameActive = true;
      score = 0;
      incorrectGuesses = 0;
      levelTime = level;
    });
    _selectRandomSquare();
    _startTimer();
  }

  void _stopGame() {
    setState(() {
      _isGameActive = false;
      _timer?.cancel();
    });
  }

  void _selectRandomSquare() {
    List<String> squares = [
      'a8',
      'b8',
      'c8',
      'd8',
      'e8',
      'f8',
      'g8',
      'h8',
      'a7',
      'b7',
      'c7',
      'd7',
      'e7',
      'f7',
      'g7',
      'h7',
      'a6',
      'b6',
      'c6',
      'd6',
      'e6',
      'f6',
      'g6',
      'h6',
      'a5',
      'b5',
      'c5',
      'd5',
      'e5',
      'f5',
      'g5',
      'h5',
      'a4',
      'b4',
      'c4',
      'd4',
      'e4',
      'f4',
      'g4',
      'h4',
      'a3',
      'b3',
      'c3',
      'd3',
      'e3',
      'f3',
      'g3',
      'h3',
      'a2',
      'b2',
      'c2',
      'd2',
      'e2',
      'f2',
      'g2',
      'h2',
      'a1',
      'b1',
      'c1',
      'd1',
      'e1',
      'f1',
      'g1',
      'h1'
    ];
    setState(() {
      targetSquare = squares[_random.nextInt(squares.length)];
      _timeLeft = levelTime;
    });
    _startTimer();
  }

  // Timer for coordinate game
  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_timeLeft > 0) {
        setState(() {
          _timeLeft--;
        });
      } else {
        timer.cancel();
        _incrementIncorrectGuesses();
      }
    });
  }

  // Function to handle square tap
  void _onSquareTap(String square) {
    if (_isGameActive) {
      bool isCorrect = square == targetSquare;
      setState(() {
        if (isCorrect) {
          _increaseScore();
        } else {
          _incrementIncorrectGuesses();
        }
      });

      setState(() {
        correctTapped = isCorrect;
        tappedSquares.add(square);
      });

      if (isCorrect) {
        // Start a timer to reset the board and select a new square after a delay
        Timer(const Duration(milliseconds: 500), () {
          setState(() {
            tappedSquares.clear();
            correctTapped = false;
          });
        });
      } else {
        // Start a timer to reset the red squares after a delay
        Timer(const Duration(milliseconds: 500), () {
          setState(() {
            tappedSquares.clear();
            correctTapped = false;
          });
        });
      }
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeNotifier>(context).currentTheme;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.appBarColor,
        title: Text(
          'Coordinate Practice',
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
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text('Score: $score', style: theme.headlineTextStyle),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text('Incorrect Guesses: $incorrectGuesses',
                  style: theme.headlineTextStyle),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: _isGameActive
                  ? Text('Find: $targetSquare', style: theme.headlineTextStyle)
                  : ElevatedButton(
                      onPressed: () => _showLevelSelectionDialog(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: theme.buttonColor,
                        elevation: 5,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        minimumSize: const Size(double.infinity, 50),
                      ),
                      child: Text(
                        'Start',
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
            ),
            if (_isGameActive)
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text('Time Left: $_timeLeft',
                    style: theme.headlineTextStyle),
              ),
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 8,
                  childAspectRatio: 1,
                ),
                itemCount: 64,
                itemBuilder: (context, index) {
                  int row = index ~/ 8;
                  int col = index % 8;
                  bool isWhiteSquare = (row + col) % 2 == 0;
                  String square =
                      '${String.fromCharCode('a'.codeUnitAt(0) + col)}${8 - row}';

                  // Check if the square is tapped and set its color
                  Color squareColor = isWhiteSquare
                      ? theme.chessBoardLightColor
                      : theme.chessBoardDarkColor;

                  if (tappedSquares.contains(square)) {
                    squareColor = correctTapped ? Colors.green : Colors.red;
                  }
                  return GestureDetector(
                      onTap: () => _onSquareTap(square),
                      child: Container(
                        color: squareColor,
                      ));
                },
              ),
            ),
            if (_isGameActive)
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: ElevatedButton(
                  onPressed: _stopGame,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.buttonColor,
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    minimumSize: const Size(double.infinity, 50),
                  ),
                  child: Text(
                    'Stop Game',
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
              ),
          ],
        ),
      ),
    );
  }

  void _showLevelSelectionDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Select Level'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  _startGame(10); // Level 1: 10 seconds per guess
                },
                child: const Text('Level 1 (10 seconds per guess)'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  _startGame(8); // Level 2: 8 seconds per guess
                },
                child: const Text('Level 2 (8 seconds per guess)'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  _startGame(6); // Level 3: 6 seconds per guess
                },
                child: const Text('Level 3 (6 seconds per guess)'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  _startGame(4); // Level 4: 4 seconds per guess
                },
                child: const Text('Level 4 (4 seconds per guess)'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  _startGame(2); // Level 5: 2 seconds per guess
                },
                child: const Text('Level 5 (2 seconds per guess)'),
              ),
            ],
          ),
        );
      },
    );
  }
}
