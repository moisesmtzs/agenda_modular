
class Query {

  String? command;

  Query( {this.command });

  Map<String, dynamic> toJson() => {
    "command": command
  };

}