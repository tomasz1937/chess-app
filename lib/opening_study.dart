import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'app_theme.dart';
import 'opening_study_board.dart';

class OpeningStudyPage extends StatelessWidget {
  final String openingName;

  const OpeningStudyPage({Key? key, required this.openingName}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeNotifier>(context).currentTheme;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.appBarColor,
        title: Text(
          openingName,
          style: theme.headlineTextStyle,
        ),
        centerTitle: true,
      ),
      body: Row(
        children: [
          Expanded(
            flex: 2,
            child: OPChessBoard(openingName: openingName),
          ),
        ],
      ),
    );
  }
}








