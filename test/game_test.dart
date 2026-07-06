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

import 'package:dragons_down_randomizer/game.dart';
import 'package:test/test.dart';

void main() {
  group((ClassRequiresTerrainPredicate).toString(), () {
    final predicate = ClassRequiresTerrainPredicate(
      characterClass: .barbarian,
      terrainPack: .mountains,
    );
    test('rejects barbarians without mountains', () {
      final tableau = _createTableau(characterClass: .barbarian);
      expect(predicate.accepts(tableau), isFalse);
    });
    test('accepts barbarians with mountains', () {
      final tableau = _createTableau(
        characterClass: .barbarian,
        terrainPack: TerrainPack.mountains,
      );
      expect(predicate.accepts(tableau), isTrue);
    });
  });

  group((LineageRequiresTerrainPredicate).toString(), () {
    final predicate = LineageRequiresTerrainPredicate(
      lineage: .dwarf,
      terrain: .caves,
    );
    test('rejects dwarf without caves', () {
      final tableau = _createTableau(lineage: .dwarf);
      expect(predicate.accepts(tableau), isFalse);
    });
    test('accepts dwarf with caves', () {
      final tableau = _createTableau(lineage: .dwarf, terrainPack: .caves);
      expect(predicate.accepts(tableau), isTrue);
    });
  });
}

/// Create a tableau for testing.
///
/// The default parameter values are chosen because, in the game, they have
/// no particular constraints.
Tableau _createTableau({
  TerrainPack? terrainPack,
  CharacterClass characterClass = .rogue,
  Lineage lineage = .human,
}) => Tableau(
  terrains: terrainPack == null
      ? []
      : [TerrainConfiguration.withRandomSides(terrainPack)],
  players: [PlayerConfiguration(lineage: lineage, clazz: characterClass)],
);
