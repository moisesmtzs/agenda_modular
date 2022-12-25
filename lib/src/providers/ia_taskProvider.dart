import 'package:get/get.dart';

import 'package:get_storage/get_storage.dart';
import 'package:agenda_app/src/api/environment.dart';
import 'package:agenda_app/src/models/user.dart';
import 'package:agenda_app/src/models/response_api.dart';
import 'package:agenda_app/src/models/ia_task.dart';

class ia_taskProvider extends GetConnect 
{
  String url = Environment.API_URL + "api/iatasks";

  User userSession = User.fromJson(GetStorage().read('user') ?? {});

  Future<ResponseApi?> create(ia_task task) async {

    Response response = await post(
      '$url/create',
      task.toJson(),
      headers: {
        'Content-Type': 'application/json'
      }
    );

    ResponseApi responseApi = ResponseApi.fromJson(response.body);
    return responseApi;

  }
}