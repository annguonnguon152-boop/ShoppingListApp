class TagModel {
  String name;
  String iconKey;

  TagModel({required this.name, required this.iconKey});

  // dart to map
  Map<String, dynamic> toMap() {
    return {'name': name, 'iconKey': iconKey};
  }

  // map to dart
  factory TagModel.fromMap(Map<String, dynamic> map) {
    return TagModel(
      name: map['name'] ?? '',
      iconKey: map['iconKey']?.toString() ?? 'other',
    );
  }
}
