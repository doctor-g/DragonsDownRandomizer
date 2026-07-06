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

import 'dart:math';

typedef Lineage = String;

final lineages = LineageListBuilder().build([
  LineageSet(4, 'Dwarf'),
  LineageSet(4, 'Elf'),
  LineageSet(4, 'Halfling'),
  LineageSet(4, 'Human'),
  LineageSet(4, 'Half-Elf'),
  LineageSet(2, 'Half-Orc'),
]);

class LineageListBuilder {
  List<Lineage> build(List<LineageSet> sets) {
    return <Lineage>[
      for (final set in sets)
        ...List<Lineage>.generate(set.quantity, (_) => set.lineage),
    ];
  }
}

class LineageSet {
  final int quantity;
  final Lineage lineage;

  LineageSet(this.quantity, this.lineage);
}

class PlayerConfiguration {
  final Lineage lineage;
  final String clazz;

  PlayerConfiguration({required this.lineage, required this.clazz});
}

const classes = [
  'Archer',
  'Assassin',
  'Barbarian',
  'Bard',
  'Battle Mage',
  'Black Knight',
  'Cleric',
  'Conjurer',
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
  'Warlock',
  'Warrior',
  'Witch',
];

const terrainPacks = [
  'Cruel Caves',
  'Malevolent Mountains',
  'Perilous Plains',
  'Sinister Swamps',
  'Wicked Woods',
];

final _random = Random();

enum Side {
  one,
  two;

  factory Side.pickRandom() {
    return _random.nextBool() ? one : two;
  }
}

class TerrainConfiguration {
  /// Name of the terrain pack
  final String packName;
  final Side setupCardSide;
  final Side civilizationCardSide;

  TerrainConfiguration({
    required this.packName,
    required this.setupCardSide,
    required this.civilizationCardSide,
  });

  factory TerrainConfiguration.withRandomSides(String packName) {
    return TerrainConfiguration(
      packName: packName,
      setupCardSide: Side.pickRandom(),
      civilizationCardSide: Side.pickRandom(),
    );
  }
}

/// A configuration of terrains and players for playing the game.
class Tableau {
  final List<TerrainConfiguration> terrains;
  final List<PlayerConfiguration> players;

  Tableau({required this.terrains, required this.players});

  factory Tableau.random({required int terrains, required int players}) {
    return Tableau(
      terrains: randomizeTerrains(terrains),
      players: randomizePlayerData(players),
    );
  }

  static List<TerrainConfiguration> randomizeTerrains(int count) {
    if (count < 1 || count > terrainPacks.length) {
      throw Exception('Illegal argument');
    }
    final shuffledTerrains = List.of(terrainPacks)..shuffle(_random);
    return List.generate(
      count,
      (index) => TerrainConfiguration.withRandomSides(shuffledTerrains[index]),
    )..sort((config1, config2) => config1.packName.compareTo(config2.packName));
  }

  static List<PlayerConfiguration> randomizePlayerData(int count) {
    final shuffledLineages = List.of(lineages)..shuffle();
    final shuffledClasses = List.of(classes)..shuffle();
    return [
      for (int i = 0; i < count; i++)
        PlayerConfiguration(
          lineage: shuffledLineages[i],
          clazz: shuffledClasses[i],
        ),
    ];
  }
}
