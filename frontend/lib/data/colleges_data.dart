import 'models/college.dart';

/// In-memory cache of the catalogue, populated from the backend API at runtime.
///
/// The database (via the API) is the single source of truth. This class just
/// holds the loaded data so the selection/review screens can read it
/// synchronously after it has been fetched once.
class CollegeCatalog {
  CollegeCatalog._();

  static List<Country> countries = const [];
  static List<College> colleges = const [];

  /// Replace the cached catalogue with freshly-fetched data.
  static void populate({
    required List<Country> countries,
    required List<College> colleges,
  }) {
    CollegeCatalog.countries = countries;
    CollegeCatalog.colleges = colleges;
  }

  static bool get isLoaded => colleges.isNotEmpty;

  /// Colleges belonging to a given country, in catalogue order.
  static List<College> byCountry(String country) =>
      colleges.where((c) => c.country == country).toList();

  /// A single college by id, or null if not found.
  static College? byId(String id) {
    for (final c in colleges) {
      if (c.id == id) return c;
    }
    return null;
  }

  static int get total => colleges.length;
}
