class RankingItem {
  final int rank;
  final String name;
  final String bu;
  final dynamic value; // Could be int or String depending on the ranking type
  final dynamic secondaryValue; // For additional value display
  final dynamic tertiaryValue; // For the third column if needed

  RankingItem({
    required this.rank,
    required this.name,
    required this.bu,
    required this.value,
    this.secondaryValue,
    this.tertiaryValue,
  });
}
