import 'package:flutter/material.dart';
import '../models/match_data.dart';
import 'prediction_page.dart';
import 'history_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _index = 0;

  final _pages = const [
    _Dashboard(),
    HistoryPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_index],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (value) => setState(() => _index = value),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.sports_soccer),
            label: 'Accueil',
          ),
          NavigationDestination(
            icon: Icon(Icons.history),
            label: 'Historique',
          ),
        ],
      ),
    );
  }
}

class _Dashboard extends StatelessWidget {
  const _Dashboard();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Mom Preduct',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 6),
            Text(
              'Simulation de prédiction sportive',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 28),
            _LeagueCard(
              title: 'English League 2',
              icon: Icons.flag,
              teams: MatchData.englishLeague2,
            ),
            const SizedBox(height: 14),
            _LeagueCard(
              title: 'Coupe d’Afrique',
              icon: Icons.public,
              teams: MatchData.coupeAfrique,
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Mise à jour effectuée.')),
                  );
                },
                icon: const Icon(Icons.sync),
                label: const Text('MISE À JOUR'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LeagueCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final List<String> teams;

  const _LeagueCard({
    required this.title,
    required this.icon,
    required this.teams,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                IconButton(
                  tooltip: 'Nouvelle prédiction',
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => PredictionPage(
                          league: title,
                          teams: teams,
                        ),
                      ),
                    );
                  },
                  icon: const Icon(Icons.arrow_forward),
                ),
              ],
            ),
            Text('${teams.length} équipes de démonstration'),
          ],
        ),
      ),
    );
  }
}
