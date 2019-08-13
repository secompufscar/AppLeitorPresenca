class Presenca {
  String _id;
  String _nome;

  Presenca(Map<String,dynamic> parsedJson, String id) {
    this._id = id;
    this._nome = parsedJson['participante'];
  }

  String get id => _id;
  String get nome => _nome;
}