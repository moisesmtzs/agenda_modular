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
//PROVIDERS//
import '../models/connectivity.dart';
import '../providers/subjectProvider.dart';
import '../providers/tasksProvider.dart';

class db
{
  //PROVIDERS//
  TasksProvider tasksProvider = TasksProvider();
  SubjectProvider subjectProvider = SubjectProvider();

  //USER SESSION//
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

        await db.execute(
          "CREATE TABLE sql_commands (command TEXT)"
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
    //ALMACENAR LOS SQL//
    var sqTable = "INSERT INTO sql_commands values (\"${sql}\")";
    result = await database.rawInsert(sqTable);
    return result;
  }

  //UPDATE//
  static Future<int?> updateSubject(Subject newSubject) async
  {
    //NOS ASEGURAMOS QUE LA BD ESTE CREADA//
    Database database = await openDB();
    //OBTENEMOS LA FECHA DE ACTUAL PARA LOS CAMPOS CREATED_AT Y UPDATED_AT//
    var today = DateTime.now().toString();
    //CONSTRUIMOS EL SQL//
    var sql = "UPDATE subject SET name = '${newSubject.name}', subject_code = '${newSubject.subject_code}', professor_name = '${newSubject.professor_name}', updated_at = '${today}' WHERE id = ${newSubject.id}";
    //EJECUTAMOS EL SQL//
    var result = await database.rawUpdate(sql);
    //ALMACENAR LOS SQL//
    var sqTable = "INSERT INTO sql_commands values (\"${sql}\")";
    result = await database.rawInsert(sqTable);
    return result;
  }

  //DELETE//
  static Future<int?> deleteSubject(String idSubject) async {

    Database database = await openDB();

    var sql = "DELETE FROM subject WHERE id = $idSubject";

    var result = await database.rawDelete(sql);

    //ALMACENAR LOS SQL//
    var sqTable = "INSERT INTO sql_commands values (\"${sql}\")";
    result = await database.rawInsert(sqTable);

    return result;

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

  //ELIMINAR TODOS//
  static Future<int?> deleteAllSubjects() async {

    Database database = await openDB();

    var sql = "DELETE FROM subject";

    var result = await database.rawDelete(sql);

    return result;

  }

  //-------------------------------------------------------------------------------------------------------------------//


  //----------------------------------------------------- <CLASE> -----------------------------------------------------//
  //-------------------------------------------------------------------------------------------------------------------//


  //----------------------------------------------------- <TAREA> -----------------------------------------------------//
  //OBTENER TODOS//
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
  
  //OBTENER POR STATUS//
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
  
  //INSERT//
  static Future<int?> insertTask(Task task) async {
    
    Database database = await openDB();
    
    var today = DateTime.now().toString();
    
    var sql = "INSERT INTO tasks(id_user, name, description, delivery_date, subject, type, status, created_at, updated_at) VALUES ( ${task.idUser}, '${task.name}', '${task.description}', '${task.deliveryDate}', '${task.subject}', '${task.type}', '${task.status}', '$today', '$today')";

    var result = await database.rawInsert(sql);

    //ALMACENAR LOS SQL//
    var sqTable = "INSERT INTO sql_commands values (\"${sql}\")";
    result = await database.rawInsert(sqTable);
    
    return result;

  }

  //UPDATE//
  static Future<int?> updateTaskStatus(String idTask, String status) async {

    Database database = await openDB();

    var today = DateTime.now().toString();

    var sql = "UPDATE tasks SET status = '$status', updated_at = '$today' WHERE id = $idTask";

    var result = await database.rawUpdate(sql);

    //ALMACENAR LOS SQL//
    var sqTable = "INSERT INTO sql_commands values (\"${sql}\")";
    result = await database.rawInsert(sqTable);

    return result;

  }

  //DELETE//
  static Future<int?> deleteTask(String idTask) async {

    Database database = await openDB();

    var sql = "DELETE FROM tasks WHERE id = $idTask";

    var result = await database.rawDelete(sql);

    //ALMACENAR LOS SQL//
    var sqTable = "INSERT INTO sql_commands values (\"${sql}\")";
    result = await database.rawInsert(sqTable);

    return result;

  }

  //ELIMINAR TODOS//
  static Future<int?> deleteAllTasks() async {

    Database database = await openDB();

    var sql = "DELETE FROM tasks";

    var result = await database.rawDelete(sql);

    return result;

  }
  //-------------------------------------------------------------------------------------------------------------------//

  //-------------------------------------------------- <COMMANDS> -----------------------------------------------------//
  //LIMPIAR TODAS LAS TABLAS//
  static void clearAll() async 
  {
    //VACIAR TODAS LAS TABLAS//
    deleteAllTasks();
    deleteAllSubjects();
    deleteCommands();
  }

  //OBTENER TODOS LOS COMANDOS//
  static Future<List<String>> getAllCommands() async
  {
    Database database = await openDB();
    List<String> sCommands = [];
    final List<Map<String, dynamic>> commandsList = await database.query('sql_commands');
    for(int i = 0; i<commandsList.length; i++)
    {
      sCommands.add(commandsList[i]['command']);
    }
    return sCommands;
  }

  //LIMPIAR LISTA DE COMANDOS//
  static Future<int?> deleteCommands() async {

    Database database = await openDB();

    var sql = "DELETE FROM sql_commands";

    var result = await database.rawDelete(sql);

    return result;

  }
  //-------------------------------------------------------------------------------------------------------------------//

  //--------------------------------------------------- <REPLICA> -----------------------------------------------------//
  

  //-------------------------------------------------------------------------------------------------------------------//
}

  void createReplica() async
  {
    Connect connectivity = Connect();

    connectivity.getConnectivity();

    if(connectivity.isConnected == false)
    {
      print("No ha sido posible generar la replica ya que no se encuentra conectado a Internet");
      return;
    }
    
    print("Generando replica");

    //PROVIDERS//
    TasksProvider tasksProvider = TasksProvider();
    SubjectProvider subjectProvider = SubjectProvider();

    //USER SESSION//
    User userSession = User.fromJson(GetStorage().read('user') ?? {});

    //VACIAMOS TODAS LAS TABLAS//
    db.clearAll();

    //RECUPERAMOS LOS OBJETOS DEL PROVIDER//

    //TAREAS//
    List<Task?> tasks = [];
    tasks = await tasksProvider.getByUserAndStatus(userSession.id ?? '0', "COMPLETADO");

    for(int i = 0; i < tasks.length; i++)
    {
      db.insertTask(tasks[i]!);
    }

    tasks = await tasksProvider.getByUserAndStatus(userSession.id ?? '0', "PENDIENTE");

    for(int i = 0; i < tasks.length; i++)
    {
      db.insertTask(tasks[i]!);
    }

    //MATERIAS//
    List<Subject?> subjects = [];
    subjects = await subjectProvider.findByUser(userSession.id ?? '0');

    for(int i = 0; i < subjects.length; i++)
    {
      db.insertSubject(subjects[i]!);
    }

    //CLASE//
    
  }