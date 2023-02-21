import 'package:agenda_app/src/screens/tasks/update/task_update_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:agenda_app/src/models/task.dart';
import 'package:agenda_app/src/ui/app_colors.dart';

class TaskUpdatePage extends StatelessWidget {

  TaskUpdatePage({Key? key, required this.task}) : super(key: key);

  late Task? task;
  late TaskUpdateController taskUpdateController = Get.put(TaskUpdateController(task!));

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
            icon: Icon(Icons.check_rounded, size: 30, color: AppColors.colors.onPrimary),
            label: Text('Actualizar tarea', style: TextStyle(fontSize: 20, color: AppColors.colors.onPrimary)),
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
              taskUpdateController.updateTask(context);
            },
          ),
          const SizedBox(height: 25),
          _taskName(),
          const SizedBox(height: 20),
          _taskDesc(),
          const SizedBox(height: 20),
          _taskDate(context),
          const SizedBox(height: 20),
          _taskSubject(),
          const SizedBox(height: 20),
          _taskType()
        ] 
      ),

    );
  }

  Widget _taskName() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 25),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppColors.colors.inversePrimary,
        borderRadius: BorderRadius.circular(15)
      ),
      child: Form(
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Column(
          children: [
            TextFormField(
              controller: taskUpdateController.nameController,
              cursorRadius: const Radius.circular(8.0),
              maxLength: 180,
              decoration: const InputDecoration(
                hintText: "Hacer maqueta",
                labelText: "Nombre de la tarea",
                suffixIcon: Icon(Icons.task_outlined)
              ),
              validator: ( value ){
                String pattern = r"\b([a-zA-ZÀ-ÿ][-,a-z. ']+[ ]*)+";
                RegExp nameregExp  = RegExp(pattern);
                return nameregExp.hasMatch( value ?? '' ) 
                  ? null 
                  : 'Nombre no válido';
              }
            )
          ]
        ),
      ),
    );
    
  }

  Widget _taskDesc() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 25),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppColors.colors.inversePrimary,
        borderRadius: BorderRadius.circular(15)
      ),
      child: Form(
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Column(
          children: [
            TextFormField(
              controller: taskUpdateController.descriptionController,
              maxLines: 3,
              maxLength: 255,
              textAlign: TextAlign.justify,
              cursorRadius: const Radius.circular(8.0),
              decoration: const InputDecoration(
                hintText: "Maqueta de 25x25",
                labelText: "Descripción de la tarea",
                suffixIcon: Icon(Icons.description_outlined)
              ),
              validator: ( value ){
                String pattern = r"\b([a-zA-ZÀ-ÿ][-,a-z. ']+[ ]*)+";
                RegExp nameregExp  = RegExp(pattern);
                return nameregExp.hasMatch( value ?? '' ) 
                  ? null 
                  : 'Descripción no válida';
              }
            )
          ]
        ),
      ),
    );
    
  }

  Widget _taskDate(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppColors.colors.inversePrimary,
        borderRadius: BorderRadius.circular(15) 
      ),
      child: Obx( () =>
        ListTile(
          title: const Text('Fecha de entrega', style: TextStyle(  fontSize: 18 ),),
          subtitle: Text(taskUpdateController.convertDateTimeDisplay(taskUpdateController.value.value),),
          trailing: const Icon( Icons.date_range_outlined ),
          onTap: () {
            taskUpdateController.showDatePick(context);
          },
        ),
      )
    );
  }

  Widget _taskSubject() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 25),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppColors.colors.inversePrimary,
        borderRadius: BorderRadius.circular(15)
      ),
      child: Obx(() => DropdownButton(
        hint: const Text('Selecciona una materia'),
        isExpanded: true,
        dropdownColor: AppColors.colors.primaryContainer,
        borderRadius: BorderRadius.circular(12),
        icon: const Icon(Icons.arrow_drop_down_circle_rounded),
        value: taskUpdateController.subjectSelected.value,
        items: _dropDownSubjects(),
        onChanged: (String? value) {
          taskUpdateController.subjectSelected.value = value!;
        },
      ),)
    );
    
  }

  Widget _taskType() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 25),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppColors.colors.inversePrimary,
        borderRadius: BorderRadius.circular(15)
      ),
      child: Obx(() => DropdownButton(
        hint: const Text('Tipo de tarea'),
        isExpanded: true,
        dropdownColor: AppColors.colors.primaryContainer,
        borderRadius: BorderRadius.circular(12),
        icon: const Icon(Icons.arrow_drop_down_circle_rounded),
        value: taskUpdateController.typeSelected.value,
        items: _dropDownItems(taskUpdateController.typeList),
        onChanged: (String? value) {
          taskUpdateController.typeSelected.value = value!;
        },
      ),)
    );
    
  }

  List<DropdownMenuItem<String>> _dropDownItems(List<String> types) {
    List<DropdownMenuItem<String>> list = [];
    for (var type in types) {
      list.add(DropdownMenuItem(
        child: Text(type),
        value: type,
      ));
    }
    return list;
  }

  List<DropdownMenuItem<String>> _dropDownSubjects() {
    List<DropdownMenuItem<String>> list = [];
    for (var subject in taskUpdateController.subjectList) {
      list.add(DropdownMenuItem(
        child: Text(subject!.name ?? ''),
        value: subject.name,
      ));
    }
    return list;
  } 

}