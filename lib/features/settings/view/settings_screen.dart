import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:sonkitap/l10n/app_localizations.dart'; 
import '../viewmodel/settings_viewmodel.dart';
import '../../../app/theme/app_theme.dart'; 

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<SettingsViewModel>();
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.settings),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            // "Anasayfaya dönmek için" dediğin için mantığı güncelledim.
            // Önce normal geri gitmeyi dener, gidemezse Ana Sayfaya (Home) atar.
            if (context.canPop()) {
              context.pop();
            } else {
              context.go('/home'); // Direkt ana sayfaya güvenli dönüş
            }
          },
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(24.0),
        children: [
          // --- Visual Theme Section ---
          Text(
            l10n.visuals,
            style: theme.textTheme.titleMedium?.copyWith(
              color: theme.colorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          
          // Theme Mode Selector
          _ThemeModeSelector(
            currentMode: viewModel.themeMode,
            onChanged: (mode) => viewModel.setThemeMode(mode),
            l10n: l10n,
          ),
          
          const SizedBox(height: 24),

          // Color Palette Selector
          Text(
            l10n.accentColor,
            style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 12),
          _ColorPaletteSelector(
            selectedColor: viewModel.themeColor,
            onChanged: (color) => viewModel.setThemeColor(color),
          ),

          const SizedBox(height: 32),
          const Divider(),
          const SizedBox(height: 32),

          // --- Language Section ---
          Text(
            l10n.language,
            style: theme.textTheme.titleMedium?.copyWith(
              color: theme.colorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          _LanguageSelector(
            currentLocale: viewModel.locale,
            onChanged: (locale) => viewModel.setLocale(locale),
            l10n: l10n,
          ),
        ],
      ),
    );
  }
}

class _ThemeModeSelector extends StatelessWidget {
  final ThemeMode currentMode;
  final Function(ThemeMode) onChanged;
  final AppLocalizations l10n;

  const _ThemeModeSelector({
    required this.currentMode,
    required this.onChanged,
    required this.l10n,
  });

  @override
  Widget build(BuildContext context) {
    return SegmentedButton<ThemeMode>(
      segments: [
        ButtonSegment(
          value: ThemeMode.light,
          label: Text(l10n.light),
          icon: const Icon(Icons.wb_sunny_outlined),
        ),
        ButtonSegment(
          value: ThemeMode.dark,
          label: Text(l10n.dark),
          icon: const Icon(Icons.nightlight_outlined),
        ),
        ButtonSegment(
          value: ThemeMode.system,
          label: Text(l10n.system),
          icon: const Icon(Icons.brightness_auto_outlined),
        ),
      ],
      selected: {currentMode},
      onSelectionChanged: (Set<ThemeMode> newSelection) {
        onChanged(newSelection.first);
      },
    );
  }
}

class _ColorPaletteSelector extends StatelessWidget {
  final AppThemeColor selectedColor;
  final Function(AppThemeColor) onChanged;

  const _ColorPaletteSelector({required this.selectedColor, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 16,
      runSpacing: 16,
      children: AppThemeColor.values.map((colorEnum) {
        final color = _getColorFromEnum(colorEnum);
        final isSelected = selectedColor == colorEnum;

        return GestureDetector(
          onTap: () => onChanged(colorEnum),
          child: Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(12),
              border: isSelected
                  ? Border.all(color: Theme.of(context).colorScheme.onSurface, width: 3)
                  : null,
              boxShadow: [
                BoxShadow(
                  color: color.withOpacity(0.4),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: isSelected
                ? const Icon(Icons.check, color: Colors.white)
                : null,
          ),
        );
      }).toList(),
    );
  }

  Color _getColorFromEnum(AppThemeColor colorEnum) {
    switch (colorEnum) {
      case AppThemeColor.green: return Colors.teal;
      case AppThemeColor.red: return Colors.red.shade400;
      case AppThemeColor.blue: return Colors.blue.shade400;
      case AppThemeColor.yellow: return Colors.amber.shade700;
      default: return Colors.deepPurple;
    }
  }
}

class _LanguageSelector extends StatelessWidget {
  final Locale currentLocale;
  final Function(Locale) onChanged;
  final AppLocalizations l10n;

  const _LanguageSelector({
    required this.currentLocale,
    required this.onChanged,
    required this.l10n,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        labelText: l10n.selectLanguage,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),
      value: currentLocale.languageCode,
      items: const [
        DropdownMenuItem(value: 'en', child: Text('🇺🇸 English')),
        DropdownMenuItem(value: 'tr', child: Text('🇹🇷 Türkçe')),
      ],
      onChanged: (value) {
        if (value != null) {
          onChanged(Locale(value));
        }
      },
    );
  }
}
