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

  //OBTENER POR NOMBRE Y USUARIO//
  Future<Clase?> getByIdDaysHours( String idUser, Clase searchClase ) async {
    try {
      Uri _url = Uri.http(Environment.API_URL_OLD, '/api/subject/findIdClase/${searchClase.begin_hour}/${searchClase.end_hour}/${searchClase.days}/$idUser');
      
      Map<String, String> headers = {
        'Content-Type': 'application/json',
        'Authorization': userSession.sessionToken ?? ''
      };
      final res = await http.get(_url, headers: headers);

      final data = json.decode(res.body);
      Clase clase = Clase.fromJson(data);
      return clase;

    } catch (e) {
      return null;
    }
  }


  Future<List<Clase?>> findByUserAndSubject(
      //String idUser, String idSubject) async {
      String idUser, String subject) async {
    try {
      Uri _url = Uri.http(Environment.API_URL_OLD,
          '/api/clase/findByUserAndSubject/$idUser/$subject');

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
      return clase.toList; 
    } catch (e) {
      return [];
    }
  }

  Future<Clase?> findByIdDayBegin(String idUser, String days, String begin) async {
    Uri _url = Uri.http(Environment.API_URL_OLD, '/api/clase/findByIdDayBegine/$idUser/$days/$begin');

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': userSession.sessionToken ?? ''
    };
    final res = await http.get(_url, headers: headers);

    final data = json.decode(res.body);
    print(data);
    Clase clase = Clase.fromJson(data); //recuperamos los datos
    return clase; 
  }

  Future<List<Clase?>> findByUserStatic(String idUser) async {
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
      return clase.toList; 
    } catch (e) {
      return [];
    }
  }



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

  Future<Map<String, dynamic>?> getDatesById( String? idClase ) async {

    try {
      Uri _url = Uri.http(Environment.API_URL_OLD, '/api/clase/findDates/$idClase');
      
      Map<String, String> headers = {
        'Content-Type': 'application/json',
        'Authorization': userSession.sessionToken ?? ''
      };
      final res = await http.get(_url, headers: headers);

      final data = json.decode(res.body);
      Map<String, dynamic> dates = data;
      return dates;

    } catch (e) {
      return null;
    }

  }

}
