import 'package:agenda_app/src/models/subject.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:agenda_app/src/screens/clase/add_clase/add_clase_controller.dart';
import 'package:agenda_app/src/ui/app_colors.dart';

class ClasePage extends StatefulWidget {
  @override
  State<ClasePage> createState() => _ClasePageState();
}

enum SingingCharacter { lunes, martes, miercoles, jueves, viernes, sabado }

class _ClasePageState extends State<ClasePage> {
  List<String> items = <String>[
    '07:00',
    '07:15',
    '07:30',
    '07:45',
    '08:00',
    '08:15',
    '08:30',
    '08:45',
    '09:00',
    '09:15',
    '09:30',
    '09:45',
    '10:00',
    '10:15',
    '10:30',
    '10:45',
    '11:00',
    '11:15',
    '11:30',
    '11:45',
    '12:00',
    '12:15',
    '12:30',
    '12:45',
    '13:00',
    '13:15',
    '13:30',
    '13:45',
    '14:00',
    '14:15',
    '14:30',
    '14:45',
    '15:00',
    '15:15',
    '15:30',
    '15:45',
    '16:00',
    '16:15',
    '16:30',
    '16:45',
    '17:00',
    '17:15',
    '17:30',
    '17:45',
    '18:00',
    '18:15',
    '18:30',
    '18:45',
    '19:00',
    '19:15',
    '19:30',
    '19:45',
    '20:00',
    '20:15',
    '20:30',
    '20:45',
    '21:00',
    '21:15',
    '21:30',
    '21:45',
    '22:00'
  ];

