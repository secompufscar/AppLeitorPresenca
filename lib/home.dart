import 'package:flutter/material.dart';
import 'package:secomp_leitor/atividades.dart';
import 'package:secomp_leitor/leitor.dart';

class HomeScreen extends StatelessWidget {
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

  Widget buildListItem(BuildContext context, int index) {
    final horario = atividades[index].horario;
    final titulo = atividades[index].titulo;

    return ListTile(
      title: Text(titulo),
      subtitle: Text(atividades[index].local),
      trailing: Text("${horario.hour}:${horario.minute}"),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Leitor(
              title: titulo,
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
      body: ListView.builder(
        itemCount: atividades.length,
        itemBuilder: (context, index) => buildListItem(context, index),
      ),
    );
  }
}
