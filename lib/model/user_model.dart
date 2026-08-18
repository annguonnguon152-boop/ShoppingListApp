class UserModel {
  final int id;
  final String name;
  final String email;
  final String phone;
  final String preference;
  final String storeLocation;
  final String image;

  const UserModel({
    this.id = 1,
    this.name = 'Local Shopper',
    this.email = '',
    this.phone = '',
    this.preference = '',
    this.storeLocation = '',
    this.image = 'Assets/image.png',
  });

  UserModel copyWith({
    int? id,
    String? name,
    String? email,
    String? phone,
    String? preference,
    String? storeLocation,
    String? image,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      preference: preference ?? this.preference,
      storeLocation: storeLocation ?? this.storeLocation,
      image: image ?? this.image,
    );
  }

  // convert dart to map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'preference': preference,
      'store_location': storeLocation,
      'image': image,
    };
  }

  // convert map to dart
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] ?? 1,
      name: map['name'] ?? 'Local Shopper',
      email: map['email'] ?? '',
      phone: map['phone'] ?? '',
      preference: map['preference'] ?? '',
      storeLocation: map['store_location'] ?? '',
      image: map['image'] ?? 'Assets/image.png',
    );
  }
}
