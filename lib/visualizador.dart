import 'package:flutter/material.dart';
import 'package:qr_mobile_vision/qr_camera.dart';
import 'package:secomp_leitor/api_service.dart';
import 'package:secomp_leitor/inscricao.dart';
import 'package:secomp_leitor/verifica_kit.dart';

class Visualizador extends StatefulWidget {
  @override
  _VisualizadorState createState() => _VisualizadorState();
}

class _VisualizadorState extends State<Visualizador> {
String qr;
  bool camState = false;
  bool open = true;
  Widget display = Container();

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  final ApiService api = ApiService();

  @override
  initState() {
    super.initState();
  }



  @override
  Widget build(BuildContext context) {
    void lerInfo(String code) async {
      if (open) {
        setState(() {
          qr = code;
          open = false;
          display = Text("Enviando..");
        });

        try {
          final VerificaKit kit = await api.verificaKit(code);
          String temKit = kit.temKit ? "SIM": "NÃO";
          List camisetas = kit.camisetas;
          List<Text> textCamisetas = []; 
          camisetas.forEach((camiseta) => textCamisetas.add(Text(camiseta)));
          setState(() {
            display = Column(
              children: <Widget>[
                Text(kit.nome + "\n Kit: " + temKit),
                ...textCamisetas,
              ],

            );
          });
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
        title: Text("Visualizar participante"),
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
                            qrCodeCallback: (code) => lerInfo(code)),
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