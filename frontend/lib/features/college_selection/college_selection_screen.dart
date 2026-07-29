import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_colors.dart';
import '../../data/colleges_data.dart';
import '../../data/models/college.dart';
import '../../shared/utils.dart';
import '../../shared/widgets/app_logo.dart';
import '../../shared/widgets/step_progress.dart';
import '../application/application_controller.dart';

/// Step 2 — for each chosen country, the student picks up to 3 preferred
/// colleges (in priority order). Closed-admission colleges are shown but
/// cannot be selected.
class CollegeSelectionScreen extends ConsumerWidget {
  const CollegeSelectionScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final draft = ref.watch(applicationProvider);
    final controller = ref.read(applicationProvider.notifier);
    final isWide = MediaQuery.sizeOf(context).width >= 720;

    return Scaffold(
      appBar: const BrandAppBar(),
      body: draft.countries.isEmpty
          ? _EmptyState()
          : Column(
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
                              const StepProgress(current: 1),
                              const SizedBox(height: 32),
                              const Text(
                                'Choose your preferred colleges',
                                style: TextStyle(
                                    fontSize: 28,
                                    fontWeight: FontWeight.w800,
                                    color: AppColors.textPrimary),
                              ),
                              const SizedBox(height: 8),
                              const Text(
                                'Pick as many universities as you like, in '
                                'your order of preference. Closed admissions '
                                'are shown but cannot be selected.',
                                style: TextStyle(
                                    fontSize: 15,
                                    color: AppColors.textSecondary),
                              ),
                              const SizedBox(height: 28),
                              for (final country in draft.countries)
                                _CountrySection(
                                  countryName: country,
                                  countryPriority:
                                      controller.priorityOf(country),
                                  priorityOf: controller.collegePriorityOf,
                                  onToggle: controller.toggleCollege,
                                ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                _bottomBar(context, draft.collegeIds.length),
              ],
            ),
    );
  }

  Widget _bottomBar(BuildContext context, int selectedCount) {
    final canProceed = selectedCount > 0;
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(top: BorderSide(color: AppColors.border)),
      ),
      padding: const EdgeInsets.fromLTRB(24, 18, 24, 22),
      child: SafeArea(
        top: false,
        child: Align(
          alignment: Alignment.center,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 960),
            child: Row(
              children: [
                OutlinedButton(
                  onPressed: () => context.go('/countries'),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 14),
                  ),
                  child: const Text('Back'),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    selectedCount == 1
                        ? '1 college selected'
                        : '$selectedCount colleges selected',
                    style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textSecondary),
                  ),
                ),
                FilledButton.icon(
                  onPressed:
                      canProceed ? () => context.go('/details') : null,
                  icon: const Icon(Icons.arrow_forward_rounded, size: 20),
                  label: const Text('Continue'),
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 14),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _CountrySection extends StatelessWidget {
  final String countryName;
  final int countryPriority;
  final int Function(String) priorityOf;
  final void Function(String) onToggle;

  const _CountrySection({
    required this.countryName,
    required this.countryPriority,
    required this.priorityOf,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    final country = CollegeCatalog.countries
        .firstWhere((c) => c.name == countryName);
    final colleges = CollegeCatalog.byCountry(countryName);

    return Padding(
      padding: const EdgeInsets.only(bottom: 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(country.flag, style: const TextStyle(fontSize: 24)),
              const SizedBox(width: 10),
              Text(
                country.name,
                style: const TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary),
              ),
              const SizedBox(width: 10),
              if (countryPriority > 0)
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: AppColors.primaryLight,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    '${ordinal(countryPriority)} choice country',
                    style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primary),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 14),
          ...colleges.map((c) => _CollegeCard(
                college: c,
                priority: priorityOf(c.id),
                onTap: () => onToggle(c.id),
              )),
        ],
      ),
    );
  }
}

class _CollegeCard extends StatelessWidget {
  final College college;
  final int priority; // 0 = not selected
  final VoidCallback onTap;

  const _CollegeCard({
    required this.college,
    required this.priority,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final closed = !college.admissionOpen;
    final selected = priority > 0;
    final disabled = closed;

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Opacity(
        opacity: disabled ? 0.55 : 1,
        child: Material(
          color: selected ? AppColors.primaryLight : AppColors.surface,
          borderRadius: BorderRadius.circular(14),
          child: InkWell(
            onTap: disabled ? null : onTap,
            borderRadius: BorderRadius.circular(14),
            child: Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: selected ? AppColors.primary : AppColors.border,
                  width: selected ? 2 : 1,
                ),
              ),
              child: Row(
                children: [
                  _leading(selected, closed),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          college.name,
                          style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textPrimary),
                        ),
                        const SizedBox(height: 4),
                        Wrap(
                          spacing: 8,
                          runSpacing: 4,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: [
                            Text(
                              '${college.program} · ${college.level}',
                              style: const TextStyle(
                                  fontSize: 12.5,
                                  color: AppColors.textSecondary),
                            ),
                            if (closed) _closedTag(),
                          ],
                        ),
                      ],
                    ),
                  ),
                  if (selected) _priorityBadge(priority),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _leading(bool selected, bool closed) {
    if (closed) {
      return const Icon(Icons.lock_outline_rounded,
          color: AppColors.textMuted, size: 22);
    }
    return Icon(
      selected
          ? Icons.check_circle_rounded
          : Icons.radio_button_unchecked_rounded,
      color: selected ? AppColors.primary : AppColors.textMuted,
      size: 22,
    );
  }

  Widget _closedTag() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
      decoration: BoxDecoration(
        color: AppColors.closed.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(5),
      ),
      child: const Text(
        'Admission Closed',
        style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            color: AppColors.closed),
      ),
    );
  }

  Widget _priorityBadge(int priority) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.accent,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        '${ordinal(priority)} choice',
        style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: AppColors.primaryDark),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.public_off_rounded,
              size: 48, color: AppColors.textMuted),
          const SizedBox(height: 16),
          const Text('Please choose your countries first',
              style: TextStyle(
                  fontSize: 16, color: AppColors.textSecondary)),
          const SizedBox(height: 20),
          FilledButton(
            onPressed: () => context.go('/countries'),
            child: const Text('Back to countries'),
          ),
        ],
      ),
    );
  }
}
