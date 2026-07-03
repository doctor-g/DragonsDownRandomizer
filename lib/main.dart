import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

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
      children: [
        Padding(
          // The children use a different indentation level than the legalese.
          // Without the padding, there will be a ragged left, which looks bad.
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: RichText(
            text: TextSpan(
              style: Theme.of(context).textTheme.bodySmall,
              text: 'Based on ',
              children: [
                TextSpan(
                  style: const TextStyle(
                    color: Colors.blue,
                    decoration: TextDecoration.underline,
                  ),
                  text: 'Scott DeMers\' Dragons Down',
                  recognizer: TapGestureRecognizer()
                    ..onTap = () =>
                        launchUrl(Uri.parse('https://activemagicgames.com')),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class RandomizerWidget extends StatefulWidget {
  const RandomizerWidget({super.key});

  @override
  State<RandomizerWidget> createState() => _RandomizerWidgetState();
}

class _RandomizerWidgetState extends State<RandomizerWidget> {
  int _terrainCount = 3;
  List<String> _terrains = [];
  int _playerCount = 3;
  List<PlayerData> _playerData = [];

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 16.0,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _makeNumberSelector(
          label: 'Terrain Packs',
          max: 5,
          selected: _terrainCount,
          onSelected: (selection) => setState(() {
            _terrainCount = selection;
          }),
        ),
        _makeNumberSelector(
          label: 'Players',
          max: _maxPlayers,
          selected: _playerCount,
          onSelected: (selection) => setState(() {
            _playerCount = selection;
          }),
        ),
        ElevatedButton(
          onPressed: _onRandomizePressed,
          child: const Text('Randomize'),
        ),
        if (_terrains.isNotEmpty)
          Column(
            children: [
              const Text('TERRAINS'),
              ..._terrains.map((terrain) => Text(terrain)),
            ],
          ),
        if (_playerData.isNotEmpty)
          Wrap(
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
      ],
    );
  }

  void _onRandomizePressed() {
    final shuffledTerrains = List.of(terrainPacks)..shuffle();
    setState(() {
      _terrains = shuffledTerrains.sublist(0, _terrainCount)..sort();
      _playerData = _generateRandomPlayerData(_playerCount);
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

  Widget _makeNumberSelector({
    required String label,
    int min = 1,
    required int max,
    required int selected,
    required void Function(int selection) onSelected,
  }) => Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      Text('$label: '),
      DropdownMenu<int>(
        enableSearch: false,
        enableFilter: false,
        requestFocusOnTap: false,
        dropdownMenuEntries: [
          for (int i = min; i <= max; i++)
            DropdownMenuEntry(value: i, label: '$i'),
        ],
        initialSelection: selected,
        onSelected: (selection) => setState(() {
          if (selection != null) {
            onSelected.call(selection);
          }
        }),
      ),
    ],
  );
}

class PlayerWidget extends StatelessWidget {
  final PlayerData _data;

  const PlayerWidget({super.key, required this._data});

  @override
  Widget build(BuildContext context) {
    return Text('${_data.lineage} ${_data.clazz}');
  }
}
