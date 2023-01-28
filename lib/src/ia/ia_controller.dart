import 'dart:ffi';
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

class IA_Controller
{
  // ------------------------------------ATRIBUTOS--------------------------------------------- //

  stt.SpeechToText _speech = stt.SpeechToText(); //ENCARGADO DE ESCUCHAR//
  bool _isListening = false; //BOOLEANO QUE DETERMIAN EL ESTADO DE LA VOZ//
  double _confidence = 1.0; //CONFIABILIDAD//

  String _text = "¿En que puedo ayudarte?"; //MENSAJE A ANALIZAR//
  String _stext = "¿En que puedo ayudarte?"; //MENSAJE AL USUARIO//
  
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
  

  // ---------------------------------------------------------------------------------------- //

  //CONSTRUCTOR//
  IA_Controller() {
    _speech = stt.SpeechToText();
    _voice = new VoiceRosalind();
  }

  // ----------------------------------METODO DE BUSQUEDA------------------------------------ //

  //ANALIZAR SI EL COMANDO ES VALIDO//
  void isCommand(String textSpeak) async 
  {
    //SI SE ESPERA UNA RESPUESTA//  
    if(waitAnswer != -1)
    {
      searchNewCommand();
    }
    else
    {
      debugPrint(_stext);

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
        //BUSCAMOS EL COMANDO EN LA BD//
        String searchCommand = _stext.toUpperCase();
        List<ia_task?> bd_exist = await ia_provider.getByCommand(searchCommand);
        debugPrint("SIZE: "+bd_exist.length.toString());
        //SI EL COMANDO EXISTE//
        if(bd_exist.length>0)
        {
          _voice.speak("el comando ya existe en la Base de Datos");
          debugPrint(bd_exist[0]!.type.toString()+" | "+bd_exist[0]!.obj.toString());
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
                //SI HAY SIMILITUD, AUMENTA EL CONTADOR DE SIMILITUDES//
                if(contains == true)
                {
                  numSimil++;
                }
              }
            }
            //SI LAS SIMILITUDES SON MAYORES O IGUAL AL MAYOR NUMERO DE SIMILITUDES, ALMACENAMOS EL COMANDO//
            if(numSimil>=highSim)
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
            newTask.command = _stext.toUpperCase();
            newTask.obj = posCommands[0]!.task!.obj;
            newTask.type = posCommands[0]!.task!.type;
            ia_provider.create(newTask);
            debugPrint(newTask.toJson().toString());
          }
          //SI HAY MAS DE UNA SIMILITUD
          else if(posCommands.length > 1)
          {
            isNewCommand = true;
            newCommand = _stext.toUpperCase();
            waitAnswer=0;
            //PRIMER DESCARTE//
            searchNewCommand();

          }
          debugPrint("COMANDOS CREADOS FINAL: "+posCommands.length.toString());  
          debugPrint("COINCIDENCIAS FINALES: "+posCommands[0]!.simil.toString());
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
      debugPrint(_stext);
      //SI LA RESPUESTA ES NO//
      if(_stext.toUpperCase() == "NO")
      {
        if(posCommands.length>0)
        {
          descartList.add(posCommands[0]);
          posCommands.removeAt(0);
          waitAnswer=0;
          //ELIMINAR IGUALES AL DESCARTADO//
          for (int p = 0; p < posCommands.length; p++)
          {
            for (int d = 0; d < descartList.length; d++)
            {
              if(posCommands[p]!.task!.type == descartList[p]!.task!.type)
              {
                if(posCommands[d]!.task!.obj == descartList[d]!.task!.obj)
                {
                  posCommands.removeAt(p);
                }
              }
            }
          }
          searchNewCommand();
        }
        else
        {
          _voice.speak("Lo siento, el comando es muy ambiguo");
          resetIA();
        }
      }
      //SI LA RESPUESTA ES SI//
      if(_stext.toUpperCase() == "SÍ")
      {
        //INSERTAR TAREA//
        if(waitAnswer==1)
        {
          _voice.speak("Se insertara una nueva Tarea");
          //CREAMOS UNA IA TASK//
          ia_task newTask = new ia_task();
          newTask.command = newCommand.toUpperCase();
          newTask.obj = posCommands[0]!.task!.obj;
          newTask.type = posCommands[0]!.task!.type;
          ia_provider.create(newTask);
          debugPrint(newTask.toJson().toString());
        }
      }
    }
    else
    {
      if(posCommands.length>0)
      {
        //INSERTAR//
        if(posCommands[0]!.task!.type == "1")
        {
          //INSERTAR TAREA - waitAnswer: 1//
          if(posCommands[0]!.task!.obj == "1")
          {
            _voice.speak("¿Quieres insertar una Tarea?");
            _stext = "¿Quieres insertar una Tarea?";
            waitAnswer = 1;
          }
          //INSERTAR MATERIA - waitAnswer: 2//
          else if(posCommands[0]!.task!.obj == "2")
          {
            _voice.speak("¿Quieres insertar una Tarea?");
            _stext = "¿Quieres insertar una Tarea?";
            waitAnswer = 2;
          }
          //INSERTAR MATERIA - waitAnswer: 3//
          else if(posCommands[0]!.task!.obj == "3")
          {
            _voice.speak("¿Quieres insertar una Clase?");
            _stext = "¿Quieres insertar una Clase?";
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
            _voice.speak("¿Quieres modificar una Tarea?");
            _stext = "¿Quieres modificar una Tarea?";
            waitAnswer = 5;
          }
          //MODIFICAR MATERIA - waitAnswer: 6//
          else if(posCommands[0]!.task!.obj == "3")
          {
            _voice.speak("¿Quieres modificar una Clase?");
            _stext = "¿Quieres modificar una Clase?";
            waitAnswer = 6;
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
          //MODIFICAR TAREA - waitAnswer: 7//
          if(posCommands[0]!.task!.obj == "1")
          {
            _voice.speak("¿Quieres eliminar una Tarea?");
            _stext = "¿Quieres eliminar una Tarea?";
            waitAnswer = 7;
          }
          //MODIFICAR MATERIA - waitAnswer: 8//
          else if(posCommands[0]!.task!.obj == "2")
          {
            _voice.speak("¿Quieres eliminar una Tarea?");
            _stext = "¿Quieres eliminar una Tarea?";
            waitAnswer = 8;
          }
          //MODIFICAR MATERIA - waitAnswer: 9//
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
    _text = "¿En que puedo ayudarte?"; 
    _stext = "¿En que puedo ayudarte?";
    commandsBD = [];
    posCommands = []; 

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
    _text = NewText;
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

}