class DescriptionModel {
  final int? id;
  final String description;
  final int categoryId;

  DescriptionModel({
    this.id,
    required this.description,
    required this.categoryId,
  });

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "description": description,
      "categoryId": categoryId,
    };
  }

  factory DescriptionModel.fromJson(Map<String, dynamic> json) =>
      DescriptionModel(
        id: json["id"] as int,
        description: json["description"] as String,
        categoryId: json["categoryId"] as int,
      );
}
