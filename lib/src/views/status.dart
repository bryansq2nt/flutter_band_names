import 'package:band_names/src/providers/socket.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class StatusView extends StatelessWidget {
  TextEditingController _controller = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    final socketService = Provider.of<SocketService>(context);

    return Scaffold(

      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Row(
          children: <Widget>[
            Text(
              "Server status: ",
              style: TextStyle(color: Colors.black87),
            ),
            Icon(
              Icons.offline_bolt,
              color: socketService.status == ServerStatus.Online
                  ? Colors.green
                  : Colors.red,
            )
          ],
        ),
      ),
      body: Center(
        child: Text("Server...")
      ),
    );
  }


}
