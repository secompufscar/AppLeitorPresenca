class Presenca {
  String _id;
  String _nome;
  String _status;

  Presenca(Map<String, dynamic> parsedJson, String id) {
    this._id = id;
    this._nome = parsedJson['Participante'];
    this._status = parsedJson['Status'];
  }

  String get id => _id;

  String get nome => _nome;

  String get status => _status;
}
