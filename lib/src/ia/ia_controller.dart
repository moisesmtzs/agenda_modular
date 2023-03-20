import 'dart:ffi';
import 'package:agenda_app/src/models/clase.dart';
import 'package:agenda_app/src/providers/claseProvider.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:get/get.dart';

import 'package:agenda_app/src/models/ia_task.dart';
import 'package:agenda_app/src/models/subject.dart';
import 'package:agenda_app/src/models/task.dart';
import 'package:agenda_app/src/models/user.dart';

import 'package:agenda_app/src/providers/ia_taskProvider.dart';
import 'package:agenda_app/src/providers/subjectProvider.dart';
import 'package:agenda_app/src/providers/tasksProvider.dart';

import 'package:agenda_app/src/ia/text_to_speech.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

import '../models/command.dart';
import '../models/connectivity.dart';
import '../models/response_api.dart';

class IA_Controller
{
  // ----------------------------------ATRIBUTOS IA-------------------------------------------- //
 
  stt.SpeechToText _speech = stt.SpeechToText(); //ENCARGADO DE ESCUCHAR//
  bool _isListening = false; //BOOLEANO QUE DETERMIAN EL ESTADO DE LA VOZ//
  double _confidence = 1.0; //CONFIABILIDAD//

  
  String _stext = "¿En que puedo ayudarte?"; //MENSAJE A ANALIZAR//
  String _text = ""; //MENSAJE AL USUARIO//
  
  VoiceRosalind _voice = new VoiceRosalind(); //ENCARGADO DE HABLAR//

  final ia_taskProvider ia_provider =  Get.put(ia_taskProvider()); //IA PROVIDER//

  List<ia_task?> commandsBD = []; //COMANDOS//

  List<command?> posCommands = []; //POSIBLES COMANDOS//

  List<command?> descartList = []; //LISTA DE COMANDOS DESCARTADOS//

  String newCommand = "";
  
  //BANDERAS//
  bool exist = false;
  bool isNewCommand = false;
  
  //ESTADOS//
  int waitAnswer = -1;
  
  //HORAS//
  String beginHourString = "";
  String endHourString = "";

  // ---------------------------------------------------------------------------------------- //

  // ---------------------------------ATRIBUTOS ACCION--------------------------------------- //
  
  //VARIABLES
  User userSession = User.fromJson(GetStorage().read('user') ?? {});

  //PROVIDERS//
  final SubjectProvider subject_provider =  Get.put(SubjectProvider());
  final TasksProvider task_provider =  Get.put(TasksProvider());
  final ClaseProvider clase_provider = Get.put(ClaseProvider());

  //CONEXION//
  Connect connectivy = Connect();
  
  //ESTADOS//
  int actualType = 0, actualObj = 0, actualProcess = 0;

  //OBJETOS CON LOS QUE TRABAJARA LA IA//
  Task NewTask = new Task();
  Task? taskDb;

  Subject NewSubject = new Subject();
  Subject? subjectDB;

  Clase NewClase = new Clase();
  Clase? claseDB;

  int modCount = 0;

  String NameMateria = "";

  //HORA Y MINUTOS//
  String Hora = "", Minutos = "";
  
  // ---------------------------------------------------------------------------------------- //

  //CONSTRUCTOR//
  IA_Controller() {
    connectivy.getConnectivity();
    _speech = stt.SpeechToText();
    _voice = new VoiceRosalind();
  }

  // ----------------------------------METODO DE BUSQUEDA------------------------------------ //

