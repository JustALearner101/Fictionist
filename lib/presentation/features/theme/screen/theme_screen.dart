import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fictionist/core/theme/theme_config.dart';
import 'package:fictionist/core/theme/theme_presets.dart';
import 'package:fictionist/presentation/features/theme/provider/theme_provider.dart';
import 'package:fictionist/presentation/common/widget/loading_indicator.dart';
import 'package:fictionist/presentation/common/widget/fictionist_dropdown.dart';
import 'package:google_fonts/google_fonts.dart';

/// Full theme customization screen.
///
/// Displays 8 preset cards in a 2-column grid and font family dropdowns
/// for display, heading, and body text.
class ThemeScreen extends ConsumerWidget {
  const ThemeScreen({super.key});

  static final _fontOptions = {
    'display': ['Lora', 'Playfair Display', 'Cinzel', 'Cormorant Garamond', 'Merriweather'],
    'heading': ['Outfit', 'Poppins', 'Montserrat', 'Raleway', 'Nunito Sans'],
    'body': ['Inter', 'Source Serif 4', 'Nunito', 'Lato', 'Roboto'],
  };

  static final _presets = [
    ThemePresets.grimoire,
    ThemePresets.solar,
    ThemePresets.forest,
    ThemePresets.ocean,
    ThemePresets.obsidian,
    ThemePresets.parchment,
    ThemePresets.neon,
    ThemePresets.monochrome,
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeState = ref.watch(themeNotifierProvider);

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).colorScheme.surface,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 18),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Appearance',
          style: Theme.of(context).textTheme.titleMedium!.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: themeState.when(
        data: (config) => _buildBody(context, ref, config),
        loading: () => const Center(
          child: LoadingIndicator(),
        ),
        error: (err, _) => Center(
          child: Text('Could not load theme: $err'),
        ),
      ),
    );
  }

  Widget _buildBody(
    BuildContext context,
    WidgetRef ref,
    ThemeConfig config,
  ) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        // Presets section
        Text(
          'Presets',
          style: Theme.of(context).textTheme.labelMedium!.copyWith(
            color: Theme.of(context).colorScheme.primary,
            fontSize: 11,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.8,
          ),
        ),
        const SizedBox(height: 12),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            childAspectRatio: 2.2,
          ),
          itemCount: _presets.length,
          itemBuilder: (context, index) {
            final preset = _presets[index];
            final isActive = config.name == preset.name;
            return _PresetCard(
              preset: preset,
              isActive: isActive,
              onTap: () {
                HapticFeedback.selectionClick();
                ref.read(themeNotifierProvider.notifier).applyPreset(preset);
              },
            );
          },
        ),

        const SizedBox(height: 28),

        // Fonts section
        Text(
          'Typography',
          style: Theme.of(context).textTheme.labelMedium!.copyWith(
            color: Theme.of(context).colorScheme.primary,
            fontSize: 11,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.8,
          ),
        ),
        const SizedBox(height: 12),

        _FontDropdown(
          label: 'Display Font',
          value: config.displayFont,
          options: _fontOptions['display']!,
          onChanged: (String value) {
            HapticFeedback.selectionClick();
            ref.read(themeNotifierProvider.notifier).updateConfig(
                  config.copyWith(displayFont: value),
                );
          },
        ),
        const SizedBox(height: 8),
        _FontDropdown(
          label: 'Heading Font',
          value: config.headingFont,
          options: _fontOptions['heading']!,
          onChanged: (String value) {
            HapticFeedback.selectionClick();
            ref.read(themeNotifierProvider.notifier).updateConfig(
                  config.copyWith(headingFont: value),
                );
          },
        ),
        const SizedBox(height: 8),
        _FontDropdown(
          label: 'Body Font',
          value: config.bodyFont,
          options: _fontOptions['body']!,
          onChanged: (String value) {
            HapticFeedback.selectionClick();
            ref.read(themeNotifierProvider.notifier).updateConfig(
                  config.copyWith(bodyFont: value),
                );
          },
        ),
        const SizedBox(height: 16),
        _TypographyPreviewBox(config: config),
        const SizedBox(height: 28),

        // Reset
        Center(
          child: OutlinedButton.icon(
            onPressed: () {
              HapticFeedback.mediumImpact();
              ref
                  .read(themeNotifierProvider.notifier)
                  .resetToDefault();
            },
            icon: const Icon(Icons.refresh, size: 16),
            label: const Text('Reset to Default'),
            style: OutlinedButton.styleFrom(
              foregroundColor:
                  Theme.of(context).colorScheme.onSurfaceVariant,
              side: BorderSide(
                color: Theme.of(context).colorScheme.outline,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

/// A card representing a theme preset with color swatches.
class _PresetCard extends StatelessWidget {
  final ThemeConfig preset;
  final bool isActive;
  final VoidCallback onTap;

  const _PresetCard({
    required this.preset,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.5),
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      preset.name as String,
                      style:
                          Theme.of(context).textTheme.bodyLarge!.copyWith(
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      ),
                    ),
                  ),
                  if (isActive)
                    Icon(
                      Icons.check_circle,
                      size: 16,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                ],
              ),
              const SizedBox(height: 8),
              // Color swatches
              Row(
                children: [
                  _swatch(context, preset.primary),
                  const SizedBox(width: 4),
                  _swatch(context, preset.secondary),
                  const SizedBox(width: 4),
                  _swatch(context, preset.background),
                  const SizedBox(width: 4),
                  _swatch(context, preset.surface),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _swatch(BuildContext context, int color) {
    return Container(
      width: 16,
      height: 16,
      decoration: BoxDecoration(
        color: Color(color),
        shape: BoxShape.circle,
        border: Border.all(
          color: Theme.of(context).colorScheme.outline,
          width: 0.5,
        ),
      ),
    );
  }
}

/// Dropdown for selecting a font family.
class _FontDropdown extends StatelessWidget {
  final String label;
  final String value;
  final List<String> options;
  final ValueChanged<String> onChanged;
  final String? fontFamily;

  const _FontDropdown({
    required this.label,
    required this.value,
    required this.options,
    required this.onChanged,
    this.fontFamily,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.3),
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        child: Row(
          children: [
            Text(
              label,
              style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
                fontSize: 13,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: FictionistDropdown<String>(
                value: value.isNotEmpty ? value : options.first,
                items: options
                    .map((f) => FictionistDropdownItem<String>(
                          value: f,
                          child: Text(f, style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          )),
                        ))
                    .toList(),
                onChanged: (v) {
                  onChanged(v);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TypographyPreviewBox extends StatelessWidget {
  final ThemeConfig config;
  const _TypographyPreviewBox({required this.config});

  @override
  Widget build(BuildContext context) {
    TextStyle getStyle(String family, {required double fontSize, required FontWeight fontWeight}) {
      try {
        return GoogleFonts.getFont(
          family,
          fontSize: fontSize,
          fontWeight: fontWeight,
          color: Theme.of(context).colorScheme.onSurface,
        );
      } catch (_) {
        return TextStyle(
          fontFamily: family,
          fontSize: fontSize,
          fontWeight: fontWeight,
          color: Theme.of(context).colorScheme.onSurface,
        );
      }
    }

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.2),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withOpacity(0.3),
          width: 0.8,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.text_format_rounded,
                size: 16,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(width: 6),
              Text(
                'LIVE TYPOGRAPHY PREVIEW',
                style: Theme.of(context).textTheme.labelMedium!.copyWith(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.0,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            'The Chronicle of Scania',
            style: getStyle(config.displayFont, fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(
            'Chapter I: The Scholar\'s Exile',
            style: getStyle(config.headingFont, fontSize: 14, fontWeight: FontWeight.w600).copyWith(
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Elidor Thorne carried the Iron Quill through the dense Scania mist. The elders of the Genius Society had pronounced their final decree: to seek the Valley anomaly was to seek heresy.',
            style: getStyle(config.bodyFont, fontSize: 13, fontWeight: FontWeight.normal).copyWith(
              height: 1.5,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
