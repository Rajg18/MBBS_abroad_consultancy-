import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_colors.dart';
import '../../data/api/admin_api.dart';
import '../../data/api/api_config.dart';
import '../../data/models/college.dart';
import '../../shared/widgets/app_logo.dart';

/// Admin college management — add, edit, open/close or remove colleges.
/// Changes appear on the student site immediately (no redeploy).
class AdminCollegesScreen extends ConsumerStatefulWidget {
  const AdminCollegesScreen({super.key});

  @override
  ConsumerState<AdminCollegesScreen> createState() =>
      _AdminCollegesScreenState();
}

class _AdminCollegesScreenState extends ConsumerState<AdminCollegesScreen> {
  Future<List<College>>? _future;
  String _search = '';

  @override
  void initState() {
    super.initState();
    _load();
  }

  void _load() {
    final token = ref.read(adminTokenProvider);
    if (token == null) return;
    setState(() => _future = ref.read(adminApiProvider).fetchColleges(token));
  }

  void _toast(String msg, {bool error = false}) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg),
      backgroundColor: error ? AppColors.error : AppColors.success,
    ));
  }

  Future<void> _save(College? existing, Map<String, dynamic> data) async {
    final token = ref.read(adminTokenProvider);
    if (token == null) return;
    try {
      final api = ref.read(adminApiProvider);
      if (existing == null) {
        await api.createCollege(token, data);
        _toast('College added');
      } else {
        await api.updateCollege(token, existing.id, data);
        _toast('College updated');
      }
      _load();
    } catch (e) {
      _toast(apiErrorMessage(e), error: true);
    }
  }

  Future<void> _toggleStatus(College c) async {
    await _save(c, {
      'name': c.name,
      'country': c.country,
      'program': c.program,
      'level': c.level,
      'intake': c.intake,
      'admissionOpen': !c.admissionOpen,
    });
  }

  Future<void> _delete(College c) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Delete college?'),
        content: Text('"${c.name}" will be removed permanently.'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel')),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: AppColors.error),
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (confirmed != true) return;
    final token = ref.read(adminTokenProvider);
    if (token == null) return;
    try {
      await ref.read(adminApiProvider).deleteCollege(token, c.id);
      _toast('College deleted');
      _load();
    } catch (e) {
      _toast(apiErrorMessage(e), error: true);
    }
  }

  Future<void> _openForm({College? existing, required List<String> countries}) async {
    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (_) => _CollegeFormDialog(existing: existing, countries: countries),
    );
    if (result != null) await _save(existing, result);
  }

  @override
  Widget build(BuildContext context) {
    final token = ref.watch(adminTokenProvider);
    if (token == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) context.go('/admin/login');
      });
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 72,
        titleSpacing: 20,
        title: const AppLogo(height: 38),
        shape: const Border(bottom: BorderSide(color: AppColors.border)),
        actions: [
          TextButton.icon(
            onPressed: () => context.go('/admin'),
            icon: const Icon(Icons.people_alt_outlined, size: 18),
            label: const Text('Applications'),
          ),
          IconButton(
              tooltip: 'Refresh',
              onPressed: _load,
              icon: const Icon(Icons.refresh_rounded)),
          const SizedBox(width: 12),
        ],
      ),
      body: FutureBuilder<List<College>>(
        future: _future,
        builder: (context, snap) {
          if (snap.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snap.hasError) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(apiErrorMessage(snap.error!),
                      style: const TextStyle(color: AppColors.textSecondary)),
                  const SizedBox(height: 16),
                  FilledButton(onPressed: _load, child: const Text('Retry')),
                ],
              ),
            );
          }

          final all = snap.data ?? const <College>[];
          final countries =
              (all.map((c) => c.country).toSet().toList()..sort());
          final q = _search.trim().toLowerCase();
          final shown = q.isEmpty
              ? all
              : all
                  .where((c) =>
                      c.name.toLowerCase().contains(q) ||
                      c.country.toLowerCase().contains(q))
                  .toList();

          return SingleChildScrollView(
            child: Align(
              alignment: Alignment.topCenter,
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 900),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Colleges',
                                    style: TextStyle(
                                        fontSize: 26,
                                        fontWeight: FontWeight.w800,
                                        color: AppColors.textPrimary)),
                                const SizedBox(height: 4),
                                Text(
                                    '${all.length} total · '
                                    '${all.where((c) => c.admissionOpen).length} open',
                                    style: const TextStyle(
                                        fontSize: 14,
                                        color: AppColors.textSecondary)),
                              ],
                            ),
                          ),
                          FilledButton.icon(
                            onPressed: () => _openForm(countries: countries),
                            icon: const Icon(Icons.add_rounded, size: 20),
                            label: const Text('Add college'),
                          ),
                        ],
                      ),
                      const SizedBox(height: 18),
                      TextField(
                        decoration: const InputDecoration(
                          hintText: 'Search by college or country…',
                          prefixIcon: Icon(Icons.search_rounded),
                        ),
                        onChanged: (v) => setState(() => _search = v),
                      ),
                      const SizedBox(height: 18),
                      if (shown.isEmpty)
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 40),
                          child: Center(
                            child: Text('No colleges match your search',
                                style:
                                    TextStyle(color: AppColors.textSecondary)),
                          ),
                        ),
                      for (final c in shown)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: _CollegeRow(
                            college: c,
                            onEdit: () =>
                                _openForm(existing: c, countries: countries),
                            onToggle: () => _toggleStatus(c),
                            onDelete: () => _delete(c),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _CollegeRow extends StatelessWidget {
  final College college;
  final VoidCallback onEdit, onToggle, onDelete;

  const _CollegeRow({
    required this.college,
    required this.onEdit,
    required this.onToggle,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final open = college.admissionOpen;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(college.name,
                    style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary)),
                const SizedBox(height: 2),
                Text(
                    '${college.country} · ${college.program} · ${college.level} · ${college.intake}',
                    style: const TextStyle(
                        fontSize: 12.5, color: AppColors.textSecondary)),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: open ? AppColors.primaryLight : AppColors.surfaceMuted,
              borderRadius: BorderRadius.circular(999),
            ),
            child: Text(open ? 'Open' : 'Closed',
                style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: open ? AppColors.primary : AppColors.closed)),
          ),
          const SizedBox(width: 4),
          IconButton(
            tooltip: open ? 'Close admissions' : 'Open admissions',
            onPressed: onToggle,
            icon: Icon(open
                ? Icons.toggle_on_rounded
                : Icons.toggle_off_outlined),
            color: open ? AppColors.success : AppColors.textMuted,
          ),
          IconButton(
              tooltip: 'Edit',
              onPressed: onEdit,
              icon: const Icon(Icons.edit_outlined, size: 20)),
          IconButton(
              tooltip: 'Delete',
              onPressed: onDelete,
              icon: const Icon(Icons.delete_outline_rounded, size: 20),
              color: AppColors.error),
        ],
      ),
    );
  }
}

