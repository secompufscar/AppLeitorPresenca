import 'package:flutter/material.dart';
import 'package:secomp_leitor/api_service.dart';
import 'package:secomp_leitor/atividades.dart';
import 'package:secomp_leitor/leitor.dart';

class HomeScreen extends StatelessWidget {
  ApiService api = ApiService();

  final atividades = <Atividade>[
    Atividade(
        titulo: "Palestra: Segurança digital",
        local: "Auditório Bento Prado",
        horario: DateTime.now()),
    Atividade(
        titulo: "Minicurso: Desenvolvimento de Apps iOS",
        local: "IFSP",
        horario: DateTime.now()),
    Atividade(
        titulo: "Coffe Break",
        local: "Anexo Auditório Bento Prado",
        horario: DateTime.now()),
    Atividade(
        titulo: "Mesa Redonda: Diversidade na computação",
        local: "Auditório Bento Prado",
        horario: DateTime.now()),
  ];

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
        ),
        body: FutureBuilder(
          future: api.getAtividades(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              Atividades atividades = snapshot.data;
              return ListView.builder(
                itemCount: atividades.count,
                itemBuilder: (context, index) => buildListItem(context, atividades.results[index]),
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
