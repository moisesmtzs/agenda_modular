import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'package:agenda_app/src/api/environment.dart';
import 'package:agenda_app/src/models/response_api.dart';
import 'package:agenda_app/src/models/user.dart';

class UsersProvider extends GetConnect {

  String url = Environment.API_URL + "api/users";

  User userSession = User.fromJson(GetStorage().read('user') ?? {});

  Future<ResponseApi?> create( User user ) async {

    Response response = await post(
      '$url/register',
      user.toJson(),
      headers: {
        'Content-Type': 'application/json'
      }
    );

    ResponseApi responseApi = ResponseApi.fromJson(response.body);
    return responseApi;

  }

  Future<ResponseApi?> login( String email, String contrasena ) async {

    Response response = await post(
      '$url/login',
      {
        'email': email,
        'password': contrasena,
      },
      headers: {
        'Content-Type': 'application/json'
      }
    );

    if ( response.body == null ) {
      Get.snackbar('Error', 'No se ha podido ejecutar la petición');
    }

    ResponseApi responseApi = ResponseApi.fromJson(response.body);
    return responseApi;

  }

  Future<ResponseApi?> update( User user ) async {

    Response response = await put(
      '$url/updateWithoutImage',
      user.toJson(),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': userSession.sessionToken ?? ''
      }
    );
    print({response.body});

    if ( response.body == null ) {
      Get.snackbar('Error', 'No se pudo actualizar la información');
      return ResponseApi();
    }

    ResponseApi responseApi = ResponseApi.fromJson(response.body);
    return responseApi;

  }

  Future<Stream?> updateWithImage( User user, File image ) async {

    Uri url = Uri.http(Environment.API_URL_OLD, '/api/users/update');
    final request = http.MultipartRequest('PUT', url);

    request.headers['Authorization'] = userSession.sessionToken ?? '';
    request.files.add(http.MultipartFile(
      'image',
      http.ByteStream(image.openRead().cast()),
      await image.length(),
      filename: basename(image.path)
    ));

    request.fields['user'] = json.encode(user);

    final response = await request.send();

    return response.stream.transform(utf8.decoder);

  }

}