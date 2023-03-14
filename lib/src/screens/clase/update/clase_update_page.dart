import 'package:agenda_app/src/screens/clase/update/clase_update_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:agenda_app/src/screens/clase/add_clase/add_clase_controller.dart';
import 'package:agenda_app/src/models/clase.dart';
import 'package:agenda_app/src/ui/app_colors.dart';

class ClaseUpdatePage extends StatelessWidget {

  ClaseUpdatePage({Key? key, required this.clase}) : super(key: key);
  
  late Clase? clase;
  late ClaseUpdateController claseUpdateController = Get.put(ClaseUpdateController(clase!));
  ClaseController claseController = Get.put(ClaseController());

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
              label: Text('Actualizar Clase', style: TextStyle(fontSize: 20, color: AppColors.colors.onPrimary)),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(AppColors.colors.primary),
                padding: MaterialStateProperty.all(const EdgeInsets.symmetric(horizontal: 50, vertical: 10)),
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
            const SizedBox(height: 20),
            _clasroom(),
            const SizedBox(height: 20),
            _building(),
            const SizedBox(height: 20),
            _begin(),
            const SizedBox(height: 20),
            _end(),
            const SizedBox(height: 20),
            _day(),
          ]
      ),
    );
  }

  Widget _begin() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 25),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppColors.colors.inversePrimary,
        borderRadius: BorderRadius.circular(15)
      ),
      child: Obx(() => DropdownButton(
        hint: const Text('Hora Inicio'),
        isExpanded: true,
        dropdownColor: AppColors.colors.primaryContainer,
        borderRadius: BorderRadius.circular(12),
        icon: const Icon(Icons.arrow_drop_down_circle_rounded),
        value: "07:00",
        items: _dropDownItems(claseUpdateController.hoursList),
        onChanged: (String? value) {
          claseUpdateController.selectedBegin.value = value!;
        },
      ),)
      
    );
  }

  Widget _end() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 25),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppColors.colors.inversePrimary,
        borderRadius: BorderRadius.circular(15)
      ),
      child: Obx(() => DropdownButton(
        hint: const Text('Hora Fin'),
        isExpanded: true,
        dropdownColor: AppColors.colors.primaryContainer,
        borderRadius: BorderRadius.circular(12),
        icon: const Icon(Icons.arrow_drop_down_circle_rounded),
        value: "07:00",
        items: _dropDownItems(claseUpdateController.hoursList),
        onChanged: (String? value) {
          claseUpdateController.selectedEnd.value = value!;
        },
      ),)
      
    );
  }

  Widget _day() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 25),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppColors.colors.inversePrimary,
        borderRadius: BorderRadius.circular(15)
      ),
      child: Obx(() => DropdownButton(
        hint: const Text('Dia'),
        isExpanded: true,
        dropdownColor: AppColors.colors.primaryContainer,
        borderRadius: BorderRadius.circular(12),
        icon: const Icon(Icons.arrow_drop_down_circle_rounded),
        //value: "Lunes",
        items: _dropDownItems(claseUpdateController.daysList),
        onChanged: (String? value) {
          claseUpdateController.selectedDay.value = value!;
        },
      ),)
      
    );
  }

  List<DropdownMenuItem<String>> _dropDownItems(List<String> types) {//dropdown de las horas
    List<DropdownMenuItem<String>> list = [];
    for (var type in types) {
      list.add(DropdownMenuItem(
        child: Text(type),
        value: type,
      ));
    }
    return list;
  }




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
