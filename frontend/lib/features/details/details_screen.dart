import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_colors.dart';
import '../../shared/widgets/app_logo.dart';
import '../../shared/widgets/step_progress.dart';
import '../application/application_controller.dart';
import '../application/picked_doc.dart';

/// Step 3 — collect the student's contact details, NEET score, required
/// documents, and consent. All fields are validated before proceeding.
class DetailsScreen extends ConsumerStatefulWidget {
  const DetailsScreen({super.key});

  @override
  ConsumerState<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends ConsumerState<DetailsScreen> {
  static const int _maxBytes = 5 * 1024 * 1024; // 5 MB
  static const _pdf = ['pdf'];
  static const _pdfImg = ['pdf', 'jpg', 'jpeg', 'png'];

  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _phone = TextEditingController();
  final _email = TextEditingController();
  final _neet = TextEditingController();

  PickedDoc? _tenth, _twelfth, _passport, _aadhaar, _neetScorecard;
  String? _tenthErr, _twelfthErr, _passportErr, _aadhaarErr, _neetScorecardErr;
  bool _consent = false;
  bool _consentErr = false;

  @override
  void initState() {
    super.initState();
    // Restore any previously entered values (e.g. after going Back).
    final d = ref.read(applicationProvider);
    _name.text = d.fullName;
    _phone.text = d.phone;
    _email.text = d.email;
    _neet.text = d.neetScore;
    _tenth = d.tenthMarksheet;
    _twelfth = d.twelfthMarksheet;
    _passport = d.passport;
    _aadhaar = d.aadhaar;
    _neetScorecard = d.neetScorecard;
    _consent = d.consent;
  }

  @override
  void dispose() {
    _name.dispose();
    _phone.dispose();
    _email.dispose();
    _neet.dispose();
    super.dispose();
  }

  Future<void> _pick({
    required List<String> allowed,
    required void Function(PickedDoc?) setDoc,
    required void Function(String?) setErr,
  }) async {
    final res = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: allowed,
      withData: true,
    );
    if (res == null || res.files.isEmpty) return;
    final f = res.files.single;
    final ext = f.extension?.toLowerCase() ?? '';
    if (!allowed.contains(ext)) {
      setState(() => setErr('Unsupported file type'));
      return;
    }
    if (f.size > _maxBytes) {
      setState(() => setErr('File too large (max 5 MB)'));
      return;
    }
    setState(() {
      setDoc(PickedDoc(
        fileName: f.name,
        sizeBytes: f.size,
        bytes: f.bytes,
        path: f.path,
      ));
      setErr(null);
    });
  }

  void _onContinue() {
    final formValid = _formKey.currentState?.validate() ?? false;
    setState(() => _consentErr = !_consent);

    if (!formValid || !_consent) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(const SnackBar(
          content: Text('Please complete all required fields.'),
          backgroundColor: AppColors.error,
        ));
      return;
    }

