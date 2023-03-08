class UserDetails {
  String name;
  String? gender;
  String? phone;
  String email;
  String? dob;
  String? altPhone;
  String? lastActive;
  double? lat;
  double? long;

  UserDetails(
      {required this.name,
      required this.email,
      this.gender,
      this.phone,
      this.dob,
      this.altPhone,
      this.lastActive});

  static late UserDetails currentUser;
  static late List<UserDetails> nearbyUsers;

  factory UserDetails.fromMap(Map<String, dynamic> map) {
    return UserDetails(
        name: map['name'],
        email: map['email'],
        dob: map['dob'],
        phone: map['mobile'].toString(),
        gender: map['gender'],
        altPhone: map['alternatePhone'],
        lastActive: map['lastActive']);
  }
}
