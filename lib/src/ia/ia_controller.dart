import 'package:flutter/material.dart';
import 'package:agenda_app/src/ia/text_to_speech.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class IA_Controller
{
  //ATRIBUTOS//
  stt.SpeechToText _speech = stt.SpeechToText(); //ENCARGADO DE ESCUCHAR//
  bool _isListening = false; //BOOLEANO QUE DETERMIAN EL ESTADO DE LA VOZ//
  String _text = "¿En que puedo ayudarte?"; //MENSAJE DE BIENVENIDA//
  double _confidence = 2.0; //CONFIABILIDAD//
  VoiceRosalind _voice = new VoiceRosalind();

  //CONSTRUCTOR//
  IA_Controller() {
    _speech = stt.SpeechToText();
    _voice = new VoiceRosalind();
  }

  //FUNCION PARA HABLAR//
  void speakRosalind(String TextSpeak) {
    _voice.speak(TextSpeak);
    _text = TextSpeak;
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