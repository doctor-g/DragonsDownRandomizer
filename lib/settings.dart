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

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: Consumer<Settings>(
        builder: (context, settings, child) => SettingsList(
          sections: [
            SettingsSection(
              tiles: [
                SettingsTile.switchTile(
                  initialValue: settings.preventClassesWithoutTerrains,
                  onToggle: (value) =>
                      settings.preventClassesWithoutTerrains = value,
                  title: const Text('Prevent bad class-terrain pairings'),
                  description: const Text(
                    'Barbarians require Malevolent Mountains, and Rangers require the Wicked Woods.',
                  ),
                ),
                SettingsTile.switchTile(
                  initialValue: settings.preventLineagesWithoutTerrains,
                  onToggle: (value) =>
                      settings.preventLineagesWithoutTerrains = value,
                  title: const Text('Prevent bad lineage-terrain pairings'),
                  description: const Text(
                    'Dwarves require Cruel Caves, and Half-Orcs require Malevolent Mountains.',
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class Settings extends ChangeNotifier {
  static const _preventClassesWithoutTerrainsKey =
      'preventClassesWithoutTerrains';
  static const _preventLineagesWithoutTerrainsKey =
      'preventLineagesWithoutTerrains';
  final SharedPreferences _preferences;

  Settings(this._preferences) {
    _preventClassesWithoutTerrains =
        _preferences.getBool(_preventClassesWithoutTerrainsKey) ?? true;
    _preventLineagesWithoutTerrains =
        _preferences.getBool(_preventLineagesWithoutTerrainsKey) ?? true;
  }

  late bool _preventClassesWithoutTerrains;
  bool get preventClassesWithoutTerrains => _preventClassesWithoutTerrains;
  set preventClassesWithoutTerrains(bool value) {
    _preventClassesWithoutTerrains = value;
    _preferences.setBool(_preventClassesWithoutTerrainsKey, value);
    notifyListeners();
  }

  late bool _preventLineagesWithoutTerrains;
  bool get preventLineagesWithoutTerrains => _preventLineagesWithoutTerrains;
  set preventLineagesWithoutTerrains(bool value) {
    _preventLineagesWithoutTerrains = value;
    _preferences.setBool(_preventLineagesWithoutTerrainsKey, value);
    notifyListeners();
  }
}
