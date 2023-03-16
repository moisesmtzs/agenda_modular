import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'package:agenda_app/src/api/environment.dart';
import 'package:agenda_app/src/models/query.dart';
import 'package:agenda_app/src/models/user.dart';

class SyncProvider extends GetConnect {

  String url = Environment.API_URL + "api/sync";

  User userSession = User.fromJson(GetStorage().read('user') ?? {});

  void create(Query command) async {
    Response response = await post('$url/execute', command.toJson(),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': userSession.sessionToken ?? ''
      }
    );

  }

}