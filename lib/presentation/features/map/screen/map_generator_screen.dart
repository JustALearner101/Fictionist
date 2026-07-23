import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'map_screen.dart'; // import MapFilterMode
import '../provider/map_provider.dart';
import '../../../../domain/name_generator/name_generator_params.dart';
import '../../../../domain/name_generator/generation_type.dart';
import '../../../../domain/use_case/name_generator/generate_names_use_case.dart';
import '../../../../domain/use_case/entity/create_entity_use_case.dart';
import '../../../../domain/entity/entity_type.dart';
import '../../../../domain/entity/entity_status.dart';
import '../../../../injection.dart';

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
  bool _applyIslandMask = true;
  bool _autoGeneratePins = true;
  late FractalNoise _noise;
  late FractalNoise _moistureNoise;
  ui.Image? _previewImage;

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
      _moistureNoise = FractalNoise(seed: _seed + 9999, frequency: _frequency * 1.25);
      _previewImage = null;
    });
    _updatePreview();
  }

  void _updateNoise() {
    setState(() {
      _noise = FractalNoise(seed: _seed, frequency: _frequency);
      _moistureNoise = FractalNoise(seed: _seed + 9999, frequency: _frequency * 1.25);
      _previewImage = null;
    });
    _updatePreview();
  }

  Future<void> _updatePreview() async {
    final elevationNoise = _noise;
    final moistureNoise = _moistureNoise;
    final seaLevel = _seaLevel;
    final theme = _theme;
    final applyIslandMask = _applyIslandMask;

    const w = 300;
    const h = 300;
    final pixels = Uint8List(w * h * 4);

    int index = 0;
    for (int y = 0; y < h; y++) {
      for (int x = 0; x < w; x++) {
        final double col = x.toDouble() * (200.0 / w);
        final double row = y.toDouble() * (200.0 / h);

        double falloff = 1.0;
        if (applyIslandMask) {
          double nx = x / (w - 1) * 2.0 - 1.0;
          double ny = y / (h - 1) * 2.0 - 1.0;
          double d = sqrt(nx * nx + ny * ny);
          if (d > 0.15) {
            falloff = pow(1.0 - (d - 0.15) / (1.414 - 0.15), 1.5).toDouble();
          }
          if (falloff < 0) falloff = 0.0;
        }

        final hVal = elevationNoise.getFractal(col, row) * falloff;
        final mVal = moistureNoise.getFractal(col, row);

        final color = _getBiomeColor(hVal, mVal, seaLevel, theme);
        pixels[index++] = color.red;
        pixels[index++] = color.green;
        pixels[index++] = color.blue;
        pixels[index++] = 255;
      }
    }

    final c = Completer<ui.Image>();
    ui.decodeImageFromPixels(pixels, w, h, ui.PixelFormat.rgba8888, c.complete);
    final img = await c.future;

    if (mounted) {
      setState(() {
        _previewImage = img;
      });
    }
  }

  Future<void> _forgeMap() async {
    HapticFeedback.mediumImpact();
    setState(() => _isGenerating = true);

    try {
      const w = 800;
      const h = 800;
      final pixels = Uint8List(w * h * 4);

      int index = 0;
      for (int y = 0; y < h; y++) {
        for (int x = 0; x < w; x++) {
          final double col = x.toDouble() * (200.0 / w);
          final double row = y.toDouble() * (200.0 / h);

          double falloff = 1.0;
          if (_applyIslandMask) {
            double nx = x / (w - 1) * 2.0 - 1.0;
            double ny = y / (h - 1) * 2.0 - 1.0;
            double d = sqrt(nx * nx + ny * ny);
            if (d > 0.15) {
              falloff = pow(1.0 - (d - 0.15) / (1.414 - 0.15), 1.5).toDouble();
            }
            if (falloff < 0) falloff = 0.0;
          }

          final hVal = _noise.getFractal(col, row) * falloff;
          final mVal = _moistureNoise.getFractal(col, row);

          final color = _getBiomeColor(hVal, mVal, _seaLevel, _theme);
          pixels[index++] = color.red;
          pixels[index++] = color.green;
          pixels[index++] = color.blue;
          pixels[index++] = 255;
        }
      }

      final completer = Completer<ui.Image>();
      ui.decodeImageFromPixels(pixels, w, h, ui.PixelFormat.rgba8888, completer.complete);
      final terrainImage = await completer.future;

      final recorder = ui.PictureRecorder();
      final canvas = Canvas(recorder);
      const canvasSize = 800.0;

      canvas.drawImage(terrainImage, Offset.zero, Paint());

      _renderProceduralDecorations(
        canvas: canvas,
        size: const Size(canvasSize, canvasSize),
        cols: 200,
        rows: 200,
        elevationNoise: _noise,
        moistureNoise: _moistureNoise,
        seaLevel: _seaLevel,
        theme: _theme,
        applyIslandMask: _applyIslandMask,
      );

      final picture = recorder.endRecording();
      final finalImg = await picture.toImage(w, h);
      final byteData = await finalImg.toByteData(format: ui.ImageByteFormat.png);
      final pngBytes = byteData!.buffer.asUint8List();

      final tempDir = await getTemporaryDirectory();
      final tempFilePath = p.join(tempDir.path, 'procedural_map_${DateTime.now().millisecondsSinceEpoch}.png');
      final file = File(tempFilePath);
      await file.writeAsBytes(pngBytes);

      final mapName = _nameController.text.trim().isEmpty ? 'Procedural Map' : _nameController.text.trim();
      final newMap = await ref.read(worldMapListProvider.notifier).addMap(mapName, tempFilePath);

      if (_autoGeneratePins) {
        await _generateLocationsAndPins(newMap.id);
      }

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

  double _getHeightAt(int col, int row, int cols, int rows) {
    final x = col.toDouble();
    final y = row.toDouble();
    
    double falloff = 1.0;
    if (_applyIslandMask) {
      double nx = col / (cols - 1) * 2.0 - 1.0;
      double ny = row / (rows - 1) * 2.0 - 1.0;
      double d = sqrt(nx * nx + ny * ny);
      if (d > 0.15) {
        falloff = pow(1.0 - (d - 0.15) / (1.414 - 0.15), 1.5).toDouble();
      }
      if (falloff < 0) falloff = 0.0;
    }
    
    return _noise.getFractal(x, y) * falloff;
  }

  double _getMoistureAt(int col, int row) {
    final x = col.toDouble();
    final y = row.toDouble();
    return _moistureNoise.getFractal(x, y);
  }

  Future<void> _generateLocationsAndPins(String mapId) async {
    final createEntity = getIt<CreateEntityUseCase>();
    final genNames = getIt<GenerateNamesUseCase>();

    final rand = Random();
    final count = 3 + rand.nextInt(3);

    final points = <Point<int>>[];
    final list = <Point<int>>[];
    const cols = 200;
    const rows = 200;

    for (int col = 15; col < 185; col += 6) {
      for (int row = 15; row < 185; row += 6) {
        final h = _getHeightAt(col, row, cols, rows);
        if (h >= _seaLevel) {
          list.add(Point(col, row));
        }
      }
    }

    if (list.isEmpty) return;

    list.shuffle(rand);
    for (final p in list) {
      if (points.length >= count) break;

      bool farEnough = true;
      for (final existing in points) {
        final dist = sqrt(pow(p.x - existing.x, 2) + pow(p.y - existing.y, 2));
        if (dist < 32) {
          farEnough = false;
          break;
        }
      }
      if (farEnough) {
        points.add(p);
      }
    }

    final nameResult = await genNames(NameGeneratorParams(
      type: GenerationType.locationName,
      count: points.length,
    ));

    final names = nameResult.fold(
      (_) => List.generate(points.length, (i) => 'Outpost ${i + 1}'),
      (list) => list.map((g) => g.name).toList(),
    );

    for (int i = 0; i < points.length; i++) {
      final p = points[i];
      final name = names[i];
      final h = _getHeightAt(p.x, p.y, cols, rows);
      final m = _getMoistureAt(p.x, p.y);

      String locationType = 'Settlement';
      String descKeyword = 'settlement';
      String descDetails = 'A prominent stronghold established on the plains.';
      int iconColor = 0xFF8B5CF6;

      if (h >= 0.72) {
        locationType = 'Citadel';
        descKeyword = 'fortress';
        descDetails = 'A high fortress guarding the peak of the mountain range.';
        iconColor = 0xFF64748B;
      } else if (h < _seaLevel + 0.05) {
        locationType = 'Port';
        descKeyword = 'port';
        descDetails = 'A bustling coastal port nestled on the shore.';
        iconColor = 0xFF3B82F6;
      } else if (m < 0.35) {
        locationType = 'Oasis';
        descKeyword = 'oasis';
        descDetails = 'A rare desert oasis refuge amidst the arid wasteland.';
        iconColor = 0xFFF59E0B;
      } else if (m > 0.65) {
        locationType = 'Sanctuary';
        descKeyword = 'forest';
        descDetails = 'A secluded forest sanctuary hidden deep within the woods.';
        iconColor = 0xFF10B981;
      }

      final entityResult = await createEntity(CreateEntityParams(
        name: name,
        type: EntityType.location,
        status: EntityStatus.canon,
        description: '$name ($locationType). $descDetails Keywords: $descKeyword',
        iconColor: iconColor,
      ));

      await entityResult.fold(
        (f) async {},
        (entity) async {
          await ref.read(mapPinsProvider(mapId).notifier).addPin(
            entityId: entity.id,
            xPercent: p.x / 200.0,
            yPercent: p.y / 200.0,
            label: name,
          );
        },
      );
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
            fontFamily: theme.textTheme.displayLarge?.fontFamily,
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
                          previewImage: _previewImage,
                          elevationNoise: _noise,
                          moistureNoise: _moistureNoise,
                          seaLevel: _seaLevel,
                          theme: _theme,
                          applyIslandMask: _applyIslandMask,
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
                                  fontFamily: Theme.of(context).textTheme.displayLarge?.fontFamily,
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
                            _updatePreview();
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

                  // Section 4: Cartographic Options
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
                          'CARTOGRAPHIC OPTIONS',
                          style: theme.textTheme.labelMedium!.copyWith(
                            color: theme.colorScheme.primary,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.1,
                          ),
                        ),
                        const SizedBox(height: 12),
                        SwitchListTile(
                          contentPadding: EdgeInsets.zero,
                          title: const Text('Apply Island Mask', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                          subtitle: const Text('Shape terrain into a centralized continent/island', style: TextStyle(fontSize: 11)),
                          value: _applyIslandMask,
                          onChanged: (val) {
                            setState(() => _applyIslandMask = val);
                            _updatePreview();
                          },
                        ),
                        const Divider(),
                        SwitchListTile(
                          contentPadding: EdgeInsets.zero,
                          title: const Text('Auto-generate Location Pins', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                          subtitle: const Text('Procedurally create & pin 3-5 Codex locations', style: TextStyle(fontSize: 11)),
                          value: _autoGeneratePins,
                          onChanged: (val) {
                            setState(() => _autoGeneratePins = val);
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Section 5: Themes
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
          _updatePreview();
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
  final ui.Image? previewImage;
  final FractalNoise elevationNoise;
  final FractalNoise moistureNoise;
  final double seaLevel;
  final MapFilterMode theme;
  final bool applyIslandMask;

  MapPreviewPainter({
    required this.previewImage,
    required this.elevationNoise,
    required this.moistureNoise,
    required this.seaLevel,
    required this.theme,
    required this.applyIslandMask,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (previewImage != null) {
      canvas.drawImageRect(
        previewImage!,
        Rect.fromLTWH(0, 0, previewImage!.width.toDouble(), previewImage!.height.toDouble()),
        Rect.fromLTWH(0, 0, size.width, size.height),
        Paint()..filterQuality = FilterQuality.medium,
      );
    } else {
      canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), Paint()..color = Colors.grey.shade800);
    }

    _renderProceduralDecorations(
      canvas: canvas,
      size: size,
      cols: 80,
      rows: 80,
      elevationNoise: elevationNoise,
      moistureNoise: moistureNoise,
      seaLevel: seaLevel,
      theme: theme,
      applyIslandMask: applyIslandMask,
    );
  }

  @override
  bool shouldRepaint(covariant MapPreviewPainter oldDelegate) {
    return oldDelegate.previewImage != previewImage ||
        oldDelegate.elevationNoise.seed != elevationNoise.seed ||
        oldDelegate.moistureNoise.seed != moistureNoise.seed ||
        oldDelegate.elevationNoise.frequency != elevationNoise.frequency ||
        oldDelegate.seaLevel != seaLevel ||
        oldDelegate.theme != theme ||
        oldDelegate.applyIslandMask != applyIslandMask;
  }
}

Color _getBiomeColor(double h, double m, double seaLevel, MapFilterMode theme) {
  // Water
  if (h < seaLevel) {
    final isDeep = h < seaLevel * 0.7;
    switch (theme) {
      case MapFilterMode.sepia:
        return isDeep ? const Color(0xFFCBB596) : const Color(0xFFDCC7A9);
      case MapFilterMode.dark:
        return isDeep ? const Color(0xFF0F172A) : const Color(0xFF1E293B);
      case MapFilterMode.satellite:
        return isDeep ? const Color(0xFF0F3D59) : const Color(0xFF1E5B7F);
      case MapFilterMode.original:
      default:
        return isDeep ? const Color(0xFF1D4ED8) : const Color(0xFF2563EB);
    }
  }
  
  // Beach / Sand (Shore)
  if (h < seaLevel + 0.03) {
    switch (theme) {
      case MapFilterMode.sepia:
        return const Color(0xFFEADBBE);
      case MapFilterMode.dark:
        return const Color(0xFF374151);
      case MapFilterMode.satellite:
        return const Color(0xFFE2E8F0);
      case MapFilterMode.original:
      default:
        return const Color(0xFFFEF08A);
    }
  }

  // High Peaks / Mountain Range
  if (h >= 0.72) {
    final isSnow = h >= 0.82;
    switch (theme) {
      case MapFilterMode.sepia:
        return isSnow ? const Color(0xFF5C4033) : const Color(0xFF8C7154);
      case MapFilterMode.dark:
        return isSnow ? const Color(0xFFEF4444) : const Color(0xFF991B1B);
      case MapFilterMode.satellite:
        return isSnow ? const Color(0xFFFFFFFF) : const Color(0xFF94A3B8);
      case MapFilterMode.original:
      default:
        return isSnow ? const Color(0xFFF3F4F6) : const Color(0xFF78716C);
    }
  }

  // Base colors for flat land biomes
  Color baseColor;
  Color cDesert;
  Color cGrass;
  Color cForest;
  switch (theme) {
    case MapFilterMode.sepia:
      cDesert = const Color(0xFFDFCEB4);
      cGrass = const Color(0xFFCBB799);
      cForest = const Color(0xFFA89274);
      break;
    case MapFilterMode.dark:
      cDesert = const Color(0xFF4B5563);
      cGrass = const Color(0xFF064E35);
      cForest = const Color(0xFF022C22);
      break;
    case MapFilterMode.satellite:
      cDesert = const Color(0xFFCBD5E1);
      cGrass = const Color(0xFF64748B);
      cForest = const Color(0xFF475569);
      break;
    case MapFilterMode.original:
    default:
      cDesert = const Color(0xFFF59E0B);
      cGrass = const Color(0xFF34D399);
      cForest = const Color(0xFF047857);
      break;
  }

  // Smoothly blend biomes based on moisture
  if (m < 0.35) {
    baseColor = cDesert;
  } else if (m < 0.58) {
    final t = (m - 0.35) / (0.58 - 0.35);
    baseColor = Color.lerp(cDesert, cGrass, t)!;
  } else {
    final t = (m - 0.58) / (1.0 - 0.58);
    baseColor = Color.lerp(cGrass, cForest, t)!;
  }

  // Blend with beach at the lower boundary, or mountain at the upper boundary
  if (h < seaLevel + 0.05) {
    final t = (h - (seaLevel + 0.03)) / 0.02;
    Color beachColor;
    switch (theme) {
      case MapFilterMode.sepia: beachColor = const Color(0xFFEADBBE); break;
      case MapFilterMode.dark: beachColor = const Color(0xFF374151); break;
      case MapFilterMode.satellite: beachColor = const Color(0xFFE2E8F0); break;
      case MapFilterMode.original:
      default: beachColor = const Color(0xFFFEF08A); break;
    }
    return Color.lerp(beachColor, baseColor, t.clamp(0.0, 1.0))!;
  } else if (h >= 0.65) {
    final t = (h - 0.65) / 0.07;
    Color mountainColor;
    switch (theme) {
      case MapFilterMode.sepia: mountainColor = const Color(0xFF8C7154); break;
      case MapFilterMode.dark: mountainColor = const Color(0xFF991B1B); break;
      case MapFilterMode.satellite: mountainColor = const Color(0xFF94A3B8); break;
      case MapFilterMode.original:
      default: mountainColor = const Color(0xFF78716C); break;
    }
    return Color.lerp(baseColor, mountainColor, t.clamp(0.0, 1.0))!;
  }

  return baseColor;
}

Color _getGridColor(MapFilterMode theme) {
  switch (theme) {
    case MapFilterMode.sepia:
      return const Color(0xFF8C7154).withOpacity(0.12);
    case MapFilterMode.dark:
      return Colors.white.withOpacity(0.04);
    case MapFilterMode.satellite:
      return Colors.white.withOpacity(0.08);
    case MapFilterMode.original:
    default:
      return Colors.black.withOpacity(0.04);
  }
}

Color _getPenColor(MapFilterMode theme) {
  switch (theme) {
    case MapFilterMode.sepia:
      return const Color(0xFF5C4033);
    case MapFilterMode.dark:
      return const Color(0xFFE2E8F0);
    case MapFilterMode.satellite:
      return const Color(0xFFFFFFFF);
    case MapFilterMode.original:
    default:
      return const Color(0xFF0F172A);
  }
}

void _drawCompassRose(ui.Canvas canvas, ui.Size size, MapFilterMode theme) {
  final cx = size.width - 55.0;
  final cy = size.height - 55.0;
  final r = 24.0;
  
  final penPaint = ui.Paint()
    ..color = _getPenColor(theme).withOpacity(0.5)
    ..style = ui.PaintingStyle.stroke
    ..strokeWidth = 0.8;
    
  final fillPaint = ui.Paint()
    ..color = _getPenColor(theme).withOpacity(0.1)
    ..style = ui.PaintingStyle.fill;
    
  canvas.drawCircle(Offset(cx, cy), r, penPaint);
  
  final innerPenPaint = ui.Paint()
    ..color = _getPenColor(theme).withOpacity(0.5)
    ..style = ui.PaintingStyle.stroke
    ..strokeWidth = 0.4;
  canvas.drawCircle(Offset(cx, cy), r - 4, innerPenPaint);
  
  final p = ui.Path();
  p.moveTo(cx, cy - r);
  p.lineTo(cx + 3, cy - 4);
  p.lineTo(cx, cy);
  p.lineTo(cx - 3, cy - 4);
  p.close();
  
  p.moveTo(cx, cy + r);
  p.lineTo(cx + 3, cy + 4);
  p.lineTo(cx, cy);
  p.lineTo(cx - 3, cy + 4);
  p.close();
  
  p.moveTo(cx + r, cy);
  p.lineTo(cx + 4, cy + 3);
  p.lineTo(cx, cy);
  p.lineTo(cx + 4, cy - 3);
  p.close();
  
  p.moveTo(cx - r, cy);
  p.lineTo(cx - 4, cy + 3);
  p.lineTo(cx, cy);
  p.lineTo(cx - 4, cy - 3);
  p.close();
  
  canvas.drawPath(p, fillPaint);
  canvas.drawPath(p, penPaint);
}

void _renderProceduralDecorations({
  required ui.Canvas canvas,
  required ui.Size size,
  required int cols,
  required int rows,
  required FractalNoise elevationNoise,
  required FractalNoise moistureNoise,
  required double seaLevel,
  required MapFilterMode theme,
  required bool applyIslandMask,
}) {
  final dx = size.width / cols;
  final dy = size.height / rows;

  final gridPaint = ui.Paint()
    ..color = _getGridColor(theme)
    ..style = ui.PaintingStyle.stroke
    ..strokeWidth = 0.3;

  for (double i = 0; i < size.width; i += size.width / 5.0) {
    canvas.drawLine(ui.Offset(i, 0), ui.Offset(i, size.height), gridPaint);
  }
  for (double j = 0; j < size.height; j += size.height / 5.0) {
    canvas.drawLine(ui.Offset(0, j), ui.Offset(size.width, j), gridPaint);
  }

  final penPaint = ui.Paint()
    ..color = _getPenColor(theme).withOpacity(0.65)
    ..style = ui.PaintingStyle.stroke
    ..strokeWidth = 0.6;

  final shadowPaint = ui.Paint()
    ..color = Colors.black.withOpacity(0.12)
    ..style = ui.PaintingStyle.fill;

  for (int col = 0; col < cols; col++) {
    for (int row = 0; row < rows; row++) {
      final x = col.toDouble();
      final y = row.toDouble();

      double falloff = 1.0;
      if (applyIslandMask) {
        double nx = col / (cols - 1) * 2.0 - 1.0;
        double ny = row / (rows - 1) * 2.0 - 1.0;
        double d = sqrt(nx * nx + ny * ny);
        if (d > 0.15) {
          falloff = pow(1.0 - (d - 0.15) / (1.414 - 0.15), 1.5).toDouble();
        }
        if (falloff < 0) falloff = 0.0;
      }

      final h = elevationNoise.getFractal(x, y) * falloff;
      final m = moistureNoise.getFractal(x, y);

      final cx = col * dx + dx / 2;
      final cy = row * dy + dy / 2;

      if (h >= 0.72) {
        final randVal = (sin(col * 12.9898 + row * 78.233) * 43758.5453).abs() % 1.0;
        if (randVal < 0.22) {
          final w = dx * 2.6;
          final heightVal = dy * 2.6;

          final mountainPath = ui.Path();
          mountainPath.moveTo(cx, cy - heightVal / 2);
          mountainPath.lineTo(cx - w / 2, cy + heightVal / 2);
          mountainPath.lineTo(cx + w / 2, cy + heightVal / 2);
          mountainPath.close();

          final shadowPath = ui.Path();
          shadowPath.moveTo(cx, cy - heightVal / 2);
          shadowPath.lineTo(cx, cy + heightVal / 2);
          shadowPath.lineTo(cx + w / 2, cy + heightVal / 2);
          shadowPath.close();

          final mountainBgPaint = ui.Paint()
            ..color = _getBiomeColor(h, m, seaLevel, theme)
            ..style = ui.PaintingStyle.fill;

          canvas.drawPath(mountainPath, mountainBgPaint);
          canvas.drawPath(shadowPath, shadowPaint);
          canvas.drawPath(mountainPath, penPaint);
        }
      } 
      else if (h >= seaLevel + 0.05 && m >= 0.58) {
        final randVal = (sin(col * 34.567 + row * 98.765) * 43758.5453).abs() % 1.0;
        if (randVal < 0.28) {
          final w = dx * 1.8;
          final heightVal = dy * 2.2;

          final treePath = ui.Path();
          treePath.moveTo(cx, cy - heightVal / 2);
          treePath.lineTo(cx - w / 2, cy + heightVal / 2);
          treePath.lineTo(cx + w / 2, cy + heightVal / 2);
          treePath.close();

          final treeBgPaint = ui.Paint()
            ..color = _getBiomeColor(h, m, seaLevel, theme)
            ..style = ui.PaintingStyle.fill;

          canvas.drawPath(treePath, treeBgPaint);
          canvas.drawPath(treePath, penPaint);
          canvas.drawLine(ui.Offset(cx, cy + heightVal / 2), ui.Offset(cx, cy + heightVal / 2 + 1.5), penPaint);
        }
      }
    }
  }

  _drawCompassRose(canvas, size, theme);
}
