class Customer {
  final int id;
  final String name;
  final String email;
  final String phone;

  Customer({
    required this.id,
    required this.name,
    this.email = '',
    this.phone = '',
  });

  Map<String, dynamic> toMap() {
    return {'id': id, 'name': name, 'email': email, 'phone': phone};
  }

  factory Customer.fromMap(Map<String, dynamic> map) {
    return Customer(
      id: map['id'],
      name: map['name'],
      email: map['email'],
      phone: map['phone'],
    );
  }
}
