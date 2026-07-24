import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../colleges_data.dart';
import '../models/college.dart';
import 'api_config.dart';

/// Fetches the country + college catalogue from the backend and caches it.
class CatalogRepository {
  final Dio _dio;
  CatalogRepository(this._dio);

  Future<void> load() async {
    final responses = await Future.wait([
      _dio.get('/countries'),
      _dio.get('/colleges'),
    ]);

    final countries = (responses[0].data as List)
        .map((e) => Country.fromJson(e as Map<String, dynamic>))
        .toList();
    final colleges = (responses[1].data as List)
        .map((e) => College.fromJson(e as Map<String, dynamic>))
        .toList();

    CollegeCatalog.populate(countries: countries, colleges: colleges);
  }
}

final catalogRepositoryProvider =
    Provider<CatalogRepository>((ref) => CatalogRepository(ref.watch(dioProvider)));

/// Loads the catalogue once. Screens watch this to show loading/error/data.
final catalogProvider = FutureProvider<void>((ref) async {
  await ref.watch(catalogRepositoryProvider).load();
});
