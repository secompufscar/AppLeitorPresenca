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

  static DateTime getDate(String date) {
    print(date);
    return DateTime.parse(
        "2019-09-${date.substring(5, 7)} ${date.substring(17, 19)}:${date.substring(20, 22)}:00");
  }

  Atividades(List json) {
    this._count = json.length;
    List<Atividade> temp = [];
    for (var a in json) {
      temp.add(
        Atividade(
            titulo: a['titulo'] ?? 'sem título',
            local: a['local'] ?? 'sem local',
            horario: a['inicio'] != null ? getDate(a['inicio']) : null,
            tipo: a['tipo'] ?? ' ',
            id: a['id']),
      );
    }
    this._results = temp;
  }

  List<Atividade> get results => _results;

  int get count => _count;
}
