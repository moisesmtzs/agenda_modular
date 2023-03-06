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
    "07:00","07:30","08:00","08:30","09:00","09:30","10:00","10:30","11:00","11:30","12:00","12:30","13:00","13:30","14:00","14:30","15:00","15:30","16:00","16:30","17:00","17:30","18:00","18:30","19:00","19:30","20:00","20:30","21:00","21:30","22:00"
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

  List<DropdownMenuItem<String>> _dropDownItems() {
    //Recuperamos las categorias para mostrar en un dropdown
    List<DropdownMenuItem<String>> list = [];
    for (var subject in claseController.subjects) {
      list.add(DropdownMenuItem(
        child: Text(subject?.name ?? ''),
        value: subject?.id,
      ));
      //debugPrint(subjects?.name.toString());
    }
    return list;
  }

  Widget _begin() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 50, vertical: 10),
      padding: const EdgeInsets.symmetric(horizontal: 80, vertical: 5),
      decoration: BoxDecoration(
        color: AppColors.colors.primaryContainer,
        borderRadius: BorderRadius.circular(15)
      ),
      child: DropdownButton(
        dropdownColor: AppColors.colors.onSecondary,
        borderRadius: BorderRadius.circular(16),
        alignment: Alignment.center,
        menuMaxHeight: 400,
        hint: const Text("Hora de Inicio"),
        value: claseController.begineController,
        icon: const Visibility(visible: false, child: Icon(Icons.arrow_drop_down_circle)),
        underline: Container(
          alignment: Alignment.centerRight,
          child: const Icon(Icons.arrow_drop_down_circle)
        ),
        items: items.map((String hora) => DropdownMenuItem<String>(
          value: hora,
          child: Text(hora),
        )).toList(),
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
      margin: const EdgeInsets.symmetric(horizontal: 50, vertical: 10),
      padding: const EdgeInsets.symmetric(horizontal: 80, vertical: 5),
      decoration: BoxDecoration(
        color: AppColors.colors.primaryContainer,
        borderRadius: BorderRadius.circular(15)
      ),
      child: DropdownButton(
        dropdownColor: AppColors.colors.onSecondary,
        borderRadius: BorderRadius.circular(16),
        alignment: Alignment.center,
        menuMaxHeight: 400,
        icon: const Visibility(visible: false, child: Icon(Icons.arrow_drop_down_circle)),
        iconSize: 30,
        hint: const Text("Hora de Fin"),
        value: claseController.endController,
        underline: Container(
          alignment: Alignment.centerRight,
          child: const Icon(Icons.arrow_drop_down_circle)
        ),
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
          title: const Text('lunes'),
          leading: Radio<SingingCharacter>(
            activeColor: AppColors.colors.primary,
            value: SingingCharacter.lunes,
            groupValue: _character,
            onChanged: (SingingCharacter? value) {
              setState(() {
                _character = value;
                claseController.daysController = 'lunes';
              });
            },
          ),
        ),
        ListTile(
          title: const Text('martes'),
          leading: Radio<SingingCharacter>(
            activeColor: AppColors.colors.primary,
            value: SingingCharacter.martes,
            groupValue: _character,
            onChanged: (SingingCharacter? value) {
              setState(() {
                _character = value;
                claseController.daysController = 'martes';
              });
            },
          ),
        ),
        ListTile(
          title: const Text('miercoles'),
          leading: Radio<SingingCharacter>(
            activeColor: AppColors.colors.primary,
            value: SingingCharacter.miercoles,
            groupValue: _character,
            onChanged: (SingingCharacter? value) {
              setState(() {
                _character = value;
                claseController.daysController = 'miercoles';
              });
            },
          ),
        ),
        ListTile(
          title: const Text('jueves'),
          leading: Radio<SingingCharacter>(
            activeColor: AppColors.colors.primary,
            value: SingingCharacter.jueves,
            groupValue: _character,
            onChanged: (SingingCharacter? value) {
              setState(() {
                _character = value;
                claseController.daysController = 'jueves';
              });
            },
          ),
        ),
        ListTile(
          title: const Text('viernes'),
          leading: Radio<SingingCharacter>(
            activeColor: AppColors.colors.primary,
            value: SingingCharacter.viernes,
            groupValue: _character,
            onChanged: (SingingCharacter? value) {
              setState(() {
                _character = value;
                claseController.daysController = 'viernes';
              });
            },
          ),
        ),
        ListTile(
          title: const Text('sabado'),
          leading: Radio<SingingCharacter>(
            activeColor: AppColors.colors.primary,
            value: SingingCharacter.sabado,
            groupValue: _character,
            onChanged: (SingingCharacter? value) {
              setState(() {
                _character = value;
                claseController.daysController = 'sabado';
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
        shape: RoundedRectangleBorder( borderRadius: BorderRadius.circular(15) ),
        disabledColor: Colors.grey,
        color: AppColors.colors.secondaryContainer,
        child: Container(
          padding: const EdgeInsets.symmetric( horizontal: 30, vertical: 15 ),
          child: const Text(
            'Registrar Materia',
          ),
        ),
        onPressed: () {
          //claseController.daysController = finaldays;
          claseController.register(context);
        },
      ),
    );
  }
} //Fin Class