  //ANALIZAR SI EL COMANDO ES VALIDO//
  void isCommand(String textSpeak) async 
  {
    connectivy.getConnectivity();
    if(connectivy.isConnected == false)
    {
      _voice.speak("Necesitas estar conectado a Internet para utilizar la IA");
      resetIA();
    }
    //CANCELAR ACCION//
    else if(_text.toUpperCase() == "CANCELAR")
    {
      _voice.speak("Cancelando...");
      resetIA();
    }
    else if(actualType != 0 && actualObj != 0)
    {
      executeCommand();
    }
    //SI SE ESPERA UNA RESPUESTA//  
    else if(waitAnswer != -1)
    {
      searchNewCommand();
    }
    else
    {
      //BUSCAR MALAS PALABRAS//
      if(badwords())
      {
        List<String> words = [];
        int cont = _text.length;
        String actualWord="";
        //SEPARAR POR PALABRAS//
        for (var i=0; i<cont; i++)
        {
          if(_text[i]==" "||i==cont-1)
          {
            if(i==cont-1)
            {
              actualWord+=_text[i];
            }
            words.add(actualWord.toUpperCase());
            actualWord="";
          }
          else
          {
            actualWord+=_text[i];
          }
        }
        if(words.length<2)
        {
          _voice.speak("Lo siento, el comando no cuenta con palabras suficientes. Intenta de Nuevo");
          resetIA();
          return;
        }
        //BUSCAMOS EL COMANDO EN LA BD//
        String searchCommand = _text.toUpperCase();
        List<ia_task?> bd_exist = await ia_provider.getByCommand(searchCommand);
        debugPrint("SIZE: "+bd_exist.length.toString());
        //SI EL COMANDO EXISTE//
        if(bd_exist.length>0)
        {
          //INSERTAR TAREA//
          if(bd_exist[0]!.obj=="1" && bd_exist[0]!.type=="1")
          {
            //CAMBIAR A MODO REGISTRAR TAREA//
            actualType=1;
            actualObj=1;
            actualProcess=1;
            NewTask = new Task();
            NewTask.idUser = userSession.id;    
            _voice.speak("Se agregará una nueva Tarea. ¿Cuál es el nombre de la tarea?");
            _stext = "¿Cual es el nombre de la tarea?";
          }
          //MODIFICAR TAREA//
          else if(bd_exist[0]!.obj=="1" && bd_exist[0]!.type=="2")
          {
            //CAMBIAR A MODO MODIFICAR TAREA//
            actualType=2;
            actualObj=1;
            actualProcess=1;
            NewTask = new Task();
            NewTask.idUser = userSession.id;    
            _voice.speak("Se modificara una Tarea. ¿Cuál es el nombre de la Tarea?");
            _stext = "¿Cual es el nombre de la Tarea?";
          }
          //ELIMINAR TAREA//
          else if(bd_exist[0]!.obj=="1" && bd_exist[0]!.type=="3")
          {
            //CAMBIAR A MODO ELIMINAR TAREA//
            actualType=3;
            actualObj=1;
            actualProcess=1;
            NewTask = new Task();
            NewTask.idUser = userSession.id;    
            _voice.speak("Se eliminara una Tarea. ¿Cuál es el nombre de la tarea?");
            _stext = "¿Cual es el nombre de la tarea?";
          }
          //INSERTAR MATERIA//
          else if(bd_exist[0]!.obj=="2" && bd_exist[0]!.type=="1")
          {
            //CAMBIAR A MODO REGISTRAR MATERIA//
            actualType=1;
            actualObj=2;
            actualProcess=1;
            NewSubject = new Subject();
            NewSubject.id_user = userSession.id;    
            _voice.speak("Se agregará una nueva Materia. ¿Cuál es el nombre de la Materia?");
            _stext = "¿Cual es el nombre de la materia?";
          }
          //MODIFICAR MATERIA//
          else if(bd_exist[0]!.obj=="2" && bd_exist[0]!.type=="2")
          {
            //CAMBIAR A MODO ELIMINAR MATERIA//
            actualType=2;
            actualObj=2;
            actualProcess=1;
            NewSubject = new Subject();
            NewSubject.id_user = userSession.id;    
            _voice.speak("Se modificara una Materia. ¿Cuál es el nombre de la Materia?");
            _stext = "¿Cual es el nombre de la Materia?";
          }
          //ELIMINAR MATERIA//
          else if(bd_exist[0]!.obj=="2" && bd_exist[0]!.type=="3")
          {
            //CAMBIAR A MODO ELIMINAR MATERIA//
            actualType=3;
            actualObj=2;
            actualProcess=1;
            NewSubject = new Subject();
            NewSubject.id_user = userSession.id;    
            _voice.speak("Se eliminara una Materia. ¿Cuál es el nombre de la Materia?");
            _stext = "¿Cual es el nombre de la Materia?";
          }
          //INSERTAR CLASE//
          else if(bd_exist[0]!.obj=="3" && bd_exist[0]!.type=="1")
          {
            //CAMBIAR A MODO REGISTRAR CLASE//
            actualType=1;
            actualObj=3;
            actualProcess=1;
            NewClase = new Clase();
            NewClase.id_user = userSession.id;    
            _voice.speak("Se agregará una nueva Clase. ¿De que Materia es la Clase?");
            _stext = "¿De que Materia es la Clase?";
          }
          //ELIMINAR CLASE//
          else if(bd_exist[0]!.obj=="3" && bd_exist[0]!.type=="3")
          {
            //CAMBIAR A MODO ELIMINAR CLASE//
            actualType=3;
            actualObj=3;
            actualProcess=1;
            NewClase = new Clase();
            NewClase.id_user = userSession.id;    
            _voice.speak("Se eliminara Clase. Te pedire la Hora y los Minutos de la Hora de Inicio por separado. ¿A qué Hora es la Clase?");
            _stext = "¿A qué Hora es la Clase?";
            _text = "";
          } 
        }
        else
        {
          //RECUPERAR COMANDOS ALMACENADOS EN LA BD//
          commandsBD = await ia_provider.getAll();
          int commandSize = commandsBD.length, highSim = 0;
          exist = false;posCommands = [];
          //BUSCAR SIMILITUDES//
          for(int iCont = 0; iCont<commandSize; iCont++)
          {
            int numSimil = 0, descarted = 0;
            //POR CADA PALABRA DEL COMANDO ALMACENADO//
            for(int iCont2 = 0; iCont2<words.length; iCont2++)
            {
              //DESCARTAMOS PALABRAS MENORES A 4 LETRAS//
              if(words[iCont2].length>=4)
              {
                //BUSCAR SI LA PALABRA SE ENCUENTRA DENTRO//
                bool? contains = commandsBD[iCont]!.command?.contains(words[iCont2]);
                debugPrint(contains.toString());
                //SI HAY SIMILITUD, AUMENTA EL CONTADOR DE SIMILITUDES//
                if(contains == true)
                {
                  numSimil++;
                }
              }
            }
            //SI LAS SIMILITUDES SON MAYORES O IGUAL AL MAYOR NUMERO DE SIMILITUDES, ALMACENAMOS EL COMANDO//
            if(numSimil>=highSim && numSimil!=0)
            {    
              //SI LAS SIMILITUDES NO SON IGUALES//
              if(numSimil>highSim)
              {
                posCommands.clear();
              }
              //EL NUMERO ACTUAL SE CONVIERTE EN EL NUMERO MAYOR DE SIMILITUDES//
              highSim = numSimil;
              //ALMACENAMOS EL COMANDO//
              command newCommand = new command();
              newCommand.setSimil(highSim);
              newCommand.setTask(commandsBD[iCont]!);
              posCommands.add(newCommand); 
            }
          }
          //SI HAY SOLO UNA SIMILITUD//
          if(posCommands.length == 1)
          {
            //CREAMOS UNA IA TASK//
            ia_task newTask = new ia_task();
            newTask.command = _text.toUpperCase();
            newTask.obj = posCommands[0]!.task!.obj;
            newTask.type = posCommands[0]!.task!.type;
            ia_provider.create(newTask);
            //INSERTAR TAREA//
            if(newTask.obj== "1" && newTask.type=="1")
            {
              //CAMBIAR A MODO REGISTRAR TAREA//
              actualType=1;
              actualObj=1;
              actualProcess=1;
              NewTask = new Task();
              NewTask.idUser = userSession.id;    
              _voice.speak("Se agregará una nueva Tarea. ¿Cuál es el nombre de la tarea?");
              _stext = "¿Cual es el nombre de la tarea?";
              _text = "";
            }
            //MODIFICAR TAREA//
            else if(bd_exist[0]!.obj=="1" && bd_exist[0]!.type=="2")
            {
              //CAMBIAR A MODO MODIFICAR MATERIA//
              actualType=2;
              actualObj=1;
              actualProcess=1;
              NewTask = new Task();
              NewTask.idUser = userSession.id;       
              _voice.speak("Se modificara una Tarea. ¿Cuál es el nombre de la Tarea?");
              _stext = "¿Cual es el nombre de la Tarea?";
              _text = "";
            }
            //ELIMINAR TAREA//
            else if(newTask.obj== "1" && newTask.type== "3")
            {
              //CAMBIAR A MODO ELIMINAR TAREA//
              actualType=3;
              actualObj=1;
              actualProcess=1;
              NewTask = new Task();
              NewTask.idUser = userSession.id;    
              _voice.speak("Se eliminara una Tarea. ¿Cuál es el nombre de la tarea?");
              _stext = "¿Cual es el nombre de la tarea?";
              _text = "";
            }
            //INSERTAR MATERIA//
            else if(newTask.obj == "2" && newTask.type == "1")
            {
              //CAMBIAR A MODO REGISTRAR MATERIA//
              actualType=1;
              actualObj=2;
              actualProcess=1;
              NewSubject = new Subject();
              NewSubject.id_user = userSession.id;    
              _voice.speak("Se agregará una nueva Materia. ¿Cuál es el nombre de la Materia?");
              _stext = "¿Cual es el nombre de la materia?";
              _text = "";
            }
            //MODIFICAR MATERIA//
            else if(bd_exist[0]!.obj=="2" && bd_exist[0]!.type=="2")
            {
              //CAMBIAR A MODO ELIMINAR MATERIA//
              actualType=2;
              actualObj=2;
              actualProcess=1;
              NewSubject = new Subject();
              NewSubject.id_user = userSession.id;    
              _voice.speak("Se modificara una Materia. ¿Cuál es el nombre de la Materia?");
              _stext = "¿Cual es el nombre de la Materia?";
              _text = "";
            }
            //ELIMINAR MATERIA//
            else if(bd_exist[0]!.obj=="2" && bd_exist[0]!.type=="3")
            {
              //CAMBIAR A MODO ELIMINAR MATERIA//
              actualType=3;
              actualObj=2;
              actualProcess=1;
              NewSubject = new Subject();
              NewSubject.id_user = userSession.id;    
              _voice.speak("Se eliminara una Materia. ¿Cuál es el nombre de la Materia?");
              _stext = "¿Cual es el nombre de la Materia?";
              _text = "";
            }
            //INSERTAR CLASE//
            else if(newTask.obj== "3" && newTask.type=="1")
            {
              //CAMBIAR A MODO REGISTRAR TAREA//
              actualType=2;
              actualObj=3;
              actualProcess=1;
              NewClase = new Clase();
              NewClase.id_user = userSession.id;    
              _voice.speak("Se eliminara Clase. Te pedire la Hora y los Minutos de la Hora de Inicio por separado. ¿A qué Hora es la Clase?");
              _stext = "¿A qué Hora es la Clase?";
              _text = "";
            }
            //ELIMINAR CLASE//
            else if(newTask.obj== "3" && newTask.type=="3")
            {
              //CAMBIAR A MODO ELIMINAR CLASE//
              actualType=3;
              actualObj=3;
              actualProcess=1;
              NewClase = new Clase();
              NewClase.id_user = userSession.id;    
              _voice.speak("Se eliminara Clase. Te pedire la Hora y los Minutos de la Hora de Inicio por separado. ¿A qué Hora es la Clase?");
              _stext = "¿A qué Hora es la Clase?";
              _text = "";
            }
            else
            {
              _voice.speak("NO ENTRE A NINGUN IF");
            }
          }
          //SI HAY MAS DE UNA SIMILITUD
          else if(posCommands.length > 1)
          {
            isNewCommand = true;
            newCommand = _text.toUpperCase();
            waitAnswer=0;
            //PRIMER DESCARTE//
            searchNewCommand();

          }
          //SI NO HAY SIMILITUDES//
          else
          {
            _voice.speak("Lo siento, el comando es muy ambiguo");
            resetIA();
          }
          if(posCommands.isNotEmpty)
          {
            debugPrint("COMANDOS CREADOS FINAL: "+posCommands.length.toString());  
            debugPrint("COINCIDENCIAS FINALES: "+posCommands[0]!.simil.toString());
          }
        }
      }
      else
      {
        _voice.speak("Lo siento, no estan permitidas palabras antisonantes. Intenta de Nuevo");
        resetIA();
      } 
    } 
  }

  // ---------------------------------------------------------------------------------------- //

  /*
      TIPOS
        1.- INSERTAR
        2.- MODIFICAR
        3.- ELIMINAR
      
      OBJETOS
        1.- TAREA
        2.- MATERIA
        3.- CLASE
  */

