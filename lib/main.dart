import 'package:flutter/material.dart';

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
        Column(children: [..._terrains.map((terrain) => Text(terrain))]),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Players: '),
            DropdownButton(
              items: [
                ...[1, 2, 3, 4].map(
                  (number) => DropdownMenuItem<int>(
                    value: number,
                    child: Text(number.toString()),
                  ),
                ),
              ],
              value: _players,
              onChanged: (value) => {
                if (value != null)
                  {
                    setState(() {
                      _players = value;
                    }),
                  },
              },
            ),
          ],
        ),
        if (_playerData.isNotEmpty)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: 12.0,
            children: [
              for (int i = 0; i < _players; i++)
                Column(
                  children: [
                    Text("Player ${i + 1}"),
                    PlayerWidget(data: _playerData[i]),
                  ],
                ),
            ],
          ),
        ElevatedButton(
          onPressed: _onRandomizePressed,
          child: const Text('Randomize'),
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

class PlayerData {
  final String lineage;
  final String clazz;

  PlayerData({required this.lineage, required this.clazz});
}

const lineages = ['Dwarf', 'Human', 'Halfling', 'Elf', 'Half-Elf', 'Half-Orc'];

const classes = [
  'Archer',
  'Assassin',
  'Barbarian',
  'Bard',
  'Battle Mage',
  'Black Knight',
  'Cleric',
  'Conjuror',
  'Druid',
  'Enchanter',
  'Executioner',
  'Illusionist',
  'Knight',
  'Magician',
  'Paladin',
  'Ranger',
  'Rogue',
  'Runesword',
  'Sorcerer',
  'Soulless',
  'Trickster',
  'Witch',
];

const terrainPacks = [
  'Cruel Caves',
  'Malevolent Mountains',
  'Perilous Plains',
  'Sinister Swamps',
  'Wicked Woods',
];
