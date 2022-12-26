import 'package:flutter/material.dart';
import "dart:io";

import 'package:get/get.dart';

import 'package:agenda_app/src/widgets/auth_background.dart';
import 'package:agenda_app/src/widgets/card_container.dart';
import 'package:agenda_app/src/ui/input_decoration.dart';
import 'package:agenda_app/src/screens/registersubject/registersubject_controller.dart';

import 'package:agenda_app/src/screens/screens.dart';
import 'package:agenda_app/src/ui/app_colors.dart';

class RegisterSubjectPage extends StatefulWidget {
  @override
  State<RegisterSubjectPage> createState() => _RegisterSubjectPageState();
}

class _RegisterSubjectPageState extends State<RegisterSubjectPage> {
  List<String> items = <String>[
    "07:00",
    "08:00",
    "09:00",
    "10:00",
    "11:00",
    "12:00",
    "13:00",
    "14:00",
    "15:00",
    "16:00",
    "17:00",
    "18:00",
    "19:00",
    "20:00",
    "21:00",
    "22:00"
  ];

  //Controladores
  ClassController classController = Get.put(ClassController());
  ScheduleinterController scheduleInterController =
      Get.put(ScheduleinterController());

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Crear materia',
          style: TextStyle(fontSize: 24),
        ),
      ),
      body: ListView(
        physics: const ClampingScrollPhysics(),
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        children: [
          _textName(),
          _textCodeSubject(),
          _textProfesorsName(),
          _days(),
          // _begin(),
          // _end(),
          // _clasroom(),
          // _building(),
        ],
      ),
      bottomNavigationBar: _registerButton(),
    );
  }

  //------------------CLASS---------------------------------------------
  Widget _textName() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
          color: AppColors.colors.primaryContainer,
          borderRadius: BorderRadius.circular(15)),
      child: Form(
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: TextFormField(
            controller: classController.nameClassController, ////<----
            cursorRadius: const Radius.circular(8.0),
            autocorrect: false,
            keyboardType: TextInputType.name,
            decoration: const InputDecoration(
                hintText: "Matematicas",
                labelText: "Nombre Materia",
                prefixIcon: Icon(Icons.perm_identity_sharp)),
            validator: (value) {
              String pattern = r"\b([a-zA-ZÀ-ÿ][-,a-z. ']+[ ]*)+";
              RegExp nameregExp = RegExp(pattern);
              return nameregExp.hasMatch(value ?? '')
                  ? null
                  : 'Nombre no válido';
            }),
      ),
    );
  }

  Widget _textCodeSubject() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
          color: AppColors.colors.primaryContainer,
          borderRadius: BorderRadius.circular(15)),
      child: Form(
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: TextFormField(
            controller: classController.codeClassController,
            cursorRadius: const Radius.circular(8.0),
            autocorrect: false,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
                hintText: "5909",
                labelText: "Codigo Materia",
                prefixIcon: Icon(Icons.numbers)),
            validator: (value) {
              String pattern = r"\b[0-9]";
              RegExp nameregExp = RegExp(pattern);
              return nameregExp.hasMatch(value ?? '')
                  ? null
                  : 'Codigo no válido';
            }),
      ),
    );
  }

  Widget _textProfesorsName() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
          color: AppColors.colors.primaryContainer,
          borderRadius: BorderRadius.circular(15)),
      child: Form(
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: TextFormField(
            controller: classController.profesorClassController,
            cursorRadius: const Radius.circular(8.0),
            autocorrect: false,
            keyboardType: TextInputType.name,
            decoration: const InputDecoration(
                hintText: "Marcos",
                labelText: "Nombre Profesor",
                prefixIcon: Icon(Icons.perm_identity_sharp)),
            validator: (value) {
              String pattern = r"\b([a-zA-ZÀ-ÿ][-,a-z. ']+[ ]*)+";
              RegExp nameregExp = RegExp(pattern);
              return nameregExp.hasMatch(value ?? '')
                  ? null
                  : 'Nombre no válido';
            }),
      ),
    );
  }

  //------------------------SCHEDULE-----------------------------------
  Widget _begin() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 45, vertical: 15),
      padding: const EdgeInsets.symmetric(horizontal: 80, vertical: 10),
      decoration: BoxDecoration(
          color: AppColors.colors.primaryContainer,
          borderRadius: BorderRadius.circular(15)),
      child: DropdownButton(
        dropdownColor: AppColors.colors.onSecondary,
        borderRadius: BorderRadius.circular(16),
        alignment: Alignment.center,
        menuMaxHeight: 400,
        icon: const Icon(Icons.keyboard_arrow_down),
        iconSize: 30,
        hint: const Text("Hora de Inicio"),
        value: scheduleInterController.begineController,
        items: items
            .map((String hora) => DropdownMenuItem<String>(
                  value: hora,
                  child: Text(hora),
                ))
            .toList(),
        onChanged: (option) {
          setState(() {
            scheduleInterController.begineController = option.toString();
          });
        },
      ),
    );
  }

  Widget _end() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 45, vertical: 15),
      padding: const EdgeInsets.symmetric(horizontal: 80, vertical: 10),
      decoration: BoxDecoration(
          color: AppColors.colors.primaryContainer,
          borderRadius: BorderRadius.circular(15)),
      child: DropdownButton(
        dropdownColor: AppColors.colors.onSecondary,
        borderRadius: BorderRadius.circular(16),
        alignment: Alignment.center,
        menuMaxHeight: 400,
        icon: const Icon(Icons.keyboard_arrow_down),
        iconSize: 30,
        hint: const Text("Hora de Fin"),
        value: scheduleInterController.endController,
        items: items
            .map((String hora) => DropdownMenuItem<String>(
                  value: hora,
                  child: Text(hora),
                ))
            .toList(),
        onChanged: (option) {
          setState(() {
            scheduleInterController.endController = option.toString();
          });
        },
      ),
    );
  }

  List<bool> dias = [false, false, false, false, false, false, false];
  Widget _days() {
    return Center(
      child: Column(
        children: <Widget>[
          CheckboxListTile(
            title: const Text('Lunes'),
            value: dias[0],
            onChanged: (bool? value) {
              setState(() {
                dias[0] = value!;
              });
            },
          ),
          CheckboxListTile(
            title: const Text('Martes'),
            value: dias[1],
            onChanged: (bool? value) {
              setState(() {
                dias[1] = value!;
              });
            },
          ),
          CheckboxListTile(
            title: const Text('Miercoles'),
            value: dias[2],
            onChanged: (bool? value) {
              setState(() {
                dias[2] = value!;
              });
            },
          ),
          CheckboxListTile(
            title: const Text('Jueves'),
            value: dias[3],
            onChanged: (bool? value) {
              setState(() {
                dias[3] = value!;
              });
            },
          ),
          CheckboxListTile(
            title: const Text('Viernes'),
            value: dias[4],
            onChanged: (bool? value) {
              setState(() {
                dias[4] = value!;
              });
            },
          ),
          CheckboxListTile(
            title: const Text('Sabado'),
            value: dias[5],
            onChanged: (bool? value) {
              setState(() {
                dias[5] = value!;
              });
            },
          ),
          CheckboxListTile(
            title: const Text('Domingo'),
            value: dias[6],
            onChanged: (bool? value) {
              setState(() {
                dias[5] = value!;
              });
            },
          ),
        ],
      ),
    );
  }

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
            controller: scheduleInterController.clasroomController,
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
            controller: scheduleInterController.buildingController,
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

  //-------------------------------------------------------------------------------
  Widget _registerButton() {
    String finaldays = "";
    if (dias[0] == true) finaldays = finaldays + 'l';
    if (dias[1] == true) finaldays = finaldays + 'm';
    if (dias[2] == true) finaldays = finaldays + 'i';
    if (dias[3] == true) finaldays = finaldays + 'j';
    if (dias[4] == true) finaldays = finaldays + 'v';
    if (dias[5] == true) finaldays = finaldays + 's';
    return Container(
      width: double.infinity,
      height: 50,
      margin: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
      //child: MaterialButton(
      child: ElevatedButton(
        //onPressed: () => scheduleController.voidschedule(),
        onPressed: () {
          scheduleInterController.daysController = finaldays;
          classController.register(context);
          //scheduleInterController.register(context);
        },
        child: const Text(
          'Registrar Materia',
        ),
      ),
    );
  }
} //Fin Class
