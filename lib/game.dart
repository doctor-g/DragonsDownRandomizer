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

class PlayerData {
  final Lineage lineage;
  final String clazz;

  PlayerData({required this.lineage, required this.clazz});
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
