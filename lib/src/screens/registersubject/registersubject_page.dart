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
  ScheduleinterController scheduleController =
      Get.put(ScheduleinterController());

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Crear materia', style: TextStyle(fontSize: 24),),
      ),
      body: ListView(
        physics: const ClampingScrollPhysics(),
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        children: [
          _textName(),
          _textCodeSubject(),
          _textProfesorsName(),
          _begin(),
          _end(),
          _days(),
          _clasroom(),
          _building(),
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
        borderRadius: BorderRadius.circular(15)
      ),
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
            prefixIcon: Icon(Icons.perm_identity_sharp)
          ),
          validator: (value) {
            String pattern = r"\b([a-zA-ZÀ-ÿ][-,a-z. ']+[ ]*)+";
            RegExp nameregExp = RegExp(pattern);
            return nameregExp.hasMatch(value ?? '') ? null : 'Nombre no válido';
          }
        ),
      ),
    );
  }

  Widget _textCodeSubject() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppColors.colors.primaryContainer,
        borderRadius: BorderRadius.circular(15)
      ),
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
              prefixIcon: Icon(Icons.numbers)
            ),
          validator: (value) {
            String pattern = r"\b[0-9]";
            RegExp nameregExp = RegExp(pattern);
            return nameregExp.hasMatch(value ?? '') ? null : 'Codigo no válido';
          }
        ),
      ),
    );
  }

  Widget _textProfesorsName() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppColors.colors.primaryContainer,
        borderRadius: BorderRadius.circular(15)
      ),
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
              prefixIcon: Icon(Icons.perm_identity_sharp)
            ),
          validator: (value) {
            String pattern = r"\b([a-zA-ZÀ-ÿ][-,a-z. ']+[ ]*)+";
            RegExp nameregExp = RegExp(pattern);
            return nameregExp.hasMatch(value ?? '') ? null : 'Nombre no válido';
          }
        ),
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
        borderRadius: BorderRadius.circular(15)
      ),
      child: DropdownButton(
        dropdownColor: AppColors.colors.onSecondary,
        borderRadius: BorderRadius.circular(16),
        alignment: Alignment.center,
        menuMaxHeight: 400,
        icon: const Icon(Icons.keyboard_arrow_down),
        iconSize: 30,
        hint: const Text("Hora de Inicio"),
        value: scheduleController.begineController,
        items: items
            .map((String hora) => DropdownMenuItem<String>(
                  value: hora,
                  child: Text(hora),
                ))
            .toList(),
        onChanged: (option) {
          setState(() {
            scheduleController.begineController = option.toString();
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
        borderRadius: BorderRadius.circular(15)
      ),
      child: DropdownButton(
        dropdownColor: AppColors.colors.onSecondary,
        borderRadius: BorderRadius.circular(16),
        alignment: Alignment.center,
        menuMaxHeight: 400,
        icon: const Icon(Icons.keyboard_arrow_down),
        iconSize: 30,
        hint: const Text("Hora de Fin"),
        value: scheduleController.endController,
        items: items
            .map((String hora) => DropdownMenuItem<String>(
                  value: hora,
                  child: Text(hora),
                ))
            .toList(),
        onChanged: (option) {
          setState(() {
            scheduleController.endController = option.toString();
          });
        },
      ),
    );
  }

  Widget _days() {
    //  l  m i j v s
    //MODIFICAR------------------
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppColors.colors.primaryContainer,
        borderRadius: BorderRadius.circular(15)
      ),
      child: Form(
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: TextFormField(
          controller: scheduleController.daysController,
          cursorRadius: const Radius.circular(8.0),
          autocorrect: false,
          keyboardType: TextInputType.text,
          decoration: const InputDecoration(
              hintText: "l m i j v s",
              labelText: "Dias",
              prefixIcon: Icon(Icons.calendar_month)
            ),
          validator: (value) {
            String pattern =
                r"^\s*([A-Za-z]{1,}([\.,] |[-']| ))+[A-Za-z]+\.?\s*$";
            RegExp nameregExp = RegExp(pattern);
            return nameregExp.hasMatch(value ?? '') ? null : 'Hora no válido';
          }
        ),
      ),
    );
  }

  Widget _clasroom() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppColors.colors.primaryContainer,
        borderRadius: BorderRadius.circular(15)
      ),
      child: Form(
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: TextFormField(
          controller: scheduleController.clasroomController,
          cursorRadius: const Radius.circular(8.0),
          autocorrect: false,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
              hintText: "8",
              labelText: "Numero de Salon",
              prefixIcon: Icon(Icons.numbers)
            ),
          validator: (value) {
            String pattern = r"\b[0-9]";
            RegExp nameregExp = RegExp(pattern);
            return nameregExp.hasMatch(value ?? '') ? null : 'Nombre no válido';
          }
        ),
      ),
    );
  }

  Widget _building() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppColors.colors.primaryContainer,
        borderRadius: BorderRadius.circular(15)
      ),
      child: Form(
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: TextFormField(
          controller: scheduleController.buildingController,
          cursorRadius: const Radius.circular(8.0),
          autocorrect: false,
          keyboardType: TextInputType.text,
          decoration: const InputDecoration(
              hintText: "A", labelText: "Edificio", prefixIcon: Icon(Icons.abc)
          ),
          validator: (value) {
            String pattern = r"\b[a-zA-Z]";
            RegExp nameregExp = RegExp(pattern);
            return nameregExp.hasMatch(value ?? '') ? null : 'Nombre no válido';
          }
        ),
      ),
    );
  }

  //-------------------------------------------------------------------------------
  Widget _registerButton() {
    return Container(
      width: double.infinity,
      height: 50,
      margin: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
      child: MaterialButton(
        shape: RoundedRectangleBorder( borderRadius: BorderRadius.circular(15) ),
        color: AppColors.colors.secondaryContainer,
        //onPressed: () => scheduleController.voidschedule(),
        onPressed: () {
          classController.voidClass();
          scheduleController.voidschedule();
        },
        child: const Text(
          'Registrar Materia',
          // style: TextStyle(color: Colors.indigo),
        ),
      ),
    );
  }
} //Fin Class
