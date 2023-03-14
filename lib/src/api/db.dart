import 'dart:async';
import 'dart:io';
import 'package:get_storage/get_storage.dart';
import 'package:path_provider/path_provider.dart';
//MODELOS//
import 'package:agenda_app/src/models/subject.dart';
import 'package:agenda_app/src/models/task.dart';
import 'package:agenda_app/src/models/user.dart';
//SQLITE//
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class db
{
  
  User userSession = User.fromJson(GetStorage().read('user') ?? {});

  //CONSTRUCTOR DE LA BASE DE DATOS//
  static Future<Database> openDB() async
  {
    return openDatabase(join(await getDatabasesPath(),'tot.db'),
      onCreate: (db, version) async
      {
        await db.execute(
          "CREATE TABLE subject (id INTEGER PRIMARY KEY,id_user INTEGER,name TEXT,subject_code TEXT,professor_name TEXT,created_at TEXT,updated_at TEXT)"    
        );

        await db.execute(
          "CREATE TABLE tasks (id INTEGER PRIMARY KEY, id_user INTEGER, name TEXT, description TEXT, delivery_date TEXT, subject TEXT, type TEXT, status TEXT, created_at TEXT, updated_at TEXT)"
        );

      }, version: 1);
  }

  //---------------------------------------------------- <MATERIA> ----------------------------------------------------//
  //INSERT//
  static Future<int?> insertSubject(Subject newSubject) async
  {
    //NOS ASEGURAMOS QUE LA BD ESTE CREADA//
    Database database = await openDB();
    //OBTENEMOS LA FECHA DE ACTUAL PARA LOS CAMPOS CREATED_AT Y UPDATED_AT//
    var today = DateTime.now().toString();
    //CONSTRUIMOS EL SQL//
    var sql = "INSERT INTO subject(id_user, name, subject_code, professor_name, created_at, updated_at) VALUES ( ${newSubject.id_user}, '${newSubject.name}', '${newSubject.subject_code}', '${newSubject.professor_name}', '${today}', '${today}')";
    //EJECUTAMOS EL SQL//
    var result = await database.rawInsert(sql);
    return result;
    //return database.insert('subject', newSubject.toLocalBD());
    //ALMACENAREMOS EL SQL EN UN ARCHIVO//

  }

  //OBTENER TODOS//
  static Future<List<Subject>> selectSubject() async
  {
    //NOS ASEGURAMOS QUE LA BD ESTE CREADA//
    Database database = await openDB();
    //OBTENEMOS TODOS LOS ELEMENTOS DE LA TABLA INDICADA//
    final List<Map<String, dynamic>> subjectList  = await database.query('subject');
    //RECORREMOS CADA ELEMENTO PARA CONSTRUIR EL OBJETO SUBJECT POR CADA UNO//
    return List.generate(subjectList.length, (i) => Subject(
      id: subjectList[i]['id'].toString(),
      id_user: subjectList[i]['id_user'].toString(),
      name: subjectList[i]['name'],
      subject_code: subjectList[i]['subject_code'],
      professor_name: subjectList[i]['professor_name'],
    ));
  }

  static Future<List<Subject?>> getSubjectsByUser() async {

    Database database = await openDB();

    final List<Map<String, dynamic>> subjectList = await database.query('tasks', where: 'id_user = ?', whereArgs: [db().userSession.id]);

    return List.generate(subjectList.length, (i) => Subject(
      id: subjectList[i]['id'].toString(),
      id_user: subjectList[i]['id_user'].toString(),
      name: subjectList[i]['name'],
      subject_code: subjectList[i]['subject_code'],
      professor_name: subjectList[i]['professor_name'],
    ));

  }

  //-------------------------------------------------------------------------------------------------------------------//


  //----------------------------------------------------- <CLASE> -----------------------------------------------------//
  //-------------------------------------------------------------------------------------------------------------------//


  //----------------------------------------------------- <TAREA> -----------------------------------------------------//

  static Future<List<Task?>> getTasks() async {

    Database database = await openDB();

    final List<Map<String, dynamic>> taskList = await database.query('tasks', where: 'id_user = ?', whereArgs: [db().userSession.id]);

    return List.generate(taskList.length, (i) => Task(
      id: taskList[i]['id'].toString(),
      idUser: taskList[i]['id_user'].toString(),
      name: taskList[i]['name'],
      description: taskList[i]['description'],
      deliveryDate: taskList[i]['delivery_date'],
      subject: taskList[i]['subject'],
      type: taskList[i]['type'],
      status: taskList[i]['status'],
    ));

  }

  static Future<List<Task?>> getTasksByStatus(String status) async {

    Database database = await openDB();

    var sql = "SELECT id, id_user, name, description, delivery_date, subject, type, status "
              "FROM tasks WHERE status = '$status'";

    final List<Map<String, dynamic>> taskList = await database.rawQuery(sql);

    return List.generate(taskList.length, (i) => Task(
      id: taskList[i]['id'].toString(),
      idUser: taskList[i]['id_user'].toString(),
      name: taskList[i]['name'],
      description: taskList[i]['description'],
      deliveryDate: taskList[i]['delivery_date'],
      subject: taskList[i]['subject'],
      type: taskList[i]['type'],
      status: taskList[i]['status'],
    ));

  }

  static Future<int?> insertTask(Task task) async {
    
    Database database = await openDB();
    
    var today = DateTime.now().toString();
    
    var sql = "INSERT INTO tasks(id_user, name, description, delivery_date, subject, type, status, created_at, updated_at) VALUES ( ${task.idUser}, '${task.name}', '${task.description}', '${task.deliveryDate}', '${task.subject}', '${task.type}', '${task.status}', '$today', '$today')";

    var result = await database.rawInsert(sql);
    
    return result;

  }

  static Future<int?> updateTaskStatus(String idTask, String status) async {

    Database database = await openDB();

    var today = DateTime.now().toString();

    var sql = "UPDATE tasks SET status = '$status', updated_at = '$today' WHERE id = $idTask";

    var result = await database.rawUpdate(sql);

    return result;

  }

  static Future<int?> deleteTask(String idTask) async {

    Database database = await openDB();

    var sql = "DELETE FROM tasks WHERE id = $idTask";

    var result = await database.rawDelete(sql);

    return result;

  }



  //-------------------------------------------------------------------------------------------------------------------//

}