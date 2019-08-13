class Atividade {
  final String titulo;
  final String local;
  final DateTime horario;

  Atividade({this.titulo, this.local, this.horario})
      : assert(titulo != null, local != null);
}
