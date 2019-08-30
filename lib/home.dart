import 'package:flutter/material.dart';
import 'package:secomp_leitor/api_service.dart';
import 'package:secomp_leitor/atividades.dart';
import 'package:secomp_leitor/leitor.dart';
import 'package:secomp_leitor/post_noticias.dart';

class HomeScreen extends StatelessWidget {
  final ApiService api = ApiService();

  Widget buildListItem(BuildContext context, Atividade atividade) {
    final horario = atividade.horario;
    final titulo = atividade.tipo + ": " + atividade.titulo;

    return ListTile(
      title: Text(titulo),
      subtitle: Text(atividade.local),
      trailing: Text("${horario.hour}:${horario.minute}"),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Leitor(
              title: titulo,
              idAtividade: atividade.id.toString(),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Atividades"),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.add_comment),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PostNoticias()),
                );
              },
            ),
          ],
        ),
        body: FutureBuilder(
          future: api.getAtividades(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              Atividades atividades = snapshot.data;
              return ListView.builder(
                itemCount: atividades.count,
                itemBuilder: (context, index) =>
                    buildListItem(context, atividades.results[index]),
              );
            } else if (snapshot.hasError) {
              return Center(child: Text("Ocorreu algum erro"));
            } else {
              return Center(child: CircularProgressIndicator());
            }
          },
        ));
  }
}
