class Customer {
  final int? id;
  final String name;
  final String gender;
  final int age;
  final String address;
  final String color;
  final DateTime? createTime;
  final String? school;
  final DateTime? birthday;
  final String? email;
  final String? phone;

  Customer({
    this.id,
    required this.name,
    required this.gender,
    required this.age,
    required this.address,
    required this.color,
    this.createTime,
    this.school,
    this.birthday,
    this.email,
    this.phone,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'gender': gender,
      'age': age,
      'address': address,
      'color': color,
      'createTime': createTime?.toIso8601String(),
      'school': school,
      'birthday': birthday?.toIso8601String(),
      'email': email,
      'phone': phone,
    };
  }

  factory Customer.fromMap(Map<String, dynamic> map) {
    return Customer(
      id: map['id'] as int,
      name: map['name'] as String,
      gender: map['gender'] as String,
      age: map['age'] as int,
      address: map['address'] as String,
      color: map['color'] as String,
      createTime: map['createTime'] != null 
          ? DateTime.parse(map['createTime'] as String)
          : null,
      school: map['school'] as String?,
      birthday: map['birthday'] != null 
          ? DateTime.parse(map['birthday'] as String)
          : null,
      email: map['email'] as String?,
      phone: map['phone'] as String?,
    );
  }
}
