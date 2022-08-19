import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import 'package:agenda_app/src/screens/tasks/detail/tasks_detail_screen.dart';
import 'package:agenda_app/src/models/user.dart';

class TaskController extends GetxController {

  User userSession = User.fromJson(GetStorage().read('user') ?? {});

  List<String> status = ['PENDIENTE', 'COMPLETADO'];

  var isSelected = false.obs;
  bool? isUpdated;

  void openBottomSheet(BuildContext context) async {

    isUpdated = await showMaterialModalBottomSheet(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(topLeft: Radius.circular(10.0), topRight: Radius.circular(10.0)),
      ),
      context: context, 
      builder: (context) => TaskDetailPage()
    ); 

  }
}