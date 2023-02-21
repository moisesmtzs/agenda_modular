import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import 'package:agenda_app/src/models/clase.dart';
import 'package:agenda_app/src/screens/clase/detail/clase_detail_controller.dart';
import 'package:agenda_app/src/screens/clase/update/clase_update_page.dart';
import 'package:agenda_app/src/ui/app_colors.dart';

class ClaseDetailPage extends StatelessWidget {
  ClaseDetailController claseDetailController =
      Get.put(ClaseDetailController());

  late Clase? clase;

  ClaseDetailPage({Key? key, required this.clase}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.4,
      margin: const EdgeInsets.only(top: 20, bottom: 40, left: 30, right: 30),
      child: ListView(physics: const ClampingScrollPhysics(), children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            IconButton(
              icon: const Icon(Icons.edit_outlined, size: 30),
              color: AppColors.colors.primary,
              onPressed: () {
                Get.bottomSheet(
                  ClaseUpdatePage(clase: clase),
                  enableDrag: true,
                  isDismissible: true,
                  isScrollControlled: true,
                  ignoreSafeArea: false,
                  backgroundColor: AppColors.colors.secondaryContainer,
                  barrierColor: Colors.black.withOpacity(0),
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10.0),
                        topRight: Radius.circular(10.0)),
                  ),
                );
              },
            ),
            IconButton(
              icon: const Icon(Icons.delete_outline_rounded, size: 30),
              color: AppColors.colors.primary,
              onPressed: () {
                claseDetailController.confirmationDialog(
                    context, clase?.id ?? '0');
                claseDetailController.refresh();
              },
            ),
          ],
        ),
        const SizedBox(height: 10),
        // Text(
        //   clase?.name ?? '',
        //   style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
        //   textAlign: TextAlign.center,
        // ),
        // const SizedBox(height: 40),
        // Text(
        //   task?.description ?? '',
        //   style: const TextStyle(fontSize: 16),
        // ),
        const SizedBox(height: 10),
      ]),
    );
  }
}
