import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

class VoiceRosalind {
  //ATRIBUTOS//
  final FlutterTts flutterTts = FlutterTts();

  //RESPONDER//
  void speak(String Text) async {
    await flutterTts.setLanguage("es-US");
    await flutterTts.setPitch(1.1);
    await flutterTts.speak(Text);
  }
}
