import 'dart:convert';

Task taskFromJson(String str) => Task.fromJson(json.decode(str));

String taskToJson(Task data) => json.encode(data.toJson());

class Task {

    String? id;
    String? name;
    String? description;
    String? deliveryDate;
    String? subject;
    String? type;
    String? status;
    
    Task({
        this.id,
        this.name,
        this.description,
        this.deliveryDate,
        this.subject,
        this.type,
        this.status,
    });


    factory Task.fromJson(Map<String, dynamic> json) => Task(
        id: json["id"],
        name: json["name"],
        description: json["description"],
        deliveryDate: json["delivery_date"],
        subject: json["subject"],
        type: json["type"],
        status: json["status"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "description": description,
        "delivery_date": deliveryDate,
        "subject": subject,
        "type": type,
        "status": status,
    };
}
