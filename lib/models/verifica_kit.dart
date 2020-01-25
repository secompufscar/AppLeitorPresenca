class VerificaKit {
  String _nome;
  bool _temKit;
  List _camisetas;

  VerificaKit(Map<String, dynamic> parsedJson) {
    this._nome = parsedJson["Participante"];
    this._temKit = parsedJson["Kit"];
    this._camisetas = parsedJson["Camiseta"];
  }

  String get nome => this._nome;

  bool get temKit => this._temKit;

  List get camisetas => this._camisetas;
}
