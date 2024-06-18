import 'package:flutter/material.dart';
import 'package:chess/chess.dart' as chess;
import 'package:provider/provider.dart';
import 'app_theme.dart';

class ChessBoard extends StatefulWidget {
  const ChessBoard({super.key});

  @override
  State<ChessBoard> createState() => ChessBoardState();
}

class ChessBoardState extends State<ChessBoard> {
  late chess.Chess _game = chess.Chess();

  @override
  void initState() {
    super.initState();
    _startNewGame();
  }

  void _startNewGame() {
    setState(() {
      _game = chess.Chess();
    });
  }

  void _undoMove() {
    setState(() {
      _game.undo_move();
    });
  }

  // Reference to the current game
  chess.Chess getGame(){
    return _game;
  }


  String? _getPieceImage(chess.Piece? piece) {
    if (piece == null) return null;
    String pieceSymbol = piece.type.toString();
    String color = piece.color == chess.Color.WHITE ? 'white' : 'black';
    return 'assets/chess_pieces/$color$pieceSymbol.jpg';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeNotifier>(context).currentTheme;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.appBarColor,
        title: Text(
          'Analysis Board',
          style: theme.headlineTextStyle,
        ),
        centerTitle: true,
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(theme.backgroundImage),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 100),
            Expanded(
              child: LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) {
                  double size = constraints.biggest.width < constraints.biggest.height
                      ? constraints.biggest.width
                      : constraints.biggest.height;

                  return GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 8,
                      childAspectRatio: 1,
                    ),
                    itemCount: 64,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      int row = index ~/ 8;
                      int col = index % 8;
                      String square = String.fromCharCode('a'.codeUnitAt(0) + col) + (8 - row).toString();
                      chess.Piece? piece = _game.get(square);
                      String? imageName = _getPieceImage(piece);

                      Color squareColor = (row + col) % 2 == 0
                          ? theme.chessBoardLightColor
                          : theme.chessBoardDarkColor;

                      return DragTarget<String>(
                        builder: (context, candidateData, rejectedData) {
                          return Draggable<String>(
                            data: square,
                            feedback: imageName != null
                                ? Image.asset(imageName, width: size / 8, height: size / 8)
                                : const SizedBox(),
                            childWhenDragging: Container(
                              color: squareColor,
                              width: size / 8,
                              height: size / 8,
                            ),
                            child: Container(
                              color: squareColor,
                              width: size / 8,
                              height: size / 8,
                              child: imageName != null
                                  ? Image.asset(imageName, fit: BoxFit.cover)
                                  : const SizedBox(),
                            ),
                          );
                        },
                        onAccept: (fromSquare) {
                          setState(() {
                            _game.move({'from': fromSquare, 'to': square});
                          });
                        },
                      );
                    },
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 200.0),
              child: ElevatedButton(
                onPressed: _undoMove,
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.buttonColor,
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  minimumSize: const Size(150, 50),
                ),
                child: Text(
                  'Undo',
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
}















