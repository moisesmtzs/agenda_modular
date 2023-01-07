import 'package:get/get.dart';

import 'package:agenda_app/src/api/environment.dart';
import 'package:agenda_app/src/models/response_api.dart';
import 'package:agenda_app/src/models/subject.dart';

class SubjectProvider extends GetConnect {
  String url = Environment.API_URL + "api/subject";

  Future<ResponseApi?> create(Subject subject) async {
    Response response = await post('$url/create', subject.toJson(),
        headers: {'Content-Type': 'application/json'});
    ResponseApi responseApi = ResponseApi.fromJson(response.body);
    return responseApi;
  }
}
