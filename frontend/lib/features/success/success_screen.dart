import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_colors.dart';
import '../../shared/widgets/app_logo.dart';
import '../application/application_controller.dart';

/// Final screen — confirms the application was submitted and explains what
/// happens next. "Back to home" clears the draft for a fresh start.
class SuccessScreen extends ConsumerWidget {
  const SuccessScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final name = ref.read(applicationProvider).fullName;
    final isWide = MediaQuery.sizeOf(context).width >= 720;

    final nextSteps = [
      (Icons.verified_rounded, 'We\'ve received your application',
          'Your preferences and documents are safely with our team.'),
      (Icons.support_agent_rounded, 'A counsellor will reach out',
          'Expect a call or message on your phone and email soon.'),
      (Icons.flight_takeoff_rounded, 'We guide you the rest of the way',
          'Admission, documentation and travel — step by step.'),
    ];

    return Scaffold(
      appBar: const BrandAppBar(),
      body: SingleChildScrollView(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 640),
            child: Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: isWide ? 32 : 20, vertical: 48),
              child: Column(
                children: [
                  Container(
                    width: 88,
                    height: 88,
                    decoration: const BoxDecoration(
                      color: AppColors.primaryLight,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.check_rounded,
                        size: 48, color: AppColors.primary),
                  ),
                  const SizedBox(height: 28),
                  Text(
                    name.isEmpty
                        ? 'Application submitted!'
                        : 'Thank you, ${name.split(' ').first}!',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textPrimary),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Your MBBS-abroad application has been submitted '
                    'successfully. Our counsellors will take it from here.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 16,
                        height: 1.6,
                        color: AppColors.textSecondary),
                  ),
                  const SizedBox(height: 36),
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Column(
                      children: [
                        for (var i = 0; i < nextSteps.length; i++) ...[
                          _stepRow(nextSteps[i].$1, nextSteps[i].$2,
                              nextSteps[i].$3),
                          if (i < nextSteps.length - 1)
                            const Padding(
                              padding: EdgeInsets.symmetric(vertical: 14),
                              child: Divider(height: 1),
                            ),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                  FilledButton(
                    onPressed: () {
                      ref.read(applicationProvider.notifier).reset();
                      context.go('/');
                    },
                    style: FilledButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 32, vertical: 18),
                    ),
                    child: const Text('Back to home'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _stepRow(IconData icon, String title, String desc) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(9),
          decoration: BoxDecoration(
            color: AppColors.primaryLight,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, size: 20, color: AppColors.primary),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title,
                  style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary)),
              const SizedBox(height: 3),
              Text(desc,
                  style: const TextStyle(
                      fontSize: 13.5,
                      height: 1.45,
                      color: AppColors.textSecondary)),
            ],
          ),
        ),
      ],
    );
  }
}