  void searchNewCommand() async
  {
    //ESPERA UN SI O NO// 
    if(waitAnswer != 0)
    {
      debugPrint(_text);
      //SI LA RESPUESTA ES NO//
      if(_text.toUpperCase() == "NO")
      {
        if(posCommands.isNotEmpty)
        {
          debugPrint("EL SIZE ES: "+posCommands.length.toString());
          descartList.add(posCommands[0]);
          posCommands.removeAt(0);
          waitAnswer=0;
          if(posCommands.isNotEmpty)
          {
            posCommands.removeAt(0);
          }
          searchNewCommand();
          debugPrint(posCommands.toString());
        }
        else
        {
          _voice.speak("Lo siento, el comando es muy ambiguo");
          resetIA();
        }
      }
      //SI LA RESPUESTA ES SI//
      else if(_text.toUpperCase() == "SÍ" || _text.toUpperCase() == "SI")
      {
        //INSERTAR TAREA//
        if(waitAnswer==1)
        {
          //CREAMOS UNA IA TASK//
          ia_task newTask = new ia_task();
          newTask.command = newCommand.toUpperCase();
          newTask.obj = posCommands[0]!.task!.obj;
          newTask.type = posCommands[0]!.task!.type;
          ia_provider.create(newTask);
          debugPrint(newTask.toJson().toString());
          //CAMBIAR A MODO REGISTRAR TAREA//
          actualType=1;
          actualObj=1;
          actualProcess=1;
          NewTask = new Task();
          NewTask.idUser = userSession.id;    
          _voice.speak("¿Cual es el nombre de la tarea?");
          _stext = "¿Cual es el nombre de la tarea?";
          _text = "";
        }
        //MODIFICAR MATERIA//
        else if(waitAnswer==4)
        {
          //CREAMOS UNA IA TASK//
          ia_task newTask = new ia_task();
          newTask.command = newCommand.toUpperCase();
          newTask.obj = posCommands[0]!.task!.obj;
          newTask.type = posCommands[0]!.task!.type;
          ia_provider.create(newTask);
          debugPrint(newTask.toJson().toString());
          //CAMBIAR A MODO MODIFICAR TAREA//
          actualType=2;
          actualObj=1;
          actualProcess=1;
          NewTask = new Task();
          NewTask.idUser = userSession.id;       
          _voice.speak("¿Cual es el nombre de la Tarea?");
          _stext = "¿Cual es el nombre de la Tarea?";
          _text = "";
        }
        //ELIMINAR TAREA//
        else if(waitAnswer==7)
        {
          //CREAMOS UNA IA TASK//
          ia_task newTask = new ia_task();
          newTask.command = newCommand.toUpperCase();
          newTask.obj = posCommands[0]!.task!.obj;
          newTask.type = posCommands[0]!.task!.type;
          ia_provider.create(newTask);
          debugPrint(newTask.toJson().toString());
          //CAMBIAR A MODO ELIMINAR TAREA//
          actualType=3;
          actualObj=1;
          actualProcess=1;
          NewTask = new Task();
          NewTask.idUser = userSession.id;    
          _voice.speak("¿Cual es el nombre de la tarea?");
          _stext = "¿Cual es el nombre de la tarea?";
          _text = "";
        }
        //INSERTAR MATERIA//
        else if(waitAnswer==2)
        {
          //CAMBIAR A MODO REGISTRAR MATERIA//
          actualType=1;
          actualObj=2;
          actualProcess=1;
          NewSubject = new Subject();
          NewSubject.id_user = userSession.id;    
          _voice.speak("Se agregará una nueva Materia. ¿Cuál es el nombre de la Materia?");
          _stext = "¿Cual es el nombre de la materia?";
          _text = "";
        }
        //MODIFICAR MATERIA//
        else if(waitAnswer==5)
        {
          //CREAMOS UNA IA TASK//
          ia_task newTask = new ia_task();
          newTask.command = newCommand.toUpperCase();
          newTask.obj = posCommands[0]!.task!.obj;
          newTask.type = posCommands[0]!.task!.type;
          ia_provider.create(newTask);
          debugPrint(newTask.toJson().toString());
          //CAMBIAR A MODO MODIFICAR TAREA//
          actualType=2;
          actualObj=2;
          actualProcess=1;
          NewSubject = new Subject();
          NewSubject.id_user = userSession.id;     
          _voice.speak("¿Cual es el nombre de la Materia?");
          _stext = "¿Cual es el nombre de la Materia?";
          _text = "";
        }
        //ELIMINAR MATERIA//
        else if(waitAnswer==8)
        {
          //CREAMOS UNA IA TASK//
          ia_task newTask = new ia_task();
          newTask.command = newCommand.toUpperCase();
          newTask.obj = posCommands[0]!.task!.obj;
          newTask.type = posCommands[0]!.task!.type;
          ia_provider.create(newTask);
          debugPrint(newTask.toJson().toString());
          //CAMBIAR A MODO ELIMINAR TAREA//
          actualType=3;
          actualObj=2;
          actualProcess = 1;
          NewSubject = new Subject();
          NewSubject.id_user = userSession.id;     
          _voice.speak("¿Cual es el nombre de la Materia?");
          _stext = "¿Cual es el nombre de la Materia?";
          _text = "";
        }
        //INSERTAR CLASE//
        else if(waitAnswer==3)
        {
          //CREAMOS UNA IA TASK//
          ia_task newTask = new ia_task();
          newTask.command = newCommand.toUpperCase();
          newTask.obj = posCommands[0]!.task!.obj;
          newTask.type = posCommands[0]!.task!.type;
          ia_provider.create(newTask);
          debugPrint(newTask.toJson().toString());
          //CAMBIAR A MODO REGISTRAR CLASE//
          actualType=1;
          actualObj=3;
          actualProcess=1;
          NewClase = new Clase();
          NewClase.id_user = userSession.id;    
          _voice.speak("Se agregará una nueva Clase. ¿De que Materia es la Clase?");
          _stext = "¿De que Materia es la Clase?";
          _text = "";
        }
        //ELIMINAR CLASE//
        else if(waitAnswer==9)
        {
          //CREAMOS UNA IA TASK//
          ia_task newTask = new ia_task();
          newTask.command = newCommand.toUpperCase();
          newTask.obj = posCommands[0]!.task!.obj;
          newTask.type = posCommands[0]!.task!.type;
          ia_provider.create(newTask);
          debugPrint(newTask.toJson().toString());
          //CAMBIAR A MODO ELIMINAR CLASE//
          actualType=3;
          actualObj=3;
          actualProcess=1;
          NewClase = new Clase();
          NewClase.id_user = userSession.id;    
          _voice.speak("Se eliminara Clase. Te pedire la Hora y los Minutos de la Hora de Inicio por separado. ¿A qué Hora es la Clase?");
          _stext = "¿A qué Hora es la Clase?";
          _text = "";   
        }
      }
      else
      {
        _voice.speak("Lo siento, solo puedes reponder Si o No");
      }
    }
    else
    {
      if(posCommands.isNotEmpty)
      {
        bool isDelete = false;
        for(int i = 0; i<descartList.length; i++)
        {
          if(posCommands[0]!.task!.type == descartList[i]!.task!.type)
          {
            if(posCommands[0]!.task!.obj == descartList[i]!.task!.obj)
            {
              posCommands.removeAt(0);
              isDelete = true;
            }
          }
        }
        if(isDelete == true)
        {
          searchNewCommand();
        }
        //INSERTAR//
        else if(posCommands[0]!.task!.type == "1")
        {
          //INSERTAR TAREA - waitAnswer: 1//
          if(posCommands[0]!.task!.obj == "1")
          {
            _voice.speak("¿Quieres insertar una Tarea?");
            _stext = "¿Quieres insertar una Tarea?";
            _text = "";
            waitAnswer = 1;
          }
          //INSERTAR MATERIA - waitAnswer: 2//
          else if(posCommands[0]!.task!.obj == "2")
          {
            _voice.speak("¿Quieres insertar una Materia?");
            _stext = "¿Quieres insertar una Materia?";
            _text = "";
            waitAnswer = 2;
          }
          //INSERTAR CLASE - waitAnswer: 3//
          else if(posCommands[0]!.task!.obj == "3")
          {
            _voice.speak("¿Quieres insertar una Clase?");
            _stext = "¿Quieres insertar una Clase?";
            _text = "";
            waitAnswer = 3;
          }
          else
          {
            _voice.speak("Lo siento, el comando es muy ambiguo");
            resetIA();
          }
        }
        //MODIFICAR//
        else if(posCommands[0]!.task!.type == "2")
        {
          //MODIFICAR TAREA - waitAnswer: 4//
          if(posCommands[0]!.task!.obj == "1")
          {
            _voice.speak("¿Quieres modificar una Tarea?");
            _stext = "¿Quieres modificar una Tarea?";
            waitAnswer = 4;
          }
          //MODIFICAR MATERIA - waitAnswer: 5//
          else if(posCommands[0]!.task!.obj == "2")
          {
            _voice.speak("¿Quieres modificar una Materia?");
            _stext = "¿Quieres modificar una Materia?";
            waitAnswer = 5;
          }
          else
          {
            _voice.speak("Lo siento, el comando es muy ambiguo");
            resetIA();
          }
        }
        //ELIMINAR//
        else if(posCommands[0]!.task!.type == "3")
        {
          //ELIMINAR TAREA - waitAnswer: 7//
          if(posCommands[0]!.task!.obj == "1")
          {
            _voice.speak("¿Quieres eliminar una Tarea?");
            _stext = "¿Quieres eliminar una Tarea?";
            _text = "";
            waitAnswer = 7;
          }
          //ELIMINAR MATERIA - waitAnswer: 8//
          else if(posCommands[0]!.task!.obj == "2")
          {
            _voice.speak("¿Quieres eliminar una Materia?");
            _stext = "¿Quieres eliminar una Materia?";
            _text = "";
            waitAnswer = 8;
          }
          //ELIMINAR CLASE - waitAnswer: 9//
          else if(posCommands[0]!.task!.obj == "3")
          {
            _voice.speak("¿Quieres eliminar una Clase?");
            _stext = "¿Quieres eliminar una Clase?";
            waitAnswer = 9;
          }
          else
          {
            _voice.speak("Lo siento, el comando es muy ambiguo");
            resetIA();
          }
        }
        else
        {
          _voice.speak("Lo siento, el comando es muy ambiguo");
          resetIA();
        }
      }
      else
      {
        _voice.speak("Lo siento, el comando es muy ambiguo");
        resetIA();
      }
    }  
  }

  // -----------------------------------METODOS DE CONTROL----------------------------------- //

  //FUNCION PARA DEJAR DE ESCUCHAR//
  void stopListening() 
  {
    _speech.stop();
  }

  //BUSCAR MALAS PALABRAS//
  bool badwords() 
  {
    int sizeText = _text.length;
    //BUSCAR *//
    for (var i = 0; i < sizeText; i++)
    {
      //ENCONTRO UN *//
      if(_text[i]=='*')
      {
        return false;
      }
    }
    return true;
  }

