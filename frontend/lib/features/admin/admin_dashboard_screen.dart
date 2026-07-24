import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../core/theme/app_colors.dart';
import '../../data/api/admin_api.dart';
import '../../data/api/api_config.dart';
import '../../data/models/admin_application.dart';
import '../../shared/download/download_helper.dart';
import '../../shared/widgets/app_logo.dart';

/// Admin dashboard — lists every applicant with document downloads.
class AdminDashboardScreen extends ConsumerStatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  ConsumerState<AdminDashboardScreen> createState() =>
      _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends ConsumerState<AdminDashboardScreen> {
  Future<List<AdminApplication>>? _future;

  @override
  void initState() {
    super.initState();
    _load();
  }

  void _load() {
    final token = ref.read(adminTokenProvider);
    if (token == null) return;
    setState(() {
      _future = ref.read(adminApiProvider).fetchApplications(token);
    });
  }

  void _logout() {
    ref.read(adminTokenProvider.notifier).clear();
    context.go('/admin/login');
  }

  Future<void> _download(AdminApplication app, AdminDocument doc) async {
    final token = ref.read(adminTokenProvider);
    if (token == null) return;
    try {
      final bytes = await ref
          .read(adminApiProvider)
          .downloadDocument(token, app.id, doc.docType);
      downloadBytes(bytes, doc.fileName);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(apiErrorMessage(e)),
            backgroundColor: AppColors.error),
      );
    }
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
            onPressed: () => context.go('/admin/colleges'),
            icon: const Icon(Icons.school_outlined, size: 18),
            label: const Text('Colleges'),
          ),
          IconButton(
            tooltip: 'Refresh',
            onPressed: _load,
            icon: const Icon(Icons.refresh_rounded),
          ),
          TextButton.icon(
            onPressed: _logout,
            icon: const Icon(Icons.logout_rounded, size: 18),
            label: const Text('Log out'),
          ),
          const SizedBox(width: 12),
        ],
      ),
      body: FutureBuilder<List<AdminApplication>>(
        future: _future,
        builder: (context, snap) {
          if (snap.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snap.hasError) {
            return _ErrorState(
                message: apiErrorMessage(snap.error!), onRetry: _load);
          }
          final apps = snap.data ?? const [];
          if (apps.isEmpty) return const _EmptyState();

          return SingleChildScrollView(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 900),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20, vertical: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Applications',
                          style: const TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.w800,
                              color: AppColors.textPrimary)),
                      const SizedBox(height: 4),
                      Text('${apps.length} total · newest first',
                          style: const TextStyle(
                              fontSize: 14, color: AppColors.textSecondary)),
                      const SizedBox(height: 20),
                      for (final app in apps)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: _ApplicantCard(
                            app: app,
                            onDownload: (doc) => _download(app, doc),
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

class _ApplicantCard extends StatelessWidget {
  final AdminApplication app;
  final void Function(AdminDocument) onDownload;

  const _ApplicantCard({required this.app, required this.onDownload});

  String _formatDate(String iso) {
    try {
      return DateFormat('dd MMM yyyy, hh:mm a')
          .format(DateTime.parse(iso).toLocal());
    } catch (_) {
      return iso;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
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
              Expanded(
                child: Text(app.fullName,
                    style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary)),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.primaryLight,
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(app.status,
                    style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primary)),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(_formatDate(app.createdAt),
              style: const TextStyle(
                  fontSize: 12.5, color: AppColors.textMuted)),
          const SizedBox(height: 14),
          Wrap(
            spacing: 24,
            runSpacing: 8,
            children: [
              _info(Icons.phone_outlined, app.phone),
              _info(Icons.mail_outline_rounded, app.email),
              _info(Icons.grade_outlined, 'NEET ${app.neetScore}'),
            ],
          ),
          const SizedBox(height: 14),
          _ranked('Preferred countries', app.countries),
          const SizedBox(height: 8),
          _ranked('Preferred colleges', app.colleges),
          const Divider(height: 28),
          const Text('Documents',
              style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textSecondary)),
          const SizedBox(height: 10),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              for (final doc in app.documents)
                OutlinedButton.icon(
                  onPressed: () => onDownload(doc),
                  icon: const Icon(Icons.download_rounded, size: 18),
                  label: Text('${doc.label}  ·  ${doc.readableSize}'),
                ),
              if (app.documents.isEmpty)
                const Text('No documents',
                    style: TextStyle(color: AppColors.textMuted)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _info(IconData icon, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: AppColors.textMuted),
        const SizedBox(width: 6),
        Text(text,
            style: const TextStyle(
                fontSize: 13.5, color: AppColors.textPrimary)),
      ],
    );
  }

  Widget _ranked(String label, List<String> items) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 150,
          child: Text('$label:',
              style: const TextStyle(
                  fontSize: 13, color: AppColors.textSecondary)),
        ),
        Expanded(
          child: Text(
            items.isEmpty
                ? '—'
                : [
                    for (var i = 0; i < items.length; i++)
                      '${i + 1}. ${items[i]}'
                  ].join('   '),
            style: const TextStyle(
                fontSize: 13.5,
                fontWeight: FontWeight.w500,
                color: AppColors.textPrimary),
          ),
        ),
      ],
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.inbox_outlined, size: 48, color: AppColors.textMuted),
          SizedBox(height: 16),
          Text('No applications yet',
              style: TextStyle(fontSize: 16, color: AppColors.textSecondary)),
        ],
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;
  const _ErrorState({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.cloud_off_rounded,
              size: 48, color: AppColors.textMuted),
          const SizedBox(height: 16),
          Text(message,
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
    );
  }
}
