import 'dart:isolate';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:isolate_demo/photo.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: [SystemUiOverlay.bottom]);
    super.initState();
  }

  void createIsolate() async {
    //main isolate
    ReceivePort receivePort = ReceivePort();
    await Isolate.spawn(heavyTask, receivePort.sendPort);
    receivePort.listen((message) {
      //print(message);
      if (message[1] is SendPort) {
        if (message[0] == 50) {
          message[1].send('gia tri 50');
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff2D2F31),
      body: const Center(child: RotateImage()),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          createIsolate();
        },
      ),
    );
  }
}

Future<void> heavyTask(SendPort sendPort) async {
  // new isolate
  ReceivePort port = ReceivePort();
  port.listen((message) {
    if (kDebugMode) {
      print(message);
    }
  });
  for (var i = 0; i < 100; i++) {                         
    sendPort.send([i, port.sendPort]);
  }
}
