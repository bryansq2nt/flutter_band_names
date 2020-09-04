import 'package:band_names/src/providers/socket.dart';
import 'package:band_names/src/views/home.dart';
import 'package:band_names/src/views/status.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => SocketService(),
        ),
      ],
      child: MaterialApp(
        title: 'App name',
        debugShowCheckedModeBanner: false,
        initialRoute: 'home',
        routes: {
          'home': (_) => HomeView(),
          'status': (_) => StatusView()
        },
      ),
    );
  }
}
