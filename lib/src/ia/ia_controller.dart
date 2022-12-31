import 'package:agenda_app/src/models/ia_task.dart';
import 'package:agenda_app/src/providers/ia_taskProvider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:agenda_app/src/ia/text_to_speech.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:get/get.dart';

class IA_Controller
{
  //ATRIBUTOS//
  stt.SpeechToText _speech = stt.SpeechToText(); //ENCARGADO DE ESCUCHAR//
  bool _isListening = false; //BOOLEANO QUE DETERMIAN EL ESTADO DE LA VOZ//
  String _text = "¿En que puedo ayudarte?"; //MENSAJE DE BIENVENIDA//
  double _confidence = 1.0; //CONFIABILIDAD//
  VoiceRosalind _voice = new VoiceRosalind();
  final ia_taskProvider ia_provider =  Get.put(ia_taskProvider());

  //CONSTRUCTOR//
  IA_Controller() {
    _speech = stt.SpeechToText();
    _voice = new VoiceRosalind();
  }

  //FUNCION PARA HABLAR//
  void speakRosalind(String TextSpeak) async {
    debugPrint("El texto es: "+TextSpeak);
    _text = TextSpeak;
    //VALIDAR PALABRAS ANTISONANTES//
    if(badwords())
    {
      List<String> words = [];
      _voice.speak("Gracias por no decir palabras antisonantes");
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
      debugPrint("La cantidad de palabras es: "+words.length.toString());
      debugPrint("PALABRAS: "+words.toString());
      List<ia_task?> bd_list = await ia_provider.getAll();
      List<ia_task?> bd_exist = await ia_provider.getByWord("INSERTAR");
      debugPrint(bd_exist.length.toString());
      debugPrint(bd_exist[0]?.word.toString());
    }
    else
    {
      _voice.speak("Lo siento, no estan permitidas palabras antisonantes. Intenta con otro comando");
      _text = "¿En que puedo ayudarte?";
    }
  } 

  //ANALIZAR TEXTO//
  bool badwords() 
  {
    int contador = 0, sizeText = _text.length;
    //CONTAR CUANTOS * EXISTEN//
    for (var i = 0; i < sizeText; i++)
    {
      if(_text[i]=='*')
      {
        contador+=1;
      }
    }
    //SI ES MAYOR QUE UNO ES UNA PALABRA ANTISONANTE//
    if(contador > 0)
    {
      return false;
    }
    //SINO ES VALIDA//
    else
    {
      return true;
    }
  }

  //FUNCION PARA DEJAR DE ESCUCHAR//
  void stopListening() {
    _speech.stop();
  }

  //GETTERS//
  String getText()
  {
    return _text;
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

  void setListening(bool NewListening)
  {
    _isListening = NewListening;
  }

  void setConfidence(double NewConfidence)
  {
    _confidence=NewConfidence;
  }

}