    ref.read(applicationProvider.notifier).saveDetails(
          fullName: _name.text.trim(),
          phone: _phone.text.trim(),
          email: _email.text.trim(),
          neetScore: _neet.text.trim(),
          tenthMarksheet: _tenth,
          twelfthMarksheet: _twelfth,
          passport: _passport,
          aadhaar: _aadhaar,
          neetScorecard: _neetScorecard,
          consent: _consent,
        );
    context.go('/review');
  }

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.sizeOf(context).width >= 720;

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
                    child: Form(
                      key: _formKey,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const StepProgress(current: 2),
                          const SizedBox(height: 32),
                          const Text('Your details & documents',
                              style: TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.w800,
                                  color: AppColors.textPrimary)),
                          const SizedBox(height: 8),
                          const Text(
                              'We use these to process your application. '
                              'Your documents are kept private and secure.',
                              style: TextStyle(
                                  fontSize: 15,
                                  color: AppColors.textSecondary)),
                          const SizedBox(height: 28),
                          _sectionTitle('Contact information'),
                          const SizedBox(height: 14),
                          _textField(
                            controller: _name,
                            label: 'Full name',
                            hint: 'As per your documents',
                            icon: Icons.person_outline_rounded,
                            validator: (v) => (v == null || v.trim().isEmpty)
                                ? 'Please enter your full name'
                                : null,
                          ),
                          const SizedBox(height: 16),
                          _textField(
                            controller: _phone,
                            label: 'Phone number',
                            hint: '10-digit mobile number',
                            icon: Icons.phone_outlined,
                            keyboardType: TextInputType.phone,
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                  RegExp(r'[0-9+\s-]')),
                            ],
                            validator: _validatePhone,
                          ),
                          const SizedBox(height: 16),
                          _textField(
                            controller: _email,
                            label: 'Email address',
                            hint: 'you@example.com',
                            icon: Icons.mail_outline_rounded,
                            keyboardType: TextInputType.emailAddress,
                            validator: _validateEmail,
                          ),
                          const SizedBox(height: 16),
                          _textField(
                            controller: _neet,
                            label: 'NEET score',
                            hint: 'Out of 720',
                            icon: Icons.grade_outlined,
                            keyboardType: const TextInputType.numberWithOptions(
                                decimal: true),
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                  RegExp(r'[0-9.]')),
                            ],
                            validator: _validateNeet,
                          ),
                          const SizedBox(height: 28),
                          _documentsDropdown(),
                          const SizedBox(height: 20),
                          _consentTile(),
                        ],
                      ),
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

  // ── Validators ────────────────────────────────────────────────────
  String? _validatePhone(String? v) {
    final s = (v ?? '').replaceAll(RegExp(r'[\s-]'), '');
    if (s.isEmpty) return 'Please enter your phone number';
    if (!RegExp(r'^(\+91)?[6-9]\d{9}$').hasMatch(s)) {
      return 'Enter a valid 10-digit mobile number';
    }
    return null;
  }

  String? _validateEmail(String? v) {
    final s = (v ?? '').trim();
    if (s.isEmpty) return 'Please enter your email';
    if (!RegExp(r'^[\w.\-+]+@[\w-]+\.[\w.-]+$').hasMatch(s)) {
      return 'Enter a valid email address';
    }
    return null;
  }

  String? _validateNeet(String? v) {
    final s = (v ?? '').trim();
    if (s.isEmpty) return 'Please enter your NEET score';
    final n = double.tryParse(s);
    if (n == null) return 'Enter a valid number';
    if (n < 0 || n > 720) return 'Score must be between 0 and 720';
    return null;
  }

  // ── UI helpers ────────────────────────────────────────────────────
  Widget _sectionTitle(String text) => Text(text,
      style: const TextStyle(
          fontSize: 17,
          fontWeight: FontWeight.w700,
          color: AppColors.textPrimary));

  Widget _textField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    TextInputType? keyboardType,
    List<TextInputFormatter>? inputFormatters,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon, size: 20),
      ),
    );
  }

  /// Collapsed by default — documents are optional, so we don't force the
  /// student to look at four upload fields before they can proceed.
  Widget _documentsDropdown() {
    final uploadedCount = [_tenth, _twelfth, _passport, _aadhaar, _neetScorecard]
        .where((d) => d != null)
        .length;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      clipBehavior: Clip.antiAlias,
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
          leading:
              const Icon(Icons.folder_open_rounded, color: AppColors.primary),
          title: const Text('Documents (Optional)',
              style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary)),
          subtitle: Text(
            uploadedCount > 0
                ? '$uploadedCount of 5 added · PDF, JPG or PNG, up to 5 MB each'
                : 'Share now or add these later · up to 5 MB each',
            style:
                const TextStyle(fontSize: 12.5, color: AppColors.textMuted),
          ),
          children: [
            _uploadField(
              label: '10th marksheet',
              hint: 'PDF only',
              doc: _tenth,
              error: _tenthErr,
              onPick: () => _pick(
                  allowed: _pdf,
                  setDoc: (d) => _tenth = d,
                  setErr: (e) => _tenthErr = e),
              onRemove: () => setState(() => _tenth = null),
            ),
            _uploadField(
              label: '12th marksheet',
              hint: 'PDF only',
              doc: _twelfth,
              error: _twelfthErr,
              onPick: () => _pick(
                  allowed: _pdf,
                  setDoc: (d) => _twelfth = d,
                  setErr: (e) => _twelfthErr = e),
              onRemove: () => setState(() => _twelfth = null),
            ),
            _uploadField(
              label: 'Passport (front page)',
              hint: 'PDF or image',
              doc: _passport,
              error: _passportErr,
              onPick: () => _pick(
                  allowed: _pdfImg,
                  setDoc: (d) => _passport = d,
                  setErr: (e) => _passportErr = e),
              onRemove: () => setState(() => _passport = null),
            ),
            _uploadField(
              label: 'Aadhaar card',
              hint: 'PDF or image',
              doc: _aadhaar,
              error: _aadhaarErr,
              onPick: () => _pick(
                  allowed: _pdfImg,
                  setDoc: (d) => _aadhaar = d,
                  setErr: (e) => _aadhaarErr = e),
              onRemove: () => setState(() => _aadhaar = null),
            ),
            _uploadField(
              label: 'NEET scorecard',
              hint: 'PDF only',
              doc: _neetScorecard,
              error: _neetScorecardErr,
              onPick: () => _pick(
                  allowed: _pdf,
                  setDoc: (d) => _neetScorecard = d,
                  setErr: (e) => _neetScorecardErr = e),
              onRemove: () => setState(() => _neetScorecard = null),
            ),
          ],
        ),
      ),
    );
  }

  Widget _uploadField({
    required String label,
    required String hint,
    required PickedDoc? doc,
    required String? error,
    required VoidCallback onPick,
    required VoidCallback onRemove,
  }) {
    final hasError = error != null;
    final picked = doc != null;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Material(
            color: picked ? AppColors.primaryLight : AppColors.surface,
            borderRadius: BorderRadius.circular(12),
            child: InkWell(
              onTap: picked ? null : onPick,
              borderRadius: BorderRadius.circular(12),
              child: Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 14),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: hasError
                        ? AppColors.error
                        : picked
                            ? AppColors.primary
                            : AppColors.border,
                    width: picked || hasError ? 1.5 : 1,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      picked
                          ? Icons.description_rounded
                          : Icons.cloud_upload_outlined,
                      color: picked ? AppColors.primary : AppColors.textMuted,
                      size: 24,
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(label,
                              style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.textPrimary)),
                          const SizedBox(height: 2),
                          Text(
                            picked
                                ? '${doc.fileName} · ${doc.readableSize}'
                                : hint,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                fontSize: 12.5,
                                color: picked
                                    ? AppColors.primaryDark
                                    : AppColors.textMuted),
                          ),
                        ],
                      ),
                    ),
                    if (picked)
                      Row(
                        children: [
                          TextButton(
                            onPressed: onPick,
                            child: const Text('Replace'),
                          ),
                          IconButton(
                            onPressed: onRemove,
                            icon: const Icon(Icons.close_rounded, size: 20),
                            color: AppColors.textSecondary,
                            tooltip: 'Remove',
                          ),
                        ],
                      )
                    else
                      const Icon(Icons.add_rounded,
                          color: AppColors.primary, size: 22),
                  ],
                ),
              ),
            ),
          ),
          if (hasError)
            Padding(
              padding: const EdgeInsets.only(top: 6, left: 4),
              child: Text(error,
                  style: const TextStyle(
                      fontSize: 12, color: AppColors.error)),
            ),
        ],
      ),
    );
  }

  Widget _consentTile() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.surfaceMuted,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
                color: _consentErr ? AppColors.error : AppColors.border),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 24,
                height: 24,
                child: Checkbox(
                  value: _consent,
                  onChanged: (v) =>
                      setState(() => _consent = v ?? false),
                  activeColor: AppColors.primary,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: 2),
                  child: Text(
                    'I consent to Sree Consultancy collecting and storing '
                    'these documents to process my MBBS-abroad application, '
                    'and I confirm the information provided is accurate.',
                    style: TextStyle(
                        fontSize: 13.5,
                        height: 1.5,
                        color: AppColors.textSecondary),
                  ),
                ),
              ),
            ],
          ),
        ),
        if (_consentErr)
          const Padding(
            padding: EdgeInsets.only(top: 6, left: 4),
            child: Text('Please accept the consent to continue',
                style: TextStyle(fontSize: 12, color: AppColors.error)),
          ),
      ],
    );
  }

  Widget _bottomBar() {
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
            constraints: const BoxConstraints(maxWidth: 760),
            child: Row(
              children: [
                OutlinedButton(
                  onPressed: () => context.go('/colleges'),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 14),
                  ),
                  child: const Text('Back'),
                ),
                const Spacer(),
                FilledButton.icon(
                  onPressed: _onContinue,
                  icon: const Icon(Icons.arrow_forward_rounded, size: 20),
                  label: const Text('Review application'),
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
