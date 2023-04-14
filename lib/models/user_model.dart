
class UserModel {
  String? name;
  String? phone;
  String? email;
  String? uId;
  String? image;
  String? cover;
  String? bio;
  bool? isEmailVerified;
  UserModel({
     this.name,
     this.phone,
     this.email,
     this.uId,
     this.image,
     this.cover,
     this.bio,
     this.isEmailVerified,
  });

  UserModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    phone = json['phone'];
    email = json['email'];
    uId = json['uId'];
    image = json['image'];
    cover = json['cover'];
    bio = json['bio'];
    isEmailVerified = json['isEmailVerified'];

  }

  Map<String, dynamic>? toMap() {
    return {
      'name': name,
      'email': email,
      'phone': phone,
      'uId': uId,
      'bio': bio,
      'image': image,
      'cover': cover,
      'isEmailVerified': isEmailVerified,

    };
  }
}
