import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:qr_mobile_vision/qr_camera.dart';
import 'package:audioplayers/audio_cache.dart';

class Leitor extends StatefulWidget {
  @override
  _LeitorState createState() => _LeitorState();
  final String title;

  Leitor({this.title}) : assert(title != null);
}

class _LeitorState extends State<Leitor> {
  String qr;
  bool camState = false;
  bool open = true;

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  static AudioCache player = new AudioCache();
  final audioPath = "futuristic.mp3";

  @override
  initState() {
    super.initState();
  }

  List lidos = <String>[];

  Widget buildListItem(BuildContext context, int index) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Text(lidos[index]),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: ListView(
        children: <Widget>[
          Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(24),
                  child: (qr != null)
                      ? Text(qr, style: TextStyle(fontSize: 16))
                      : Text(""),
                ),
                camState
                    ? Center(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: SizedBox(
                            width: 400.0,
                            height: 400.0,
                            child: QrCamera(
                              notStartedBuilder: (context) =>
                                  Center(child: Text("Ligando camera...")),
                              onError: (context, error) => Text(
                                error.toString(),
                                style: TextStyle(color: Colors.red),
                              ),
                              qrCodeCallback: (code) {
                                if (open) {
                                  if (lidos.contains(code)) {
                                    setState(() {
                                      qr = "Código já lido!";
                                    });
                                  } else {
                                    player.play(audioPath);
                                    setState(() {
                                      qr = code;
                                    });
                                    open = false;
                                    lidos.add(code);
                                    Timer(
                                      Duration(seconds: 2),
                                      () => setState(() {
                                        open = true;
                                      }),
                                    );
                                  }
                                }
                              },
                            ),
                          ),
                        ),
                      )
                    : Center(
                        child: Text(
                          "Camera desligada",
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
              ],
            ),
          ),
          ListView.builder(
            shrinkWrap: true,
            physics: ClampingScrollPhysics(),
            itemBuilder: (context, index) => buildListItem(context, index),
            itemCount: lidos.length,
            reverse: true,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.camera_alt),
          onPressed: () {
            setState(() {
              camState = !camState;
            });
          }),
    );
  }
}
