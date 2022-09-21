import 'package:get/get.dart';

import 'package:agenda_app/src/api/environment.dart';
import 'package:agenda_app/src/models/response_api.dart';
import 'package:agenda_app/src/models/task.dart';

class TasksProvider extends GetConnect {

  String url = Environment.API_URL + "api/tasks";

  Future<ResponseApi?> create(Task task) async {

    Response response = await post(
      '$url/create',
      task.toJson(),
      headers: {
        'Content-Type': 'application/json'
      }
    );

    ResponseApi responseApi = ResponseApi.fromJson(response.body);
    return responseApi;

  }

}