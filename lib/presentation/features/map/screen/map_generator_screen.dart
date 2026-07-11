import 'dart:io';
import 'dart:math';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'map_screen.dart'; // import MapFilterMode
import '../provider/map_provider.dart';

class FractalNoise {
  final int seed;
  final double frequency;
  final int octaves = 4;
  final double lacunarity = 2.0;
  final double gain = 0.5;
  late final List<int> p;

  FractalNoise({required this.seed, required this.frequency}) {
    final rand = Random(seed);
    final list = List.generate(256, (i) => i);
    list.shuffle(rand);
    p = List.from(list)..addAll(list);
  }

  double noise2d(double x, double y) {
    int X = x.floor() & 255;
    int Y = y.floor() & 255;

    double xf = x - x.floor();
    double yf = y - y.floor();

    double u = fade(xf);
    double v = fade(yf);

    int aa = p[p[X] + Y];
    int ab = p[p[X] + Y + 1];
    int ba = p[p[X + 1] + Y];
    int bb = p[p[X + 1] + Y + 1];

    double x1 = lerp(u, grad(aa, xf, yf), grad(ba, xf - 1, yf));
    double x2 = lerp(u, grad(ab, xf, yf - 1), grad(bb, xf - 1, yf - 1));

    return (lerp(v, x1, x2) + 1.0) / 2.0;
  }

  double getFractal(double x, double y) {
    double total = 0.0;
    double amplitude = 1.0;
    double freq = frequency / 100.0;
    double maxValue = 0.0;

    for (int i = 0; i < octaves; i++) {
      total += noise2d(x * freq, y * freq) * amplitude;
      maxValue += amplitude;
      amplitude *= gain;
      freq *= lacunarity;
    }

    return total / maxValue;
  }

  double fade(double t) => t * t * t * (t * (t * 6 - 15) + 10);
  double lerp(double t, double a, double b) => a + t * (b - a);
  double grad(int hash, double x, double y) {
    int h = hash & 7;
    double u = h < 4 ? x : y;
    double v = h < 4 ? y : x;
    return ((h & 1) == 0 ? u : -u) + ((h & 2) == 0 ? v * 2.0 : -v * 2.0);
  }
}

class MapGeneratorScreen extends ConsumerStatefulWidget {
  const MapGeneratorScreen({super.key});

  @override
  ConsumerState<MapGeneratorScreen> createState() => _MapGeneratorScreenState();
}

class _MapGeneratorScreenState extends ConsumerState<MapGeneratorScreen> {
  final _nameController = TextEditingController(text: 'New World Map');
  int _seed = 12345;
  double _frequency = 4.0;
  double _seaLevel = 0.45;
  MapFilterMode _theme = MapFilterMode.original;
  bool _isGenerating = false;
  late FractalNoise _noise;

  @override
  void initState() {
    super.initState();
    _rollSeed();
  }

  void _rollSeed() {
    HapticFeedback.selectionClick();
    setState(() {
      _seed = Random().nextInt(999999);
      _noise = FractalNoise(seed: _seed, frequency: _frequency);
    });
  }

  void _updateNoise() {
    setState(() {
      _noise = FractalNoise(seed: _seed, frequency: _frequency);
    });
  }

  Color _getColorForHeight(double h, double seaLevel, MapFilterMode theme) {
    if (theme == MapFilterMode.sepia) {
      if (h < seaLevel) {
        return const Color(0xFFF5E6CA);
      } else if (h < seaLevel + 0.05) {
        return const Color(0xFFE8D5B5);
      } else if (h < 0.7) {
        return const Color(0xFFD4B28C);
      } else {
        return const Color(0xFF8C6239);
      }
    } else if (theme == MapFilterMode.dark) {
      if (h < seaLevel) {
        return const Color(0xFF111827);
      } else if (h < seaLevel + 0.05) {
        return const Color(0xFF1F2937);
      } else if (h < 0.7) {
        return const Color(0xFF374151);
      } else {
        return const Color(0xFFEF4444);
      }
    } else if (theme == MapFilterMode.satellite) {
      if (h < seaLevel) {
        return const Color(0xFF2C5282);
      } else if (h < seaLevel + 0.05) {
        return const Color(0xFFE2E8F0);
      } else if (h < 0.8) {
        return const Color(0xFFFFFFFF);
      } else {
        return const Color(0xFFCBD5E0);
      }
    } else {
      if (h < seaLevel) {
        return const Color(0xFF1E3A8A);
      } else if (h < seaLevel + 0.04) {
        return const Color(0xFFFBBF24);
      } else if (h < 0.65) {
        return const Color(0xFF047857);
      } else if (h < 0.82) {
        return const Color(0xFF78716C);
      } else {
        return const Color(0xFFF3F4F6);
      }
    }
  }

