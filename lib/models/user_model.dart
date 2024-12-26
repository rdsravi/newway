class UserModel {
  String? uid;
  String? email;
  String? name;
  String? mobileNumber;
  String? gender;
  bool? notificationsEnabled;
  String? profilePictureUrl;
  // Add any new fields here, e.g., address, dob, etc.
  String? address;
  String? dob; // Date of Birth

  UserModel({
    this.uid,
    this.email,
    this.name,
    this.mobileNumber,
    this.gender,
    this.notificationsEnabled,
    this.profilePictureUrl,
    this.address,
    this.dob,
  });

  factory UserModel.fromFirestore(Map<String, dynamic> data) {
    return UserModel(
      uid: data['uid'],
      email: data['email'],
      name: data['name'],
      mobileNumber: data['mobileNumber'],
      gender: data['gender'],
      notificationsEnabled: data['notificationsEnabled'] ?? true,
      profilePictureUrl: data['profilePictureUrl'] ?? '',
      address: data['address'] ?? '',
      dob: data['dob'] ?? '',
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'uid': uid,
      'email': email,
      'name': name,
      'mobileNumber': mobileNumber,
      'gender': gender,
      'notificationsEnabled': notificationsEnabled,
      'profilePictureUrl': profilePictureUrl,
      'address': address,
      'dob': dob,
    };
  }
}
