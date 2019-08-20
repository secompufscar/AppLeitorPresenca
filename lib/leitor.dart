import 'dart:async';

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
  Widget display = Container();

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
          open = false;
          display = Text("Enviando..");
        });

        final Presenca presenca =
            await api.lerPresenca('1', '1');

        if (presenca.status == 'JA_LIDO') {
          print("ja lido");
          setState(() {
            display = Text("${presenca.nome} \n Já lido");
          });
        } else {
          player.play(audioPath);

          setState(() {
            display = Text(presenca.nome);
          });
        }

        Timer(Duration(seconds: 2), () {
          setState(() {
            open = true;
          });
        });
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
                  ? display
                  : Container(),
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