  Future<void> _forgeMap() async {
    HapticFeedback.mediumImpact();
    setState(() => _isGenerating = true);

    try {
      final recorder = ui.PictureRecorder();
      final canvas = Canvas(recorder);
      const size = 600.0;
      
      const cols = 200;
      const rows = 200;
      const dx = size / cols;
      const dy = size / rows;

      for (int col = 0; col < cols; col++) {
        for (int row = 0; row < rows; row++) {
          final x = col.toDouble();
          final y = row.toDouble();
          final val = _noise.getFractal(x, y);
          final color = _getColorForHeight(val, _seaLevel, _theme);
          final paint = Paint()..color = color;
          canvas.drawRect(Rect.fromLTWH(col * dx, row * dy, dx + 0.3, dy + 0.3), paint);
        }
      }

      final picture = recorder.endRecording();
      final img = await picture.toImage(600, 600);
      final byteData = await img.toByteData(format: ui.ImageByteFormat.png);
      final pngBytes = byteData!.buffer.asUint8List();

      final tempDir = await getTemporaryDirectory();
      final tempFilePath = p.join(tempDir.path, 'procedural_map_${DateTime.now().millisecondsSinceEpoch}.png');
      final file = File(tempFilePath);
      await file.writeAsBytes(pngBytes);

      final mapName = _nameController.text.trim().isEmpty ? 'Procedural Map' : _nameController.text.trim();
      await ref.read(worldMapListProvider.notifier).addMap(mapName, tempFilePath);

      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Forged map "$mapName" successfully!'),
            backgroundColor: Theme.of(context).colorScheme.tertiary,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to forge map: $e'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isGenerating = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        backgroundColor: theme.colorScheme.surface,
        elevation: 0,
        title: Text(
          'Forge Fantasy Map',
          style: theme.textTheme.headlineMedium!.copyWith(
            fontFamily: 'Lora',
            color: theme.colorScheme.primary,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        actions: [
          if (!_isGenerating)
            TextButton.icon(
              onPressed: _forgeMap,
              icon: const Icon(Icons.check),
              label: const Text('Forge', style: TextStyle(fontWeight: FontWeight.bold)),
              style: TextButton.styleFrom(
                foregroundColor: theme.colorScheme.primary,
              ),
            ),
        ],
      ),
      body: _isGenerating
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircularProgressIndicator(),
                  const SizedBox(height: 16),
                  Text(
                    'Rendering procedural lands...',
                    style: theme.textTheme.bodyMedium!.copyWith(color: theme.colorScheme.onSurfaceVariant),
                  ),
                ],
              ),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // Map Preview Card
                  Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    clipBehavior: Clip.antiAlias,
                    child: Container(
                      height: 280,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surfaceContainerLowest,
                      ),
                      child: CustomPaint(
                        painter: MapPreviewPainter(
                          noise: _noise,
                          seaLevel: _seaLevel,
                          theme: _theme,
                          colorHelper: _getColorForHeight,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  
                  // Bento Control Panel
                  // Section 1: Map Identity
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surfaceContainerHighest.withOpacity(0.4),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: theme.colorScheme.outline.withOpacity(0.1)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'MAP IDENTITY',
                          style: theme.textTheme.labelMedium!.copyWith(
                            color: theme.colorScheme.primary,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.1,
                          ),
                        ),
                        const SizedBox(height: 10),
                        TextField(
                          controller: _nameController,
                          style: theme.textTheme.bodyLarge!,
                          decoration: const InputDecoration(
                            labelText: 'Map Name',
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Section 2: Generation Seed
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surfaceContainerHighest.withOpacity(0.4),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: theme.colorScheme.outline.withOpacity(0.1)),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'WORLD SEED',
                                style: theme.textTheme.labelMedium!.copyWith(
                                  color: theme.colorScheme.primary,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1.1,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                '#$_seed',
                                style: theme.textTheme.headlineMedium!.copyWith(
                                  fontFamily: 'Lora',
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                ),
                              ),
                            ],
                          ),
                        ),
                        ElevatedButton.icon(
                          onPressed: _rollSeed,
                          icon: const Icon(Icons.casino, size: 18),
                          label: const Text('Roll'),
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Section 3: Parameters Slider
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surfaceContainerHighest.withOpacity(0.4),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: theme.colorScheme.outline.withOpacity(0.1)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'GEOGRAPHY PARAMETERS',
                          style: theme.textTheme.labelMedium!.copyWith(
                            color: theme.colorScheme.primary,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.1,
                          ),
                        ),
                        const SizedBox(height: 12),
                        // Sea Level
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Sea Level', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                            Text('${(_seaLevel * 100).toStringAsFixed(0)}%', style: TextStyle(color: theme.colorScheme.primary, fontWeight: FontWeight.bold, fontSize: 13)),
                          ],
                        ),
                        Slider(
                          value: _seaLevel,
                          min: 0.2,
                          max: 0.8,
                          onChanged: (val) {
                            setState(() => _seaLevel = val);
                          },
                        ),
                        const SizedBox(height: 8),
                        // Frequency
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Land Mass Density', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                            Text('${_frequency.toStringAsFixed(1)}x', style: TextStyle(color: theme.colorScheme.primary, fontWeight: FontWeight.bold, fontSize: 13)),
                          ],
                        ),
                        Slider(
                          value: _frequency,
                          min: 1.5,
                          max: 8.0,
                          onChanged: (val) {
                            setState(() {
                              _frequency = val;
                              _updateNoise();
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Section 4: Themes
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surfaceContainerHighest.withOpacity(0.4),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: theme.colorScheme.outline.withOpacity(0.1)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'CARTOGRAPHY THEME',
                          style: theme.textTheme.labelMedium!.copyWith(
                            color: theme.colorScheme.primary,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.1,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            _themeChip(MapFilterMode.original, 'Verdant RPG'),
                            const SizedBox(width: 8),
                            _themeChip(MapFilterMode.sepia, 'Classic Sepia'),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            _themeChip(MapFilterMode.dark, 'Volcanic Ash'),
                            const SizedBox(width: 8),
                            _themeChip(MapFilterMode.satellite, 'Frostlands'),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _themeChip(MapFilterMode mode, String label) {
    final isSelected = _theme == mode;
    final theme = Theme.of(context);
    return Expanded(
      child: InkWell(
        onTap: () {
          HapticFeedback.selectionClick();
          setState(() => _theme = mode);
        },
        borderRadius: BorderRadius.circular(10),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isSelected ? theme.colorScheme.primary : theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: isSelected ? theme.colorScheme.primary : theme.colorScheme.outline.withOpacity(0.2),
            ),
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: isSelected ? theme.colorScheme.onPrimary : theme.colorScheme.onSurface,
            ),
          ),
        ),
      ),
    );
  }
}

class MapPreviewPainter extends CustomPainter {
  final FractalNoise noise;
  final double seaLevel;
  final MapFilterMode theme;
  final Color Function(double, double, MapFilterMode) colorHelper;

  MapPreviewPainter({
    required this.noise,
    required this.seaLevel,
    required this.theme,
    required this.colorHelper,
  });

  @override
  void paint(Canvas canvas, Size size) {
    const cols = 80;
    const rows = 80;
    final dx = size.width / cols;
    final dy = size.height / rows;

    for (int col = 0; col < cols; col++) {
      for (int row = 0; row < rows; row++) {
        final x = col.toDouble();
        final y = row.toDouble();
        final val = noise.getFractal(x, y);
        final color = colorHelper(val, seaLevel, theme);
        final paint = Paint()..color = color;
        canvas.drawRect(Rect.fromLTWH(col * dx, row * dy, dx + 0.5, dy + 0.5), paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant MapPreviewPainter oldDelegate) {
    return oldDelegate.noise.seed != noise.seed ||
        oldDelegate.noise.frequency != noise.frequency ||
        oldDelegate.seaLevel != seaLevel ||
        oldDelegate.theme != theme;
  }
}
