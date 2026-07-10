import 'dart:async';
import 'dart:isolate';

/// Offloads heavy graph layout computation to a background isolate
/// to keep the UI at 60fps.
///
/// Usage:
/// ```dart
/// final result = await GraphIsolateWorker.computeLayout(nodes, edges);
/// ```
class GraphIsolateWorker {
  /// Compute force-directed layout positions in a background isolate.
  /// Returns a list of (nodeId, x, y) tuples.
  static Future<List<(String, double, double)>> computeLayout({
    required List<({String id, double x, double y})> nodes,
    required List<({String sourceId, String targetId})> edges,
    int iterations = 50,
  }) async {
    final receivePort = ReceivePort();

    await Isolate.spawn(_runSimulation, {
      'sendPort': receivePort.sendPort,
      'nodes': nodes,
      'edges': edges,
      'iterations': iterations,
    });

    final result = await receivePort.first as List<({String id, double x, double y})>;
    return result.map((n) => (n.id, n.x, n.y)).toList();
  }

  static void _runSimulation(Map<String, dynamic> params) {
    final sendPort = params['sendPort'] as SendPort;
    var nodeList = (params['nodes'] as List)
        .map((n) => (id: (n as Map)['id'] as String, x: (n['x'] as num).toDouble(), y: (n['y'] as num).toDouble()))
        .toList();
    final edgeList = (params['edges'] as List)
        .map((e) => (sourceId: (e as Map)['sourceId'] as String, targetId: (e['targetId'] as String)))
        .toList();
    final iterations = params['iterations'] as int;

    final repulsionStrength = 5000.0;
    final attractionStrength = 0.01;
    final damping = 0.9;

    for (int iter = 0; iter < iterations; iter++) {
      final forces = List.filled(nodeList.length, (0.0, 0.0));

      // Repulsion between all pairs
      for (int i = 0; i < nodeList.length; i++) {
        for (int j = i + 1; j < nodeList.length; j++) {
          final dx = nodeList[i].x - nodeList[j].x;
          final dy = nodeList[i].y - nodeList[j].y;
          final dist = dx * dx + dy * dy;
          if (dist < 1) continue;
          final force = repulsionStrength / dist;
          final fx = force * dx / dist;
          final fy = force * dy / dist;
          final fi = forces[i];
          final fj = forces[j];
          forces[i] = (fi.$1 + fx, fi.$2 + fy);
          forces[j] = (fj.$1 - fx, fj.$2 - fy);
        }
      }

      // Attraction along edges
      for (final edge in edgeList) {
        final si = nodeList.indexWhere((n) => n.id == edge.sourceId);
        final ti = nodeList.indexWhere((n) => n.id == edge.targetId);
        if (si < 0 || ti < 0) continue;

        final dx = nodeList[ti].x - nodeList[si].x;
        final dy = nodeList[ti].y - nodeList[si].y;
        final dist = (dx * dx + dy * dy).clamp(1, 10000);
        final force = attractionStrength * dist;
        final fi = forces[si];
        final fj = forces[ti];
        forces[si] = (fi.$1 + force * dx / dist, fi.$2 + force * dy / dist);
        forces[ti] = (fj.$1 - force * dx / dist, fj.$2 - force * dy / dist);
      }

      // Apply forces with damping
      for (int i = 0; i < nodeList.length; i++) {
        final f = forces[i];
        nodeList[i] = (
          id: nodeList[i].id,
          x: nodeList[i].x + f.$1 * damping,
          y: nodeList[i].y + f.$2 * damping,
        );
      }
    }

    sendPort.send(nodeList);
  }
}
