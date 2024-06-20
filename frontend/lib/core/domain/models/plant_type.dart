enum PlantType {
  flower,
  tree,
  grass,
  moss,
  unknown
}

extension Extension on PlantType {
  String get displayTitle {
    switch (this) {
      case PlantType.flower:
        return 'Цветок';
      case PlantType.tree:
        return 'Дерево';
      case PlantType.grass:
        return 'Трава';
      case PlantType.moss:
        return 'Мох';
      case PlantType.unknown:
        return 'Неизвесно';
    }
  }
}