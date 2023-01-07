import 'dart:convert';

import 'package:agenda_app/src/screens/screens.dart';

Clase claseFromJson(String str) => Clase.fromJson(json.decode(str));

String claseToJson(Clase data) => json.encode(data.toJson());

class Clase {
  String? id;
  String? id_class;
  String? begin_hour;
  String? end_hour;
  String? days;
  String? classroom;
  String? building;

  Clase({
    this.id,
    this.id_class,
    this.begin_hour,
    this.end_hour,
    this.days,
    this.classroom,
    this.building,
  });

  factory Clase.fromJson(Map<String, dynamic> json) => Clase(
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
