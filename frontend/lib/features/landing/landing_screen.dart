import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_colors.dart';
import '../../data/api/catalog_repository.dart';
import '../../data/colleges_data.dart';
import '../../shared/widgets/app_logo.dart';

/// First screen a visitor sees. No login required — an inviting, brand-aligned
/// hero (navy + gold) with a single call-to-action to begin the flow.
class LandingScreen extends ConsumerWidget {
  const LandingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Pre-warm the catalogue so the next screen loads instantly.
    ref.watch(catalogProvider);
    final width = MediaQuery.sizeOf(context).width;
    final isWide = width >= 900;

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            _header(isWide),
            Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1120),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: isWide ? 32 : 16,
                    vertical: isWide ? 40 : 24,
                  ),
                  child: Column(
                    children: [
                      _hero(context, isWide),
                      SizedBox(height: isWide ? 72 : 48),
                      _howItWorks(isWide),
                      const SizedBox(height: 56),
                      _footer(context),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Top bar: logo pinned to the left ──────────────────────────────
  Widget _header(bool isWide) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(bottom: BorderSide(color: AppColors.border)),
      ),
      padding: EdgeInsets.symmetric(
        horizontal: isWide ? 32 : 16,
        vertical: 14,
      ),
      child: Align(
        alignment: Alignment.centerLeft,
        child: const AppLogo(height: 46),
      ),
    );
  }

  // ── Navy hero band with gold accents ──────────────────────────────
  Widget _hero(BuildContext context, bool isWide) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: isWide ? 56 : 24,
        vertical: isWide ? 64 : 44,
      ),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.primary, AppColors.primaryDark],
        ),
        borderRadius: BorderRadius.circular(28),
      ),
      child: Column(
        children: [
          _goldPill('Study MBBS Abroad · Intake 2026-2027'),
          const SizedBox(height: 24),
          Text(
            'Your medical career,\nbeyond borders.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: isWide ? 50 : 32,
              height: 1.15,
              fontWeight: FontWeight.w800,
              color: Colors.white,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 20),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 580),
            child: Text(
              'Transform your medical aspirations into achievement. '
              'We operate in 25+ countries, and mainly recommend 11 where '
              'Indian student strength is strong and institutes are '
              'NMC-approved.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                height: 1.6,
                color: Colors.white.withValues(alpha: 0.82),
              ),
            ),
          ),
          const SizedBox(height: 32),
          FilledButton.icon(
            onPressed: () => context.go('/countries'),
            icon: const Icon(Icons.arrow_forward_rounded, size: 20),
            label: const Text('Start Your Application'),
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.accent,
              foregroundColor: AppColors.primaryDark,
              padding:
                  const EdgeInsets.symmetric(horizontal: 32, vertical: 20),
              textStyle:
                  const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
            ),
          ),
          SizedBox(height: isWide ? 56 : 40),
          Divider(color: Colors.white.withValues(alpha: 0.15)),
          SizedBox(height: isWide ? 32 : 24),
          _statsRow(isWide),
        ],
      ),
    );
  }

  Widget _goldPill(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.accent.withValues(alpha: 0.18),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: AppColors.accent.withValues(alpha: 0.5)),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: AppColors.accentLight,
          fontWeight: FontWeight.w600,
          fontSize: 13,
        ),
      ),
    );
  }

  Widget _statsRow(bool isWide) {
    final stats = [
      ('25+', 'Countries'),
      (CollegeCatalog.isLoaded ? '${CollegeCatalog.total}+' : '100+',
          'Universities'),
      ('100%', 'Guided Support'),
    ];
    return Wrap(
      spacing: isWide ? 64 : 32,
      runSpacing: 20,
      alignment: WrapAlignment.center,
      children: [
        for (final (value, label) in stats)
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(value,
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w800,
                    color: AppColors.accent,
                  )),
              const SizedBox(height: 4),
              Text(label,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white.withValues(alpha: 0.8),
                  )),
            ],
          ),
      ],
    );
  }

  Widget _howItWorks(bool isWide) {
    final steps = [
      (Icons.public_rounded, 'Pick countries',
          'Choose your top 3 country preferences.'),
      (Icons.school_rounded, 'Pick colleges',
          'Select preferred universities in each.'),
      (Icons.upload_file_rounded, 'Share details (Optional)',
          'Upload documents & contact info securely.'),
    ];
    return Column(
      children: [
        const Text('How it works',
            style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary)),
        const SizedBox(height: 8),
        const Text('Three simple steps to get started',
            style: TextStyle(fontSize: 15, color: AppColors.textSecondary)),
        const SizedBox(height: 32),
        Wrap(
          spacing: 20,
          runSpacing: 20,
          alignment: WrapAlignment.center,
          children: [
            for (var i = 0; i < steps.length; i++)
              SizedBox(
                width: isWide ? 320 : double.infinity,
                child: _stepCard(i + 1, steps[i].$1, steps[i].$2, steps[i].$3),
              ),
          ],
        ),
      ],
    );
  }

  Widget _stepCard(int n, IconData icon, String title, String desc) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(11),
                decoration: BoxDecoration(
                  color: AppColors.primaryLight,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: AppColors.primary, size: 24),
              ),
              const Spacer(),
              Text('0$n',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w800,
                    color: AppColors.accent.withValues(alpha: 0.35),
                  )),
            ],
          ),
          const SizedBox(height: 18),
          Text(title,
              style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary)),
          const SizedBox(height: 8),
          Text(desc,
              style: const TextStyle(
                  fontSize: 14,
                  height: 1.5,
                  color: AppColors.textSecondary)),
        ],
      ),
    );
  }

  Widget _footer(BuildContext context) {
    return Column(
      children: [
        Divider(color: AppColors.border),
        const SizedBox(height: 12),
        Wrap(
          alignment: WrapAlignment.center,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            const Text(
              '© Sree Consultancy · Your data is handled securely.',
              style: TextStyle(fontSize: 13, color: AppColors.textMuted),
            ),
            TextButton(
              onPressed: () => context.go('/privacy'),
              style: TextButton.styleFrom(
                  visualDensity: VisualDensity.compact,
                  textStyle: const TextStyle(fontSize: 13)),
              child: const Text('Privacy Policy'),
            ),
          ],
        ),
      ],
    );
  }
}
