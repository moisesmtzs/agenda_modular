// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

class CardContainer extends StatelessWidget {

  final Widget child;

  const CardContainer({
    required this.child
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric( horizontal: 35 ),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(20),
        decoration: _createCard(),
        child: child,
      ),
    );
  }

  BoxDecoration _createCard() => BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadiusDirectional.circular(8),
    boxShadow: const [
      BoxShadow(
        color: Colors.black12,
        blurRadius: 15,
        offset: Offset(0,5)
      )
    ]
  );
}