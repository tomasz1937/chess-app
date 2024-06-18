import 'package:flutter/material.dart';
import 'package:chess/chess.dart' as chess;
import 'package:provider/provider.dart';
import 'app_theme.dart';

class OPChessBoard extends StatefulWidget {
  final String openingName;

  const OPChessBoard({Key? key, required this.openingName}) : super(key: key);

  @override
  State<OPChessBoard> createState() => OpeningStudyBoardState();
}

// List of current openings
const openings = {
  'Vienna Game': [
    'e4',
    'e5',
    'Nc3',
    [
      'Nf6',
      [
        'Bc4',
        [
          'Nxe4',
          [
            'Qh5',
            ['g6', 'Qxe5+']
          ],
          'Nxe4'
        ]
      ]
    ],
    [
      'Nc6',
      [
        'Bc4',
        [
          'Nf6',
          [
            'd3',
            ['Bb4', 'Be7']
          ],
          [
            'd4',
            ['exd4']
          ]
        ],
        'Bc5',
        'g3'
      ]
    ]
  ],
  'Italian Game': [
    'e4',
    'e5',
    'Nf3',
    [
      'Nc6',
      [
        'Bc4',
        [
          'Nf6',
          [
            'c3',
            ['d5', 'exd5', 'Nxd5', 'd4', 'Nb6', 'Bd3']
          ],
          [
            'Nxe4',
            [
              'Qe2',
              ['d5', 'd3', 'Nf6', 'Nxe5', 'Nxe5', 'dxe5']
            ],
          ],
          [
            'Bc5',
            [
              'O-O',
              ['d6', 'Re1', 'Be6', 'Bxe6', 'fxe6', 'Qb3']
            ],
            ['b5', 'Bb6', 'c4']
          ],
        ],
      ],
    ],
  ],
  'Caro-Kann Defense': [
    'e4',
    'c6',
    [
      'd4',
      [
        'd5',
        ['c4', 'e6', 'Nc3', 'Nf6', 'Nf3', 'dxc4'],
        ['Nc3', 'dxc4', 'e5', 'Bf5']
      ],
      ['Nf3', 'd5', 'exd5', 'cxd5', 'c4', 'e6', 'Nc3', 'Nf6']
    ],
  ],
};

class OpeningStudyBoardState extends State<OPChessBoard> {
  late chess.Chess _game;
  late MoveTreeNode _moveTree;
  late MoveTreeNode _currentNode;
  final List<MoveTreeNode> _moveHistory = [];

  @override
  void initState() {
    super.initState();
    _game = chess.Chess();
    _moveTree = buildMoveTree(openings[widget.openingName]!);
    _currentNode = _moveTree;
  }

  // Undo a move and move the game tree back by one
  void _undoMove() {
    setState(() {
      if (_game.undo_move() != null) {
        _currentNode = _moveHistory.removeLast();
      }
    });
  }

  // When a move is selected in the game tree
  void _onMoveSelected(String move) {
    setState(() {
      _game.move(move);
      _moveHistory.add(_currentNode);
      _currentNode =
          _currentNode.children.firstWhere((node) => node.move == move);
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeNotifier>(context).currentTheme;

    return Scaffold(
      body: Column(
        children: [
          Expanded(
            flex: 3,
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(theme.backgroundImage),
                  fit: BoxFit.cover,
                ),
              ),
              child: LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) {
                  double size =
                      constraints.biggest.width < constraints.biggest.height
                          ? constraints.biggest.width
                          : constraints.biggest.height;

                  return GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 8,
                      childAspectRatio: 1,
                    ),
                    itemCount: 64,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      int row = index ~/ 8;
                      int col = index % 8;
                      String square =
                          String.fromCharCode('a'.codeUnitAt(0) + col) +
                              (8 - row).toString();
                      chess.Piece? piece = _game.get(square);
                      String? imageName = _getPieceImage(piece);

                      Color squareColor = (row + col) % 2 == 0
                          ? theme.chessBoardLightColor
                          : theme.chessBoardDarkColor;

                      return Container(
                        color: squareColor,
                        width: size / 8,
                        height: size / 8,
                        child: imageName != null
                            ? Image.asset(imageName, fit: BoxFit.cover)
                            : const SizedBox(),
                      );
                    },
                  );
                },
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: MoveTreeWidget(
                rootNode: _currentNode,
                onMoveSelected: _onMoveSelected,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 100.0),
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
    );
  }

  // Get image for a piece
  String? _getPieceImage(chess.Piece? piece) {
    if (piece == null) return null;
    String pieceSymbol = piece.type.toString();
    String color = piece.color == chess.Color.WHITE ? 'white' : 'black';
    return 'assets/chess_pieces/$color$pieceSymbol.jpg';
  }
}

class MoveTreeNode {
  String move;
  chess.Chess position;
  List<MoveTreeNode> children;

  MoveTreeNode(this.move, this.position) : children = [];
}

class MoveTreeWidget extends StatelessWidget {
  final MoveTreeNode rootNode;
  final ValueChanged<String> onMoveSelected;

  const MoveTreeWidget({
    Key? key,
    required this.rootNode,
    required this.onMoveSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: rootNode.children.length,
      itemBuilder: (context, index) {
        final node = rootNode.children[index];
        return ListTile(
          title: Text(
            node.move,
            style:
                const TextStyle(color: Colors.white),
          ),
          onTap: () => onMoveSelected(node.move),
          trailing: node.children.isNotEmpty
              ? const Icon(Icons.arrow_forward,
                  color: Colors.white)
              : null,
        );
      },
    );
  }
}

// Builds a move tree from a list of moves
MoveTreeNode buildMoveTree(List<dynamic> moves,
    [chess.Chess? initialPosition]) {
  initialPosition ??= chess.Chess();
  var rootNode = MoveTreeNode('', initialPosition);

  // Add moves to the tree
  void addMoves(List<dynamic> moves, MoveTreeNode parentNode) {
    for (var move in moves) {
      if (move is String) {
        var newPosition = chess.Chess.fromFEN(parentNode.position.fen);
        newPosition.move(move);
        var newNode = MoveTreeNode(move, newPosition);
        parentNode.children.add(newNode);
        parentNode = newNode;
      } else if (move is List) {
        addMoves(move, parentNode);
      }
    }
  }

  addMoves(moves, rootNode);
  return rootNode;
}
