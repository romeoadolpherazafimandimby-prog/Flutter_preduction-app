import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../services/db_helper.dart';
import '../services/prediction_engine.dart';

class PredictionPage extends StatefulWidget {
  final String league;
  final List<String> teams;

  const PredictionPage({
    super.key,
    required this.league,
    required this.teams,
  });

  @override
  State<PredictionPage> createState() => _PredictionPageState();
}

class _PredictionPageState extends State<PredictionPage> {
  String? home;
  String? away;
  final homeOdd = TextEditingController(text: '2.00');
  final drawOdd = TextEditingController(text: '3.00');
  final awayOdd = TextEditingController(text: '4.00');
  bool loading = false;

  @override
  void dispose() {
    homeOdd.dispose();
    drawOdd.dispose();
    awayOdd.dispose();
    super.dispose();
  }

  Future<void> runPrediction() async {
    if (home == null || away == null || home == away) {
      _error('Sélectionnez deux équipes différentes.');
      return;
    }

    final h = double.tryParse(homeOdd.text.replaceAll(',', '.'));
    final d = double.tryParse(drawOdd.text.replaceAll(',', '.'));
    final a = double.tryParse(awayOdd.text.replaceAll(',', '.'));

    if (h == null || d == null || a == null || h <= 0 || d <= 0 || a <= 0) {
      _error('Entrez des cotes valides supérieures à zéro.');
      return;
    }

    setState(() => loading = true);

    try {
      final result = await PredictionEngine.compute(
        homeOdd: h,
        drawOdd: d,
        awayOdd: a,
      );

      await DBHelper.add({
        'league': widget.league,
        'home': home!,
        'away': away!,
        'homeProb': result['home'],
        'drawProb': result['draw'],
        'awayProb': result['away'],
        'score': result['score'],
        'confidence': result['confidence'],
        'date': DateTime.now().toIso8601String(),
      });

      if (!mounted) return;
      setState(() => loading = false);

      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('Résultat'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('$home  ${result['home']}%'),
              Text('Nul  ${result['draw']}%'),
              Text('$away  ${result['away']}%'),
              const SizedBox(height: 12),
              Text(
                'Score estimé : ${result['score']}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              Text('Confiance : ${result['confidence']}'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('FERMER'),
            ),
          ],
        ),
      );
    } catch (e) {
      if (mounted) {
        setState(() => loading = false);
        _error('Erreur : $e');
      }
    }
  }

  void _error(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.league)),
      body: ListView(
        padding: const EdgeInsets.all(18),
        children: [
          DropdownButtonFormField<String>(
            value: home,
            decoration: const InputDecoration(
              labelText: 'Équipe domicile',
              border: OutlineInputBorder(),
            ),
            items: widget.teams
                .map((team) => DropdownMenuItem(
                      value: team,
                      child: Text(team),
                    ))
                .toList(),
            onChanged: (value) => setState(() => home = value),
          ),
          const SizedBox(height: 14),
          DropdownButtonFormField<String>(
            value: away,
            decoration: const InputDecoration(
              labelText: 'Équipe extérieure',
              border: OutlineInputBorder(),
            ),
            items: widget.teams
                .map((team) => DropdownMenuItem(
                      value: team,
                      child: Text(team),
                    ))
                .toList(),
            onChanged: (value) => setState(() => away = value),
          ),
          const SizedBox(height: 20),
          Text(
            'Cotes',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 10),
          _oddField(homeOdd, 'Cote domicile'),
          const SizedBox(height: 10),
          _oddField(drawOdd, 'Cote nul'),
          const SizedBox(height: 10),
          _oddField(awayOdd, 'Cote extérieure'),
          const SizedBox(height: 24),
          SizedBox(
            height: 52,
            child: FilledButton.icon(
              onPressed: loading ? null : runPrediction,
              icon: loading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.auto_awesome),
              label: Text(
                loading ? 'ANALYSE...' : 'LANCER LA PRÉDICTION',
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Simulation : les résultats sont des estimations et ne garantissent pas le résultat réel.',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    );
  }

  Widget _oddField(TextEditingController controller, String label) {
    return TextField(
      controller: controller,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
    );
  }
}
