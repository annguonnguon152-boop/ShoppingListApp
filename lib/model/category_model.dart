class CategoryModel {
  int? id;
  String name;
  String icon;

  CategoryModel({this.id, required this.name, required this.icon});

  // convert dart to map
  Map<String, dynamic> toMap() {
    return {"id": id, "name": name, "icon": icon};
  }

  // convert map to dart
  factory CategoryModel.fromMap(Map<String, dynamic> map) {
    return CategoryModel(id: map['id'], name: map['name'], icon: map['icon']);
  }
}
