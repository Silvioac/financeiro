import 'package:financeiro/config.dart';
import 'package:financeiro/helpers/menu_lateral.dart';
import 'package:financeiro/sobre.dart';
import 'package:flutter/material.dart';

import 'activities/home.dart';

class Inicio extends StatelessWidget {

  final _pgController = PageController();
  @override
  Widget build(BuildContext context) {
    return PageView(
      controller: _pgController,
      children: <Widget>[
        Scaffold(
           appBar: AppBar(
        title: Text("Finance Control"),
        backgroundColor: Color(0xff4285F4),
      ),
          body: Home(),
          drawer: MenuLateral(_pgController),
        ),
        Scaffold(
          body: Config(),
          drawer: MenuLateral(_pgController),
        ),
        Scaffold(
          body: Sobre(),
          drawer: MenuLateral(_pgController),
        )
      ],
      
    );
  }
}