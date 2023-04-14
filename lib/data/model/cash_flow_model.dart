class CashFlowModel {
  final int? id;
  final String type;
  final String category;
  final String description;
  final double value;
  final String typeOfPayment;
  final String? observation;
  final String status;
  final DateTime dueDate;
  final DateTime? settledIn;
  final DateTime? createIn;

  const CashFlowModel({
    this.id,
    required this.type,
    required this.category,
    required this.description,
    required this.value,
    required this.typeOfPayment,
    this.observation,
    required this.status,
    required this.dueDate,
    this.settledIn,
    this.createIn,
  });

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "type": type,
      "category": category,
      "description": description,
      "value": value,
      "typeOfPayment": typeOfPayment,
      "observation": observation,
      "status": status,
      "dueDate": dueDate.toIso8601String(),
      "settledIn": settledIn?.toIso8601String(),
      "createIn": createIn?.toIso8601String(),
    };
  }

  factory CashFlowModel.fromJson(Map<String, dynamic> json) => CashFlowModel(
        id: json["id"] as int,
        type: json["type"] as String,
        category: json["category"] as String,
        description: json["description"] as String,
        value: json["value"] as double,
        typeOfPayment: json["typeOfPayment"] as String,
        observation: json["observation"] as String,
        status: json["status"] as String,
        dueDate: DateTime.parse(json["dueDate"] as String),
        settledIn: json["settledIn"] != null
            ? DateTime.parse(json["settledIn"] as String)
            : null,
        createIn: DateTime.parse(json["createIn"] as String),
      );
}
