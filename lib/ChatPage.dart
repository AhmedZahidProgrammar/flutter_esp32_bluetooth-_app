import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

class ChatPage extends StatefulWidget {
  final BluetoothDevice server;

  const ChatPage({this.server});

  @override
  _ChatPage createState() => new _ChatPage();
}

class _Message {
  int whom;
  String text;

  _Message(this.whom, this.text);
}

class _ChatPage extends State<ChatPage> {
  static final clientID = 0;
  BluetoothConnection connection;

  List<_Message> messages = List<_Message>();
  String _messageBuffer = '';

  final TextEditingController textEditingController =
      new TextEditingController();
  final ScrollController listScrollController = new ScrollController();

  bool isConnecting = true;
  bool get isConnected => connection != null && connection.isConnected;

  bool isDisconnecting = false;

  @override
  void initState() {
    super.initState();

    BluetoothConnection.toAddress(widget.server.address).then((_connection) {
      print('Connected to the device');
      connection = _connection;
      setState(() {
        isConnecting = false;
        isDisconnecting = false;
      });

      connection.input.listen(_onDataReceived).onDone(() {
        // Example: Detect which side closed the connection
        // There should be `isDisconnecting` flag to show are we are (locally)
        // in middle of disconnecting process, should be set before calling
        // `dispose`, `finish` or `close`, which all causes to disconnect.
        // If we except the disconnection, `onDone` should be fired as result.
        // If we didn't except this (no flag set), it means closing by remote.
        if (isDisconnecting) {
          print('Disconnecting locally!');
        } else {
          print('Disconnected remotely!');
        }
        if (this.mounted) {
          setState(() {});
        }
      });
    }).catchError((error) {
      print('Cannot connect, exception occured');
      print(error);
    });
  }

