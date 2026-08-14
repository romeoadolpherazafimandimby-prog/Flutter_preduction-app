import 'dart:math';

class PredictionEngine {
  static Future<Map<String, dynamic>> compute({
    required double homeOdd,
    required double drawOdd,
    required double awayOdd,
  }) async {
    await Future.delayed(const Duration(milliseconds: 900));

    if (homeOdd <= 0 || drawOdd <= 0 || awayOdd <= 0) {
      throw ArgumentError('Les cotes doivent être supérieures à zéro.');
    }

    final invH = 1 / homeOdd;
    final invD = 1 / drawOdd;
    final invA = 1 / awayOdd;
    final sum = invH + invD + invA;

    int h = (invH / sum * 100).round();
    int d = (invD / sum * 100).round();
    int a = 100 - h - d;

    // Small deterministic weighting + RNG simulation.
    final rng = Random();
    final scoreH = rng.nextInt(4);
    final scoreA = rng.nextInt(4);

    final maxProb = [h, d, a].reduce(max);
    final confidence = maxProb >= 55
        ? 'Élevée'
        : maxProb >= 42
            ? 'Moyenne'
            : 'Faible';

    return {
      'home': h,
      'draw': d,
      'away': a,
      'score': '$scoreH-$scoreA',
      'confidence': confidence,
      'goals': scoreH + scoreA,
    };
  }
}
