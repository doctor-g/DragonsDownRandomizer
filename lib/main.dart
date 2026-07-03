import 'package:flutter/material.dart';

import 'game.dart';

const _maxPlayers = 6;

void main() {
  runApp(const DragonsDownRandomizerApp());
}

const title = 'Dragons Down Randomizer';

class DragonsDownRandomizerApp extends StatelessWidget {
  const DragonsDownRandomizerApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: title,
      theme: ThemeData(colorScheme: .fromSeed(seedColor: Colors.deepPurple)),
      home: MainWidget(),
    );
  }
}

class MainWidget extends StatelessWidget {
  const MainWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(title),
        actions: [
          IconButton(
            onPressed: () => _showLegalPopup(context),
            icon: const Icon(Icons.info),
          ),
        ],
      ),
      body: RandomizerWidget(),
    );
  }

  void _showLegalPopup(BuildContext context) {
    showAboutDialog(
      context: context,
      applicationName: title,
      applicationLegalese: '©2026 Paul Gestwicki',
    );
  }
}

class RandomizerWidget extends StatefulWidget {
  const RandomizerWidget({super.key});

  @override
  State<RandomizerWidget> createState() => _RandomizerWidgetState();
}

class _RandomizerWidgetState extends State<RandomizerWidget> {
  List<String> _terrains = [];
  int _players = 3;
  List<PlayerData> _playerData = [];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Players: '),

            SegmentedButton<int>(
              multiSelectionEnabled: false,
              segments: [
                for (int i = 1; i <= _maxPlayers; i++)
                  ButtonSegment(value: i, label: Text("$i")),
              ],
              selected: {_players},
              onSelectionChanged: (selection) => setState(() {
                _players = selection.first;
              }),
            ),
          ],
        ),
        ElevatedButton(
          onPressed: _onRandomizePressed,
          child: const Text('Randomize'),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              const Text('TERRAINS'),
              ..._terrains.map((terrain) => Text(terrain)),
            ],
          ),
        ),
        if (_playerData.isNotEmpty)
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              spacing: 12.0,
              children: [
                for (int i = 0; i < _playerData.length; i++)
                  Column(
                    children: [
                      Text("PLAYER ${i + 1}"),
                      PlayerWidget(data: _playerData[i]),
                    ],
                  ),
              ],
            ),
          ),
      ],
    );
  }

  void _onRandomizePressed() {
    final shuffled = List.of(terrainPacks)..shuffle();
    setState(() {
      _terrains = shuffled.sublist(0, 3);
      _playerData = _generateRandomPlayerData(_players);
    });
  }

  List<PlayerData> _generateRandomPlayerData(int count) {
    final shuffledLineages = List.of(lineages)..shuffle();
    final shuffledClasses = List.of(classes)..shuffle();
    return [
      for (int i = 0; i < count; i++)
        PlayerData(lineage: shuffledLineages[i], clazz: shuffledClasses[i]),
    ];
  }
}

class PlayerWidget extends StatelessWidget {
  final PlayerData _data;

  const PlayerWidget({super.key, required this._data});

  @override
  Widget build(BuildContext context) {
    return Text('${_data.lineage} ${_data.clazz}');
  }
}
