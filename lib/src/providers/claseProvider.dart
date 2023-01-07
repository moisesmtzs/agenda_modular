import 'package:get/get.dart';

import 'package:agenda_app/src/api/environment.dart';
import 'package:agenda_app/src/models/response_api.dart';
import 'package:agenda_app/src/models/clase.dart';

class ClaseProvider extends GetConnect {
  String url = Environment.API_URL + "api/clase";

  Future<ResponseApi?> create(Clase clase) async {
    Response response = await post('$url/create', clase.toJson(),
        headers: {'Content-Type': 'application/json'});
    ResponseApi responseApi = ResponseApi.fromJson(response.body);
    return responseApi;
  }
}
