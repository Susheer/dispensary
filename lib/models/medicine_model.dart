// medicine_model.dart
class Medicine {
  int sysMedicineId;
  String name;
  String description;
  DateTime createdDate;
  DateTime updatedDate;

  Medicine({
    required this.sysMedicineId,
    required this.name,
    required this.description,
    required this.createdDate,
    required this.updatedDate,
  });

  // CopyWith method to create a new instance with modified values
  Medicine copyWith({
    int? sysMedicineId,
    String? name,
    String? description,
    DateTime? createdDate,
    DateTime? updatedDate,
  }) {
    return Medicine(
      sysMedicineId: sysMedicineId ?? this.sysMedicineId,
      name: name ?? this.name,
      description: description ?? this.description,
      createdDate: createdDate ?? this.createdDate,
      updatedDate: updatedDate ?? this.updatedDate,
    );
  }

  // Setter for sysMedicineId
  set setSysMedicineId(int newSysMedicineId) {
    sysMedicineId = newSysMedicineId;
  }

  // Setter for name
  set setName(String newName) {
    name = newName;
  }

  // Setter for description
  set setDescription(String newDescription) {
    description = newDescription;
  }

  // Setter for createdDate
  set setCreatedDate(DateTime newCreatedDate) {
    createdDate = newCreatedDate;
  }

  // Setter for updatedDate
  set setUpdatedDate(DateTime newUpdatedDate) {
    updatedDate = newUpdatedDate;
  }

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
