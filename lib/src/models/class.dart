import 'dart:convert';

Class classFromJson(String str) => Class.fromJson(json.decode(str));

String classToJson(Class data) => json.encode(data.toJson());

class Class {
  String? id;
  String? id_user;
  String? name;
  String? subject_code;
  String? professor_name;

  Class({
    this.id,
    this.id_user,
    this.name,
    this.subject_code,
    this.professor_name,
  });

  factory Class.fromJson(Map<String, dynamic> json) => Class(
        id: json["id"],
        id_user: json["id_user"],
        name: json["name"],
        subject_code: json["subject_code"],
        professor_name: json["professor_name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "id_user": id_user,
        "name": name,
        "subject_code": subject_code,
        "professor_name": professor_name,
      };
}
