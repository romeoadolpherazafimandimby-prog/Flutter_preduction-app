class MatchData {
  final String league;
  final String home;
  final String away;

  const MatchData({
    required this.league,
    required this.home,
    required this.away,
  });

  static const List<String> englishLeague2 = [
    'Wrexham',
    'Notts County',
    'MK Dons',
    'Bradford City',
    'AFC Wimbledon',
    'Salford City',
  ];

  static const List<String> coupeAfrique = [
    "Sénégal",
    "Côte d'Ivoire",
    "Nigeria",
    "Maroc",
    "Égypte",
    "Ghana",
  ];
}
