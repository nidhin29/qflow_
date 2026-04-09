import 'dart:convert';

class MemberModel {
  final String? id;
  final String name;
  final int age;
  final String gender;
  final String bloodGroup;
  final String relation;
  final double? weight;
  final double? height;

  const MemberModel({
    this.id,
    required this.name,
    required this.age,
    required this.gender,
    required this.bloodGroup,
    required this.relation,
    this.weight,
    this.height,
  });

  @override
  String toString() {
    return 'MemberModel(id: $id, name: $name, age: $age, gender: $gender, relation: $relation, weight: $weight, height: $height)';
  }

  factory MemberModel.fromMap(Map<String, dynamic> data) {
    String fullName = (data['name'] ?? 
                      data['fullName'] ?? 
                      data['first_name'] ?? 
                      data['firstName'] ?? 
                      '').toString();
    
    if (data['last_name'] != null || data['lastName'] != null) {
       final last = (data['last_name'] ?? data['lastName']).toString();
       if (last.isNotEmpty && !fullName.contains(last)) {
         fullName = '$fullName $last'.trim();
       }
    }

    return MemberModel(
      id: data['id']?.toString() ?? data['_id']?.toString(),
      name: fullName,
      age: data['age'] ?? 0,
      gender: (data['gender'] ?? '').toString(),
      bloodGroup: (data['blood_group'] ?? data['bloodGroup'] ?? '').toString(),
      relation: (data['relation'] ?? '').toString(),
      weight: data['weight'] != null ? double.tryParse(data['weight'].toString()) : null,
      height: data['height'] != null ? double.tryParse(data['height'].toString()) : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'name': name,
      'age': age,
      'gender': gender,
      'blood_group': bloodGroup,
      'relation': relation,
      if (weight != null) 'weight': weight,
      if (height != null) 'height': height,
    };
  }

  String toJson() => json.encode(toMap());

  factory MemberModel.fromJson(String source) =>
      MemberModel.fromMap(json.decode(source) as Map<String, dynamic>);

  MemberModel copyWith({
    String? id,
    String? name,
    int? age,
    String? gender,
    String? bloodGroup,
    String? relation,
    double? weight,
    double? height,
  }) {
    return MemberModel(
      id: id ?? this.id,
      name: name ?? this.name,
      age: age ?? this.age,
      gender: gender ?? this.gender,
      bloodGroup: bloodGroup ?? this.bloodGroup,
      relation: relation ?? this.relation,
      weight: weight ?? this.weight,
      height: height ?? this.height,
    );
  }
}
