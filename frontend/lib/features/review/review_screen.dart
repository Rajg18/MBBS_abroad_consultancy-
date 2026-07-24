import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_colors.dart';
import '../../data/api/api_config.dart';
import '../../data/api/application_api.dart';
import '../../data/colleges_data.dart';
import '../../shared/utils.dart';
import '../../shared/widgets/app_logo.dart';
import '../../shared/widgets/step_progress.dart';
import '../application/application_controller.dart';
import '../application/picked_doc.dart';

/// Step 4 — a read-only summary of everything the student entered, with
/// per-section edit links and a final Submit (local stub until the backend).
class ReviewScreen extends ConsumerStatefulWidget {
  const ReviewScreen({super.key});

  @override
  ConsumerState<ReviewScreen> createState() => _ReviewScreenState();
}

class _ReviewScreenState extends ConsumerState<ReviewScreen> {
  bool _submitting = false;

  Future<void> _submit() async {
    setState(() => _submitting = true);
    try {
      // Real API call: POST /api/applications (multipart with the 4 files).
      await ref.read(applicationApiProvider).submit(ref.read(applicationProvider));
      if (!mounted) return;
      context.go('/success');
    } catch (e) {
      if (!mounted) return;
      setState(() => _submitting = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(apiErrorMessage(e)),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final d = ref.watch(applicationProvider);
    final isWide = MediaQuery.sizeOf(context).width >= 720;

    // Guard: reached without completing the flow.
    if (d.collegeIds.isEmpty || d.fullName.isEmpty) {
      return Scaffold(
        appBar: const BrandAppBar(),
        body: _IncompleteState(),
      );
    }

    return Scaffold(
      appBar: const BrandAppBar(),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Align(
                alignment: Alignment.topCenter,
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 760),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: isWide ? 32 : 16, vertical: 28),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const StepProgress(current: 3),
                        const SizedBox(height: 32),
                        const Text('Review your application',
                            style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.w800,
                                color: AppColors.textPrimary)),
                        const SizedBox(height: 8),
                        const Text(
                            'Please check everything is correct before '
                            'submitting. You can edit any section.',
                            style: TextStyle(
                                fontSize: 15,
                                color: AppColors.textSecondary)),
                        const SizedBox(height: 24),
                        _countriesCard(d),
                        const SizedBox(height: 16),
                        _collegesCard(d),
                        const SizedBox(height: 16),
                        _contactCard(d),
                        const SizedBox(height: 16),
                        _documentsCard(d),
                        const SizedBox(height: 16),
                        _consentNote(),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          _bottomBar(),
        ],
      ),
    );
  }

  // ── Sections ──────────────────────────────────────────────────────
  Widget _countriesCard(ApplicationDraft d) {
    return _card(
      title: 'Preferred countries',
      onEdit: _submitting ? null : () => context.go('/countries'),
      child: Column(
        children: [
          for (var i = 0; i < d.countries.length; i++)
            _rankRow(
              rank: i + 1,
              main: d.countries[i],
              trailing: CollegeCatalog.countries
                  .firstWhere((c) => c.name == d.countries[i])
                  .flag,
            ),
        ],
      ),
    );
  }

  Widget _collegesCard(ApplicationDraft d) {
    return _card(
      title: 'Preferred colleges',
      onEdit: _submitting ? null : () => context.go('/colleges'),
      child: Column(
        children: [
          for (var i = 0; i < d.collegeIds.length; i++)
            Builder(builder: (_) {
              final c = CollegeCatalog.byId(d.collegeIds[i]);
              return _rankRow(
                rank: i + 1,
                main: c?.name ?? d.collegeIds[i],
                sub: c == null ? null : '${c.country} · ${c.program}',
              );
            }),
        ],
      ),
    );
  }

  Widget _contactCard(ApplicationDraft d) {
    return _card(
      title: 'Contact details',
      onEdit: _submitting ? null : () => context.go('/details'),
      child: Column(
        children: [
          _infoRow(Icons.person_outline_rounded, 'Name', d.fullName),
          _infoRow(Icons.phone_outlined, 'Phone', d.phone),
          _infoRow(Icons.mail_outline_rounded, 'Email', d.email),
          _infoRow(Icons.grade_outlined, 'NEET score', d.neetScore),
        ],
      ),
    );
  }

  Widget _documentsCard(ApplicationDraft d) {
    return _card(
      title: 'Documents',
      onEdit: _submitting ? null : () => context.go('/details'),
      child: Column(
        children: [
          _docRow('10th marksheet', d.tenthMarksheet),
          _docRow('12th marksheet', d.twelfthMarksheet),
          _docRow('Passport (front page)', d.passport),
          _docRow('Aadhaar card', d.aadhaar),
        ],
      ),
    );
  }

  Widget _consentNote() {
    return Row(
      children: [
        const Icon(Icons.verified_user_outlined,
            size: 18, color: AppColors.success),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            'You have consented to Sree Consultancy processing these details.',
            style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
          ),
        ),
      ],
    );
  }

  // ── Building blocks ───────────────────────────────────────────────
  Widget _card({
    required String title,
    required VoidCallback? onEdit,
    required Widget child,
  }) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(title,
                  style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary)),
              const Spacer(),
              TextButton.icon(
                onPressed: onEdit,
                icon: const Icon(Icons.edit_outlined, size: 16),
                label: const Text('Edit'),
                style: TextButton.styleFrom(
                    visualDensity: VisualDensity.compact),
              ),
            ],
          ),
          const SizedBox(height: 6),
          child,
        ],
      ),
    );
  }

  Widget _rankRow({
    required int rank,
    required String main,
    String? sub,
    String? trailing,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: AppColors.primaryLight,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(ordinal(rank),
                style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primary)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(main,
                    style: const TextStyle(
                        fontSize: 14.5,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary)),
                if (sub != null)
                  Text(sub,
                      style: const TextStyle(
                          fontSize: 12.5, color: AppColors.textSecondary)),
              ],
            ),
          ),
          if (trailing != null)
            Text(trailing, style: const TextStyle(fontSize: 20)),
        ],
      ),
    );
  }

  Widget _infoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(icon, size: 18, color: AppColors.textMuted),
          const SizedBox(width: 12),
          Text('$label:  ',
              style: const TextStyle(
                  fontSize: 14, color: AppColors.textSecondary)),
          Expanded(
            child: Text(value,
                style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary)),
          ),
        ],
      ),
    );
  }

  Widget _docRow(String label, PickedDoc? doc) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          const Icon(Icons.check_circle_rounded,
              size: 18, color: AppColors.success),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                    style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary)),
                if (doc != null)
                  Text('${doc.fileName} · ${doc.readableSize}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          fontSize: 12.5, color: AppColors.textSecondary)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _bottomBar() {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(top: BorderSide(color: AppColors.border)),
      ),
      padding: const EdgeInsets.fromLTRB(20, 14, 20, 18),
      child: SafeArea(
        top: false,
        child: Align(
          alignment: Alignment.center,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 760),
            child: Row(
              children: [
                OutlinedButton(
                  onPressed: _submitting ? null : () => context.go('/details'),
                  child: const Text('Back'),
                ),
                const Spacer(),
                FilledButton.icon(
                  onPressed: _submitting ? null : _submit,
                  icon: _submitting
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                              strokeWidth: 2, color: Colors.white),
                        )
                      : const Icon(Icons.check_rounded, size: 20),
                  label: Text(_submitting ? 'Submitting…' : 'Submit application'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _IncompleteState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.assignment_late_outlined,
              size: 48, color: AppColors.textMuted),
          const SizedBox(height: 16),
          const Text('Please complete your application first',
              style: TextStyle(fontSize: 16, color: AppColors.textSecondary)),
          const SizedBox(height: 20),
          FilledButton(
            onPressed: () => context.go('/countries'),
            child: const Text('Start application'),
          ),
        ],
      ),
    );
  }
}
