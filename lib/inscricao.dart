class Inscricao {
  String _nome;
  bool _inscrito;

  Inscricao(Map<String, dynamic> parsedJson) {
    this._nome = parsedJson["Participante"];
    this._inscrito = parsedJson["Inscrito"];
  }

  String get nome => this._nome;
  bool get inscrito => this._inscrito;
}