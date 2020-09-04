import 'dart:io';

import 'package:band_names/src/models/band.dart';
import 'package:band_names/src/providers/socket.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:provider/provider.dart';

class HomeView extends StatefulWidget {
  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  List<Band> bands = [];

  @override
  void initState() {
    final socketService = Provider.of<SocketService>(context,listen: false);
    socketService.socket.on('active-bands',_handleActiveBands);

    super.initState();
  }

  _handleActiveBands(dynamic payload){
    this.bands = (payload as List)
        .map((band) => Band.fromMap(band))
        .toList();
    setState(() {});
  }

  @override
  void dispose() {
    final socketService = Provider.of<SocketService>(context,listen: false);
    socketService.socket.off('active-bands');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final socketService = Provider.of<SocketService>(context);

    return Scaffold(
        appBar: AppBar(
          elevation: 1,
          title: Text(
            "Band Names",
            style: TextStyle(color: Colors.black87),
          ),
          backgroundColor: Colors.white,
          actions: <Widget>[
            Container(
              margin: EdgeInsets.only( right: 10),
              child : socketService.status ==  ServerStatus.Online
               ? Icon(Icons.check_circle, color: Colors.blue[300],)
               : Icon(Icons.offline_bolt, color: Colors.red[300],)
              ,
            )
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              _showGraph(),
              ListView.builder(
                  shrinkWrap: true,
                  itemCount: bands.length,
                  itemBuilder: (context, index) => _bandTile(bands[index])
              ),
            ],
          ),
        ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        elevation: 1,
        onPressed: addNewBand,
      ),
    );
  }

  Widget _bandTile(Band band) {
    final socketService = Provider.of<SocketService>(context,listen: false);

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
      onDismissed: (direction) => socketService.socket.emit('delete-band',{ 'id': band.id } ),
      child: ListTile(
        leading: CircleAvatar(
          child: Text(band.name.substring(0, 2)),
          backgroundColor: Colors.blue[100],
        ),
        title: Text(band.name),
        trailing: Text('${band.votes}', style: TextStyle(fontSize: 20),),
        onTap:() => socketService.socket.emit('vote-band',{ 'id': band.id } ),
      ),
    );
  }

  addNewBand(){
    final  textController = new TextEditingController();

    if(!Platform.isAndroid){
      return showDialog(
          context: context,
          builder: (_) => AlertDialog(
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
            )

      );
    }

    showCupertinoDialog(
        context: context,
        builder: (_) =>  CupertinoAlertDialog(
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
          )
    );

    
  }

  void addBandToList(String name){
    final socketService = Provider.of<SocketService>(context,listen: false);

    if(name.length > 1){
      socketService.socket.emit('new-band',{ 'name': name });
    }
    else
      {

      }

    Navigator.pop(context);
  }


  Widget _showGraph() {
    Map<String, double> dataMap = new Map();
    this.bands.forEach((band) {
      dataMap.putIfAbsent(band.name, () => band.votes.toDouble());
    });

    final List<Color> colorList = [
      Colors.blue[200],
      Colors.pink[200],
      Colors.red[200],
      Colors.purple[200],
      Colors.green[200],
      Colors.yellow[200],
      Colors.amber[200],
      Colors.orange[200],
    ];

    return Container(
      width: double.infinity,
      height: 200.0,
      child:
      this.bands.isNotEmpty ? PieChart(
        dataMap: dataMap,
        animationDuration: Duration(milliseconds: 800),
        chartLegendSpacing: 32.0,
        chartRadius: MediaQuery.of(context).size.width / 2.7,
        showChartValuesInPercentage: true,
        showChartValues: true,
        showChartValuesOutside: false,
        chartValueBackgroundColor: Colors.grey[200],
        colorList: colorList,
        showLegends: true,
        legendPosition: LegendPosition.right,
        decimalPlaces: 0,
        showChartValueLabel: true,
        initialAngle: 0,
        chartValueStyle: defaultChartValueStyle.copyWith(
          color: Colors.blueGrey[900].withOpacity(0.9),
        ),
        chartType: ChartType.ring,
      )
          : Center(child: Text("No hay datos..."))
    );
  }
}
