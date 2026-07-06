/*
 * Copyright 2026 Paul Gestwicki
 *
 * This file is part of Dragons Down Randomizer.
 *
 * Dragons Down Randomizer is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
 *
 * Dragons Down Randomizer is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License along with Dragons Down Randomizer. If not, see <https://www.gnu.org/licenses/>.
 */

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import 'game.dart';

const _maxPlayers = 6;
const title = 'Dragons Down Randomizer';
const sourceUriString = 'https://github.com/doctor-g/DragonsDownRandomizer';

late final PackageInfo packageInfo;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  packageInfo = await PackageInfo.fromPlatform();
  runApp(const DragonsDownRandomizerApp());
}

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
  static const _linkStyle = TextStyle(
    color: Colors.blue,
    decoration: TextDecoration.underline,
  );

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
      applicationVersion: 'Version ${packageInfo.version}',
      applicationLegalese: 'Copyright 2026 Paul Gestwicki',
      children: [
        Padding(
          // The children use a different indentation level than the legalese.
          // Without the padding, there will be a ragged left, which looks bad.
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
          child: RichText(
            text: TextSpan(
              style: Theme.of(context).textTheme.bodySmall,
              text: 'Based on ',
              children: [
                TextSpan(
                  style: _linkStyle,
                  text: 'Scott DeMers\' ',
                  children: [
                    TextSpan(
                      style: const TextStyle(fontStyle: .italic),
                      text: 'Dragons Down',
                    ),
                  ],
                  recognizer: TapGestureRecognizer()
                    ..onTap = () =>
                        launchUrl(Uri.parse('https://activemagicgames.com')),
                ),
                TextSpan(
                  text:
                      '\n\nThis software is licensed under GNU General Public License. Source code is available at ',
                  children: [
                    TextSpan(
                      style: _linkStyle,
                      text: sourceUriString,
                      recognizer: TapGestureRecognizer()
                        ..onTap = () => launchUrl(Uri.parse(sourceUriString)),
                    ),
                  ],
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
  int _playerCount = 3;
  Tableau? _tableau;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
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
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 250),
            child: _tableau == null
                ? const SizedBox.shrink()
                : TableauWidget(_tableau!, key: ValueKey(_tableau)),
          ),
        ],
      ),
    );
  }

  void _onRandomizePressed() {
    setState(() {
      _tableau = Tableau.random(terrains: _terrainCount, players: _playerCount);
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

class TableauWidget extends StatelessWidget {
  final Tableau _tableau;

  const TableauWidget(this._tableau, {super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        DataTable(
          columns: <DataColumn>[
            ...['Terrain Pack', 'Setup', 'Civ.'].map(
              (name) => DataColumn(
                label: Text(name, style: TextStyle(fontWeight: .bold)),
              ),
            ),
          ],
          rows: <DataRow>[
            ..._tableau.terrains.map(
              (config) => DataRow(
                cells: <DataCell>[
                  DataCell(Text(config.packName)),
                  DataCell(Center(child: Text(config.setupCardSide.format()))),
                  DataCell(
                    Center(child: Text(config.civilizationCardSide.format())),
                  ),
                ],
              ),
            ),
          ],
        ),

        DataTable(
          columns: [
            ...['Player', 'Lineage', 'Class'].map(
              (label) => DataColumn(
                label: Text(label, style: TextStyle(fontWeight: .bold)),
              ),
            ),
          ],
          rows: [
            for (int i = 0; i < _tableau.players.length; i++)
              DataRow(
                cells: [
                  DataCell(Center(child: Text('${i + 1}'))),
                  DataCell(Text(_tableau.players[i].lineage)),
                  DataCell(Text(_tableau.players[i].clazz)),
                ],
              ),
          ],
        ),
      ],
    );
  }
}

extension on Side {
  String format() => this == Side.one ? '1' : '2';
}

class PlayerWidget extends StatelessWidget {
  final PlayerConfiguration _data;

  const PlayerWidget({super.key, required this._data});

  @override
  Widget build(BuildContext context) {
    return Text('${_data.lineage} ${_data.clazz}');
  }
}
