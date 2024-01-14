class Medicine {
  late int id;
  late String name;
  late String dosage;
  late String strength;
  String? description; // Made description field optional
  double? price;

  Medicine({
    required this.id,
    required this.name,
    required this.dosage,
    required this.strength,
    this.description,
    this.price,
  });

  // Factory method to create a Medicine instance from a map
  factory Medicine.fromMap(Map<String, dynamic> map) {
    return Medicine(
      id: map['id'],
      name: map['name'],
      dosage: map['dosage'],
      strength: map['strength'],
      description: map['description'],
      price: map['price']?.toDouble(),
    );
  }

  // Convert the Medicine instance to a map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'dosage': dosage,
      'strength': strength,
      'description': description,
      'price': price,
    };
  }
}
