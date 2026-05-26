class Algorithm {
  const Algorithm({
    required this.id,
    required this.name,
    required this.category,
    required this.cleanAlgorithm,
    required this.groupedAlgorithm,
    this.fullNameEn,
    this.fullNameEs,
    this.descriptionEn,
    this.descriptionEs,
    this.recognitionEn,
    this.recognitionEs,
    this.imageUrl,
  });

  final String id;
  final String name;
  final String category;
  final String cleanAlgorithm;
  final String groupedAlgorithm;
  final String? fullNameEn;
  final String? fullNameEs;
  final String? descriptionEn;
  final String? descriptionEs;
  final String? recognitionEn;
  final String? recognitionEs;
  final String? imageUrl;

  factory Algorithm.fromJson(Map<String, dynamic> json) {
    final algorithmJson = json['algorithm'];
    final algorithm = algorithmJson is Map<String, dynamic>
        ? algorithmJson
        : const <String, dynamic>{};

    return Algorithm(
      id: _stringValue(json['id'], fallback: ''),
      name: _stringValue(json['name'], fallback: 'Unknown case'),
      category: _stringValue(
        json['category'] ?? json['type'],
        fallback: 'PLL',
      ),
      fullNameEn: _nullableString(json['full_name_en']),
      fullNameEs: _nullableString(json['full_name_es']),
      descriptionEn: _nullableString(
        json['description_en'] ?? json['description'],
      ),
      descriptionEs: _nullableString(json['description_es']),
      recognitionEn: _nullableString(json['recognition_en']),
      recognitionEs: _nullableString(json['recognition_es']),
      cleanAlgorithm: _stringValue(
        algorithm['clean'] ?? json['clean_algorithm'] ?? json['algorithm'],
        fallback: 'Algorithm unavailable',
      ),
      groupedAlgorithm: _stringValue(
        algorithm['grouped'] ?? json['grouped_algorithm'],
        fallback: _stringValue(
          algorithm['clean'] ?? json['clean_algorithm'] ?? json['algorithm'],
          fallback: 'Algorithm unavailable',
        ),
      ),
      imageUrl: _nullableString(json['image_url']),
    );
  }

  static String _stringValue(Object? value, {required String fallback}) {
    if (value == null) {
      return fallback;
    }
    final text = value.toString().trim();
    return text.isEmpty ? fallback : text;
  }

  static String? _nullableString(Object? value) {
    if (value == null) {
      return null;
    }
    final text = value.toString().trim();
    return text.isEmpty ? null : text;
  }
}
