import 'package:agenda_app/src/screens/screens.dart';
import 'package:flutter/material.dart';
import "dart:io";

import 'package:get/get.dart';

import 'package:agenda_app/src/widgets/auth_background.dart';
import 'package:agenda_app/src/widgets/card_container.dart';
import 'package:agenda_app/src/ui/input_decoration.dart';
import 'package:agenda_app/src/screens/registersubject/registersubject_controller.dart';

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
        floatingActionButton: FloatingActionButton(
            elevation: 0,
            backgroundColor: const Color.fromARGB(0, 254, 254, 254),
            child: const Icon(Icons.arrow_back_ios_new_rounded),
            onPressed: () => Get.back()),
        floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
        body: AuthBackground(
            child: SingleChildScrollView(
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                physics: const BouncingScrollPhysics(),
                child: Column(
                  children: [
                    SizedBox(height: MediaQuery.of(context).size.height * 0.25),
                    CardContainer(
                        child: Column(
                      children: [
                        const SizedBox(height: 10),
                        Text('Crear materia',
                            style: Theme.of(context).textTheme.headline4),
                        const SizedBox(height: 30),
                        _registerForm(context)
                      ],
                    )),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.03),
                  ],
                ))));
  }

  Widget _registerForm(BuildContext context) {
    return Form(
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Column(children: [
          _textName(),
          _textCodeSubject(),
          _textProfesorsName(),
          _begin(),
          _end(),
          _days(),
          _clasroom(),
          _building(),
          const SizedBox(
            height: 25,
          ),
          _registerButton(),
        ]));
  }

  //------------------CLASS---------------------------------------------
  Widget _textName() {
    return TextFormField(
        controller: classController.nameClassController, ////<----
        cursorRadius: const Radius.circular(8.0),
        autocorrect: false,
        keyboardType: TextInputType.name,
        decoration: InputDecorations.authInputDecoration(
            hintText: "Matematicas",
            labelText: "Nombre Materia",
            prefixIcon: Icons.perm_identity_sharp),
        validator: (value) {
          String pattern = r"\b([a-zA-ZÀ-ÿ][-,a-z. ']+[ ]*)+";
          RegExp nameregExp = RegExp(pattern);
          return nameregExp.hasMatch(value ?? '') ? null : 'Nombre no válido';
        });
  }

  Widget _textCodeSubject() {
    return TextFormField(
        controller: classController.codeClassController,
        cursorRadius: const Radius.circular(8.0),
        autocorrect: false,
        keyboardType: TextInputType.number,
        decoration: InputDecorations.authInputDecoration(
            hintText: "5909",
            labelText: "Codigo Materia",
            prefixIcon: Icons.numbers),
        validator: (value) {
          String pattern = r"\b[0-9]";
          RegExp nameregExp = RegExp(pattern);
          return nameregExp.hasMatch(value ?? '') ? null : 'Codigo no válido';
        });
  }

  Widget _textProfesorsName() {
    return TextFormField(
        controller: classController.profesorClassController,
        cursorRadius: const Radius.circular(8.0),
        autocorrect: false,
        keyboardType: TextInputType.name,
        decoration: InputDecorations.authInputDecoration(
            hintText: "Marcos",
            labelText: "Nombre Profesor",
            prefixIcon: Icons.perm_identity_sharp),
        validator: (value) {
          String pattern = r"\b([a-zA-ZÀ-ÿ][-,a-z. ']+[ ]*)+";
          RegExp nameregExp = RegExp(pattern);
          return nameregExp.hasMatch(value ?? '') ? null : 'Nombre no válido';
        });
  }

  //------------------------SCHEDULE-----------------------------------
  Widget _begin() {
    return DropdownButton(
      hint: Text("Hora de Inicio"),
      alignment: Alignment.topLeft,
      style: const TextStyle(color: Colors.indigo),
      value: scheduleController.begineController,
      icon: const Icon(
        Icons.keyboard_arrow_down,
        color: Colors.indigo,
      ),
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
    );
  }

  Widget _end() {
    return DropdownButton(
      hint: Text("Hora de Fin"),
      alignment: Alignment.topLeft,
      style: const TextStyle(color: Colors.indigo),
      value: scheduleController.endController,
      icon: const Icon(
        Icons.keyboard_arrow_down,
        color: Colors.indigo,
      ),
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
    );
  }

  Widget _days() {
    //  l  m i j v s
    //MODIFICAR------------------
    return TextFormField(
        controller: scheduleController.daysController,
        cursorRadius: const Radius.circular(8.0),
        autocorrect: false,
        keyboardType: TextInputType.text,
        decoration: InputDecorations.authInputDecoration(
            hintText: "l m i j v s",
            labelText: "Dias",
            prefixIcon: Icons.calendar_month),
        validator: (value) {
          String pattern =
              r"^\s*([A-Za-z]{1,}([\.,] |[-']| ))+[A-Za-z]+\.?\s*$";
          RegExp nameregExp = RegExp(pattern);
          return nameregExp.hasMatch(value ?? '') ? null : 'Hora no válido';
        });
  }

  Widget _clasroom() {
    return TextFormField(
        controller: scheduleController.clasroomController,
        cursorRadius: const Radius.circular(8.0),
        autocorrect: false,
        keyboardType: TextInputType.number,
        decoration: InputDecorations.authInputDecoration(
            hintText: "8",
            labelText: "Numero de Salon",
            prefixIcon: Icons.numbers),
        validator: (value) {
          String pattern = r"\b[0-9]";
          RegExp nameregExp = RegExp(pattern);
          return nameregExp.hasMatch(value ?? '') ? null : 'Nombre no válido';
        });
  }

  Widget _building() {
    return TextFormField(
        controller: scheduleController.buildingController,
        cursorRadius: const Radius.circular(8.0),
        autocorrect: false,
        keyboardType: TextInputType.text,
        decoration: InputDecorations.authInputDecoration(
            hintText: "A", labelText: "Edificio", prefixIcon: Icons.abc),
        validator: (value) {
          String pattern = r"\b[a-zA-Z]";
          RegExp nameregExp = RegExp(pattern);
          return nameregExp.hasMatch(value ?? '') ? null : 'Nombre no válido';
        });
  }

  //-------------------------------------------------------------------------------
  Widget _registerButton() {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
      child: ElevatedButton(
        //onPressed: () => scheduleController.voidschedule(),
        onPressed: () {
          classController.voidClass();
          scheduleController.voidschedule();
        },
        child: Text(
          'Registrar Materia',
          style: TextStyle(color: Colors.indigo),
        ),
      ),
    );
  }
} //Fin Class
