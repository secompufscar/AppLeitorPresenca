import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:qr_mobile_vision/qr_camera.dart';
import 'package:audioplayers/audio_cache.dart';
import 'package:secomp_leitor/api_service.dart';
import 'package:secomp_leitor/presenca.dart';

class Leitor extends StatefulWidget {
  @override
  _LeitorState createState() => _LeitorState();
  final String title;
  final String idAtividade;

  Leitor({this.title, this.idAtividade})
      : assert(title != null, idAtividade != null);
}

class _LeitorState extends State<Leitor> {
  String qr;
  bool camState = false;
  bool open = true;
  String display;

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  static AudioCache player = new AudioCache();
  final audioPath = "futuristic.mp3";

  final ApiService api = ApiService();

  @override
  initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    void lerPresenca(String code) async {
      if (open) {
        setState(() {
          qr = code;
        });
        open = false;

        final Presenca presenca =
            await api.lerPresenca(code, widget.idAtividade);

        if (presenca.status == Status.lido) {
          setState(() {
            display = "Código já lido";
          });
        } else {
          player.play(audioPath);

          setState(() {
            display = presenca.nome;
          });
        }
      }
    }

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(24),
              child: (qr != null)
                  ? Text(display, style: TextStyle(fontSize: 16))
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
                            qrCodeCallback: (code) => lerPresenca(code)),
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
