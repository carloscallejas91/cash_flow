class CategoryModel {
  final int? id;
  final String category;
  final String type;

  CategoryModel({
    this.id,
    required this.category,
    required this.type,
  });

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "category": category,
      "type": type,
    };
  }

  factory CategoryModel.fromJson(Map<String, dynamic> json) => CategoryModel(
        id: json["id"] as int,
        category: json["category"] as String,
        type: json["type"] as String,
      );
}
