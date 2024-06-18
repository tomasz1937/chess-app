import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'app_theme.dart';
import 'opening_study.dart';

class OpeningListPage extends StatelessWidget {

  // Current list of Openings
  final List<String> openings = [
    'Vienna Game',
    'Italian Game',
    'Caro-Kann Defense',
  ];

  OpeningListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeNotifier>(context).currentTheme;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.appBarColor,
        title: Text(
          'Choose an Opening',
          style: theme.headlineTextStyle,
        ),
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: openings.length,
        itemBuilder: (context, index) {
          final opening = openings[index];
          return ListTile(
            title: Text(opening, style: theme.headlineTextStyle,),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => OpeningStudyPage(openingName: opening),
                ),
              );
            },
          );
        },
      ),
    );
  }
}



