
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:chess/chess.dart' as chess;
import 'package:provider/provider.dart';
import 'app_theme.dart';

class FamousGames extends StatefulWidget {
  const FamousGames({Key? key}) : super(key: key);

  @override
  State<FamousGames> createState() => FamousGameState();
}

class FamousGameState extends State<FamousGames> {
  late final chess.Chess _game = chess.Chess();

  // Chess game list
  final List<String> _pgnFiles = [
    'assets/famous_games/kasparov_topalov_1999.pgn',
    'assets/famous_games/ivanchuk_jussupow_1991.pgn',
  ];

  // Matching titles for game list
  final List<String> _titles = [
    'Kasparov vs. Topalov, Wijk aan Zee 1999',
    'Ivanchuk vs. Jussupow, Brussels 1991',
  ];

  late int _currentGameIndex;
  List<int> changedSquareIndices = [];

  bool _isMounted = false; // Flag to track if the widget is mounted

  @override
  void initState() {
    super.initState();
    _currentGameIndex = Random().nextInt(_pgnFiles.length); // play a random game
    _loadAndAnimatePgn();
  }

  @override
  void dispose() {
    _isMounted = false;
    super.dispose();
  }

  List<chess.Piece?> generateStandardBoard(List<chess.Piece?> board) {
    List<chess.Piece?> standardBoard = List.filled(64, null);
    for (String square in chess.Chess.SQUARES.keys) {
      int index = chess.Chess.SQUARES[square]!;
      if (index < board.length && board[index] != null) {
        int standardIndex = getStandardIndex(square);
        standardBoard[standardIndex] = board[index];
      }
    }
    return standardBoard;
  }

  // Convert the custom map index to a standard 8x8 board index
  int getStandardIndex(String square) {
    int file = square.codeUnitAt(0) - 'a'.codeUnitAt(0);
    int rank = 8 - int.parse(square[1]);
    return rank * 8 + file;
  }


  // Method to load and animate the PGN
  Future<void> _loadAndAnimatePgn() async {
    List<String> moves = await _parseAndLoadPgn(_pgnFiles[_currentGameIndex]);

    while (true) {

      for (var move in moves) {

        await Future.delayed(const Duration(milliseconds: 1500));

        changedSquareIndices.clear();

        List<chess.Piece?>initialBoard = generateStandardBoard(_game.board);
        List<chess.Piece?> prev = initialBoard;
        _game.move(move);
        initialBoard = generateStandardBoard(_game.board);

        for (int i = 0; i < prev.length; i++) {
          if (initialBoard[i]?.type != prev[i]?.type
              || initialBoard[i]?.color != prev[i]?.color) {
            changedSquareIndices.add(i);
          }
        }
        setState(() {});
      }
      await Future.delayed(const Duration(seconds: 3));
      _game.reset();
      setState(() {});

      _currentGameIndex = (_currentGameIndex + 1) % _pgnFiles.length;
      moves = await _parseAndLoadPgn(_pgnFiles[_currentGameIndex]);
      setState(() {});
    }
  }

  // Parse and load async
  Future<List<String>> _parseAndLoadPgn(String filePath) async {
    String pgnString = await _loadPgnFromFile(filePath);
    return _parsePgnMoves(pgnString);
  }

  // Load from file async
  Future<String> _loadPgnFromFile(String filePath) async {
    try {
      return await DefaultAssetBundle.of(context).loadString(filePath);
    } catch (e) {
      return '';
    }
  }

  // Parse the pgn and return a list of all the games moves
  List<String> _parsePgnMoves(String pgnString) {
    List<String> lines = pgnString.split('\n');

    // Find the index where the moves start
    int moveIndex = lines.indexWhere((line) =>
        line.startsWith(RegExp(r'\d+\.')));
    if (moveIndex == -1) {
      return [];
    }

    // Get the lines starting from the moveIndex
    List<String> moveLines = lines.sublist(moveIndex);
    List<String> moves = [];

    // Iterate through each move line
    for (String line in moveLines) {
      String trimmedLine = line.trim();
      List<String> tokens = trimmedLine.split(' ');

      for (int i = 0; i < tokens.length; i++) {
        String move = tokens[i];

        // Check if the move is not just a number followed by a period
        if (!RegExp(r'^\d+\.$').hasMatch(move)) {
          if (i == tokens.length - 1 && move.endsWith('\n')) {
            move = move.substring(0, move.length - 1);
          }
          moves.add(move);
        }
      }
    }
    return moves;
  }

  // Get a pieces image
  String? _getPieceImage(chess.Piece? piece) {
    if (piece == null) return null;
    String pieceSymbol = piece.type.toString();
    String color = piece.color == chess.Color.WHITE ? 'white' : 'black';
    return 'assets/chess_pieces/$color$pieceSymbol.jpg';
  }


  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery
        .of(context)
        .size
        .width;
    final double screenHeight = MediaQuery
        .of(context)
        .size
        .height;

    // Calculate the size of the chessboard
    final double boardSize = screenWidth < screenHeight
        ? screenWidth
        : screenHeight;

    final theme = Provider.of<ThemeNotifier>(context).currentTheme;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(4.0),
          child: Text(
            _titles[_currentGameIndex],
            style: theme.gameTextStyle,
          ),
        ),
        SingleChildScrollView(
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 8,
              childAspectRatio: 1,
            ),
            itemCount: 64,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            // Disable scrolling
            itemBuilder: (context, index) {
              int row = index ~/ 8;
              int col = index % 8;
              String square =
                  String.fromCharCode('a'.codeUnitAt(0) + col) +
                      (8 - row).toString();
              chess.Piece? piece = _game.get(square);
              String? imageName = _getPieceImage(piece);

              Color backgroundColor = changedSquareIndices.contains(index)
                  ? Colors.green.withOpacity(0.8)
                  : (row + col) % 2 == 0
                  ? theme.chessBoardLightColor
                  : theme.chessBoardDarkColor;

              return Container(
                color: backgroundColor,
                width: MediaQuery
                    .of(context)
                    .size
                    .width / 8,
                height: MediaQuery
                    .of(context)
                    .size
                    .width / 8,
                child: imageName != null
                    ? Image.asset(imageName, fit: BoxFit.cover)
                    : const SizedBox(),
              );
            },
          ),
        ),
      ],
    );
  }
}