/// Add / edit dialog.
class _CollegeFormDialog extends StatefulWidget {
  final College? existing;
  final List<String> countries;
  const _CollegeFormDialog({this.existing, required this.countries});

  @override
  State<_CollegeFormDialog> createState() => _CollegeFormDialogState();
}

class _CollegeFormDialogState extends State<_CollegeFormDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _name;
  late final TextEditingController _program;
  late final TextEditingController _level;
  late final TextEditingController _intake;
  late String _country;
  late bool _open;

  @override
  void initState() {
    super.initState();
    final e = widget.existing;
    _name = TextEditingController(text: e?.name ?? '');
    _program = TextEditingController(text: e?.program ?? 'General Medicine');
    _level = TextEditingController(text: e?.level ?? 'Bachelor');
    _intake = TextEditingController(text: e?.intake ?? 'Sep-26');
    _country = e?.country ??
        (widget.countries.isNotEmpty ? widget.countries.first : 'Georgia');
    _open = e?.admissionOpen ?? true;
  }

  @override
  void dispose() {
    _name.dispose();
    _program.dispose();
    _level.dispose();
    _intake.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.existing == null ? 'Add college' : 'Edit college'),
      content: SizedBox(
        width: 420,
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: _name,
                  decoration: const InputDecoration(labelText: 'College name'),
                  validator: (v) => (v == null || v.trim().isEmpty)
                      ? 'Enter the college name'
                      : null,
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  initialValue: _country,
                  decoration: const InputDecoration(labelText: 'Country'),
                  items: [
                    for (final c in widget.countries)
                      DropdownMenuItem(value: c, child: Text(c)),
                  ],
                  onChanged: (v) => setState(() => _country = v ?? _country),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _program,
                  decoration: const InputDecoration(labelText: 'Program'),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _level,
                  decoration: const InputDecoration(labelText: 'Level'),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _intake,
                  decoration: const InputDecoration(labelText: 'Intake'),
                ),
                const SizedBox(height: 8),
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Admissions open'),
                  value: _open,
                  onChanged: (v) => setState(() => _open = v),
                ),
              ],
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel')),
        FilledButton(
          onPressed: () {
            if (!_formKey.currentState!.validate()) return;
            Navigator.pop(context, {
              'name': _name.text.trim(),
              'country': _country,
              'program': _program.text.trim(),
              'level': _level.text.trim(),
              'intake': _intake.text.trim(),
              'admissionOpen': _open,
            });
          },
          child: const Text('Save'),
        ),
      ],
    );
  }
}
