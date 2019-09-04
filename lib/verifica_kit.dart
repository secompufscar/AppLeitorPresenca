class VerificaKit {
  String _nome;
  bool _temKit;

  VerificaKit(Map<String, dynamic> parsedJson) {
    this._nome = parsedJson["Participante"];
    this._temKit = parsedJson["Kit"];
  }

  String get nome => this._nome;
  bool get temKit => this._temKit;
}