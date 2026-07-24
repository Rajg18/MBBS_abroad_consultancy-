import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/application/application_controller.dart';
import '../../features/application/picked_doc.dart';
import 'api_config.dart';

/// Submits a completed application to the backend as multipart/form-data.
class ApplicationApi {
  final Dio _dio;
  ApplicationApi(this._dio);

  /// Returns the created application's id on success; throws on failure.
  Future<String> submit(ApplicationDraft d) async {
    final form = FormData();

    form.fields
      ..add(MapEntry('fullName', d.fullName))
      ..add(MapEntry('phone', d.phone))
      ..add(MapEntry('email', d.email))
      ..add(MapEntry('neetScore', d.neetScore))
      ..add(MapEntry('consent', d.consent.toString()));

    // Repeated keys -> Spring binds these as List<String>.
    for (final c in d.countries) {
      form.fields.add(MapEntry('countries', c));
    }
    for (final id in d.collegeIds) {
      form.fields.add(MapEntry('collegeIds', id));
    }

    form.files
      ..add(MapEntry('tenthMarksheet', _part(d.tenthMarksheet!)))
      ..add(MapEntry('twelfthMarksheet', _part(d.twelfthMarksheet!)))
      ..add(MapEntry('passport', _part(d.passport!)))
      ..add(MapEntry('aadhaar', _part(d.aadhaar!)));

    final res = await _dio.post('/applications', data: form);
    return (res.data as Map)['id'] as String;
  }

  MultipartFile _part(PickedDoc doc) {
    final bytes = doc.bytes;
    if (bytes == null) {
      throw StateError('File contents missing for ${doc.fileName}');
    }
    return MultipartFile.fromBytes(bytes, filename: doc.fileName);
  }
}

final applicationApiProvider =
    Provider<ApplicationApi>((ref) => ApplicationApi(ref.watch(dioProvider)));
