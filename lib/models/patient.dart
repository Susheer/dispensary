// patient_model.dart
enum Gender {
  Male,
  Female,
  Other,
}

class Patient {
  late int id;
  late String name;
  late String mobileNumber;
  late Gender gender;
  late String address;
  late List<String> allergies;

  late String? guardianName;
  late String? guardianMobileNumber;
  late Gender? guardianGender;
  late String? guardianAddress;
  late GuardianRelation? relation;
  late DateTime createdDate;
  late DateTime updatedDate;
  DateTime? scheduledDate;

  Patient({
    required this.id,
    required this.name,
    required this.mobileNumber,
    required this.gender,
    required this.address,
    required this.allergies,
    this.guardianName,
    this.guardianMobileNumber,
    this.guardianGender,
    this.guardianAddress,
    this.relation,
    this.scheduledDate,
    required this.createdDate,
    required this.updatedDate,
  });

  factory Patient.fromMap(Map<String, dynamic> map) {
    String? guardianRelation = map['guardianRelation']?.toString();
    String? guardianGender = map['guardianGender']?.toString();
    GuardianRelation? rel;
    Gender? gen;

    if (guardianRelation != null && guardianRelation.trim().isNotEmpty) {
      rel = parseRelation(guardianRelation);
    }
    if (guardianGender != null && guardianGender.trim().isNotEmpty) {
      gen = parseGender(guardianGender);
    }
    DateTime? sDate;
    if (map['scheduled_date'] == "" || map['scheduled_date'] == null) {
      sDate = null;
    } else {
      sDate = DateTime.parse(map['scheduled_date']);
    }
    return Patient(
      id: map['id'],
      name: map['name'],
      mobileNumber: map['mobileNumber'],
      gender: parseGender(map['gender']),
      address: map['address'],
      allergies: map['allergies']?.split(',').toList() ?? [],
      guardianName: map['guardianName'],
      guardianMobileNumber: map['guardianMobileNumber'],
      guardianGender: gen,
      guardianAddress: map['guardianAddress'],
      relation: rel,
      createdDate: DateTime.parse(map['created_date']),
      updatedDate: DateTime.parse(map['updated_date']),
      scheduledDate: sDate,
    );
  }

  static Gender parseGender(String gender) {
    switch (gender.toLowerCase()) {
      case 'male':
        return Gender.Male;
      case 'female':
        return Gender.Female;
      case 'other':
        return Gender.Other;
      default:
        return Gender.Other;
    }
  }

  static String parseGenderToString(Gender gender) {
    switch (gender) {
      case Gender.Male:
        return 'male';
      case Gender.Female:
        return 'female';
      case Gender.Other:
        return 'other';
      default:
        return 'other';
    }
  }

  static GuardianRelation parseRelation(String relation) {
    switch (relation.toLowerCase()) {
      case 'parent':
        return GuardianRelation.Parent;
      case 'spouse':
        return GuardianRelation.Spouse;
      case 'sibling':
        return GuardianRelation.Sibling;
      case 'other':
        return GuardianRelation.Other;
      default:
        throw ArgumentError('Invalid relation: $relation');
    }
  }

  static String parseRelationToString(GuardianRelation relation) {
    switch (relation) {
      case GuardianRelation.Parent:
        return 'parent';
      case GuardianRelation.Spouse:
        return 'spouse';
      case GuardianRelation.Sibling:
        return 'sibling';
      case GuardianRelation.Other:
        return 'other';
      default:
        return 'other';
    }
  }
}

enum GuardianRelation {
  Parent,
  Spouse,
  Sibling,
  Other,
}
