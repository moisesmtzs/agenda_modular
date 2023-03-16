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

  Future<List<Clase?>> findByUser(String idUser) async {
    //retorna una lista de tipo clase
    try {
      Uri _url =
          Uri.http(Environment.API_URL_OLD, '/api/clase/findByUser/$idUser');

      Map<String, String> headers = {
        'Content-Type': 'application/json',
        'Authorization': userSession.sessionToken ?? ''
      };
      final res = await http.get(_url, headers: headers);

      final data = json.decode(res.body);
      Clase clase = Clase.fromJsonList(data); //recuperamos los datos
      return clase
          .toList; //retornamos los datos y los regresamos como una lista
    } catch (e) {
      return [];
    }
  }

  // Future<List<Clase?>> getByIdUserAndIdSubject(
  //     String subjectt, String user) async {
  //   try {
  //     Uri _url = Uri.http(Environment.API_URL_OLD,
  //         '/api/Clase/getByIdUserAndIdSubject/$subjectt/$user');

  //     Map<String, String> headers = {
  //       'Content-Type': 'application/json',
  //       'Authorization': userSession.sessionToken ?? ''
  //     };

  //     final res = await http.get(_url, headers: headers);

  //     final data = json.decode(res.body);

  //     Clase subject = Clase.fromJsonList(data);
  //     return subject.toList;
  //   } catch (e) {
  //     e.printError();
  //     return [];
  //   }
  // }

  Future<List<Clase?>> findByUserAndDay(String idUser, String day) async {
    //RETORNAMOS LAS CLASES POR DIA
    try {
      Uri _url = Uri.http(Environment.API_URL_OLD,
          '/api/Clase/findByIdUserAndDay/$idUser/$day');

      Map<String, String> headers = {
        'Content-Type': 'application/json',
        'Authorization': userSession.sessionToken ?? ''
      };

      final res = await http.get(_url, headers: headers);
      final data = json.decode(res.body);

      Clase clasesbyDay = Clase.fromJsonList(data);
      return clasesbyDay.toList;
    } catch (e) {
      e.printError();
      return [];
    }
  }

  Future<ResponseApi?> deleteClase(String? id) async {
    Response response = await delete('$url/delete/$id', headers: {
      'Content-Type': 'application/json',
      'Authorization': userSession.sessionToken ?? ''
    });
    ResponseApi responseApi = ResponseApi.fromJson(response.body);
    return responseApi;
  }

  Future<ResponseApi?> updateClase(Clase? clase) async {
    Response response = await put('$url/update', clase!.toJson(), headers: {
      'Content-Type': 'application/json',
      'Authorization': userSession.sessionToken ?? ''
    });

    ResponseApi responseApi = ResponseApi.fromJson(response.body);
    return responseApi;
  }
}
