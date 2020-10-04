import 'package:flutter/foundation.dart';
import 'package:web_socket_channel/io.dart';
import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import 'widgets/my_button.dart';

//testing forks

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final title = 'WebSocket Demo';
    return MaterialApp(
      title: title,
      debugShowCheckedModeBanner: false,
      home: MyHomePage(
        title: title,
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final String title;

  MyHomePage({Key key, @required this.title}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController _controller = TextEditingController();
  final TextEditingController _urlController = TextEditingController();
  WebSocketChannel channel;
  bool connectionStatus = false;
  List<String> messageList = [];
  bool clearLog = false;

  @override
  void initState() {
    super.initState();
    _controller.text = '';
    _urlController.text = 'wss://echo.websocket.org';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Colors.orange,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Text(
                "Location:",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Container(
                  width: 220,
                  height: 30,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    shape: BoxShape.rectangle,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(top: 5.0, left: 1.0),
                    child: TextField(
                      controller: _urlController,
                      textAlign: TextAlign.left,
                    ),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  MyButton(
                    'Connect',
                    onPressed: () => _connectToChannel(),
                    backgroundColor: Colors.orange[700],
                  ),
                  SizedBox(
                    width: 3,
                  ),
                  MyButton(
                    'Disconnect',
                    onPressed: () => _disconnectChannel(),
                    backgroundColor: Colors.orange[700],
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "Log:",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Container(
                      height: 140,
                      width: 220,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        shape: BoxShape.rectangle,
                      ),
                      child: StreamBuilder(
                        stream: channel?.stream,
                        builder: (context, snapshot) {
                          if (snapshot.hasData &&
                              connectionStatus == true &&
                              snapshot.connectionState ==
                                  ConnectionState.active) {
                            messageList.add(snapshot.data);
                          }
                          return getMessageList();
                        },
                      ),
                    ),
                  ),
                  messageList.length != 0
                      ? MyButton(
                          'Clear Log',
                          onPressed: () {
                            setState(() {
                              messageList.clear();
                              getMessageList();
                              _controller.text = '';
                            });
                          },
                          backgroundColor: Colors.orange[700],
                        )
                      : MyButton(
                          'Clear Log',
                          disableColor: Colors.grey[300],
                        ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                "Message:",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Container(
                  width: 220,
                  height: 30,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    shape: BoxShape.rectangle,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(top: 5.0, left: 1.0),
                    child: Form(
                      child: TextFormField(
                        controller: _controller,
                        textAlign: TextAlign.left,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              connectionStatus
                  ? MyButton(
                      'Send',
                      onPressed: () => connectionStatus ? _sendMessage() : {},
                      backgroundColor: Colors.orange[700],
                    )
                  : MyButton(
                      'Send',
                      disableColor: Colors.grey[200],
                    ),
            ],
          ),
        ),
      ),
    );
  }

  void _sendMessage() {
    if (_controller.text.isNotEmpty && connectionStatus == true) {
      channel.sink.add(_controller.text);
    }
  }

  void _connectToChannel() {
    channel = IOWebSocketChannel.connect(_urlController.text);
    setState(() {
      connectionStatus = true;
      _controller.text = '';
    });
    messageList.add("Connected");
  }

  void _disconnectChannel() {
    channel.sink.close();
    setState(() {
      connectionStatus = false;
      _controller.text = '';
    });
    messageList.add("Disconnected");
  }

  ListView getMessageList() {
    List<Widget> listWidget = [];
    for (String message in messageList) {
      listWidget.add(ListTile(
        title: Container(
          child: Text(
            message,
            style: TextStyle(fontSize: 15),
          ),
        ),
      ));
    }
    return ListView(children: listWidget);
  }
}
