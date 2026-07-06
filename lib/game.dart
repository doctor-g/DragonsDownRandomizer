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

enum Lineage {
  dwarf('Dwarf'),
  elf('Elf'),
  halfling('Halfling'),
  human('Human'),
  halfElf('Half-Elf'),
  halfOrc('Half-Orc');

  final String name;

  const Lineage(this.name);
}

final lineages = LineageListBuilder().build([
  LineageSet(4, Lineage.dwarf),
  LineageSet(4, Lineage.elf),
  LineageSet(4, Lineage.halfling),
  LineageSet(4, Lineage.human),
  LineageSet(4, Lineage.halfElf),
  LineageSet(2, Lineage.halfOrc),
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
  final CharacterClass clazz;

  PlayerConfiguration({required this.lineage, required this.clazz});
}

enum CharacterClass {
  archer('Archer'),
  assassin('Assassin'),
  barbarian('Barbarian'),
  bard('Bard'),
  battleMage('Battle Mage'),
  blackKnight('Black Knight'),
  cleric('Cleric'),
  conjurer('Conjurer'),
  druid('Druid'),
  enchanter('Enchanter'),
  executioner('Executioner'),
  illusionist('Illusionist'),
  knight('Knight'),
  magician('Magician'),
  paladin('Paladin'),
  ranger('Ranger'),
  rogue('Rogue'),
  runesword('Runesword'),
  sorcerer('Sorcerer'),
  soulless('Soulless'),
  trickster('Trickster'),
  warlock('Warlock'),
  warrior('Warrior'),
  witch('Witch');

  final String name;
  const CharacterClass(this.name);
}

enum TerrainPack {
  caves('Cruel Caves'),
  mountains('Malevolent Mountains'),
  plains('Perilous Plains'),
  swamps('Sinister Swamps'),
  woods('Wicked Woods');

  final String name;
  const TerrainPack(this.name);
}

final _random = Random();

enum Side {
  one,
  two;

  factory Side.pickRandom() {
    return _random.nextBool() ? one : two;
  }
}

class TerrainConfiguration {
  final TerrainPack pack;
  final Side setupCardSide;
  final Side civilizationCardSide;

  TerrainConfiguration({
    required this.pack,
    required this.setupCardSide,
    required this.civilizationCardSide,
  });

  factory TerrainConfiguration.withRandomSides(TerrainPack pack) {
    return TerrainConfiguration(
      pack: pack,
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

  bool hasClass(CharacterClass clazz) =>
      players.where((player) => player.clazz == clazz).isNotEmpty;
  bool hasLineage(Lineage lineage) =>
      players.where((player) => player.lineage == lineage).isNotEmpty;
  bool hasTerrain(TerrainPack terrain) =>
      terrains.where((t) => t.pack == terrain).isNotEmpty;

  static List<TerrainConfiguration> randomizeTerrains(int count) {
    if (count < 1 || count > TerrainPack.values.length) {
      throw Exception('Illegal argument');
    }
    final shuffledTerrains = List.of(TerrainPack.values)..shuffle(_random);
    return List.generate(
      count,
      (index) => TerrainConfiguration.withRandomSides(shuffledTerrains[index]),
    )..sort(
      (config1, config2) => config1.pack.name.compareTo(config2.pack.name),
    );
  }

  static List<PlayerConfiguration> randomizePlayerData(int count) {
    final shuffledLineages = List.of(lineages)..shuffle();
    final shuffledClasses = List.of(CharacterClass.values)..shuffle();
    return [
      for (int i = 0; i < count; i++)
        PlayerConfiguration(
          lineage: shuffledLineages[i],
          clazz: shuffledClasses[i],
        ),
    ];
  }
}

abstract class TableauPredicate {
  const TableauPredicate();
  bool accepts(Tableau tableau);
}

class ClassRequiresTerrainPredicate extends TableauPredicate {
  final CharacterClass characterClass;
  final TerrainPack terrainPack;

  const ClassRequiresTerrainPredicate({
    required this.characterClass,
    required this.terrainPack,
  });

  @override
  bool accepts(Tableau tableau) {
    return !tableau.hasClass(characterClass) || tableau.hasTerrain(terrainPack);
  }
}

class LineageRequiresTerrainPredicate extends TableauPredicate {
  final Lineage lineage;
  final TerrainPack terrain;

  const LineageRequiresTerrainPredicate({
    required this.lineage,
    required this.terrain,
  });

  @override
  bool accepts(Tableau tableau) {
    return !tableau.hasLineage(lineage) || tableau.hasTerrain(terrain);
  }
}
