import 'dart:io';

import 'package:band_names/src/models/band.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomeView extends StatefulWidget {
  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  List<Band> bands = [
    new Band(id: '1', name: "Linkin Park", votes: 55),
    new Band(id: '2', name: "Three Days Grace", votes: 80),
    new Band(id: '3', name: "Metallica", votes: 30),
    new Band(id: '4', name: "Queen", votes: 125),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 1,
          title: Text(
            "Band Names",
            style: TextStyle(color: Colors.black87),
          ),
          backgroundColor: Colors.white,
        ),
        body: ListView.builder(
          itemCount: bands.length,
          itemBuilder: (context, index) => _bandTile(bands[index])
        ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        elevation: 1,
        onPressed: addNewBand,
      ),
    );
  }

  Widget _bandTile(Band band) {
    return Dismissible(
      key: Key(band.id),
      direction: DismissDirection.startToEnd,
      background: Container(
        padding: EdgeInsets.only(left: 10.0),
        color: Colors.red,
        child: Align(
          alignment: Alignment.centerLeft,
          child: Icon(Icons.delete, color: Colors.white,),
        ),
      ),
      onDismissed: (direction){
        print("Banda: ${band.name} eliminada correctamente.");
      },
      child: ListTile(
        leading: CircleAvatar(
          child: Text(band.name.substring(0, 2)),
          backgroundColor: Colors.blue[100],
        ),
        title: Text(band.name),
        trailing: Text('${band.votes}', style: TextStyle(fontSize: 20),),
        onTap:(){},
      ),
    );
  }

  addNewBand(){
    final  textController = new TextEditingController();

    if(!Platform.isAndroid){
      return showDialog(
          context: context,
          builder: (context){
            return AlertDialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5.0))),
              title: Text("New Band Name"),
              content: TextField(
                controller: textController,
              ),
              actions: <Widget>[

                MaterialButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text("Cancelar"),
                ),
                MaterialButton(
                  elevation: 5,
                  textColor: Colors.blue,
                  onPressed: () => addBandToList(textController.text),
                  child: Text("Agregar"),
                ),
              ],
            );
          }
      );
    }

    showCupertinoDialog(
        context: context,
        builder: (_){
          return CupertinoAlertDialog(
            title: Text("Dialogo"),
            content: CupertinoTextField(
              controller: textController,
            ),
            actions: <Widget>[

              CupertinoDialogAction(
                isDestructiveAction: true,
                child: Text("Cacelar"),
                onPressed: () => Navigator.pop(context),
              ),
              CupertinoDialogAction(
                isDefaultAction: true,
                child: Text("Agregar"),
                onPressed: () => addBandToList(textController.text),
              ),
            ],
          );
        }
    );

    
  }

  void addBandToList(String name){
    if(name.length > 1){
      this.bands.add(new Band(id: DateTime.now().millisecondsSinceEpoch.toString(),name: name , votes: DateTime.now().millisecondsSinceEpoch));
      setState(() {});
    }
    else
      {

      }

    Navigator.pop(context);
  }
}