  //REINICIAR IA//
  void resetIA() 
  {
    _text = ""; 
    _stext = "¿En que puedo ayudarte?";
    commandsBD = [];
    posCommands = []; 
    descartList = []; 
    newCommand = "";
    exist = false;
    isNewCommand = false;
    waitAnswer = -1;
    actualType = 0;
    actualObj = 0;
    actualProcess = 0;
    modCount = 0;
    Hora = ""; 
    Minutos="";
    NameMateria="";
  }

  // ------------------------------------SETTERS|GETTERS------------------------------------ //

  //GETTERS//
  String getText()
  {
    return _text;
  }

  String getsText()
  {
    return _stext;
  }

  double getConfidence()
  {
    return _confidence;
  }

  bool getListening()
  {
    return _isListening;
  }

  stt.SpeechToText getSpeech()
  {
    return _speech;
  }

  //SETTERS//
  void setText(String NewText)
  {
    _text = NewText;
  }

  void setsText(String NewText)
  {
    _stext = NewText;
  }

  void setListening(bool NewListening)
  {
    _isListening = NewListening;
  }

  void setConfidence(double NewConfidence)
  {
    _confidence=NewConfidence;
  }

  // ---------------------------------------------------------------------------------------- //


  // ------------------------------------COMANDOS POR VOZ------------------------------------ //
  Future<void> executeCommand()
  async {
    //INSERTAR UNA TAREA//
    if(actualObj == 1 && actualType == 1)
    {
      //NOMBRE//
      if(actualProcess == 1)
      {
        NewTask.name = _text;
        _voice.speak("¿Cual es la descripción de la tarea?");
        _stext = "¿Cual es la descripción de la tarea?";
        _text = "";
        actualProcess++;
      }
      //DESCRIPCION//
      else if(actualProcess == 2)
      {
        NewTask.description = _text;
        _voice.speak("¿Cual es la fecha de entrega de la tarea?");
        _voice.speak("Se claro con la fecha, especifica dia y mes.");
        _stext = "¿Cual es la fecha de entrega de la tarea? (Se claro con la fecha, especifica dia y mes)";
        _text = "";
        actualProcess++;
      }
      //FECHA//
      else if(actualProcess == 3)
      {
        List<String> words = [];
        int cont = _text.length;
        String actualWord="";
        //SEPARAR POR PALABRAS//
        for (var i=0; i<cont; i++)
        {
          if(_text[i]==" "||i==cont-1)
          {
            if(i==cont-1)
            {
              actualWord+=_text[i];
            }
            words.add(actualWord.toUpperCase());
            actualWord="";
          }
          else
          {
            actualWord+=_text[i];
          }
        }
        createDate(words);
        _voice.speak("¿De que materia?");
        _stext = "¿De que materia?";
        _text = "";
        actualProcess++;
      }
      //MATERIA//
      else if(actualProcess == 4)
      {
        //VALIDAR SI EL USUARIO TIENE UNA MATERIA CON ESE NOMBRE//
        String validSubject = "";
        for(int i=0; i<_text.length; i++)
        {
          if(i==0)
          {
            validSubject+=_text[i].toUpperCase();
          }
          else
          {
            validSubject+=_text[i];
          }
        }
        List<Subject?> ActualSubject = await subject_provider.getByName(validSubject, userSession.id.toString());
        if(ActualSubject.length==0)
        {
          _voice.speak("Lo siento, no tienes una materia registrada con ese nombre, intenta con otra o verifica su ortografia.");
          _stext = "¿De que materia?";
          _text = "";
        }
        else
        {
          NewTask.subject = validSubject;
          _voice.speak("¿Es de tipo Examen, Tarea o Actividad?");
          _stext = "¿Es de tipo Examen, Tarea o Actividad?";
          _text = "";
          actualProcess++;
        }
      }
      //TIPO//
      else if(actualProcess == 5)
      {
        String isValidType = _text.toUpperCase();
        if(isValidType == "EXAMEN" || isValidType == "TAREA" || isValidType == "ACTIVIDAD")
        {
          if(isValidType == "EXAMEN")
          {
            NewTask.type="Examen";
          }
          else if(isValidType == "ACTIVIDAD")
          {
            NewTask.type="Actividad";
          }
          else
          {
            NewTask.type="Tarea";
          }
          actualProcess++;
          _voice.speak("A continuación, te muestro la información de la tarea, si es correcta di Guardar para registrarla o Cancelar para descartarla.");
          _stext = "El Nombre es: "+NewTask.name.toString() + "\nLa Descripción es: "+NewTask.description.toString()+"\nLa Fecha es: "+NewTask.deliveryDate.toString()
                + "\nLa Materia es: "+NewTask.subject.toString() + "\nEl Tipo es: "+NewTask.type.toString();
                _text = "";
        }
        else
        {
          _voice.speak("Lo siento, solo puede ser Examen, Tarea o Actividad");
          _stext = "¿Es de tipo Examen, Tarea o Actividad?";
          _text = "";
        }
      }
      //CONFIRMAR//
      else if(actualProcess == 6)
      {
        if(_text.toUpperCase() == "GUARDAR")
        {
          NewTask.status="PENDIENTE";
          _voice.speak("Se guardó la tarea");
          ResponseApi? responseApi = await task_provider.create(NewTask);
          if (responseApi?.success == true)
          {
            _voice.speak("Se guardó la Tarea");
          }
          else
          {
            _voice.speak("Hubo un problema al guardar la Tarea. Verifica los datos o tu conexion a Internet.");
          }
          resetIA();
        }
        else if(_text.toUpperCase() == "CANCELAR")
        {
          _voice.speak("Se ha descartado la tarea");
          NewTask = new Task();
          resetIA();
        }
        else
        {
          _voice.speak("Solo son validas las opciones Guardar o Cancelar.");
          _stext = "El Nombre es: "+NewTask.name.toString() + "\nLa Descripcion es: "+NewTask.description.toString()+"\nLa Fecha es: "+NewTask.deliveryDate.toString()
                 + "\nLa Materia es: "+NewTask.subject.toString() + "\nEl Tipo es: "+NewTask.type.toString();
                 _text = "";
        }
      }
    }
    //MODIFICAR UNA TAREA
    else if(actualObj == 1 && actualType == 2)
    {
      //MODIFICAR LA MATERIA POR NOMBRE//
      if(actualProcess==1)
      {
        NewTask.name = _text.toUpperCase();
        debugPrint(NewTask.name);
        List<Task?> searchTask = await task_provider.getByUserAndName(userSession.id.toString(),NewTask.name.toString());
        if(searchTask.length!=0)
        {
          taskDb = searchTask[0];
          String? TaskName = taskDb?.name.toString();
          _voice.speak("Existe la Tarea, ¿Qué deseas modificar?"); 
          _stext = "Se modificara la Tarea: "+ TaskName!;
          _text = "";
          actualProcess=2;
        }
        else
        {
          _voice.speak("Lo siento, no existe esa Tarea, intenta con otra.");
          resetIA();
        }  
      }
      else if(actualProcess==2)
      {
        //LEER EL CAMPO A MODIFICAR//
        String aux = _text.toUpperCase();
        //NOMBRE//
        if(aux == "NOMBRE")
        {
          _voice.speak("¿Cual es el nuevo Nombre de la Tarea?");
          _stext = "¿Cual es el nuevo Nombre de la Tarea?";
          _text = "";
          actualProcess++;
          modCount = 1;
        }
        //DESCRIPCIÓN//
        else if(aux == "DESCRIPCIÓN")
        {
          _voice.speak("¿Cual es la nueva Descripción de la Tarea?");
          _stext = "¿Cual es el la nueva Descripción de la Tarea?";
          _text = "";
          actualProcess++;
          modCount = 2;
        }
        //FECHA//
        else if(aux == "FECHA" || aux=="FECHA DE ENTREGA")
        {
          _voice.speak("¿Cual es la nueva Fecha de Entrega de la Tarea? (Especifica solo dia y mes)");
          _stext = "¿Cual es la nueva Fecha de Entrega de la Tarea?";
          _text = "";
          actualProcess++;
          modCount = 3;
        }
        //MATERIA//
        else if(aux == "MATERIA")
        {
          _voice.speak("¿Cual es la nueva Materia de la Tarea?");
          _stext = "¿Cual es la nueva Materia de la Tarea?";
          _text = "";
          actualProcess++;
          modCount = 4;
        }
        //TIPO//
        else if(aux == "TIPO")
        {
          _voice.speak("¿Cual es el nuevo Tipo de la Tarea?");
          _stext = "¿Cual es el nuevo Tipo de la Tarea?";
          _text = "";
          actualProcess++;
          modCount = 5;
        }
        //ESTATUS//
        else if(aux == "ESTATUS")
        {
          _voice.speak("¿Cual es el nuevo Estatus de la Tarea?");
          _stext = "¿Cual es el nuevo Estatus de la Tarea?";
          _text = "";
          actualProcess++;
          modCount = 6;
        }
        else
        {
          _voice.speak("Lo siento, la Tarea no cuenta con ese atributo. Intenta con Nombre, Descripción, Fecha, Materia, Tipo o Estatus");
        }
      }
      //ASIGNAR MODIFICACION//
      else if(actualProcess==3)
      {
        if(modCount == 1)
        {
          String? OldName = NewTask.name;
          taskDb!.name = _text;
          _voice.speak("Se modificara el Nombre de la Tarea. Di Guardar para confirmar los cambios o Cancelar para descartarlos.");
          _stext = "Antes: "+OldName!+"\nNuevo: "+taskDb!.name!;
          _text = "";
          actualProcess++;
        }
        else if(modCount == 2)
        {
          taskDb!.description = _text;
          _voice.speak("Se modificara la Descripción de la Tarea. Di Guardar para confirmar los cambios o Cancelar para descartarlos.");
          _stext = "Nueva Descripcion: "+taskDb!.description!;
          _text = "";
          actualProcess++;
        }
        else if(modCount == 3)
        {
          List<String> words = [];
          int cont = _text.length;
          String actualWord="";
          //SEPARAR POR PALABRAS//
          for (var i=0; i<cont; i++)
          {
            if(_text[i]==" "||i==cont-1)
            {
              if(i==cont-1)
              {
                actualWord+=_text[i];
              }
              words.add(actualWord.toUpperCase());
              actualWord="";
            }
            else
            {
              actualWord+=_text[i];
            }
          }
          createDate(words);
          taskDb!.deliveryDate = NewTask.deliveryDate;
          _voice.speak("Se modificara la Fecha de Entrega de la Tarea. Di Guardar para confirmar los cambios o Cancelar para descartarlos.");
          _stext = "Nueva Fecha: "+NewTask.deliveryDate.toString();
          _text = "";
          actualProcess++;
        }
        else if(modCount == 4)
        {
          String? OldSubj = NewTask.subject;
          //VALIDAR SI EL USUARIO TIENE UNA MATERIA CON ESE NOMBRE//
          String validSubject = "";
          for(int i=0; i<_text.length; i++)
          {
            if(i==0)
            {
              validSubject+=_text[i].toUpperCase();
            }
            else
            {
              validSubject+=_text[i];
            }
          }
          List<Subject?> ActualSubject = await subject_provider.getByUserNameIA(userSession.id.toString(), validSubject.toUpperCase());
          if(ActualSubject.length==0)
          {
            _voice.speak("Lo siento, no tienes una materia registrada con ese nombre, intenta con otra o verifica su ortografía.");
            _stext = "¿De que materia?";
            _text = "";
          }
          else
          {
            taskDb!.subject = validSubject;
            _voice.speak("Se modificara la Materia de la Tarea. Di Guardar para confirmar los cambios o Cancelar para descartarlos.");
            _stext = "Nueva Materia: "+taskDb!.subject!;
            _text = "";
            actualProcess++;
          }          
        }
        else if(modCount == 5)
        {
          String? OldType = NewTask.type;
          String isValidType = _text.toUpperCase();
          if(isValidType == "EXAMEN" || isValidType == "TAREA" || isValidType == "ACTIVIDAD")
          {
            if(isValidType == "EXAMEN")
            {
              taskDb!.type="Examen";
            }
            else if(isValidType == "ACTIVIDAD")
            {
              taskDb!.type="Actividad";
            }
            else
            {
              taskDb!.type="Tarea";
            }
            _voice.speak("Se modificara el Tipo de la Tarea. Di Guardar para confirmar los cambios o Cancelar para descartarlos.");
            _stext = "Nuevo Tipo: "+taskDb!.type!;
            _text = "";
            actualProcess++;
          }
          else
          {
            _voice.speak("Lo siento, solo puede ser Examen, Tarea o Actividad");
            _stext = "¿Es de tipo Examen, Tarea o Actividad?";
            _text = "";
          }
        }
        else if(modCount == 6)
        {
          String aux = _text.toUpperCase();
          if(aux == "PENDIENTE" || aux == "COMPLETADA")
          {
            taskDb!.status = aux;
            _voice.speak("Se modificara el Estatus de la Tarea. Di Guardar para confirmar los cambios o Cancelar para descartarlos.");
            _stext = "Nuevo Estatus: "+taskDb!.status!;
            _text = "";
            actualProcess++;
          }
          else
          {
            _voice.speak("Solo son validas las opciones Pendiente o Completada.");
            _stext = "Solo son validas las opciones Pendiente o Completada.";
            _text = "";
          }      
        }      
      }
      //CONFIRMACION
      else if(actualProcess==4)
      {
        if(_text.toUpperCase() == "GUARDAR")
        {
          debugPrint(taskDb!.id);
          debugPrint(taskDb!.name);
          ResponseApi? responseApi = await task_provider.updateTask(taskDb!);
          if (responseApi?.success == true)
          {
            _voice.speak("Se modifico la Tarea");
          }
          else
          {
            _voice.speak("Hubo un problema al modificar la Tarea. Verifica los datos o tu conexion a Internet.");
          }
          resetIA();
        }
        else if(_text.toUpperCase() == "CANCELAR")
        {
          _voice.speak("No se ha modificado la Tarea");
          NewTask = new Task();
          resetIA();
        }
        else
        {
          _voice.speak("Solo son validas las opciones Guardar o Cancelar.");
          _stext = "Solo son validas las opciones Guardar o Cancelar.";
          _text = "";
        }
      }
    }
    //ELIMINAR UNA TAREA//
    else if(actualObj == 1 && actualType == 3)
    {
      //ELIMINAR LA TAREA POR NOMBRE//
        if(actualProcess==1)
        {
          NewTask.name = _text.toUpperCase();
          debugPrint(NewTask.name);
          List<Task?> searchTask = await task_provider.getByUserAndName(userSession.id.toString(),NewTask.name.toString());
          if(searchTask.length!=0)
          {
            taskDb = searchTask[0];
            String? subjectName = taskDb?.name.toString();
            _voice.speak("Existe la tarea, ¿Estas seguro de que quieres eliminarla?"); 
            _stext = "Se eliminara la Tarea: "+ subjectName!;
            _text = "";
            actualProcess=2;
          }
          else
          {
            _voice.speak("Lo siento, no existe esa Tarea, intenta con otra.");
            resetIA();
          }  
        }
        //CONFIRMACION
        else if(actualProcess==2)
        {
          if(_text.toUpperCase() == "SÍ"||_text.toUpperCase() == "SI")
          {
            ResponseApi? responseApi = await task_provider.deleteTask(taskDb?.id);
            if (responseApi?.success == true)
            {
              _voice.speak("Tarea eliminada exitosamente");
            }
            else
            {
              _voice.speak("Hubo un problema al Eliminar la Tarea. Verifica los datos o tu conexion a Internet.");
            }
            resetIA();
          }
          else if(_text.toUpperCase() == "NO")
          {
            _voice.speak("No se eliminara la Tarea.");
            resetIA();
          }
          else
          {
            _voice.speak("Lo siento, utiliza Si, para confirmar y No, para cancelar");
          } 
        }
    }
    //INSERTAR UNA MATERIA//
    else if(actualObj == 2 && actualType == 1)
    {
      //NOMBRE//
      if(actualProcess == 1)
      {
        NewSubject.name = _text;
        _voice.speak("¿Cual es el codigo de la materia?");
        _stext = "¿Cual es el codigo de la materia?";
        _text = "";
        actualProcess++;
      }
      //CODIGO DE LA MATERIA//
      else if(actualProcess == 2)
      {
        NewSubject.subject_code = _text;
        _voice.speak("¿Cual es el nombre del profesor?");
        _stext = "¿Cual es el nombre del profesor?";
        _text = "";
        actualProcess++;
      }
      //NOMBRE DEL PROFESOR//
      else if(actualProcess == 3)
      {
        NewSubject.professor_name = _text;
        _voice.speak("A continuación, te muestro la información de la materia, si es correcta di Guardar para registrarla o Cancelar para descartarla.");
        _stext = "El Nombre es: "+NewSubject.name.toString() + "\nEl Codigo de la Materia es: "+NewSubject.subject_code.toString()+"\nLa Fecha es: "+NewSubject.professor_name.toString();
        _text = "";
        actualProcess++;
      }
      //CONFIRMAR//
      else if(actualProcess == 4)
      {
        if(_text.toUpperCase() == "GUARDAR")
        {
          ResponseApi? responseApi = await subject_provider.create(NewSubject);
          if (responseApi?.success == true)
          {
            _voice.speak("Se guardó la Materia");
          }
          else
          {
            _voice.speak("Hubo un problema al Guardar la Materia. Verifica los datos o tu conexion a Internet.");
          }
          resetIA();
        }
        else if(_text.toUpperCase() == "CANCELAR")
        {
          _voice.speak("Se ha descartado la tarea");
          NewSubject = new Subject();
          resetIA();
        }
        else
        {
          _voice.speak("Solo son validas las opciones Guardar o Cancelar.");
          _stext = "El Nombre es: "+NewSubject.name.toString() + "\nEl Codigo de la Materia es: "+NewSubject.subject_code.toString()+"\nEl profesor es: "+NewSubject.professor_name.toString();
          _text = "";
        }
      }
    }
    //MODIFICAR UNA MATERIA//
    else if(actualObj == 2 && actualType == 2)
    {
        //MODIFICAR LA MATERIA POR NOMBRE//
        if(actualProcess==1)
        {
          NewSubject.name = _text.toUpperCase();
          debugPrint(NewSubject.name);
          List<Subject?> searchSubject = await subject_provider.getByUserNameIA(userSession.id.toString(),NewSubject.name.toString());
          if(searchSubject.length!=0)
          {
            subjectDB = searchSubject[0];
            String? subjectName = subjectDB?.name.toString();
            _voice.speak("Existe la Materia, ¿Qué deseas modificar?"); 
            _stext = "Se modificara la Materia: "+ subjectName!;
            _text = "";
            actualProcess=2;
          }
          else
          {
            _voice.speak("Lo siento, no existe esa Materia, intenta con otra.");
            resetIA();
          }  
        }
        else if(actualProcess==2)
        {
          //LEER EL CAMPO A MODIFICAR//
          String aux = _text.toUpperCase();
          //NOMBRE//
          if(aux == "NOMBRE")
          {
            _voice.speak("¿Cual es el nuevo Nombre de la Materia?");
            _stext = "¿Cual es el nuevo Nombre de la Materia?";
            _text = "";
            actualProcess++;
            modCount = 1;
          }
          //CODIGO//
          else if(aux == "CÓDIGO")
          {
            _voice.speak("¿Cual es el nuevo Código de la Materia?");
            _stext = "¿Cual es el nuevo Código de la Materia?";
            _text = "";
            actualProcess++;
            modCount = 2;
          }
          //PROFESOR//
          else if(aux == "PROFESOR")
          {
            _voice.speak("¿Cual es el nuevo Profesor de la Materia?");
            _stext = "¿Cual es el nuevo Profesor de la Materia?";
            _text = "";
            actualProcess++;
            modCount = 3;
          }
          else
          {
            _voice.speak("Lo siento, la Materia no cuenta con ese atributo. Intenta con Nombre, Código o Profesor");
          }
        }
        //ASIGNAR MODIFICACION//
        else if(actualProcess==3)
        {
          if(modCount == 1)
          {
            String? OldName = NewSubject.name;
            subjectDB!.name = _text;
            _voice.speak("Se modificara el Nombre de la materia. Di Guardar para confirmar los cambios o Cancelar para descartarlos.");
            _stext = "Antes: "+OldName!+"\nNuevo: "+subjectDB!.name!;
            _text = "";
            actualProcess++;
          }
          else if(modCount == 2)
          {
            String? OldCode = NewSubject.subject_code;
            subjectDB!.subject_code = _text;
            _voice.speak("Se modificara el Código de la materia. Di Guardar para confirmar los cambios o Cancelar para descartarlos.");
            _stext = "Antes: "+OldCode!+"\nNuevo: "+subjectDB!.subject_code!;
            _text = "";
            actualProcess++;
          }
          else if(modCount == 3)
          {
            String? OldProf = NewSubject.professor_name;
            subjectDB!.professor_name = _text;
            _voice.speak("Se modificara el Profesor de la materia. Di Guardar para confirmar los cambios o Cancelar para descartarlos.");
            _stext = "Antes: "+OldProf!+"\nNuevo: "+subjectDB!.professor_name!;
            _text = "";
            actualProcess++;
          }
        }
        //CONFIRMACION
        else if(actualProcess==4)
        {
          if(_text.toUpperCase() == "GUARDAR")
          {
            debugPrint(subjectDB!.id);
            debugPrint(subjectDB!.name);
            ResponseApi? responseApi = await subject_provider.updateSubject(subjectDB!);
            if (responseApi?.success == true)
            {
              _voice.speak("Se modifico la Materia");
            }
            else
            {
              _voice.speak("Hubo un problema al Modificar la Materia. Verifica los datos o tu conexion a Internet.");
            }
            resetIA();
          }
          else if(_text.toUpperCase() == "CANCELAR")
          {
            _voice.speak("No se ha modifico la Materia");
            NewSubject = new Subject();
            resetIA();
          }
          else
          {
            _voice.speak("Solo son validas las opciones Guardar o Cancelar.");
            _stext = "Solo son validas las opciones Guardar o Cancelar.";
            _text = "";
          }
        }
    }
    //ELIMINAR UNA MATERIA//
    else if(actualObj == 2 && actualType == 3)
    {
        //ELIMINAR LA MATERIA POR NOMBRE//
        if(actualProcess==1)
        {
          NewSubject.name = _text.toUpperCase();
          debugPrint(NewSubject.name);
          List<Subject?> searchSubject = await subject_provider.getByUserNameIA(userSession.id.toString(),NewSubject.name.toString());
          if(searchSubject.length!=0)
          {
            subjectDB = searchSubject[0];
            String? subjectName = subjectDB?.name.toString();
            _voice.speak("Existe la Materia, ¿Estas seguro de que quieres eliminarla?"); 
            _stext = "Se eliminara la Materia: "+ subjectName!;
            _text = "";
            actualProcess=2;
          }
          else
          {
            _voice.speak("Lo siento, no existe esa Materia, intenta con otra.");
            resetIA();
          }  
        }
        //CONFIRMACION
        else if(actualProcess==2)
        {
          if(_text.toUpperCase() == "SÍ" || _text.toUpperCase() == "SI")
          {
            ResponseApi? responseApi = await subject_provider.deleteSubject(subjectDB?.id);
            if (responseApi?.success == true)
            {
              _voice.speak("Materia eliminada exitosamente");
            }
            else
            {
              _voice.speak("Hubo un problema al Eliminar la Materia. Verifica los datos o tu conexion a Internet.");
            }
            resetIA();
          }
          else if(_text.toUpperCase() == "NO")
          {
            _voice.speak("No se eliminara la Materia.");
            resetIA();
          }
          else
          {
            _voice.speak("Lo siento, utiliza Si, para confirmar y No, para cancelar");
          } 
        }
    }
    //INSERTAR UNA CLASE//
    else if(actualObj == 3 && actualType == 1)
    {
      //MATERIA//
      if(actualProcess == 1)
      {
        //VALIDAR SI EL USUARIO TIENE UNA MATERIA CON ESE NOMBRE//
        String validSubject = "";
        for(int i=0; i<_text.length; i++)
        {
          if(i==0)
          {
            validSubject+=_text[i].toUpperCase();
          }
          else
          {
            validSubject+=_text[i];
          }
        }
        List<Subject?> ActualSubject = await subject_provider.getByName(validSubject, userSession.id.toString());
        if(ActualSubject.length==0)
        {
          _voice.speak("Lo siento, no tienes una materia registrada con ese nombre, intenta con otra o verifica su ortografía.");
          _stext = "¿De que Materia es la Clase?";
          _text = "";
        }
        else
        {
          NameMateria = ActualSubject[0]!.name!;
          NewClase.id_subject = ActualSubject[0]!.id;
          _voice.speak("Te pedire hora y minutos por separado. ¿Cuál es la Hora de Inicio en formato 24 horas?");
          _stext = "¿Cuál es la Hora de Inicio?";
          _text = "";
          actualProcess++;
        }
      }
      //HORA DE INICIO//
      else if(actualProcess == 2)
      {
        if(_text.toLowerCase() == "uno") _text = '01';
        else if(_text.toLowerCase() == "dos") _text = '02';
        else if(_text.toLowerCase() == "tres") _text = '03';
        else if(_text.toLowerCase() == "cuatro") _text = '04';
        else if(_text.toLowerCase() == "cinco") _text = '05';
        else if(_text.toLowerCase() == "seis") _text = '06';
        else if(_text.toLowerCase() == "siete") _text = '07';
        else if(_text.toLowerCase() == "ocho") _text = '08';
        else if(_text.toLowerCase() == "nueve") _text = '09';
        else if(_text.toLowerCase() == "cero") _text = '00';
        var num = int.tryParse(_text);
        if(_text.length > 2)
        {
          _voice.speak("Lo siento, utiliza solo numeros no mayores a 2 digitos");
          _stext = "¿Cuál es la Hora de Inicio?";
          _text = "";
        }
        else if(num == null)
        {
          _voice.speak("Lo siento, no es un numero válido");
          _stext = "¿Cuál es la Hora de Inicio?";
          _text = "";
        }
        else if(num > 23 || num < 0)
        {
          _voice.speak("Lo siento, la hora no puede ser mayor a 23 ni menor a 0");
          _stext = "¿Cuál es la Hora de Inicio?";
          _text = "";
        }
        else
        {
          Hora = _text;
          _voice.speak("¿Con cuantos minutos la Hora de Inicio?");
          _stext = "¿Con cuantos minutos la Hora de Inicio?";
          _text = "";
          actualProcess++;
        }
      }
      else if(actualProcess == 3)
      {
        if(_text.toLowerCase() == "uno") _text = '01';
        else if(_text.toLowerCase() == "dos") _text = '02';
        else if(_text.toLowerCase() == "tres") _text = '03';
        else if(_text.toLowerCase() == "cuatro") _text = '04';
        else if(_text.toLowerCase() == "cinco") _text = '05';
        else if(_text.toLowerCase() == "seis") _text = '06';
        else if(_text.toLowerCase() == "siete") _text = '07';
        else if(_text.toLowerCase() == "ocho") _text = '08';
        else if(_text.toLowerCase() == "nueve") _text = '09';
        else if(_text.toLowerCase() == "cero" || _text.toLowerCase() =="en punto") _text = '00';
        var num = int.tryParse(_text);
        if(_text.length > 2)
        {
          _voice.speak("Lo siento, utiliza solo numeros no mayores a 2 digitos");
          _stext = "¿Con cuantos minutos la Hora de Inicio?";
          _text = "";
        }
        else if(num == null)
        {
          _voice.speak("Lo siento, no es un numero válido");
          _stext = "¿Con cuantos minutos la Hora de Inicio?";
          _text = "";
        }
        else if(num > 59 || num < 0)
        {
          _voice.speak("Lo siento, los minutos no puede ser mayores a 59 ni menores a 0");
          _stext = "¿Con cuantos minutos la Hora de Inicio?";
          _text = "";
        }
        else
        {
          Minutos = _text;
          DateTime beginHour = DateTime(0001,1,1,int.parse(Hora),int.parse(Minutos));
          beginHourString = beginHour.hour.toString() + ":" + beginHour.minute.toString();
          NewClase.begin_hour = beginHour.toString();
          debugPrint(beginHour.toString());
          _voice.speak("Te pedire hora y minutos por separado. ¿Cuál es la Hora de Fin en formato 24 horas?");
          _stext = "¿Cuál es la Hora de Fin?";
          _text = "";
          actualProcess++;
        }
      }
      //HORA DE FIN//
      else if(actualProcess == 4)
      {
        if(_text.toLowerCase() == "uno") _text = '01';
        else if(_text.toLowerCase() == "dos") _text = '02';
        else if(_text.toLowerCase() == "tres") _text = '03';
        else if(_text.toLowerCase() == "cuatro") _text = '04';
        else if(_text.toLowerCase() == "cinco") _text = '05';
        else if(_text.toLowerCase() == "seis") _text = '06';
        else if(_text.toLowerCase() == "siete") _text = '07';
        else if(_text.toLowerCase() == "ocho") _text = '08';
        else if(_text.toLowerCase() == "nueve") _text = '09';
        var num = int.tryParse(_text);
        if(_text.length > 2)
        {
          _voice.speak("Lo siento, utiliza solo números no mayores a 2 digitos");
          _stext = "¿Cuál es la Hora de Fin?";
          _text = "";
        }
        else if(num == null)
        {
          _voice.speak("Lo siento, no es un número válido");
          _stext = "¿Cuál es la Hora de Fin?";
          _text = "";
        }
        else if(num > 23 || num < 0)
        {
          _voice.speak("Lo siento, la hora no puede ser mayor a 23 ni menor a 0");
          _stext = "¿Cuál es la Hora de Fin?";
          _text = "";
        }
        else
        {
          Hora = _text;
          _voice.speak("¿Con cuantos minutos la Hora de Fin?");
          _stext = "¿Con cuantos minutos la Hora de Fin?";
          _text = "";
          actualProcess++;
        }
      }
      else if(actualProcess == 5)
      {
        if(_text.toLowerCase() == "uno") _text = '01';
        else if(_text.toLowerCase() == "dos") _text = '02';
        else if(_text.toLowerCase() == "tres") _text = '03';
        else if(_text.toLowerCase() == "cuatro") _text = '04';
        else if(_text.toLowerCase() == "cinco") _text = '05';
        else if(_text.toLowerCase() == "seis") _text = '06';
        else if(_text.toLowerCase() == "siete") _text = '07';
        else if(_text.toLowerCase() == "ocho") _text = '08';
        else if(_text.toLowerCase() == "nueve") _text = '09';
        else if(_text.toLowerCase() == "cero" || _text.toLowerCase() =="en punto") _text = '00';
        var num = int.tryParse(_text);
        if(_text.length > 2)
        {
          _voice.speak("Lo siento, utiliza solo números no mayores a 2 digitos");
          _stext = "¿Con cuantos minutos la Hora de Fin?";
          _text = "";
        }
        else if(num == null)
        {
          _voice.speak("Lo siento, no es un número válido");
          _stext = "¿Con cuantos minutos la Hora de Fin?";
          _text = "";
        }
        else if(num > 59 || num < 0)
        {
          _voice.speak("Lo siento, los minutos no puede ser mayores a 59 ni menores a 0");
          _stext = "¿Con cuantos minutos la Hora de Fin?";
          _text = "";
        }
        else
        {
          Minutos = _text;
          DateTime endHour = DateTime(0001,1,1,int.parse(Hora),int.parse(Minutos));
          endHourString = endHour.hour.toString() + ":" + endHour.minute.toString();
          NewClase.end_hour = endHour.toString();
          _voice.speak("¿Qué día sera la Clase? Solo puedes mencionar un dia");
          _stext = "¿Qué día sera la Clase?";
          _text = "";
          actualProcess++;
        }
      }
      //DIA//
      else if(actualProcess == 6)
      {
        bool isDay = false;
        if(_text.toUpperCase() == "LUNES")
        {
          isDay = true;
        }
        else if(_text.toUpperCase() == "MARTES")
        {
          isDay = true;
        }
        else if(_text.toUpperCase() == "MIÉRCOLES")
        {
          isDay = true;
        }
        else if(_text.toUpperCase() == "JUEVES")
        {
          isDay = true;
        }
        else if(_text.toUpperCase() == "VIERNES")
        {
          isDay = true;
        }
        else if(_text.toUpperCase() == "SABADO")
        {
          isDay = true;
        }
        else if(_text.toUpperCase() == "DOMINGO")
        {
          isDay = true;
        }
        //PENDIENTE//
        if(isDay)
        {
          NewClase.days=_text;
          _voice.speak("A continuación, te muestro la información de la Clase, si es correcta di Guardar para registrarla o Cancelar para descartarla.");
          _stext = "La Materia es: "+NameMateria + "\nEl Dia es: "+NewClase.days.toString()+"\nLa Hora Inicio es: "+beginHourString+"\nLa Hora Fin es: "+endHourString;
          _text = "";
          actualProcess++;
        }
        else
        {
          _voice.speak("¿Qué día sera la Clase? Solo puedes mencionar un dia");
          _stext = "¿Qué día sera la Clase?";
          _text = "";
        }
      }
      //CONFIRMAR//
      else if(actualProcess == 7)
      {
        if(_text.toUpperCase() == "GUARDAR")
        {
          
          ResponseApi? responseApi = await clase_provider.create(NewClase);
          if (responseApi?.success == true)
          {
            _voice.speak("Se guardó la Clase");
          }
          else
          {
            _voice.speak("Hubo un problema al guardar la Clase. Verifica los datos o tu conexion a Internet.");
          }
          resetIA();
        }
        else if(_text.toUpperCase() == "CANCELAR")
        {
          _voice.speak("Se ha descartado la Clase");
          NewClase = new Clase();
          resetIA();
        }
        else
        {
          _voice.speak("Solo son validas las opciones Guardar o Cancelar.");
          _stext = "La Materia es: "+NameMateria + "\nEl Dia es: "+NewClase.days.toString()+"\nLa Hora Inicio es: "+beginHourString+"\nLa Hora Fin es: "+endHourString;
          _text = "";
        }
      }
    }
    //ELIMINAR UNA CLASE//
    else if(actualObj == 3 && actualType == 3)
    {
      //HORA DE INICIO//
      if(actualProcess == 1)
      {
        if(_text.toLowerCase() == "uno") _text = '01';
        else if(_text.toLowerCase() == "dos") _text = '02';
        else if(_text.toLowerCase() == "tres") _text = '03';
        else if(_text.toLowerCase() == "cuatro") _text = '04';
        else if(_text.toLowerCase() == "cinco") _text = '05';
        else if(_text.toLowerCase() == "seis") _text = '06';
        else if(_text.toLowerCase() == "siete") _text = '07';
        else if(_text.toLowerCase() == "ocho") _text = '08';
        else if(_text.toLowerCase() == "nueve") _text = '09';
        else if(_text.toLowerCase() == "cero") _text = '00';
        var num = int.tryParse(_text);
        if(_text.length > 2)
        {
          _voice.speak("Lo siento, utiliza solo numeros no mayores a 2 digitos");
          _stext = "¿Cuál es la Hora de Inicio?";
          _text = "";
        }
        else if(num == null)
        {
          _voice.speak("Lo siento, no es un numero válido");
          _stext = "¿Cuál es la Hora de Inicio?";
          _text = "";
        }
        else if(num > 23 || num < 0)
        {
          _voice.speak("Lo siento, la hora no puede ser mayor a 23 ni menor a 0");
          _stext = "¿Cuál es la Hora de Inicio?";
          _text = "";
        }
        else
        {
          Hora = _text;
          _voice.speak("¿Con cuantos minutos la Hora de Inicio?");
          _stext = "¿Con cuantos minutos la Hora de Inicio?";
          _text = "";
          actualProcess++;
        }
      }
      else if(actualProcess == 2)
      {
        if(_text.toLowerCase() == "uno") _text = '01';
        else if(_text.toLowerCase() == "dos") _text = '02';
        else if(_text.toLowerCase() == "tres") _text = '03';
        else if(_text.toLowerCase() == "cuatro") _text = '04';
        else if(_text.toLowerCase() == "cinco") _text = '05';
        else if(_text.toLowerCase() == "seis") _text = '06';
        else if(_text.toLowerCase() == "siete") _text = '07';
        else if(_text.toLowerCase() == "ocho") _text = '08';
        else if(_text.toLowerCase() == "nueve") _text = '09';
        else if(_text.toLowerCase() == "cero" || _text.toLowerCase() =="en punto") _text = '00';
        var num = int.tryParse(_text);
        if(_text.length > 2)
        {
          _voice.speak("Lo siento, utiliza solo numeros no mayores a 2 digitos");
          _stext = "¿Con cuantos minutos la Hora de Inicio?";
          _text = "";
        }
        else if(num == null)
        {
          _voice.speak("Lo siento, no es un numero válido");
          _stext = "¿Con cuantos minutos la Hora de Inicio?";
          _text = "";
        }
        else if(num > 59 || num < 0)
        {
          _voice.speak("Lo siento, la hora no puede ser mayor a 59 ni menor a 0");
          _stext = "¿Con cuantos minutos la Hora de Inicio?";
          _text = "";
        }
        else
        {
          Minutos = _text;
          DateTime beginHour = DateTime(0001,1,1,int.parse(Hora),int.parse(Minutos));
          beginHourString = beginHour.hour.toString() + ":" + beginHour.minute.toString();
          NewClase.begin_hour = beginHour.toString();
          _voice.speak("Te pedire hora y minutos por separado. ¿Cuál es la Hora de Fin en formato 24 horas?");
          _stext = "¿Cuál es la Hora de Fin?";
          _text = "";
          actualProcess++;
        }
      }
      //HORA DE FIN//
      else if(actualProcess == 3)
      {
        if(_text.toLowerCase() == "uno") _text = '01';
        else if(_text.toLowerCase() == "dos") _text = '02';
        else if(_text.toLowerCase() == "tres") _text = '03';
        else if(_text.toLowerCase() == "cuatro") _text = '04';
        else if(_text.toLowerCase() == "cinco") _text = '05';
        else if(_text.toLowerCase() == "seis") _text = '06';
        else if(_text.toLowerCase() == "siete") _text = '07';
        else if(_text.toLowerCase() == "ocho") _text = '08';
        else if(_text.toLowerCase() == "nueve") _text = '09';
        else if(_text.toLowerCase() == "cero") _text = '00';
        var num = int.tryParse(_text);
        if(_text.length > 2)
        {
          _voice.speak("Lo siento, utiliza solo números no mayores a 2 digitos");
          _stext = "¿Cuál es la Hora de Fin?";
          _text = "";
        }
        else if(num == null)
        {
          _voice.speak("Lo siento, no es un número válido");
          _stext = "¿Cuál es la Hora de Fin?";
          _text = "";
        }
        else if(num > 23 || num < 0)
        {
          _voice.speak("Lo siento, la hora no puede ser mayor a 23 ni menor a 0");
          _stext = "¿Cuál es la Hora de Fin?";
          _text = "";
        }
        else
        {
          Hora = _text;
          _voice.speak("¿Con cuantos minutos la Hora de Fin?");
          _stext = "¿Con cuantos minutos la Hora de Fin?";
          _text = "";
          actualProcess++;
        }
      }
      else if(actualProcess == 4)
      {
        if(_text.toLowerCase() == "uno") _text = '01';
        else if(_text.toLowerCase() == "dos") _text = '02';
        else if(_text.toLowerCase() == "tres") _text = '03';
        else if(_text.toLowerCase() == "cuatro") _text = '04';
        else if(_text.toLowerCase() == "cinco") _text = '05';
        else if(_text.toLowerCase() == "seis") _text = '06';
        else if(_text.toLowerCase() == "siete") _text = '07';
        else if(_text.toLowerCase() == "ocho") _text = '08';
        else if(_text.toLowerCase() == "nueve") _text = '09';
        else if(_text.toLowerCase() == "cero" || _text.toLowerCase() =="en punto") _text = '00';
        var num = int.tryParse(_text);
        if(_text.length > 2)
        {
          _voice.speak("Lo siento, utiliza solo números no mayores a 2 digitos");
          _stext = "¿Con cuantos minutos la Hora de Fin?";
          _text = "";
        }
        else if(num == null)
        {
          _voice.speak("Lo siento, no es un número válido");
          _stext = "¿Con cuantos minutos la Hora de Fin?";
          _text = "";
        }
        else if(num > 59 || num < 0)
        {
          _voice.speak("Lo siento, la hora no puede ser mayor a 59 ni menor a 0");
          _stext = "¿Con cuantos minutos la Hora de Fin?";
          _text = "";
        }
        else
        {
          Minutos = _text;
          DateTime endHour = DateTime(0001,1,1,int.parse(Hora),int.parse(Minutos));
          endHourString = endHour.hour.toString() + ":" + endHour.minute.toString();
          NewClase.end_hour = endHour.toString();
          _voice.speak("¿Qué día sera la Clase? Solo puedes mencionar un dia");
          _stext = "¿Qué día sera la Clase?";
          _text = "";
          actualProcess++;
        }
      }
      //DIA//
      else if(actualProcess == 5)
      {
        bool isDay = false;
        if(_text.toUpperCase() == "LUNES")
        {
          isDay = true;
        }
        else if(_text.toUpperCase() == "MARTES")
        {
          isDay = true;
        }
        else if(_text.toUpperCase() == "MIÉRCOLES")
        {
          isDay = true;
        }
        else if(_text.toUpperCase() == "JUEVES")
        {
          isDay = true;
        }
        else if(_text.toUpperCase() == "VIERNES")
        {
          isDay = true;
        }
        else if(_text.toUpperCase() == "SABADO")
        {
          isDay = true;
        }
        else if(_text.toUpperCase() == "DOMINGO")
        {
          isDay = true;
        }
        //PENDIENTE//
        if(isDay)
        {
          NewClase.days=_text;
          _voice.speak("A continuación, te muestro la información de la Clase, si es correcta di Confirmar para eliminarla o Cancelar.");
          _stext = "La Materia es: "+NameMateria + "\nEl Dia es: "+NewClase.days.toString()+"\nLa Hora Inicio es: "+NewClase.begin_hour.toString()+"\nLa Hora Fin es: "+NewClase.end_hour.toString();
          _text = "";
          actualProcess++;
        }
        else
        {
          _voice.speak("¿Qué día sera la Clase? Solo puedes mencionar un dia");
          _stext = "¿Qué día sera la Clase?";
          _text = "";
        }
      }
      //CONFIRMAR//
      else if(actualProcess == 6)
      {
        if(_text.toUpperCase() == "CONFIRMAR")
        {
          //MODIFICAR//
          Clase? claseSearched = await clase_provider.getByIdDaysHours(userSession.id.toString(),NewClase);
          if (claseSearched != null)
          {
            ResponseApi? responseApi  = await clase_provider.deleteClase(claseSearched.id);    
            if (responseApi?.success == true)
            {
              _voice.speak("Clase eliminada exitosamente");
            }
            else
            {
              _voice.speak("Hubo un problema al Eliminar la Clase. Verifica los datos o tu conexion a Internet.");
            }
            resetIA();     
          }
          else
          {
            _voice.speak("No existe una Clase ese dia, a esas Horas y de esa Materia.");
          }
          resetIA();
        }
        else if(_text.toUpperCase() == "CANCELAR")
        {
          _voice.speak("Se ha descartado la Clase");
          NewClase = new Clase();
          resetIA();
        }
        else
        {
          _voice.speak("Solo son validas las opciones Guardar o Cancelar.");
          _stext = "La Materia es: "+NameMateria + "\nEl Dia es: "+NewClase.days.toString()+"\nLa Hora Inicio es: "+beginHourString+"\nLa Hora Fin es: "+endHourString;
          _text = "";
        }
      }
    }
  }

