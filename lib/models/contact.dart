class Contact {
  // fields
  String id;
  String firstname;
  String lastname;
  String gender;
  String phone;
  String company;

  // constructor (paramenterized constructor)
  Contact({
    required this.id,
    required this.firstname,
    required this.lastname,
    required this.gender,
    required this.phone,
    required this.company,
  });

  Map<String, dynamic> toMap() {
    return {
      // key : value
      'firstname': firstname,
      'lastname': lastname,
      'gender': gender,
      'phone': phone,
      'company': company,
    };
  }

  factory Contact.fromMap(Map<String, dynamic> map, String id) {
    return Contact(
      id: id,
      firstname: map['firstname'] ?? '',
      lastname: map['lastname'] ?? '',
      gender: map['gender'] ?? '',
      phone: map['phone'] ?? '',
      company: map['company'] ?? '',
    );
  }
}
