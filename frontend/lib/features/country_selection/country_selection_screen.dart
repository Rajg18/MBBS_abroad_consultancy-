import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_colors.dart';
import '../../data/api/api_config.dart';
import '../../data/api/catalog_repository.dart';
import '../../data/colleges_data.dart';
import '../../data/models/college.dart';
import '../../shared/widgets/app_logo.dart';
import '../../shared/widgets/step_progress.dart';
import '../application/application_controller.dart';

/// Step 1 — the student picks up to 3 preferred countries, in priority order.
class CountrySelectionScreen extends ConsumerWidget {
  const CountrySelectionScreen({super.key});

  static String _ordinal(int n) => switch (n) {
        1 => '1st',
        2 => '2nd',
        3 => '3rd',
        _ => '${n}th',
      };

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final draft = ref.watch(applicationProvider);
    final controller = ref.read(applicationProvider.notifier);
    final isWide = MediaQuery.sizeOf(context).width >= 720;
    final selectedCount = draft.countries.length;
    final full = selectedCount >= ApplicationController.maxCountries;
    final catalogAsync = ref.watch(catalogProvider);

    return Scaffold(
      appBar: const BrandAppBar(),
      body: catalogAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => _CatalogError(
            message: apiErrorMessage(e),
            onRetry: () => ref.invalidate(catalogProvider)),
        data: (_) => Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Align(
                alignment: Alignment.topCenter,
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 960),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: isWide ? 32 : 16, vertical: 28),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                  const StepProgress(current: 0),
                  const SizedBox(height: 32),
                  const Text(
                    'Where do you want to study?',
                    style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textPrimary),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Pick up to 3 countries in your order of preference. '
                    'Tap again to remove.',
                    style: TextStyle(
                        fontSize: 15, color: AppColors.textSecondary),
                  ),
                  const SizedBox(height: 24),
                  Wrap(
                    spacing: 16,
                    runSpacing: 16,
                    children: [
                      for (final country in CollegeCatalog.countries)
                        SizedBox(
                          width: isWide
                              ? (960 - 32 * 2 - 16 * 2) / 3
                              : double.infinity,
                          child: _CountryCard(
                            country: country,
                            priority: controller.priorityOf(country.name),
                            disabled: full &&
                                controller.priorityOf(country.name) == 0,
                            ordinalLabel: _ordinal,
                            onTap: () => controller.toggleCountry(country.name),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
          ),
          _bottomBar(context, selectedCount, controller),
        ],
      ),
      ),
    );
  }

  Widget _bottomBar(
      BuildContext context, int selectedCount, ApplicationController c) {
    final canProceed = selectedCount > 0;
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(top: BorderSide(color: AppColors.border)),
      ),
      padding: const EdgeInsets.fromLTRB(20, 14, 20, 18),
      child: SafeArea(
        top: false,
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 960),
            child: Row(
              children: [
                Text(
                  '$selectedCount of ${ApplicationController.maxCountries} selected',
                  style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textSecondary),
                ),
                const Spacer(),
                FilledButton.icon(
                  onPressed:
                      canProceed ? () => context.go('/colleges') : null,
                  icon: const Icon(Icons.arrow_forward_rounded, size: 20),
                  label: const Text('Continue'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _CountryCard extends StatelessWidget {
  final Country country;
  final int priority; // 0 = not selected
  final bool disabled;
  final String Function(int) ordinalLabel;
  final VoidCallback onTap;

  const _CountryCard({
    required this.country,
    required this.priority,
    required this.disabled,
    required this.ordinalLabel,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final all = CollegeCatalog.byCountry(country.name);
    final openCount = all.where((c) => c.admissionOpen).length;
    final selected = priority > 0;

    return Opacity(
      opacity: disabled ? 0.45 : 1,
      child: Material(
        color: selected ? AppColors.primaryLight : AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          onTap: disabled ? null : onTap,
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: selected ? AppColors.primary : AppColors.border,
                width: selected ? 2 : 1,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    _FlagImage(flag: country.flag),
                    const Spacer(),
                    if (selected)
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.accent,
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: Text(
                          '${ordinalLabel(priority)} choice',
                          style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: AppColors.primaryDark),
                        ),
                      )
                    else
                      Icon(Icons.add_circle_outline_rounded,
                          color: AppColors.textMuted, size: 22),
                  ],
                ),
                const SizedBox(height: 14),
                Text(
                  country.name,
                  style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary),
                ),
                const SizedBox(height: 4),
                Text(
                  '${all.length} universities · $openCount open',
                  style: const TextStyle(
                      fontSize: 13, color: AppColors.textSecondary),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Converts a flag emoji (e.g. 🇷🇺) to its 2-letter ISO country code (e.g. "ru").
/// Flag emojis are pairs of Regional Indicator Symbols starting at U+1F1E6 ('A').
String _isoFromFlag(String flag) {
  try {
    return flag.runes
        .map((r) => String.fromCharCode(r - 0x1F1A5))
        .join()
        .toLowerCase();
  } catch (_) {
    return '';
  }
}

/// Renders a country flag as a network image from flagcdn.com.
/// Falls back to the emoji text if the image fails to load.
class _FlagImage extends StatelessWidget {
  final String flag;
  const _FlagImage({required this.flag});

  @override
  Widget build(BuildContext context) {
    final iso = _isoFromFlag(flag);
    if (iso.length != 2) {
      return Text(flag, style: const TextStyle(fontSize: 30));
    }
    return Image.network(
      'https://flagcdn.com/w40/$iso.png',
      width: 48,
      height: 32,
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) =>
          Text(flag, style: const TextStyle(fontSize: 30)),
    );
  }
}

/// Shown when the catalogue fails to load from the backend.
class _CatalogError extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _CatalogError({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.cloud_off_rounded,
                size: 48, color: AppColors.textMuted),
            const SizedBox(height: 16),
            Text(message,
                textAlign: TextAlign.center,
                style: const TextStyle(
                    fontSize: 16, color: AppColors.textSecondary)),
            const SizedBox(height: 20),
            FilledButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh_rounded, size: 20),
              label: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}
