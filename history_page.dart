import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../services/db_helper.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  late Future<List<Map<String, dynamic>>> future;

  @override
  void initState() {
    super.initState();
    future = DBHelper.getHistory();
  }

  Future<void> refresh() async {
    setState(() => future = DBHelper.getHistory());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Historique'),
        actions: [
          IconButton(
            onPressed: () async {
              await DBHelper.clear();
              refresh();
            },
            icon: const Icon(Icons.delete_sweep),
          ),
        ],
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: future,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }

          final rows = snapshot.data ?? [];
          if (rows.isEmpty) {
            return const Center(
              child: Text('Aucune prédiction enregistrée.'),
            );
          }

          return RefreshIndicator(
            onRefresh: refresh,
            child: ListView.builder(
              itemCount: rows.length,
              itemBuilder: (context, index) {
                final item = rows[index];
                final date = DateTime.tryParse(item['date'] as String);
                final dateText = date == null
                    ? item['date'].toString()
                    : DateFormat('dd/MM/yyyy HH:mm').format(date);

                return Card(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  child: ListTile(
                    title: Text(
                      '${item['home']} vs ${item['away']}',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      '${item['league']}\n'
                      '1: ${item['homeProb']}%  N: ${item['drawProb']}%  '
                      '2: ${item['awayProb']}%\n'
                      'Score estimé : ${item['score']} • ${item['confidence']}',
                    ),
                    isThreeLine: true,
                    trailing: Text(
                      dateText,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
