import 'dart:async';
import 'dart:io';
import 'package:agenda_app/src/models/query.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
//MODELOS//
import 'package:agenda_app/src/models/subject.dart';
import 'package:agenda_app/src/models/task.dart';
import 'package:agenda_app/src/models/user.dart';
import 'package:agenda_app/src/models/clase.dart';
//SQLITE//
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
//PROVIDERS//
import '../models/connectivity.dart';
import '../providers/subjectProvider.dart';
import '../providers/syncProvider.dart';
import '../providers/tasksProvider.dart';
import '../providers/claseProvider.dart';

class db
{
  //PROVIDERS//
  TasksProvider tasksProvider = TasksProvider();
  SubjectProvider subjectProvider = SubjectProvider();
  ClaseProvider claseProvider = ClaseProvider();

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
          "CREATE TABLE clase (id INTEGER PRIMARY KEY, id_user INTEGER, id_subject INTEGER, begin_hour TEXT, end_hour TEXT, days TEXT, clasroom TEXT, building TEXT, created_at TEXT, updated_at TEXT)"
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

  static Future<int?> insertSubjectSync(Subject newSubject) async
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
  }

  //UPDATE//
  static Future<int?> updateSubject(Subject newSubject) async
  {
    //NOS ASEGURAMOS QUE LA BD ESTE CREADA//
    Database database = await openDB();
    //OBTENEMOS LA FECHA DE ACTUAL PARA LOS CAMPOS CREATED_AT Y UPDATED_AT//
    var today = DateTime.now().toString();
    //OBTENER EL NOMBRE OLD//
    var oldSubject = await database.query('subject', where: 'id = ?', whereArgs: [newSubject.id]);
    String nameOld = "";
    for(int i = 0; i<oldSubject.length; i++)
    {
      nameOld=oldSubject[i]['name'].toString();
    }
    //CONSTRUIMOS EL SQL//
    var sql = "UPDATE subject SET name = '${newSubject.name}', subject_code = '${newSubject.subject_code}', professor_name = '${newSubject.professor_name}', updated_at = '${today}' WHERE id = ${newSubject.id}";
    var sqlTask = "UPDATE tasks SET subject = '${newSubject.name}' WHERE subject = '$nameOld'";
    //EJECUTAMOS EL SQL//
    var result = await database.rawUpdate(sql);
    var resultTrigger = await database.rawUpdate(sqlTask);
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

    var result = await database.delete("subject");
    return result;

  }

  //-------------------------------------------------------------------------------------------------------------------//


  //----------------------------------------------------- <CLASE> -----------------------------------------------------//
  static Future<List<Clase?>> getClase() async {

    Database database = await openDB();
    final List<Map<String, dynamic>> claseList = await database.query('clase', where: 'id_user = ?', whereArgs: [db().userSession.id]);
    return List.generate(claseList.length, (i) => Clase(
      id: claseList[i]['id'].toString(),
      id_user: claseList[i]['id_user'].toString(),
      id_subject: claseList[i]['id_subject'],
      begin_hour: claseList[i]['begin_hour'],
      end_hour: claseList[i]['end_hour'],
      days: claseList[i]['days'],
      classroom: claseList[i]['classroom'],
      building: claseList[i]['building'],
    ));
  }

  static Future<String?> getOneClase(String? idClase) async {

    Database database = await openDB();

    final List<Map<String, dynamic>> claseList = await database.query('clase', where: 'id = ?', whereArgs: [idClase]);
    var created_at = claseList[0]['created_at'].toString();
  
    return created_at;

  }

  static Future<List<Clase>> selectClase() async
  {
    //NOS ASEGURAMOS QUE LA BD ESTE CREADA//
    Database database = await openDB();
    //OBTENEMOS TODOS LOS ELEMENTOS DE LA TABLA INDICADA//
    final List<Map<String, dynamic>> claseList  = await database.query('clase');
    //RECORREMOS CADA ELEMENTO PARA CONSTRUIR EL OBJETO SUBJECT POR CADA UNO//
    return List.generate(claseList.length, (i) => Clase(
      id: claseList[i]['id'].toString(),
      id_user: claseList[i]['id_user'].toString(),
      id_subject: claseList[i]['id_subject'],
      begin_hour: claseList[i]['begin_hour'],
      end_hour: claseList[i]['end_hour'],
      days: claseList[i]['days'],
      classroom: claseList[i]['classroom'],
      building: claseList[i]['building'],
    ));
  }

  //INSERT CLASE
  static Future<int?> insertClase(Clase newClase) async
  {
    //NOS ASEGURAMOS QUE LA BD ESTE CREADA//
    Database database = await openDB();
    //OBTENEMOS LA FECHA DE ACTUAL PARA LOS CAMPOS CREATED_AT Y UPDATED_AT//
    var today = DateTime.now().toString();
    //CONSTRUIMOS EL SQL//
    var sql = "INSERT INTO clase(id_user, id_subject, begin_hour, end_hour, days, classroom, building, created_at, updated_at) VALUES ( ${newClase.id_user}, '${newClase.id_subject}', '${newClase.begin_hour}', '${newClase.end_hour}', '${newClase.days}', '${newClase.classroom}', '${newClase.building}','${today}', '${today}')";
    //EJECUTAMOS EL SQL//
    var result = await database.rawInsert(sql);
    //ALMACENAR LOS SQL//
    var sqTable = "INSERT INTO sql_commands values (\"${sql}\")";
    result = await database.rawInsert(sqTable);
    return result;
  }

  static Future<int?> insertClaseSync(Clase newClase) async
  {
    //NOS ASEGURAMOS QUE LA BD ESTE CREADA//
    Database database = await openDB();
    //OBTENEMOS LA FECHA DE ACTUAL PARA LOS CAMPOS CREATED_AT Y UPDATED_AT//
    var today = DateTime.now().toString();
    //CONSTRUIMOS EL SQL//
    var sql = "INSERT INTO clase(id_user, id_subject, begin_hour, end_hour, days, classroom, building, created_at, updated_at) VALUES ( ${newClase.id_user}, '${newClase.id_subject}', '${newClase.begin_hour}', '${newClase.end_hour}', '${newClase.days}', '${newClase.classroom}', '${newClase.building}','${today}', '${today}')";
    //EJECUTAMOS EL SQL//
    var result = await database.rawInsert(sql);
    return result;
  }

  //UPDATE//
  static Future<int?> updateClase(Clase clase) async {

    Database database = await openDB();

    var today = DateTime.now().toString();

    var sqlBase = "UPDATE clase SET begin_hour = '${clase.begin_hour}', end_hour = '${clase.end_hour}', days = '${clase.days}', classroom = '${clase.classroom}', building = '${clase.building}', updated_at = '$today' WHERE id_user = ${clase.id_user}";
    var sql = sqlBase + "and id = ${clase.id} ";
    var result = await database.rawUpdate(sql);

    var sqlSync = sqlBase + " and created_at = $today";
    var sqlReplica = "INSERT INTO sql_commands values (\"${sqlSync}\")";
    var resultSync = await database.rawInsert(sqlReplica);
    return result;

  }

  //DELETE//
  static Future<int?> deleteClase(Clase? clase) async {

    Database database = await openDB();

    var sqlBase = "DELETE FROM clase WHERE id_user = ${clase!.id_user}";

    var sql = sqlBase + "and id = ${clase.id} ";

    Future<String?> oldClaseCreated = getOneClase(clase.id);
    
    var result = await database.rawDelete(sql);
  
    var sqlSync = sqlBase + " and created_at = $oldClaseCreated";

    //ALMACENAR LOS SQL//
    var sqlReplica = "INSERT INTO sql_commands values (\"${sqlSync}\")";
    var resultSync = await database.rawInsert(sqlReplica);
    
    return result;

  }

  //ELIMINAR TODOS//
  static Future<int?> deleteAllClases() async {

    Database database = await openDB();
    var result = await database.delete("clase");

    return result;

  }

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

  static Future<String?> getOneTask(String? idTask) async {

    Database database = await openDB();

    final List<Map<String, dynamic>> taskList = await database.query('tasks', where: 'id = ?', whereArgs: [idTask]);
    String? created_at = taskList[0]['created_at'];

    return created_at;

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
    //TRANSFORMARMOS LA FECHA DE HOY EN EL FORMATO CORRECTO//
    var today = DateTime.now().toString();
    final DateFormat displayFormater = DateFormat('yyyy-MM-dd HH:mm:ss');
    final DateTime displayDate = displayFormater.parse(today);
    final String formatted = displayFormater.format(displayDate);

    print("FEHCA INSERT SIN FORMATO: "+today);
    print("FECHA INSERT CON FORMATO: "+formatted);

    //INSERTAMOS EL REGISTRO EN LA BASE DE DATOS LOCAL//
    Database database = await openDB();
    
    var sql = "INSERT INTO tasks(id_user, name, description, delivery_date, subject, type, status, created_at, updated_at) VALUES ( ${task.idUser}, '${task.name}', '${task.description}', '${task.deliveryDate}', '${task.subject}', '${task.type}', '${task.status}', '$formatted', '$formatted')";
    var result = await database.rawInsert(sql);

    //ALMACENAR EL COMANDO SQL//
    var sqTable = "INSERT INTO sql_commands values (\"${sql}\")";
    result = await database.rawInsert(sqTable);
    
    return result;
  }

  //INSERT//
  static Future<int?> insertTaskSync(Task task) async {
    
    /*
      OBSERVACIONES:
        - LA FECHA CON LA QUE SE GUARDA LA REPLICA DE LA INFORMACION DEBE SER LA ORIGINAL Y NO LA ACTUAL
          * POSIBLE SOLUCION: CREAR METODO EN LA API PARA OBTENER CREATED_AT Y UPDATED_AT POR ID
    */
    var today = DateTime.now().toString();
    final DateFormat displayFormater = DateFormat('yyyy-MM-dd HH:mm:ss');
    final DateTime displayDate = displayFormater.parse(today);
    final String formatted = displayFormater.format(displayDate);

    Database database = await openDB();
    
    var sql = "INSERT INTO tasks(id, id_user, name, description, delivery_date, subject, type, status, created_at, updated_at) VALUES ( ${task.id}, ${task.idUser}, '${task.name}', '${task.description}', '${task.deliveryDate}', '${task.subject}', '${task.type}', '${task.status}', '$formatted', '$formatted')";
    
    var result = await database.rawInsert(sql);

    print("REPLICA: "+sql);
    
    return result;

  }

  static Future<int?> updateTask(Task task) async {
    /*
      OBSERVACIONES:
        - MANTENER PERSISTENCIA DE LA FECHA DE CREACION ENTRE LA BASE DE DATOS GLOBAL Y LA REPLICA
    */
    var today = DateTime.now().toString();

    final DateFormat displayFormater = DateFormat('yyyy-MM-dd HH:mm:ss');
    final DateTime displayDate = displayFormater.parse(today);
    final String formatted = displayFormater.format(displayDate);

    print("FECHA DE ACTUALIZACION SIN FORMATO: "+today);
    print("FECHA DE ACTUALIZACION CON FORMATO: "+formatted);

    Database database = await openDB();

    var sqlBase = "UPDATE tasks SET name = '${task.name}', description = '${task.description}', delivery_date = '${task.deliveryDate}', subject = '${task.subject}', type = '${task.type}', status = '${task.status}', updated_at = '$formatted' WHERE id_user = ${task.idUser}";

    var sql = sqlBase + " and id = ${task.id} ";
    var result = await database.rawUpdate(sql);

    String? createdAt = await getOneTask(task.id);

    print("FECHA DE CREACION OBTENIDA: "+createdAt!);

    var sqlSync = sqlBase + " and created_at = $createdAt";
    var sqlReplica = "INSERT INTO sql_commands values (\"$sqlSync\")";

    await database.rawInsert(sqlReplica);

    return result;

  }

  static Future<int?> updateTaskStatus(String idTask, String status) async {

    var today = DateTime.now().toString();
    final DateFormat displayFormater = DateFormat('yyyy-MM-dd HH:mm:ss');
    final DateTime displayDate = displayFormater.parse(today);
    final String formatted = displayFormater.format(displayDate);

    Database database = await openDB();

    var sqlBase = "UPDATE tasks SET status = '$status', updated_at = '$formatted' WHERE id_user = ${db().userSession.id}";

    var sql = sqlBase + " and id = $idTask";

    var result = await database.rawUpdate(sql);

    String? createdAt = await getOneTask(idTask);

    var sqlSync = sqlBase + " and created_at = $createdAt";
    var sqlReplica = "INSERT INTO sql_commands values (\"$sqlSync\")";
    
    await database.rawInsert(sqlReplica);

    return result;

  }

  //DELETE//
  static Future<int?> deleteTask(Task? task) async {

    Database database = await openDB();

    var sqlBase = "DELETE FROM tasks WHERE id_user = ${task!.idUser}";

    var sql = sqlBase + " and id = ${task.id} ";

    String? oldTaskCreated = await getOneTask(task.id);
    
    var result = await database.rawDelete(sql);
  
    var sqlSync = sqlBase + " and created_at = $oldTaskCreated";

    //ALMACENAR LOS SQL//
    var sqlReplica = "INSERT INTO sql_commands values (\"${sqlSync}\")";
    var resultSync = await database.rawInsert(sqlReplica);
    
    return result;

  }

  //ELIMINAR TODOS//
  static Future<int?> deleteAllTasks() async {

    Database database = await openDB();
    var result = await database.delete("tasks");

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
    deleteAllClases();
    deleteCommands();

    createReplica();
  }

  //OBTENER TODOS LOS COMANDOS//
  static Future<List<Query>> getAllCommands() async
  {
    Database database = await openDB();

    final List<Map<String, dynamic>> commandsList = await database.query('sql_commands');

    return List.generate(commandsList.length, (i) => Query(
      command: commandsList[i]['command'],
    ));
  }

  //LIMPIAR LISTA DE COMANDOS//
  static Future<int?> deleteCommands() async {

    Database database = await openDB();

    var result = await database.delete("sql_commands");

    return result;

  }
  //-------------------------------------------------------------------------------------------------------------------//

  
}
  //--------------------------------------------------- <REPLICA> -----------------------------------------------------//
  void createReplica() async
  {

      print("INICIANDO REPLICA");

      //PROVIDERS//
      TasksProvider tasksProvider = TasksProvider();
      SubjectProvider subjectProvider = SubjectProvider();
      ClaseProvider claseProvider = ClaseProvider();

      //USER SESSION//
      User userSession = User.fromJson(GetStorage().read('user') ?? {});

      //RECUPERAMOS LOS OBJETOS DEL PROVIDER//

      //TAREAS//
      List<Task?> tasks = [];
      tasks = await tasksProvider.getByUserAndStatus(userSession.id ?? '0', "COMPLETADO");

      for(int i = 0; i < tasks.length; i++)
      {
        db.insertTaskSync(tasks[i]!);
      }

      tasks = await tasksProvider.getByUserAndStatus(userSession.id ?? '0', "PENDIENTE");

      for(int i = 0; i < tasks.length; i++)
      {
        db.insertTaskSync(tasks[i]!);
      }

      //MATERIAS//
      List<Subject?> subjects = [];
      subjects = await subjectProvider.findByUser(userSession.id ?? '0');

      for(int i = 0; i < subjects.length; i++)
      {
        db.insertSubjectSync(subjects[i]!);
      }

    //CLASE//
    List<Clase?> clases = [];
      clases = await claseProvider.findByUser(userSession.id ?? '0');//aquiii

      for(int i = 0; i < clases.length; i++)
      {
        db.insertClaseSync(clases[i]!);
      }

    print("REPLICA FINALIZADA");
  }
  //-------------------------------------------------------------------------------------------------------------------//

  //------------------------------------------------ <SINCRONIZACION> -------------------------------------------------//
  void createSync() async
  {
      print("INICIA LA SINCRONIZACION");

      //PROVIDERS//
      SyncProvider syncProvider = SyncProvider();

      //USER SESSION//
      User userSession = User.fromJson(GetStorage().read('user') ?? {});

      List<Query> command = await db.getAllCommands();

      for(int i = 0; i<command.length; i++)
      {
        syncProvider.create(command[i]);
      }

      db.clearAll();

      print("SINCRONIZACION FINALIZADA");
      

  }
  //-------------------------------------------------------------------------------------------------------------------//