  //FUNCION PARA GENERAR UNA FECHA SEGUN EL TEXTO INGRESADO//
  bool createDate(List<String> words)
  {
    String day = "", month = "";
    for(var i=0; i<words.length; i++)
    {
      if(int.tryParse(words[i])!=null)
      {
        day = int.tryParse(words[i]).toString();
      }
      else if(words[i]=="PRIMERO") { day = "01"; }
      else if(words[i]=="ENERO") { month = "01"; }
      else if(words[i]=="FEBRERO") { month = "02"; }
      else if(words[i]=="MARZO") { month = "03"; }
      else if(words[i]=="ABRIL") { month = "04"; }
      else if(words[i]=="MAYO") { month = "05"; }
      else if(words[i]=="JUNIO") { month = "06"; }
      else if(words[i]=="JULIO") { month = "07"; }
      else if(words[i]=="AGOSTO") { month = "08"; }
      else if(words[i]=="SEPTIEMBRE") { month = "09"; }
      else if(words[i]=="OCTUBRE") { month = "10"; }
      else if(words[i]=="NOVIEMBRE") { month = "11"; }
      else if(words[i]=="DICIEMBRE") { month = "12"; }      
    }
    if(day == "" || month == "")
    {
      return false;
    }
    else
    {
      var now = new DateTime.now();
      DateTime fecha = new DateTime(now.year,int.parse(month),int.parse(day));
      String NewDate = day + "-"+month+"-"+now.year.toString()+" 00:00:00";
      NewTask.deliveryDate= fecha.toString();
      debugPrint(fecha.toString());
      return true;
    }
  }
  // ---------------------------------------------------------------------------------------- //
}