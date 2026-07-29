import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_colors.dart';
import '../../shared/widgets/app_logo.dart';

/// Privacy Policy — required because the application collects sensitive
/// documents (marksheets, passport, Aadhaar). Written in plain language and
/// aligned with India's DPDP Act expectations.
class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.sizeOf(context).width >= 720;

    return Scaffold(
      appBar: const BrandAppBar(),
      body: SingleChildScrollView(
        child: Align(
          alignment: Alignment.topCenter,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 800),
            child: Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: isWide ? 32 : 16, vertical: 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Privacy Policy',
                      style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.w800,
                          color: AppColors.textPrimary)),
                  const SizedBox(height: 8),
                  const Text(
                    'How Sree Consultancy collects, uses and protects your information.',
                    style:
                        TextStyle(fontSize: 15, color: AppColors.textSecondary),
                  ),
                  const SizedBox(height: 28),

                  _section('1. Who we are', [
                    'Sree Consultancy helps students apply to medical (MBBS) programmes at '
                        'universities abroad. This policy explains what we collect when you '
                        'submit an application through this website, and how we handle it.',
                  ]),

                  _section('2. Information we collect', [
                    'When you submit an application, we collect:',
                    '•  Your name, phone number and email address',
                    '•  Your NEET score',
                    '•  Your preferred countries and universities',
                    '•  Documents you upload (optional): 10th marksheet, 12th '
                        'marksheet, passport (front page), Aadhaar card and '
                        'NEET scorecard',
                  ]),

                  _section('3. Why we collect it', [
                    'We use this information only to:',
                    '•  Assess your eligibility and guide you on suitable universities',
                    '•  Prepare and submit your application to the universities you select',
                    '•  Contact you about your application',
                    'We do not sell your information, and we do not use it for advertising.',
                  ]),

                  _section('4. Your consent', [
                    'We collect and process your information only after you tick the consent '
                        'box on the application form. You may withdraw your consent at any time '
                        'by contacting us (see section 9); we will then stop processing and '
                        'delete your data, unless we are legally required to keep it.',
                  ]),

                  _section('5. How we protect your data', [
                    '•  All data is transmitted over an encrypted (HTTPS) connection',
                    '•  Documents are stored in private, encrypted storage — never publicly accessible',
                    '•  Access is restricted to authorised Sree Consultancy staff, behind a '
                        'password-protected admin login',
                    '•  Document access by staff is logged',
                  ]),

                  _section('6. Who we share it with', [
                    'We share your application details and documents only with the universities '
                        'and their authorised admission partners that you have selected, for the '
                        'purpose of processing your admission. We do not share your data with '
                        'anyone else, except where required by law.',
                  ]),

                  _section('7. How long we keep it', [
                    'We retain your application and documents for the duration of the admission '
                        'cycle you applied for, and for a reasonable period afterwards to support '
                        'your admission process. After that — or earlier on your request — your '
                        'data is deleted.',
                  ]),

                  _section('8. Your rights', [
                    'You may ask us to:',
                    '•  Show you the information we hold about you',
                    '•  Correct anything that is wrong',
                    '•  Delete your information',
                    '•  Withdraw your consent',
                    'Contact us using the details below and we will act on your request.',
                  ]),

                  _section('9. Contact us', [
                    'For any privacy question or request, contact Sree Consultancy through the '
                        'phone number or email address you were given when you received this '
                        'application link.',
                  ]),

                  const SizedBox(height: 8),
                  const Divider(),
                  const SizedBox(height: 16),
                  const Text(
                    'This policy may be updated from time to time. Please review it '
                    'whenever you submit a new application.',
                    style:
                        TextStyle(fontSize: 13, color: AppColors.textMuted),
                  ),
                  const SizedBox(height: 28),
                  Center(
                    child: OutlinedButton.icon(
                      onPressed: () => context.go('/'),
                      icon: const Icon(Icons.arrow_back_rounded, size: 18),
                      label: const Text('Back to site'),
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _section(String title, List<String> paragraphs) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 26),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary)),
          const SizedBox(height: 10),
          for (final p in paragraphs)
            Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Text(p,
                  style: const TextStyle(
                      fontSize: 14.5,
                      height: 1.6,
                      color: AppColors.textSecondary)),
            ),
        ],
      ),
    );
  }
}
