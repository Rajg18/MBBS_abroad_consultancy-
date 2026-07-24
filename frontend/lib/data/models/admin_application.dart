/// A downloadable document belonging to an applicant (admin view).
class AdminDocument {
  final String docType; // TENTH_MARKSHEET, TWELFTH_MARKSHEET, PASSPORT, AADHAAR
  final String fileName;
  final int sizeBytes;

  const AdminDocument({
    required this.docType,
    required this.fileName,
    required this.sizeBytes,
  });

  factory AdminDocument.fromJson(Map<String, dynamic> json) {
    return AdminDocument(
      docType: json['docType'] as String,
      fileName: (json['fileName'] ?? '') as String,
      sizeBytes: (json['sizeBytes'] ?? 0) as int,
    );
  }

  /// Friendly label for the document type.
  String get label => switch (docType) {
        'TENTH_MARKSHEET' => '10th Marksheet',
        'TWELFTH_MARKSHEET' => '12th Marksheet',
        'PASSPORT' => 'Passport',
        'AADHAAR' => 'Aadhaar',
        _ => docType,
      };

  String get readableSize {
    if (sizeBytes < 1024) return '$sizeBytes B';
    if (sizeBytes < 1024 * 1024) return '${(sizeBytes / 1024).toStringAsFixed(0)} KB';
    return '${(sizeBytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }
}

/// One applicant row on the admin dashboard.
class AdminApplication {
  final String id;
  final String fullName;
  final String phone;
  final String email;
  final String neetScore;
  final String status;
  final String createdAt; // ISO-8601 string
  final List<String> countries; // priority order
  final List<String> colleges; // priority order, names
  final List<AdminDocument> documents;

  const AdminApplication({
    required this.id,
    required this.fullName,
    required this.phone,
    required this.email,
    required this.neetScore,
    required this.status,
    required this.createdAt,
    required this.countries,
    required this.colleges,
    required this.documents,
  });

  factory AdminApplication.fromJson(Map<String, dynamic> json) {
    return AdminApplication(
      id: json['id'] as String,
      fullName: (json['fullName'] ?? '') as String,
      phone: (json['phone'] ?? '') as String,
      email: (json['email'] ?? '') as String,
      neetScore: (json['neetScore'] ?? '') as String,
      status: (json['status'] ?? '') as String,
      createdAt: (json['createdAt'] ?? '') as String,
      countries: ((json['countries'] ?? []) as List).map((e) => e as String).toList(),
      colleges: ((json['colleges'] ?? []) as List).map((e) => e as String).toList(),
      documents: ((json['documents'] ?? []) as List)
          .map((e) => AdminDocument.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}
