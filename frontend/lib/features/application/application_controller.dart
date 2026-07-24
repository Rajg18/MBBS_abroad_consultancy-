import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/colleges_data.dart';
import 'picked_doc.dart';

/// The in-progress application, shared across every step of the flow.
///
/// Preferences are stored as ordered lists — index 0 is the 1st priority,
/// index 1 the 2nd, and so on.
class ApplicationDraft {
  final List<String> countries; // ordered by priority, max 3
  final List<String> collegeIds; // ordered by priority (no cap)

  // Personal details (committed on the Details step)
  final String fullName;
  final String phone;
  final String email;
  final String neetScore;

  // Documents
  final PickedDoc? tenthMarksheet;
  final PickedDoc? twelfthMarksheet;
  final PickedDoc? passport;
  final PickedDoc? aadhaar;

  final bool consent;

  const ApplicationDraft({
    this.countries = const [],
    this.collegeIds = const [],
    this.fullName = '',
    this.phone = '',
    this.email = '',
    this.neetScore = '',
    this.tenthMarksheet,
    this.twelfthMarksheet,
    this.passport,
    this.aadhaar,
    this.consent = false,
  });

  ApplicationDraft copyWith({
    List<String>? countries,
    List<String>? collegeIds,
    String? fullName,
    String? phone,
    String? email,
    String? neetScore,
    PickedDoc? tenthMarksheet,
    PickedDoc? twelfthMarksheet,
    PickedDoc? passport,
    PickedDoc? aadhaar,
    bool? consent,
  }) {
    return ApplicationDraft(
      countries: countries ?? this.countries,
      collegeIds: collegeIds ?? this.collegeIds,
      fullName: fullName ?? this.fullName,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      neetScore: neetScore ?? this.neetScore,
      tenthMarksheet: tenthMarksheet ?? this.tenthMarksheet,
      twelfthMarksheet: twelfthMarksheet ?? this.twelfthMarksheet,
      passport: passport ?? this.passport,
      aadhaar: aadhaar ?? this.aadhaar,
      consent: consent ?? this.consent,
    );
  }
}

class ApplicationController extends Notifier<ApplicationDraft> {
  static const int maxCountries = 3;

  @override
  ApplicationDraft build() => const ApplicationDraft();

  /// Toggle a country in/out of the preference list (max 3, order preserved).
  void toggleCountry(String name) {
    final list = [...state.countries];
    if (list.contains(name)) {
      list.remove(name);
      // Drop any chosen colleges that belonged to the removed country.
      final validIds = _collegeIdsWithin(list);
      state = state.copyWith(
        countries: list,
        collegeIds:
            state.collegeIds.where(validIds.contains).toList(growable: false),
      );
    } else {
      if (list.length >= maxCountries) return;
      list.add(name);
      state = state.copyWith(countries: list);
    }
  }

  /// 1-based priority of a country, or 0 if not selected.
  int priorityOf(String name) => state.countries.indexOf(name) + 1;

  bool get canProceed => state.countries.isNotEmpty;

  /// Toggle a college in/out of the preference list (no cap, order preserved).
  void toggleCollege(String id) {
    final list = [...state.collegeIds];
    if (list.contains(id)) {
      list.remove(id);
    } else {
      list.add(id);
    }
    state = state.copyWith(collegeIds: list);
  }

  /// 1-based priority of a college, or 0 if not selected.
  int collegePriorityOf(String id) => state.collegeIds.indexOf(id) + 1;

  bool get canProceedColleges => state.collegeIds.isNotEmpty;

  /// Commit the details-step data into the shared draft.
  void saveDetails({
    required String fullName,
    required String phone,
    required String email,
    required String neetScore,
    required PickedDoc tenthMarksheet,
    required PickedDoc twelfthMarksheet,
    required PickedDoc passport,
    required PickedDoc aadhaar,
    required bool consent,
  }) {
    state = state.copyWith(
      fullName: fullName,
      phone: phone,
      email: email,
      neetScore: neetScore,
      tenthMarksheet: tenthMarksheet,
      twelfthMarksheet: twelfthMarksheet,
      passport: passport,
      aadhaar: aadhaar,
      consent: consent,
    );
  }

  /// Clear the whole draft (used after a successful submission).
  void reset() => state = const ApplicationDraft();

  Set<String> _collegeIdsWithin(List<String> countries) {
    return CollegeCatalog.colleges
        .where((c) => countries.contains(c.country))
        .map((c) => c.id)
        .toSet();
  }
}

final applicationProvider =
    NotifierProvider<ApplicationController, ApplicationDraft>(
        ApplicationController.new);
