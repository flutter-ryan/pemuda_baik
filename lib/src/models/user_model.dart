UserModel userModelFromJson(dynamic str) => UserModel.fromJson(str);

class UserModel {
  UserModel({
    this.user,
    this.message,
  });

  User? user;
  String? message;

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        user: User.fromJson(json["data"]),
        message: json["message"],
      );
}

class User {
  User({
    this.id,
    this.name,
    this.email,
    this.role,
    this.pemudaSave,
  });

  int? id;
  String? name;
  String? email;
  int? role;
  PemudaSave? pemudaSave;

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"],
        name: json["name"],
        email: json["email"],
        role: json["role"],
        pemudaSave:
            json["pemuda"] == null ? null : PemudaSave.fromJson(json["pemuda"]),
      );
}

class PemudaSave {
  PemudaSave({
    this.id,
    this.nama,
    this.idUser,
  });

  int? id;
  String? nama;
  int? idUser;

  factory PemudaSave.fromJson(Map<String, dynamic> json) => PemudaSave(
        id: json["id"],
        nama: json["nama"],
        idUser: json["laravel_through_key"],
      );
}
