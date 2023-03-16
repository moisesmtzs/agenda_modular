import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'package:agenda_app/src/api/environment.dart';
import 'package:agenda_app/src/models/response_api.dart';
import 'package:agenda_app/src/models/task.dart';
import 'package:agenda_app/src/models/user.dart';

class TasksProvider extends GetConnect {

  String url = Environment.API_URL + "api/tasks";

  User userSession = User.fromJson(GetStorage().read('user') ?? {});

  Future<ResponseApi?> create(Task task) async {
    Response response = await post(
      '$url/create',
      task.toJson(),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': userSession.sessionToken ?? ''
      }
    );
    ResponseApi responseApi = ResponseApi.fromJson(response.body);
    return responseApi;

  }

  Future<List<Task?>> getByUserAndStatus( String idUser, String status ) async {

    try {
      Uri _url = Uri.http(Environment.API_URL_OLD, '/api/tasks/findByUserAndStatus/$idUser/$status');
      
      Map<String, String> headers = {
        'Content-Type': 'application/json',
        'Authorization': userSession.sessionToken ?? ''
      };
      final res = await http.get(_url, headers: headers);

      final data = json.decode(res.body);
      Task task = Task.fromJsonList(data);
      return task.toList;

    } catch (e) {
      return [];
    }

  }

  //OBTENER POR NOMBRE Y USUARIO//
  Future<List<Task?>> getByUserAndName( String idUser, String name ) async {

    try {
      Uri _url = Uri.http(Environment.API_URL_OLD, '/api/tasks/findByUserAndName/$idUser/$name');
      
      Map<String, String> headers = {
        'Content-Type': 'application/json',
        'Authorization': userSession.sessionToken ?? ''
      };
      final res = await http.get(_url, headers: headers);

      final data = json.decode(res.body);
      Task task = Task.fromJsonList(data);
      return task.toList;

    } catch (e) {
      return [];
    }

  }


  Future<ResponseApi?> updateTask(Task? task) async {

    Response response = await put(
      '$url/update',
      task!.toJson(),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': userSession.sessionToken ?? ''
      }
    );

    ResponseApi responseApi = ResponseApi.fromJson(response.body);
    return responseApi;

  }

  Future<ResponseApi?> updateStatusTask( String? id, String? status ) async {

    Map<String, dynamic> body = {
      'id': id ?? '',
      'status': status ?? ''
    };
    String jsonBody = json.encode(body);

    Response response = await put(
      '$url/updateStatus/$id/$status',
      jsonBody,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': userSession.sessionToken ?? ''
      }
    );

    ResponseApi responseApi = ResponseApi.fromJson(response.body);
    return responseApi;

  }
  

  Future<ResponseApi?> deleteTask( String? id ) async {

    Response response = await delete(
      '$url/delete/$id',
      headers: {
        'Content-Type': 'application/json',
        'Authorization': userSession.sessionToken ?? ''
      }
    );
    ResponseApi responseApi = ResponseApi.fromJson(response.body);
    return responseApi;
    
  }

}