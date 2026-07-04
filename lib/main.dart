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
  List<TerrainConfiguration> _terrains = [];
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
          DataTable(
            columns: <DataColumn>[
              ...['Terrain Pack', 'Setup', 'Civ.'].map(
                (name) => DataColumn(
                  label: Text(name, style: TextStyle(fontWeight: .bold)),
                ),
              ),
            ],
            rows: <DataRow>[
              ..._terrains.map(
                (config) => DataRow(
                  cells: <DataCell>[
                    DataCell(Text(config.packName)),
                    DataCell(
                      Center(child: Text(config.setupCardSide.format())),
                    ),
                    DataCell(
                      Center(child: Text(config.civilizationCardSide.format())),
                    ),
                  ],
                ),
              ),
            ],
          ),

        if (_playerData.isNotEmpty)
          DataTable(
            columns: [
              ...['Player', 'Lineage', 'Class'].map(
                (label) => DataColumn(
                  label: Text(label, style: TextStyle(fontWeight: .bold)),
                ),
              ),
            ],
            rows: [
              for (int i = 0; i < _playerData.length; i++)
                DataRow(
                  cells: [
                    DataCell(Center(child: Text('${i + 1}'))),
                    DataCell(Text(_playerData[i].lineage)),
                    DataCell(Text(_playerData[i].clazz)),
                  ],
                ),
            ],
          ),
      ],
    );
  }

  void _onRandomizePressed() {
    setState(() {
      _terrains = randomizeTerrains(_terrainCount);
      _playerData = randomizePlayerData(_playerCount);
    });
  }

  Widget _makeNumberSelector({
    required String label,
    int min = 1,
    required int max,
    required int selected,
    required void Function(int selection) onSelected,
  }) => Row(
    mainAxisAlignment: MainAxisAlignment.center,
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

extension on Side {
  String format() => this == Side.one ? '1' : '2';
}

class PlayerWidget extends StatelessWidget {
  final PlayerData _data;

  const PlayerWidget({super.key, required this._data});

  @override
  Widget build(BuildContext context) {
    return Text('${_data.lineage} ${_data.clazz}');
  }
}
