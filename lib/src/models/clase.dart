import 'dart:convert';

Clase claseFromJson(String str) => Clase.fromJson(json.decode(str));

String claseToJson(Clase data) => json.encode(data.toJson());

class Clase {
  String? id;
  String? id_user;
  String? id_clase;
  String? begin_hour;
  String? end_hour;
  String? days;
  String? classroom;
  String? building;

  Clase({
    this.id,
    this.id_user,
    this.id_clase,
    this.begin_hour,
    this.end_hour,
    this.days,
    this.classroom,
    this.building,
  });

  factory Clase.fromJson(Map<String, dynamic> json) => Clase(
        id: json["id"],
        id_user: json["id_user"],
        id_clase: json["id_clase"],
        begin_hour: json["begin_hour"],
        end_hour: json["end_hour"],
        days: json["days"],
        classroom: json["classroom"],
        building: json["building"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "id_user": id_user,
        "id_clase": id_clase,
        "begin_hour": begin_hour,
        "end_hour": end_hour,
        "days": days,
        "classroom": classroom,
        "building": building,
      };
}
