class Atividade {
  final String titulo;
  final String tipo;
  final String local;
  final DateTime horario;
  final int id;

  Atividade({this.titulo, this.tipo, this.local, this.horario, this.id})
      : assert(titulo != null, local != null);
}

class Atividades {
  List<Atividade> _results;
  int _count;

  Atividades(Map<String, dynamic> json) {
    this._count = json['count'];
    List<Atividade> temp = [];
    for (var a in json['results']) {
      temp.add(
        Atividade(
            titulo: a['titulo'],
            local: a['local'],
            horario: DateTime.now(),
            tipo: a['tipo'],
            id: a['id']),
      );
    }
    this._results = temp;
  }

  List<Atividade> get results => _results;
  int get count => _count;
}
