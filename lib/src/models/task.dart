import 'dart:convert';

Task taskFromJson(String str) => Task.fromJson(json.decode(str));

String taskToJson(Task data) => json.encode(data.toJson());

class Task {

    String? id;
    String? idUser;
    String? name;
    String? description;
    String? deliveryDate;
    String? subject;
    String? type;
    String? status;
    List<Task> toList = [];
    
    Task({
        this.id,
        this.idUser,
        this.name,
        this.description,
        this.deliveryDate,
        this.subject,
        this.type,
        this.status,
    });


    factory Task.fromJson(Map<String, dynamic> json) => Task(
        id: json["id"],
        idUser: json["id_user"],
        name: json["name"],
        description: json["description"],
        deliveryDate: json["delivery_date"],
        subject: json["subject"],
        type: json["type"],
        status: json["status"],
    );

    Task.fromJsonList( List<dynamic> jsonList ) {
      if ( jsonList == null ) return;

      for (var element in jsonList) {
        Task task = Task.fromJson(element);
        toList.add(task);
      }
    }

    Map<String, dynamic> toJson() => {
        "id": id,
        "id_user": idUser,
        "name": name,
        "description": description,
        "delivery_date": deliveryDate,
        "subject": subject,
        "type": type,
        "status": status,
    };
}
