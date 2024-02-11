import 'dart:io';

import 'package:flutter/material.dart';
import 'package:stomp_dart_client/stomp.dart';
import 'package:stomp_dart_client/stomp_config.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String? token;
  StompClient? stompClient;
  List<String> messages = [];

  void _connect() {
    setState(() {
      stompClient = StompClient(
        config: StompConfig(
            url: 'ws://localhost:61613/ws',
            onConnect: (stompFrame) => debugPrint(
                "Connected ${stompFrame.headers}\n${stompFrame.body}"),
            //stompConnectHeaders: {'Authorization': 'Bearer $token'},
            //webSocketConnectHeaders: {'Authorization': 'Bearer $token'},
            webSocketConnectHeaders: {"login": "user", "passcode": "password"},
            stompConnectHeaders: {"login": "user", "passcode": "password"},
            onWebSocketError: (e) {
              debugPrint("[WS ERROR] $e");
              stompClient?.deactivate();
            },
            onStompError: (d) => debugPrint("[STOMP ERROR] $d"),
            onDisconnect: (f) => debugPrint("Disconnected")),
      );
      stompClient!.activate();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                constraints:
                    const BoxConstraints(maxHeight: 100, maxWidth: 400),
                child: TextField(
                  onChanged: (token) => setState(() {
                    this.token = token;
                  }),
                  maxLines: 5,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Token',
                  ),
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height - 250,
                child: SingleChildScrollView(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: messages
                          .map<Widget>((message) => Text(
                                message,
                                style:
                                    Theme.of(context).textTheme.headlineMedium,
                              ))
                          .toList()),
                ),
              ),
              Container(
                constraints: const BoxConstraints(maxHeight: 50, maxWidth: 400),
                child: TextField(
                  onChanged: (token) => setState(() {
                    this.token = token;
                  }),
                  maxLines: 1,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Message',
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: token == null ? null : _connect,
        tooltip: 'Connect',
        child: const Icon(Icons.connect_without_contact),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
