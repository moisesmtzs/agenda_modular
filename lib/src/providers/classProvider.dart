import 'package:get/get.dart';

import 'package:agenda_app/src/api/environment.dart';
import 'package:agenda_app/src/models/response_api.dart';
import 'package:agenda_app/src/models/class.dart';

class ClassProvider extends GetConnect {
  String url = Environment.API_URL + "api/class";

  Future<ResponseApi?> create(Class clase) async {
    Response response = await post('$url/create', clase.toJson(),
        headers: {'Content-Type': 'application/json'});
    ResponseApi responseApi = ResponseApi.fromJson(response.body);
    return responseApi;
  }
}
