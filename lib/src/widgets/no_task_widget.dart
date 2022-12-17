import 'package:flutter/material.dart';

class NoTaskWidget extends StatelessWidget {

  String? text;

  NoTaskWidget( { Key? key, this.text } ) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 80, vertical: 90),
      margin: const EdgeInsets.only(bottom: 100),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset('assets/img/no_tasks.png', height: 100),
          const SizedBox(height: 10),
          Text(text ?? '', style: const TextStyle( fontSize: 18, fontWeight: FontWeight.w600 ))
        ],
      ),

    );
  }
}