import 'package:get/get.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:agenda_app/src/api/environment.dart';
import 'package:agenda_app/src/models/response_api.dart';
import 'package:agenda_app/src/models/subject.dart';

import 'package:get_storage/get_storage.dart';
import 'package:agenda_app/src/models/user.dart';

class SubjectProvider extends GetConnect {
  String url = Environment.API_URL + "api/subject";
  User userSession = User.fromJson(GetStorage().read('user') ?? {});

  Future<ResponseApi?> create(Subject subject) async {
    Response response = await post('$url/create', subject.toJson(),
        headers: {'Content-Type': 'application/json'});
    ResponseApi responseApi = ResponseApi.fromJson(response.body);
    return responseApi;
  }

  Future<List<Subject?>> getByName(String name, String user) async {
    try {
      Uri _url = Uri.http(
          Environment.API_URL_OLD, '/api/subject/findByName/$name/$user');

      Map<String, String> headers = {
        'Content-Type': 'application/json',
        'Authorization': userSession.sessionToken ?? ''
      };

      final res = await http.get(_url, headers: headers);

      final data = json.decode(res.body);
      Subject subject = Subject.fromJsonList(data);
      return subject.toList;
    } catch (e) {
      e.printError();
      return [];
    }
  }
}