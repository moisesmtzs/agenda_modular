import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'package:agenda_app/src/api/environment.dart';
import 'package:agenda_app/src/models/response_api.dart';
import 'package:agenda_app/src/models/clase.dart';
import 'package:agenda_app/src/models/user.dart';

class ClaseProvider extends GetConnect {
  String url = Environment.API_URL + "api/clase";
  User userSession = User.fromJson(GetStorage().read('user') ?? {});

  Future<ResponseApi?> create(Clase clase) async {
    Response response = await post('$url/create', clase.toJson(),
        headers: {'Content-Type': 'application/json'});
    ResponseApi responseApi = ResponseApi.fromJson(response.body);
    return responseApi;
  }

  Future<List<Clase?>> findByUserAndSubject(
      String idUser, String idSubject) async {
    try {
      Uri _url = Uri.http(Environment.API_URL_OLD,
          '/api/clase/findByUserAndSubject/$idUser/$idSubject');

      Map<String, String> headers = {
        'Content-Type': 'application/json',
        'Authorization': userSession.sessionToken ?? ''
      };
      final res = await http.get(_url, headers: headers);

      final data = json.decode(res.body);
      Clase clase = Clase.fromJsonList(data);
      return clase.toList;
    } catch (e) {
      return [];
    }
  }
}
