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

List<TerrainConfiguration> randomizeTerrains(int count) {
  if (count < 1 || count > terrainPacks.length) {
    throw Exception('Illegal argument');
  }
  final shuffledTerrains = List.of(terrainPacks)..shuffle(_random);
  return List.generate(
    count,
    (index) => TerrainConfiguration.withRandomSides(shuffledTerrains[index]),
  )..sort((config1, config2) => config1.packName.compareTo(config2.packName));
}

List<PlayerConfiguration> randomizePlayerData(int count) {
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
