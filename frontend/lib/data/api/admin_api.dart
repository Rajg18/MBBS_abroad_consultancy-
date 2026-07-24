import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/admin_application.dart';
import '../models/college.dart';
import 'api_config.dart';

/// Talks to the protected /api/admin/** endpoints.
class AdminApi {
  final Dio _dio;
  AdminApi(this._dio);

  /// Logs in; returns the session JWT on success (throws on failure).
  Future<String> login(String username, String password) async {
    final res = await _dio.post('/admin/login', data: {
      'username': username,
      'password': password,
    });
    return (res.data as Map)['token'] as String;
  }

  Future<List<AdminApplication>> fetchApplications(String token) async {
    final res = await _dio.get(
      '/admin/applications',
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );
    return (res.data as List)
        .map((e) => AdminApplication.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  /// Downloads one document's bytes (for triggering a browser save).
  Future<Uint8List> downloadDocument(
      String token, String applicationId, String docType) async {
    final res = await _dio.get<List<int>>(
      '/admin/applications/$applicationId/documents/$docType',
      options: Options(
        responseType: ResponseType.bytes,
        headers: {'Authorization': 'Bearer $token'},
      ),
    );
    return Uint8List.fromList(res.data ?? const []);
  }

  // ── College management ──────────────────────────────────────────────

  /// Every college (including closed ones) for the admin table.
  Future<List<College>> fetchColleges(String token) async {
    final res = await _dio.get(
      '/admin/colleges',
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );
    return (res.data as List)
        .map((e) => College.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<void> createCollege(String token, Map<String, dynamic> data) async {
    await _dio.post(
      '/admin/colleges',
      data: data,
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );
  }

  Future<void> updateCollege(
      String token, String id, Map<String, dynamic> data) async {
    await _dio.put(
      '/admin/colleges/$id',
      data: data,
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );
  }

  Future<void> deleteCollege(String token, String id) async {
    await _dio.delete(
      '/admin/colleges/$id',
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );
  }
}

final adminApiProvider =
    Provider<AdminApi>((ref) => AdminApi(ref.watch(dioProvider)));

/// Holds the current admin session token (in-memory; re-login per session).
class AdminTokenNotifier extends Notifier<String?> {
  @override
  String? build() => null;

  void set(String token) => state = token;
  void clear() => state = null;

  bool get isLoggedIn => state != null;
}

final adminTokenProvider =
    NotifierProvider<AdminTokenNotifier, String?>(AdminTokenNotifier.new);
