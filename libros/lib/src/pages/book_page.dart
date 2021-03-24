import 'package:flutter/material.dart';
import 'package:page_turn/page_turn.dart';

//TODO: DISEÑAR LA GESTIÓN DEL BUFFER DE TEXTO
//TODO: IMPLEMENTAR BUFFER CON COLA CIRCULAR
//TODO: GESTIONAR LOS OFFSETS(CURRENTOFFSET, INITBUFFEROFFSET).
class BookPage extends StatefulWidget {
  @override
  _BookPageState createState() => _BookPageState();
}
class _BookPageState extends State<BookPage> {
  @override
  int currentOffset; //Offset actual
  final _page = GlobalKey<PageTurnState>();



  Widget build(BuildContext context) {
    //Argumentos recibidos al invocar BookPage
    Map data = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      body: SafeArea(
        child: Center(child: Text(data["book"].title))
      ) ,
    );
  }
}
