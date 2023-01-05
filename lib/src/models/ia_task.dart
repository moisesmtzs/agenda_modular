import 'dart:convert';

ia_task classFromJson(String str) => ia_task.fromJson(json.decode(str));

String classToJson(ia_task data) => json.encode(data.toJson());

class ia_task {
  String? id;
  String? word;
  String? action;
  List<ia_task> toList = [];

  ia_task({
    this.id,
    this.word,
    this.action,
  });

  factory ia_task.fromJson(Map<String, dynamic> json) => ia_task(
        id: json["id"],
        word: json["word"],
        action: json["action"],
      );

  ia_task.fromJsonList( List<dynamic> jsonList ) {
      if ( jsonList == null ) return;

      for (var element in jsonList) {
        ia_task task = ia_task.fromJson(element);
        toList.add(task);
      }
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "word": word,
        "action": action,
      };
}