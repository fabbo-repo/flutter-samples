import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
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
      home: MyHomePage(title: 'WS Tester'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({super.key, required this.title});

  final String title;
  final TextEditingController textController = TextEditingController();
  final ScrollController scrollController = new ScrollController();

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final dio = Dio(BaseOptions(
    baseUrl: "http://localhost:8080",
    validateStatus: (status) =>
        status != HttpStatus.unauthorized &&
        status != HttpStatus.internalServerError,
  ));

  String? userFrom = "2aeaabd9-d4fa-4507-b373-df73236c31d7";
  String? userTo = "2aeaabd9-d4fa-4507-b373-df73236c31d7";
  String? queue;
  final String token = "token";
  StompClient? stompClient;
  List<String> messages = [];
  bool isConnected = false;

  Future<void> _connect() async {
    stompClient = StompClient(
      config: StompConfig(
          url: 'ws://localhost:15674/ws',
          onConnect: (stompFrame) async {
            debugPrint("Connected ${stompFrame.headers}");
            if (stompFrame.binaryBody != null) {
              debugPrint(String.fromCharCodes(stompFrame.binaryBody!));
            }
            subscribe();
            setState(() {
              isConnected = true;
            });
          },
          stompConnectHeaders: {"login": "jwt", "passcode": token},
          onWebSocketError: (e) {
            debugPrint("[WS ERROR] $e");
            setState(() {
              stompClient?.deactivate();
              isConnected = false;
            });
          },
          onStompError: (stompFrame) {
            debugPrint(
                "[STOMP ERROR] ${stompFrame.command} --- ${stompFrame.body}");
            setState(() {
              stompClient?.deactivate();
              isConnected = false;
            });
          },
          onDisconnect: (f) => debugPrint("Disconnected")),
    );
    stompClient!.activate();
  }

  void _disconnect() {
    setState(() {
      stompClient!.deactivate();
      isConnected = false;
    });
  }

  Future subscribe() async {
    final response = await dio.get("/chat-queue",
        queryParameters: {"fromUser": userFrom, "toUser": userTo});
    debugPrint("Response: " + response.data.toString());
    queue = response.data["queue"]!;
    stompClient!.subscribe(
        destination: queue!,
        headers: {
          "auto_delete": "true",
          "durable": "false",
          "exclusive": "false"
        },
        callback: (stompFrame) {
          debugPrint("Sub response command: ${stompFrame.command}");
          debugPrint("Sub response headers: ${stompFrame.headers}");
          debugPrint("Sub response body: ${stompFrame.body}");
          if (stompFrame.body != null) {
            final chatMessage = json.decode(stompFrame.body!);
            setState(() {
              messages.add(chatMessage["text"]);
            });
          }
          debugPrint("Sub response binary body: ${stompFrame.binaryBody}");
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
              SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height - 250,
                child: SingleChildScrollView(
                  controller: widget.scrollController,
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
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    constraints:
                        const BoxConstraints(maxHeight: 50, maxWidth: 400),
                    child: TextField(
                      controller: widget.textController,
                      onChanged: (message) async {},
                      maxLines: 1,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Message',
                      ),
                    ),
                  ),
                  ElevatedButton(
                      onPressed: () async {
                        await dio.post("/send-msg", data: {
                          "fromUser": userFrom,
                          "toUser": userTo,
                          "text": widget.textController.text
                        });
                        widget.textController.text = "";
                        setState(() {
                          widget.scrollController.jumpTo(
                              widget.scrollController.position.maxScrollExtent +
                                  40);
                        });
                      },
                      child: const Icon(Icons.send))
                ],
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
