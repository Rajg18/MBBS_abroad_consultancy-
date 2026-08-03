/// A single university / college offering that a student can choose.
class College {
  final String id;
  final String name;
  final String country;
  final String program; // e.g. General Medicine, Integrated American Program
  final String level; // Bachelor, Master
  final String intake; // e.g. Sep-26
  final bool admissionOpen;
  final String? description;
  final int? feesPerYearUsd;
  final int? durationYears;
  final List<String> highlights;

  const College({
    required this.id,
    required this.name,
    required this.country,
    this.program = 'General Medicine',
    this.level = 'Bachelor',
    this.intake = 'Sep-26',
    this.admissionOpen = true,
    this.description,
    this.feesPerYearUsd,
    this.durationYears,
    this.highlights = const [],
  });

  factory College.fromJson(Map<String, dynamic> json) {
    return College(
      id: json['id'] as String,
      name: json['name'] as String,
      country: json['country'] as String,
      program: (json['program'] ?? 'General Medicine') as String,
      level: (json['level'] ?? 'Bachelor') as String,
      intake: (json['intake'] ?? 'Sep-26') as String,
      admissionOpen: (json['admissionOpen'] ?? true) as bool,
      description: json['description'] as String?,
      feesPerYearUsd: json['feesPerYearUsd'] as int?,
      durationYears: json['durationYears'] as int?,
      highlights: (json['highlights'] as List?)?.cast<String>() ?? const [],
    );
  }
}

/// A country grouping, used for the first selection step.
class Country {
  final String name;
  final String flag; // emoji flag

  const Country({required this.name, required this.flag});

  factory Country.fromJson(Map<String, dynamic> json) {
    return Country(
      name: json['name'] as String,
      flag: (json['flag'] ?? '') as String,
    );
  }
}
