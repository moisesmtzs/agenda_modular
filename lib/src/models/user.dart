import 'dart:convert';

User userFromJson(String str) => User.fromJson(json.decode(str));

String userToJson(User data) => json.encode(data.toJson());

class User {

    String? id;
    String? name;
    String? lastname;
    String? phone;
    String? email;
    String? password;
    String? image;
    
    User({
        this.id,
        this.name,
        this.lastname,
        this.phone,
        this.email,
        this.password,
        this.image,
    });


    factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"],
        name: json["name"],
        lastname: json["lastname"],
        phone: json["phone"],
        email: json["email"],
        password: json["password"],
        image: json["image"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "lastname": lastname,
        "phone": phone,
        "email": email,
        "password": password,
        "image": image,
    };
}
