import 'dart:convert';

Classroom clasroomFromJson(String str) => Classroom.fromJson(json.decode(str));

String classroomToJson(Classroom data) => json.encode(data.toJson());

class Classroom {
  String? id;
  String? id_class;
  String? begin_hour;
  String? end_hour;
  String? days;
  String? classroom;
  String? building;

  Classroom({
    this.id,
    this.id_class,
    this.begin_hour,
    this.end_hour,
    this.days,
    this.classroom,
    this.building,
  });

  factory Classroom.fromJson(Map<String, dynamic> json) => Classroom(
        id: json["id"],
        id_class: json["id_class"],
        begin_hour: json["begin_hour"],
        end_hour: json["end_hour"],
        days: json["days"],
        classroom: json["classroom"],
        building: json["building"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "id_class": id_class,
        "begin_hour": begin_hour,
        "end_hour": end_hour,
        "days": days,
        "classroom": classroom,
        "building": building,
      };
}
