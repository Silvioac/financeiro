import 'package:flutter/material.dart';

class MenuLateral extends StatelessWidget {


  PageController _pgController;

  MenuLateral(this._pgController);

    @override
    Widget build (BuildContext context){

      Widget _bkDrawer() => Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.blueAccent,
              Colors.white
            ]
          )
        ),
      );

      return Drawer(
        child: Stack(
          children: <Widget>[
            _bkDrawer(),
            ListView(
              children: <Widget>[
                DrawerHeader(
              padding: EdgeInsets.only(top: 20.0, left: 20.0),
                  child: Text(
                    "Menu Financeiro",
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold
                      ),
                    ),
                ),
                Divider(),
                ListTile(
                  title: Text("Home"),
                  onTap: (){
                    _pgController.jumpToPage(0);
                  },
                ),ListTile(
                  title: Text("Configurações"),
                  onTap: (){
                    _pgController.jumpToPage(1);
                  },
                ),ListTile(
                  title: Text("Sobre"),
                  onTap: (){
                    _pgController.jumpToPage(2);
                  },
                ),
              ],
            )
          ],
        )
      );
  }
}