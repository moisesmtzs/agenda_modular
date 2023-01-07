import 'dart:convert';

Subject subjectFromJson(String str) => Subject.fromJson(json.decode(str));

String subjectToJson(Subject data) => json.encode(data.toJson());

class Subject {
  String? id;
  String? id_user;
  String? name;
  String? subject_code;
  String? professor_name;

  Subject({
    this.id,
    this.id_user,
    this.name,
    this.subject_code,
    this.professor_name,
  });

  factory Subject.fromJson(Map<String, dynamic> json) => Subject(
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
