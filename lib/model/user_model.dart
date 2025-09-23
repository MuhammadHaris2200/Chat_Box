class UserModel {
  final String uid;
  final String name;
  final String email;
  final String about;
  final String phone;
  final String profilePic;
  final String createdAt;

  UserModel({
    required this.uid,
    required this.name,
    required this.email,
    required this.about,
    required this.phone,
    required this.profilePic,
    required this.createdAt,
  });

  ///Firestore se data lene k liye
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map["uid"] ?? '',
      name: map["name"] ?? '',
      email: map["email"] ?? '',
      about: map["about"] ?? '',
      phone: map["phone"] ?? '',
      profilePic: map["profilePic"] ?? '',
      createdAt: map["createdAt"] ?? '',
    );
  }

  ///Firestore ma data bhejne k liye
  Map<String, dynamic> toMap() {
    return {
      "uid": uid,
      "name": name,
      "email": email,
      "about": about,
      "phone": phone,
      "profilePic": profilePic,
      "createdAt": createdAt,
    };
  }
}
