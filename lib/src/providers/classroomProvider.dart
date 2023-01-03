import 'package:get/get.dart';

import 'package:agenda_app/src/api/environment.dart';
import 'package:agenda_app/src/models/response_api.dart';
import 'package:agenda_app/src/models/classroom.dart';

class ClassroomProvider extends GetConnect {
  String url = Environment.API_URL + "api/classroom";

  Future<ResponseApi?> create(Classroom classroom) async {
    Response response = await post('$url/create', classroom.toJson(),
        headers: {'Content-Type': 'application/json'});
    ResponseApi responseApi = ResponseApi.fromJson(response.body);
    return responseApi;
  }
}
