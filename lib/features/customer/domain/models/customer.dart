class Customer {
  final int? id;
  final String name;
  final String gender;
  final int age;
  final String address;
  final String color;

  Customer({
    this.id,
    required this.name,
    required this.gender,
    required this.age,
    required this.address,
    required this.color,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'gender': gender,
      'age': age,
      'address': address,
      'color': color,
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
    );
  }
}
