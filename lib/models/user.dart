class UserModel {
  final String uid;

  UserModel({required this.uid});
}

class UserInformation{
  String uid;
  String avatar;
  String email;
  String name;
  String bio;

  UserInformation({required this.uid, required this.avatar, required this.name, required this.email, required this.bio});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is UserInformation &&
              runtimeType == other.runtimeType &&
              uid == other.uid &&
              avatar == other.avatar &&
              email == other.email &&
              name == other.name &&
              bio == other.bio;

  @override
  int get hashCode => uid.hashCode;

  factory UserInformation.fromJson(Map<String, dynamic> json){
    return UserInformation(
        uid: json['uid'] ?? "",
        avatar: json["avatar"] ?? "",
        email: json["email"] ?? "",
        name: json["name"] ?? "",
        bio: json['bio'] ?? ""
    );
  }

  Map<String, dynamic> toJson(){
    return {
      'uid': uid,
      'avatar': avatar,
      'email': email,
      'name': name,
      'bio': bio,
  };


}
}