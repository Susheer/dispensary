// medicine_model.dart
class Medicine {
  final int sysMedicineId;
  final String name;
  final String description;
  final DateTime createdDate;
  final DateTime updatedDate;

  Medicine({
    required this.sysMedicineId,
    required this.name,
    required this.description,
    required this.createdDate,
    required this.updatedDate,
  });

  Map<String, dynamic> toMap() {
    return {
      'sys_medicine_id': sysMedicineId,
      'name': name,
      'description': description,
      'created_date': createdDate.toIso8601String(),
      'updated_date': updatedDate.toIso8601String(),
    };
  }

  Map<String, dynamic> toMapWithoutId() {
    return {
      'name': name,
      'description': description,
      'created_date': createdDate.toIso8601String(),
      'updated_date': updatedDate.toIso8601String(),
    };
  }

  factory Medicine.fromMap(Map<String, dynamic> map) {
    return Medicine(
      sysMedicineId: map['sys_medicine_id'],
      name: map['name'],
      description: map['description'],
      createdDate: DateTime.parse(map['created_date']),
      updatedDate: DateTime.parse(map['updated_date']),
    );
  }
}
