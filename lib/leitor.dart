import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:qr_mobile_vision/qr_camera.dart';
import 'package:audioplayers/audio_cache.dart';
import 'package:secomp_leitor/api_service.dart';
import 'package:secomp_leitor/inscricao.dart';
import 'package:secomp_leitor/presenca.dart';
import 'package:secomp_leitor/verifica_kit.dart';

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

  void _lerPresenca(bool force) async {
    Presenca presenca;
    try {
      presenca = await api.lerPresenca(qr, widget.idAtividade, force);
    } catch (_) {
      setState(() {
        display = Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(Icons.error_outline, color: Colors.red),
            Text("Ocorreu algum erro.\nTente novamente."),
          ],
        );
      });
      return;
    }

    if (presenca.status == 'JA_LIDO') {
      print("ja lido");
      setState(() {
        display = Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(Icons.check_circle_outline, color: Colors.yellow),
            Text("${presenca.nome} \n Já lido"),
          ],
        );
      });
    } else {
      player.play(audioPath);

      setState(() {
        display = Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(Icons.check_circle_outline, color: Colors.green),
            Text("${presenca.nome} \n OK!"),
          ],
        );
      });
    }
  }

  Widget _buildDialog(
      BuildContext context, Inscricao inscricao, VerificaKit kit) {
    String stringKit = kit.temKit ? " " : "SEM KIT!!!";
    return AlertDialog(
      title: Text("Forçar presença?"),
      content: Text(
          "${inscricao.nome} não está inscrito nessa atividade.\n$stringKit\nVocê deseja forçar a presença?"),
      actions: <Widget>[
        MaterialButton(
          child: Text("Sim"),
          onPressed: () {
            _lerPresenca(true);
            Navigator.pop(context);
          },
        ),
        MaterialButton(
            child: Text("Não"),
            onPressed: () {
              setState(() {
                display = Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Icon(Icons.error_outline, color: Colors.red),
                    Text("${inscricao.nome} \n Não autorizado"),
                  ],
                );
              });
              Navigator.pop(context);
            })
      ],
    );
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

        try {
          final VerificaKit kit = await api.verificaKit(code);
          final Inscricao inscricao =
              await api.verificarInscricao(code, widget.idAtividade);
          if (widget.title.contains("Palestra:")) {
            _lerPresenca(false);
          } else if (widget.title.contains("Coffee-Break")) {
            if(!kit.temKit) {
              showDialog(
                context: context,
                builder: (context) => _buildDialog(context, inscricao, kit));
            } else {
              _lerPresenca(false);
            }
          } 
          else if (!inscricao.inscrito) {
            showDialog(
                context: context,
                builder: (context) => _buildDialog(context, inscricao, kit));
          } else {
            _lerPresenca(false);
          }
        } catch (e) {
          setState(() {
            display = Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Icon(Icons.error_outline, color: Colors.red),
                Text("Ocorreu algum erro.\nTente novamente."),
              ],
            );
          });
        }

        Future.delayed(Duration(seconds: 2), () {
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
              child: (qr != null) ? display : Container(),
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
