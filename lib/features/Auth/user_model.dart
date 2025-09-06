
class UserModel {
  final String uid;
  final String email;
  final String name;
  final String? imageUrl;

  UserModel({
    required this.uid,
    required this.email,
    required this.name,
    this.imageUrl,
  });

  factory UserModel.formFirebaseUser(dynamic user) {
    return UserModel(
      uid: user.uid,
      email: user.email ?? "",
      name: user.displayName ?? '',
      imageUrl: user.imageUrl ?? "",
    );
  }


  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'displayName': name,
      'imageUrl': imageUrl,
    };
  }

  factory UserModel.frommap(Map<String,dynamic>userData){
    return UserModel(
      uid: userData["uid"], 
      email: userData["email"]??'', 
      name: userData['displayName']??'',
      imageUrl:userData['imageUrl']??"" );
  }
}