  @override
  void dispose() {
    // Avoid memory leak (`setState` after dispose) and disconnect
    if (isConnected) {
      isDisconnecting = true;
      connection.dispose();
      connection = null;
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: (isConnecting
              ? Text('Connecting chat to ' + widget.server.name + '...')
              : isConnected
                  ? Text('Live chat with ' + widget.server.name)
                  : Text('Chat log with ' + widget.server.name))),
      body:Column(
        children: [
          Divider(),
          Container(
            margin: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment:MainAxisAlignment.center,
              children: [
                Text('Switch Board'),
                Row(
                  children: <Widget>[
                    Expanded(child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: ElevatedButton(
                        child: Text('ON'),
                        style: ButtonStyle(
                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18.0),
                                  side: BorderSide(color: Colors.white)
                              )
                          ),
                        ),
                        onPressed: (){
                          if(isConnected){
                            _sendMessage("1");
                            _sendMessage("1");
                          }
                        },
                      ),
                    ),
                    ),
                    Expanded(child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: ElevatedButton(
                        child: Text('OFF'),
                        style: ButtonStyle(
                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18.0),
                                  side: BorderSide(color: Colors.white)
                              )
                          ),
                        ),
                        onPressed: (){
                          if(isConnected){
                            _sendMessage("1");
                            _sendMessage("0");
                          }
                        },
                      ),
                    ),
                    ),
                  ],
                ),

              ],
            ),
          ),
          Divider(),
          Container(
            margin: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment:MainAxisAlignment.center,
              children: [
                Text('WIFI'),
                Row(
                  children: <Widget>[
                    Expanded(child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: ElevatedButton(
                        child: Text('ON'),
                        style: ButtonStyle(
                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18.0),
                                side: BorderSide(color: Colors.white),
                              )
                          ),
                        ),
                        onPressed: (){
                          if(isConnected){
                            _sendMessage("2");
                            _sendMessage("1");
                          }
                          },
                      ),
                    ),
                    ),
                    Expanded(child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: ElevatedButton(
                        child: Text('OFF'),
                        style: ButtonStyle(
                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18.0),
                                  side: BorderSide(color: Colors.white)
                              )
                          ),
                        ),
                        onPressed: (){
                          if(isConnected){
                            _sendMessage("2");
                            _sendMessage("0");
                          }
                        },
                      ),
                    ),
                    ),
                  ],
                ),

              ],
            ),
          ),
          Divider(),
          Container(
            margin: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment:MainAxisAlignment.center,
              children: [
                Text('LED BULB'),
                Row(
                  children: <Widget>[
                    Expanded(child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: ElevatedButton(
                        child: Text('ON'),
                        style: ButtonStyle(
                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18.0),
                                  side: BorderSide(color: Colors.white)
                              )
                          ),
                        ),
                        onPressed: (){
                          if(isConnected){
                            _sendMessage("3");
                            _sendMessage("1");
                          }
                        },
                      ),
                    ),
                    ),
                    Expanded(child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: ElevatedButton(
                        child: Text('OFF'),
                        style: ButtonStyle(
                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18.0),
                                  side: BorderSide(color: Colors.white)
                              )
                          ),
                        ),
                        onPressed: (){
                          if(isConnected){
                            _sendMessage("3");
                            _sendMessage("0");
                          }
                        },
                      ),
                    ),
                    ),
                  ],
                ),

              ],
            ),
          ),
          Divider(),
          Container(
            margin: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment:MainAxisAlignment.center,
              children: [
                Text('FAN'),
                Row(
                  children: <Widget>[
                    Expanded(child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: ElevatedButton(
                        child: Text('ON'),
                        style: ButtonStyle(
                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18.0),
                                  side: BorderSide(color: Colors.white)
                              )
                          ),
                        ),
                        onPressed: (){
                          if(isConnected){
                            _sendMessage("4");
                            _sendMessage("1");
                          }
                        },
                      ),
                    ),
                    ),
                    Expanded(child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: ElevatedButton(
                        child: Text('OFF'),
                        style: ButtonStyle(
                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18.0),
                                  side: BorderSide(color: Colors.white)
                              )
                          ),
                        ),
                        onPressed: (){
                          if(isConnected){
                            _sendMessage("4");
                            _sendMessage("0");
                          }
                        },
                      ),
                    ),
                    ),
                  ],
                ),

              ],
            ),
          ),
          Divider(),
        ],
      )
    );
  }

  void _onDataReceived(Uint8List data) {
    // Allocate buffer for parsed data
    int backspacesCounter = 0;
    data.forEach((byte) {
      if (byte == 8 || byte == 127) {
        backspacesCounter++;
      }
    });
    Uint8List buffer = Uint8List(data.length - backspacesCounter);
    int bufferIndex = buffer.length;

    // Apply backspace control character
    backspacesCounter = 0;
    for (int i = data.length - 1; i >= 0; i--) {
      if (data[i] == 8 || data[i] == 127) {
        backspacesCounter++;
      } else {
        if (backspacesCounter > 0) {
          backspacesCounter--;
        } else {
          buffer[--bufferIndex] = data[i];
        }
      }
    }

    // Create message if there is new line character
    String dataString = String.fromCharCodes(buffer);
    int index = buffer.indexOf(13);
    if (~index != 0) {
      setState(() {
        messages.add(
          _Message(
            1,
            backspacesCounter > 0
                ? _messageBuffer.substring(
                    0, _messageBuffer.length - backspacesCounter)
                : _messageBuffer + dataString.substring(0, index),
          ),
        );
        _messageBuffer = dataString.substring(index);
      });
    } else {
      _messageBuffer = (backspacesCounter > 0
          ? _messageBuffer.substring(
              0, _messageBuffer.length - backspacesCounter)
          : _messageBuffer + dataString);
    }
  }

  void _sendMessage(String text) async {
    text = text.trim();
    textEditingController.clear();

    if (text.length > 0) {
      try {
        connection.output.add(utf8.encode(text + "\r\n"));
        await connection.output.allSent;

        setState(() {
          messages.add(_Message(clientID, text));
        });

        Future.delayed(Duration(milliseconds: 333)).then((_) {
          listScrollController.animateTo(
              listScrollController.position.maxScrollExtent,
              duration: Duration(milliseconds: 333),
              curve: Curves.easeOut);
        });
      } catch (e) {
        // Ignore error, but notify state
        setState(() {});
      }
    }
  }
}
