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
      home: const MyHomePage(title: 'WS Tester'),
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
  bool isConnected = false;

  void _connect() {
    setState(() {
      stompClient = StompClient(
        config: StompConfig(
            url: 'ws://localhost:15674/ws',
            onConnect: (stompFrame) {
              debugPrint("Connected ${stompFrame.headers}\n${stompFrame.body}");
              setState(() {
                isConnected = true;
              });
            },
            webSocketConnectHeaders: {
              "login": "client",
              "passcode": "password"
            },
            stompConnectHeaders: {"login": "client", "passcode": "password"},
            onWebSocketError: (e) {
              debugPrint("[WS ERROR] $e");
              stompClient?.deactivate();
            },
            onStompError: (e) {
              debugPrint("[STOMP ERROR] $e");
              stompClient?.deactivate();
            },
            onDisconnect: (f) => debugPrint("Disconnected")),
      );
      stompClient!.activate();
    });
  }

  void _disconnect() {
    setState(() {
      stompClient!.deactivate();
      isConnected = false;
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
      floatingActionButton: isConnected
          ? FloatingActionButton(
              onPressed: _disconnect,
              tooltip: 'Disconnect',
              child: const Icon(Icons.cancel_outlined),
            )
          : FloatingActionButton(
              onPressed: _connect,
              tooltip: 'Connect',
              child: const Icon(Icons.connect_without_contact),
            ),
    );
  }
}
