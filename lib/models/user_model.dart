class UserModel {
  final String uid;
  final bool isOnline;
  final String phoneNumber;
  final String name;
  final String profilePic;

  UserModel(
      {required this.uid,
      required this.isOnline,
      required this.phoneNumber,
      required this.name,
      required this.profilePic});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
        uid: json['uid'] ?? '',
        isOnline: json['isOnline'] ?? '',
        phoneNumber: json['phoneNumber'] ?? '',
        name: json['name'] ?? '',
        profilePic: json['profilePic'] ?? '');
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =  <String, dynamic>{};
    data['uid'] = uid;
    data['isOnline'] = isOnline;
    data['phoneNumber'] = phoneNumber;
    data['name'] = name;
    data['profilePic'] = profilePic;
    return data;
  }
}
