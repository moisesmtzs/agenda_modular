import 'package:agenda_app/src/screens/clase/update/clase_update_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:agenda_app/src/screens/clase/add_clase/add_clase_controller.dart';
import 'package:agenda_app/src/models/clase.dart';
import 'package:agenda_app/src/ui/app_colors.dart';

class ClaseUpdatePage extends StatelessWidget {
  ClaseUpdatePage({Key? key, required this.clase}) : super(key: key);

  ClaseController claseController = Get.put(ClaseController());
  List<String> items = <String>[
    "07:00","07:30","08:00","08:30","09:00","09:30","10:00","10:30","11:00","11:30","12:00","12:30","13:00","13:30","14:00","14:30","15:00","15:30","16:00","16:30","17:00","17:30","18:00","18:30","19:00","19:30","20:00","20:30","21:00","21:30","22:00"
  ];

  late Clase? clase;
  late ClaseUpdateController claseUpdateController =
      Get.put(ClaseUpdateController(clase!));

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
      margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
      child: ListView(
          physics: const ClampingScrollPhysics(),
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          children: [
            ElevatedButton.icon(
              icon: Icon(Icons.check_rounded,
                  size: 30, color: AppColors.colors.onPrimary),
              label: Text('Actualizar Clase',
                  style: TextStyle(
                      fontSize: 20, color: AppColors.colors.onPrimary)),
              style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all(AppColors.colors.primary),
                  padding: MaterialStateProperty.all(
                      const EdgeInsets.symmetric(horizontal: 50, vertical: 10)),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                      )
                  )
              ),
              onPressed: () {
                claseUpdateController.updateClase(context);
              },
            ),
            // const SizedBox(height: 25),
            // _dropDownSubjects(),
            const SizedBox(height: 20),
            _clasroom(),
            const SizedBox(height: 20),
            _building(),
          ]
      ),
    );
  }

  List<DropdownMenuItem<String>> _dropDownItems() {
    List<DropdownMenuItem<String>> list = [];
    for (var subject in claseController.subjects) {
      list.add(DropdownMenuItem(
        child: Text(subject?.name ?? ''),
        value: subject?.id,
      ));
    }
    return list;
  }

  Widget _dropDownSubjects(){
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      margin: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.colors.primaryContainer,
        borderRadius: BorderRadius.circular(15)
      ),
      child: Obx( () => DropdownButton(
        dropdownColor: AppColors.colors.onSecondary,
        borderRadius: BorderRadius.circular(16),
        underline: Container(
          alignment: Alignment.centerRight,
          child: const Icon(Icons.arrow_drop_down_circle)
        ),
        elevation: 3,
        isExpanded: true,
        hint: const Text(
          'Seleccionar materia',
          style: TextStyle(color: Colors.black, fontSize: 16),
        ),
        items: _dropDownItems(),
        value: claseController.idsubject.value == '' ? null : claseController.idsubject.value,
        onChanged: (option) {
          claseController.idsubject.value = option.toString();
        },
      ),
      ),
    );
  }

  // Widget _begin() {
  //   return Container(
  //     margin: const EdgeInsets.symmetric(horizontal: 50, vertical: 10),
  //     padding: const EdgeInsets.symmetric(horizontal: 80, vertical: 5),
  //     decoration: BoxDecoration(
  //       color: AppColors.colors.primaryContainer,
  //       borderRadius: BorderRadius.circular(15)
  //     ),
  //     child: DropdownButton(
  //       dropdownColor: AppColors.colors.onSecondary,
  //       borderRadius: BorderRadius.circular(16),
  //       alignment: Alignment.center,
  //       menuMaxHeight: 400,
  //       hint: const Text("Hora de Inicio"),
  //       value: claseUpdateController.begineController,
  //       icon: const Visibility(visible: false, child: Icon(Icons.arrow_drop_down_circle)),
  //       underline: Container(
  //         alignment: Alignment.centerRight,
  //         child: const Icon(Icons.arrow_drop_down_circle)
  //       ),
  //       items: items.map((String hora) => DropdownMenuItem<String>(
  //         value: hora,
  //         child: Text(hora),
  //       )).toList(),
  //       onChanged: (option) {
  //         setState(() {
  //           claseUpdateController.begineController = option.toString();
  //         });
  //       },
  //     ),
  //   );
  // }

  // Widget _end() {
  //   return Container(
  //     margin: const EdgeInsets.symmetric(horizontal: 50, vertical: 10),
  //     padding: const EdgeInsets.symmetric(horizontal: 80, vertical: 5),
  //     decoration: BoxDecoration(
  //       color: AppColors.colors.primaryContainer,
  //       borderRadius: BorderRadius.circular(15)
  //     ),
  //     child: DropdownButton(
  //       dropdownColor: AppColors.colors.onSecondary,
  //       borderRadius: BorderRadius.circular(16),
  //       alignment: Alignment.center,
  //       menuMaxHeight: 400,
  //       icon: const Visibility(visible: false, child: Icon(Icons.arrow_drop_down_circle)),
  //       iconSize: 30,
  //       hint: const Text("Hora de Fin"),
  //       value: claseUpdateController.endController,
  //       underline: Container(
  //         alignment: Alignment.centerRight,
  //         child: const Icon(Icons.arrow_drop_down_circle)
  //       ),
  //       items: items
  //           .map((String hora) => DropdownMenuItem<String>(
  //                 value: hora,
  //                 child: Text(hora),
  //               ))
  //           .toList(),
  //       onChanged: (option) {
  //         setState(() {
  //           claseUpdateController.endController = option.toString();
  //         });
  //       },
  //     ),
  //   );
  // }

  // SingingCharacter? _character = SingingCharacter.lunes;
  // Widget _day() {
  //   return Column(
  //     children: <Widget>[
  //       ListTile(
  //         title: const Text('lunes'),
  //         leading: Radio<SingingCharacter>(
  //           activeColor: AppColors.colors.primary,
  //           value: SingingCharacter.lunes,
  //           groupValue: _character,
  //           onChanged: (SingingCharacter? value) {
  //             setState(() {
  //               _character = value;
  //               claseUpdateController.daysController = 'lunes';
  //             });
  //           },
  //         ),
  //       ),
  //       ListTile(
  //         title: const Text('martes'),
  //         leading: Radio<SingingCharacter>(
  //           activeColor: AppColors.colors.primary,
  //           value: SingingCharacter.martes,
  //           groupValue: _character,
  //           onChanged: (SingingCharacter? value) {
  //             setState(() {
  //               _character = value;
  //               claseUpdateController.daysController = 'martes';
  //             });
  //           },
  //         ),
  //       ),
  //       ListTile(
  //         title: const Text('miercoles'),
  //         leading: Radio<SingingCharacter>(
  //           activeColor: AppColors.colors.primary,
  //           value: SingingCharacter.miercoles,
  //           groupValue: _character,
  //           onChanged: (SingingCharacter? value) {
            
  //             setState(() {
  //               _character = value;
  //               claseUpdateController.daysController = 'miercoles';
  //             });
  //           },
  //         ),
  //       ),
  //       ListTile(
  //         title: const Text('jueves'),
  //         leading: Radio<SingingCharacter>(
  //           activeColor: AppColors.colors.primary,
  //           value: SingingCharacter.jueves,
  //           groupValue: _character,
  //           onChanged: (SingingCharacter? value) {
  //             setState(() {
  //               _character = value;
  //               claseUpdateController.daysController = 'jueves';
  //             });
  //           },
  //         ),
  //       ),
  //       ListTile(
  //         title: const Text('viernes'),
  //         leading: Radio<SingingCharacter>(
  //           activeColor: AppColors.colors.primary,
  //           value: SingingCharacter.viernes,
  //           groupValue: _character,
  //           onChanged: (SingingCharacter? value) {
  //             setState(() {
  //               _character = value;
  //               claseUpdateController.daysController = 'viernes';
  //             });
  //           },
  //         ),
  //       ),
  //       ListTile(
  //         title: const Text('sabado'),
  //         leading: Radio<SingingCharacter>(
  //           activeColor: AppColors.colors.primary,
  //           value: SingingCharacter.sabado,
  //           groupValue: _character,
  //           onChanged: (SingingCharacter? value) {
  //             setState(() {
  //               _character = value;
  //               claseUpdateController.daysController = 'sabado';
  //             });
  //           },
  //         ),
  //       ),
  //     ],
  //   );
  // }

  Widget _clasroom() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
          color: AppColors.colors.primaryContainer,
          borderRadius: BorderRadius.circular(15)),
      child: Form(
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: TextFormField(
            controller: claseUpdateController.clasroomController,
            cursorRadius: const Radius.circular(8.0),
            autocorrect: false,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
                hintText: "8",
                labelText: "Numero de Salon",
                prefixIcon: Icon(Icons.numbers)),
            validator: (value) {
              String pattern = r"\b[0-9]";
              RegExp nameregExp = RegExp(pattern);
              return nameregExp.hasMatch(value ?? '')
                  ? null
                  : 'Nombre no válido';
            }),
      ),
    );
  }

  Widget _building() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
          color: AppColors.colors.primaryContainer,
          borderRadius: BorderRadius.circular(15)),
      child: Form(
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: TextFormField(
            controller: claseUpdateController.buildingController,
            cursorRadius: const Radius.circular(8.0),
            autocorrect: false,
            keyboardType: TextInputType.text,
            decoration: const InputDecoration(
                hintText: "A",
                labelText: "Edificio",
                prefixIcon: Icon(Icons.abc)),
            validator: (value) {
              String pattern = r"\b[a-zA-Z]";
              RegExp nameregExp = RegExp(pattern);
              return nameregExp.hasMatch(value ?? '')
                  ? null
                  : 'Nombre no válido';
            }),
      ),
    );
  }
}
