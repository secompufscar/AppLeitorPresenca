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
      trailing: Text(horario != null ? TimeOfDay.fromDateTime(horario).format(context) : "horário não definido"),
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
    return DefaultTabController(
      length: 6,
      child: Scaffold(
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
            bottom: TabBar(
              tabs: <Widget>[
                Tab(text: "seg"),
                Tab(text: "ter"),
                Tab(text: "qua"),
                Tab(text: "qui"),
                Tab(text: "sex"),
                Tab(text: "?"),
              ],
            ),
          ),
          body: FutureBuilder(
            future: api.getAtividades(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                List<Atividade> lista = snapshot.data.results;
                List<Atividade> segunda = lista
                    .where((atv) => atv.horario != null && atv.horario.day == 9)
                    .toList();
                List<Atividade> terca = lista
                    .where(
                        (atv) => atv.horario != null && atv.horario.day == 10)
                    .toList();
                List<Atividade> quarta = lista
                    .where(
                        (atv) => atv.horario != null && atv.horario.day == 11)
                    .toList();
                List<Atividade> quinta = lista
                    .where(
                        (atv) => atv.horario != null && atv.horario.day == 12)
                    .toList();
                List<Atividade> sexta = lista
                    .where(
                        (atv) => atv.horario != null && atv.horario.day == 13)
                    .toList();
              

                segunda.sort((a, b) => a.horario.compareTo(b.horario));
                terca.sort((a, b) => a.horario.compareTo(b.horario));
                quarta.sort((a, b) => a.horario.compareTo(b.horario));
                quinta.sort((a, b) => a.horario.compareTo(b.horario));
                sexta.sort((a, b) => a.horario.compareTo(b.horario));

                List<Atividade> outros = lista.where((atv) => atv.horario == null || atv.horario.day < 9).toList();

                return TabBarView(
                  children: <Widget>[
                    ListView.builder(
                      itemCount: segunda.length,
                      itemBuilder: (context, index) =>
                          buildListItem(context, segunda[index]),
                    ),
                      ListView.builder(
                      itemCount: terca.length,
                      itemBuilder: (context, index) =>
                          buildListItem(context, terca[index]),
                    ),
                      ListView.builder(
                      itemCount: quarta.length,
                      itemBuilder: (context, index) =>
                          buildListItem(context, quarta[index]),
                    ),
                      ListView.builder(
                      itemCount: quinta.length,
                      itemBuilder: (context, index) =>
                          buildListItem(context, quinta[index]),
                    ),
                      ListView.builder(
                      itemCount: sexta.length,
                      itemBuilder: (context, index) =>
                          buildListItem(context, sexta[index]),
                    ),
                    ListView.builder(
                      itemCount: outros.length,
                      itemBuilder: (context, index) =>
                          buildListItem(context, outros[index]),
                    ),
                  ],
                );
              } else if (snapshot.hasError) {
                return Center(child: Text("Ocorreu algum erro"));
              } else {
                return Center(child: CircularProgressIndicator());
              }
            },
          )),
    );
  }
}
