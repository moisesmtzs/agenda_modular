import 'package:get/get.dart';

import 'package:agenda_app/src/api/environment.dart';
import 'package:agenda_app/src/models/response_api.dart';
import 'package:agenda_app/src/models/user.dart';

class UsersProvider extends GetConnect {

  String url = Environment.API_URL + "api/users";

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

}