  //Controladores
  ClaseController claseController = Get.put(ClaseController());

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Crear una clase',
          style: TextStyle(fontSize: 24),
        ),
      ),
      body: ListView(
        physics: const ClampingScrollPhysics(),
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        children: [
          _dropDownSubjects(),
          _day(),
          _begin(),
          _end(),
          _clasroom(),
          _building(),
        ],
      ),
      bottomNavigationBar: _registerButton(),
    );
  }

  Widget _dropDownSubjects() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      margin: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
      decoration: BoxDecoration(
          color: AppColors.colors.primaryContainer,
          borderRadius: BorderRadius.circular(15)),
      child: Obx(
        () => DropdownButton(
          dropdownColor: AppColors.colors.onSecondary,
          borderRadius: BorderRadius.circular(16),
          underline: Container(
              alignment: Alignment.centerRight,
              child: const Icon(Icons.arrow_drop_down_circle)),
          elevation: 3,
          isExpanded: true,
          hint: const Text(
            'Seleccionar materia',
            style: TextStyle(color: Colors.black, fontSize: 16),
          ),
          items: _dropDownItems(),
          value: claseController.idsubject.value == ''
              ? null
              : claseController.idsubject.value,
          onChanged: (option) {
            claseController.idsubject.value = option.toString();
          },
        ),
      ),
    );
  }

  List<DropdownMenuItem<String>> _dropDownItems() {
    List<DropdownMenuItem<String>> list = [];
    for (var subject in claseController.subjects) {
      list.add(DropdownMenuItem(
        child: Text(subject?.name ?? ''),
        value: subject?.name,//----
      ));
      //debugPrint(subjects?.name.toString());
    }
    return list;
  }

  Widget _begin() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
      padding: const EdgeInsets.symmetric(horizontal: 80, vertical: 5),
      decoration: BoxDecoration(
          color: AppColors.colors.primaryContainer,
          borderRadius: BorderRadius.circular(15)),
      child: DropdownButton(
        dropdownColor: AppColors.colors.onSecondary,
        borderRadius: BorderRadius.circular(16),
        alignment: Alignment.center,
        menuMaxHeight: 400,
        hint: const Text("Hora de Inicio"),
        value: claseController.begineController,
        icon: const Visibility(
            visible: false, child: Icon(Icons.arrow_drop_down_circle)),
            underline: Container(
              alignment: Alignment.centerRight,
              child: const Icon(Icons.arrow_drop_down_circle)
            ),
        items: items.map((String hora) => DropdownMenuItem<String>(
                  value: hora,
                  child: Text(hora),
                ))
            .toList(),
        onChanged: (option) {
          setState(() {
            claseController.begineController = option.toString();
          });
        },
      ),
    );
  }

  Widget _end() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
      padding: const EdgeInsets.symmetric(horizontal: 80, vertical: 5),
      decoration: BoxDecoration(
          color: AppColors.colors.primaryContainer,
          borderRadius: BorderRadius.circular(15)),
      child: DropdownButton(
        dropdownColor: AppColors.colors.onSecondary,
        borderRadius: BorderRadius.circular(16),
        alignment: Alignment.center,
        menuMaxHeight: 400,
        icon: const Visibility(
            visible: false, child: Icon(Icons.arrow_drop_down_circle)),
        iconSize: 30,
        hint: const Text("Hora de Fin"),
        value: claseController.endController,
        underline: Container(
            alignment: Alignment.centerRight,
            child: const Icon(Icons.arrow_drop_down_circle)),
        items: items
            .map((String hora) => DropdownMenuItem<String>(
                  value: hora,
                  child: Text(hora),
                ))
            .toList(),
        onChanged: (option) {
          setState(() {
            claseController.endController = option.toString();
          });
        },
      ),
    );
  }

  SingingCharacter? _character = SingingCharacter.lunes;
  Widget _day() {
    return Column(
      children: <Widget>[
        ListTile(
          title: const Text('Lunes'),
          leading: Radio<SingingCharacter>(
            activeColor: AppColors.colors.primary,
            value: SingingCharacter.lunes,
            groupValue: _character,
            onChanged: (SingingCharacter? value) {
              setState(() {
                _character = value;
                claseController.daysController = 'Lunes';
              });
            },
          ),
        ),
        ListTile(
          title: const Text('Martes'),
          leading: Radio<SingingCharacter>(
            activeColor: AppColors.colors.primary,
            value: SingingCharacter.martes,
            groupValue: _character,
            onChanged: (SingingCharacter? value) {
              setState(() {
                _character = value;
                claseController.daysController = 'Martes';
              });
            },
          ),
        ),
        ListTile(
          title: const Text('Miércoles'),
          leading: Radio<SingingCharacter>(
            activeColor: AppColors.colors.primary,
            value: SingingCharacter.miercoles,
            groupValue: _character,
            onChanged: (SingingCharacter? value) {
              setState(() {
                _character = value;
                claseController.daysController = 'Miércoles';
              });
            },
          ),
        ),
        ListTile(
          title: const Text('Jueves'),
          leading: Radio<SingingCharacter>(
            activeColor: AppColors.colors.primary,
            value: SingingCharacter.jueves,
            groupValue: _character,
            onChanged: (SingingCharacter? value) {
              setState(() {
                _character = value;
                claseController.daysController = 'Jueves';
              });
            },
          ),
        ),
        ListTile(
          title: const Text('Viernes'),
          leading: Radio<SingingCharacter>(
            activeColor: AppColors.colors.primary,
            value: SingingCharacter.viernes,
            groupValue: _character,
            onChanged: (SingingCharacter? value) {
              setState(() {
                _character = value;
                claseController.daysController = 'Viernes';
              });
            },
          ),
        ),
        ListTile(
          title: const Text('Sábado'),
          leading: Radio<SingingCharacter>(
            activeColor: AppColors.colors.primary,
            value: SingingCharacter.sabado,
            groupValue: _character,
            onChanged: (SingingCharacter? value) {
              setState(() {
                _character = value;
                claseController.daysController = 'Sábado';
              });
            },
          ),
        ),
      ],
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
          controller: claseController.clasroomController,
          cursorRadius: const Radius.circular(8.0),
          autocorrect: false,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            hintText: "8",
            labelText: "Número de Salón",
            prefixIcon: Icon(Icons.numbers)
          ),
          validator: (value) {
            String pattern = r"\b[0-9]";
            RegExp nameregExp = RegExp(pattern);
            return nameregExp.hasMatch(value ?? '')
                ? null
                : 'Nombre no válido';
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
          borderRadius: BorderRadius.circular(15)),
      child: Form(
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: TextFormField(
            controller: claseController.buildingController,
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
    return Container(
      width: double.infinity,
      height: 50,
      margin: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
      child: MaterialButton(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        disabledColor: Colors.grey,
        color: AppColors.colors.secondaryContainer,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
          child: const Text(
            'Registrar Clase',
          ),
        ),
        onPressed: () => {
          claseController.register()
        } 
          // ? () {
          //   //claseController.daysController = finaldays;
          //   claseController.register();
          //   }
          // : null
      ),
    );
  }
} //Fin Class